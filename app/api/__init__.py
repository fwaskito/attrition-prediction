from flask import Blueprint

bp = Blueprint("api", __name__)

from app.api import main
from app.api import authentication
from app.api import employee
from app.api import employee_history
from app.api import prediction
