//
// Created by xehoth on 2021/12/22.
//
#include "insert/test.cuh"
#include "correctness/test.cuh"

int main() {
  do_correctness_test();
  do_test1_all();
  RandomSetGenerator<(1 << 24)>::get()->free();
  return 0;
}