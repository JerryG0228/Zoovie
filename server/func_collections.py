import os
from dotenv import load_dotenv
import requests
import json
from datetime import datetime

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

# 현재 날짜 (api 요청시 사용)
current_date = datetime.now().strftime("%Y-%m-%d")
decade_date = (datetime.now().replace(year=datetime.now().year - 10)).strftime("%Y-%m-%d")
double_month_date = (datetime.now().replace(year=datetime.now().month + 2)).strftime("%Y-%m-%d")


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
    url = f"https://api.themoviedb.org/3/discover/{media}?page={page}&include_adult=false&include_video=false&language=ko-KR&sort_by=popularity.desc&primary_release_date.gte={decade_date}&primary_release_date.lte={current_date}"

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
        url = f"https://api.themoviedb.org/3/discover/movie?page={page}&language=ko-KR&sort_by=popularity.desc&primary_release_date.gte={current_date}&primary_release_date.lte={double_month_date}"
    elif media == "tv":
        url = f"https://api.themoviedb.org/3/discover/tv?page={page}&language=ko-KR&sort_by=popularity.desc&first_air_date.gte={current_date}&first_air_date.lte={double_month_date}"
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
    logo_url = f"https://api.themoviedb.org/3/{media}/{id}/images?language=en"

    stillcut_response = requests.get(stillcut_url, headers=headers)
    detail_response = requests.get(detail_url, headers=headers)
    credit_response = requests.get(credit_url, headers=headers)
    provider_response = requests.get(provider_url, headers=headers)
    logo_response = requests.get(logo_url, headers=headers)

    stillcut_data = json.loads(stillcut_response.text)
    detail_data = json.loads(detail_response.text)
    credit_data = json.loads(credit_response.text)
    provider_data = json.loads(provider_response.text)
    logo_data = json.loads(logo_response.text)

    # provider_data에서 results 키가 있는지 확인
    if "results" in provider_data:
        provider_logo_path = set()
        for country_data in provider_data["results"].values():
            for category in ["buy", "rent"]:
                if category in country_data:
                    for provider in country_data[category]:
                        provider_logo_path.add(provider["logo_path"])
    else:
        # results 키가 없는 경우 빈 플랫폼 리스트 반환
        platforms = []

    # 필요한 데이터만 추출
    result["stillcuts"] = [{"file_path": backdrop["file_path"]} for backdrop in stillcut_data.get("backdrops", [])[:10]]
    result["poster_path"] = baseUrl + detail_data["poster_path"]
    result["overview"] = detail_data["overview"]
    result["vote_average"] = detail_data["vote_average"]
    result["logo_path"] = baseUrl + logo_data["logos"][0]["file_path"] if logo_data["logos"] else None
    if media == "movie":
        result["title"] = detail_data["title"]
        result["budget"] = detail_data["budget"]
        result["revenue"] = detail_data["revenue"]
        result["runtime"] = detail_data["runtime"]
    elif media == "tv":
        result["name"] = detail_data["name"]
        result["seasons"] = detail_data["seasons"]
        result["status"] = detail_data["status"]
    result["cast"] = [{"name": cast["name"], "character": cast["character"], "profile_path": cast["profile_path"]}
                      for cast in credit_data["cast"] if cast["profile_path"] is not None]
    result["providers"] = list(provider_logo_path)
    result["id"] = id
    result["media_type"] = media
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


# 키워드 검색
def getKeyword(media, id):
    url = f"https://api.themoviedb.org/3/{media}/{id}/keywords"

    response = requests.get(url, headers=headers)
    data = json.loads(response.text)

    results = [{"id": keyword["id"], "name": keyword["name"]} for keyword in data.get("keywords", [])]
    return results


# 비슷한 영화 or TV 프로그램 데이터
def getSimilar(media, id):
    url = f"https://api.themoviedb.org/3/{media}/{id}/similar?language=ko-KR&page=1"

    response = requests.get(url, headers=headers)
    results = json.loads(response.text)

    return results
