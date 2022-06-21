cmake_minimum_required(VERSION 3.10)
# set the project name and version
project(CW2)

set(CMAKE_CXX_STANDARD 17)      #optional

# add the executable
add_executable(main m.cpp)

# Add the mylib2
set(mylib2_DIR "../../../Templates/mylib2.build/my-install/lib/cmake/mylib2")
find_package(mylib2 1.2.3)

# Add the my_test
set(my_test_DIR "../my_test.build/my-install/lib/cmake/my_test")
find_package(my_test 1.2.3)
target_link_libraries(main PUBLIC mylib2::mylib2 my_test::my_test)


add_custom_target(run ALL main COMMENTS "Running the program")
