import numpy as np
from math import prod


def part1(time, distance):
    times = map(int, time.split()[1:])
    distances = map(int, distance.split()[1:])

    return prod(calculate(time, distance) for time, distance in zip(times, distances))


def part2(time, distance):
    time = int("".join(time.split()[1:]))
    distance = int("".join(distance.split()[1:]))
    return calculate(time, distance)


def calculate(time, distance):
    arr = np.arange(0, time, 1, dtype=np.uint64)
    arr = arr * (time - arr)
    return len(arr[arr > distance])


def main():
    with open("inputs/day6.txt") as f:
        time, distance = f.readlines()
    print("part 1", part1(time, distance))
    print("part 2", part2(time, distance))


if __name__ == "__main__":
    main()
