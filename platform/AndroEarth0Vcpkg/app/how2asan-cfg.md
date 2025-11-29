# 1.how to disable  asan

根据 https://developer.android.google.cn/ndk/guides/asan?hl=cs#cmake 进行配置。

(1) platform/AndroEarth0Vcpkg/app/build.gradle.kts
    "-DENABLE_123ASAN=0", // enable asan(step 1)
(2) platform/AndroEarth0Vcpkg/app/src/main/jniLibs    ->   platform/AndroEarth0Vcpkg/app/src/main/jniLibs--bk

(3) platform/AndroEarth0Vcpkg/app/src/main/resources  ->   platform/AndroEarth0Vcpkg/app/src/main/resources--bk
