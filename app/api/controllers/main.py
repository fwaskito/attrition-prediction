from flask import render_template
from app.api import bp


@bp.route("/")
def main():
    return render_template("index.html", page="main")
