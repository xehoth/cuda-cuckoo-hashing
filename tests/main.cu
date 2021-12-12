//
// Created by xehoth on 2021/12/11.
//
#include <timer.cuh>
#include <hash_table.cuh>
#include <set>
#include <random>
#include <iostream>
#include <rng.cuh>
__global__ void test() { printf("%d %d\n", blockIdx.x, threadIdx.x); }

int main() {
  HashTable<std::uint32_t((1 << 24) * 1.01), 3> table;
  constexpr int S = 1 << 24;
  HostArray<std::uint32_t, S> h;
  std::set<std::uint32_t> set;
  std::mt19937 engine;
  std::uniform_int_distribution<std::uint32_t> dis;
  //  for (int i = 0; i < S; ++i) {
  //    std::uint32_t x;
  //    do {
  //      x = dis(engine);
  //    } while (set.count(x) || x == -1u);
  //    set.insert(x);
  //  }
  //  auto it = set.begin();
  std::cerr << "generate begin" << std::endl;
#pragma omp parallel for
  for (std::uint32_t i = 0; i < h.size(); ++i) {
    h(i) = dis(engine);
    while (h(i) == -1u) h(i) = dis(engine);
  }
  std::cerr << "generate done" << std::endl;
  DeviceArray<std::uint32_t, S> d, lookup, res;
  d = h;
  lookup = h;
  std::uint32_t a = 1000;
  cudaMemcpy(lookup.data, &a, sizeof(std::uint32_t), cudaMemcpyHostToDevice);
  res.constant_fill<0>();

  Timer timer;
  for (int i = 0; i < 5; ++i) {
    timer.start();
    table.insert(d);
    timer.end();
//    table.insert_and_lookup<S, S>(d, lookup, res, timer);
    table.clear();
  }
//  HostArray<std::uint32_t, S> h_res;
//  h_res = res;
//  for (std::uint32_t i = 0; i < h_res.size(); ++i) {
//    if (h_res(i) != 1) {
//      printf("wrong answer %d !!!!", i);
//    }
//  }
  table.print();
  cudaDeviceSynchronize();
  table.free();
  d.free();
  h.free();
  timer.report(S);
  return 0;
}