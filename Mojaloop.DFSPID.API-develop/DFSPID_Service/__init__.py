from flask import Flask, request,jsonify,Response,send_from_directory
from flask_healthz import healthz
from DFSPID_Service.modules.logging import my_logger
from flask_swagger_ui import get_swaggerui_blueprint
import os
import DFSPID_Service.apis.readiness

def create_app():
    app = Flask(__name__)
    SWAGGER_URL = "{0}swagger".format(os.environ.get("SWAGGER_PREFIX","/"))
    FILEURL = "{0}static/swagger.json".format(os.environ.get("SWAGGERFILE_PREFIX","/"))
    swaggerui_blueprint = get_swaggerui_blueprint(SWAGGER_URL,FILEURL)
    app.register_blueprint(swaggerui_blueprint, url_prefix="/swagger")
    app.register_blueprint(healthz, url_prefix="/healthz")
    app.config.update(
        HEALTHZ = {
            "live":"DFSPID_Service.apis.readiness.liveness",
            "ready":"DFSPID_Service.apis.readiness.readiness"
        }
    )

    from DFSPID_Service.apis.validation import validate
    app.register_blueprint(validate)

    return app