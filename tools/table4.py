x = [0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.4, 3.6, 4.8, 7.2, 9.6, 14.4, 19.2]

with open("../test.txt") as f:
    l = f.readlines()
    for i in range(len(l)):
        l[i] = l[i].split()
        print(f'{x[i]:.1f} & 3 & {l[i][0]} & {l[i][1]} & {l[i][2]} ' + r'\\')

    