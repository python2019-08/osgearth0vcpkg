# android-asan-toolchain.cmake
# 更好的方法：继承标准 NDK 工具链，然后添加 ASAN
# /mnt/disk2/abner/zdev/nv/osgearth0vcpkg/cmake/arm64-android-asan-toolchain.cmake

# 首先包含标准 NDK 工具链
# set(ANDROID_NDK_HOME  "/home/abner/Android/Sdk/ndk/27.1.12297006")
include("/home/abner/Android/Sdk/ndk/27.1.12297006/build/cmake/android.toolchain.cmake")

# # 然后添加 ASAN 配置
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fsanitize=address -fno-omit-frame-pointer -g -O1 -fPIC")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=address -fno-omit-frame-pointer -g -O1 -fPIC")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fsanitize=address")
set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -fsanitize=address")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fsanitize=address")

# 注：CMAKE_BUILD_TYPE的set会让 sqlite3的头文件无法生成，古怪。。。
# set(CMAKE_BUILD_TYPE Debug) 
 
# 确保标志不被覆盖
set(CMAKE_C_FLAGS_INIT "-fsanitize=address -fno-omit-frame-pointer -g -O1 -fPIC")
set(CMAKE_CXX_FLAGS_INIT "-fsanitize=address -fno-omit-frame-pointer -g -O1 -fPIC")