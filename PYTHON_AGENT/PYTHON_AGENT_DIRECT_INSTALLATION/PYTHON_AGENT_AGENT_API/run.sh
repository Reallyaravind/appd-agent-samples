# Run pyagent with appdynamics config and start gunicorn server
pyagent run -c appdynamics.cfg -- \
gunicorn -w 2 --threads 2 -b 0.0.0.0:8002 app:app