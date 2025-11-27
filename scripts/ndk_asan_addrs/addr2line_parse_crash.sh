#!/bin/bash
# parse_asan.sh
ANDROID_NDK_HOME=/home/abner/Android/Sdk/ndk/27.1.12297006
ADDR2LINE="${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-addr2line"
if [ ! -f "$ADDR2LINE" ]; then
    echo "错误: 找不到 addr2line 工具: $ADDR2LINE"
    exit 1
fi

# 尝试自动查找 .so 文件
# SO_FILE=$(find . -name "libandroioearth01.so" -type f | head -1)
AndroidAppPath=/mnt/disk2/abner/zdev/nv/osgearth0vcpkg/platform/AndroEarth0Vcpkg/
# param (1/2)
SO_FILE=${AndroidAppPath}/app/build/intermediates/cxx/Debug/5l1w211y/obj/arm64-v8a/libandroioearth01.so
if [ -z "$SO_FILE" ]; then
    echo "错误: 找不到 libandroioearth01.so 文件"
    echo "请在包含 .so 文件的目录中运行此脚本"
    exit 1
fi

# *** scripts/addr_from_ndk_asan_log.py 从错误日志中提取所有地址
# param (2/2)
ADDRESSES=(
"0x4705790"
"0x470576c"
"0x57b8c80"
"0x57b89f8"
"0x57b7cf8"
"0x57b0afc"
"0x57b0194"
"0x57b46ec"
"0x57b5860"
"0x569d3bc"
"0x53ad9f0"
"0x5381e74"
"0x53819a8"
"0x53b4638"
"0x53b2f8c"
"0x53c2758"
"0x53d2684"
"0x4a3a058"
"0x4a3966c"
)

echo "=== AddressSanitizer 调用栈解析 ==="
echo "库文件: $SO_FILE"
echo "===================================="

for addr in "${ADDRESSES[@]}"; do
    echo -n "地址: $addr || " && $ADDR2LINE -e "$SO_FILE" -f -C -p "$addr"
    # printf "地址: %s " "$addr"; $ADDR2LINE -e "$SO_FILE" -f -C -p "$addr"    
    # echo -e "地址: $addr\t$($ADDR2LINE -e "$SO_FILE" -f -C -p "$addr")"
done