# 1. git clone https://github.com/microsoft/vcpkg.git

```sh
(base) abner@abner-XPS:~/programs$ git clone https://github.com/microsoft/vcpkg.git
正克隆到 'vcpkg'...
remote: Enumerating objects: 293281, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (5/5), done.
remote: Total 293281 (delta 0), reused 0 (delta 0), pack-reused 293276 (from 1)
接收对象中: 100% (293281/293281), 91.66 MiB | 55.00 KiB/s, 完成.
处理 delta 中: 100% (196579/196579), 完成.


(base) abner@abner-XPS:~/programs$ cd vcpkg/

(base) abner@abner-XPS:~/programs/vcpkg$ ls
bootstrap-vcpkg.bat  CodeQL.yml       CONTRIBUTING_pt.md  docs         NOTICE_pt.txt  ports      scripts      shell.nix  triplets
bootstrap-vcpkg.sh   CONTRIBUTING.md  CONTRIBUTING_zh.md  LICENSE.txt  NOTICE.txt     README.md  SECURITY.md  toolsrc    versions

(base) abner@abner-XPS:~/programs/vcpkg$ ls -l
总计 144
-rw-rw-r--    1 abner abner   102 11月 15 13:52 bootstrap-vcpkg.bat
-rwxrwxr-x    1 abner abner   109 11月 15 13:52 bootstrap-vcpkg.sh
-rw-rw-r--    1 abner abner   105 11月 15 13:52 CodeQL.yml
-rw-rw-r--    1 abner abner  2432 11月 15 13:52 CONTRIBUTING.md
-rw-rw-r--    1 abner abner  2785 11月 15 13:52 CONTRIBUTING_pt.md
-rw-rw-r--    1 abner abner  2186 11月 15 13:52 CONTRIBUTING_zh.md
drwxrwxr-x    4 abner abner  4096 11月 15 13:52 docs
-rw-rw-r--    1 abner abner  1073 11月 15 13:52 LICENSE.txt
-rw-rw-r--    1 abner abner  2538 11月 15 13:52 NOTICE_pt.txt
-rw-rw-r--    1 abner abner  2334 11月 15 13:52 NOTICE.txt
drwxrwxr-x 2713 abner abner 69632 11月 15 13:52 ports
-rw-rw-r--    1 abner abner  6999 11月 15 13:52 README.md
drwxrwxr-x   14 abner abner  4096 11月 15 13:52 scripts
-rw-rw-r--    1 abner abner  2757 11月 15 13:52 SECURITY.md
-rw-rw-r--    1 abner abner   924 11月 15 13:52 shell.nix
drwxrwxr-x    2 abner abner  4096 11月 15 13:52 toolsrc
drwxrwxr-x    3 abner abner  4096 11月 15 13:52 triplets
drwxrwxr-x   30 abner abner  4096 11月 15 13:52 versions
 


```

# 2. 刚git clone 下来的vcpkg目录

```sh
(base) abner@abner-XPS:~/programs/vcpkg$ ls
bootstrap-vcpkg.bat  CONTRIBUTING.md     docs           NOTICE.txt  scripts      toolsrc
bootstrap-vcpkg.sh   CONTRIBUTING_pt.md  LICENSE.txt    ports       SECURITY.md  triplets
CodeQL.yml           CONTRIBUTING_zh.md  NOTICE_pt.txt  README.md   shell.nix    versions


(base) abner@abner-XPS:~/programs/vcpkg$ ls docs/
about  users


(base) abner@abner-XPS:~/programs/vcpkg$ ls docs/about/
privacy.md


(base) abner@abner-XPS:~/programs/vcpkg$ ls docs/users/
assetcaching.md  binarycaching.md  manifests.md  registries.md  triplets.md  versioning.md


(base) abner@abner-XPS:~/programs/vcpkg$ ls ports/ |more
3fd
7zip
ableton
ableton-link
abseil
absent
abumq-ripe
ace
acl
activemq-cpp
ada-idna
ada-url
ade
adios2
advobfuscator
air-ctl
aixlog
aklomp-base64
alac

 
(base) abner@abner-XPS:~/programs/vcpkg$ ls scripts/ 
addPoshVcpkgToPowershellProfile.ps1  cmake                      tls12-download-arm64.exe
angle                                detect_compiler            tls12-download.exe
azure-pipelines                      generateBaseline.py        toolchains
boost                                generatePortVersionsDb.py  update_suitesparse.py
bootstrap.ps1                        get_cmake_vars             update-vcpkg-tool-metadata.ps1
bootstrap.sh                         ifw                        vcpkg_completion.bash
build_info.cmake                     ports.cmake                vcpkg_completion.fish
buildsystems                         posh-vcpkg                 vcpkg_completion.zsh
ci.baseline.txt                      templates                  vcpkg-tool-metadata.txt
ci.feature.baseline.txt              test_ports                 vcpkg-tools.json


(base) abner@abner-XPS:~/programs/vcpkg$ ls scripts/cmake/ |more 
compile_wrapper_consider_clang-cl.patch
execute_process.cmake
vcpkg_acquire_msys.cmake
vcpkg_add_to_path.cmake
vcpkg_apply_patches.cmake
vcpkg_backup_restore_env_vars.cmake
vcpkg_build_cmake.cmake
vcpkg_build_make.cmake
vcpkg_build_msbuild.cmake
vcpkg_build_ninja.cmake
vcpkg_build_nmake.cmake
vcpkg_buildpath_length_warning.cmake
vcpkg_build_qmake.cmake
vcpkg_check_features.cmake
vcpkg_check_linkage.cmake
vcpkg_clean_executables_in_bin.cmake
vcpkg_clean_msbuild.cmake
vcpkg_common_definitions.cmake
vcpkg_common_functions.cmake


(base) abner@abner-XPS:~/programs/vcpkg$ ls
bootstrap-vcpkg.bat  CONTRIBUTING.md     docs           NOTICE.txt  scripts      toolsrc
bootstrap-vcpkg.sh   CONTRIBUTING_pt.md  LICENSE.txt    ports       SECURITY.md  triplets
CodeQL.yml           CONTRIBUTING_zh.md  NOTICE_pt.txt  README.md   shell.nix    versions


(base) abner@abner-XPS:~/programs/vcpkg$ ls toolsrc/
VERSION.txt


(base) abner@abner-XPS:~/programs/vcpkg$ ls triplets/
arm64-android.cmake  arm64-windows-static-md.cmake  x64-linux.cmake    x64-windows-release.cmake
arm64-osx.cmake      arm-neon-android.cmake         x64-osx.cmake      x64-windows-static.cmake
arm64-uwp.cmake      community                      x64-uwp.cmake      x64-windows-static-md.cmake
arm64-windows.cmake  x64-android.cmake              x64-windows.cmake  x86-windows.cmake


(base) abner@abner-XPS:~/programs/vcpkg$ ls versions/
3-  a-  baseline.json  d-  f-  h-  j-  l-  n-  p-  r-  t-  v-  x-  z-
7-  b-  c-             e-  g-  i-  k-  m-  o-  q-  s-  u-  w-  y-

```


# 3. 编译 vcpkg

```sh
(base) abner@abner-XPS:~/programs/vcpkg$ ./bootstrap-vcpkg.sh
Downloading vcpkg-glibc...
curl: (7) Failed to connect to 127.0.0.1 port 8123 after 0 ms: Couldn't connect to server


(base) abner@abner-XPS:~/programs/vcpkg$ export http_proxy=http://127.0.0.1:15732 https_proxy=http://127.0.0.1:15732


(base) abner@abner-XPS:~/programs/vcpkg$ ./bootstrap-vcpkg.sh
Downloading vcpkg-glibc...
vcpkg package management program version 2025-10-16-71538f2694db93da4668782d094768ba74c45991

See LICENSE.txt for license information.
Telemetry
---------
vcpkg collects usage data in order to help us improve your experience.
The data collected by Microsoft is anonymous.
You can opt-out of telemetry by re-running the bootstrap-vcpkg script with -disableMetrics,
passing --disable-metrics to vcpkg on the command line,
or by setting the VCPKG_DISABLE_METRICS environment variable.

Read more about vcpkg telemetry at docs/about/privacy.md



(base) abner@abner-XPS:~/programs/vcpkg$ ./bootstrap-vcpkg.sh  -disableMetrics
Downloading vcpkg-glibc...
vcpkg package management program version 2025-10-16-71538f2694db93da4668782d094768ba74c45991

See LICENSE.txt for license information.


(base) abner@abner-XPS:~/programs/vcpkg$ ls
bootstrap-vcpkg.bat  CodeQL.yml       CONTRIBUTING_pt.md  docs         NOTICE_pt.txt  ports      scripts      shell.nix  triplets  vcpkg.disable-metrics
bootstrap-vcpkg.sh   CONTRIBUTING.md  CONTRIBUTING_zh.md  LICENSE.txt  NOTICE.txt     README.md  SECURITY.md  toolsrc    vcpkg     versions

```