//
// Created by 82454 on 2021/12/11.
//

#ifndef CS121_LAB2_INCLUDE_HELPER_CUH_
#define CS121_LAB2_INCLUDE_HELPER_CUH_
#include <cstdio>

#define cuda_foreach_unsigned(_, start, end)                              \
  for (std::uint32_t _ = (start) + blockDim._ * blockIdx._ + threadIdx._; \
       _ < (end); _ += blockDim._ * gridDim._)

#define checkCudaErrors(val) doCheckCudaErrors((val), #val, __FILE__, __LINE__)

template <typename T>
static void doCheckCudaErrors(T result, const char *const func,
                              const char *const file, const int line) {
  if (result) {
    fprintf(stderr, "CUDA error at %s:%d code=%d(%s) \"%s\" \n", file, line,
            static_cast<unsigned int>(result), cudaGetErrorName(result), func);
    exit(EXIT_FAILURE);
  }
}

#endif  // CS121_LAB2_INCLUDE_HELPER_CUH_
