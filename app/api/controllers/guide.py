from flask import render_template
from app.api import bp


@bp.route("/guide")
def guide():
    return render_template("guide.html", page="guide")
