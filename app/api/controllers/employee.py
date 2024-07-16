from flask import request, session
from flask import render_template, redirect, url_for, flash
from app.utils.helper import generate_id
from app.api.models.model import Employee
from app.api import bp


@bp.route("/employees", methods=["GET"])
def employees():
    if session.get("user"):
        employees_data = Employee().get_employees()

        if session.get("new_id") is None:
            session["new_id"] = generate_id()

        return render_template("home.html", employees=employees_data, page="home")
    return render_template("error.html", error="Unauthorized Access")


@bp.route("/employees/edit", methods=["POST"])
def edit_employee():
    id_ = request.form.get("id")
    values = [
        id_,
        request.form.get("age"),
        request.form.get("department_id"),
        request.form.get("dist_from_home"),
        request.form.get("education"),
        request.form.get("education_field"),
        request.form.get("env_satisfaction"),
        request.form.get("job_satisfaction"),
        request.form.get("marital_status"),
        request.form.get("num_comp_worked"),
        request.form.get("monthly_income"),
        request.form.get("work_life_balance"),
        request.form.get("years_at_company"),
    ]

    Employee().update_employee(values)
    flash("Employee " + id_ + "'s data successfully updated.")

    return redirect(url_for("api.employees"))


@bp.route("/employees/delete", methods=["POST"])
def delete_employee():
    id_ = request.form.get("id")
    Employee().delete_employee(id_)
    flash("Employee " + id_ + " successfully deleted.")

    return redirect(url_for("api.employees"))


@bp.route("/employees/add", methods=["POST"])
def add_employee():
    id_ = session.get("new_id")
    values = [
        id_,
        "No",
        request.form.get("age"),
        request.form.get("department_id"),
        request.form.get("dist_from_home"),
        request.form.get("education"),
        request.form.get("education_field"),
        request.form.get("env_satisfaction"),
        request.form.get("job_satisfaction"),
        request.form.get("marital_status"),
        request.form.get("num_comp_worked"),
        request.form.get("monthly_income"),
        request.form.get("work_life_balance"),
        request.form.get("years_at_company"),
    ]

    Employee().add_employee(values)
    session["new_id"] = None
    flash("Employee " + id_ + " successfully added.")

    return redirect(url_for("api.employees"))
