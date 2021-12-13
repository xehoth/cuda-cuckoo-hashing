//
// Created by xehoth on 2021/12/13.
//

#ifndef CS121_LAB2_TESTS_SIZE_TEST_CUH_
#define CS121_LAB2_TESTS_SIZE_TEST_CUH_
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
  timer.report(S);
  fprintf(stderr, "done\n\n");
  return timer.to_string(S);
}

void do_test3_all();
#endif  // CS121_LAB2_TESTS_SIZE_TEST_CUH_
