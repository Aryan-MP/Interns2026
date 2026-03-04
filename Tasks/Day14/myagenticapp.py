#chatvenv - lab venv for this file
import os
import re
import math
import chainlit as cl
from openai import AzureOpenAI
from dotenv import load_dotenv
from pathlib import Path
from collections import Counter

load_dotenv()

# ── Azure OpenAI client ──────────────────────────────────────────────────────
client = AzureOpenAI(
    api_key=os.getenv("AZURE_OPENAI_API_KEY"),
    api_version=os.getenv("AZURE_OPENAI_API_VERSION", "2024-12-01-preview"),
    azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT"),
)

DEPLOYMENT_NAME = os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME", "gpt-4o-mini")

SYSTEM_PROMPT = """You are a passionate and knowledgeable FIFA World Cup analyst.
You have deep expertise on the 2014 (Brazil), 2018 (Russia), and 2022 (Qatar) World Cups.
Answer questions using the provided context from the knowledge base.
Be enthusiastic, specific with stats, and cite numbers confidently.
If the user asks something outside these three tournaments, politely say your knowledge is focused on 2014, 2018, and 2022 World Cups."""


# initialise message history ────────────────────────────────
@cl.on_chat_start
async def on_chat_start():
    cl.user_session.set("message_history", [
        {"role": "system", "content": SYSTEM_PROMPT}
    ])
    await cl.Message(content="👋 Hello! How can I help you today?").send()


# ── On each user message ─────────────────────────────────────────────────────
@cl.on_message
async def on_message(message: cl.Message):
    # Retrieve and update history
    history = cl.user_session.get("message_history")
    history.append({"role": "user", "content": message.content})

    # Placeholder message for streaming
    response_message = cl.Message(content="")
    await response_message.send()

    # Stream from Azure OpenAI
    stream = client.chat.completions.create(
        model=DEPLOYMENT_NAME,
        messages=history,
        stream=True,
    )

    full_response = ""
    for chunk in stream:
        delta = chunk.choices[0].delta if chunk.choices else None
        if delta and delta.content:
            full_response += delta.content
            await response_message.stream_token(delta.content)

    await response_message.update()

    # Save assistant reply to history
    history.append({"role": "assistant", "content": full_response})
    cl.user_session.set("message_history", history)