//
// Created by xehoth on 2021/12/12.
//
#include <hash_table.cuh>
#include <rng.cuh>
#include <fstream>

template <std::uint32_t C, std::uint32_t N_H>
std::string do_test3() {
  fprintf(stderr, "test3 (C = %u, t = %u):\n", C, N_H);
  HashTable<C, 4 * 24, N_H> table;
  constexpr std::uint32_t S = 1 << 24;
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

void do_test3_all() {
  std::ofstream out("test3.bench");
  constexpr std::uint32_t S = 1 << 24;
#define _C(v) (static_cast<std::uint32_t>(S * (v) + 1 - 1e-10))
  out << do_test3<_C(1.1), 2>();
  out << do_test3<_C(1.2), 2>();
  out << do_test3<_C(1.3), 2>();
  out << do_test3<_C(1.4), 2>();
  out << do_test3<_C(1.5), 2>();
  out << do_test3<_C(1.6), 2>();
  out << do_test3<_C(1.7), 2>();
  out << do_test3<_C(1.8), 2>();
  out << do_test3<_C(1.9), 2>();
  out << do_test3<_C(2.0), 2>();
  out << do_test3<_C(1.01), 2>();
  out << do_test3<_C(1.02), 2>();
  out << do_test3<_C(1.05), 2>();
  out << do_test3<_C(1.1), 3>();
  out << do_test3<_C(1.2), 3>();
  out << do_test3<_C(1.3), 3>();
  out << do_test3<_C(1.4), 3>();
  out << do_test3<_C(1.5), 3>();
  out << do_test3<_C(1.6), 3>();
  out << do_test3<_C(1.7), 3>();
  out << do_test3<_C(1.8), 3>();
  out << do_test3<_C(1.9), 3>();
  out << do_test3<_C(2.0), 3>();
  out << do_test3<_C(1.01), 3>();
  out << do_test3<_C(1.02), 3>();
  out << do_test3<_C(1.05), 3>();
#undef _C
}

int main() {
  do_test3_all();
  return 0;
}