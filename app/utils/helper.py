from app.api.models.database import Database


def generate_id() -> str:
    conn = Database().get_connection()
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


def tostring_ordinal(key: str, value: int) -> str:
    attributes = {
        "education": {
            1: "Bellow College",
            2: "College",
            3: "Bachelor",
            4: "Master",
            5: "Doctor",
        },
        "env_satisfaction": {
            1: "Low",
            2: "Medium",
            3: "High",
            4: "Very High",
        },
        "job_satisfaction": {
            1: "Low",
            2: "Medium",
            3: "High",
            4: "Very High",
        },
        "work_life_balance": {
            1: "Bad",
            2: "Good",
            3: "Better",
            4: "Best",
        },
    }

    return attributes[key][value]


def convert_attribute(data_list: list) -> None:
    keys = [
        "education",
        "env_satisfaction",
        "job_satisfaction",
        "work_life_balance",
    ]

    for data in data_list:
        for key in keys:
            data[key] = tostring_ordinal(
                key,
                data[key],
            )
