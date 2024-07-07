from flask import Blueprint

bp = Blueprint('api', __name__)

from app.api import main
from app.api import authentication
from app.api import employees