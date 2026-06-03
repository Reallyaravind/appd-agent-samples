from flask import Flask, jsonify


app = Flask(__name__)

@app.route("/home")
def home():
    return jsonify(message="Hello from Flask running inside Docker on port 8002!")

@app.route("/health")
def health():
    return jsonify(status="UP")

if __name__ == "__main__":
    # Run locally if needed (not used in Docker)
    app.run(host="0.0.0.0", port=8002)