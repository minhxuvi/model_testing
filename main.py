import ollama


def ollama_health_check():
    try:
        response = ollama.chat(
            model="llama3.1:8b",
            messages=[{"role": "user", "content": "ping"}],
            options={"temperature": 0, "seed": 0},
        )
        return response.get("message") is not None
    except Exception:
        return False


def generate_text(prompt):
    response = ollama.chat(
        model="llama3.1:8b",
        messages=[{"role": "user", "content": prompt}],
        options={
            "temperature": 0,  # Makes output deterministic
            "seed": 0,  # Optional: ensures same results across runs
        },
    )
    return response["message"]["content"]


# Example usage
# print(generate_text("Explain quantum computing in simple terms."))
print(ollama_health_check())
