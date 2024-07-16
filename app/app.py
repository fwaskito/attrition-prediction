from flask import Flask
from config import Config
from app.api import bp as api_blueprint


app = Flask(__name__, template_folder="api/views")
app.config.from_object(Config)

# Register blueprints
app.register_blueprint(api_blueprint)
