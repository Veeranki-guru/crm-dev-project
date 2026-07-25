from marshmallow import Schema, fields, validate


class OrderSchema(Schema):

    id = fields.Int(
        dump_only=True
    )

    user_id = fields.Int(
        required=True,
        validate=validate.Range(min=1)
    )

    product_id = fields.Int(
        required=True,
        validate=validate.Range(min=1)
    )

    quantity = fields.Int(
        required=True,
        validate=validate.Range(min=1)
    )

    status = fields.Str(
        required=False,
        validate=validate.OneOf([
            "pending",
            "confirmed",
            "shipped",
            "delivered",
            "cancelled"
        ])
    )

    created_at = fields.DateTime(
        dump_only=True
    )