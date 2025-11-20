
# 1.java 和 android studio
编译要求java最低不小于11
代码原先默认堆栈为2048M可能无法满足
/Users/xxx/vcpkg/installed/arm64-android/debug/lib/libgeotiff.a cmake文件中为绝对路径，但是上面已经引入GDAL库这行删除即可

打开android studio后提示建议升级gradle可能是默认java版本与gradle不匹配
打开Settings →"Build, Execution, Deployment" → Gradle → "Gradle JDK 设置本地Java路径"，gradle.properties中设置本地Java路径可以解决

# 2.解决win环境下.a文件链接到so文件可能提示-fPIC问题
vcpkg目录下triplets下当前编译平台如 arm64-android.cmake 添加
```cmake
set(VCPKG_CMAKE_C_FLAGS "-fPIC")
set(VCPKG_CMAKE_CXX_FLAGS "-fPIC")

# 强制注入 -fPIC
set(VCPKG_CMAKE_CONFIGURE_OPTIONS ${VCPKG_CMAKE_CONFIGURE_OPTIONS}
    -DCMAKE_C_FLAGS=-fPIC
    -DCMAKE_CXX_FLAGS=-fPIC
)
```
上述为ai建议，但是我电脑没生效。

**我的解决办法**是 打开vcpkg目录下port/gdal/protfile.cmake文件找到vcpkg_cmake_configure函数部分添加-DCMAKE_POSITION_INDEPENDENT_CODE=ON

# D:\vcpkg\triplets\arm64-android.cmake

# 3.port/gdal/vcpkg.json
vcpkg安装默认调用 port/gdal/vcpkg.json，其中 **default-features** 内参数为默认安装feature，如果不更改则会安装非勾选feature，**导致安装库增大**。

**解决办法**是 在vcpkg目录下建一个custom-ports，将gdal的目录拷贝过来后，修改vcpkg.json中的default-features设置为空，
           然后执行以下命令就不会额外安装不必要feature。

```sh
# arm64-android  
vcpkg install --triplet=arm64-android zlib minizip uriparser expat lunasvg
vcpkg install --triplet=arm64-android  openssl   sqlite3 curl    freetype   proj   geos    libjpeg-turbo    libpng   tiff  libxml2   expat   json-c   liblzma openjpeg   libzip   libwebp     libgeotiff zlib  protobuf


vcpkg install gdal[curl,geos,libkml,libxml2,openssl,png,qhull,sqlite3,webp,lzma,iconv,jpeg]:arm64-android   --triplet=arm64-android   --overlay-ports=custom-ports   --recurse


# x64-android
vcpkg install --triplet=x64-android zlib minizip uriparser expat lunasvg
vcpkg install --triplet=x64-android  openssl   sqlite3 curl    freetype   proj   geos    libjpeg-turbo    libpng   tiff  libxml2   expat   json-c   liblzma openjpeg   libzip   libwebp     libgeotiff zlib  protobuf


vcpkg install gdal[curl,geos,libkml,libxml2,openssl,png,qhull,sqlite3,webp,lzma,iconv,jpeg]:x64-android   --triplet=x64-android   --overlay-ports=custom-ports   --recurse
```