//
// Created by xehoth on 2021/12/22.
//
#include "lookup/test.cuh"
#include "correctness/test.cuh"

int main() {
  do_correctness_test();
  do_test2_all();
  return 0;
}