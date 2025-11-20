# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html.
# For more examples on how to use CMake, see https://github.com/android/ndk-samples.

# Sets the minimum CMake version required for this project.
cmake_minimum_required(VERSION 3.22.1)

# Declares the project name. The project name can be accessed via ${ PROJECT_NAME},
# Since this is the top level CMakeLists.txt, the project name is also accessible
# with ${CMAKE_PROJECT_NAME} (both CMake variables are in-sync within the top level
# build script scope).
project("androioearth01")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)


# 对所有共享库启用 16KB 对齐
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-z,max-page-size=16384")


# -------- CMAKE_ANDROID_ARCH_ABI
# set(CMAKE_ANDROID_ARCH_ABI  "x86_64" CACHE STRING 
#         "Value should only be one of arm64-v8a, x86_64, armeabi-v7a or x86")
set(ANDROID_API_NAME ${CMAKE_ANDROID_ARCH_ABI})
if( ANDROID_API_NAME  MATCHES "arm64-v8a|x86_64")
    message(STATUS "ANDROID_API_NAME=${ANDROID_API_NAME} is ok!")    
else()
    message(FATAL_ERROR "******ANDROID_API **Should** be arm64-v8a or x86_64,but now: ${ANDROID_API_NAME}!")    
endif()

SET(CMAKE_BUILD_TYPE "Debug")

# --------Android 特定设置
if(ANDROID)
    message(STATUS "^-^....ANDROID=1")   
    # 设置 Android 编译选项
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
    
    # Android 调试配置
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -DDEBUG=1")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g -DDEBUG=1")
    
    # 确保 NDK 也包含调试信息
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        add_compile_options(-g -O0 -fno-omit-frame-pointer)
    endif()
else()
    message(STATUS "^v^....ANDROID !=1")   
endif()

# ------InstallRoot_3rd_vcpkg 
set(InstallRoot_vcpkg "" CACHE PATH "Location of 3rd libraries folder in vcpkg root dir")
mark_as_advanced(InstallRoot_vcpkg)
if(NOT InstallRoot_vcpkg OR NOT EXISTS "${InstallRoot_vcpkg}")
    message(FATAL_ERROR "InstallRoot_vcpkg=${InstallRoot_vcpkg} NOT EXISTS !")
else ()
    message(STATUS "InstallRoot_vcpkg=${InstallRoot_vcpkg} EXISTS ^-^!")
endif()

set(VCPKG_TRIPLET_NAMER "arm64-android-asan")
if("${ANDROID_API_NAME}"  STREQUAL "arm64-v8a")
    set(VCPKG_TRIPLET_NAMER "arm64-android-asan")
# elseif("${ANDROID_API_NAME}"  STREQUAL "x86_64")
#     set(VCPKG_TRIPLET_NAMER "x64-android")    
else()
    message(FATAL_ERROR "******ERROR: vcpkg asan can only support arm64-android-asan now!")
endif()
set(InstallRoot_3rd_vcpkg "${InstallRoot_vcpkg}/arm64-android-asan")
 

# ------InstallRoot_3rd 
set(InstallRoot_3rd "" CACHE PATH "Location of 3rd libraries folder")
mark_as_advanced(InstallRoot_3rd)
if(NOT InstallRoot_3rd OR NOT EXISTS "${InstallRoot_3rd}")
    message(FATAL_ERROR "InstallRoot_3rd=${InstallRoot_3rd} NOT EXISTS !")
else ()
    message(STATUS "InstallRoot_3rd=${InstallRoot_3rd} EXISTS ^-^!")
endif()
 

set(Libs3rd_includeDIRS "")
set(Libs3rd_LIBS "")
if( NOT EXISTS "${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/include")
    message(FATAL_ERROR "InstallRoot_3rd=${InstallRoot_3rd} NOT EXISTS !")
else()
    list(APPEND    Libs3rd_includeDIRS
       ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/include 
        )       
    list(APPEND  Libs3rd_LIBS 
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/libosgEarth.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_earth.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_gltf.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_kml.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_bumpmap.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_cache_filesystem.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_colorramp.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_detail.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_engine_rex.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_featurefilter_intersect.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_featurefilter_join.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_scriptengine_javascript.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_sky_gl.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_sky_simple.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_terrainshader.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_vdatum_egm2008.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_vdatum_egm84.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_vdatum_egm96.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_osgearth_viewpoints.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_template.a
        ${InstallRoot_3rd}/osgearth/${ANDROID_API_NAME}/lib/osgdb_zip.a        
     )    
        
endif()


if( NOT EXISTS "${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/include")
    message(FATAL_ERROR "InstallRoot_3rd=${InstallRoot_3rd} NOT EXISTS !")
else()
    list(APPEND    Libs3rd_includeDIRS
       ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/include 
        )        

    list(APPEND  Libs3rd_LIBS 
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libOpenThreads.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosg.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgAnimation.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgDB.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgFX.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgGA.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgManipulator.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgParticle.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgPresentation.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgShadow.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgSim.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgTerrain.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgText.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgUI.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgUtil.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgViewer.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgVolume.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/libosgWidget.a        
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_3dc.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_ac.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_bmp.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_bsp.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_bvh.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_cfg.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_curl.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_dds.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_deprecated_osg.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_deprecated_osganimation.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_deprecated_osgfx.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_deprecated_osgparticle.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_deprecated_osgshadow.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_deprecated_osgsim.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_deprecated_osgterrain.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_deprecated_osgtext.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_deprecated_osgviewer.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_deprecated_osgvolume.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_deprecated_osgwidget.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_dot.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_dxf.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_freetype.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_gdal.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_gles.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_glsl.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_gz.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_hdr.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_ive.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_jpeg.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_ktx.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_logo.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_lua.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_lws.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_md2.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_mdl.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_normals.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_obj.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_ogr.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_openflight.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_osc.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_osg.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_osga.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_osgjs.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_osgshadow.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_osgterrain.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_osgtgz.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_osgviewer.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_p3d.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_pic.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_png.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_pnm.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_pov.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_pvr.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_revisions.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_rgb.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_rot.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_scale.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osg.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osganimation.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osgfx.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osgga.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osgmanipulator.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osgparticle.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osgshadow.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osgsim.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osgterrain.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osgtext.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osgui.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osgutil.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osgviewer.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_serializers_osgvolume.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_shp.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_stl.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_tf.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_tga.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_tgz.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_tiff.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_trans.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_trk.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_txf.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_vtf.a
        ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_x.a
        # ### do not use "osg/**/libosgdb_zip.a", but use "osgearth/**/osgdb_zip.a". 
        # ${InstallRoot_3rd}/osg/${ANDROID_API_NAME}/lib/osgPlugins-3.7.0/libosgdb_zip.a        
    )
  
endif()


if( NOT EXISTS "${InstallRoot_3rd_vcpkg}/lib")
    message(FATAL_ERROR "{InstallRoot_3rd_vcpkg}/lib=${InstallRoot_3rd}/lib NOT EXISTS !")
else()   

    list(APPEND  Libs3rd_LIBS 
        ${InstallRoot_3rd_vcpkg}/lib/libjpeg.a

        ${InstallRoot_3rd_vcpkg}/lib/libabsl_base.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_city.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_civil_time.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_cord.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_cord_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_cordz_functions.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_cordz_handle.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_cordz_info.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_cordz_sample_token.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_crc32c.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_crc_cord_state.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_crc_cpu_detect.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_crc_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_debugging_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_decode_rust_punycode.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_demangle_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_demangle_rust.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_die_if_null.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_examine_stack.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_exponential_biased.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_failure_signal_handler.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_flags_commandlineflag.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_flags_commandlineflag_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_flags_config.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_flags_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_flags_marshalling.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_flags_parse.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_flags_private_handle_accessor.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_flags_program_name.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_flags_reflection.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_flags_usage.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_flags_usage_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_graphcycles_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_hash.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_hashtablez_sampler.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_int128.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_kernel_timeout_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_leak_check.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_flags.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_globals.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_initialize.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_internal_check_op.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_internal_conditions.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_internal_fnmatch.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_internal_format.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_internal_globals.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_internal_log_sink_set.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_internal_message.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_internal_nullguard.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_internal_proto.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_internal_structured_proto.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_severity.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_log_sink.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_low_level_hash.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_malloc_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_periodic_sampler.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_poison.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_random_distributions.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_random_internal_distribution_test_util.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_random_internal_entropy_pool.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_random_internal_platform.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_random_internal_randen.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_random_internal_randen_hwaes.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_random_internal_randen_hwaes_impl.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_random_internal_randen_slow.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_random_internal_seed_material.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_random_seed_gen_exception.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_random_seed_sequences.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_raw_hash_set.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_raw_logging_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_scoped_set_env.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_spinlock_wait.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_stacktrace.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_status.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_statusor.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_strerror.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_str_format_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_strings.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_strings_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_string_view.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_symbolize.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_synchronization.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_throw_delegate.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_time.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_time_zone.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_tracing_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_utf8_for_code_point.a
        ${InstallRoot_3rd_vcpkg}/lib/libabsl_vlog_config_internal.a
        ${InstallRoot_3rd_vcpkg}/lib/libbrotlicommon.a
        ${InstallRoot_3rd_vcpkg}/lib/libbrotlidec.a
        ${InstallRoot_3rd_vcpkg}/lib/libbrotlienc.a
        ${InstallRoot_3rd_vcpkg}/lib/libbz2.a
        ${InstallRoot_3rd_vcpkg}/lib/libcrypto.a
        ${InstallRoot_3rd_vcpkg}/lib/libcurl.a
        ${InstallRoot_3rd_vcpkg}/lib/libexpat.a
        ${InstallRoot_3rd_vcpkg}/lib/libfreetype.a
        ${InstallRoot_3rd_vcpkg}/lib/libgdal.a
        ${InstallRoot_3rd_vcpkg}/lib/libgeos.a
        ${InstallRoot_3rd_vcpkg}/lib/libgeos_c.a
        ${InstallRoot_3rd_vcpkg}/lib/libgeotiff.a
        ${InstallRoot_3rd_vcpkg}/lib/libjpeg.a
        ${InstallRoot_3rd_vcpkg}/lib/libjson-c.a
        ${InstallRoot_3rd_vcpkg}/lib/libkmlbase.a
        ${InstallRoot_3rd_vcpkg}/lib/libkmlconvenience.a
        ${InstallRoot_3rd_vcpkg}/lib/libkmldom.a
        ${InstallRoot_3rd_vcpkg}/lib/libkmlengine.a
        ${InstallRoot_3rd_vcpkg}/lib/libkmlregionator.a
        ${InstallRoot_3rd_vcpkg}/lib/libkmlxsd.a
        ${InstallRoot_3rd_vcpkg}/lib/liblunasvg.a
        ${InstallRoot_3rd_vcpkg}/lib/liblzma.a
        ${InstallRoot_3rd_vcpkg}/lib/libminizip.a
        ${InstallRoot_3rd_vcpkg}/lib/libopenjp2.a
        ${InstallRoot_3rd_vcpkg}/lib/libplutovg.a
        ${InstallRoot_3rd_vcpkg}/lib/libpng16.a
        ${InstallRoot_3rd_vcpkg}/lib/libpng.a
        ${InstallRoot_3rd_vcpkg}/lib/libproj.a
        ${InstallRoot_3rd_vcpkg}/lib/libprotobuf.a
        ${InstallRoot_3rd_vcpkg}/lib/libprotobuf-lite.a
        ${InstallRoot_3rd_vcpkg}/lib/libprotoc.a
        ${InstallRoot_3rd_vcpkg}/lib/libqhullcpp.a
        ${InstallRoot_3rd_vcpkg}/lib/libqhullstatic.a
        ${InstallRoot_3rd_vcpkg}/lib/libqhullstatic_r.a
        ${InstallRoot_3rd_vcpkg}/lib/libsharpyuv.a
        ${InstallRoot_3rd_vcpkg}/lib/libsqlite3.a
        ${InstallRoot_3rd_vcpkg}/lib/libssl.a
        ${InstallRoot_3rd_vcpkg}/lib/libtiff.a
        ${InstallRoot_3rd_vcpkg}/lib/libturbojpeg.a
        ${InstallRoot_3rd_vcpkg}/lib/liburiparser.a
        ${InstallRoot_3rd_vcpkg}/lib/libutf8_range.a
        ${InstallRoot_3rd_vcpkg}/lib/libutf8_validity.a
        ${InstallRoot_3rd_vcpkg}/lib/libwebp.a
        ${InstallRoot_3rd_vcpkg}/lib/libwebpdecoder.a
        ${InstallRoot_3rd_vcpkg}/lib/libwebpdemux.a
        ${InstallRoot_3rd_vcpkg}/lib/libwebpmux.a
        ${InstallRoot_3rd_vcpkg}/lib/libxml2.a
        ${InstallRoot_3rd_vcpkg}/lib/libz.a
        ${InstallRoot_3rd_vcpkg}/lib/libzip.a
        ${InstallRoot_3rd_vcpkg}/lib/libiconv.a
    )
endif() 
     
    

# ------OEarthJni_SRC_FILES 
# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds them for you.
# Gradle automatically packages shared libraries with your APK.
#
# In this top level CMakeLists.txt, ${CMAKE_PROJECT_NAME} is used to define
# the target library name; in the sub-module's CMakeLists.txt, ${PROJECT_NAME}
# is preferred for the same purpose.
#
# In order to load a library into your app from Java/Kotlin, you must call
# System.loadLibrary() and pass the name of the library defined here;
# for GameActivity/NativeActivity derived applications, the same library name must be
# used in the AndroidManifest.xml file.
set(OEarthJni_SRC_FILES 
        # a-native-lib.cpp  // a-native-lib.cpp is created by wizard
        OsgDebugMsgHandler.cpp
        OeLayerFactory.cpp
        OsgDemoScene.cpp    OsgMainApp.cpp    
        osgNativeLib.cpp   
         )

message(STATUS "Libs3rd_includeDIRS=${Libs3rd_includeDIRS} haha!")
message(STATUS "Libs3rd_LIBS=${Libs3rd_LIBS} haha!")

# return() #### hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh

add_library(${CMAKE_PROJECT_NAME} SHARED
        # List C/C++ source files with relative paths to this CMakeLists.txt.
        ${OEarthJni_SRC_FILES} )


# Android 特定的目标设置
if(ANDROID)
    target_compile_options(${CMAKE_PROJECT_NAME} PRIVATE
        $<$<CONFIG:Debug>:
            -g
            -ggdb            
            -fno-optimize-sibling-calls             
            -fno-omit-frame-pointer
            > 
    )
    
    # 防止 strip
    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
        ANDROID_ARM_NEON TRUE
        NO_SYSTEM_FROM_IMPORTED TRUE
    ) 

    if(ENABLE_123HWASAN)
        target_compile_options(${CMAKE_PROJECT_NAME} PRIVATE
            $<$<CONFIG:Debug>:-fsanitize=hwaddress  -fno-omit-frame-pointer>   )    
        target_link_options(${CMAKE_PROJECT_NAME} PRIVATE 
                $<$<CONFIG:Debug>:-fsanitize=hwaddress>  
                ) 
    elseif(ENABLE_123ASAN) 
        target_compile_options(${CMAKE_PROJECT_NAME} PRIVATE
            $<$<CONFIG:Debug>:-fsanitize=address  -fno-omit-frame-pointer>   )    
        target_link_options(${CMAKE_PROJECT_NAME} PRIVATE 
                $<$<CONFIG:Debug>:-fsanitize=address>  
                )                                   
    endif()  
endif()

target_compile_definitions(${CMAKE_PROJECT_NAME}
    PRIVATE
        -DOSG_LIBRARY_STATIC=1, 
        -DOSGEARTH_LIBRARY_STATIC=1
        )

target_include_directories(${CMAKE_PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        ${Libs3rd_includeDIRS}
        ${InstallRoot_3rd_vcpkg}/include
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/
)

# Specifies libraries CMake should link to your target library. You
# can link libraries from various origins, such as libraries defined in this
# build script, prebuilt third-party libraries, or Android system libraries.
target_link_libraries(${CMAKE_PROJECT_NAME}
        # List libraries link to the target library
        ${Libs3rd_LIBS}
        android
        log
        GLESv3  
        # ​​NDK r18+（推荐）​​：Google 移除了 gnustl（GNU STL），仅保留 libc++（LLVM 的 C++ 标准库）。​
        #                  ​无需再链接 gnustl_static或 supc++​​。
        #                  自动链接 libc++，无需手动指定
        # ​​NDK r17 及更早​​：若使用 GNU STL，需显式链接 gnustl_static和 supc++。
        dl         
        )