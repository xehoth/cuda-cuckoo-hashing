//
// Created by xehoth on 2021/12/11.
//

#ifndef CS121_LAB2_INCLUDE_HASH_FUNC_CUH_
#define CS121_LAB2_INCLUDE_HASH_FUNC_CUH_
#include <cstdint>

static const std::uint32_t PRIME1 = 0x9E3779B1U;
static const std::uint32_t PRIME2 = 0x85EBCA77U;
static const std::uint32_t PRIME3 = 0xC2B2AE3DU;
static const std::uint32_t PRIME4 = 0x27D4EB2FU;
static const std::uint32_t PRIME5 = 0x165667B1U;

__host__ __device__ __forceinline__ std::uint32_t rotate_left(std::uint32_t v,
                                                              std::uint32_t n) {
  return (v << n) | (v >> (32 - n));
}

template <std::uint32_t seed>
__host__ __device__ __forceinline__ std::uint32_t xxhash(std::uint32_t v) {
  std::uint32_t acc = seed + PRIME5;

  acc = acc + v * PRIME3;
  acc = rotate_left(acc, 17) * PRIME4;

  std::uint8_t *byte = (std::uint8_t *)(&v);
  for (std::uint32_t i = 0; i < 4; i += 1) {
    acc = acc + byte[i] * PRIME5;
    acc = rotate_left(acc, 11) * PRIME1;
  }

  acc ^= acc >> 15;
  acc *= PRIME2;
  acc ^= acc >> 13;
  acc *= PRIME3;
  acc ^= acc >> 16;

  return acc;
}

template <std::uint32_t hash_func_i>
struct TemplateHash {
  static __device__ __host__ __forceinline__ std::uint32_t hash(
      std::uint32_t k) {
    return xxhash<hash_func_i + 5>(k);
  }
};

template <>
struct TemplateHash<0> {
  static __device__ __host__ __forceinline__ std::uint32_t hash(
      std::uint32_t k) {
    return xxhash<4>(k);
  }
};

template <>
struct TemplateHash<1> {
  static __device__ __host__ __forceinline__ std::uint32_t hash(
      std::uint32_t k) {
    return xxhash<5>(k);
  }
};

//template <>
//struct TemplateHash<2> {
//  static __device__ __host__ __forceinline__ std::uint32_t hash(
//      std::uint32_t k) {
//    return k;
//  }
//};

#endif  // CS121_LAB2_INCLUDE_HASH_FUNC_CUH_
