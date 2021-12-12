//
// Created by xehoth on 2021/12/11.
//

#ifndef CS121_LAB2_INCLUDE_HASH_FUNC_CUH_
#define CS121_LAB2_INCLUDE_HASH_FUNC_CUH_
#include <cstdint>
#include <xxhash.cuh>

template <std::uint32_t hash_func_i>
struct TemplateHash {
  static __device__ __host__ __forceinline__ std::uint32_t hash(
      std::uint32_t k) {
    return xxhash<7979717 * hash_func_i + 998244353>(k);
  }
};
//
//template <>
//struct TemplateHash<0> {
//  static __device__ __host__ __forceinline__ std::uint32_t hash(
//      std::uint32_t k) {
//    return xxhash<4>(k);
//  }
//};
//
//template <>
//struct TemplateHash<1> {
//  static __device__ __host__ __forceinline__ std::uint32_t hash(
//      std::uint32_t k) {
//    return xxhash<5>(k);
//  }
//};

//template <>
//struct TemplateHash<2> {
//  static __device__ __host__ __forceinline__ std::uint32_t hash(
//      std::uint32_t k) {
//    return k;
//  }
//};

#endif  // CS121_LAB2_INCLUDE_HASH_FUNC_CUH_
