import pandas as pd
import heapq

# Load the nodes and edges data
nodes_df = pd.read_csv('./resources/nodes.csv')
edges_df = pd.read_csv('./resources/edges.csv')

TRANSFER_PENALTY = 1111111


class Node:
    def __init__(self, node_id, latitude, longitude, station_name):
        self.node_id = node_id
        self.latitude = latitude
        self.longitude = longitude
        self.station_name = station_name
        self.edges = []


class Edge:
    def __init__(self, to_node, weight, route_id, bus_number, from_ars_id):
        self.to_node = to_node
        self.weight = weight
        self.route_id = route_id
        self.bus_number = bus_number
        self.from_ars_id = from_ars_id


def load_custom_graph(nodes_df, edges_df):
    nodes = {}
    for _, row in nodes_df.iterrows():
        nodes[row['node_id']] = Node(row['node_id'], row['latitude'], row['longitude'], row['station_name'])

    for _, row in edges_df.iterrows():
        from_node = row['from_node']
        to_node = row['to_node']
        edge = Edge(to_node, row['distance'], row['route_id'], row['bus_number'], row['from_ars_id'])
        nodes[from_node].edges.append(edge)

    return nodes


# Function to find station IDs by station name
def find_station_ids(nodes, station_name):
    return [node_id for node_id, node in nodes.items() if station_name in node.station_name]


def find_min_transfer_paths(nodes, start, end, transfer_penalty, max_paths=5):
    queue = [(0, 0, start, None, [], None)]  # (path_weight, transfers, current_node, current_route, path, current_bus)
    visited = {}
    best_paths = []
    best_weight = float('inf')

    while queue:
        if len(best_paths) >= max_paths:
            break

        path_weight, transfers, current_node, current_route, path, current_bus = heapq.heappop(queue)

        if current_node == end:
            if path_weight < best_weight:
                best_paths = [(path + [(end, current_bus)], path_weight)]
                best_weight = path_weight
            elif path_weight == best_weight:
                best_paths.append((path + [(end, current_bus)], path_weight))
            continue

        if (current_node, current_route) in visited and visited[(current_node, current_route)] <= path_weight:
            continue

        visited[(current_node, current_route)] = path_weight

        for edge in nodes[current_node].edges:
            next_node = edge.to_node
            next_route = edge.route_id
            next_bus = edge.bus_number
            distance = edge.weight
            next_path = path + [(current_node, current_bus)]

            if current_route is None or current_route == next_route:
                next_weight = path_weight + distance
                next_transfers = transfers
            else:
                next_weight = path_weight + distance + transfer_penalty
                next_transfers = transfers + 1

            heapq.heappush(queue, (next_weight, next_transfers, next_node, next_route, next_path, next_bus))

    return best_paths


# Main function to run the pathfinding
def main(start_station, end_station):
    nodes = load_custom_graph(nodes_df, edges_df)
    start_station_ids = find_station_ids(nodes, start_station)
    end_station_ids = find_station_ids(nodes, end_station)

    all_best_paths = []
    for start_id in start_station_ids:
        for end_id in end_station_ids:
            paths = find_min_transfer_paths(nodes, start_id, end_id, TRANSFER_PENALTY, max_paths=5)
            all_best_paths.extend(paths)

    if all_best_paths:
        result = {
            "paths": [
                {
                    "route": [(nodes[u].station_name, u, bus) for u, bus in path],
                    "total_weight": weight
                }
                for path, weight in all_best_paths
            ]
        }
    else:
        result = "There is no path between {} and {} with the given constraints.".format(start_station, end_station)

    return result


def print_result(result):
    if isinstance(result, dict) and "paths" in result:
        print(f"Found {len(result['paths'])} optimal paths:\n")
        for i, path_info in enumerate(result["paths"], start=1):
            print(f"Path {i}:")
            for station_name, node_id, bus_number in path_info["route"]:
                bus_info = f"(Bus {bus_number})" if bus_number else "(Walking)"
                print(f"  {station_name} {bus_info}")
            print(f"  Total Weight: {path_info['total_weight']}\n")
    else:
        print(result)


main_result = main('정금마을', '대한사회복지회')
print_result(main_result)
