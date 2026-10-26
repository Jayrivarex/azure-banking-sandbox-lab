# Usamos una imagen base ligera y segura basada en Python Slim
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.11-slim

WORKDIR /app

# Creamos un usuario sin privilegios (Non-root user) por seguridad bancaria
RUN useradd -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

COPY --from=builder /root/.local /home/appuser/.local
COPY . /app

ENV PATH=/home/appuser/.local/bin:$PATH

EXPOSE 8080

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]