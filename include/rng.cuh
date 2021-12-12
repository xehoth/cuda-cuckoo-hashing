//
// Created by xehoth on 2021/12/12.
//

#ifndef CS121_LAB2_INCLUDE_RNG_CUH_
#define CS121_LAB2_INCLUDE_RNG_CUH_
#include <random>
#include <unordered_set>
#include <cuda_array.cuh>
#include <algorithm>

template <std::uint32_t S>
HostArray<std::uint32_t, S> generate_random_set() {
  static std::vector<std::uint32_t> cache;
  HostArray<std::uint32_t, S> ret;
  if (cache.size() == S) {
    for (std::uint32_t i = 0; i < S; ++i) ret(i) = cache[i];
    return ret;
  }
  std::mt19937 engine;
  std::uniform_int_distribution<std::uint32_t> dis(0, -1u);
  std::unordered_set<std::uint32_t> set;
  for (int i = 0; i < S;) {
    std::uint32_t x;
    do {
      x = dis(engine);
    } while (set.count(x));
    ret(i++) = x;
  }
  if (cache.empty()) {
    cache.resize(S);
    for (std::uint32_t i = 0; i < S; ++i) cache[i] = ret(i);
  }
  return ret;
}

template <std::uint32_t S, std::uint32_t percent_i>
HostArray<std::uint32_t, S> generate_lookup_set(
    HostArray<std::uint32_t, S> set) {
  static std::vector<std::uint32_t> cache;
  HostArray<std::uint32_t, S> ret;
  if (cache.size() == S) {
    for (std::uint32_t i = 0; i < ret.size(); ++i) ret(i) = cache[i];
    return ret;
  }
  std::mt19937 engine;
  std::uniform_int_distribution<std::uint32_t> dis(0, S - 1);
  std::uniform_int_distribution<std::uint32_t> dis_val(0, -1u);
  constexpr int choose_from_set =
      static_cast<int>((100 - percent_i * 10) / 100.0 * S);
  constexpr int choose_from_random = static_cast<int>(S) - choose_from_set;
  std::unordered_set<std::uint32_t> filter;
  for (std::uint32_t i = 0; i < S; ++i) filter.insert(set(i));
  std::vector<std::uint32_t> random_set(choose_from_random);
  for (int i = 0; i < choose_from_random; ++i) {
    std::uint32_t x;
    do {
      x = dis_val(engine);
    } while (filter.count(x));
    filter.insert(x);
    random_set[i] = x;
  }
  ret = set;
  std::shuffle(ret.data, ret.data + ret.size(), engine);
  for (int i = 0; i < choose_from_random; ++i) {
    ret(i) = random_set[i];
  }
  std::shuffle(ret.data, ret.data + ret.size(), engine);
  if (cache.empty()) {
    cache.resize(S);
    for (std::uint32_t i = 0; i < S; ++i) cache[i] = ret(i);
  }
  return ret;
}
#endif  // CS121_LAB2_INCLUDE_RNG_CUH_
