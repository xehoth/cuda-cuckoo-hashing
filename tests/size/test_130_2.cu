//
// Created by xehoth on 2021/12/12.
//
#include "test.cuh"
std::string do_test3_130_2() { return do_test3<static_cast<std::uint32_t>((1 << 24) * 1.30 + 1 - 1e-10), 2>(); }
