from flask import (
    Blueprint, request, Response
)
from flask_cors import CORS
from DFSPID_Service.modules.DataHandler import LookupDFSPID

validate = Blueprint('validate', __name__)
CORS(validate)

@validate.route("/Validate", methods=['GET'])#change to get instead
def validate_dfsp_id():
    dfspid = request.headers.get('X-DFSP-ID')
    res,err = LookupDFSPID(dfspid)
    if res == 1:
        return Response("{'validID' : false }", status=401, mimetype='application/json')
    return Response("{'validID' : true }", status=200, mimetype='application/json')

