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
    id_ = request.form.get("id")
    age = request.form.get("age")
    department_id = request.form.get("department_id")
    dist_from_home = request.form.get("dist_from_home")
    education = request.form.get("education")
    education_field = request.form.get("education_field")
    env_satisfaction = request.form.get("env_satisfaction")
    job_satisfaction = request.form.get("job_satisfaction")
    marital_status = request.form.get("marital_status")
    num_comp_worked = request.form.get("num_comp_worked")
    monthly_income = request.form.get("monthly_income")
    work_life_balance = request.form.get("work_life_balance")
    years_at_company = request.form.get("years_at_company")

    values = [
        id_,
        age,
        department_id,
        dist_from_home,
        education,
        education_field,
        env_satisfaction,
        job_satisfaction,
        marital_status,
        num_comp_worked,
        monthly_income,
        work_life_balance,
        years_at_company,
    ]

    query = "update_employee"
    conn = db().get_connection()
    cursor = conn.cursor()
    cursor.callproc(query, values)
    conn.commit()

    cursor.close()
    conn.close()

    flash("Employee " + id_ + "'s data successfully updated.")
    return redirect(url_for("api.employees"))


@bp.route("/employees/delete", methods=["POST"])
def delete_employee():
    id_ = request.form.get("id")
    query = "delete_employee"
    conn = db().get_connection()
    cursor = conn.cursor()
    cursor.callproc(query, [id_])
    conn.commit()

    cursor.close()
    conn.close()

    flash("Employee " + id_ + " successfully deleted.")
    return redirect(url_for("api.employees"))


@bp.route("/employees/add", methods=["POST"])
def add_employee():
    id_ = request.form.get("id")
    attrition = "No"
    age = request.form.get("age")
    department_id = request.form.get("department_id")
    dist_from_home = request.form.get("dist_from_home")
    education = request.form.get("education")
    education_field = request.form.get("edu_field")
    env_satisfaction = request.form.get("env_satisfaction")
    job_satisfaction = request.form.get("job_satisfaction")
    marital_status = request.form.get("marital_status")
    num_comp_worked = request.form.get("num_comp_worked")
    monthly_income = request.form.get("monthly_income")
    work_life_balance = request.form.get("work_life_balance")
    years_at_company = request.form.get("years_at_company")

    values = [
        id_,
        attrition,
        age,
        department_id,
        dist_from_home,
        education,
        education_field,
        env_satisfaction,
        job_satisfaction,
        marital_status,
        num_comp_worked,
        monthly_income,
        work_life_balance,
        years_at_company,
    ]

    query = "add_employee"
    conn = db().get_connection()
    cursor = conn.cursor()
    cursor.callproc(query, values)
    conn.commit()

    cursor.close()
    conn.close()

    session["new_id"] = None
    flash("Employee " + id_ + " successfully added.")
    return redirect(url_for("api.employees"))
