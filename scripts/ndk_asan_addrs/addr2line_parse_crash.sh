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
SO_FILE=${AndroidAppPath}/app/build/intermediates/cxx/Debug/5l1w211y/obj/arm64-v8a/libandroioearth01.so
if [ -z "$SO_FILE" ]; then
    echo "错误: 找不到 libandroioearth01.so 文件"
    echo "请在包含 .so 文件的目录中运行此脚本"
    exit 1
fi

# *** scripts/addr_from_ndk_asan_log.py 从错误日志中提取所有地址
ADDRESSES=(
"0x46ea088"
"0x46ea038"
"0x46e9fdc"
"0x579c6d0"
"0x579c150"
"0x579cccc"
"0x579ca30"
"0x57967b4"
"0x5796808"
"0x58cc430"
"0x58cc7a8"
"0x56373a4"
"0x56380a4"
"0x5385db4"
"0x58cc430"
"0x58cc7a8"
"0x4966668"
"0x5748448"
"0x574873c"
"0x5a9caf0"
"0x57f9b44"
"0x535cc88"
"0x58cc430"
"0x58cc7a8"
"0x538cc38"
"0x538ce80"
"0x58cc430"
"0x58cc7a8"
"0x47b7efc"
)

echo "=== AddressSanitizer 调用栈解析 ==="
echo "库文件: $SO_FILE"
echo "===================================="

for addr in "${ADDRESSES[@]}"; do
    echo -e "\n地址: $addr"
    $ADDR2LINE -e "$SO_FILE" -f -C -p "$addr"
done