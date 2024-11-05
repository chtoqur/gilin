
import requests
import json


subway_lines_codes = {
    "1호선": 1,
    "2호선": 2,
    "3호선": 3,
    "4호선": 4,
    "5호선": 5,
    "6호선": 6,
    "7호선": 7,
    "8호선": 8,
    "9호선": 9,
    "GTX-A": 91,
    "공항철도": 101,
    "자기부상철도": 102,
    "경의중앙선": 104,
    "에버라인": 107,
    "경춘선": 108,
    "신분당선": 109,
    "의정부경전철": 110,
    "경강선": 112,
    "우이신설선": 113,
    "서해선": 114,
    "김포골드라인": 115,
    "수인분당선": 116,
    "신림선": 117,
    "인천 1호선": 21,
    "인천 2호선": 22,
    "대전 1호선": 31,
    "대구 1호선": 41,
    "대구 2호선": 42,
    "대구 3호선": 43,
    "광주 1호선": 51,
    "부산 1호선": 71,
    "부산 2호선": 72,
    "부산 3호선": 73,
    "부산 4호선": 74,
    "동해선": 78,
    "부산-김해경전철": 79
}


# API 키와 기본 URL 설정
API_KEY = ''  
BASE_URL = 'https://api.odsay.com/v1/api/loadLane'

# 파라미터 설정 (필요한 lang, mapObject 등 추가)
params = {
    'apiKey': API_KEY,
    'lang': '0',  # 예시로 '0'을 사용 (한국어)
    'mapObject': '126:37@2:2:99:100'  # mapObject는 좌표 정보를 넣어야 합니다 (예시)
}

# API 요청 보내기
response = requests.get(BASE_URL, params=params)

# 응답 상태 확인
if response.status_code == 200:
    # JSON 데이터를 파싱
    data = response.json()
    # 보기 쉽게 출력
    print(json.dumps(data, indent=4, ensure_ascii=False))
else:
    print(f"Error: {response.status_code}, {response.text}")
