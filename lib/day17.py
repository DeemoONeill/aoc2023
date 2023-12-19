import networkx as nx

example = """2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533"""

dic = {}

for y, row in enumerate(example.split("\n")):
    for x, weight in enumerate(row):
        dic[(x, y)] = int(weight)

max_y = y
max_x = x

DG = nx.DiGraph()

up = (-1, 0)
down = (1, 0)
left = (0, -1)
right = (0, 1)

max_weight = max(dic.values())
print(max_weight)

for x, y in dic:
    keys = [(x + x2, y + y2) for (x2, y2) in [up, down, left, right]]
    next_nodes = {k: dic.get(k) for k in keys if dic.get(k)}
    DG.add_weighted_edges_from(
        [((x, y), key, value) for key, value in next_nodes.items()]
    )


changed = True
while changed:
    path = nx.shortest_path(DG, (0, 0), (max_x, max_y), weight="weight")
    for nodes in zip(path[0:], path[1:], path[2:], path[3:]):
        node1, *rest = nodes
        if all(node[0] == node1[0] for node in rest) or all(
            node[1] == node1[1] for node in rest
        ):
            DG.remove_edge(rest[-2], rest[-1])
            break
    else:
        changed = False

print(path)
print(sum(dic.get(node) for node in path[1:]))
