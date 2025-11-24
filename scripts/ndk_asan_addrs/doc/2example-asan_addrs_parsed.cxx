2025-11-20 15:34:26.085 28304-28347 AndroiOearth01    com.oearth.androearth0vcpkg    I  Warning: PointSprite::apply(State&) - not supported.
2025-11-20 15:34:26.137 28507-28507 DEBUG   pid-28507  A  pid: 28304, tid: 28304, name: ndroearth0vcpkg  >>> com.oearth.androearth0vcpkg <<<
2025-11-20 15:34:26.137 28507-28507 DEBUG   pid-28507  A  Abort message: '=================================================================
		==28304==ERROR: AddressSanitizer: heap-use-after-free on address 0x0056ee3f0218 at pc 0x007a334fe180 bp 0x007fc0811930 sp 0x007fc0811928
		READ of size 4 at 0x0056ee3f0218 thread T0 (ndroearth0vcpkg)


地址: 0x606917c
void osg::KdTree::intersect<osg::TemplatePrimitiveFunctor<LineSegmentIntersectorUtils::IntersectFunctor<osg::Vec3d, double>>>(osg::TemplatePrimitiveFunctor<LineSegmentIntersectorUtils::IntersectFunctor<osg::Vec3d, double>>&, osg::KdTree::KdNode const&) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/KdTree:152

地址: 0x6067f18
osgUtil::LineSegmentIntersector::intersect(osgUtil::IntersectionVisitor&, osg::Drawable*, osg::Vec3d const&, osg::Vec3d const&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/LineSegmentIntersector.cpp:598

地址: 0x6062f34
osgUtil::LineSegmentIntersector::intersect(osgUtil::IntersectionVisitor&, osg::Drawable*) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/LineSegmentIntersector.cpp:562

地址: 0x60299d4
osgUtil::IntersectionVisitor::intersect(osg::Drawable*) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osgUtil/IntersectionVisitor:386

地址: 0x602992c
osgUtil::IntersectionVisitor::apply(osg::Drawable&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/IntersectionVisitor.cpp:226

地址: 0x5053698
osg::Drawable::accept(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/Drawable:97

地址: 0x5748a88
osg::Group::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Group.cpp:63

地址: 0x5557af4
osg::NodeVisitor::traverse(osg::Node&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/NodeVisitor:277

地址: 0x60298f4
osgUtil::IntersectionVisitor::apply(osg::Group&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/IntersectionVisitor.cpp:219

地址: 0x478b400
osg::Group::accept(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/Group:38

地址: 0x5396c78
osgEarth::REX::TileNode::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/TileNode.cpp:0

地址: 0x5557af4
osg::NodeVisitor::traverse(osg::Node&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/NodeVisitor:277

地址: 0x60298f4
osgUtil::IntersectionVisitor::apply(osg::Group&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/IntersectionVisitor.cpp:219

地址: 0x478b400
osg::Group::accept(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/Group:38

地址: 0x5396b68
osgEarth::REX::TileNode::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/TileNode.cpp:565

地址: 0x5557af4
osg::NodeVisitor::traverse(osg::Node&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/NodeVisitor:277

地址: 0x60298f4
osgUtil::IntersectionVisitor::apply(osg::Group&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/IntersectionVisitor.cpp:219

地址: 0x478b400
osg::Group::accept(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/Group:38

地址: 0x5748a88
osg::Group::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Group.cpp:63

地址: 0x5557af4
osg::NodeVisitor::traverse(osg::Node&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/NodeVisitor:277

地址: 0x60298f4
osgUtil::IntersectionVisitor::apply(osg::Group&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/IntersectionVisitor.cpp:219

地址: 0x478b400
osg::Group::accept(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/Group:38

地址: 0x5748a88
osg::Group::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Group.cpp:63

地址: 0x4ff84d4
osgEarth::TerrainEngineNode::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarth/TerrainEngineNode.cpp:325

地址: 0x5557af4
osg::NodeVisitor::traverse(osg::Node&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/NodeVisitor:277

地址: 0x60298f4
osgUtil::IntersectionVisitor::apply(osg::Group&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/IntersectionVisitor.cpp:219

地址: 0x5815714
osg::NodeVisitor::apply(osg::CoordinateSystemNode&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/NodeVisitor.cpp:122

地址: 0x531dd50
osgEarth::REX::RexTerrainEngineNode::accept(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/RexTerrainEngineNode:37

地址: 0x480e854
osgEarth::Util::EarthManipulator::intersectLookVector(osg::Vec3d&, osg::Vec3d&, osg::Vec3d&) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarth/EarthManipulator.cpp:1405

地址: 0x481edd0
osgEarth::Util::EarthManipulator::recalculateCenterFromLookVector() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarth/EarthManipulator.cpp:2465

地址: 0x472c078
OsgMainApp::touchZoomEvent(double) at /mnt/disk2/abner/zdev/nv/osgearth0vcpkg/platform/AndroEarth0Vcpkg/app/src/main/jni/OsgMainApp.cpp:68

地址: 0x4730f00
Java_com_oearth_androearth0vcpkg_osgNativeLib_touchZoomEvent at /mnt/disk2/abner/zdev/nv/osgearth0vcpkg/platform/AndroEarth0Vcpkg/app/src/main/jni/osgNativeLib.cpp:82
===============================================
===============================================
		0x0056ee3f0218 is located 24 bytes inside of 23040-byte region [0x0056ee3f0200,0x0056ee3f5c00)
		freed by thread T21 (GLThread 17) here:
 
#0 0x7b2f9f3ba4  (/data/app/~~d3K_sN68n6UQran2Bv1vcg==/com.oearth.androearth0vcpkg-DoOK1hnmeNdQjr8MgZHtCw==/lib/arm64/libclang_rt.asan-aarch64-android.so+0xf2ba4) (BuildId: d2089f24857cf6bfee934a5c1e8395bab0e414b6)
=== AddressSanitizer 调用栈解析 ===
库文件: /mnt/disk2/abner/zdev/nv/osgearth0vcpkg/platform/AndroEarth0Vcpkg//app/build/intermediates/cxx/Debug/5l1w211y/obj/arm64-v8a/libandroioearth01.so
====================================

地址: 0x46ea088
void std::__ndk1::__libcpp_operator_delete[abi:ne180000]<void*>(void*) at /home/abner/Android/Sdk/ndk/27.0.12077973/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/new:280

地址: 0x46ea038
void std::__ndk1::__do_deallocate_handle_size[abi:ne180000]<>(void*, unsigned long) at /home/abner/Android/Sdk/ndk/27.0.12077973/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/new:302

地址: 0x46e9fdc
std::__ndk1::__libcpp_deallocate[abi:ne180000](void*, unsigned long, unsigned long) at /home/abner/Android/Sdk/ndk/27.0.12077973/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/new:317

地址: 0x579c6d0
std::__ndk1::allocator<osg::KdTree::KdNode>::deallocate[abi:ne180000](osg::KdTree::KdNode*, unsigned long) at /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/__memory/allocator.h:131

地址: 0x579c150
std::__ndk1::allocator_traits<std::__ndk1::allocator<osg::KdTree::KdNode>>::deallocate[abi:ne180000](std::__ndk1::allocator<osg::KdTree::KdNode>&, osg::KdTree::KdNode*, unsigned long) at /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/__memory/allocator_traits.h:289

地址: 0x579cccc
std::__ndk1::vector<osg::KdTree::KdNode, std::__ndk1::allocator<osg::KdTree::KdNode>>::__destroy_vector::operator()[abi:ne180000]() at /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/vector:492

地址: 0x579ca30
std::__ndk1::vector<osg::KdTree::KdNode, std::__ndk1::allocator<osg::KdTree::KdNode>>::~vector[abi:ne180000]() at /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/vector:501

地址: 0x57967b4
osg::KdTree::~KdTree() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/KdTree:26

地址: 0x5796808
osg::KdTree::~KdTree() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/KdTree:26

地址: 0x58cc430
osg::Referenced::signalObserversAndDelete(bool, bool) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:292

地址: 0x58cc7a8
osg::Referenced::unref() const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:348

地址: 0x56373a4
osg::ref_ptr<osg::Shape>::~ref_ptr() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/ref_ptr:61

地址: 0x56380a4
osg::Drawable::~Drawable() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Drawable.cpp:281

地址: 0x5385db4
osgEarth::REX::TileDrawable::~TileDrawable() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/TileDrawable.cpp:73

地址: 0x58cc430
osg::Referenced::signalObserversAndDelete(bool, bool) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:292

地址: 0x58cc7a8
osg::Referenced::unref() const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:348

地址: 0x4966668
osg::ref_ptr<osg::Node>::~ref_ptr() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/ref_ptr:61

地址: 0x5748448
std::__ndk1::vector<osg::ref_ptr<osg::Node>, std::__ndk1::allocator<osg::ref_ptr<osg::Node>>>::~vector[abi:ne180000]() at /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/vector:501

地址: 0x574873c
osg::Group::~Group() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Group.cpp:54

地址: 0x5a9caf0
osg::Transform::~Transform() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Transform.cpp:143

地址: 0x57f9b44
osg::MatrixTransform::~MatrixTransform() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/MatrixTransform.cpp:41

地址: 0x535cc88
osgEarth::REX::SurfaceNode::~SurfaceNode() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/SurfaceNode:27

地址: 0x58cc430
osg::Referenced::signalObserversAndDelete(bool, bool) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:292

地址: 0x58cc7a8
osg::Referenced::unref() const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:348

地址: 0x538cc38
osg::ref_ptr<osgEarth::REX::SurfaceNode>::~ref_ptr() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/ref_ptr:61

地址: 0x538ce80
osgEarth::REX::TileNode::~TileNode() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/TileNode.cpp:81

地址: 0x58cc430
osg::Referenced::signalObserversAndDelete(bool, bool) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:292

地址: 0x58cc7a8
osg::Referenced::unref() const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:348

地址: 0x47b7efc
osg::ref_ptr<osg::Node>::~ref_ptr() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/ref_ptr:61
