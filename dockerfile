FROM python:3.12-slim
RUN pip install ollama fastapi uvicorn
COPY . /app
WORKDIR /app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]