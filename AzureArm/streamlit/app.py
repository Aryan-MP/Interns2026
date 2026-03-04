import os
import streamlit as st
from dotenv import load_dotenv
from openai import AzureOpenAI
from azure.search.documents import SearchClient
from azure.search.documents.models import VectorizedQuery
from azure.core.credentials import AzureKeyCredential

# -----------------------------------
# Load Environment Variables
# -----------------------------------
load_dotenv()

# -----------------------------------
# Azure OpenAI Client
# -----------------------------------
openai_client = AzureOpenAI(
    api_key=os.getenv("AZURE_OPENAI_KEY"),
    azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT"),
    api_version="2024-02-15-preview"
)

# -----------------------------------
# Azure AI Search Client
# -----------------------------------
search_client = SearchClient(
    endpoint=os.getenv("AZURE_SEARCH_ENDPOINT"),
    index_name=os.getenv("AZURE_SEARCH_INDEX"),
    credential=AzureKeyCredential(os.getenv("AZURE_SEARCH_KEY"))
)

# -----------------------------------
# Create Embedding
# -----------------------------------
def get_embedding(text: str):
    response = openai_client.embeddings.create(
        model=os.getenv("EMBEDDING_DEPLOYMENT"),
        input=text
    )
    return response.data[0].embedding


# -----------------------------------
# Vector Retrieval
# -----------------------------------
def retrieve_documents(query: str, k: int = 5):
    query_vector = get_embedding(query)

    vector_query = VectorizedQuery(
        vector=query_vector,
        k_nearest_neighbors=k,
        fields="text_vector"   # <-- MUST match your index vector field name
    )

    results = search_client.search(      #using that search_client function
        search_text=None,
        vector_queries=[vector_query],
        select=["chunk"]
    )

    documents = []
    for result in results:
        documents.append(result["chunk"])

    return documents


# -----------------------------------
# Generate RAG Answer
# -----------------------------------
def generate_answer(query: str):
    documents = retrieve_documents(query)

    if not documents:
        return "No relevant documents found."

    context = "\n\n".join(documents)

    response = openai_client.chat.completions.create(
        model=os.getenv("CHAT_DEPLOYMENT"),
        messages=[
            {
                "role": "system",
                "content": (
                    "You are a strict RAG assistant. "
                    "Answer ONLY from the provided context. "
                    "If the answer is not in the context, respond with: "
                    "'I could not find this information in the provided document.'"
                )
            },
            {
                "role": "user",
                "content": f"Context:\n{context}\n\nQuestion:\n{query}"
            }
        ],
        temperature=0.2
    )

    return response.choices[0].message.content


# -----------------------------------
# Streamlit UI
# -----------------------------------
st.set_page_config(page_title="Azure RAG Chat", layout="wide")
st.title("Azure RAG Chat Application")

if "chat_history" not in st.session_state:
    st.session_state.chat_history = []

user_input = st.chat_input("Ask a question about your indexed document")

if user_input:
    st.session_state.chat_history.append(("user", user_input))

    try:
        answer = generate_answer(user_input)
    except Exception as e:
        answer = f"Error occurred: {str(e)}"

    st.session_state.chat_history.append(("assistant", answer))

for role, message in st.session_state.chat_history:
    with st.chat_message(role):
        st.write(message)