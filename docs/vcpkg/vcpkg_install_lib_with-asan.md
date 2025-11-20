# 1.vcpkg 安装某开源库时，如何指定 asan

在 vcpkg 中指定 ASan（Address Sanitizer）有几种方法，具体取决于您要编译的目标平台。

## 1. 使用特定的 triplet

### 对于 Linux 平台：
```bash
# ~/programs/vcpkg/buildtrees/detect_compiler/stdout-arm64-android-asan.log

# 使用预定义的 asan triplet
vcpkg install opencv:x64-linux-asan

# 或者
vcpkg install opencv --triplet=x64-linux-asan
```

### 对于 Android 平台：
```bash
# Android 的 ASan triplet
vcpkg install opencv:arm64-android-asan
vcpkg install opencv:arm-android-asan
```

## 2. 查看可用的 ASan triplet

```bash
# 查看所有 triplet
ls vcpkg/triplets/

# 查看社区 triplet（通常包含 asan 配置）
ls vcpkg/triplets/community/ | grep asan
```

## 3. 自定义 ASan triplet

如果预定义的 triplet 不存在，可以创建自定义的：

### 创建 `vcpkg/triplets/arm64-android-asan.cmake`：
```cmake
# 基于 arm64-android 配置
set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CMAKE_SYSTEM_NAME Android)

# ASan 配置
set(VCPKG_CXX_FLAGS "-fsanitize=address -fno-omit-frame-pointer")
set(VCPKG_C_FLAGS "-fsanitize=address -fno-omit-frame-pointer")
set(VCPKG_LINKER_FLAGS "-fsanitize=address")

# Android 特定配置
set(VCPKG_ANDROID_NDK_HOME $ENV{ANDROID_NDK_HOME})
```

### 或者创建 `vcpkg/triplets/x64-linux-asan.cmake`：
```cmake
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

# ASan 配置
set(VCPKG_BUILD_TYPE release)  # ASan 通常用于调试版本
set(VCPKG_CXX_FLAGS "-fsanitize=address -fno-omit-frame-pointer -g")
set(VCPKG_C_FLAGS "-fsanitize=address -fno-omit-frame-pointer -g")
set(VCPKG_LINKER_FLAGS "-fsanitize=address")
```

## 4. 安装时直接指定编译选项

```bash
# 使用环境变量覆盖
export VCPKG_CXX_FLAGS="-fsanitize=address"
export VCPKG_C_FLAGS="-fsanitize=address" 
export VCPKG_LINKER_FLAGS="-fsanitize=address"

vcpkg install opencv:arm64-android
```

## 5. 在 vcpkg.json 中配置（如果使用清单模式）

创建 `vcpkg.json`：
```json
{
    "name": "my-project",
    "version": "1.0.0",
    "dependencies": [
        "opencv"
    ],
    "overrides": [
        {
            "name": "opencv",
            "version": "4.5.5"
        }
    ],
    "builtin-baseline": "a1c0f1c6c3c35574a1bc7c2c4c90915130c51f69"
}
```

然后使用：
```bash
vcpkg install --triplet=arm64-android-asan
```

## 6. Android 特定的 ASan 配置

对于 Android，需要更详细的配置：

### `arm64-android-asan.cmake`：
```cmake
set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CMAKE_SYSTEM_NAME Android)

# ASan 配置
set(VCPKG_CXX_FLAGS "-fsanitize=address -fno-omit-frame-pointer -g")
set(VCPKG_C_FLAGS "-fsanitize=address -fno-omit-frame-pointer -g")
set(VCPKG_LINKER_FLAGS "-fsanitize=address")

# Android NDK 配置
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE $ENV{ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake)

# 确保使用 clang（ASan 在 clang 中支持更好）
set(VCPKG_CMAKE_SYSTEM_VERSION 21)
set(VCPKG_ANDROID_NDK_HOME $ENV{ANDROID_NDK_HOME})
```

## 7. 验证 ASan 是否生效

安装后检查编译标志：
```bash
# 查看库的编译信息
strings vcpkg/installed/arm64-android-asan/lib/libopencv_core.a | grep sanitize

# 或者检查编译日志
cat vcpkg/buildtrees/opencv/build-arm64-android-asan-*.log | grep sanitize
```

## 8. 完整的 Android ASan 安装示例

```bash
# 设置环境变量
export ANDROID_NDK_HOME=/path/to/android-ndk

# 创建自定义 triplet
cat > vcpkg/triplets/arm64-android-asan.cmake << 'EOF'
set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CMAKE_SYSTEM_NAME Android)
set(VCPKG_CXX_FLAGS "-fsanitize=address -fno-omit-frame-pointer")
set(VCPKG_C_FLAGS "-fsanitize=address -fno-omit-frame-pointer")
set(VCPKG_LINKER_FLAGS "-fsanitize=address")
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE $ENV{ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake)
EOF

# 安装库
vcpkg install opencv:arm64-android-asan
```

## 注意事项

1. **性能影响**：ASan 会显著增加内存使用和降低性能
2. **Android 限制**：在 Android 上使用 ASan 需要额外的运行时配置（wrap.sh）
3. **依赖冲突**：某些库可能不完全支持 ASan
4. **调试符号**：建议同时启用 `-g` 标志以获得有用的堆栈跟踪

选择适合您项目需求的方法，通常使用自定义 triplet 是最灵活的方式。

========================================================
# 2.VCPKG_CXX_FLAGS是否可以加入-g  -O0

## Q
简要回答，
set(VCPKG_CXX_FLAGS "-fsanitize=address -fno-omit-frame-pointer -g")
set(VCPKG_C_FLAGS "-fsanitize=address -fno-omit-frame-pointer -g")
是否可以写成
set(VCPKG_CXX_FLAGS "-fsanitize=address -fno-omit-frame-pointer -g  -O0")
set(VCPKG_C_FLAGS "-fsanitize=address -fno-omit-frame-pointer -g  -O0")
？

## A-YuanbaoAI
**可以，但不推荐。**

### 简要回答：

**可以**添加 `-O0`，但通常**不建议**这样做。

### 原因：

1. **性能问题**：`-O0` 会完全禁用优化，编译极慢，生成的代码效率很低
2. **调试友好性**：虽然 `-O0` 调试更简单，但 `-O1`/`-O2` 配合 `-g` 通常足够调试 ASan 问题
3. **ASan 兼容性**：ASan 与 `-O1`/`-O2` 优化级别兼容良好

### 推荐做法：
```cmake
# 推荐：使用 -O1 或 -O2
set(VCPKG_CXX_FLAGS "-fsanitize=address -fno-omit-frame-pointer -g -O1")
set(VCPKG_C_FLAGS "-fsanitize=address -fno-omit-frame-pointer -g -O1")
```

只有在遇到特定优化相关 bug 时，才临时使用 `-O0` 进行调试。
============================================================
# 3.VCPKG_CHAINLOAD_TOOLCHAIN_FILE 与 vcpkg/scripts/buildsystems/vcpkg.cmake 有关系吗

是的，它们之间有**直接的关系**，但作用在不同的阶段。

## 关系说明

### 1. 执行顺序和层次关系

```
用户项目 CMakeLists.txt
    ↓ 使用 -DCMAKE_TOOLCHAIN_FILE=
    vcpkg/scripts/buildsystems/vcpkg.cmake  (vcpkg 主工具链)
        ↓ 内部处理
        VCPKG_CHAINLOAD_TOOLCHAIN_FILE  (链式加载的工具链)
            ↓ 加载
            Android NDK 工具链或其他自定义工具链
```

### 2. 具体关系

#### `vcpkg.cmake` - **vcpkg 的主入口**
```cmake
# 用户在 CMake 中这样使用：
cmake -DCMAKE_TOOLCHAIN_FILE=/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake ...
```
- 这是 vcpkg 的**主要入口点**
- 负责设置 vcpkg 的构建系统、包管理、依赖解析等

#### `VCPKG_CHAINLOAD_TOOLCHAIN_FILE` - **链式加载的工具链**
```cmake
# 在 triplet 文件中设置：
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "/path/to/android-toolchain.cmake")
```
- 这是 vcpkg **内部使用**的变量
- 用于加载**交叉编译工具链**（如 Android NDK）

## 实际工作流程

### 配置阶段：
```bash
# 用户命令
cmake .. -DCMAKE_TOOLCHAIN_FILE=/home/abner/programs/vcpkg/scripts/buildsystems/vcpkg.cmake
```

### 内部处理流程：
```cmake
# 在 vcpkg.cmake 内部：
1. 读取 triplet 配置（如 arm64-android.cmake）
2. 检查 VCPKG_CHAINLOAD_TOOLCHAIN_FILE 变量
3. 如果设置了，加载指定的工具链文件
4. 继续 vcpkg 的配置过程
```

## 代码示例

### 项目中的 CMake 配置：
```cmake
# CMake 命令
cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=/home/abner/programs/vcpkg/scripts/buildsystems/vcpkg.cmake \
    -DVCPKG_TARGET_TRIPLET=arm64-android
```

### Triplet 文件配置：
```cmake
# arm64-android.cmake
set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CMAKE_SYSTEM_NAME Android)

# 告诉 vcpkg.cmake 要加载 Android 工具链
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "$ENV{ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake")
```

## 类比理解

可以这样类比：

| 组件 | 类比 | 作用 |
|------|------|------|
| `vcpkg.cmake` | **项目经理** | 总体协调，管理依赖和构建 |
| `VCPKG_CHAINLOAD_TOOLCHAIN_FILE` | **专业工具** | 具体的编译工具（Android 编译器） |
| Android NDK 工具链 | **工人技能** | 实际的编译能力 |

## 重要区别

### `vcpkg.cmake`：
- **用户层面**的配置
- CMake 的 `-DCMAKE_TOOLCHAIN_FILE=` 参数
- vcpkg 的**入口点**

### `VCPKG_CHAINLOAD_TOOLCHAIN_FILE`：
- **vcpkg 内部**的配置  
- 在 triplet 文件中设置
- 用于**链式加载**其他工具链

## 完整配置示例

### 1. 项目配置
```bash
cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=/home/abner/programs/vcpkg/scripts/buildsystems/vcpkg.cmake \
    -DVCPKG_TARGET_TRIPLET=arm64-android
```

### 2. Triplet 配置
```cmake
# arm64-android.cmake
set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CMAKE_SYSTEM_NAME Android)
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "$ENV{ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake")
```

### 3. 执行结果
```
vcpkg.cmake 加载 → 读取 triplet → 链式加载 Android 工具链 → 编译 Android 库
```

## 总结

- `vcpkg.cmake` 是 **vcpkg 的入口工具链**
- `VCPKG_CHAINLOAD_TOOLCHAIN_FILE` 是 **vcpkg 内部链式加载其他工具链的机制**
- 它们配合工作，使得 vcpkg 既能管理依赖，又能支持交叉编译

**关系**：`vcpkg.cmake` 通过 `VCPKG_CHAINLOAD_TOOLCHAIN_FILE` 变量来加载适合目标平台的编译工具链。

=============================================================
# 4. error: building uriparser:arm64-android-asan failed with: BUILD_FAILED

## #1.error: building uriparser:arm64-android-asan failed with: BUILD_FAILED
vcpkg编译出错
```sh
Additional packages (*) will be modified to complete this operation.
Detecting compiler hash for triplet arm64-android-asan...
Compiler found: /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++
Detecting compiler hash for triplet x64-linux...
Compiler found: /usr/bin/c++
Restored 0 package(s) from /home/abner/.cache/vcpkg/archives in 10.1 us. Use --debug to see more details.
Installing 1/7 uriparser:arm64-android-asan@0.9.9...
Building uriparser:arm64-android-asan@0.9.9...
-- Using cached uriparser-uriparser-uriparser-0.9.9.tar.gz
-- Cleaning sources at /home/abner/programs/vcpkg/buildtrees/uriparser/src/rser-0.9.9-23a8e6b358.clean. Use --editable to skip cleaning for the packages you specify.
-- Extracting source /home/abner/programs/vcpkg/downloads/uriparser-uriparser-uriparser-0.9.9.tar.gz
-- Using source at /home/abner/programs/vcpkg/buildtrees/uriparser/src/rser-0.9.9-23a8e6b358.clean
-- Configuring arm64-android-asan
-- Building arm64-android-asan-dbg
CMake Error at scripts/cmake/vcpkg_execute_build_process.cmake:134 (message):
    Command failed: /usr/share/cmake-3.31.8/bin/cmake --build . --config Debug --target install -- -v -j21
    Working Directory: /home/abner/programs/vcpkg/buildtrees/uriparser/arm64-android-asan-dbg
    See logs for more information:
      /home/abner/programs/vcpkg/buildtrees/uriparser/install-arm64-android-asan-dbg-out.log

Call Stack (most recent call first):
  installed/x64-linux/share/vcpkg-cmake/vcpkg_cmake_build.cmake:74 (vcpkg_execute_build_process)
  installed/x64-linux/share/vcpkg-cmake/vcpkg_cmake_install.cmake:16 (vcpkg_cmake_build)
  ports/uriparser/portfile.cmake:31 (vcpkg_cmake_install)
  scripts/ports.cmake:206 (include)


error: building uriparser:arm64-android-asan failed with: BUILD_FAILED
See https://learn.microsoft.com/vcpkg/troubleshoot/build-failures?WT.mc_id=vcpkg_inproduct_cli for more information.
Elapsed time to handle uriparser:arm64-android-asan: 946 ms
Please ensure you're using the latest port files with `git pull` and `vcpkg update`.
Then check for known issues at:
  https://github.com/microsoft/vcpkg/issues?q=is%3Aissue+is%3Aopen+in%3Atitle+uriparser
You can submit a new issue at:
  https://github.com/microsoft/vcpkg/issues/new?title=%5Buriparser%5D%20build%20error%20on%20arm64-android-asan&body=Copy%20issue%20body%20from%20%2Fhome%2Fabner%2Fprograms%2Fvcpkg%2Finstalled%2Fvcpkg%2Fissue_body.md
```

而 /home/abner/programs/vcpkg/buildtrees/uriparser/install-arm64-android-asan-dbg-out.log:
```sh
[9/31] /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/bin/clang --target=aarch64-none-linux-android28 -DURI_LIBRARY_BUILD -DURI_STATIC_BUILD -DURI_VISIBILITY -I/home/abner/programs/vcpkg/buildtrees/uriparser/src/rser-0.9.9-23a8e6b358.clean/include -I/home/abner/programs/vcpkg/buildtrees/uriparser/arm64-android-asan-dbg -fsanitize=address -fno-omit-frame-pointer -g -O1 -fPIC -fsanitize=address -fno-omit-frame-pointer -g -O1 -fPIC  -fvisibility=hidden -g  -fno-limit-debug-info -std=c99 -MD -MT CMakeFiles/uriparser.dir/src/UriMemory.c.o -MF CMakeFiles/uriparser.dir/src/UriMemory.c.o.d -o CMakeFiles/uriparser.dir/src/UriMemory.c.o -c /home/abner/programs/vcpkg/buildtrees/uriparser/src/rser-0.9.9-23a8e6b358.clean/src/UriMemory.c
FAILED: [code=1] CMakeFiles/uriparser.dir/src/UriMemory.c.o 
/home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/bin/clang --target=aarch64-none-linux-android28 -DURI_LIBRARY_BUILD -DURI_STATIC_BUILD -DURI_VISIBILITY -I/home/abner/programs/vcpkg/buildtrees/uriparser/src/rser-0.9.9-23a8e6b358.clean/include -I/home/abner/programs/vcpkg/buildtrees/uriparser/arm64-android-asan-dbg -fsanitize=address -fno-omit-frame-pointer -g -O1 -fPIC -fsanitize=address -fno-omit-frame-pointer -g -O1 -fPIC  -fvisibility=hidden -g  -fno-limit-debug-info -std=c99 -MD -MT CMakeFiles/uriparser.dir/src/UriMemory.c.o -MF CMakeFiles/uriparser.dir/src/UriMemory.c.o.d -o CMakeFiles/uriparser.dir/src/UriMemory.c.o -c /home/abner/programs/vcpkg/buildtrees/uriparser/src/rser-0.9.9-23a8e6b358.clean/src/UriMemory.c
/home/abner/programs/vcpkg/buildtrees/uriparser/src/rser-0.9.9-23a8e6b358.clean/src/UriMemory.c:102:9: error: call to undeclared function 'reallocarray'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
  102 |         return reallocarray(ptr, nmemb, size);
      |                ^
/home/abner/programs/vcpkg/buildtrees/uriparser/src/rser-0.9.9-23a8e6b358.clean/src/UriMemory.c:102:9: error: incompatible integer to pointer conversion returning 'int' from a function with result type 'void *' [-Wint-conversion]
  102 |         return reallocarray(ptr, nmemb, size);
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2 errors generated.
```

## #2.yuanbaoAI

这个错误是因为 `reallocarray` 函数在 Android NDK 的 C 标准库中不可用。`reallocarray` 是一个非标准的 BSD 扩展函数，在 Android 的 Bionic libc 中没有提供。

### 原因：check_function_exists 没起作用
/home/abner/programs/vcpkg/buildtrees/uriparser/src/rser-0.9.9-23a8e6b358.clean/CMakeLists.txt 里
```
check_function_exists(reallocarray HAVE_REALLOCARRAY)  # no luck with CheckSymbolExists
```
check_function_exists 没起作用,

### 解决方案：禁用 reallocarray 功能
 修改 triplet 文件，添加定义来禁用 reallocarray：

```cmake
# 在 arm64-android-asan.cmake 中添加
# set(VCPKG_C_FLAGS "${VCPKG_C_FLAGS} -DHAVE_REALLOCARRAY=OFF -DURI_NO_REALLOCARRAY=ON")
# set(VCPKG_CXX_FLAGS "${VCPKG_CXX_FLAGS}  -DHAVE_REALLOCARRAY=OFF -DURI_NO_REALLOCARRAY=ON")

# 在 arm64-android-asan.cmake 中添加
set(VCPKG_CMAKE_CONFIGURE_OPTIONS ${VCPKG_CMAKE_CONFIGURE_OPTIONS}
    -DHAVE_REALLOCARRAY=OFF
    -DURI_NO_REALLOCARRAY=ON
)
```
  

### 验证修复

修复后，编译命令应该不再出现 reallocarray 错误：

```bash
# 重新安装
./vcpkg install uriparser:arm64-android-asan

# 检查是否成功
nm ./installed/arm64-android-asan/lib/liburiparser.a | grep -i uri
```
 
===================================================================
# 5.vcpkg根目录下的installed 和packages 的区别

`installed` 和 `packages` 目录在 vcpkg 中有不同的用途和生命周期：

## 核心区别

| 目录 | 用途 | 内容 | 生命周期 |
|------|------|------|----------|
| **`installed/`** | **安装目录** | 编译后的库文件（头文件、库文件、CMake配置） | 长期存在，供项目使用 |
| **`packages/`** | **打包缓存目录** | 临时打包文件，用于快速重新安装 | 临时性，可清理 |

## 详细说明

### 1. `installed/` 目录（安装目录）
```
installed/
├── arm64-android-asan/
│   ├── include/          # 头文件
│   ├── lib/              # 静态库/动态库
│   ├── bin/              # 可执行文件（如果有）
│   └── share/            # CMake配置等元数据
├── x64-linux/
└── ...
```

**特点**：
- ✅ **供项目使用**：CMake 项目通过 `find_package()` 在这里查找库
- ✅ **长期存在**：除非手动删除或执行 `vcpkg remove`
- ✅ **按 triplet 组织**：不同平台的库分开存放

### 2. `packages/` 目录（打包缓存）
```
packages/
├── zlib_arm64-android-asan/
│   └── ...（与 installed 类似的结构）
├── openssl_arm64-android-asan/
└── ...
```

**特点**：
- ⚡ **构建缓存**：加速重新安装
- 🗑️ **可清理**：`vcpkg remove --purge` 会删除
- 🔄 **临时性**：vcpkg 内部使用

## 实际工作流程

### 安装过程：
```
源码 → 编译 → packages/（打包） → installed/（安装）
```

### 示例操作：
```bash
# 安装库
vcpkg install zlib:arm64-android-asan

# 查看安装结果
ls installed/arm64-android-asan/lib/libz.a      # ✅ 存在
ls packages/zlib_arm64-android-asan/lib/libz.a # ✅ 存在（缓存）

# 删除库（但保留缓存）
vcpkg remove zlib:arm64-android-asan
ls installed/arm64-android-asan/lib/libz.a      # ❌ 不存在
ls packages/zlib_arm64-android-asan/lib/libz.a # ✅ 存在（缓存）

# 彻底删除（包括缓存）
vcpkg remove zlib:arm64-android-asan --purge
ls packages/zlib_arm64-android-asan/           # ❌ 不存在
```

## 使用场景

### 项目开发时：
```cmake
# CMakeLists.txt 引用 installed 目录
find_package(ZLIB REQUIRED)
target_link_libraries(myapp ZLIB::ZLIB)
```

### 清理空间：
```bash
# 只清理缓存，保留已安装的库
vcpkg remove --purge zlib:arm64-android-asan

# 或者手动清理 packages 目录
rm -rf packages/
```

## 重要注意事项

1. **不要手动修改 `installed/`**：vcpkg 会管理这个目录
2. **`packages/` 可以安全删除**：vcpkg 会重新构建
3. **跨 triplet 隔离**：不同平台的库完全独立
4. **磁盘空间**：`packages/` 可能占用大量空间，定期清理
 
项目应该始终引用 `installed/` 目录，而 `packages/` 是 vcpkg 内部优化用的。



