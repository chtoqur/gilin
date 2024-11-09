import requests
import csv
import os
import xml.etree.ElementTree as ET

API_URL = "http://ws.bus.go.kr/api/rest/busRouteInfo/getRoutePath"
API_KEY = os.getenv("API_KEY_1")

ROUTE_FILE_PATH = "./resources/routeId.csv"
OUTPUT_FILE_PATH = "./resources/route_gps_data.CSV"
LOG_FILE_PATH = "./resources/completed_routes.csv"

def fetch_route_data(route_id):
    params = {
        "serviceKey": API_KEY,
        "busRouteId": route_id
    }
    response = requests.get(API_URL, params=params)
    response.raise_for_status()
    return response.content


def parse_route_data(xml_data):
    root = ET.fromstring(xml_data)
    gps_data = []

    for item in root.findall(".//msgBody/itemList"):
        gpsX = item.find("gpsX").text
        gpsY = item.find("gpsY").text
        no = item.find("no").text
        gps_data.append((gpsX, gpsY, no))

    return gps_data


def load_completed_routes(log_file_path):
    if os.path.exists(log_file_path):
        with open(log_file_path, "r") as log_file:
            return set(line.strip() for line in log_file)
    return set()


def save_completed_route(log_file_path, route_id):
    """Log the completed route ID to prevent redundant API calls."""
    with open(log_file_path, "a") as log_file:
        log_file.write(f"{route_id}\n")


def main():
    # Load completed routes to avoid redundant API calls
    completed_routes = load_completed_routes(LOG_FILE_PATH)

    with open(ROUTE_FILE_PATH, "r", encoding="utf-8") as route_file, open(OUTPUT_FILE_PATH, "w", newline="",
                                                                          encoding="utf-8") as output_file:
        route_reader = csv.DictReader(route_file)
        output_writer = csv.writer(output_file)

        # Write header for output CSV
        output_writer.writerow(["노선명", "ROUTEID", "gpsX", "gpsY", "no"])

        for row in route_reader:
            route_name = row["노선명"]
            route_id = row["ROUTEID"]

            if route_id in completed_routes:
                print(f"Skipping completed route: {route_name} (ROUTEID: {route_id})")
                continue

            try:
                xml_data = fetch_route_data(route_id)
                print(xml_data)
                gps_data = parse_route_data(xml_data)

                for gpsX, gpsY, no in gps_data:
                    print(gpsX, gpsY)
                    output_writer.writerow([route_name, route_id, gpsX, gpsY, no])

                save_completed_route(LOG_FILE_PATH, route_id)
                print(f"Successfully processed route: {route_name} (ROUTEID: {route_id})")

            except Exception as e:
                print(f"Error processing route {route_name} (ROUTEID: {route_id}): {e}")


if __name__ == "__main__":
    main()
