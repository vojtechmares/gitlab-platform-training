# hello-app

A tiny Flask service used throughout the GitLab Platform training.

| Endpoint   | Returns                                        |
| ---------- | ---------------------------------------------- |
| `/`        | App name, version, environment, host name      |
| `/healthz` | `{"status": "ok"}` for health checks           |

Run it locally:

```bash
pip install -r requirements-dev.txt
pytest
APP_ENVIRONMENT=local gunicorn --bind 127.0.0.1:8000 app.main:app
```

Build the image: `docker build -t hello-app .`
