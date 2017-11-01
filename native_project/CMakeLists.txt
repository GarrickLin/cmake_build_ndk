cmake_minimum_required(VERSION 3.1)
project(mxnet_predict_jni)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

link_directories(${CMAKE_SOURCE_DIR}/lib)
add_library(mxnet_predict_jni SHARED src/predictor.cc)
target_link_libraries(mxnet_predict_jni mxnet)