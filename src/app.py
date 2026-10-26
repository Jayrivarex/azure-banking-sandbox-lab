from fastapi import FastAPI, Response, status
import os

app = FastAPI(title="Banking Core API", version="1.0.0")

@app.get("/accounts/{account_id}")
def get_account_balance(account_id: str):
    # Simulación de respuesta de core bancario bajo estrictos estándares de latencia
    return {
        "account_id": account_id,
        "status": "ACTIVE",
        "currency": "PEN",
        "balance": 15450.75,
        "environment": os.getenv("ENVIRONMENT", "sandbox")
    }

@app.get("/healthz")
def liveness_probe(response: Response):
    # Kubernetes Liveness Probe: Valida si el proceso está vivo
    return {"status": "healthy"}

@app.get("/readyz")
def readiness_probe(response: Response):
    # Kubernetes Readiness Probe: Valida si el servicio está listo para recibir tráfico
    return {"status": "ready"}