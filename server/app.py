import bcrypt
from flask import Flask, jsonify, request
from pymongo import MongoClient
from func_collections import *

# MongoDB 연결
client = MongoClient("mongodb://localhost:27017/")
db = client["zoovieDB"]
users_collection = db["users"]

app = Flask(__name__)


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


# 화면에서 영화 데이터 모두 불러오기
# media: movie, tv
@app.route("/<media>/loaddatas", methods=["GET"])
def loadDatas(media):
    datas = {}
    datas["nowPlaying"] = nowPlaying(media, page=1)
    datas["popular"] = popular(media, page=1)
    datas["topRated"] = topRated(media, page=1)
    datas["upcoming"] = upcoming(media, page=1)
    return jsonify(datas)


# 해당 id 값 영화 or tv 프로그램 데이터 불러오기
@app.route("/getdatabyid/<media>/<int:id>", methods=["GET"])
def getDataByIdRoute(media, id):
    datas = getDataById(media, id)
    datas["keywords"] = getKeyword(media, id)
    return jsonify(datas)


# 현재 상영중인 영화 또는 TV 프로그램 데이터 불러오기
@app.route("/morenowplaying/<media>/<int:page>", methods=["GET"])
def moreNowPlaying(media, page):
    datas = nowPlaying(media, page)
    return jsonify(datas)


# 인기있는 영화 or TV 프로그램 데이터 불러오기
@app.route("/morepopular/<media>/<int:page>", methods=["GET"])
def morePopular(media, page):
    datas = popular(media, page)
    return jsonify(datas)


# 평가 받은 영화 or TV 프로그램 데이터 불러오기
@app.route("/moretoprated/<media>/<int:page>", methods=["GET"])
def moreTopRated(media, page):
    datas = topRated(media, page)
    return jsonify(datas)


# 상영 예정인 영화 or 곧 방영 예정인 TV 프로그램 데이터 불러오기
@app.route("/moreupcoming/<media>/<int:page>", methods=["GET"])
def moreUpcoming(media, page):
    datas = upcoming(media, page)
    return jsonify(datas)


# 검색 키워드를 통해 영화, TV 프로그램 데이터 불러오기
@app.route("/search/<keyword>/<int:page>", methods=["GET"])
def search(keyword, page):
    datas = getDatabyKeyword(keyword, page)
    return jsonify(datas)


# 검색 키워드를 통해 영화, TV 프로그램 데이터 불러오기
@app.route("/similar/<media>/<id>", methods=["GET"])
def similar(media, id):
    datas = getSimilar(media, id)
    return jsonify(datas)


# 키워드 검색
@app.route("/keyword/<media>/<id>", methods=["GET"])
def keyword(media, id):
    datas = getKeyword(media, id)
    return jsonify(datas)


if __name__ == '__main__':
    app.run()
