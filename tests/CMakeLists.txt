add_subdirectory(bound)
add_subdirectory(insert)
add_subdirectory(lookup)
add_subdirectory(size)
add_subdirectory(correctness)
add_executable(main main.cu)
target_compile_features(main PRIVATE cuda_std_17)
target_link_libraries(
  main PRIVATE
  HashTable::HashTable
  OpenMP::OpenMP_CXX
  insert_test
  lookup_test
  size_test
  bound_test
  correctness_test
)
add_executable(main_test1 main_test1.cu)
target_compile_features(main_test1 PRIVATE cuda_std_17)
target_link_libraries(main_test1 PRIVATE HashTable::HashTable OpenMP::OpenMP_CXX insert_test correctness_test)
add_executable(main_test2 main_test2.cu)
target_compile_features(main_test2 PRIVATE cuda_std_17)
target_link_libraries(main_test2 PRIVATE HashTable::HashTable OpenMP::OpenMP_CXX lookup_test correctness_test)
add_executable(main_test3 main_test3.cu)
target_compile_features(main_test3 PRIVATE cuda_std_17)
target_link_libraries(main_test3 PRIVATE HashTable::HashTable OpenMP::OpenMP_CXX size_test correctness_test)
add_executable(main_test4 main_test4.cu)
target_compile_features(main_test4 PRIVATE cuda_std_17)
target_link_libraries(main_test4 PRIVATE HashTable::HashTable OpenMP::OpenMP_CXX bound_test correctness_test)