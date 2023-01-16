from dotenv import load_dotenv
import os

load_dotenv()


class ApplicationConfig:

    SQLALCHEMY_TRACK_MODIFICATIONS = False
    # SQLALCHEMY_ECHO = True
    SESSION_TYPE = "filesystem"
    SECRET_KEY = os.getenv("SECRET_KEY")
    # SESSION_COOKIE_SECURE=True
    SESSION_REFRESH_EACH_REQUEST = False
    # SESSION_COOKIE_HTTPONLY=False
    username = os.getenv("username")
    password = "secret"
    SQLALCHEMY_DATABASE_URI = f'postgresql://{username}:{password}@<some_DB_URL>:5432/{dbname}'
