from flask import Blueprint, jsonify

authentication_bp = Blueprint(
    "authentication",
    __name__,
    url_prefix="/auth"
)


@authentication_bp.route("/login", methods=["POST"])
def login():

    return jsonify({
        "message": "Login API"
    })


@authentication_bp.route("/logout", methods=["POST"])
def logout():

    return jsonify({
        "message": "Logout API"
    })