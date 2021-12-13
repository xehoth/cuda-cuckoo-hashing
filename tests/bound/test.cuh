//
// Created by 82454 on 2021/12/13.
//

#ifndef CS121_LAB2_TESTS_BOUND_TEST_CUH_
#define CS121_LAB2_TESTS_BOUND_TEST_CUH_
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
  timer.report(S);
  fprintf(stderr, "done\n\n");
  return timer.to_string(S);
}

void do_test4_all();
#endif  // CS121_LAB2_TESTS_BOUND_TEST_CUH_
