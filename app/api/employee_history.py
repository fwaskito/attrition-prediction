from flask import session, render_template
from app.models.database import Database as db
from psycopg2.extras import RealDictCursor
from app.api import bp


@bp.route("/history", methods=["GET", "POST"])
def employees_history():
    if session.get("user"):
        query = "get_train_data_distribution"
        conn = db().get_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.callproc(query)
        class_distrib = cursor.fetchall()[0]

        query = "get_employees_history"
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.callproc(query)
        employees_history_data = cursor.fetchall()

        cursor.close()
        conn.close()

        return render_template(
            "history.html",
            employees_history=employees_history_data,
            class_distrib=class_distrib,
            page="history",
        )

    return render_template("error.html", error="Unauthorized Access")
