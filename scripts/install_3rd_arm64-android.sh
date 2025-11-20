#!/usr/bin/env bash
# ----------------------------------------------------------------
# ## version of my vcpkg 
# 
# ```sh
# (base) abner@abner-XPS:~/programs/vcpkg$ git log -n 2
# commit 0804e3b55b7e435c593707071052363fa876f170 (HEAD -> master, origin/master, origin/HEAD)
# Author: CQ_Undefine <60255716+cqundefine@users.noreply.github.com>
# Date:   Sat Nov 15 05:37:56 2025 +0100

#     [libvpx] Fix support for NetBSD (#48300)
# ```
# ----------------------------------------------------------------
# 使用环境变量覆盖
# ANDROID_NDK_HOME​ ​:后来 Android Studio 和 Gradle 更倾向于使用此变量。  
export ANDROID_NDK_ROOT=/home/abner/Android/Sdk/ndk/27.1.12297006     
export ANDROID_NDK_HOME="${ANDROID_NDK_ROOT}" 
export ANDROID_NDK="${ANDROID_NDK_ROOT}" 

# export VCPKG_CHAINLOAD_TOOLCHAIN_FILE="${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake"
 
# #------ "-fPIC"
# export VCPKG_C_FLAGS="${VCPKG_C_FLAGS} -DNO_CPL_MULTIPROC_PTHREAD -fPIC"
# export VCPKG_CXX_FLAGS="${VCPKG_CXX_FLAGS} -DNO_CPL_MULTIPROC_PTHREAD -fPIC"
 
# export VCPKG_CMAKE_C_FLAGS="-fPIC"
# export VCPKG_CMAKE_CXX_FLAGS="-fPIC"

# # 强制注入 -fPIC
# export VCPKG_CMAKE_CONFIGURE_OPTIONS="${VCPKG_CMAKE_CONFIGURE_OPTIONS} -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC"

# #------ asan ---注: 这些asan选项实际上没起作用
# export VCPKG_C_FLAGS="${VCPKG_C_FLAGS} -fsanitize=address -fno-omit-frame-pointer -g -O1" 
# export VCPKG_CXX_FLAGS="${VCPKG_CXX_FLAGS} -fsanitize=address -fno-omit-frame-pointer -g -O1"
# export VCPKG_LINKER_FLAGS="${VCPKG_LINKER_FLAGS} -fsanitize=address"
# ----------- 注: 这些asan选项实际上没起作用
# export CFLAGS="-fsanitize=address -fno-omit-frame-pointer -g -O1 -fPIC"
# export CXXFLAGS="-fsanitize=address -fno-omit-frame-pointer -g -O1 -fPIC"
# export LDFLAGS="-fsanitize=address"
 
# ----------------------------------------------------------------
set -x
# /home/abner/programs/vcpkg/buildtrees/detect_compiler/stdout-arm64-android.log
# See logs for more information:
#   /home/abner/programs/vcpkg/buildtrees/detect_compiler/config-arm64-android-rel-CMakeCache.txt.log
#   /home/abner/programs/vcpkg/buildtrees/detect_compiler/config-arm64-android-rel-out.log
#   /home/abner/programs/vcpkg/buildtrees/detect_compiler/config-arm64-android-rel-err.log

# cd ${VCPKG_ROOT} && rm -fr   buildtrees/ downloads/ installed/ packages/ 
#  /home/abner/programs/vcpkg/triplets/arm64-android.cmake
IS_ENABLE_ASAN=0
TRIPLET_NAME="arm64-android"
if [ "${IS_ENABLE_ASAN}" = "true" ]; then
       TRIPLET_NAME="arm64-android-asan"
fi
echo "scripts/install_3rd_arm64-android.sh:...TRIPLET_NAME=${TRIPLET_NAME}"
# echo "================================="
VCPKG_ROOT="/home/abner/programs/vcpkg"
echo "=================================" 
 
${VCPKG_ROOT}/vcpkg install --triplet=${TRIPLET_NAME} zlib  minizip uriparser expat lunasvg sqlite3

${VCPKG_ROOT}/vcpkg install --triplet=${TRIPLET_NAME}  openssl    curl    freetype  \
       proj   geos    libjpeg-turbo    libpng   tiff  libxml2   expat   json-c  \
       liblzma openjpeg   libzip   libwebp     libgeotiff zlib  protobuf  libiconv


${VCPKG_ROOT}/vcpkg  install gdal[curl,geos,libkml,libxml2,openssl,png,qhull,sqlite3,webp,lzma,iconv,jpeg]:${TRIPLET_NAME} \
          --triplet=${TRIPLET_NAME}   --overlay-ports=custom-ports   --recurse
 
 
# # 明确禁用不需要的功能 
# ${VCPKG_ROOT}/vcpkg install osgearth  \
#     --triplet=${TRIPLET_NAME} \
#     --overlay-ports=custom-ports \
#     --recurse   --allow-unsupported   
 

set +x