# 1. CMAKE_CXX_FLAGS_XXX

你已经配置了 `Debug` 和 `Release` 模式的编译选项，接下来补充 **`RelWithDebInfo`（带调试信息的发布版）** 和 **`MinsizeRel`（最小体积发布版）** 的标准配置，同时说明各模式的核心差异、适用场景及完整用法，确保配置兼容 GCC/Clang/MSVC 跨编译器：


### 一、完整配置代码（直接复用）
```cmake
# 1. Debug 模式：调试优先（保留符号、禁用优化、定义 DEBUG 宏）
# 追加 -g（调试符号）、-O0（无优化）、-DDEBUG（自定义调试宏），保留默认值
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -O0 -DDEBUG")

# 2. Release 模式：性能优先（平衡优化、移除调试、禁用 assert）
# 追加 -O2（稳定优化）、-DNDEBUG（禁用 assert），保留默认值
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2 -DNDEBUG")

# 3. RelWithDebInfo 模式：性能+调试（优化+保留调试符号，用于性能调优）
# 核心：-O2（同 Release 优化） + -g（调试符号） + -DNDEBUG（禁用 assert）
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -O2 -g -DNDEBUG")

# 4. MinsizeRel 模式：体积优先（最小可执行文件，牺牲部分性能）
# 核心：-Os（优化体积） + -DNDEBUG（禁用 assert），比 -O2 体积更小
set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} -Os -DNDEBUG")
```

#### 跨编译器兼容补充（可选，适配 MSVC）
如果项目需要支持 Windows MSVC 编译器，需通过条件判断区分选项（GCC/Clang 用 `-` 前缀，MSVC 用 `/` 前缀）：
```cmake
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
  # GCC/Clang 配置（同上）
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -O0 -DDEBUG")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2 -DNDEBUG")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -O2 -g -DNDEBUG")
  set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} -Os -DNDEBUG")
elseif(MSVC)
  # MSVC 配置（对应功能的 MSVC 选项）
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /Zi /Od /DDEBUG")  # /Zi：调试符号，/Od：无优化
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /O2 /DNDEBUG") # /O2：性能优化
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /O2 /Zi /DNDEBUG") # 优化+调试符号
  set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /Os /DNDEBUG") # /Os：体积优化
endif()
```


### 二、四大模式核心差异对比（关键参数+适用场景）
| 模式               | 核心编译选项（GCC/Clang） | 核心编译选项（MSVC） | 核心目标                  | 适用场景                                  |
|--------------------|---------------------------|----------------------|---------------------------|-------------------------------------------|
| `Debug`            | `-g -O0 -DDEBUG`          | `/Zi /Od /DDEBUG`    | 调试友好（保留所有信息）  | 开发阶段、断点调试、定位 Bug              |
| `Release`          | `-O2 -DNDEBUG`            | `/O2 /DNDEBUG`       | 性能+稳定性平衡           | 最终交付、生产环境（无调试需求）          |
| `RelWithDebInfo`   | `-O2 -g -DNDEBUG`         | `/O2 /Zi /DNDEBUG`   | 性能+可调试（优化不丢符号）| 性能调优（需定位 Release 模式下的性能问题）|
| `MinsizeRel`       | `-Os -DNDEBUG`            | `/Os /DNDEBUG`       | 最小体积（优先减小文件）  | 嵌入式设备、存储受限场景（如固件、小程序）|

#### 关键参数说明
- `-g` / `/Zi`：生成调试符号（允许 GDB/VS 调试，不影响运行性能，仅增大文件体积）；
- `-O0` / `/Od`：无优化（编译快，保留代码原始逻辑，适合调试；`O0` 是 Debug 模式默认值）；
- `-O2`：平衡优化（速度/体积/稳定性最优，Release 模式默认核心选项）；
- `-Os`：体积优化（在 `-O2` 基础上进一步减小文件大小，牺牲少量非关键性能）；
- `-DDEBUG`：自定义宏（用于代码中区分调试模式，如 `#if defined(DEBUG) 打印日志 #endif`）；
- `-DNDEBUG`：禁用 `assert()` 断言（所有发布类模式必带，减小体积+提升性能）。


### 三、使用方式（如何激活对应模式）
#### 1. 命令行指定（GCC/Clang/MinGW）
```bash
# 示例1：编译 Debug 模式
cmake -DCMAKE_BUILD_TYPE=Debug ..
make -j$(nproc)  # 或 ninja

# 示例2：编译 RelWithDebInfo 模式（性能调优）
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
make -j$(nproc)

# 示例3：编译 MinsizeRel 模式（嵌入式）
cmake -DCMAKE_BUILD_TYPE=MinsizeRel ..
make -j$(nproc)
```

#### 2. Visual Studio 生成解决方案（MSVC）
```bash
# 生成支持所有模式的 VS 解决方案（Debug/Release/RelWithDebInfo/MinsizeRel）
cmake -G "Visual Studio 17 2022" -A x64 ..
```
打开生成的 `.sln` 文件后，在 VS 中直接选择「解决方案配置」切换模式（无需再改 CMake）。


### 四、代码中如何区分各模式？
通过宏定义在代码中适配不同模式（如调试日志、断言开关）：
```cpp
#include <cassert>
#include <iostream>

int main() {
  // 1. 调试模式打印日志（依赖 -DDEBUG 宏）
#if defined(DEBUG)
  std::cout << "Debug mode: 开启详细日志" << std::endl;
#endif

  // 2. Release/RelWithDebInfo/MinsizeRel 禁用 assert（依赖 -DNDEBUG 宏）
  int a = 10;
  assert(a == 20);  // Debug 模式触发断言，其他模式无反应

  // 3. 可选：通过 CMake 内置宏区分模式（无需手动定义 -DXXX）
#if defined(NDEBUG)
  std::cout << "当前是发布类模式（Release/RelWithDebInfo/MinsizeRel）" << std::endl;
#else
  std::cout << "当前是 Debug 模式" << std::endl;
#endif

  return 0;
}
```


### 五、注意事项
1. **避免重复配置**：CMake 默认已为各模式设置基础选项（如 Debug 默认 `-g -O0`，Release 默认 `-O3/-O2 -DNDEBUG`），我们的配置用 `${CMAKE_CXX_FLAGS_XXX}` 追加，而非覆盖，避免丢失默认关键参数；
2. **`RelWithDebInfo` 慎用 `-O3`**：若将其优化级别改为 `-O3`（极致性能），可能导致调试符号与代码逻辑错位（如循环展开、变量优化消失），推荐保持 `-O2`；
3. **`MinsizeRel` 不适合性能敏感场景**：`-Os` 会牺牲循环优化、指令集优化等，若项目对速度有要求，优先用 `Release`；
4. **自定义宏的作用域**：如果仅需某个目标（而非全局）定义 `DEBUG` 宏，推荐用 `target_compile_definitions()`（目标级配置，更灵活）：
   ```cmake
   add_executable(my_app main.cpp)
   # 仅 my_app 的 Debug 模式定义 DEBUG 宏（替代全局 CMAKE_CXX_FLAGS_DEBUG）
   target_compile_definitions(my_app PRIVATE $<$<CONFIG:Debug>:DEBUG>)
   ```


### 总结
以上配置覆盖了 CMake 四大核心构建模式，重点：
- `Debug`：开发调试，保留所有调试信息；
- `Release`：生产交付，平衡性能与稳定性；
- `RelWithDebInfo`：性能调优，优化不丢调试符号；
- `MinsizeRel`：体积优先，适配存储受限场景。

配置兼容跨编译器，可直接复制到 `CMakeLists.txt` 中使用，根据项目需求（开发/交付/调优/嵌入式）选择对应的构建模式即可。