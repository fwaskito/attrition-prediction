from flask import session, render_template, redirect, url_for, flash
from psycopg2.extras import RealDictCursor
from app.models.database import Database
from app.forms import SigninForm
from app.api import bp


@bp.route("/login", methods=["GET", "POST"])
def login():
    form = SigninForm()
    if form.validate_on_submit():
        try:
            username = form.username.data
            password = form.password.data

            query = "select * from sys_user where username='" + username + "';"
            conn = Database().get_connection()
            cursor = conn.cursor(cursor_factory=RealDictCursor)
            cursor.execute(query)
            data = cursor.fetchall()

            if len(data) > 0:
                if str(data[0]["password"]) == str(password):
                    session["user"] = data[0]
                    return redirect(url_for("api.employees"))
                else:
                    flash("Password invalid!")
                    return render_template("login.html", form=form, page="login")
            else:
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
