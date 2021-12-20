//
// Created by xehoth on 2021/12/13.
//
#include "test.cuh"
#include <fstream>

extern std::string do_test2_0_2();
extern std::string do_test2_1_2();
extern std::string do_test2_2_2();
extern std::string do_test2_3_2();
extern std::string do_test2_4_2();
extern std::string do_test2_5_2();
extern std::string do_test2_6_2();
extern std::string do_test2_7_2();
extern std::string do_test2_8_2();
extern std::string do_test2_9_2();
extern std::string do_test2_10_2();

extern std::string do_test2_0_3();
extern std::string do_test2_1_3();
extern std::string do_test2_2_3();
extern std::string do_test2_3_3();
extern std::string do_test2_4_3();
extern std::string do_test2_5_3();
extern std::string do_test2_6_3();
extern std::string do_test2_7_3();
extern std::string do_test2_8_3();
extern std::string do_test2_9_3();
extern std::string do_test2_10_3();

void do_test2_all() {
  printf("Lookup test:\n");
  printf("Result saves to lookup.bench\n");
  printf("%-4s%-4s%-12s%-12s%-12s\n", "i", "t", "MOPS", "mean/ms", "stddev/ms");
  std::ofstream out("lookup.bench");
  out << do_test2_0_2();
  out << do_test2_1_2();
  out << do_test2_2_2();
  out << do_test2_3_2();
  out << do_test2_4_2();
  out << do_test2_5_2();
  out << do_test2_6_2();
  out << do_test2_7_2();
  out << do_test2_8_2();
  out << do_test2_9_2();
  out << do_test2_10_2();

  out << do_test2_0_3();
  out << do_test2_1_3();
  out << do_test2_2_3();
  out << do_test2_3_3();
  out << do_test2_4_3();
  out << do_test2_5_3();
  out << do_test2_6_3();
  out << do_test2_7_3();
  out << do_test2_8_3();
  out << do_test2_9_3();
  out << do_test2_10_3();
}