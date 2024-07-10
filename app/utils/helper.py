from app.models.database import Database as db


def generate_id():
    conn = db().get_connection()
    cursor = conn.cursor()

    query = "SELECT max(id) FROM employee"
    cursor.execute(query)
    max_id_employee = cursor.fetchone()[0]

    query = "SELECT max(employee_id) FROM employee_history"
    cursor.execute(query)
    max_id_employee_history = cursor.fetchone()[0]

    cursor.close()
    conn.close()

    new_num_id = 0

    if max_id_employee > max_id_employee_history:
        max_id = max_id_employee.removeprefix("EP")
        new_num_id = int(max_id) + 1
    else:
        max_id = max_id_employee_history.removeprefix("EP")
        new_num_id = int(max_id) + 1

    return f"EP{new_num_id}"
