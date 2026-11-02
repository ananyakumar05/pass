cmake_minimum_required(VERSION 3.20)
project(UnifiedEngineeringWorkbench VERSION 0.1.0 LANGUAGES CXX)

if(APPLE)
    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15" CACHE STRING "Minimum supported macOS version")
endif()

find_package(Qt5 5.15 REQUIRED COMPONENTS Widgets Concurrent)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(UEW_BUILD_TESTS "Build workbench tests" ON)
option(UEW_BUILD_BENCHMARK "Build the reproducible benchmark command-line tool" ON)

add_library(uew_core
    src/backend/geometry/geometry_parser.cpp
    src/backend/hardware/mock_adapters.cpp
    src/backend/neural_network/backprop.cpp
    src/backend/performance/batch_runner.cpp
    src/backend/thermal/thermal_solver.cpp
)
target_include_directories(uew_core PUBLIC src/backend)
target_compile_features(uew_core PUBLIC cxx_std_17)
find_package(Threads REQUIRED)
target_link_libraries(uew_core PUBLIC Threads::Threads)

add_executable(UnifiedEngineeringWorkbench
    src/frontend/app/main.cpp
    src/frontend/app/mainwindow.cpp
    src/frontend/widgets/geometry_canvas.cpp
)
target_include_directories(UnifiedEngineeringWorkbench PRIVATE src/frontend/app src/frontend/widgets)
target_link_libraries(UnifiedEngineeringWorkbench PRIVATE uew_core Qt5::Widgets Qt5::Concurrent)

add_executable(uew_capture_walkthrough
    tools/capture_walkthrough.cpp
    src/frontend/app/mainwindow.cpp
    src/frontend/widgets/geometry_canvas.cpp
)
target_include_directories(uew_capture_walkthrough PRIVATE src/backend src/frontend/app src/frontend/widgets)
target_link_libraries(uew_capture_walkthrough PRIVATE uew_core Qt5::Widgets Qt5::Concurrent)

if(WIN32)
    add_executable(Launch WIN32 packaging/windows/launch_windows.cpp)
    target_compile_features(Launch PRIVATE cxx_std_17)
endif()

if(MSVC)
    target_compile_options(uew_core PRIVATE /W4 /permissive-)
else()
    target_compile_options(uew_core PRIVATE -Wall -Wextra -Wpedantic)
endif()

if(UEW_BUILD_BENCHMARK)
    add_executable(uew_benchmark tools/benchmark_main.cpp)
    target_link_libraries(uew_benchmark PRIVATE uew_core)
endif()

add_executable(backprop_demo tools/backprop_demo.cpp)
target_link_libraries(backprop_demo PRIVATE uew_core)

add_executable(thermal_results tools/thermal_results.cpp)
target_link_libraries(thermal_results PRIVATE uew_core)

if(UEW_BUILD_TESTS)
    enable_testing()
    add_executable(thermal_tests tests/thermal/thermal_tests.cpp)
    target_link_libraries(thermal_tests PRIVATE uew_core)
    add_test(NAME thermal_tests COMMAND thermal_tests)

    add_executable(geometry_tests tests/geometry/geometry_tests.cpp)
    target_link_libraries(geometry_tests PRIVATE uew_core)
    add_test(NAME geometry_tests COMMAND geometry_tests)
    add_executable(performance_tests tests/performance/performance_tests.cpp)
    target_link_libraries(performance_tests PRIVATE uew_core)
    add_test(NAME performance_tests COMMAND performance_tests)
    add_executable(backprop_tests tests/neural_network/backprop_tests.cpp)
    target_link_libraries(backprop_tests PRIVATE uew_core)
    add_test(NAME backprop_tests COMMAND backprop_tests)
    add_executable(hardware_tests tests/hardware/hardware_tests.cpp)
    target_link_libraries(hardware_tests PRIVATE uew_core)
    add_test(NAME hardware_tests COMMAND hardware_tests)
    set_tests_properties(thermal_tests geometry_tests performance_tests backprop_tests hardware_tests PROPERTIES WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}")
endif()
