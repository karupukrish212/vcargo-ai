from fastapi import FastAPI

from app.core.config import settings
from app.core.database import check_database_connection


app = FastAPI(
    title=settings.APP_NAME,
)


@app.get("/")
def root():
    return {
        "message": "VCargo AI Assistant API is running"
    }


@app.get("/health")
def health():
    database_connected = check_database_connection()

    return {
        "status": "healthy" if database_connected else "unhealthy",
        "database": (
            "connected"
            if database_connected
            else "disconnected"
        ),
    }