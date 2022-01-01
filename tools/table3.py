with open("../test.txt") as f:
    l = f.readlines()
    l = list(reversed(l))
    for i in range(len(l)):
        l[i] = l[i].split()
        print(f'{2 - i / 10:.1f} & 3 & {l[i][0]} & {l[i][1]} & {l[i][2]} ' + r'\\')

    