//
// Created by xehoth on 2021/12/13.
//

#ifndef CS121_LAB2_TESTS_LOOKUP_TEST_CUH_
#define CS121_LAB2_TESTS_LOOKUP_TEST_CUH_

#include <hash_table.cuh>
#include <rng.cuh>
#include <cstdio>
#include <fstream>
#include <string>

template <std::uint32_t i, std::uint32_t N_H>
std::string do_test2() {
  fprintf(stderr, "test2 (i = %u, t = %u):\n", i, N_H);
  constexpr std::uint32_t C = 1 << 25;
  constexpr std::uint32_t S = 1 << 24;
  HashTable<C, 4 * 24, N_H> table;
  DeviceArray<std::uint32_t, S> d_set;
  DeviceArray<std::uint32_t, S> d_lookup_set, d_res;
  fprintf(stderr, "  generate random set ... ");
  RandomSetGenerator<S>::get()->generate_random_set<S>(d_set);
  fprintf(stderr, "done\n");
  fprintf(stderr, "  generate lookup set ... ");
  RandomSetGenerator<S>::get()->generate_lookup_set<i>(d_lookup_set);
  fprintf(stderr, "done\n");
  fprintf(stderr, "  begin testing ... \n");
  Timer timer;
  for (int case_i = 0; case_i < 5; ++case_i) {
    fprintf(stderr, "    round %d begin ... ", case_i);
    table.insert_and_lookup(d_set, d_lookup_set, d_res, timer);
    fprintf(stderr, "done\n");
    table.clear();
  }
  fprintf(stderr, "  done\n");
  d_set.free();
  d_lookup_set.free();
  d_res.free();
  table.free();
  printf("%-4u%-4u", i, N_H);
  timer.report(S);
  fprintf(stderr, "done\n\n");
  return timer.to_string(S);
}

void do_test2_all();
#endif  // CS121_LAB2_TESTS_LOOKUP_TEST_CUH_
