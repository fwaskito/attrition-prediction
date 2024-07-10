import os

basedir = os.path.abspath(os.path.dirname(__file__))


class Config:
    SECRET_KEY = os.environ["SECRET_KEY"]


class DatabaseConfig:
    HOST = os.environ["POSTGRES_HOST"]
    DATABASE = os.environ["POSTGRES_DATABASE"]
    USER = os.environ["POSTGRES_USER"]
    PASSWORD = os.environ["POSTGRES_PASSWORD"]
