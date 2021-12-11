//
// Created by xehoth on 2021/12/11.
//

#ifndef CS121_LAB2_INCLUDE_CUDA_ARRAY_CUH_
#define CS121_LAB2_INCLUDE_CUDA_ARRAY_CUH_
#include <cuda_runtime.h>
#include <helper.cuh>
#include <cstdlib>

template <typename T, std::uint32_t S>
struct HostArray;

template <typename T, std::uint32_t S>
struct DeviceArray;

template <typename T, std::uint32_t S>
struct HostArray {
  HostArray() : data(reinterpret_cast<T *>(std::malloc(sizeof(T) * S))) {}

  void free() {
    if (data) {
      std::free(data);
      data = nullptr;
    }
  }

  HostArray &operator=(const HostArray<T, S> &rhs) {
    if (&rhs == this) return *this;
    checkCudaErrors(
        cudaMemcpy(data, rhs.data, sizeof(T) * S, cudaMemcpyHostToHost));
    return *this;
  }

  HostArray &operator=(const DeviceArray<T, S> &rhs) {
    checkCudaErrors(
        cudaMemcpy(data, rhs.data, sizeof(T) * S, cudaMemcpyDeviceToHost));
    return *this;
  }

  T &operator()(std::uint32_t i) { return data[i]; }
  const T &operator()(std::uint32_t i) const { return data[i]; }

  [[nodiscard]] constexpr std::uint32_t size() const { return S; }

  T *data;
};

template <typename T, std::uint32_t S, T value>
__global__ void constant_fill_kernel(T *data) {
  cuda_foreach_unsigned(x, 0, S) { data[x] = value; }
}

template <typename T, std::uint32_t S>
struct DeviceArray {
  DeviceArray() { checkCudaErrors(cudaMalloc(&data, sizeof(T) * S)); }

  void free() {
    if (data) {
      checkCudaErrors(cudaFree(data));
      data = nullptr;
    }
  }

  DeviceArray &operator=(const HostArray<T, S> &rhs) {
    checkCudaErrors(
        cudaMemcpy(data, rhs.data, sizeof(T) * S, cudaMemcpyHostToDevice));
    return *this;
  }

  __device__ __forceinline__ DeviceArray &operator=(
      const DeviceArray<T, S> &rhs) {
    if (&rhs == this) return *this;
    checkCudaErrors(
        cudaMemcpy(data, rhs.data, sizeof(T) * S, cudaMemcpyDeviceToDevice));
  }

  [[nodiscard]] constexpr __host__ __device__ __forceinline__ std::uint32_t
  size() const {
    return S;
  }

  __device__ __forceinline__ T &operator()(std::uint32_t i) { return data[i]; }
  __device__ __forceinline__ const T &operator()(std::uint32_t i) const {
    return data[i];
  }

  template <T value>
  void constant_fill() {
    constant_fill_kernel<T, S, value><<<ceil(S / 256.0), 256>>>(data);
  }

  T *data;
};

#endif  // CS121_LAB2_INCLUDE_CUDA_ARRAY_CUH_
