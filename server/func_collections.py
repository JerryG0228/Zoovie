import os
from dotenv import load_dotenv
import requests
import json

# .env 파일 로드
load_dotenv()

# API 토큰
token = os.getenv('API_TOKEN')
# 이미지 URL
baseUrl = "https://image.tmdb.org/t/p/w1280/"

# API 요청 헤더
headers = {
    "accept": "application/json",
    "Authorization": f"Bearer {token}"
}


# 현재 상영중인 영화 또는 방영중인 TV 프로그램 데이터
def nowPlaying(media, page):
    if media == "movie":
        url = f"https://api.themoviedb.org/3/movie/now_playing?language=ko-KR&page={page}"
    elif media == "tv":
        url = f"https://api.themoviedb.org/3/tv/airing_today?language=ko-KR&page={page}"
    else:
        return []

    response = requests.get(url, headers=headers)
    data = json.loads(response.text)

    # 필요한 데이터만 추출
    if media == "movie":
        results = [
            {"id": result["id"], "poster_path": baseUrl + result["poster_path"], "vote_average": result["vote_average"]}
            for result in data.get('results', [])]
    elif media == "tv":
        results = [
            {"id": result["id"], "poster_path": baseUrl + result["poster_path"], "vote_average": result["vote_average"]}
            for result in data.get('results', [])]
    return results


# 인기 있는 영화 또는 TV 프로그램 데이터
def popular(media, page):
    url = f"https://api.themoviedb.org/3/{media}/popular?language=ko-KR&page={page}"

    response = requests.get(url, headers=headers)
    data = json.loads(response.text)

    if media == "movie":
        results = [
            {"id": result["id"], "poster_path": baseUrl + result["poster_path"], "release_date": result["release_date"]}
            for result in data.get('results', [])]
    elif media == "tv":
        results = [
            {"id": result["id"], "poster_path": baseUrl + result["poster_path"],
             "first_air_date": result["first_air_date"]}
            for result in data.get('results', [])]
    return results


# 높은 평가 받은 영화 또는 TV 프로그램 데이터
def topRated(media, page):
    url = f"https://api.themoviedb.org/3/{media}/top_rated?language=ko-KR&page={page}"

    response = requests.get(url, headers=headers)
    data = json.loads(response.text)
    results = [
        {"id": result["id"], "poster_path": baseUrl + result["poster_path"], "vote_average": result["vote_average"]}
        for result in data.get('results', [])]
    return results


# 개봉 예정 영화 또는 방영 예정 TV 프로그램 데이터
def upcoming(media, page):
    if media == "movie":
        url = f"https://api.themoviedb.org/3/movie/upcoming?language=ko-KR&page={page}"
    elif media == "tv":
        url = f"https://api.themoviedb.org/3/tv/on_the_air?language=ko-KR&page={page}"
    else:
        return []

    response = requests.get(url, headers=headers)
    data = json.loads(response.text)
    results = [
        {"id": result["id"], "poster_path": baseUrl + result["poster_path"], "vote_average": result["vote_average"],
         "vote_count": result["vote_count"]} for result in data.get('results', [])]
    return results


def getDataById(media, id):
    result = {}
    stillcut_url = f"https://api.themoviedb.org/3/{media}/{id}/images"
    detail_url = f"https://api.themoviedb.org/3/{media}/{id}?language=ko-KR"
    credit_url = f"https://api.themoviedb.org/3/{media}/{id}/credits?language=ko-KR"
    provider_url = f"https://api.themoviedb.org/3/{media}/{id}/watch/providers"

    stillcut_response = requests.get(stillcut_url, headers=headers)
    detail_response = requests.get(detail_url, headers=headers)
    credit_response = requests.get(credit_url, headers=headers)
    provider_response = requests.get(provider_url, headers=headers)
    stillcut_data = json.loads(stillcut_response.text)
    detail_data = json.loads(detail_response.text)
    credit_data = json.loads(credit_response.text)
    provider_data = json.loads(provider_response.text)

    # provider 로고 이미지 경로 수집
    provider_logo_path = set()
    for country_data in provider_data["results"].values():
        for category in ["buy", "rent"]:
            if category in country_data:
                for provider in country_data[category]:
                    provider_logo_path.add(provider["logo_path"])

    # 필요한 데이터만 추출
    result["stillcuts"] = [{"file_path": stillcut_data["backdrops"][i]["file_path"]} for i in range(10)]
    result["poster_path"] = baseUrl + detail_data["poster_path"]
    result["overview"] = detail_data["overview"]
    result["vote_average"] = detail_data["vote_average"]
    if media == "movie":
        result["budget"] = detail_data["budget"]
        result["revenue"] = detail_data["revenue"]
        result["runtime"] = detail_data["runtime"]
    elif media == "tv":
        result["seasons"] = detail_data["seasons"]
        result["status"] = detail_data["status"]
    result["cast"] = [{"name": cast["name"], "character": cast["character"], "profile_path": cast["profile_path"]}
                      for cast in credit_data["cast"] if cast["profile_path"] is not None]
    result["providers"] = list(provider_logo_path)
    return result


# 키워드에 해당하는 영화, TV 프로그램 데이터
def getDatabyKeyword(keyword, page):
    url = f"https://api.themoviedb.org/3/search/multi?query={keyword}&include_adult=true&language=ko-KR&page={page}"

    response = requests.get(url, headers=headers)
    data = json.loads(response.text)
    results = {
        "page": data["page"],
        "total_pages": data["total_pages"],
        "results": [{"id": item["id"], "poster_path": baseUrl + item["poster_path"]} for item in data["results"]]
    }
    return results
