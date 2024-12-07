from flask import Flask, jsonify, request
import requests

app = Flask(__name__)

API_URLS = {
    "user": "http://localhost:5001",
    "media": "http://localhost:5002",
    "search": "http://localhost:5003",
}


@app.route("/<service>/<path:endpoint>", methods=["GET", "POST"])
def proxy(service, endpoint):
    if service not in API_URLS:
        return jsonify({"error": "Service not found"}), 404

    url = f"{API_URLS[service]}/{endpoint}"
    if request.method == "GET":
        response = requests.get(url, params=request.args)
    else:
        response = requests.post(url, json=request.json)

    return jsonify(response.json()), response.status_code


if __name__ == "__main__":
    app.run(port=5000)  # API Gateway는 포트 5000에서 실행
