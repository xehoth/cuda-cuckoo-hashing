//
// Created by xehoth on 2021/12/11.
//
#include <timer.cuh>
#include <hash_table.cuh>
#include <set>
#include <random>
#include <iostream>

__global__ void test() { printf("%d %d\n", blockIdx.x, threadIdx.x); }

int main() {
  HashTable<std::uint32_t((1 << 24) * 1.02), 3> table;
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
  DeviceArray<std::uint32_t, S> d;
  d = h;

  Timer timer;
  for (int i = 0; i < 5; ++i) {
    timer.start();
    table.insert(d);
    timer.end();
    table.clear();
  }
  table.print();
  cudaDeviceSynchronize();
  table.free();
  d.free();
  h.free();
  timer.report(1 << 25);
  return 0;
}