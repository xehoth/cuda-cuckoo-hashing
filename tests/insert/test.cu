//
// Created by xehoth on 2021/12/12.
//
#include "test.cuh"

extern std::string do_test1_10_2();
extern std::string do_test1_11_2();
extern std::string do_test1_12_2();
extern std::string do_test1_13_2();
extern std::string do_test1_14_2();
extern std::string do_test1_15_2();
extern std::string do_test1_16_2();
extern std::string do_test1_17_2();
extern std::string do_test1_18_2();
extern std::string do_test1_19_2();
extern std::string do_test1_20_2();
extern std::string do_test1_21_2();
extern std::string do_test1_22_2();
extern std::string do_test1_23_2();
extern std::string do_test1_24_2();

extern std::string do_test1_10_3();
extern std::string do_test1_11_3();
extern std::string do_test1_12_3();
extern std::string do_test1_13_3();
extern std::string do_test1_14_3();
extern std::string do_test1_15_3();
extern std::string do_test1_16_3();
extern std::string do_test1_17_3();
extern std::string do_test1_18_3();
extern std::string do_test1_19_3();
extern std::string do_test1_20_3();
extern std::string do_test1_21_3();
extern std::string do_test1_22_3();
extern std::string do_test1_23_3();
extern std::string do_test1_24_3();

void do_test1_all() {
  printf("Insert test:\n");
  printf("Result saves to insert.bench\n");
  printf("%-4s%-4s%-12s%-12s%-12s\n", "s", "t", "MOPS", "mean/ms", "stddev/ms");
  std::ofstream out("insert.bench");
  out << do_test1_10_2();
  out << do_test1_11_2();
  out << do_test1_12_2();
  out << do_test1_13_2();
  out << do_test1_14_2();
  out << do_test1_15_2();
  out << do_test1_16_2();
  out << do_test1_17_2();
  out << do_test1_18_2();
  out << do_test1_19_2();
  out << do_test1_20_2();
  out << do_test1_21_2();
  out << do_test1_22_2();
  out << do_test1_23_2();
  out << do_test1_24_2();

  out << do_test1_10_3();
  out << do_test1_11_3();
  out << do_test1_12_3();
  out << do_test1_13_3();
  out << do_test1_14_3();
  out << do_test1_15_3();
  out << do_test1_16_3();
  out << do_test1_17_3();
  out << do_test1_18_3();
  out << do_test1_19_3();
  out << do_test1_20_3();
  out << do_test1_21_3();
  out << do_test1_22_3();
  out << do_test1_23_3();
  out << do_test1_24_3();
}