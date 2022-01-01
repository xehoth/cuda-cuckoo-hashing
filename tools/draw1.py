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

x = [i for i in range(10, 25)]
y2060_2 = [7.446709, 37.200651, 76.472696, 185.561035, 227.859371, 320.661368, 572.194902, 658.499736, 773.983850, 743.422896, 848.028746, 782.824122, 818.832553, 740.279704, 678.550312]
y2060_3 = [21.214532, 44.071065, 90.026727, 164.018451, 258.638111, 371.984887, 559.348878, 659.666305, 750.733137, 846.473374, 784.772035, 848.118706, 832.881107, 807.912957, 736.136639]
yA100_2 = [44.211108, 73.613987, 143.465591, 286.802600, 545.028746, 1055.452489, 1730.606726, 2829.120113, 3867.799868, 4452.415964, 4918.495447, 5072.681438, 5057.063274, 4773.093010, 4252.760722]
yA100_3 = [34.453057, 67.100022, 142.793397, 283.248506, 551.724145, 1073.600350, 1609.303782, 2755.651233, 3661.065435, 4495.664528, 5094.368927, 5352.674049, 5335.417389, 5063.862307, 4570.751084]

plt.plot(x, y2060_2, '-o', color='green', label='$t = 2$, RTX 2060 SUPER')
plt.plot(x, y2060_3, '-o', color='purple', label='$t = 3$, RTX 2060 SUPER')
draw_max(x, y2060_3)
plt.plot(x, yA100_2, '-o', color='blue', label='$t = 2$, TESLA A100')
draw_max(x, yA100_2)
plt.plot(x, yA100_3, '-o', color='red', label='$t = 3$, TESLA A100')
draw_max(x, yA100_3)
plt.title("Insertion Performance")
plt.xticks(x)
plt.xlabel("Insert Set Size: $2^s$")
plt.ylabel("MOPS")
plt.legend()
plt.savefig("1.png")
plt.show()