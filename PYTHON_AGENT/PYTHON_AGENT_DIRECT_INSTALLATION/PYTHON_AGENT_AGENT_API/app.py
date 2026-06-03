from flask import Flask, jsonify, request
from appdynamics.agent import api as appd

app = Flask(__name__)

@app.route('/hello', methods=['GET'])
def hello():
    exc = None
    bt_handle = appd.start_bt('hello')
    try:
        return "Hello World"
    except Exception as exc:
        raise
    finally:
        appd.end_bt(bt_handle, exc)


if __name__ == "__main__":
    # Run locally if needed (not used in Docker)
    app.run(host="0.0.0.0", port=8002)