import psycopg2
from config import DatabaseConfig as dc

class Database:
    def get_connection(self):
        conn = psycopg2.connect(
            host = dc.HOST,
            database = dc.DATABASE,
            user = dc.USER,
            password = dc.PASSWORD,
        )

        return conn