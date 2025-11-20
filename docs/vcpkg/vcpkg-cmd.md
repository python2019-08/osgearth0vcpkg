# 1.ubuntu 下 vcpkg如何安装和使用
doubaoAI.
在 Ubuntu 系统中，vcpkg 是一个跨平台的 C/C++ 包管理工具，可方便地安装、管理第三方库（如 Boost、OpenCV、Qt 等）。以下是详细的安装和使用步骤：


### **一、安装 vcpkg**
#### 1. 安装依赖
vcpkg 需要 Git、CMake、编译器等工具，先通过 apt 安装：
```bash
sudo apt update
sudo apt install -y git cmake build-essential pkg-config
```
- `build-essential`：包含 GCC 编译器、make 等基础构建工具。

#### 2. 克隆 vcpkg 仓库
选择一个安装目录（如 `~/tools`），克隆官方仓库：
```bash
# 创建目录（可选）
mkdir -p ~/tools && cd ~/tools

# 克隆仓库
git clone https://github.com/microsoft/vcpkg.git
```

#### 3. 编译 vcpkg 可执行文件
进入 vcpkg 目录，运行 bootstrap 脚本生成可执行文件：
```bash
cd vcpkg
./bootstrap-vcpkg.sh
```
- 脚本会自动编译 vcpkg，生成 `vcpkg` 可执行文件（位于当前目录）。

#### 4. （可选）添加到系统 PATH
为了在任意目录使用 `vcpkg` 命令，可将其路径添加到 `~/.bashrc` 或 `~/.zshrc`：
```bash
# 编辑环境变量配置文件
echo 'export PATH="$HOME/tools/vcpkg:$PATH"' >> ~/.bashrc

# 生效配置
source ~/.bashrc
```
- 验证是否生效：`vcpkg --version`，若输出版本信息则成功。


### **二、基本使用方法**
#### 1. 搜索库
使用 `vcpkg search` 查找需要的库（支持模糊搜索）：
```bash
# 搜索 OpenCV
vcpkg search opencv

# 搜索 Boost 相关库
vcpkg search boost
```

#### 2. 安装库
使用 `vcpkg install <库名>` 安装，默认安装 **x64-linux** 版本（Ubuntu 下常用）。  
示例：
```bash
# 安装 OpenCV（默认 x64-linux）
vcpkg install opencv

# 安装特定版本（如 Boost 1.78）
vcpkg install boost:1.78.0

# 安装多个库
vcpkg install eigen3 glog gtest
```
- 安装路径：`vcpkg/installed/x64-linux/`（包含头文件、库文件等）。

#### 3. 查看已安装的库
```bash
vcpkg list
```

#### 4. 卸载库
```bash
vcpkg remove opencv
```

#### 5. 更新 vcpkg 和库
```bash
# 更新 vcpkg 本身（拉取最新代码并重新编译）
git pull
./bootstrap-vcpkg.sh

# 更新已安装的库（需先更新 vcpkg）
vcpkg upgrade
```


### **三、在项目中使用 vcpkg**
vcpkg 支持通过 CMake 集成，无需手动指定库路径。

#### 1. 生成 CMake 工具链文件
vcpkg 提供了工具链文件，用于告诉 CMake 如何找到安装的库。工具链文件路径为：  
`vcpkg/scripts/buildsystems/vcpkg.cmake`

#### 2. CMake 项目集成示例
假设项目结构如下：
```
my_project/
├── CMakeLists.txt
└── main.cpp
```

**CMakeLists.txt** 中添加：
```cmake
cmake_minimum_required(VERSION 3.10)
project(my_project)

# 设置 C++ 标准
set(CMAKE_CXX_STANDARD 17)

# 查找并链接 vcpkg 安装的库（以 OpenCV 为例）
find_package(OpenCV REQUIRED)

# 添加可执行文件
add_executable(my_app main.cpp)

# 链接库
target_link_libraries(my_app PRIVATE ${OpenCV_LIBS})
```

**编译项目**时，通过 `-DCMAKE_TOOLCHAIN_FILE` 指定 vcpkg 工具链：
```bash
# 进入项目目录
cd my_project

# 创建构建目录
mkdir build && cd build

# 生成 Makefile（指定 vcpkg 工具链）
cmake .. -DCMAKE_TOOLCHAIN_FILE=~/tools/vcpkg/scripts/buildsystems/vcpkg.cmake

# 编译
make -j4
```
- 替换 `~/tools/vcpkg` 为你的 vcpkg 实际安装路径。


### **四、高级用法**
#### 1. 安装特定架构的库
默认是 `x64-linux`，如需 32 位（`x86-linux`）：
```bash
vcpkg install opencv:x86-linux
```

#### 2. 导出库供其他项目使用
生成一个包含所有依赖的清单，方便共享：
```bash
vcpkg export opencv eigen3 --zip  # 导出为 zip 包
```

#### 3. 集成到全局 CMake（可选）
运行以下命令后，无需每次指定工具链文件（全局生效）：
```bash
vcpkg integrate install
```
- 取消全局集成：`vcpkg integrate remove`


### **五、常见问题**
1. **安装速度慢**：可配置国内镜像（如 GitHub 镜像、vcpkg 资源镜像）。
2. **编译失败**：检查依赖是否齐全（如 `libssl-dev`、`libgl1-mesa-dev` 等系统库可能需要手动安装）。
3. **库版本冲突**：使用 `vcpkg remove` 卸载旧版本，再安装指定版本。

通过以上步骤，即可在 Ubuntu 中使用 vcpkg 高效管理 C/C++ 依赖库。
================================================================
# 2.如何把vcpkg安装的库 删除

要删除 vcpkg 安装的库，有几种方法：

## 1. 删除特定库（推荐）

```bash
# 删除指定库
vcpkg remove zlib:arm64-android

# 同时删除缓存文件
vcpkg remove --purge zlib:arm64-android

# 删除多个库
vcpkg remove zlib minizip uriparser:arm64-android
```

## 2. 查看已安装的库

```bash
# 查看所有已安装的库
vcpkg list

# 查看特定架构的库
vcpkg list :arm64-android

# 查看特定库的安装信息
vcpkg list zlib
```

## 3. 清理所有已安装的库

```bash
# 删除所有已安装的库（保留vcpkg本身）
rm -rf vcpkg/installed/

# 或者更彻底的方式
rm -rf vcpkg/installed/ vcpkg/packages/
```

## 4. 完全重新安装 vcpkg

```bash
# 备份vcpkg配置（如果需要）
cp vcpkg/vcpkg.json ./ 2>/dev/null || true

# 删除整个vcpkg目录
rm -rf vcpkg/

# 重新克隆和安装
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh
```

## 5. 删除特定 triplet 的所有库

```bash
# 删除arm64-android的所有库
rm -rf vcpkg/installed/arm64-android/
rm -rf vcpkg/packages/*_arm64-android/
```

## 6. 使用集成清理

如果库已集成到 CMake 项目中：

```bash
# 清理CMake缓存
rm -rf build/ CMakeCache.txt CMakeFiles/

# 重新配置时不使用vcpkg
cmake .. -DCMAKE_TOOLCHAIN_FILE=  # 清空工具链文件
```

## 推荐使用顺序：

1. **首选**：`vcpkg remove --purge <库名>:<triplet>`
2. **批量删除**：直接删除 `vcpkg/installed/<triplet>/` 目录
3. **彻底清理**：删除整个 vcpkg 重新安装

## 注意事项：

- `vcpkg remove` 会保留下载的源码缓存
- `--purge` 选项会同时删除缓存文件
- 直接删除文件可能更快，但 `vcpkg remove` 更安全
- 删除后可能需要重新运行 `vcpkg integrate install`

对于您的具体情况，建议使用：
```bash
vcpkg remove --purge zlib minizip uriparser expat lunasvg:arm64-android
```
 