#add_executable(test1 test1.cu)
#target_compile_features(test1 PRIVATE cuda_std_17)
#target_link_libraries(test1 PRIVATE HashTable::HashTable OpenMP::OpenMP_CXX)
#
#add_executable(test2 test2.cu)
#target_compile_features(test2 PRIVATE cuda_std_17)
#target_link_libraries(test2 PRIVATE HashTable::HashTable OpenMP::OpenMP_CXX)
#
#add_executable(test3 test3.cu)
#target_compile_features(test3 PRIVATE cuda_std_17)
#target_link_libraries(test3 PRIVATE HashTable::HashTable OpenMP::OpenMP_CXX)
#
#add_executable(test4 test4.cu)
#target_compile_features(test4 PRIVATE cuda_std_17)
#target_link_libraries(test4 PRIVATE HashTable::HashTable OpenMP::OpenMP_CXX)
#

add_subdirectory(insert)
add_executable(main main.cu)
target_compile_features(main PRIVATE cuda_std_17)
target_link_libraries(main PRIVATE HashTable::HashTable OpenMP::OpenMP_CXX insert_test)