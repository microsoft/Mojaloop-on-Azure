import logging
from flask.logging import default_handler
import os

#appinsights = AppInsights(app) # sets up api monitoring
#appinsights.context.cloud.role_name = "Python Service"

level = os.environ.get("loglevel", default="info")

if level == "info":
    levelitem = logging.INFO
elif level == "debug":
    levelitem = logging.DEBUG
elif level == "error":
    levelitem = logging.ERROR
elif level == "warn":
    levelitem = logging.WARN
else:
    levelitem = logging.INFO

my_logger = logging.getLogger('simple_logger')
my_logger.setLevel(levelitem)
my_logger.addHandler(default_handler)
