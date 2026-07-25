import re


def is_valid_email(email):
    """
    Validate email format.
    """

    if not email:
        return False

    pattern = r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"

    return bool(
        re.match(pattern, email)
    )


def is_valid_phone(phone):
    """
    Validate phone number.
    """

    if not phone:
        return False

    pattern = r"^[0-9]{10}$"

    return bool(
        re.match(pattern, phone)
    )


def is_valid_password(password):
    """
    Validate password length.
    """

    if not password:
        return False

    return len(password) >= 6