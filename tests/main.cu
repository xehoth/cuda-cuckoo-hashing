//
// Created by xehoth on 2021/12/11.
//
#include "insert/test.cuh"
#include "lookup/test.cuh"
#include "size/test.cuh"
#include "bound/test.cuh"
#include "correctness/test.cuh"
#include <cstdio>

int main() {
  freopen("test.log", "w", stderr);
  do_correctness_test();
  do_test1_all();
  do_test2_all();
  do_test3_all();
  do_test4_all();
  return 0;
}
