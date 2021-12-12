//
// Created by xehoth on 2021/12/12.
//
#include <rng.cuh>
#include <hash_table.cuh>
#include <cstdint>
#include <fstream>

template <std::uint32_t l, std::uint32_t N_H>
std::string do_test4() {
  fprintf(stderr, "test3 (C = %.1f, t = %u):\n", l / 10.0, N_H);
  constexpr std::uint32_t S = 1 << 24;
  constexpr auto C = static_cast<std::uint32_t>(S * 1.4 + 1 - 1e-10);
  constexpr auto bound = static_cast<std::uint32_t>(24 * l / 10.0 + 1 - 1e-10);
  HashTable<C, bound, N_H> table;
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

void do_test4_all() {
  std::ofstream out("test4.bench");
  out << do_test4<2, 2>();
  out << do_test4<4, 2>();
  out << do_test4<6, 2>();
  out << do_test4<8, 2>();
  out << do_test4<10, 2>();
  out << do_test4<12, 2>();
  out << do_test4<14, 2>();
  out << do_test4<16, 2>();
  out << do_test4<18, 2>();
  out << do_test4<20, 2>();
  out << do_test4<30, 2>();
  out << do_test4<40, 2>();
  out << do_test4<60, 2>();
  out << do_test4<80, 2>();
  out << do_test4<120, 2>();
  out << do_test4<160, 2>();
  out << do_test4<2, 3>();
  out << do_test4<4, 3>();
  out << do_test4<6, 3>();
  out << do_test4<8, 3>();
  out << do_test4<10, 3>();
  out << do_test4<12, 3>();
  out << do_test4<14, 3>();
  out << do_test4<16, 3>();
  out << do_test4<18, 3>();
  out << do_test4<20, 3>();
  out << do_test4<30, 3>();
  out << do_test4<40, 3>();
  out << do_test4<60, 3>();
  out << do_test4<80, 3>();
  out << do_test4<120, 3>();
  out << do_test4<160, 3>();
}

int main() {
  do_test4_all();
  return 0;
}