# pyagent start proxy
pyagent run -c appdynamics.cfg --use-manual-proxy -- gunicorn -w 2 --threads 2 -b 0.0.0.0:8002 app:app
