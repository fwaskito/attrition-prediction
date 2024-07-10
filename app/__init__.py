from flask import Flask
from config import Config
from app.api import bp as api_blueprint


def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    # Register blueprints
    app.register_blueprint(api_blueprint)

    @app.route("/test/")
    def test_page():
        return "<h2>Testing the Attrition Prediction System</h2>"

    return app
