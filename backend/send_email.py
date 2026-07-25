import smtplib
from email.message import EmailMessage
from config import Config


def send_email(to_email, subject, body):

    message = EmailMessage()

    message["Subject"] = subject
    message["From"] = "your-email@example.com"
    message["To"] = to_email

    message.set_content(body)

    with smtplib.SMTP(
        Config.SMTP_SERVER,
        Config.SMTP_PORT
    ) as server:

        server.starttls()

        server.login(
            "your-email@example.com",
            "your-password"
        )

        server.send_message(message)