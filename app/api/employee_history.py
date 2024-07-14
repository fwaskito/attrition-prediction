from flask import session, render_template
from app.models.database import Database as db
from psycopg2.extras import RealDictCursor
from app.api import bp


@bp.route("/employee-histories", methods=["GET"])
def employee_histories():
    if session.get("user"):
        conn = db().get_connection()
        query = "get_employees_history"
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.callproc(query)
        employee_histories_data = cursor.fetchall()

        query = "get_train_class_distribution"
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.callproc(query)
        train_class_distrib = cursor.fetchall()[0]

        cursor.close()
        conn.close()

        if train_class_distrib["e_attrition_no"] == None:
            train_class_distrib["e_attrition_no"] = 0
        if train_class_distrib["eh_attrition_no"] == None:
            train_class_distrib["eh_attrition_no"] = 0
        if train_class_distrib["eh_attrition_yes"] == None:
            train_class_distrib["eh_attrition_yes"] = 0

        class_distrib = {
            "no": (
                train_class_distrib["e_attrition_no"]
                + train_class_distrib["eh_attrition_no"]
            ),
            "yes": train_class_distrib["eh_attrition_yes"],
        }

        return render_template(
            "history.html",
            employee_histories=employee_histories_data,
            class_distrib=class_distrib,
            page="history",
        )

    return render_template("error.html", error="Unauthorized Access")
