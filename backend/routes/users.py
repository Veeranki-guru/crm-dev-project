from flask import Blueprint, request

from utils.validators import is_valid_email
from utils.response import (
    success_response,
    error_response
)


users_bp = Blueprint(
    "users",
    __name__,
    url_prefix="/users"
)


@users_bp.route("/", methods=["POST"])
def create_user():

    data = request.get_json()

    email = data.get("email")

    if not is_valid_email(email):

        return error_response(
            message="Invalid email address",
            status_code=400
        )

    return success_response(
        message="User created successfully",
        data=data,
        status_code=201
    )