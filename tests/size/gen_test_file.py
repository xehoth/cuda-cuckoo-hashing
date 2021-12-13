def gen(i, n_h):
    header = '''//
// Created by xehoth on 2021/12/12.
//
#include "test.cuh"
'''
    func = f'std::string do_test3_{i}_{n_h}() ' + '{' + \
           f' return do_test3<static_cast<std::uint32_t>((1 << 24) * {i/100:.2f} + 1 - 1e-10), {n_h}>(); ' \
           + '}'
    with open(f'test_{i}_{n_h}.cu', 'w') as f:
        print(header + func, file=f)

for i in range(110, 201, 10):
    for n_h in range(2, 4):
        gen(i, n_h)
gen(101, 2)
gen(102, 2)
gen(105, 2)
gen(101, 3)
gen(102, 3)
gen(105, 3)