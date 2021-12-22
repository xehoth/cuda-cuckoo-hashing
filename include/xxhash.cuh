//
// Created by xehoth on 2021/12/12.
//

#ifndef CS121_LAB2_INCLUDE_XXHASH_CUH_
#define CS121_LAB2_INCLUDE_XXHASH_CUH_

static const std::uint32_t PRIME1 = 2654435761u;
static const std::uint32_t PRIME2 = 2246822519u;
static const std::uint32_t PRIME3 = 3266489917u;
static const std::uint32_t PRIME4 = 668265263;
static const std::uint32_t PRIME5 = 374761393;

__host__ __device__ __forceinline__ std::uint32_t rotate_left(std::uint32_t v,
                                                              std::uint32_t n) {
  return (v << n) | (v >> (32 - n));
}

template <std::uint32_t seed>
__host__ __device__ __forceinline__ std::uint32_t xxhash(std::uint32_t v) {
  std::uint32_t hash = seed + PRIME5;

  hash = hash + v * PRIME3;
  hash = rotate_left(hash, 17) * PRIME4;

  auto *byte = reinterpret_cast<std::uint8_t *>(&v);

  for (std::uint32_t i = 0; i < 4; ++i) {
    hash = hash + byte[i] * PRIME5;
    hash = rotate_left(hash, 11) * PRIME1;
  }

  hash ^= hash >> 15;
  hash *= PRIME2;
  hash ^= hash >> 13;
  hash *= PRIME3;
  hash ^= hash >> 16;

  return hash;
}
#endif  // CS121_LAB2_INCLUDE_XXHASH_CUH_
