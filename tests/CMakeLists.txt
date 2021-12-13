add_subdirectory(bound)
add_subdirectory(insert)
add_subdirectory(lookup)
add_subdirectory(size)
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
)