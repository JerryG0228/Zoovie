from flask import Flask, jsonify
from func_collections import getDatabyKeyword, getSimilar, getKeyword, getVideo

app = Flask(__name__)


# 검색 키워드를 통해 영화, TV 프로그램 데이터 불러오기
@app.route("/search/<keyword>/<int:page>", methods=["GET"])
def search(keyword, page):
    datas = getDatabyKeyword(keyword, page)
    return jsonify(datas)


# 비슷한 영화, TV 프로그램 데이터 불러오기
@app.route("/similar/<media>/<id>/<int:page>", methods=["GET"])
def similar(media, id, page):
    datas = getSimilar(media, id, page)
    return jsonify(datas)


# 키워드 검색
@app.route("/keyword/<media>/<id>", methods=["GET"])
def keyword(media, id):
    datas = getKeyword(media, id)
    return jsonify(datas)


# 티저 영상 검색
@app.route("/video/<media>/<id>", methods=["GET"])
def video(media, id):
    datas = getVideo(media, id)
    return jsonify(datas)


if __name__ == "__main__":
    app.run(port=5003)  # Search Service는 포트 5003에서 실행
