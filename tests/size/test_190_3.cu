//
// Created by xehoth on 2021/12/12.
//
#include "test.cuh"
std::string do_test3_190_3() { return do_test3<static_cast<std::uint32_t>((1 << 24) * 1.90 + 1 - 1e-10), 3>(); }
