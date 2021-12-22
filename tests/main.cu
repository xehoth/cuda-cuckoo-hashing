//
// Created by xehoth on 2021/12/11.
//
//#include "insert/test.cuh"
//#include "lookup/test.cuh"
//#include "size/test.cuh"
//#include "bound/test.cuh"
//#include "correctness/test.cuh"
#include <cstdio>
#include <cstdlib>

int main() {
  freopen("test.log", "w", stderr);
#ifdef _WIN32
  system("main_test1");
  system("main_test2");
  system("main_test3");
  system("main_test4");
#else
  system("./main_test1");
  system("./main_test2");
  system("./main_test3");
  system("./main_test4");
#endif
  return 0;
}
