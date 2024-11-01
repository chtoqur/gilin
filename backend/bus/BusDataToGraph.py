import pandas as pd
import networkx as nx
import math

file_path = './resources/busdata.CSV'

bus_data = pd.read_csv(file_path)

G = nx.Graph()


def haversine(lat1, lon1, lat2, lon2):
    R = 6371000  # 지구 반지름 (미터)
    phi1 = math.radians(lat1)
    phi2 = math.radians(lat2)
    delta_phi = math.radians(lat2 - lat1)
    delta_lambda = math.radians(lon2 - lon1)

    a = math.sin(delta_phi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2) ** 2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    return R * c


edges = []
for route_id, route_stops in bus_data.groupby('route_id'):
    route_stops = route_stops.sort_values('order')

    previous_stop = None
    for _, stop in route_stops.iterrows():
        G.add_node(stop['node_id'], latitude=stop['latitude'], longitude=stop['longitude'],
                   station_name=stop['station_name'])

        if previous_stop is not None:
            distance = haversine(
                previous_stop['latitude'], previous_stop['longitude'],
                stop['latitude'], stop['longitude']
            )

            G.add_edge(previous_stop['node_id'], stop['node_id'], weight=distance, route_id=route_id)
            edges.append([
                previous_stop['node_id'],  # 출발 정류장
                stop['node_id'],  # 도착 정류장
                distance,  # 거리
                route_id,  # 노선 ID
                stop['route_name'],  # 버스 번호
                previous_stop['ars_id']  # 출발 정류장의 ars_id
            ])

        previous_stop = stop

nodes_data = pd.DataFrame({
    'node_id': list(G.nodes),
    'latitude': [G.nodes[node]['latitude'] for node in G.nodes],
    'longitude': [G.nodes[node]['longitude'] for node in G.nodes],
    'station_name': [G.nodes[node]['station_name'] for node in G.nodes]
})

edges_data = pd.DataFrame(edges, columns=['from_node', 'to_node', 'distance', 'route_id', 'bus_number', 'from_ars_id'])

nodes_data.to_csv('./resources/nodes.csv', index=False)
edges_data.to_csv('./resources/edges.csv', index=False)

print("Nodes and edges with route, bus number, and ars_id information saved to CSV files successfully.")
