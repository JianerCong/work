cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(my_test VERSION 1.0)

set(mylib2_DIR "../../../Templates/mylib2.build/my-install/lib/cmake/mylib2")
message( "mylib2_DIR is ${mylib2_DIR}")
find_package(mylib2 1.2.3)
# create the library

set(pkg my_test)
set(src test.cpp tester.cpp)

# add_library(${pkg} STATIC ${src})

include("../../../Templates/scripts/myfuncs.cmake")
my_add_package(${pkg} 1.2.3 "${src}")
# Quote the variable as you pass it to the macro: "{$src}", so that the whole
# list is passed to the parameter ${src}

# Note: since the downstream dependencies depends on this PUBLICly, so this
# library should publicly depends on mylib2::mylib2, contrast to our tutoral
target_link_libraries(my_test PUBLIC mylib2::mylib2)

# add the executable
add_executable(my_test_run my_test.cpp)
target_link_libraries(my_test_run PUBLIC my_test)
target_compile_definitions(my_test PUBLIC TEST)

add_custom_target(run_my_test ALL my_test_run COMMENT "Run the program")   #run the program
