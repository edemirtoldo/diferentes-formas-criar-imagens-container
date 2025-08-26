# =========================
# Stage 1: Builder
# =========================
FROM cgr.dev/chainguard/python:latest-dev AS builder

WORKDIR /app

# Copia código da aplicação
COPY src/ /app

# Copia apenas requirements para aproveitar cache do Docker
COPY src/requirements.txt .

# Instala dependências em /app/deps
RUN pip install --target=/app/deps --no-cache-dir -r requirements.txt

# =========================
# Stage 2: Chainguard Runtime
# =========================
FROM cgr.dev/chainguard/python:latest

WORKDIR /app

# Copia aplicação e dependências do builder
COPY --from=builder /app /app

# Define PYTHONPATH
ENV PYTHONPATH=/app/deps

# Comando padrão
CMD ["/app/app.py"]

