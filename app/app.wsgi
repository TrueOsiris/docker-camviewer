# app.wsgi
import sys
sys.path.insert(0, "/app")
from app import app as application  # `application` is the WSGI callable
