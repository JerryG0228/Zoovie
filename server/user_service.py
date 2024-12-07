from flask import Flask, jsonify, request
from pymongo import MongoClient
import bcrypt

app = Flask(__name__)

# MongoDB 연결
client = MongoClient("mongodb://localhost:27017/")
db = client["zoovieDB"]
users_collection = db["users"]


# 회원가입
@app.route("/signup", methods=["POST"])
def signup():
    data = request.json
    if users_collection.find_one({"username": data["username"]}):
        return jsonify({"error": "Already exists username"}), 400

    hashed_password = bcrypt.hashpw(data["password"].encode('utf-8'), bcrypt.gensalt())
    new_user = {
        "username": data["username"],
        "password": hashed_password,
        "email": data["email"],
        "bookmarked": {
            "movie": [],
            "tv": []
        }
    }
    users_collection.insert_one(new_user)
    return jsonify({"message": "Success signup"}), 201


# 로그인
@app.route("/login", methods=["POST"])
def login():
    data = request.json
    user = users_collection.find_one({"email": data["email"]})
    # 비밀번호 확인
    if not user or not bcrypt.checkpw(data["password"].encode('utf-8'), user["password"]):
        return jsonify({"error": "User does not exist"}), 401
    return jsonify({"message": "Successful login"}), 200


# 유저 정보 불러오기
@app.route("/user", methods=["POST"])
def getUserByEmail():
    data = request.json
    email = data.get("email")
    if not email:
        return jsonify({"error": "Email is required"}), 400

    user = users_collection.find_one({"email": email})
    if not user:
        return jsonify({"error": "User does not exist"}), 404

    user_info = {
        "username": user["username"],
        "email": user["email"],
        "bookmarked": user.get("bookmarked", {"movie": [], "tv": []})
    }
    return jsonify(user_info), 200


# 북마크
@app.route("/<media>/bookmark", methods=["POST"])
def bookmark(media):
    data = request.json
    username = data["username"]
    item_id = data["item_id"]

    user = users_collection.find_one({"username": username})
    if not user:
        return jsonify({"error": "User does not exist"}), 404

    if media not in ["movie", "tv"]:
        return jsonify({"error": "Invalid media type"}), 400

    users_collection.update_one(
        {"username": username},
        {"$addToSet": {f"bookmarked.{media}": item_id}}
    )
    return jsonify({"message": f"Success add ID to {media} bookmarks"}), 200


# 북마크 취소
@app.route("/<media>/cancelBookmark", methods=["POST"])
def cancelBookmark(media):
    data = request.json
    username = data["username"]
    item_id = data["item_id"]

    if media not in ["movie", "tv"]:
        return jsonify({"error": "Invalid media type"}), 400

    result = users_collection.update_one(
        {"username": username},
        {"$pull": {f"bookmarked.{media}": item_id}},
        upsert=False
    )
    if result.modified_count == 0:
        return jsonify({"error": f"Item ID not found in {media} bookmarks"}), 404
    return jsonify({"message": f"Success remove ID from {media} bookmarks"}), 200


if __name__ == "__main__":
    app.run(port=5001)  # User Service는 포트 5001에서 실행
