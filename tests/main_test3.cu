//
// Created by xehoth on 2021/12/22.
//
#include "size/test.cuh"
#include "correctness/test.cuh"

int main() {
  do_correctness_test();
  do_test3_all();
  return 0;
}