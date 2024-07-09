from flask import request, session, render_template, flash, redirect, url_for
from psycopg2.extras import RealDictCursor
from app.models.database import Database as db
from app.utils.helper import generate_id
from app.api import bp


@bp.route("/employees", methods=["GET"])
def employees():
    if session.get("user"):
        query = "get_employees"
        conn = db().get_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.callproc(query)
        employees_data = cursor.fetchall()
        cursor.close()
        conn.close()

        if session.get("new_id") is None:
            session["new_id"] = generate_id()

        return render_template("home.html", employees=employees_data, page="home")

    return render_template("error.html", error="Unauthorized Access")


@bp.route("/employees/edit", methods=["POST"])
def edit_employee():
    id = request.form.get("id")
    age = request.form.get("age")
    # ---- convert foreign key -----------------
    departmant = request.form.get("department")
    department_id = ""

    if departmant.lower() == "research & development":
        department_id = "DP1"
    elif departmant.lower() == "sales":
        department_id = "DP2"
    else:
        department_id = "DP3"
    # ------------------------------------------
    dist_from_home = request.form.get("dist_from_home")
    edu = request.form.get("edu")
    edu_field = request.form.get("edu_field")
    env_sat = request.form.get("env_sat")
    job_sat = request.form.get("job_sat")
    marital_sts = request.form.get("marital_sts")
    num_comp_worked = request.form.get("num_comp_worked")
    salary = request.form.get("salary")
    wlb = request.form.get("wlb")
    years_at_comp = request.form.get("years_at_comp")

    values = [
        age,
        department_id,
        dist_from_home,
        edu,
        edu_field,
        env_sat,
        job_sat,
        marital_sts,
        num_comp_worked,
        salary,
        wlb,
        years_at_comp,
        id,
    ]

    query = "update_employee"
    conn = db().get_connection()
    cursor = conn.cursor()
    cursor.callproc(query, values)
    conn.commit()

    cursor.close()
    conn.close()

    flash(id + "'s data sucessfully updated.")
    return redirect(url_for("api.employees"))


@bp.route("/employees/delete", methods=["POST"])
def deleteData():
    _id = request.form.get("id")
    query = "delete_employee"
    conn = db().get_connection()
    cursor = conn.cursor()
    cursor.callproc(query, [_id])
    conn.commit()

    cursor.close()
    conn.close()

    flash("Employee " + _id + " sucessfully deleted.")
    return redirect(url_for("api.employees"))


@bp.route("/employees/add", methods=["POST"])
def add_employee():
    id = session.get("new_id")
    attrition = "No"
    age = request.form.get("age")
    department_id = request.form.get("department_id")
    dist_from_home = request.form.get("dist_from_home")
    edu = request.form.get("edu")
    edu_field = request.form.get("edu_field")
    env_sat = request.form.get("env_sat")
    job_sat = request.form.get("job_sat")
    marital_sts = request.form.get("marital_sts")
    num_comp_worked = request.form.get("num_comp_worked")
    salary = request.form.get("salary")
    wlb = request.form.get("wlb")
    years_at_comp = request.form.get("years_at_comp")

    values = [
        id,
        attrition,
        age,
        department_id,
        dist_from_home,
        edu,
        edu_field,
        env_sat,
        job_sat,
        marital_sts,
        num_comp_worked,
        salary,
        wlb,
        years_at_comp,
    ]

    query = "add_employee"
    conn = db().get_connection()
    cursor = conn.cursor()
    cursor.callproc(query, values)
    conn.commit()

    cursor.close()
    conn.close()

    session["new_id"] = None
    flash("Employee " + id + " sucessfully added.")
    return redirect(url_for("api.employees"))
