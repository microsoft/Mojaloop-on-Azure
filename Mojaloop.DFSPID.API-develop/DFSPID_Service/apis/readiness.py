from flask_healthz  import HealthError
from DFSPID_Service.modules.DataHandler import connectionTest

def liveness():
    pass

def readiness():
    try:
        connectionTest()
    except Exception as e:
        raise HealthError("Can't connect to the database : {0}".format(e))
