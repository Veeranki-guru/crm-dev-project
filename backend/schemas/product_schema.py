from marshmallow import Schema, fields, validate


class ProductSchema(Schema):

    id = fields.Int(
        dump_only=True
    )

    name = fields.Str(
        required=True,
        validate=validate.Length(min=2, max=100)
    )

    description = fields.Str(
        required=False
    )

    price = fields.Float(
        required=True,
        validate=validate.Range(min=0)
    )

    quantity = fields.Int(
        required=True,
        validate=validate.Range(min=0)
    )

    created_at = fields.DateTime(
        dump_only=True
    )