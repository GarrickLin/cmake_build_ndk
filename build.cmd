mkdir native_project/build
cd native_project/build
cmake -DCMAKE_TOOLCHAIN_FILE=E:/workspace/android/cmake_build_ndk/android-cmake/android.toolchain.cmake -DANDROID_NDK=D:/SDK/android-ndk-r13b -DANDROID_ABI=arm64-v8a -DANDROID_NATIVE_API_LEVEL=21 -DCMAKE_BUILD_TYPE=Release -G"Unix Makefiles" ..
make -j2