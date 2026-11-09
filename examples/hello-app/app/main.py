"""Tiny demo service used throughout the GitLab Platform training."""

import os
import socket

from flask import Flask, jsonify

app = Flask(__name__)

# Injected at build time (see Dockerfile and .gitlab-ci.yml).
VERSION = os.environ.get("APP_VERSION", "dev")
ENVIRONMENT = os.environ.get("APP_ENVIRONMENT", "local")


@app.get("/")
def index():
    return jsonify(
        app="hello-app",
        version=VERSION,
        environment=ENVIRONMENT,
        host=socket.gethostname(),
    )


@app.get("/healthz")
def healthz():
    return jsonify(status="ok"), 200
