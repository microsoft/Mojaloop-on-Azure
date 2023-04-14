from DFSPID_Service import send_from_directory
from flask_swagger_ui import get_swaggerui_blueprint
import os

SWAGGER_URL = "/swagger"
FILEURL = "/static/swagger.json"
swaggerui_blueprint = get_swaggerui_blueprint(SWAGGER_URL,FILEURL)
app.register_blueprint(swaggerui_blueprint, url_prefix=SWAGGER_URL)

static_file_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), '../static')
@app.route('/static/<path:path>', methods=['GET'])
def serve_file_in_dir(path):
    if not os.path.isfile(os.path.join(static_file_dir, path)):
        path = os.path.join(path, 'index.html')
    return send_from_directory(static_file_dir, path)
