地址: 0x606917c
void osg::KdTree::intersect<osg::TemplatePrimitiveFunctor<LineSegmentIntersectorUtils::IntersectFunctor<osg::Vec3d, double>>>(osg::TemplatePrimitiveFunctor<LineSegmentIntersectorUtils::IntersectFunctor<osg::Vec3d, double>>&, osg::KdTree::KdNode const&) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/KdTree:152
```cpp
        template<class IntersectFunctor>
        void intersect(IntersectFunctor& functor, const KdNode& node) const
        {
            if (node.first<0)
            {
```				




地址: 0x6067f18
osgUtil::LineSegmentIntersector::intersect(osgUtil::IntersectionVisitor&, osg::Drawable*, osg::Vec3d const&, osg::Vec3d const&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/LineSegmentIntersector.cpp:598
```cpp
void LineSegmentIntersector::intersect(osgUtil::IntersectionVisitor& iv, osg::Drawable* drawable,
                                       const osg::Vec3d& s, const osg::Vec3d& e)
{
    if (reachedLimit()) 
        return;
    
    if (!drawable)
    {
        OSG_FATAL<< "LineSegmentIntersector::intersect(iv,drawable,s,e): drawable is null."<<s<<" "<<e<<std::endl;
        return;
    }
    

    LineSegmentIntersectorUtils::Settings settings;
    settings._lineSegIntersector = this;
    settings._iv = &iv;
    settings._drawable = drawable;
    settings._limitOneIntersection = (_intersectionLimit == LIMIT_ONE_PER_DRAWABLE || _intersectionLimit == LIMIT_ONE);

    osg::Geometry* geometry = drawable->asGeometry();
    if (geometry)
    {
        settings._vertices = dynamic_cast<osg::Vec3Array*>(geometry->getVertexArray());
    }

    osg::KdTree* kdTree = iv.getUseKdTreeWhenAvailable() ? dynamic_cast<osg::KdTree*>(drawable->getShape()) : 0;

    if (getPrecisionHint()==USE_DOUBLE_CALCULATIONS)
    {
        osg::TemplatePrimitiveFunctor<LineSegmentIntersectorUtils::IntersectFunctor<osg::Vec3d, double> > intersector;
        intersector.set(s,e, &settings);

        if (kdTree) 
            kdTree->intersect(intersector, kdTree->getNode(0));//<-----
        else 
            drawable->accept(intersector);
    }
    else
    {
        osg::TemplatePrimitiveFunctor<LineSegmentIntersectorUtils::IntersectFunctor<osg::Vec3f, float> > intersector;
        intersector.set(s,e, &settings);

        if (kdTree) 
            kdTree->intersect(intersector, kdTree->getNode(0));
        else 
            drawable->accept(intersector);
    }
}
```


地址: 0x6062f34
osgUtil::LineSegmentIntersector::intersect(osgUtil::IntersectionVisitor&, osg::Drawable*) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/LineSegmentIntersector.cpp:562
```cpp
void LineSegmentIntersector::intersect(osgUtil::IntersectionVisitor& iv, osg::Drawable* drawable)
{
    if (reachedLimit()) 
        return;

    osg::Vec3d s(_start), e(_end);
    if ( drawable->isCullingActive() && !intersectAndClip( s, e, drawable->getBoundingBox() ) ) 
        return;

    if (iv.getDoDummyTraversal()) 
        return;

    intersect(iv, drawable, s, e);//<-----
}
```


地址: 0x60299d4
osgUtil::IntersectionVisitor::intersect(osg::Drawable*) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osgUtil/IntersectionVisitor:386
```cpp
        inline void intersect(osg::Drawable* drawable) { 
          _intersectorStack.back()->intersect(*this, drawable); //<-----
        }
```

地址: 0x602992c
osgUtil::IntersectionVisitor::apply(osg::Drawable&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/IntersectionVisitor.cpp:226
```cpp
void IntersectionVisitor::apply(osg::Drawable& drawable)
{
    intersect( &drawable );//<-----
}
```

地址: 0x5053698
osg::Drawable::accept(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/Drawable:97
```cpp
class OSG_EXPORT Drawable : public Node
{
    public:

        Drawable();

        /** Copy constructor using CopyOp to manage deep vs shallow copy.*/
        Drawable(const Drawable& drawable,const CopyOp& copyop=CopyOp::SHALLOW_COPY);

        META_Node(osg, Drawable);//<-----
```

地址: 0x5748a88
osg::Group::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Group.cpp:63
```cpp
void Group::traverse(NodeVisitor& nv)
{
    for(NodeList::iterator itr=_children.begin();
        itr!=_children.end();
        ++itr)
    {
        (*itr)->accept(nv);//<-----
    }
}
```

地址: 0x5557af4
osg::NodeVisitor::traverse(osg::Node&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/NodeVisitor:277
```cpp
        inline void traverse(Node& node)
        {
            if (_traversalMode==TRAVERSE_PARENTS) node.ascend(*this);
            else if (_traversalMode!=TRAVERSE_NONE) node.traverse(*this);//<-----
        }
```

地址: 0x60298f4
osgUtil::IntersectionVisitor::apply(osg::Group&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/IntersectionVisitor.cpp:219
```cpp
void IntersectionVisitor::apply(osg::Group& group)
{
    if (!enter(group)) return;

    traverse(group);//<-----

    leave();
}
```

地址: 0x478b400
osg::Group::accept(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/Group:38
```cpp
class OSG_EXPORT Group : public Node
{
    public :


        Group();

        /** Copy constructor using CopyOp to manage deep vs shallow copy. */
        Group(const Group&,const CopyOp& copyop=CopyOp::SHALLOW_COPY);

        META_Node(osg, Group);//<-----
```

地址: 0x5396c78
osgEarth::REX::TileNode::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/TileNode.cpp:0

地址: 0x5557af4
osg::NodeVisitor::traverse(osg::Node&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/NodeVisitor:277
```cpp
        inline void traverse(Node& node)
        {
            if (_traversalMode==TRAVERSE_PARENTS) node.ascend(*this);
            else if (_traversalMode!=TRAVERSE_NONE) node.traverse(*this);//<-----
        }
```

地址: 0x60298f4
osgUtil::IntersectionVisitor::apply(osg::Group&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/IntersectionVisitor.cpp:219
```cpp
void IntersectionVisitor::apply(osg::Group& group)
{
    if (!enter(group)) return;

    traverse(group);//<-----

    leave();
}
```

地址: 0x478b400
osg::Group::accept(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/Group:38
```cpp
class OSG_EXPORT Group : public Node
{
    public :


        Group();

        /** Copy constructor using CopyOp to manage deep vs shallow copy. */
        Group(const Group&,const CopyOp& copyop=CopyOp::SHALLOW_COPY);

        META_Node(osg, Group);//<-----
```


地址: 0x5396b68
osgEarth::REX::TileNode::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/TileNode.cpp:565

地址: 0x5557af4
osg::NodeVisitor::traverse(osg::Node&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/NodeVisitor:277
```cpp
        inline void traverse(Node& node)
        {
            if (_traversalMode==TRAVERSE_PARENTS) node.ascend(*this);
            else if (_traversalMode!=TRAVERSE_NONE) node.traverse(*this);//<-----
        }
```

地址: 0x60298f4
osgUtil::IntersectionVisitor::apply(osg::Group&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/IntersectionVisitor.cpp:219
```cpp
void IntersectionVisitor::apply(osg::Group& group)
{
    if (!enter(group)) return;

    traverse(group);//<-----

    leave();
}
```

地址: 0x478b400
osg::Group::accept(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/Group:38
```cpp
class OSG_EXPORT Group : public Node
{
    public :


        Group();

        /** Copy constructor using CopyOp to manage deep vs shallow copy. */
        Group(const Group&,const CopyOp& copyop=CopyOp::SHALLOW_COPY);

        META_Node(osg, Group);//<-----
```

地址: 0x5748a88
osg::Group::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Group.cpp:63
```cpp
void Group::traverse(NodeVisitor& nv)
{
    for(NodeList::iterator itr=_children.begin();
        itr!=_children.end();
        ++itr)
    {
        (*itr)->accept(nv);//<-----
    }
}
```

地址: 0x5557af4
osg::NodeVisitor::traverse(osg::Node&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/NodeVisitor:277
```cpp
        inline void traverse(Node& node)
        {
            if (_traversalMode==TRAVERSE_PARENTS) node.ascend(*this);
            else if (_traversalMode!=TRAVERSE_NONE) node.traverse(*this);//<-----
        }
```


地址: 0x60298f4
osgUtil::IntersectionVisitor::apply(osg::Group&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/IntersectionVisitor.cpp:219
```cpp
void IntersectionVisitor::apply(osg::Group& group)
{
    if (!enter(group)) return;

    traverse(group);//<-----

    leave();
}
```

地址: 0x478b400
osg::Group::accept(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/Group:38
```cpp
class OSG_EXPORT Group : public Node
{
    public :


        Group();

        /** Copy constructor using CopyOp to manage deep vs shallow copy. */
        Group(const Group&,const CopyOp& copyop=CopyOp::SHALLOW_COPY);

        META_Node(osg, Group);//<-----
```


地址: 0x5748a88
osg::Group::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Group.cpp:63
```cpp
void Group::traverse(NodeVisitor& nv)
{
    for(NodeList::iterator itr=_children.begin();
        itr!=_children.end();
        ++itr)
    {
        (*itr)->accept(nv);//<-----
    }
}
```

地址: 0x4ff84d4
osgEarth::TerrainEngineNode::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarth/TerrainEngineNode.cpp:325
```cpp
void
TerrainEngineNode::traverse( osg::NodeVisitor& nv )
{
    if ( nv.getVisitorType() == nv.EVENT_VISITOR )
    {
        _dirtyCount = 0;
        if (_updateScheduled == false && _terrainInterface->_updateQueue->empty() == false)
        {
            ADJUST_UPDATE_TRAV_COUNT(this, +1);
            _updateScheduled = true;
        }
    }

    else if (nv.getVisitorType() == nv.UPDATE_VISITOR)
    {
        if (_updateScheduled == true )
        {
            _terrainInterface->update();
            ADJUST_UPDATE_TRAV_COUNT(this, -1);
            _updateScheduled = false;
        }
    }

    osg::CoordinateSystemNode::traverse( nv );//<----
}
```



地址: 0x5557af4
osg::NodeVisitor::traverse(osg::Node&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/NodeVisitor:277
```cpp
        inline void traverse(Node& node)
        {
            if (_traversalMode==TRAVERSE_PARENTS) node.ascend(*this);
            else if (_traversalMode!=TRAVERSE_NONE) node.traverse(*this); //<-----
        }
```

地址: 0x60298f4
osgUtil::IntersectionVisitor::apply(osg::Group&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osgUtil/IntersectionVisitor.cpp:219
```cpp
void IntersectionVisitor::apply(osg::Group& group)
{
    if (!enter(group)) return;

    traverse(group);//<---

    leave();
}
```


地址: 0x5815714
osg::NodeVisitor::apply(osg::CoordinateSystemNode&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/NodeVisitor.cpp:122
```cpp
void NodeVisitor::apply(CoordinateSystemNode& node)
{
    apply(static_cast<Group&>(node));// <----
}
```

地址: 0x531dd50
osgEarth::REX::RexTerrainEngineNode::accept(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/
RexTerrainEngineNode:37
```cpp
    class RexTerrainEngineNode : public osgEarth::TerrainEngineNode
    {
    public:
        META_Node(osgEarth, RexTerrainEngineNode);//<-----
```

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
```cpp
class OSG_EXPORT KdTree : public osg::Shape//<--------------
{
    public:
```

地址: 0x58cc430
osg::Referenced::signalObserversAndDelete(bool, bool) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:292
```cpp
void Referenced::signalObserversAndDelete(bool signalDelete, bool doDelete) const
{
#if defined(_OSG_REFERENCED_USE_ATOMIC_OPERATIONS)
    ObserverSet* observerSet = static_cast<ObserverSet*>(_observerSet.get());
#else
    ObserverSet* observerSet = static_cast<ObserverSet*>(_observerSet);
#endif

    if (observerSet && signalDelete)
    {
        observerSet->signalObjectDeleted(const_cast<Referenced*>(this));
    }

    if (doDelete)
    {
        if (_refCount!=0)
            OSG_NOTICE<<"Warning Referenced::signalObserversAndDelete(,,) doing delete with _refCount="<<_refCount<<std::endl;

        if (getDeleteHandler()) deleteUsingDeleteHandler();
        else delete this;//<--------------
    }
}

```


地址: 0x58cc7a8
osg::Referenced::unref() const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:348
```cpp
int Referenced::unref() const
{
    int newRef;
#if defined(_OSG_REFERENCED_USE_ATOMIC_OPERATIONS)
    OSG_WARN<<"og...include/osg/Referenced(01): _refCount="<<_refCount <<std::endl;
    newRef = --_refCount;
    bool needDelete = (newRef == 0);
#else
    // OSG_WARN<<"og...include/osg/Referenced(02): _refCount="<<_refCount <<std::endl;
    bool needDelete = false;
    if (_refMutex)
    {
        OpenThreads::ScopedLock<OpenThreads::Mutex> lock(*_refMutex);
        // OSG_WARN<<"og...include/osg/Referenced(03): _refCount="<<_refCount <<std::endl;
        newRef = --_refCount;
        needDelete = newRef==0;
    }
    else
    {
        OSG_WARN<<"og...include/osg/Referenced(04): _refCount="<<_refCount <<std::endl;
        newRef = --_refCount;
        needDelete = newRef==0;
    }
#endif

    if (needDelete)
    {
        signalObserversAndDelete(true,true);//<----
    }
    return newRef;
}
```

地址: 0x56373a4
osg::ref_ptr<osg::Shape>::~ref_ptr() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/ref_ptr:61
```cpp
        ~ref_ptr() { 
            if (_ptr) 
                _ptr->unref();  //<------------
            _ptr = 0; 
        }
```

地址: 0x56380a4
osg::Drawable::~Drawable() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Drawable.cpp:281
```cpp
Drawable::~Drawable()
{
    // clean up display lists if assigned, for the display lists size  we can't use glGLObjectSizeHint() as it's a virtual function, so have to default to a 0 size hint.
    #ifdef OSG_GL_DISPLAYLISTS_AVAILABLE
    for(unsigned int i=0;i<_globjList.size();++i)
    {
        if (_globjList[i] != 0)
        {
            Drawable::deleteDisplayList(i,_globjList[i], 0); // we don't know getGLObjectSizeHint()
            _globjList[i] = 0;
        }
    }
    #endif

    // clean up VertexArrayState
    for(unsigned int i=0; i<_vertexArrayStateList.size(); ++i)
    {
        VertexArrayState* vas = _vertexArrayStateList[i].get();
        if (vas)
        {
            vas->release();
            _vertexArrayStateList[i] = 0;
        }
    }
}//<------------
```

地址: 0x5385db4
osgEarth::REX::TileDrawable::~TileDrawable() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/TileDrawable.cpp:73
```cpp
TileDrawable::~TileDrawable()
{//<--------------
    //nop
}
```

地址: 0x58cc430
osg::Referenced::signalObserversAndDelete(bool, bool) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:292
```cpp
void Referenced::signalObserversAndDelete(bool signalDelete, bool doDelete) const
{
#if defined(_OSG_REFERENCED_USE_ATOMIC_OPERATIONS)
    ObserverSet* observerSet = static_cast<ObserverSet*>(_observerSet.get());
#else
    ObserverSet* observerSet = static_cast<ObserverSet*>(_observerSet);
#endif

    if (observerSet && signalDelete)
    {
        observerSet->signalObjectDeleted(const_cast<Referenced*>(this));
    }

    if (doDelete)
    {
        if (_refCount!=0)
            OSG_NOTICE<<"Warning Referenced::signalObserversAndDelete(,,) doing delete with _refCount="<<_refCount<<std::endl;

        if (getDeleteHandler()) deleteUsingDeleteHandler();
        else delete this;//<--------------
    }
}

```

地址: 0x58cc7a8
osg::Referenced::unref() const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:348
```cpp
int Referenced::unref() const
{
    int newRef;
#if defined(_OSG_REFERENCED_USE_ATOMIC_OPERATIONS)
    OSG_WARN<<"og...include/osg/Referenced(01): _refCount="<<_refCount <<std::endl;
    newRef = --_refCount;
    bool needDelete = (newRef == 0);
#else
    // OSG_WARN<<"og...include/osg/Referenced(02): _refCount="<<_refCount <<std::endl;
    bool needDelete = false;
    if (_refMutex)
    {
        OpenThreads::ScopedLock<OpenThreads::Mutex> lock(*_refMutex);
        // OSG_WARN<<"og...include/osg/Referenced(03): _refCount="<<_refCount <<std::endl;
        newRef = --_refCount;
        needDelete = newRef==0;
    }
    else
    {
        OSG_WARN<<"og...include/osg/Referenced(04): _refCount="<<_refCount <<std::endl;
        newRef = --_refCount;
        needDelete = newRef==0;
    }
#endif

    if (needDelete)
    {
        signalObserversAndDelete(true,true);//<----
    }
    return newRef;
}
```

地址: 0x4966668
osg::ref_ptr<osg::Node>::~ref_ptr() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/ref_ptr:61
```cpp
        ~ref_ptr() { 
            if (_ptr) 
                _ptr->unref();  //<----
            _ptr = 0; 
        }
```


地址: 0x5748448
std::__ndk1::vector<osg::ref_ptr<osg::Node>, std::__ndk1::allocator<osg::ref_ptr<osg::Node>>>::~vector[abi:ne180000]() at /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/vector:501

地址: 0x574873c
osg::Group::~Group() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Group.cpp:54
```cpp
Group::~Group()
{
    // remove reference to this from children's parent lists.
    for(NodeList::iterator itr=_children.begin();
        itr!=_children.end();
        ++itr)
    {
        (*itr)->removeParent(this);
    }

}//<-------------
```

地址: 0x5a9caf0
osg::Transform::~Transform() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Transform.cpp:143
```cpp
Transform::~Transform()
{
}//<---------------
```

地址: 0x57f9b44
osg::MatrixTransform::~MatrixTransform() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/MatrixTransform.cpp:41
```cpp
MatrixTransform::~MatrixTransform()
{
}//<---------------
```

地址: 0x535cc88
osgEarth::REX::SurfaceNode::~SurfaceNode() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/SurfaceNode:27
```cpp
namespace osgEarth { namespace REX
{
    using namespace osgEarth;

    /**
     * SurfaceNode holds the geometry and transform information
     * for one terrain tile surface.
     */
    class SurfaceNode : public osg::MatrixTransform //<----------------------------------- 
    {
```

地址: 0x58cc430
osg::Referenced::signalObserversAndDelete(bool, bool) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:292
```cpp
void Referenced::signalObserversAndDelete(bool signalDelete, bool doDelete) const
{
#if defined(_OSG_REFERENCED_USE_ATOMIC_OPERATIONS)
    ObserverSet* observerSet = static_cast<ObserverSet*>(_observerSet.get());
#else
    ObserverSet* observerSet = static_cast<ObserverSet*>(_observerSet);
#endif

    if (observerSet && signalDelete)
    {
        observerSet->signalObjectDeleted(const_cast<Referenced*>(this));
    }

    if (doDelete)
    {
        if (_refCount!=0)
            OSG_NOTICE<<"Warning Referenced::signalObserversAndDelete(,,) doing delete with _refCount="<<_refCount<<std::endl;

        if (getDeleteHandler()) deleteUsingDeleteHandler();
        else delete this;//<--------------
    }
}

```


地址: 0x58cc7a8
osg::Referenced::unref() const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:348
```cpp
int Referenced::unref() const
{
    int newRef;
#if defined(_OSG_REFERENCED_USE_ATOMIC_OPERATIONS)
    OSG_WARN<<"og...include/osg/Referenced(01): _refCount="<<_refCount <<std::endl;
    newRef = --_refCount;
    bool needDelete = (newRef == 0);
#else
    // OSG_WARN<<"og...include/osg/Referenced(02): _refCount="<<_refCount <<std::endl;
    bool needDelete = false;
    if (_refMutex)
    {
        OpenThreads::ScopedLock<OpenThreads::Mutex> lock(*_refMutex);
        // OSG_WARN<<"og...include/osg/Referenced(03): _refCount="<<_refCount <<std::endl;
        newRef = --_refCount;
        needDelete = newRef==0;
    }
    else
    {
        OSG_WARN<<"og...include/osg/Referenced(04): _refCount="<<_refCount <<std::endl;
        newRef = --_refCount;
        needDelete = newRef==0;
    }
#endif

    if (needDelete)
    {
        signalObserversAndDelete(true,true);//<----
    }
    return newRef;
}
```


地址: 0x538cc38
osg::ref_ptr<osgEarth::REX::SurfaceNode>::~ref_ptr() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/ref_ptr:61
```cpp
        ~ref_ptr() { 
            if (_ptr) 
                _ptr->unref();  //<----
            _ptr = 0; 
        }
```


地址: 0x538ce80
osgEarth::REX::TileNode::~TileNode() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/TileNode.cpp:81
```cpp
TileNode::~TileNode()
{ //<------------------
    //nop
}
```


地址: 0x58cc430
osg::Referenced::signalObserversAndDelete(bool, bool) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:292
```cpp
void Referenced::signalObserversAndDelete(bool signalDelete, bool doDelete) const
{
#if defined(_OSG_REFERENCED_USE_ATOMIC_OPERATIONS)
    ObserverSet* observerSet = static_cast<ObserverSet*>(_observerSet.get());
#else
    ObserverSet* observerSet = static_cast<ObserverSet*>(_observerSet);
#endif

    if (observerSet && signalDelete)
    {
        observerSet->signalObjectDeleted(const_cast<Referenced*>(this));
    }

    if (doDelete)
    {
        if (_refCount!=0)
            OSG_NOTICE<<"Warning Referenced::signalObserversAndDelete(,,) doing delete with _refCount="<<_refCount<<std::endl;

        if (getDeleteHandler()) deleteUsingDeleteHandler();
        else delete this;//<--------------
    }
}

```


地址: 0x58cc7a8
osg::Referenced::unref() const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:348
```cpp

int Referenced::unref() const
{
    int newRef;
#if defined(_OSG_REFERENCED_USE_ATOMIC_OPERATIONS)
    OSG_WARN<<"og...include/osg/Referenced(01): _refCount="<<_refCount <<std::endl;
    newRef = --_refCount;
    bool needDelete = (newRef == 0);
#else
    // OSG_WARN<<"og...include/osg/Referenced(02): _refCount="<<_refCount <<std::endl;
    bool needDelete = false;
    if (_refMutex)
    {
        OpenThreads::ScopedLock<OpenThreads::Mutex> lock(*_refMutex);
        // OSG_WARN<<"og...include/osg/Referenced(03): _refCount="<<_refCount <<std::endl;
        newRef = --_refCount;
        needDelete = newRef==0;
    }
    else
    {
        OSG_WARN<<"og...include/osg/Referenced(04): _refCount="<<_refCount <<std::endl;
        newRef = --_refCount;
        needDelete = newRef==0;
    }
#endif

    if (needDelete)
    {
        signalObserversAndDelete(true,true);//<----
    }
    return newRef;
}
```

地址: 0x47b7efc
osg::ref_ptr<osg::Node>::~ref_ptr() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/ref_ptr:61
```cpp
        ~ref_ptr() { 
            if (_ptr) 
                _ptr->unref();  //<----
            _ptr = 0; 
        }
```        