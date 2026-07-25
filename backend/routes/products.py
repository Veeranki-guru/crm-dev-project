from flask import Blueprint, jsonify

products_bp = Blueprint(
    "products",
    __name__,
    url_prefix="/products"
)


@products_bp.route("/", methods=["GET"])
def get_products():

    return jsonify({
        "message": "Get products"
    })