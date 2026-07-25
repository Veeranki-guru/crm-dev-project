def response_message(message, status=True):
    return {
        "success": status,
        "message": message
    }