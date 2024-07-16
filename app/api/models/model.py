from psycopg2.extras import RealDictCursor
from app.api.models.database import Database


class Employee:
    def get_employees(self):
        query = "get_employees"
        conn = Database().get_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.callproc(query)
        employees = cursor.fetchall()

        cursor.close()
        conn.close()

        return employees

    def update_employee(self, values: list):
        query = "update_employee"
        conn = Database().get_connection()
        cursor = conn.cursor()
        cursor.callproc(query, values)
        conn.commit()

        cursor.close()
        conn.close()

    def delete_employee(self, id_: str):
        query = "delete_employee"
        conn = Database().get_connection()
        cursor = conn.cursor()
        cursor.callproc(query, [id_])
        conn.commit()

        cursor.close()
        conn.close()

    def add_employee(self, values: list):
        query = "add_employee"
        conn = Database().get_connection()
        cursor = conn.cursor()
        cursor.callproc(query, values)
        conn.commit()

        cursor.close()
        conn.close()


class EmployeeHistory:
    def get_employee_histories(self):
        query = "get_employees_history"
        conn = Database().get_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.callproc(query)
        employees_history = cursor.fetchall()

        cursor.close()
        conn.close()

        return employees_history

    def get_train_class_distribution(self):
        query = "get_train_class_distribution"
        conn = Database().get_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.callproc(query)
        class_distrib = cursor.fetchall()[0]

        cursor.close()
        conn.close()

        return class_distrib


class Prediction:
    def get_test_data(self):
        query = "get_test_data"
        conn = Database().get_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.callproc(query)
        test_data = cursor.fetchall()

        cursor.close()
        conn.close()

        return test_data

    def get_train_data(self):
        query = "get_train_data"
        conn = Database().get_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.callproc(query)
        train_data = cursor.fetchall()

        cursor.close()
        conn.close()

        return train_data

    def rest_test_data(self):
        query = "reset_test_data"
        conn = Database().get_connection()
        cursor = conn.cursor()
        cursor.callproc(query)
        conn.commit()

        cursor.close()
        conn.close()


class User:
    def get_user(self, username: str):
        query = "get_sys_user"
        conn = Database().get_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.callproc(query, [username])
        user = cursor.fetchall()

        cursor.close()
        conn.close()

        return user
