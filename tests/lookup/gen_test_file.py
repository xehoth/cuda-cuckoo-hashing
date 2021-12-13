for i in range(11):
    for n_h in range(2, 4):
        header = '''//
// Created by xehoth on 2021/12/12.
//
#include "test.cuh"
'''
        func = f'std::string do_test2_{i}_{n_h}() ' + '{' + f' return do_test2<{i}, {n_h}>(); ' + '}'
        with open(f'test_{i}_{n_h}.cu', 'w') as f:
            print(header + func, file=f)
