import re

def parts(lines, regex):
    map_ = dict(zip("one,two,three,four,five,six,seven,eight,nine".split(","), map(str, range(1,10))))

    total = 0
    for line in lines:
        matches = regex.findall(line)
        first = matches[0]
        last = matches[-1]
        total += int(map_.get(first, first) + map_.get(last, last))
    print(total)

def main():
    digit_match = re.compile(r"(\d)")
    number_match = re.compile(r"(?=(\d|one|two|three|four|five|six|seven|eight|nine))")
    with open("inputs/day1.txt") as f:
        lines = f.readlines()
    parts(lines, digit_match)
    parts(lines, number_match)

if __name__ == "__main__":
    main()
