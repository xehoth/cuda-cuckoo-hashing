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

x = [0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.4, 3.6, 4.8, 7.2, 9.6, 14.4, 19.2]

y2060_2 = [0, 0, 0, 0, 0, 0, 657.483519, 646.936886, 641.007204, 620.847396, 658.149056, 659.814903, 661.132839, 658.687197, 644.927489, 641.568838, 634.861433, 643.584807]
y2060_3 = [0, 693.425597, 693.467047, 690.305337, 693.034023, 693.265324, 681.274671, 693.066273, 693.658439, 691.121569, 685.183113, 665.937249, 684.540419, 693.442664, 692.317996, 691.614976, 692.744288, 693.520618]
yA100_2 = [0, 0, 0, 0, 0, 0, 4336.226983, 4336.965930, 4329.588092, 4331.934797, 4335.932864, 4336.851103, 4328.079694, 4336.937169, 4331.211905, 4336.786582, 4333.388402, 4329.037487]
yA100_3 = [0, 4516.142393, 4516.943821, 4511.129706, 4511.479023, 4514.874533, 4511.129590, 4511.533343, 4511.595532, 4509.577610, 4509.236274, 4513.382040, 4510.206033, 4512.162369, 4511.051972, 4512.240083, 4506.902747, 4513.622961]
s = 3
plt.plot(x, y2060_2, '-o', color='green', label='$t = 2$, RTX 2060 SUPER', markersize=s)
plt.plot(x, y2060_3, '-o', color='purple', label='$t = 3$, RTX 2060 SUPER', markersize=s)
draw_max(x, y2060_3)
plt.plot(x, yA100_2, '-o', color='blue', label='$t = 2$, TESLA A100', markersize=s)
plt.plot(x, yA100_3, '-o', color='red', label='$t = 3$, TESLA A100', markersize=s)
draw_max(x, yA100_3)
plt.title("Bound Experiment")
# plt.xticks(x)
plt.xlabel(r"Size: $\alpha n$")
plt.ylabel("MOPS")
plt.legend()
plt.savefig("4.png")
plt.show()