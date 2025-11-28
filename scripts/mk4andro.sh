#!/bin/bash
# **************************************************************************
# false  ;;;   ./mk4andro.sh  >ba.txt 2>&1
startTm=$(date +%Y/%m/%d--%H:%M:%S) 

# 输出脚本名称
echo "mk4ubuntu.sh: param 0=$0"
# 获取脚本的物理绝对路径（解析软链接）
SCRIPT_PHYSICAL_PATH=$(readlink -f "$0")
echo "Physical path: $SCRIPT_PHYSICAL_PATH"
#--额外：获取脚本所在目录的绝对路径
# Repo_ROOT=$(dirname "$SCRIPT_PHYSICAL_PATH") 
#--当/home/abner/abner2 是 实际路径/mnt/disk2/abner/ 的软链接时，Repo_ROOT应该是 软链接目录下的路径，
#--否则，cmake 在使用CMAKE_PREFIX_PATH查找 xxxConfig.cmake 时有歧义、混淆，从而编译失败。
#--所以这里强制指定为：
# changable(1)
Repo_ROOT=/home/abner/abner2/zdev/nv/osgearth0vcpkg  
echo "Repo_ROOT=${Repo_ROOT}"
# 验证路径是否存在
if [ ! -d "$Repo_ROOT" ]; then
    echo "Error: Repo_ROOT does not exist: $Repo_ROOT"
    exit 1
fi 
echo "============================================================="
# changable(2)
is_enable_ASAN=true    # false
isRebuild=true
# ----
isFinished_build_osg=true
isFinished_build_oearth=false
# echo "============================================================="
# ###定义要编译的 Android ABI 列表::vcpkg默认只支持"arm64-v8a"和"x86_64"。
# ABIS=("arm64-v8a"  "x86_64"   "armeabi-v7a"  "x86" )
CMAKE_ANDROID_ARCH_ABI="arm64-v8a"
ABI_LEVEL=24
# ---------------
# ANDROID_NDK_ROOT ​​:早期 Android 工具链（如 ndk-build）和部分开源项目（如 OpenSSL）习惯使用此变量。
# ANDROID_NDK=/home/abner/Android/Sdk/ndk/android-ndk-r27d
export ANDROID_NDK_ROOT=/home/abner/Android/Sdk/ndk/27.1.12297006     
# ANDROID_NDK_HOME​ ​:后来 Android Studio 和 Gradle 更倾向于使用此变量。    
export ANDROID_NDK_HOME="${ANDROID_NDK_ROOT}"
# 确保 NDK 路径已设置（需要根据实际环境修改或通过环境变量传入）
if [ -z "${ANDROID_NDK_HOME}" -o ! -d "${ANDROID_NDK_HOME}"  ]; then
    echo "ERROR: ANDROID_NDK_HOME=${ANDROID_NDK_HOME} not exist!"
    exit 1001
fi
export ANDROID_NDK="${ANDROID_NDK_ROOT}"
# CMAKE_SYSROOT=${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/sysroot
# 
# 设置 NDK 工具链路径（使用 LLVM 工具）
TOOLCHAIN=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64
if [ ! -d "${TOOLCHAIN}"  ]; then
    echo "ERROR: TOOLCHAIN=${TOOLCHAIN} not exist!"
    exit 1001
fi
# 使用统一的 LLVM 工具替代传统工具
export AR=${TOOLCHAIN}/bin/llvm-ar
export AS=${TOOLCHAIN}/bin/llvm-as
export LD=${TOOLCHAIN}/bin/ld.lld
export RANLIB=${TOOLCHAIN}/bin/llvm-ranlib
export STRIP=${TOOLCHAIN}/bin/llvm-strip

# 
ANDRO_TOOLCHAIN_FILE=${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake
if [ ! -f "${ANDRO_TOOLCHAIN_FILE}"  ]; then
    echo "ERROR: ANDRO_TOOLCHAIN_FILE=${ANDRO_TOOLCHAIN_FILE} not exist!"
    exit 1001
fi

export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
export PATH=$PATH:$ANDROID_NDK_HOME
# echo "=============================================================" 
# CMAKE_C_COMPILER=/usr/bin/gcc   # /usr/bin/musl-gcc   # /usr/bin/clang  # 
# CMAKE_CXX_COMPILER=/usr/bin/g++ # /usr/bin/musl-gcc # /usr/bin/clang++  #   
CMAKE_MAKE_PROGRAM=${ANDROID_NDK_HOME}/prebuilt/linux-x86_64/bin/make
if [ ! -f "${CMAKE_MAKE_PROGRAM}"  ]; then
    echo "ERROR: CMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM} not exist!"
    exit 1001
fi
CMAKE_BUILD_TYPE=Debug #RelWithDebInfo
# echo "============================================================="
#------为“./configure --prefix=/path/to/install...”启用ASan 而设置环境变量
# 因为openssl等第三方库不支持HWASan，所以只能使用ASAN
# 参考 https://developer.android.com/ndk/guides/asan#cmake
ENABLE_123ASAN_VAL="OFF"
ASAN_C_FLAGS="" 
ASAN_CXX_FLAGS=""  
ASAN_EXE_LINKER_FLAGS="" 
ASAN_SHARED_LINKER_FLAGS="" 
if [ "${is_enable_ASAN}" = "true" ]; then 
    ENABLE_123ASAN_VAL="ON"
    # -g -O0" # 调试信息 + 无优化 -fno-optimize-sibling-calls
    ASAN_C_FLAGS="-fsanitize=address   -g -O1 -fno-omit-frame-pointer" 
    ASAN_CXX_FLAGS="-fsanitize=address  -g -O1 -fno-omit-frame-pointer"   
    ASAN_EXE_LINKER_FLAGS="-fsanitize=address"     
    ASAN_SHARED_LINKER_FLAGS="-fsanitize=address -Wl,--export-dynamic -Wl,-z,defs"  
    # ANDROID_ARM_MODE=arm 
    # ANDROID_STL=c++_shared        
fi
 
CMAKE_CXX_FLAGS_DEBUG="${CMAKE_CXX_FLAGS_DEBUG} -g -O1 -DDEBUG" 
CMAKE_CXX_FLAGS_RELEASE="${CMAKE_CXX_FLAGS_RELEASE} -O2 -DNDEBUG" 
CMAKE_CXX_FLAGS_RELWITHDEBINFO="${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -O2 -g -DNDEBUG"
CMAKE_CXX_FLAGS_MINSIZEREL="${CMAKE_CXX_FLAGS_MINSIZEREL} -Os -DNDEBUG"

echo "=============================================================" 
BuildROOT=${Repo_ROOT}/build_sh
# rm -fr ./build_by_sh 

BuildROOT_andro=${BuildROOT}/build/android
InstallROOT_andro=${BuildROOT}/install/android
if [ "${is_enable_ASAN}" = "true" ]; then 
    InstallROOT_andro=${BuildROOT}/install/android-asan
fi
mkdir -p ${BuildROOT_andro} 
mkdir -p ${InstallROOT_andro} 
 
# **************************************************************************
VCPKG_ROOT="/home/abner/programs/vcpkg"
# CMAKE_TOOLCHAIN_FILE_fromVCPKG="${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
InstallROOT_vcpkg="${VCPKG_ROOT}/installed/arm64-android-asan"  

get_vcpkgTriplet_byABIName()
{
    local ABIname=$1
    local vcpkgTriplet="arm64-android" 

    # 根据 ABI 选择对应的 NDK 工具链和交叉编译参数
    if [ "${ABIname}" = "arm64-v8a" ];then 
        vcpkgTriplet="arm64-android-asan"  
    elif [ "${ABIname}" = "x86_64" ];then  
        vcpkgTriplet="x64-android"
    else
        echo "ERROR: Unsupported ABI ${ABI}"
        exit 1      
    fi

    echo "${vcpkgTriplet}"
}

VCPKG_Triplet=$(get_vcpkgTriplet_byABIName  "${CMAKE_ANDROID_ARCH_ABI}")
InstallROOT_vcpkg="${VCPKG_ROOT}/installed/${VCPKG_Triplet}"
VCPKG_installed_LN="${InstallROOT_andro}/vcpkg_${VCPKG_Triplet}"
 
# 然后检查符号链接是否需要创建
if [ ! -d "${VCPKG_installed_LN}" ]; then
    echo "创建符号链接: ${VCPKG_installed_LN} -> ${InstallROOT_vcpkg}"
    ln -s "${InstallROOT_vcpkg}" "${VCPKG_installed_LN}"
else
    echo "符号链接已存在: ${VCPKG_installed_LN}"
fi 
 
echo "============================================================="
cmakeCommonParams=(
    "-DCMAKE_TOOLCHAIN_FILE=${ANDRO_TOOLCHAIN_FILE}"  
    "-DANDROID_STL=c++_shared" 
    "-DANDROID_PLATFORM=android-${ABI_LEVEL}"  
    "-DANDROID_NATIVE_API_LEVEL=${ABI_LEVEL}"    
    "-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}"
    "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
    "-DPKG_CONFIG_EXECUTABLE=/usr/bin/pkg-config"
  "-DCMAKE_FIND_ROOT_PATH=${InstallROOT_andro}"
  "-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY"
  "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
  "-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY" # BOTH：先查根路径，再查系统路径    
  "-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY" # 头文件仍只查根路径 
  "-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER"
#   # 是否访问 /usr/include/、/usr/lib/ 等 系统路径   
  "-DCMAKE_FIND_USE_CMAKE_SYSTEM_PATH=OFF"
  # 是否访问PATH\LD_LIBRARY_PATH等环境变量
  "-DCMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH=OFF" 
  "-DCMAKE_FIND_LIBRARY_SUFFIXES=.a"
  "-DCMAKE_POSITION_INDEPENDENT_CODE=ON" 
  "-DBUILD_SHARED_LIBS=OFF"    

    "-DCMAKE_CXX_FLAGS_DEBUG=${CMAKE_CXX_FLAGS_DEBUG} -g -O1 -DDEBUG" 
    "-DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE} -O2 -DNDEBUG" 
    "-DCMAKE_CXX_FLAGS_RELWITHDEBINFO=${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -O2 -g -DNDEBUG"
    "-DCMAKE_CXX_FLAGS_MINSIZEREL=${CMAKE_CXX_FLAGS_MINSIZEREL} -Os -DNDEBUG"
)
    # # 禁用 vcpkg 的自动下载 
    # "-DVCPKG_MANIFEST_MODE=OFF"
    # "-DVCPKG_USE_LOCAL_PORTS=ON"
    # "-DVCPKG_FEATURE_FLAGS=versions,manifests"       
    # "-DVCPKG_OVERLAY_PORTS=${VCPKG_ROOT}/ports"

if [ "${is_enable_ASAN}" = "true" ]; then 
    cmakeCommonParams+=(
      "-DENABLE_123ASAN=${ENABLE_123ASAN_VAL}" 
      "-DANDROID_ARM_MODE=arm" 
      "-DCMAKE_C_FLAGS=${ASAN_C_FLAGS}"
      "-DCMAKE_CXX_FLAGS=${ASAN_CXX_FLAGS}"  
    )
fi

 
echo "cmakeCommonParams=${cmakeCommonParams[@]}"
echo "ANDROID_TOOLCHAIN_ROOT=${ANDROID_TOOLCHAIN_ROOT}"

# **************************************************************************
# functions
prepareBuilding()
{
    local aSubSrcDir="$1"
    local aSubBuildDir="$2"
    local aSubInstallDir="$3"
    local aIsRebuild="$4"
    # ---- check params
    echo "aSubSrcDir=$aSubSrcDir"
    echo "aSubBuildDir=$aSubBuildDir"
    echo "aSubInstallDir=$aSubInstallDir;;aIsRebuild=$aIsRebuild" 
    if  [ -z "$aSubSrcDir" ] || [ ! -d "${aSubSrcDir}" ]; then
        echo "aSubSrcDir=${aSubSrcDir}  NOT exist!"
        exit 1001
    fi    
 
    if  [ -z "$aSubBuildDir" ]; then
        echo "aSubBuildDir=${aSubBuildDir}  is empty string!"
        exit 1002
    fi   

    if  [ -z "$aSubInstallDir" ]; then
        echo "aSubInstallDir=${aSubInstallDir}  is empty string!"
        exit 1002
    fi     

    # ----  if aIsRebuild is true,del old folders
    if [ "${aIsRebuild}" = "true" ]; then 
        # echo "${aSubSrcDir} aIsRebuild ==true..1"          
        rm -fr ${aSubBuildDir}          
        rm -fr ${aSubInstallDir}
        echo "${aSubSrcDir} aIsRebuild ==true..2"       
    else
        rm -fr ${aSubInstallDir}
        echo "${aSubSrcDir} aIsRebuild ==false"      
    fi   

    # ---- 不管是否 Rebuild，都创建 aSubBuildDir 和 aSubInstallDir，
    #      因为configure 不会创建 aSubBuildDir 
    if [ ! -d "${aSubBuildDir}" ]; then
        mkdir -p ${aSubBuildDir} || { 
            echo "mkdir -p ${aSubBuildDir}失败！"
            exit 1002
        } 
    fi    

     
    if  [ ! -d "${aSubInstallDir}" ]; then
        mkdir -p ${aSubInstallDir} || { 
            echo "mkdir -p ${aSubInstallDir}失败！"
            exit 1002
        } 
    fi    


    return 0
}


get_targetHost_byABIName()
{
    local ABIname=$1

    # 根据 ABI 选择对应的 NDK 工具链和交叉编译参数
    case ${ABIname} in
        arm64-v8a)
            TARGET_HOST=aarch64-linux-android
            ;;
        armeabi-v7a)
            TARGET_HOST=arm-linux-androideabi
            ;;
        x86)
            TARGET_HOST=i686-linux-android
            ;;
        x86_64)
            TARGET_HOST=x86_64-linux-android
            ;;
        *)
            echo "ERROR: Unsupported ABI ${ABI}"
            exit 1
            ;;
    esac

    echo "${TARGET_HOST}"
}

g_TARGET_HOST="aarch64-linux-android"
g_TARGET_ARCH="android-x86_64"

get_targetArch_byABILvl()
{
    local ABIname=$1
 
    local targetArch="android-x86_64"
    
    # 根据 ABI 选择对应的 NDK 工具链和交叉编译参数
    case ${ABIname} in
        arm64-v8a) 
            targetArch="android-arm64"
            ;;
        armeabi-v7a) 
            targetArch="android-arm"
            ;;
        x86) 
            targetArch="android-x86"
            ;;
        x86_64)
            targetArch="android-x86_64"
            ;;
        *)
            echo "ERROR: Unsupported ABI ${ABI}"
            exit 1
            ;;
    esac
         
    g_TARGET_ARCH=${targetArch}

    echo "${targetArch}"
}

for ABI in "${ABIS[@]}"; do
    ret_targetHost=$(get_targetHost_byABIName "${ABI}")
    echo "....ret_targetHost=${ret_targetHost}"  
done
 
# **************************************************************************
# **************************************************************************
#  3rd/
# **************************************************************************
SrcDIR_3rd=${Repo_ROOT}/3rd

BuildDir_3rd=${BuildROOT_andro}/3rd

INSTALL_PREFIX_3rd=${InstallROOT_andro}/3rd

# -------------------------------------------------
# osg 
# -------------------------------------------------
if [ "${isFinished_build_osg}" != "true" ] ; then 
    echo "========== building osg 4 Android========== " &&  sleep 1

    SrcDIR_lib=${SrcDIR_3rd}/osg
 
        
        BuildDIR_lib=${BuildDir_3rd}/osg/$CMAKE_ANDROID_ARCH_ABI
        INSTALL_PREFIX_osg=${INSTALL_PREFIX_3rd}/osg/$CMAKE_ANDROID_ARCH_ABI
        prepareBuilding  ${SrcDIR_lib} ${BuildDIR_lib} ${INSTALL_PREFIX_osg} ${isRebuild}     
 
        # _LINKER_FLAGS="-L${lib_dir} -lcurl -ltiff -ljpeg -lsqlite3 -lprotobuf -lpng -llzma -lz"
        # _LINKER_FLAGS="${_LINKER_FLAGS} -L${lib64_dir} -lssl -lcrypto"      
  
        # <<osg的间接依赖库>>
        # 依赖关系：osg -->gdal-->curl-->libpsl， 所以OSG 的 CMake 配置需要确保在
        # target_link_libraries 时包含所有 cURL 所依赖的库(osg的间接依赖库)。
        # 这通常在 CMakeLists.txt中通过 find_package(CURL)返回的导入型目标CURL::libCurl获得或直接在
        # CMake -S -B命令中加 -DCMAKE_EXE_LINKER_FLAGS或CMAKE_SHARED_LINKER_FLAGS来添加缺失的库。​  
        _curlLibs_array=()
        _curlLibs_array+=("${VCPKG_installed_LN}/lib/libcurl.a")
        _curlLibs_array+=("${VCPKG_installed_LN}/lib/libssl.a")
        _curlLibs_array+=("${VCPKG_installed_LN}/lib/libcrypto.a")
        _curlLibs_array+=("${VCPKG_installed_LN}/lib/libpsl.a")
        _curlLibs_array+=("${VCPKG_installed_LN}/lib/libz.a")
        # _curlLibs_array+=("${VCPKG_installed_LN}/lib/libzstd.a")
        # 转换为分号分隔的字符串
        printf -v _curlLibs "%s;" "${_curlLibs_array[@]}"
        _curlLibs="${_curlLibs%;}"  # 移除最后一个分号 
        echo "osg==========_curlLibs=${_curlLibs}" 


        #  
        echo "=== cmake -S ${SrcDIR_lib} -B ${BuildDIR_lib}  --debug-find ......"
        TARGET_HOST=$(get_targetHost_byABIName "${CMAKE_ANDROID_ARCH_ABI}")
        OPENGL_gl_LIBRARY=${CMAKE_SYSROOT}/usr/lib/${TARGET_HOST}/${ABI_LEVEL}/libGLESv3.so
 
 
        # --debug-find    --debug-output 
        cmake -S ${SrcDIR_lib} -B ${BuildDIR_lib}  --debug-find     \
            "${cmakeCommonParams[@]}"    -DANDROID_ABI=${CMAKE_ANDROID_ARCH_ABI}  \
            -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX_osg}  \
            -DCMAKE_C_FLAGS="${ASAN_C_FLAGS}  -fPIC"             \
            -DCMAKE_CXX_FLAGS="${ASAN_CXX_FLAGS}  -fPIC -std=c++14" \
            -DBUILD_SHARED_LIBS=OFF  \
        -DCMAKE_DEBUG_POSTFIX=""   \
        -DDYNAMIC_OPENTHREADS=OFF   \
        -DDYNAMIC_OPENSCENEGRAPH=OFF \
        -DANDROID=ON    -DOPENTHREADS_ATOMIC_USE_MUTEX=ON  \
        -DOSG_GL1_AVAILABLE=OFF \
        -DOSG_GL2_AVAILABLE=OFF \
        -DOSG_GL3_AVAILABLE=OFF \
        -DOSG_GLES1_AVAILABLE=OFF \
        -DOSG_GLES2_AVAILABLE=OFF \
        -DOSG_GLES3_AVAILABLE=ON  \
        -DOSG_GL_LIBRARY_STATIC=OFF \
        -DOSG_GL_DISPLAYLISTS_AVAILABLE=OFF \
        -DOSG_GL_MATRICES_AVAILABLE=OFF \
        -DOSG_GL_VERTEX_FUNCS_AVAILABLE=OFF \
        -DOSG_GL_VERTEX_ARRAY_FUNCS_AVAILABLE=OFF \
        -DOSG_GL_FIXED_FUNCTION_AVAILABLE=OFF \
        -DOPENGL_PROFILE="GLES3" \
        -DOPENGL_gl_LIBRARY=${OPENGL_gl_LIBRARY} \
        -DOSG_FIND_3RD_PARTY_DEPS=OFF  \
        -DCURL_INCLUDE_DIR=${VCPKG_installed_LN}/include    \
        -DCURL_LIBRARY=CURL::libcurl   \
        -DCURL_LIBRARIES="${_curlLibs}" \
        -DNO_DEFAULT_PATH=ON \
        -DZLIB_USE_STATIC_LIBS=ON                       \
        -DZLIB_INCLUDE_DIR=${VCPKG_installed_LN}/include  \
        -DZLIB_LIBRARY=${VCPKG_installed_LN}/lib/libz.a    \
        -DZLIB_LIBRARIES="${VCPKG_installed_LN}/lib/libz.a" \
        -DJPEG_INCLUDE_DIR=${VCPKG_installed_LN}/include    \
        -DJPEG_LIBRARY=${VCPKG_installed_LN}/lib/libjpeg.a   \
        -DJPEG_LIBRARIES=${VCPKG_installed_LN}/lib/libjpeg.a  \
        -DPNG_INCLUDE_DIR=${VCPKG_installed_LN}/include      \
        -DPNG_PNG_INCLUDE_DIR="${VCPKG_installed_LN}/include" \
        -DPNG_LIBRARY=${VCPKG_installed_LN}/lib/libpng.a       \
        -DPNG_LIBRARIES=${VCPKG_installed_LN}/lib/libpng.a      \
        -DOpenSSL_USE_STATIC_LIBS=ON                               \
        -DOPENSSL_INCLUDE_DIR=${VCPKG_installed_LN}/include          \
        -DOPENSSL_SSL_LIBRARY=${VCPKG_installed_LN}/lib/libssl.a      \
        -DOPENSSL_CRYPTO_LIBRARY=${VCPKG_installed_LN}/lib/libcrypto.a \
        -DTIFF_INCLUDE_DIR=${VCPKG_installed_LN}/include   \
        -DTIFF_LIBRARY=${VCPKG_installed_LN}/lib/libtiff.a  \
        -DTIFF_LIBRARIES=${VCPKG_installed_LN}/lib/libtiff.a \
        -DFREETYPE_INCLUDE_DIRS=${VCPKG_installed_LN}/include \
        -DFREETYPE_LIBRARY=${VCPKG_installed_LN}/lib/libfreetyped.a      \
        -DFREETYPE_LIBRARIES=${VCPKG_installed_LN}/lib/libfreetyped.a     \
        -DGDAL_INCLUDE_DIR=${VCPKG_installed_LN}/include   \
        -DGDAL_LIBRARY=${VCPKG_installed_LN}/lib/libgdal.a  



        # -DCMAKE_PREFIX_PATH="${cmkPrefixPath}"      \
        # -DCMAKE_MODULE_PATH="${osg_MODULE_PATH}"     \

        # -DFREETYPE_DIR=${VCPKG_installed_LN}/lib/freetype              \
        # -DCURL_DIR="${VCPKG_installed_LN}/lib/cmake/CURL" \
        # -DGDAL_DIR=${VCPKG_installed_LN}                  \   
        # -DOpenSSL_DIR="${VCPKG_installed_LN}/lib/cmake/OpenSSL"   \
        # -DOPENSSL_ROOT_DIR="${VCPKG_installed_LN}"                 \             
        # -DJPEG_DIR= \
        # -DOpenSSL_DIR="${INSTALL_PREFIX_openssl}/lib/cmake/OpenSSL"  \
        # -DCMAKE_LIBRARY_PATH="/usr/lib/gcc/x86_64-linux-gnu/13" \
 
        # -DCMAKE_EXE_LINKER_FLAGS="-llog -landroid" \
 
        # (1)关于-DCURL_LIBRARY="CURL::libcurl" ：
        #  -DCURL_LIBRARY="${INSTALL_PREFIX_curl}/lib/libcurl-d.a"  ## 根据一般的规则，ok
        #  -DCURL_LIBRARIES="CURL::libcurl" ## 根据一般的规则，ok
        #  -DCURL_LIBRARY="CURL::libcurl" ##  特定于osg项目，是ok的，因为osg/src/osgPlugins/curl/CMakeLists.txt中
        #     ## SET(TARGET_LIBRARIES_VARS   CURL_LIBRARY     ZLIB_LIBRARIES)用的是CURL_LIBRARY而不是CURL_LIBRARIES
        
        # (2)Glibc 的某些函数（如网络相关）在静态链接时需要动态库支持,使用libc.a和libm.a会导致 collect2: error: ld returned 1 exit status
        #     
        # (3) -DZLIB_ROOT=${INSTALL_PREFIX_zlib} \
        # (4) osg/src/osgPlugins/png/CMakeLists.txt中强制 SET(TARGET_LIBRARIES_VARS PNG_LIBRARY ZLIB_LIBRARIES )
        #    而 lib/cmake/PNG/PNGConfig.cmake 中 没提供PNG_LIBRARY
        #    所以 cmake -S -B 必须添加 -DPNG_LIBRARY=${INSTALL_PREFIX_png}/lib/libpng.a
        # (5)针对cmakeCommonParams，特化设置：
        #    -DEGL_LIBRARY=  -DEGL_INCLUDE_DIR=  -DEGL_LIBRARY= 
        #    -DOPENGL_EGL_INCLUDE_DIR=  -DOPENGL_INCLUDE_DIR=  -DOPENGL_gl_LIBRARY=
        #    -DPKG_CONFIG_EXECUTABLE= 
        # 
        # -DEGL_LIBRARY=/usr/lib/x86_64-linux-gnu/libEGL.so \
        # -DEGL_INCLUDE_DIR=/usr/include/EGL                 \
        # -DEGL_LIBRARY=/usr/lib/x86_64-linux-gnu/libEGL.so   \
        # -DOPENGL_EGL_INCLUDE_DIR=/usr/include/EGL            \
        # -DOPENGL_INCLUDE_DIR=/usr/include/GL                  \
        # -DOPENGL_gl_LIBRARY=/usr/lib/x86_64-linux-gnu/libGL.so \
        # -DPKG_CONFIG_EXECUTABLE=/usr/bin/pkg-config             \

        # -DBoost_ROOT=${INSTALL_PREFIX_boost}  \ ## 现代CMake（>=3.12）官方标准
        # -DBOOST_ROOT=${INSTALL_PREFIX_boost}  \ ## 旧版兼容（FindBoost.cmake传统方式）
        
        # -DGDAL_LIBRARIES=${INSTALL_PREFIX_gdal}/lib/libgdal.a  \ 
        # -DCMAKE_STATIC_LINKER_FLAGS=${_LINKER_FLAGS}  


 
        echo "=== cmake --build ${BuildDIR_lib} --config ${CMAKE_BUILD_TYPE}  -j$(nproc) -v"
        cmake --build ${BuildDIR_lib} --config ${CMAKE_BUILD_TYPE}  -j$(nproc) -v
        
        echo "=== cmake --install ${BuildDIR_lib} --config ${CMAKE_BUILD_TYPE}"
        cmake --install ${BuildDIR_lib} --config ${CMAKE_BUILD_TYPE}  
 
    echo "========== finished building osg 4 Android ========== " &&  sleep 1 

fi    
 
# -------------------------------------------------
# osgearth 
# -------------------------------------------------
if [ "${isFinished_build_oearth}" != "true" ] ; then 
    echo "========== building osgearth 4 Android========== " &&  sleep 1 # && set -x

    SrcDIR_lib=${SrcDIR_3rd}/osgearth
 
    
    BuildDIR_lib=${BuildDir_3rd}/osgearth/$CMAKE_ANDROID_ARCH_ABI
    INSTALL_PREFIX_osgearth=${INSTALL_PREFIX_3rd}/osgearth/$CMAKE_ANDROID_ARCH_ABI 
    prepareBuilding  ${SrcDIR_lib} ${BuildDIR_lib} ${INSTALL_PREFIX_osgearth} ${isRebuild}  

    # ------
    INSTALL_PREFIX_osg=${INSTALL_PREFIX_3rd}/osg/$CMAKE_ANDROID_ARCH_ABI
    export PKG_CONFIG_PATH="${INSTALL_PREFIX_osg}/lib/pkgconfig:$PKG_CONFIG_PATH"
    
    # ---- cmkPrefixPath
    cmkPrefixPath_array=()
    cmkPrefixPath_array+=("${INSTALL_PREFIX_osg}")
    cmkPrefixPath_array+=(
        "${VCPKG_installed_LN}/share/libzip"
        # "${VCPKG_installed_LN}/share/curl"
        # "${VCPKG_installed_LN}/share/gdal"
        # "${VCPKG_installed_LN}/share/geos" 
    ) 
    # 使用;号连接数组元素.
    # IFS是Shell中的“内部字段分隔符”（Internal Field Separator），默认值包含空格、制表符和换行符
    cmkPrefixPath=$(IFS=";"; echo "${cmkPrefixPath_array[*]}")
    echo "gg==========cmkPrefixPath=${cmkPrefixPath}" 
 

    # ------
    # 2. 清理环境
    unset LD_LIBRARY_PATH
    unset LIBRARY_PATH
    

    TARGET_HOST=$(get_targetHost_byABIName "${CMAKE_ANDROID_ARCH_ABI}")
    VCPKG_Triplet=$(get_vcpkgTriplet_byABIName  "${CMAKE_ANDROID_ARCH_ABI}")
    InstallROOT_vcpkg=${VCPKG_ROOT}/installed/${VCPKG_Triplet} 

    OPENGL_gl_LIBRARY=${CMAKE_SYSROOT}/usr/lib/${TARGET_HOST}/${ABI_LEVEL}/libGLESv3.so
    OPENGL_opengl_LIBRARY=${OPENGL_gl_LIBRARY} 
    OPENGL_EGL_LIBRARY=${CMAKE_SYSROOT}/usr/lib/${TARGET_HOST}/${ABI_LEVEL}/libEGL.so
    OPENGL_GLES3_INCLUDE_DIR=${CMAKE_SYSROOT}/usr/include/GLES3

    OEARTH_C_CXX_FLAGS="-fPIC -DGLES32=1 -DANDROID=1 -DGL_GLEXT_PROTOTYPES=1 -U GDAL_DEBUG -DOSGEARTH_LIBRARY=1"
    # --debug-find    --debug-output 
    cmake -S ${SrcDIR_lib} -B ${BuildDIR_lib}  --debug-find  \
        "${cmakeCommonParams[@]}"  -DANDROID_ABI=${CMAKE_ANDROID_ARCH_ABI}  \
            -DCMAKE_PREFIX_PATH="${cmkPrefixPath}"            \
            -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX_osgearth}  \
            -DCMAKE_C_FLAGS="${ASAN_C_FLAGS} ${OEARTH_C_CXX_FLAGS}"         \
            -DCMAKE_CXX_FLAGS="${ASAN_CXX_FLAGS} ${OEARTH_C_CXX_FLAGS}"      \
            -DBUILD_SHARED_LIBS=OFF   \
        -DNRL_STATIC_LIBRARIES=ON  -DOSGEARTH_BUILD_SHARED_LIBS=OFF \
        -DCMAKE_SKIP_RPATH=ON \
        -DANDROID=ON   -DOPENTHREADS_ATOMIC_USE_MUTEX=ON    \
        -DDYNAMIC_OPENTHREADS=OFF  -DDYNAMIC_OPENSCENEGRAPH=OFF \
        -DOSGEARTH_ENABLE_FASTDXT=OFF \
        -DOSGEARTH_BUILD_TOOLS=OFF       \
        -DOSGEARTH_BUILD_EXAMPLES=OFF     \
        -DOSGEARTH_BUILD_IMGUI_NODEKIT=OFF \
        -DOSG_GL1_AVAILABLE=OFF \
        -DOSG_GL2_AVAILABLE=OFF  \
        -DOSG_GL3_AVAILABLE=OFF   \
        -DOSG_GLES1_AVAILABLE=OFF  \
        -DOSG_GLES2_AVAILABLE=OFF   \
        -DOSG_GLES3_AVAILABLE=ON     \
        -DOSG_GL_LIBRARY_STATIC=OFF   \
        -DOSG_GL_DISPLAYLISTS_AVAILABLE=OFF    \
        -DOSG_GL_MATRICES_AVAILABLE=OFF         \
        -DOSG_GL_VERTEX_FUNCS_AVAILABLE=OFF      \
        -DOSG_GL_VERTEX_ARRAY_FUNCS_AVAILABLE=OFF \
        -DOSG_GL_FIXED_FUNCTION_AVAILABLE=OFF      \
        -DOPENGL_PROFILE="GLES3"                    \
        -DOPENGL_glx_LIBRARY=NOTFOUND              \
        -DOPENGL_opengl_LIBRARY=${OPENGL_opengl_LIBRARY} \
        -DOPENGL_EGL_LIBRARY=${OPENGL_EGL_LIBRARY} \
        -DOPENGL_gl_LIBRARY=${OPENGL_gl_LIBRARY}    \
        -DOPENGL_gles3_LIBRARY=${OPENGL_gl_LIBRARY}  \
        -DOPENGL_INCLUDE_DIR=${OPENGL_GLES3_INCLUDE_DIR}      \
        -DOPENGL_GLES3_INCLUDE_DIR=${OPENGL_GLES3_INCLUDE_DIR} \
        -DOSG_LIBRARY_STATIC=ON \
        -DPKG_CONFIG_EXECUTABLE=/usr/bin/pkg-config \
        -DOpenSceneGraph_FIND_QUIETLY=OFF -DOpenSceneGraph_DEBUG=ON  \
        -DOSG_DIR=${INSTALL_PREFIX_osg}     \
        -DOSG_INCLUDE_DIR=${INSTALL_PREFIX_osg}/include \
        -DOPENSCENEGRAPH_INCLUDE_DIR=${INSTALL_PREFIX_osg}/include \
        -DOPENTHREADS_INCLUDE_DIR=${INSTALL_PREFIX_osg}/include \
        -DLIB_EAY_RELEASE=""          \
        -DOpenSSL_USE_STATIC_LIBS=ON   \
        -DBZIP2_INCLUDE_DIR=${VCPKG_installed_LN}/include  \
        -DBZIP2_LIBRARY_RELEASE=${VCPKG_installed_LN}/lib/libbz2.a \
        -DGDAL_INCLUDE_DIR=${VCPKG_installed_LN}/include  \
        -DGDAL_LIBRARY=${VCPKG_installed_LN}/lib/libgdal.a \
        -DZLIB_INCLUDE_DIR=${VCPKG_installed_LN}/include \
        -DZLIB_LIBRARY=${VCPKG_installed_LN}/lib/libz.a   \
        -DPNG_INCLUDE_DIR=${VCPKG_installed_LN}/include/     \
        -DPNG_PNG_INCLUDE_DIR="${VCPKG_installed_LN}/include" \
        -DPNG_LIBRARY=${VCPKG_installed_LN}/lib/libpng.a       \
        -DJPEG_INCLUDE_DIR=${VCPKG_installed_LN}/include  \
        -DJPEG_LIBRARY=${VCPKG_installed_LN}/lib/libjpeg.a \
        -DTIFF_INCLUDE_DIR=${VCPKG_installed_LN}/include  \
        -DTIFF_LIBRARY=${VCPKG_installed_LN}/lib/libtiff.a \
        -DFREETYPE_INCLUDE_DIR=${VCPKG_installed_LN}/include      \
        -DFREETYPE_LIBRARY=${VCPKG_installed_LN}/lib/libfreetype.a \
        -DCURL_INCLUDE_DIR=${VCPKG_installed_LN}/include    \
        -DCURL_LIBRARY=${VCPKG_installed_LN}/lib/libcurl.a \
        -DSQLite3_INCLUDE_DIR=${VCPKG_installed_LN}/include      \
        -DSQLite3_LIBRARY=${VCPKG_installed_LN}/lib/libsqlite3.a  \
        -DSQLite3_LIBRARIES=${VCPKG_installed_LN}/lib/libsqlite3.a \
        -DGEOS_INCLUDE_DIR=${VCPKG_installed_LN}/include    \
        -DGEOS_LIBRARY=${VCPKG_installed_LN}/lib/libgeos_c.a \
        -DPROJ_INCLUDE_DIR=${VCPKG_installed_LN}/include  \
        -DPROJ_LIBRARY=${VCPKG_installed_LN}/lib/libproj.a \
        -DPROJ4_LIBRARY=${VCPKG_installed_LN}/lib/libproj.a \
        -DGDAL_INCLUDE_DIR=${VCPKG_installed_LN}/include  \
        -DGDAL_LIBRARY=${VCPKG_installed_LN}/lib/libgdal.a \
        -DOPENSSL_INCLUDE_DIR=${VCPKG_installed_LN}/include         \
        -DOPENSSL_SSL_LIBRARY=${VCPKG_installed_LN}/lib/libssl.a     \
        -DSSL_EAY_RELEASE=${VCPKG_installed_LN}/lib/libssl.a          \
        -DOPENSSL_CRYPTO_LIBRARY=${VCPKG_installed_LN}/lib/libcrypto.a    


        # -DCURL_ROOT=${VCPKG_installed_LN}                  \
        # -DFREETYPE_ROOT=${VCPKG_installed_LN}          \
        # -DZLIB_ROOT_DIR="${VCPKG_installed_LN}"         \
        # -DGEOS_DIR=${VCPKG_installed_LN}                   \
        # -DGDAL_ROOT=${VCPKG_installed_LN}                \     
        # -DOPENSSL_ROOT_DIR=${VCPKG_installed_LN}                    \           
            # -DCMAKE_EXE_LINKER_FLAGS="-llog -landroid"  \       

        # (1)/usr/share/cmake-3.28/Modules/FindGLEW.cmake中需要用 ENV GLEW_ROOT。
        # (2)在 CMake 命令行中临时设置环境变量（一次性生效），格式为 
        #   GLEW_ROOT=/path/to/GLEW cmake ...  ，无需提前 export。如：
        #   GLEW_ROOT="/usr/lib/x86_64-linux-gnu/" cmake -S ${SrcDIR_lib} -B ${BuildDIR_lib}\
 
            # (0) osgearth 编译时发生 类型转换错误​​（invalid conversion from 'void*' to 'OGRLayerH'）,
            #     用-DCMAKE_C_FLAGS="-U GDAL_DEBUG" 解决

            # (1) osgearth ->GEOS::geos_c ; osgearth -> gdal -> GEOS::GEOS
            #   GEOS 自身的 install/geos/lib/cmake/GEOS/geos-config.cmake 生成 GEOS::geos 目标 ,
            #   GDAL 自带的 install/gdal/lib/cmake/gdal/packages/FindGEOS.cmake 生成 GEOS::GEOS 目标。
            #   osgearth 的cmakelists.txt中需要GEOS::geos_c，osgearth依赖gdal，而gdal需要GEOS::GEOS,因为
            #   gdal/lib/cmake/gdal/GDAL-targets.cmake  有
            # ```
            # set_target_properties(GDAL::GDAL PROPERTIES
            #     INTERFACE_COMPILE_DEFINITIONS "\$<\$<CONFIG:DEBUG>:GDAL_DEBUG>"
            #     INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"
            #     INTERFACE_LINK_LIBRARIES "\$<LINK_ONLY:ZLIB::ZLIB>;。。。。。。。。。。。\$<LINK_ONLY:GEOS::GEOS>。。。。
            # ```
            # (2)remark: osgearth/src/osgEarth/CMakeLists.txt 
            # ```
            # OPTION(NRL_STATIC_LIBRARIES "Link osgEarth against static GDAL and cURL, including static OpenSSL, Proj4, JPEG, PNG, and TIFF." OFF)
            # if(NOT NRL_STATIC_LIBRARIES)
            # LINK_WITH_VARIABLES(${LIB_NAME} OSG_LIBRARY ... CURL_LIBRARY GDAL_LIBRARY OSGMANIPULATOR_LIBRARY)
            # else(NOT NRL_STATIC_LIBRARIES)
            # LINK_WITH_VARIABLES(${LIB_NAME} OSG_LIBRARY ... CURL_LIBRARY GDAL_LIBRARY OSGMANIPULATOR_LIBRARY 
            #                           SSL_EAY_RELEASE LIB_EAY_RELEASE 
            #                           TIFF_LIBRARY PROJ4_LIBRARY PNG_LIBRARY JPEG_LIBRARY)
            # endif(NOT NRL_STATIC_LIBRARIES)
            # ```
            # (3)
            # OSGDB_LIBRARY  OSGGA_LIBRARY OSGMANIPULATOR_LIBRARY OSGSHADOW_LIBRARY 
            # OSGSIM_LIBRARY OSGTEXT_LIBRARY OSGUTIL_LIBRARY 
            # OSGVIEWER_LIBRARY OSG_LIBRARY
    echo "oe....cmake --build ${BuildDIR_lib} --config ${CMAKE_BUILD_TYPE}  -j$(nproc) -v" 
    cmake --build ${BuildDIR_lib} --config ${CMAKE_BUILD_TYPE}  -j$(nproc) -v
    
    echo "oe....cmake --install ${BuildDIR_lib} --config ${CMAKE_BUILD_TYPE}" 
    cmake --install ${BuildDIR_lib} --config ${CMAKE_BUILD_TYPE}         
 
    echo "========== finished building osgearth 4 Android ========== " # && set +x

fi

 
# **************************************************************************
# **************************************************************************
#  platform/
# ************************************************************************** 
SrcDIR_platform=${Repo_ROOT}/platform
echo  "SrcDIR_platform=${SrcDIR_platform}" 

# **************************************************************************
endTm=$(date +%Y/%m/%d--%H:%M:%S)
printf "${startTm}----${endTm}\n"    