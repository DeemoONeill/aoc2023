with open("day10") as f:
    data = [tuple(map(int, line.split(","))) for line in f]

max_x, min_x = (
    max(data, key=lambda point: point[0])[0],
    min(data, key=lambda point: point[0])[0],
)
max_y, min_y = (
    max(data, key=lambda point: point[1])[1],
    min(data, key=lambda point: point[1])[1],
)

print(min_x, min_y, max_x, max_y)

visited = set(data)
contained = set()


def fill(x, y):
    dirs = [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]
    dirs = [dir for dir in dirs if dir not in visited]

    for direction in dirs:
        stack = [direction]
        current = []
        while stack:
            point = stack.pop()
            x, y = point
            if point in visited or x < min_x or x > max_x or y < min_y or y > max_y:
                continue
            current.append(point)
            visited.add(point)
            stack.extend([(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)])
        if current:
            contained.add(tuple(sorted(current)))


for point in data:
    fill(*point)

print(sum([len(points) for points in filter(lambda x: len(x) < 20, contained)]))
