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

x = [i for i in range(0, 11)]
y2060_2 = [1866.584072, 1761.835282, 1668.597444, 1584.623803, 1506.272597, 1433.399665, 1367.833913, 1306.748787, 1249.908829, 1197.400414, 1146.550585]
y2060_3 = [1843.989880, 1625.353454, 1452.115347, 1311.857373, 1194.372580, 1095.647198, 1011.771790, 939.055437, 875.845898, 820.318196, 771.261283]
yA100_2 = [10944.190395, 10225.301127, 9652.516268, 9155.470175, 8699.132169, 8272.762610, 7935.005113, 7577.905498, 7263.175951, 6966.356637, 6697.239074]
yA100_3 = [10752.596504, 9331.956724, 8307.342176, 7482.538448, 6810.226405, 6244.869361, 5768.100057, 5354.653074, 4998.941599, 4687.387080, 4413.198677]

plt.plot(x, y2060_2, '-o', color='green', label='$t = 2$, RTX 2060 SUPER')
draw_max(x, y2060_2)
plt.plot(x, y2060_3, '-o', color='purple', label='$t = 3$, RTX 2060 SUPER')
plt.plot(x, yA100_2, '-o', color='blue', label='$t = 2$, TESLA A100')
draw_max(x, yA100_2)
plt.plot(x, yA100_3, '-o', color='red', label='$t = 3$, TESLA A100')
plt.title("Lookup Performance")
plt.xticks(x)
plt.xlabel("Lookup Set Type: $i$")
plt.ylabel("MOPS")
plt.legend()
plt.savefig("2.png")
plt.show()