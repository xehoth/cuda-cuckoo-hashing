with open("../test.txt") as f:
    l = f.readlines()
    for i in range(len(l)):
        l[i] = l[i].split()
        print(f'{i} & 3 & {l[i][0]} & {l[i][1]} & {l[i][2]} ' + r'\\')

    