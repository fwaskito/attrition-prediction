from flask import session, render_template, redirect, url_for, flash
from psycopg2.extras import RealDictCursor
from app.models.database import Database as db
from app.forms import SigninForm
from app.api import bp


@bp.route("/login", methods=["GET", "POST"])
def login():
    form = SigninForm()
    if form.validate_on_submit():
        try:
            username = form.username.data
            password = form.password.data

            query = "get_system_user"
            conn = db().get_connection()
            cursor = conn.cursor(cursor_factory=RealDictCursor)
            cursor.callproc(query, [username])
            user = cursor.fetchall()

            cursor.close()
            conn.close()

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
