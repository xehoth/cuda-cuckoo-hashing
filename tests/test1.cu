//
// Created by xehoth on 2021/12/12.
//
#include <cstdint>
#include <hash_table.cuh>
#include <rng.cuh>
#include <timer.cuh>
#include <cstdio>
#include <fstream>

template <std::uint32_t s, std::uint32_t N_H>
std::string do_test1() {
  fprintf(stderr, "test1 (s = %u, t = %u):\n", s, N_H);
  constexpr std::uint32_t C = 1 << 25;
  constexpr std::uint32_t S = 1 << s;
  HashTable<C, 4 * s, N_H> table;
  fprintf(stderr, "  generate random set ... ");
  HostArray<std::uint32_t, S> h_set = generate_random_set<S>();
  fprintf(stderr, "done\n");
  DeviceArray<std::uint32_t, S> d_set;
  d_set = h_set;
  h_set.free();
  fprintf(stderr, "  begin testing ... \n");
  Timer timer;
  for (int i = 0; i < 5; ++i) {
    fprintf(stderr, "    round %d begin ... ", i);
    timer.start();
    table.insert(d_set);
    timer.end();
    fprintf(stderr, "done\n");
    table.clear();
  }
  fprintf(stderr, "  done\n");
  d_set.free();
  table.free();
  fprintf(stderr, "done\n\n");
  return timer.to_string(S);
}

void do_test1_all() {
  std::ofstream out("test1.bench");
  out << do_test1<10, 2>();
  out << do_test1<11, 2>();
  out << do_test1<12, 2>();
  out << do_test1<13, 2>();
  out << do_test1<14, 2>();
  out << do_test1<15, 2>();
  out << do_test1<16, 2>();
  out << do_test1<17, 2>();
  out << do_test1<18, 2>();
  out << do_test1<19, 2>();
  out << do_test1<20, 2>();
  out << do_test1<21, 2>();
  out << do_test1<22, 2>();
  out << do_test1<23, 2>();
  out << do_test1<24, 2>();
  out << do_test1<10, 3>();
  out << do_test1<11, 3>();
  out << do_test1<12, 3>();
  out << do_test1<13, 3>();
  out << do_test1<14, 3>();
  out << do_test1<15, 3>();
  out << do_test1<16, 3>();
  out << do_test1<17, 3>();
  out << do_test1<18, 3>();
  out << do_test1<19, 3>();
  out << do_test1<20, 3>();
  out << do_test1<21, 3>();
  out << do_test1<22, 3>();
  out << do_test1<23, 3>();
  out << do_test1<24, 3>();
}

int main() {
  do_test1_all();
  return 0;
}