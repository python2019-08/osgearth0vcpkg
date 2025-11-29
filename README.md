# osgearth0vcpkg
osgearth and its dependencies is built with vcpkg.


progress of code standardization : src/osg/Material.cpp 
                                   include/osg/Callback
                                   finished..
## how 2 build

(1) use vcpkg to build+install 3rd for android ndk

```sh
scripts/install_3rd_arm64-android.sh
```
(2) build osg+osgEarth for android ndk

```sh
scripts/mk4andro.sh   >ba.txt 2>&1
```

(3) use AndroidStudio to build+run platform/AndroEarth0Vcpkg

