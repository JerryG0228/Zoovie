from flask import Flask, jsonify
from func_collections import nowPlaying, popular, topRated, upcoming, getDataById, getKeyword

app = Flask(__name__)


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


if __name__ == "__main__":
    app.run(port=5002)  # Media Service는 포트 5002에서 실행
