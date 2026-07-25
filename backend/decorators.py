from functools import wraps
from flask import request, jsonify


def token_required(func):

    @wraps(func)
    def decorated(*args, **kwargs):

        token = request.headers.get("Authorization")

        if not token:
            return jsonify({
                "message": "Token is missing"
            }), 401

        return func(*args, **kwargs)

    return decorated