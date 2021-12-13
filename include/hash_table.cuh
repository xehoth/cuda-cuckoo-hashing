//
// Created by xehoth on 2021/12/11.
//

#ifndef CS121_LAB2_INCLUDE_HASH_TABLE_CUH_
#define CS121_LAB2_INCLUDE_HASH_TABLE_CUH_
#include <cstdint>
#include <cuda_array.cuh>
#include <helper.cuh>
#include <hash_func.cuh>
#include <cstdio>
#include <timer.cuh>

// capacity, number of hash functions, empty key
template <std::uint32_t C, std::uint32_t bound, std::uint32_t N_H = 2,
          std::uint32_t EMPTY_KEY = -1u>
class HashTable;

template <std::uint32_t C, std::uint32_t bound, std::uint32_t N_H,
          std::uint32_t S, std::uint32_t hash_func_i>
__global__ void insert_kernel(HashTable<C, bound, N_H> table,
                              DeviceArray<std::uint32_t, S> keys);

template <std::uint32_t C, std::uint32_t bound, std::uint32_t N_H,
          std::uint32_t S, std::uint32_t hash_func_i>
__global__ void lookup_kernel(HashTable<C, bound, N_H> table,
                              DeviceArray<std::uint32_t, S> keys,
                              DeviceArray<std::uint32_t, S> res);

template <std::uint32_t C, std::uint32_t bound, std::uint32_t N_H,
          std::uint32_t EMPTY_KEY>
class HashTable {
 public:
  __host__ HashTable() { clear(); }

  void clear() {
    for (auto &slot : slots) slot.template constant_fill<EMPTY_KEY>();
    std::uint32_t h_collisions = 0;
    cudaMemcpy(collisions.data, &h_collisions, sizeof(std::uint32_t),
               cudaMemcpyHostToDevice);
  }

  void free() {
    for (auto &slot : slots) slot.free();
    collisions.free();
  }

  template <std::uint32_t S, std::uint32_t hash_func_i = 0>
  __forceinline__ void insert(DeviceArray<std::uint32_t, S> keys) {
    insert_kernel<C, bound, N_H, S, hash_func_i>
        <<<ceil(S / 512.0), 512>>>(*this, keys);
    std::uint32_t h_collisions = 0;
    cudaMemcpy(&h_collisions, collisions.data, sizeof(std::uint32_t),
               cudaMemcpyDeviceToHost);
    if (h_collisions == 0) {
      return;
    }
    fprintf(stderr, "[rehash %d] ", hash_func_i + 1);
    clear();
    if constexpr (hash_func_i < 16) {
      insert<S, hash_func_i + 1>(keys);
    } else {
      fprintf(stderr, "[rehash too long, failed] ");
      return;
    }
  }

  template <std::uint32_t S, std::uint32_t LS, std::uint32_t hash_func_i = 0>
  __forceinline__ void insert_and_lookup(
      DeviceArray<std::uint32_t, S> keys,
      DeviceArray<std::uint32_t, LS> lookup_keys,
      DeviceArray<std::uint32_t, LS> res, Timer &timer) {
    insert_kernel<C, bound, N_H, S, hash_func_i>
        <<<ceil(S / 512.0), 512>>>(*this, keys);
    std::uint32_t h_collisions = 0;
    cudaMemcpy(&h_collisions, collisions.data, sizeof(std::uint32_t),
               cudaMemcpyDeviceToHost);
    if (h_collisions == 0) {
      timer.start();
      lookup_kernel<C, bound, N_H, LS, hash_func_i>
          <<<ceil(S / 512.0), 512>>>(*this, lookup_keys, res);
      timer.end();
      return;
    }
    fprintf(stderr, "[rehash %d] ", hash_func_i + 1);
    clear();
    if constexpr (hash_func_i < 16) {
      insert_and_lookup<S, LS, hash_func_i + 1>(keys, lookup_keys, res, timer);
    } else {
      fprintf(stderr, "[rehash too long, failed] ");
      return;
    }
  }

  [[nodiscard]] constexpr __device__ __host__ __forceinline__ std::uint32_t
  emptyKey() const {
    return EMPTY_KEY;
  }

  void print() {
    HostArray<std::uint32_t, C> h_slots[N_H];
    for (std::uint32_t i = 0; i < N_H; ++i) h_slots[i] = slots[i];
    for (std::uint32_t i = 0; i < N_H; ++i) {
      for (std::uint32_t j = 0; j < C; ++j) {
        if (h_slots[i](j) != EMPTY_KEY) {
          printf("%u: (%u, %u)\n", h_slots[i](j), i, j);
        }
      }
    }
    for (auto &v : h_slots) v.free();
  }

  DeviceArray<std::uint32_t, C> slots[N_H];
  DeviceArray<std::uint32_t, 1> collisions;
};

template <std::uint32_t cur, std::uint32_t N_H, std::uint32_t bound,
          std::uint32_t hash_func_i>
struct TemplateInsert {
  template <std::uint32_t C, std::uint32_t TB>
  static __device__ __forceinline__ void insert(HashTable<C, TB, N_H> table,
                                                std::uint32_t key) {
    if (table.collisions(0)) return;
    std::uint32_t last = atomicExch(
        &(table.slots[cur](TemplateHash<cur + hash_func_i>::hash(key) % C)),
        key);
    if (last == table.emptyKey() || last == key) {
      return;
    } else {
      TemplateInsert<(cur + 1) % N_H, N_H, bound - 1,
                     hash_func_i>::insert<C, TB>(table, last);
    }
  }
};

template <std::uint32_t cur, std::uint32_t N_H, std::uint32_t hash_func_i>
struct TemplateInsert<cur, N_H, 0, hash_func_i> {
  template <std::uint32_t C, std::uint32_t TB>
  static __device__ __forceinline__ void insert(HashTable<C, TB, N_H> table,
                                                std::uint32_t) {
    atomicAdd(&table.collisions(0), 1);
  }
};

template <std::uint32_t cur, std::uint32_t N_H, std::uint32_t hash_func_i>
struct TemplateLookup {
  template <std::uint32_t C, std::uint32_t TB>
  static __device__ __forceinline__ bool lookup(HashTable<C, TB, N_H> table,
                                                std::uint32_t key) {
    if (key == table.slots[cur](TemplateHash<cur + hash_func_i>::hash(key) % C))
      return true;
    return TemplateLookup<cur + 1, N_H, hash_func_i>::lookup<C, TB>(table, key);
  }
};

template <std::uint32_t N_H, std::uint32_t hash_func_i>
struct TemplateLookup<N_H, N_H, hash_func_i> {
  template <std::uint32_t C, std::uint32_t TB>
  static __device__ __forceinline__ bool lookup(HashTable<C, TB, N_H>,
                                                std::uint32_t) {
    return false;
  }
};

template <std::uint32_t C, std::uint32_t bound, std::uint32_t N_H,
          std::uint32_t S, std::uint32_t hash_func_i>
__global__ void insert_kernel(HashTable<C, bound, N_H> table,
                              DeviceArray<std::uint32_t, S> keys) {
  cuda_foreach_unsigned(x, 0, S) {
    TemplateInsert<0, N_H, bound, hash_func_i>::insert<C, bound>(table,
                                                                 keys(x));
  }
}

template <std::uint32_t C, std::uint32_t bound, std::uint32_t N_H,
          std::uint32_t S, std::uint32_t hash_func_i>
__global__ void lookup_kernel(HashTable<C, bound, N_H> table,
                              DeviceArray<std::uint32_t, S> keys,
                              DeviceArray<std::uint32_t, S> res) {
  cuda_foreach_unsigned(x, 0, keys.size()) {
    res(x) =
        TemplateLookup<0, N_H, hash_func_i>::lookup<C, bound>(table, keys(x));
  }
}
#endif  // CS121_LAB2_INCLUDE_HASH_TABLE_CUH_
