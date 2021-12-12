//
// Created by xehoth on 2021/12/12.
//

#ifndef CS121_LAB2_TESTS_INSERT_TEST_CUH_
#define CS121_LAB2_TESTS_INSERT_TEST_CUH_
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

void do_test1_all();
#endif  // CS121_LAB2_TESTS_INSERT_TEST_CUH_
