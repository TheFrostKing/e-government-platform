import bcrypt
from flask_cors import CORS
from flask import Flask, jsonify, request, session
from flask_bcrypt import Bcrypt
from datetime import timedelta
from flask_login import (
    login_user,
    LoginManager,
    login_required,
    logout_user,
    current_user
)
from config import ApplicationConfig
from models import db, Citizen, User

# Init App
app = Flask(__name__)
app.config.from_object(ApplicationConfig)

bcrypt = Bcrypt(app)  # noqa
CORS(app, supports_credentials=True)


db.init_app(app)

login_manager = LoginManager()
login_manager.init_app(app)


@app.before_first_request
def first_request():
    with app.app_context():
        # db.drop_all()
        db.create_all()
    # time for inactivity
    app.permanent_session_lifetime = timedelta(minutes=5)
    # refresh session of inactivity
    session.modified = True


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(user_id)


@app.route("/register", methods=["POST"])
def register_user():
    bsn = request.json["bsn"]
    password = request.json["password"]
    first_name = request.json["firstName"]
    city = request.json["city"]
    last_name = request.json["lastName"]
    street = request.json["street"]
    country = request.json["country"]

    user_exists = User.query.filter_by(bsn=bsn).first() is not None

    if user_exists:
        return jsonify({"error": "User already exists"}), 409

    hashed_password = bcrypt.generate_password_hash(password)
    new_user = User(bsn=bsn, password=hashed_password.decode("utf-8"))

    citizen_info = Citizen(
        parent=new_user,
        first_name=first_name,
        city=city,
        street=street,
        country=country,
        last_name=last_name,
    )
    db.session.add(new_user)
    db.session.add(citizen_info)
    db.session.commit()

    return jsonify({"bsn": new_user.bsn})


@app.route("/login", methods=["POST"])
def login():
    bsn = request.json["bsn"]
    password = request.json["password"]
    user = User.query.filter_by(bsn=bsn).first()

    if user is None:
        return jsonify({"error": "Unauthorized"}), 401

    if not bcrypt.check_password_hash(user.password, password):

        return jsonify({"error": "Unauthorized"}), 401

    login_user(user)
    return jsonify({"bsn": user.bsn})


@app.route("/logout", methods=["POST"])
@login_required
def logout():

    logout_user()

    return jsonify({"user": "loggedout"})


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"test": "healthy"}), 200


@app.route("/home", methods=["GET"])
@login_required
def home():
    return jsonify({"test": "raboti"})


# GET USER DATA
@app.route("/user", methods=["GET"])
@login_required
def add_user():

    user_info = Citizen.query.filter_by(user_id=current_user.id).first()
    return jsonify(
        {
            "first_name": user_info.first_name,
            "last_name": user_info.last_name,
            "city": user_info.city,
            "country": user_info.country,
            "street": user_info.street,
        }
    )


# UPDATE ADDRESS
@app.route("/change/address", methods=["POST"])
@login_required
def change_address():
    street = request.json["street"]
    city = request.json["city"]
    country = request.json["country"]

    user_info = Citizen.query.filter_by(user_id=current_user.id).first()

    user_info.first_name = user_info.first_name
    user_info.last_name = user_info.last_name
    user_info.city = city if city else user_info.city
    user_info.country = country if country else user_info.country
    user_info.street = street if street else user_info.street
    print(user_info)
    db.session.add(user_info)
    db.session.commit()

    return (
        jsonify(
            {
                "user": user_info.first_name,
                "country": user_info.country,
                "street": user_info.street,
                "city": user_info.city,
            }
        ),
        200,
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
# app.run(ssl_context=('./self_singed/server.cert', './self_singed/server.key')
# , host ="0.0.0.0", port=443, debug = True)
