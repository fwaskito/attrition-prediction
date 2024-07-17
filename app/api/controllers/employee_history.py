from flask import session, render_template
from app.api.models.model import EmployeeHistory
from app.utils.helper import convert_attribute
from app.api import bp


@bp.route("/employee-histories", methods=["GET"])
def employee_histories():
    if session.get("user"):
        employee_histories_data = EmployeeHistory().get_employee_histories()
        train_class_distrib = EmployeeHistory().get_train_class_distribution()
        convert_attribute(employee_histories_data)

        if train_class_distrib["e_attrition_no"] is None:
            train_class_distrib["e_attrition_no"] = 0
        if train_class_distrib["eh_attrition_no"] is None:
            train_class_distrib["eh_attrition_no"] = 0
        if train_class_distrib["eh_attrition_yes"] is None:
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
