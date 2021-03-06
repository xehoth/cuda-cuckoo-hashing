//
// Created by xehoth on 2021/12/11.
//
#include <timer.cuh>
#include <numeric>
#include <iostream>

Timer::Timer() {
  cudaEventCreate(&start_event);
  cudaEventCreate(&end_event);
}

Timer::~Timer() {
  cudaEventDestroy(start_event);
  cudaEventDestroy(end_event);
}

void Timer::start() { cudaEventRecord(start_event, nullptr); }

void Timer::end() {
  cudaEventRecord(end_event, nullptr);
  cudaEventSynchronize(end_event);
  float elapsed;
  cudaEventElapsedTime(&elapsed, start_event, end_event);
  times.push_back(elapsed / 1000.0);
}

void Timer::clear() { times.clear(); }

double Timer::average() const {
  return std::accumulate(times.begin(), times.end(), 0.0) /
         static_cast<double>(times.size());
}

double Timer::stddev() const {
  double sum = std::accumulate(times.begin(), times.end(), 0.0);
  double avg = sum / static_cast<double>(times.size());
  double ret = 0;
  for (auto &v : times) ret += (v - avg) * (v - avg);
  ret = std::sqrt(ret / static_cast<double>(times.size()));
  return ret;
}

void Timer::report(std::uint32_t keys) const {
  double avg = average();
  double mops = keys / 1e6 / avg;
  printf("%-12.6f%-12.6f%-12.6f\n", mops, avg * 1000, 1000 * stddev());
}

std::string Timer::to_string(std::uint32_t keys) const {
  double avg = average();
  double mops = keys / 1e6 / avg;
  return std::to_string(mops) + " " + std::to_string(avg * 1000) + " " +
         std::to_string(1000 * stddev()) + '\n';
}
