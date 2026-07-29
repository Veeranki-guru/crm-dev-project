```python
import logging
import os

from flask import Flask, jsonify, render_template

from config import Config
from database import init_db

from routes.authentication import authentication_bp
from routes.users import users_bp
from routes.products import products_bp
from routes.orders import orders_bp


# --------------------------------------------------
# Base directory
# --------------------------------------------------

BASE_DIR = os.path.dirname(os.path.abspath(__file__))


# --------------------------------------------------
# Create logs directory
# --------------------------------------------------

LOG_DIR = os.path.join(BASE_DIR, "logs")

os.makedirs(LOG_DIR, exist_ok=True)


# --------------------------------------------------
# Configure logging
# --------------------------------------------------

LOG_FILE = os.path.join(LOG_DIR, "error.log")

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s: %(message)s",
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler()
    ]
)


# --------------------------------------------------
# Create Flask application
# --------------------------------------------------

app = Flask(
    __name__,
    template_folder=os.path.join(BASE_DIR, "templates"),
    static_folder=os.path.join(BASE_DIR, "static")
)


# --------------------------------------------------
# Load configuration
# --------------------------------------------------

app.config.from_object(Config)


# --------------------------------------------------
# Initialize database
# --------------------------------------------------

init_db(app)


# --------------------------------------------------
# Register Blueprints
# --------------------------------------------------

app.register_blueprint(authentication_bp)
app.register_blueprint(users_bp)
app.register_blueprint(products_bp)
app.register_blueprint(orders_bp)


# --------------------------------------------------
# Home page
# --------------------------------------------------

@app.route("/", methods=["GET"])
def home():
    app.logger.info("Home page accessed")

    return render_template("index.html")


# --------------------------------------------------
# Health check
# --------------------------------------------------

@app.route("/health", methods=["GET"])
def health():
    app.logger.info("Health check requested")

    return jsonify({
        "status": "UP",
        "message": "Application is healthy"
    }), 200


# --------------------------------------------------
# Dashboard
# --------------------------------------------------

@app.route("/dashboard", methods=["GET"])
def dashboard():
    app.logger.info("Dashboard accessed")

    return render_template("dashboard.html")


# --------------------------------------------------
# Run application
# --------------------------------------------------

if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5000,
        debug=False
    )
```
