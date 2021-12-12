//
// Created by xehoth on 2021/12/11.
//

#ifndef CS121_LAB2_INCLUDE_TIMER_CUH_
#define CS121_LAB2_INCLUDE_TIMER_CUH_
#include <cuda_runtime.h>
#include <vector>
#include <cstdint>
#include <string>

class Timer {
 public:
  Timer();
  ~Timer();

  void start();
  void end();
  void clear();
  [[nodiscard]] double average() const;
  [[nodiscard]] double stddev() const;
  void report(std::uint32_t keys) const;
  [[nodiscard]] std::string to_string(std::uint32_t keys) const;

 private:
  std::vector<double> times;
  cudaEvent_t start_event{};
  cudaEvent_t end_event{};
};
#endif  // CS121_LAB2_INCLUDE_TIMER_CUH_
