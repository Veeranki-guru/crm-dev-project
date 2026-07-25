import os


class Config:
    SECRET_KEY = os.getenv(
        "SECRET_KEY",
        "change-this-secret-key"
    )

    DATABASE_URL = os.getenv(
        "DATABASE_URL",
        "sqlite:///app.db"
    )

    SMTP_SERVER = os.getenv(
        "SMTP_SERVER",
        "smtp.gmail.com"
    )

    SMTP_PORT = int(os.getenv(
        "SMTP_PORT",
        "587"
    ))