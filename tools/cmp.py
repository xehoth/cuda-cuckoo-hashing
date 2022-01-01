import matplotlib.pyplot as plt
import numpy as np
X = np.array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
Y1 = [5352.674049, 848.118706,   430.3913, 239.674514, 214.982265, 593.34606]
Y2 = [10944.190395, 1866.584072, 763.3371, 300.666953, 812.304685, 643.670837]

w = 0.4
offset = w / 2 + 0.02

plt.bar(X - offset, Y1, width=0.4, facecolor='lightskyblue', edgecolor='white', label='insert')
plt.bar(X + offset, Y2, width=0.4, facecolor='yellowgreen', edgecolor='white', label='lookup')

def draw_text(str, x, y, offset, fontsize=8.5):
    plt.text(x, y, str, ha='center', va='bottom', fontsize=fontsize)

for x, y in zip(X - offset, Y1):
    draw_text(f'{y:.2f}', x, y, 0)

for x, y in zip(X + offset, Y2):
    draw_text(f'{y:.2f}', x, y, 0)
plt.title("Performance Comparison with Some Open Source Codes (on NVIDIA RTX 2060 SUPER)")
plt.ylabel("MOPS")
plt.xlabel("code")
plt.xticks(range(1, len(X) + 1), ["My@A100", "My", "chibinz", "josehu07", "victoryang00", "xiezhq-hermann"], size='small')
plt.legend()
plt.show()
