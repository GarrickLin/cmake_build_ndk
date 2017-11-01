#!/usr/bin/env bash

set -e

if [ -z "$NDK_ROOT" ]; then
    echo "NDK_ROOT should be set for Android build"
    exit 1
fi

# set up envs
ANDROID_ROOT=E:/workspace/android/cmake_build_ndk
THIRD_PARTY_ROOT=$ANDROID_ROOT/../3rdparty/src
ANDROID_TOOLCHAIN_FILE=$ANDROID_ROOT/android-cmake/android.toolchain.cmake
ANDROID_NATIVE_API_LEVEL=21
ANDROID_BUILD_JOBS=2
ANDROID_ABIS=(arm64-v8a)
# MINICAFFE_JNILIBS=$ANDROID_ROOT/jniLibs

echo "Android Build Root: $ANDROID_ROOT"
echo "Android NDK Root: $NDK_ROOT"
echo "Android Native API Level: $ANDROID_NATIVE_API_LEVEL"

# # check host system
# if [ "$(uname)" = "Darwin" ]; then
#     HOST_OS=darwin
# elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
#     HOST_OS=linux
# elif [ "$(expr substr $(uname -s) 1 10)" = "MINGW64_NT" ]; then
#     HOST_OS=windows
# else
#     echo $HOST_OS
#     echo "Unknown OS"
#     exit 1
# fi

# if [ "$(uname -m)" = "x86_64"  ]; then
#     HOST_BIT=x86_64
# else
#     HOST_BIT=x86
# fi

function build_project {
    NATIVE_ROOT=$ANDROID_ROOT/native_project
    SOURCE_BUILD=$NATIVE_ROOT/build
    mkdir -p $SOURCE_BUILD
    cd $SOURCE_BUILD
    echo `pwd`
    echo $NATIVE_ROOT
    echo ANDROID_TOOLCHAIN_FILE, $ANDROID_TOOLCHAIN_FILE
    echo NDK_ROOT, $NDK_ROOT
    echo ANDROID_ABI $ANDROID_ABI    
    cmake   -DCMAKE_TOOLCHAIN_FILE=$ANDROID_TOOLCHAIN_FILE \
            -DANDROID_NDK=$NDK_ROOT \
            -DANDROID_ABI=$ANDROID_ABI \
            -DANDROID_NATIVE_API_LEVEL=$ANDROID_NATIVE_API_LEVEL \
            -DCMAKE_BUILD_TYPE=Release \    
            -DANDROID_EXTRA_LIBRARY_PATH=$ANDROID_ROOT/$ANDROID_ABI-install \      
            -G "Unix Makefiles"
            $NATIVE_ROOT
    make -j$ANDROID_BUILD_JOBS
} 

for ANDROID_ABI in ${ANDROID_ABIS[@]}; do
    echo "Build for $ANDROID_ABI"
    build_project
done    