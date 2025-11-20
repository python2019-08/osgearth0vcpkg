set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CMAKE_SYSTEM_NAME Android)
set(VCPKG_CMAKE_SYSTEM_VERSION 28)
set(VCPKG_MAKE_BUILD_TRIPLET "--host=aarch64-linux-android")
set(VCPKG_CMAKE_CONFIGURE_OPTIONS -DANDROID_ABI=arm64-v8a)


set(ENABLE_ASAN   TRUE)

if(ENABLE_ASAN)
	message(STATUS "HAHA....triplets/arm64-android-asan.cmake: ENABLE_ASAN=TRUE....")
	# Android NDK 配置
	set(VCPKG_ANDROID_NDK_HOME $ENV{ANDROID_NDK_HOME})
	message(STATUS "HAHA....triplets/arm64-android-asan.cmake: VCPKG_ANDROID_NDK_HOME=${VCPKG_ANDROID_NDK_HOME}")
	# use customed android toolchain file
	set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "/home/abner/abner2/zdev/nv/osgearth0vcpkg/cmake/arm64-android-asan-toolchain.cmake")
	set(VCPKG_C_FLAGS "${VCPKG_C_FLAGS} -DURI_NO_REALLOCARRAY")
	set(VCPKG_CXX_FLAGS "${VCPKG_CXX_FLAGS} -DURI_NO_REALLOCARRAY")

	# ----- cmake/android-asan-toolchain.cmake里已经存在  "-fPIC"了，此处不需要了
	# set(VCPKG_CMAKE_C_FLAGS "-fPIC")
	# set(VCPKG_CMAKE_CXX_FLAGS "-fPIC")
  
	# #----统一的编译标志（ASan + PIC），很遗憾这里的ASan编译标志没起作用
	# set(VCPKG_C_FLAGS "-fsanitize=address -fno-omit-frame-pointer -g -O1   -DNO_CPL_MULTIPROC_PTHREAD")
	# set(VCPKG_CXX_FLAGS "-fsanitize=address -fno-omit-frame-pointer -g -O1   -DNO_CPL_MULTIPROC_PTHREAD")
	# set(VCPKG_LINKER_FLAGS "-fsanitize=address")
 
	# 在 arm64-android-asan.cmake 中添加
	set(VCPKG_CMAKE_CONFIGURE_OPTIONS ${VCPKG_CMAKE_CONFIGURE_OPTIONS}
	    -DHAVE_REALLOCARRAY=OFF
	    -DURI_NO_REALLOCARRAY=ON
	    -DOSGEARTH_BUILD_TOOLS=OFF   
	    -DOSGEARTH_BUILD_EXAMPLES=OFF   
	    -DOSGEARTH_BUILD_IMGUI_NODEKIT=OFF 
		-DFT_REQUIRE_BROTLI=OFF
		-DHAVE_POSIX_SPAWNP=OFF
	)

	# # 在 triplet 中添加 GEOS 特定的选项,但是很遗憾error了
	# set(VCPKG_CMAKE_CONFIGURE_OPTIONS
	#     ${VCPKG_CMAKE_CONFIGURE_OPTIONS}
	#     -DCMAKE_C_FLAGS="-fsanitize=address -fno-omit-frame-pointer -g -O1 -fPIC"
	#     -DCMAKE_CXX_FLAGS="-fsanitize=address -fno-omit-frame-pointer -g -O1 -fPIC"
	#     -DCMAKE_EXE_LINKER_FLAGS="-fsanitize=address"
	#     -DCMAKE_SHARED_LINKER_FLAGS="-fsanitize=address"
	#     -DCMAKE_MODULE_LINKER_FLAGS="-fsanitize=address"
	# )
else()
    message(FATAL_ERROR "ERROR:....triplets/arm64-android-asan.cmake: ENABLE_ASAN=FALSE....")	
endif()	