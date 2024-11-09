import csv
import redis
import json

host = 'k11a306.p.ssafy.io'
# host = 'localhost'

r = redis.StrictRedis(host=host, port=6379, db=0, password='ssafy!a306')
with open('./resources/gyeonggi_busdata.CSV', 'r', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    route_data = {}

    for row in reader:
        route_id = row['ROUTEID']
        coordinates = {"latitude": float(row['Y좌표']), "longitude": float(row['X좌표'])}

        if route_id not in route_data:
            route_data[route_id] = []

        route_data[route_id].append(coordinates)

    for route_id, coords in route_data.items():
        r.delete(route_id)
        r.set(route_id, json.dumps(coords))  # JSON으로 직렬화하여 저장
        print(route_id, r.get(route_id))

# 노선명,ROUTEID,gpsX,gpsY,no
with open('./resources/route_gps_data.csv', 'r', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    route_data = {}
    for row in reader:
        route_id = row['ROUTEID']
        coordinates = {"latitude": float(row['gpsX']), "longitude": float(row['gpsY'])}

        if route_id not in route_data:
            route_data[route_id] = []

        route_data[route_id].append(coordinates)

    for route_id, coords in route_data.items():
        r.delete(route_id)
        r.set(route_id, json.dumps(coords))  # JSON으로 직렬화하여 저장
        print(route_id, r.get(route_id))

print("CSV 데이터를 Redis에 JSON 배열 형식으로 성공적으로 저장했습니다.")