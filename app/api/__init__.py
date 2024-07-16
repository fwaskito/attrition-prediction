from flask import Blueprint

bp = Blueprint("api", __name__)

from app.api.controllers import main
from app.api.controllers import authentication
from app.api.controllers import employee
from app.api.controllers import employee_history
from app.api.controllers import prediction
