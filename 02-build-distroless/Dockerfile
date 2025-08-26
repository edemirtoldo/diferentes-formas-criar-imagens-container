# =========================
# Stage 1: Builder
# =========================
FROM python:3.11-slim AS builder

WORKDIR /app

# Copia código da aplicação
COPY src/ /app

# Copia apenas requirements para aproveitar cache do Docker
COPY src/requirements.txt .

# Instala dependências em /app/deps
RUN pip install --target=/app/deps --no-cache-dir -r requirements.txt


# =========================
# Stage 2: Distroless Runtime
# =========================
FROM gcr.io/distroless/python3-debian12

WORKDIR /app

# Copia aplicação e dependências do builder
COPY --from=builder /app /app

# Define PYTHONPATH
ENV PYTHONPATH=/app/deps

# CMD no distroless precisa ser apenas o programa/script
CMD ["app.py"]

