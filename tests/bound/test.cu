//
// Created by xehoth on 2021/12/13.
//
#include "test.cuh"
#include <fstream>

extern std::string do_test4_2_2();
extern std::string do_test4_4_2();
extern std::string do_test4_6_2();
extern std::string do_test4_8_2();
extern std::string do_test4_10_2();
extern std::string do_test4_12_2();
extern std::string do_test4_14_2();
extern std::string do_test4_16_2();
extern std::string do_test4_18_2();
extern std::string do_test4_20_2();
extern std::string do_test4_22_2();
extern std::string do_test4_24_2();
extern std::string do_test4_36_2();
extern std::string do_test4_48_2();
extern std::string do_test4_72_2();
extern std::string do_test4_96_2();
extern std::string do_test4_144_2();
extern std::string do_test4_192_2();

extern std::string do_test4_2_3();
extern std::string do_test4_4_3();
extern std::string do_test4_6_3();
extern std::string do_test4_8_3();
extern std::string do_test4_10_3();
extern std::string do_test4_12_3();
extern std::string do_test4_14_3();
extern std::string do_test4_16_3();
extern std::string do_test4_18_3();
extern std::string do_test4_20_3();
extern std::string do_test4_22_3();
extern std::string do_test4_24_3();
extern std::string do_test4_36_3();
extern std::string do_test4_48_3();
extern std::string do_test4_72_3();
extern std::string do_test4_96_3();
extern std::string do_test4_144_3();
extern std::string do_test4_192_3();

void do_test4_all() {
  std::ofstream out("bound.bench");
  out << do_test4_2_2();
  out << do_test4_4_2();
  out << do_test4_6_2();
  out << do_test4_8_2();
  out << do_test4_10_2();
  out << do_test4_12_2();
  out << do_test4_14_2();
  out << do_test4_16_2();
  out << do_test4_18_2();
  out << do_test4_20_2();
  out << do_test4_22_2();
  out << do_test4_24_2();
  out << do_test4_36_2();
  out << do_test4_48_2();
  out << do_test4_72_2();
  out << do_test4_96_2();
  out << do_test4_144_2();
  out << do_test4_192_2();

  out << do_test4_2_3();
  out << do_test4_4_3();
  out << do_test4_6_3();
  out << do_test4_8_3();
  out << do_test4_10_3();
  out << do_test4_12_3();
  out << do_test4_14_3();
  out << do_test4_16_3();
  out << do_test4_18_3();
  out << do_test4_20_3();
  out << do_test4_22_3();
  out << do_test4_24_3();
  out << do_test4_36_3();
  out << do_test4_48_3();
  out << do_test4_72_3();
  out << do_test4_96_3();
  out << do_test4_144_3();
  out << do_test4_192_3();
}