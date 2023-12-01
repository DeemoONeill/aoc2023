import re

WORDS = "one,two,three,four,five,six,seven,eight,nine".split(",")
WORD_TO_NUMBER = dict(zip(WORDS, map(str, range(1, 10))))


def convert_to_number(line, regex):
    matches = regex.findall(line)
    first = matches[0]
    last = matches[-1]
    return int(WORD_TO_NUMBER.get(first, first) + WORD_TO_NUMBER.get(last, last))


def parts(lines, regex):
    return sum(convert_to_number(line, regex) for line in lines)


def main():
    digit_match = re.compile(r"(\d)")
    number_match = re.compile(rf"(?=(\d|{'|'.join(WORDS)}))")
    with open("inputs/day1.txt") as f:
        lines = f.readlines()
    print("part 1:", parts(lines, digit_match))
    print("part 2:", parts(lines, number_match))


if __name__ == "__main__":
    main()
