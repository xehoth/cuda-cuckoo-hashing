add_executable(main main.cu)
target_compile_features(main PRIVATE cuda_std_17)
target_link_libraries(main PRIVATE HashTable::HashTable OpenMP::OpenMP_CXX)