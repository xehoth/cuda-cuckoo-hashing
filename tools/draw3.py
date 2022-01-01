import matplotlib.pyplot as plt

def get_max(l):
    val = max([(l[i], i) for i in range(len(l))])
    return val[1], val[0]

def draw_text(str, x, y, offset, fontsize=10.5):
    plt.text(x, y, str, ha='center', va='bottom', fontsize=fontsize)

def draw_max(x, y):
    idx, val = get_max(y)
    x_val = x[idx]
    y_val = val
    str = f'{y_val:.2f}'
    draw_text(str, x_val, y_val, 0)

NAN = float('nan')

x = [1.01, 1.02, 1.05, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0]

y2060_2 = [0, 0, 0, 259.893430, 607.410984, 631.628612, 644.583205, 658.699933, 682.258901, 354.465352, 699.033878, 707.180415, 718.569511]
y2060_3 = [622.909822, 624.410461, 639.108578, 641.431637, 651.055876, 665.923213, 663.355432, 692.596413, 697.417215, 715.366934, 724.240721, 710.266831, 720.760163]
yA100_2 = [0, 0, 0, 3738.228285, 3886.171126, 3994.070087, 4071.855181, 4288.401832, 4367.152402, 2150.872191, 4444.836303, 4473.218103, 4495.988473]
yA100_3 = [4328.415614, 4364.069773, 4381.700577, 4416.581690, 4452.022667, 4483.699920, 4518.867180, 4539.911130, 4556.363571, 4583.313615, 4595.526630, 4615.325053, 4624.068615]

plt.plot(x, y2060_2, '-o', color='green', label='$t = 2$, RTX 2060 SUPER')
plt.plot(x, y2060_3, '-o', color='purple', label='$t = 3$, RTX 2060 SUPER')
draw_max(x, y2060_3)
plt.plot(x, yA100_2, '-o', color='blue', label='$t = 2$, TESLA A100')
plt.plot(x, yA100_3, '-o', color='red', label='$t = 3$, TESLA A100')
draw_max(x, yA100_3)
plt.title("Size Experiment")
# plt.xticks(x)
plt.xlabel(r"Size: $\alpha n$")
plt.ylabel("MOPS")
plt.legend()
plt.savefig("3.png")
plt.show()