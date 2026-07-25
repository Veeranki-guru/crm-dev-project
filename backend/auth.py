from werkzeug.security import generate_password_hash
from werkzeug.security import check_password_hash


def create_password(password):
    return generate_password_hash(password)


def verify_password(password, hashed_password):
    return check_password_hash(
        hashed_password,
        password
    )