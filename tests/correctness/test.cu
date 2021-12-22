//
// Created by xehoth on 2021/12/20.
//
#include "test.cuh"
#include <hash_table.cuh>
#include <rng.cuh>

void do_correctness_test() {
  RandomSetGenerator<(1 << 24)>::get();
  printf("testing correctness ... ");
  constexpr std::uint32_t C = 1 << 25;
  constexpr std::uint32_t S = 1 << 24;
  HashTable<C, 4 * 24, 2> table;
  HostArray<std::uint32_t, S> h_set, h_lookup_set;
  DeviceArray<std::uint32_t, S> d_set;
  RandomSetGenerator<S>::get()->generate_random_set(d_set);
  DeviceArray<std::uint32_t, S> d_lookup_set, d_res;
  RandomSetGenerator<S>::get()->generate_lookup_set<5>(d_lookup_set);
  HostArray<std::uint32_t, S> h_res;
  h_set = d_set;
  h_lookup_set = d_lookup_set;
  auto check_correctness = [&]() {
    std::unordered_set<std::uint32_t> hash_set;
    for (std::uint32_t i = 0; i < h_set.size(); ++i) hash_set.insert(h_set(i));
    HostArray<std::uint32_t, S> h_res;
    h_res = d_res;
    for (std::uint32_t i = 0; i < h_res.size(); ++i) {
      std::uint32_t expected = hash_set.count(h_lookup_set(i));
      if (h_res(i) != expected) {
        printf("[wrong answer at (%u: %u), expected: %u]\n", i, h_lookup_set(i),
               expected);
        return;
      }
    }
    printf("[correct]\n");
  };
  Timer timer;
  table.insert_and_lookup(d_set, d_lookup_set, d_res, timer);
  checkCudaErrors(cudaDeviceSynchronize());
  check_correctness();
  h_set.free();
  h_lookup_set.free();
  h_res.free();
  d_set.free();
  d_lookup_set.free();
  d_res.free();
  table.free();
}