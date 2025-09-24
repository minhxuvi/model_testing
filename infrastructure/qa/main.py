# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "fastapi",
#     "ollama",
# ]
# ///

import os
import socket

import ollama
from fastapi import FastAPI

app = FastAPI()


def get_ollama_host():
    """Detect environment and return appropriate Ollama host"""
    # Check if running in Docker container
    if os.path.exists("/.dockerenv"):
        # Running in Docker - use host.docker.internal
        return "http://host.docker.internal:11434"

    # Alternative check: try to resolve host.docker.internal
    try:
        socket.gethostbyname("host.docker.internal")
        return "http://host.docker.internal:11434"
    except socket.gaierror:
        # Not in Docker environment, use localhost
        return "http://localhost:11434"


def get_pod_info():
    """Get pod identification information"""
    pod_name = os.environ.get("HOSTNAME", "unknown")
    pod_ip = os.environ.get("POD_IP", "unknown")
    node_name = os.environ.get("NODE_NAME", "unknown")

    return {"pod_name": pod_name, "pod_ip": pod_ip, "node_name": node_name}


# Configure Ollama client based on environment
ollama_host = get_ollama_host()
# print(f"Using Ollama host: {ollama_host}")
client = ollama.Client(host=ollama_host)


@app.get("/generate")
def generate(prompt: str):
    try:
        response = client.chat(
            model="llama3.1:8b", messages=[{"role": "user", "content": prompt}]
        )
        return {"response": response["message"]["content"], "pod_info": get_pod_info()}
    except Exception as e:
        print(f"Error in API endpoint: {e}")
        return {
            "error": f"Could not connect to Ollama at {ollama_host}",
            "details": str(e),
        }


@app.get("/health")
def health():
    """Health check endpoint with pod info"""
    return get_pod_info()
