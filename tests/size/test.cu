//
// Created by xehoth on 2021/12/13.
//
#include "test.cuh"
#include <fstream>

extern std::string do_test3_110_2();
extern std::string do_test3_120_2();
extern std::string do_test3_130_2();
extern std::string do_test3_140_2();
extern std::string do_test3_150_2();
extern std::string do_test3_160_2();
extern std::string do_test3_170_2();
extern std::string do_test3_180_2();
extern std::string do_test3_190_2();
extern std::string do_test3_200_2();
extern std::string do_test3_101_2();
extern std::string do_test3_102_2();
extern std::string do_test3_105_2();

extern std::string do_test3_110_3();
extern std::string do_test3_120_3();
extern std::string do_test3_130_3();
extern std::string do_test3_140_3();
extern std::string do_test3_150_3();
extern std::string do_test3_160_3();
extern std::string do_test3_170_3();
extern std::string do_test3_180_3();
extern std::string do_test3_190_3();
extern std::string do_test3_200_3();
extern std::string do_test3_101_3();
extern std::string do_test3_102_3();
extern std::string do_test3_105_3();

void do_test3_all() {
  printf("Size test:\n");
  printf("Result saves to size.bench\n");
  printf("%-6s%-4s%-12s%-12s%-12s\n", "size", "t", "MOPS", "mean/ms", "stddev/ms");
  std::ofstream out("size.bench");
  out << do_test3_110_2();
  out << do_test3_120_2();
  out << do_test3_130_2();
  out << do_test3_140_2();
  out << do_test3_150_2();
  out << do_test3_160_2();
  out << do_test3_170_2();
  out << do_test3_180_2();
  out << do_test3_190_2();
  out << do_test3_200_2();
  out << do_test3_101_2();
  out << do_test3_102_2();
  out << do_test3_105_2();

  out << do_test3_110_3();
  out << do_test3_120_3();
  out << do_test3_130_3();
  out << do_test3_140_3();
  out << do_test3_150_3();
  out << do_test3_160_3();
  out << do_test3_170_3();
  out << do_test3_180_3();
  out << do_test3_190_3();
  out << do_test3_200_3();
  out << do_test3_101_3();
  out << do_test3_102_3();
  out << do_test3_105_3();
}
