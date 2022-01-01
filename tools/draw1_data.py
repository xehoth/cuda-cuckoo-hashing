with open("../test.txt") as f:
    l = f.readlines()
    print(", ".join([i.split()[0] for i in l]))
