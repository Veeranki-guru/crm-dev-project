
import os
import sys

# Add backend directory to Python path
BACKEND_DIR = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        ".."
    )
)

sys.path.insert(0, BACKEND_DIR)

from app import app


def test_health():
    """
    Test the application health endpoint.
    """

    client = app.test_client()

    response = client.get("/health")

    assert response.status_code == 200

    data = response.get_json()

    assert data["status"] == "UP"

    assert data["message"] == "Application is healthy"

