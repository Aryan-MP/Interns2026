# chatvenv\Scripts\activate
import os
import asyncio
import chainlit as cl
from dotenv import load_dotenv

# Azure Blob Storage
from azure.storage.blob import BlobServiceClient

# LangChain
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_openai import AzureOpenAIEmbeddings, AzureChatOpenAI
from langchain_community.vectorstores.azuresearch import AzureSearch
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.messages import HumanMessage, AIMessage
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnableLambda, RunnablePassthrough
from langchain_core.documents import Document

load_dotenv()

# ── Config ────────────────────────────────────────────────────────────────────
AZURE_ENDPOINT       = os.getenv("AZURE_OPENAI_ENDPOINT")
AZURE_API_KEY        = os.getenv("AZURE_OPENAI_API_KEY")
AZURE_API_VERSION    = os.getenv("AZURE_OPENAI_API_VERSION")
CHAT_DEPLOYMENT      = os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME")
EMBEDDING_DEPLOYMENT = os.getenv("AZURE_EMBEDDING_DEPLOYMENT_NAME", "text-embedding-ada-002")

STORAGE_ACCOUNT_NAME = os.getenv("AZURE_STORAGE_ACCOUNT_NAME")
STORAGE_ACCOUNT_KEY  = os.getenv("AZURE_STORAGE_ACCOUNT_KEY")
CONTAINER_NAME       = os.getenv("AZURE_STORAGE_CONTAINER_NAME")

SEARCH_ENDPOINT      = os.getenv("AZURE_SEARCH_ENDPOINT")
SEARCH_API_KEY       = os.getenv("AZURE_SEARCH_API_KEY")
SEARCH_INDEX_NAME    = os.getenv("AZURE_SEARCH_INDEX_NAME", "worldcup-index")


# ── Step 1: Load .txt files from Azure Blob Storage ───────────────────────────
def load_blobs() -> list[Document]:
    account_url = f"https://{STORAGE_ACCOUNT_NAME}.blob.core.windows.net"
    container_client = BlobServiceClient(
        account_url=account_url,
        credential=STORAGE_ACCOUNT_KEY
    ).get_container_client(CONTAINER_NAME)

    documents = []
    txt_blobs = [b for b in container_client.list_blobs() if b.name.endswith(".txt")]
    print(f"Found {len(txt_blobs)} .txt file(s) in '{CONTAINER_NAME}'")

    for blob in txt_blobs:
        content = container_client.download_blob(blob.name, encoding="utf-8").readall()
        documents.append(Document(page_content=content, metadata={"source": blob.name}))
        print(f"  + Loaded: {blob.name}")

    return documents


# ── Step 2: Build embeddings + Azure AI Search vector store ───────────────────
def build_vector_store() -> AzureSearch:
    embeddings = AzureOpenAIEmbeddings(
        azure_deployment=EMBEDDING_DEPLOYMENT,
        azure_endpoint=AZURE_ENDPOINT,
        api_key=AZURE_API_KEY,
        api_version=AZURE_API_VERSION,
    )

    # AzureSearch auto-creates the index if it doesn't exist
    # If index already exists, it connects to it — no re-indexing
    vector_store = AzureSearch(
        azure_search_endpoint=SEARCH_ENDPOINT,
        azure_search_key=SEARCH_API_KEY,
        index_name=SEARCH_INDEX_NAME,
        embedding_function=embeddings.embed_query,
    )

    # Check if index is empty — only index docs on first run
    existing = vector_store.client.get_document_count()
    if existing == 0:
        print("Index is empty — loading and indexing documents...")
        documents = load_blobs()
        chunks = RecursiveCharacterTextSplitter(
            chunk_size=1500, chunk_overlap=200
        ).split_documents(documents)
        vector_store.add_documents(chunks)
        print(f"  ✓ Indexed {len(chunks)} chunks into '{SEARCH_INDEX_NAME}'")
    else:
        print(f"Index '{SEARCH_INDEX_NAME}' already has {existing} docs — skipping re-index")

    return vector_store


# ── Step 3: Build the RAG chain ───────────────────────────────────────────────
def initialize_rag():
    vector_store = build_vector_store()

    retriever = vector_store.as_retriever(
        k=3
    )

    llm = AzureChatOpenAI(
        azure_deployment=CHAT_DEPLOYMENT,
        azure_endpoint=AZURE_ENDPOINT,
        api_key=AZURE_API_KEY,
        api_version=AZURE_API_VERSION,
        temperature=0.7,
        streaming=True,
    )

    prompt = ChatPromptTemplate.from_messages([
        ("system",
         "You are a passionate FIFA World Cup analyst with deep knowledge of the "
         "2014, 2018, and 2022 tournaments. Answer using the context below. "
         "Be specific with stats and numbers. If the question is outside these "
         "three tournaments, politely say so.\n\nContext:\n{context}"),
        MessagesPlaceholder("chat_history"),
        ("human", "{input}"),
    ])

    def format_docs(docs):
        return "\n\n".join(doc.page_content for doc in docs)

    # LCEL pipe: input → retrieve → format → prompt → LLM → string
    get_input = RunnableLambda(lambda x: x["input"])
    get_history = RunnableLambda(lambda x: x["chat_history"])

    chain = (
        {
            "context": get_input |retriever | format_docs,
            "input": get_input,
            "chat_history": get_history,
        }
        | prompt
        | llm
        | StrOutputParser()
    )

    return retriever, chain


# ── Startup ───────────────────────────────────────────────────────────────────
print("Initializing RAG pipeline...")
RETRIEVER, RAG_CHAIN = initialize_rag()
print("Ready.\n")


# ── Chainlit ──────────────────────────────────────────────────────────────────
@cl.on_chat_start
async def on_chat_start():
    cl.user_session.set("chat_history", [])
    await cl.Message(
        content=(
            "**World Cup Analyst ready!**\n\n"
            "Ask me anything about the **2014**, **2018**, or **2022** FIFA World Cups."
        )
    ).send()


@cl.on_message
async def on_message(message: cl.Message):
    chat_history = cl.user_session.get("chat_history")

    response_msg = cl.Message(content="")
    await response_msg.send()

    source_docs = await asyncio.to_thread(
        RETRIEVER.invoke, message.content
    )

    answer = await asyncio.to_thread(
        RAG_CHAIN.invoke,
        {"input": message.content, "chat_history": chat_history}
    )

    for token in answer:
        await response_msg.stream_token(token)

    # Show which files were used
    if source_docs:
        seen, labels = set(), []
        for doc in source_docs:
            src = doc.metadata.get("source", "unknown")
            if src not in seen:
                seen.add(src)
                labels.append(f"`{src}`")
        await response_msg.stream_token(f"\n\n---\n Sources: {', '.join(labels)}*")

    await response_msg.update()

    # Update history
    chat_history.append(HumanMessage(content=message.content))
    chat_history.append(AIMessage(content=answer))
    cl.user_session.set("chat_history", chat_history)