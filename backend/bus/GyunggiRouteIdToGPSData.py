import requests
import csv
import os
import xml.etree.ElementTree as ET
import sys

API_URL_GYEONGGI = "http://apis.data.go.kr/6410000/busrouteservice/getBusRouteLineList"
API_KEYS = [
    "8bNMSXgVBuMruOkav59Ebi3f1S24GGm5ls7ojz3aapZD1nH5P2uPp4pswd8jjZVendxDhFf38ZgyJSfvlTP2nw==",
    "/VkT5deh4hwi5Oc0/SkfswbCqUNxfgJGke9jLmE3LDDGpwCgWhxIQeQZDy6J9tOJi1HddArjj+7jC5R7SeSnpg==",
    "2WrT7Qll8aYQ9AYM0+V0EVC1H9KEwYKVsbKEFeRindOeD7fIqZgDaGMIjXQA5DIcyRT7x3rfetIxRDMJi45TWg==",
    "qTWGPbDDUr2n0Y0GXkst3h1sCcxs1GTwxq8e8ZtZx74QLVX5qmoB2UYoP+GAJ/5ohXd+ObQ3wDlAgCoqu4hgWw==",
    "ax3JnG8OGMs3JsA4xYIrz/59MQBeGMdatzd4U+jQWAXWg8cVKmWJjNug6//IxOmfUgRMplrTutzEu792AxXdEA==",
    "J320H46M44xDNZI1mevkAAAgT+e7TR31eYF5QQzWJdUgD8M/9wV6a3MI9iy+Buh53RriLw0yJbUjhspTPDt7oA=="
]

GYEONGGI_ROUTE_FILE_PATH = "./resources/gyeonggiRouteId.csv"
GYEONGGI_OUTPUT_FILE_PATH = "./resources/gyeonggi_busdata.CSV"
GYEONGGI_LOG_FILE_PATH = "./resources/completed_gyeonggi_routes.csv"
GYEONGGI_DISCONTINUED_FILE_PATH = "./resources/discontinued_routes.csv"


def fetch_gyeonggi_route_data(route_id, api_key):
    params = {
        "serviceKey": api_key,
        "routeId": route_id
    }
    response = requests.get(API_URL_GYEONGGI, params=params)
    response.raise_for_status()

    if b"LIMITED_NUMBER_OF_SERVICE_REQUESTS_EXCEEDS_ERROR" in response.content:
        print("API Key Limit Error: LIMITED_NUMBER_OF_SERVICE_REQUESTS_EXCEEDS_ERROR. Trying next API key." + api_key)
        return None  # Indicate that the key limit was exceeded

    return response.content


def parse_gyeonggi_route_data(xml_data):
    root = ET.fromstring(xml_data)
    result_code_elem = root.find(".//msgHeader/resultCode")
    result_code = result_code_elem.text if result_code_elem is not None else "0"
    if result_code == "4":
        return None

    gps_data = []
    for item in root.findall(".//msgBody/busRouteLineList"):
        x = item.find("x").text if item.find("x") is not None else ""
        y = item.find("y").text if item.find("y") is not None else ""
        lineSeq = item.find("lineSeq").text if item.find("lineSeq") is not None else ""
        gps_data.append((x, y, lineSeq))

    return gps_data


def load_completed_routes(log_file_path):
    if os.path.exists(log_file_path):
        with open(log_file_path, "r") as log_file:
            return set(line.strip() for line in log_file)
    return set()


def save_completed_route(log_file_path, route_id):
    with open(log_file_path, "a") as log_file:
        log_file.write(f"{route_id}\n")


def save_discontinued_route(discontinued_file_path, route_name, route_id):
    with open(discontinued_file_path, "a", newline="", encoding="utf-8") as discontinued_file:
        writer = csv.writer(discontinued_file)
        writer.writerow([route_name, route_id])


def main():
    completed_routes = load_completed_routes(GYEONGGI_LOG_FILE_PATH)

    file_exists = os.path.isfile(GYEONGGI_OUTPUT_FILE_PATH)
    with open(GYEONGGI_ROUTE_FILE_PATH, "r", encoding="utf-8") as route_file, open(GYEONGGI_OUTPUT_FILE_PATH, "a",
                                                                                   newline="",
                                                                                   encoding="utf-8") as output_file:
        route_reader = csv.DictReader(route_file)
        output_writer = csv.writer(output_file)

        if not file_exists:
            output_writer.writerow(["노선명", "ROUTEID", "X좌표", "Y좌표", "형상 좌표 순서"])

        for row in route_reader:
            route_name = row["노선명"]
            route_id = row["노선ID"]

            if route_id in completed_routes:
                print(f"Skipping completed route: {route_name} (ROUTEID: {route_id})")
                continue

            for api_key in API_KEYS:
                try:
                    xml_data = fetch_gyeonggi_route_data(route_id, api_key)

                    if xml_data is None:
                        continue  # Try the next API key if the current one failed due to limit error

                    gps_data = parse_gyeonggi_route_data(xml_data)

                    if gps_data is None:
                        save_discontinued_route(GYEONGGI_DISCONTINUED_FILE_PATH, route_name, route_id)
                        print(f"Discontinued route: {route_name} (ROUTEID: {route_id})")
                    else:
                        for x, y, lineSeq in gps_data:
                            output_writer.writerow([route_name, route_id, x, y, lineSeq])

                    save_completed_route(GYEONGGI_LOG_FILE_PATH, route_id)
                    print(f"Successfully processed route: {route_name} (ROUTEID: {route_id})")
                    break  # Exit the API key loop if successful

                except Exception as e:
                    print(f"Error processing route {route_name} (ROUTEID: {route_id}): {e}")
                    continue  # Try the next API key if an error occurred
            else:
                print("All API keys have exceeded their limits. Terminating program.")
                sys.exit(1)


if __name__ == "__main__":
    main()
