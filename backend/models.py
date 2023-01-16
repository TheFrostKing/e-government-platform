from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from uuid import uuid4


db = SQLAlchemy()


def get_uuid():
    return uuid4().hex


class User(db.Model, UserMixin):
    id = db.Column(db.Text(), primary_key=True, default=get_uuid)
    bsn = db.Column(db.Integer(), unique=True)
    password = db.Column(db.String(300), nullable=False, unique=True)
    link_to_child_table = db.relationship("Citizen", backref="parent")


class Citizen(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Text(), db.ForeignKey("user.id"))
    first_name = db.Column(db.String(20))
    last_name = db.Column(db.String(20))
    city = db.Column(db.String(20))
    street = db.Column(db.String(55))
    country = db.Column(db.String(55))
