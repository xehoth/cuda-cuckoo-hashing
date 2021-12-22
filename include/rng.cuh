//
// Created by xehoth on 2021/12/12.
//

#ifndef CS121_LAB2_INCLUDE_RNG_CUH_
#define CS121_LAB2_INCLUDE_RNG_CUH_
#include <random>
#include <unordered_set>
#include <cuda_array.cuh>
#include <algorithm>
#include <omp.h>
#include <bitset>
#include <memory>

template <std::uint32_t S>
__global__ static void random_shuffle_kernel(DeviceArray<std::uint32_t, S> a) {
  cuda_foreach_unsigned(x, 0, S) {
    std::uint32_t swap_idx = x;
    swap_idx ^= swap_idx << 13;
    swap_idx ^= swap_idx >> 17;
    swap_idx ^= swap_idx << 5;
    swap_idx %= S;
    std::uint32_t tmp = a(x);
    tmp = atomicExch(&a(swap_idx), tmp);
    atomicExch(&a(x), tmp);
  }
}

template <std::uint32_t S>
struct RandomSetGenerator {
  static RandomSetGenerator *get() {
    static std::unique_ptr<RandomSetGenerator<S>> instance{};
    if (!instance) {
      instance = std::make_unique<RandomSetGenerator<S>>();
      instance->init();
    }
    return instance.get();
  }

  void init();

  template <std::uint32_t size>
  void generate_random_set(DeviceArray<std::uint32_t, size> output) {
    checkCudaErrors(cudaMemcpy(output.data, random_set.data,
                               sizeof(std::uint32_t) * size,
                               cudaMemcpyDeviceToDevice));
  }

  template <std::uint32_t percent_i>
  void generate_lookup_set(DeviceArray<std::uint32_t, S> output) {
    constexpr int choose_from_set =
        static_cast<int>((100 - percent_i * 10) / 100.0 * S);
    constexpr int choose_from_random = static_cast<int>(S) - choose_from_set;
    output = random_set;
    random_shuffle_kernel<<<ceil(S / 512.0), 512>>>(output);
    cudaMemcpy(output.data, diff_set.data,
               sizeof(std::uint32_t) * choose_from_random,
               cudaMemcpyDeviceToDevice);
    random_shuffle_kernel<<<ceil(S / 512.0), 512>>>(output);
  }

  ~RandomSetGenerator() {
    random_set.free();
    diff_set.free();
    lookup_set.free();
  }

 private:
  DeviceArray<std::uint32_t, S> random_set;
  DeviceArray<std::uint32_t, S> diff_set;
  DeviceArray<std::uint32_t, S> lookup_set;
};

template <std::uint32_t S>
void RandomSetGenerator<S>::init() {
  printf("init random set generator of size %u:\n", S);
  auto used = std::make_unique<
      std::bitset<std::numeric_limits<std::uint32_t>::max()>>();
  {
    printf("  generate random set ... ");
    HostArray<std::uint32_t, S> h_random_set;
    // generate random set (insert)
    std::mt19937 engine;
    std::uniform_int_distribution<std::uint32_t> dis(
        0, std::numeric_limits<std::uint32_t>::max() - 1);
    for (std::uint32_t i = 0; i < S;) {
      std::uint32_t x = dis(engine);
      if (used->test(x)) continue;
      used->set(x);
      h_random_set(i++) = x;
    }
    this->random_set = h_random_set;
    h_random_set.free();
    printf("done\n");
  }
  {
    printf("  generate different set ... ");
    HostArray<std::uint32_t, S> h_diff_set;
    std::mt19937 engine(495);
    std::uniform_int_distribution<std::uint32_t> dis(
        0, std::numeric_limits<std::uint32_t>::max() - 1);
    for (std::uint32_t i = 0; i < S;) {
      std::uint32_t x = dis(engine);
      if (used->test(x)) continue;
      used->set(x);
      h_diff_set(i++) = x;
    }
    this->diff_set = h_diff_set;
    h_diff_set.free();
    printf("done\n");
  }
  printf("init random set generator done\n");
}

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
  std::unique_ptr<std::bitset<std::numeric_limits<std::uint32_t>::max()>> set =
      std::make_unique<
          std::bitset<std::numeric_limits<std::uint32_t>::max()>>();
  for (int i = 0; i < S;) {
    std::uint32_t x;
    do {
      x = dis(engine);
    } while (set->test(x));
    set->set(x);
    ret(i++) = x;
  }
  //  std::unordered_set<std::uint32_t> set;
  //  for (int i = 0; i < S;) {
  //    std::uint32_t x;
  //    do {
  //      x = dis(engine);
  //    } while (set.count(x));
  //    ret(i++) = x;
  //  }
  if (cache.empty()) {
    cache.resize(S);
    for (std::uint32_t i = 0; i < S; ++i) cache[i] = ret(i);
  }
  return ret;
}

template <std::uint32_t S>
const std::vector<std::uint32_t> &generate_random_lookup_set(
    HostArray<std::uint32_t, S> set) {
  static std::vector<std::uint32_t> cache;
  if (cache.size() == S) {
    return cache;
  }
  std::mt19937 engine(495);
  std::uniform_int_distribution<std::uint32_t> dis_val(0, -1u);
  //  std::unordered_set<std::uint32_t> filter(set.data, set.data + set.size());
  std::unique_ptr<std::bitset<std::numeric_limits<std::uint32_t>::max()>>
      filter = std::make_unique<
          std::bitset<std::numeric_limits<std::uint32_t>::max()>>();
  for (std::uint32_t i = 0; i < S; ++i) filter->set(set(i));
  cache.resize(S);
  for (int i = 0; i < S; ++i) {
    std::uint32_t x;
    do {
      x = dis_val(engine);
    } while (filter->test(x));
    filter->set(x);
    cache[i] = x;
  }
  //  for (int i = 0; i < S; ++i) {
  //    std::uint32_t x;
  //    do {
  //      x = dis_val(engine);
  //    } while (filter.count(x));
  //    filter.insert(x);
  //    cache[i] = x;
  //  }
  return cache;
}

template <std::uint32_t S, std::uint32_t percent_i>
HostArray<std::uint32_t, S> generate_lookup_set(
    HostArray<std::uint32_t, S> set) {
  HostArray<std::uint32_t, S> ret;
  std::mt19937 engine;
  constexpr int choose_from_set =
      static_cast<int>((100 - percent_i * 10) / 100.0 * S);
  constexpr int choose_from_random = static_cast<int>(S) - choose_from_set;

  ret = set;
  const std::vector<std::uint32_t> &lookup_set_cache =
      generate_random_lookup_set<S>(set);
#pragma omp parallel private(engine)
  {
    engine.seed(omp_get_thread_num());
#pragma omp for
    for (int i = ret.size() - 1; i > 0; --i) {
      std::uniform_int_distribution<int> dis(0, i);
      int idx = dis(engine);
      std::swap(ret(i), ret(idx));
    }
  }
#pragma omp parallel for
  for (int i = 0; i < choose_from_random; ++i) {
    ret(i) = lookup_set_cache[i];
  }
#pragma omp parallel private(engine)
  {
    engine.seed(omp_get_thread_num());
#pragma omp for
    for (int i = ret.size() - 1; i > 0; --i) {
      std::uniform_int_distribution<int> dis(0, i);
      int idx = dis(engine);
      std::swap(ret(i), ret(idx));
    }
  }
  return ret;
}
#endif  // CS121_LAB2_INCLUDE_RNG_CUH_
