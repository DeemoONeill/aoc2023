# %%
import matplotlib.pyplot as plt


def plot_race(time, distance):
    x = list(range(0, time + 1))
    time_held = range(0, time + 1)
    time_left = range(time + 1, -1, -1)

    y = [(held * left) - distance for held, left in zip(time_held, time_left)]
    print(y)

    plot = plt.scatter(x, y, marker="x")
    plot.ylim(-10)


plot_race(71530, 940200)

# %%
