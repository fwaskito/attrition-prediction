from flask import session
from flask import render_template, redirect, url_for, flash
from app.forms import SigninForm
from app.api.models.model import User
from app.api import bp


@bp.route("/login", methods=["GET", "POST"])
def login():
    form = SigninForm()
    if form.validate_on_submit():
        try:
            username = form.username.data
            password = form.password.data
            user = User().get_user(username)

            if len(user) > 0:
                if str(user[0]["password"]) == str(password):
                    session["user"] = user[0]
                    return redirect(url_for("api.employees"))

                flash("Password invalid!")
                return render_template("login.html", form=form, page="login")

            flash("Username invalid!")
            return render_template("login.html", form=form, page="login")

        except Exception as e:
            print("Execption: ", e)
            return render_template("error.html", error=str(e))

    return render_template("login.html", form=form, page="login")


@bp.route("/logout")
def logout():
    session.pop("user", None)
    session.pop("predictions", None)
    session.pop("new_id", None)

    return redirect(url_for("api.main"))
