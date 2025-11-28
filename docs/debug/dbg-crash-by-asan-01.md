# 1.ERROR: AddressSanitizer: heap-use-after-free

## 1.1 callstacks
2025-11-20 15:34:26.137 28507-28507 DEBUG   pid-28507  A  pid: 28304, tid: 28304, name: ndroearth0vcpkg  >>> com.oearth.androearth0vcpkg <<<
2025-11-20 15:34:26.137 28507-28507 DEBUG   pid-28507  A  Abort message: '=================================================================
		==28304==ERROR: AddressSanitizer: heap-use-after-free on address 0x0056ee3f0218 at pc 0x007a334fe180 bp 0x007fc0811930 sp 0x007fc0811928
		READ of size 4 at 0x0056ee3f0218 thread T0 (ndroearth0vcpkg)

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


//===============================================
//===============================================
		0x0056ee3f0218 is located 24 bytes inside of 23040-byte region [0x0056ee3f0200,0x0056ee3f5c00)
		freed by thread T21 (GLThread 17) here:
 
#0 0x7b2f9f3ba4  (/data/app/~~d3K_sN68n6UQran2Bv1vcg==/com.oearth.androearth0vcpkg-DoOK1hnmeNdQjr8MgZHtCw==/lib/arm64/libclang_rt.asan-aarch64-android.so+0xf2ba4) (BuildId: d2089f24857cf6bfee934a5c1e8395bab0e414b6) 

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


===============================================

		SUMMARY: AddressSanitizer: heap-use-after-free (/data/app/~~d3K_sN68n6UQran2Bv1vcg==/com.oearth.androearth0vcpkg-DoOK1hnmeNdQjr8MgZHtCw==/lib/arm64/libandroioearth01.so+0x606917c) (BuildId: bb081a4b948d402247eaa20d9c1b8b3ea2a4dd3a) 
		Shadow bytes around the buggy address:
			0x0056ee3eff80: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
			0x0056ee3f0000: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
			0x0056ee3f0080: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
			0x0056ee3f0100: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
			0x0056ee3f0180: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
		=>0x0056ee3f0200: fd fd fd[fd]fd fd fd fd fd fd fd fd fd fd fd fd
			0x0056ee3f0280: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
			0x0056ee3f0300: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
			0x0056ee3f0380: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
			0x0056ee3f0400: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
			0x0056ee3f0480: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
		Shadow byte legend (one shadow byte represents 8 application bytes):
			Addressable:     00
			Partially addressable: 01 02 03 04 05 06 07 
			Heap left redzone:    fa
			Freed heap region:    fd
			Stack left redzone:   f1
			Stack mid redzone:    f2
			Stack right redzone:  f3
			Stack after return:   f5
			Stack use after scope:   f8
			Global redzone:    f9
			Global init order:    f6
			Poisoned by user:  f7
			Container overflow:   fc
			Array cookie:   ac
			Intra object redzone: bb
			ASan internal:     fe
			Left alloca redzone:  ca
			Right alloca redzone: cb
		'
2025-11-20 15:34:26.139 28507-28507 DEBUG   pid-28507  A  #01 pc 000000000006c5b4  /data/app/~~d3K_sN68n6UQran2Bv1vcg==/com.oearth.androearth0vcpkg-DoOK1hnmeNdQjr8MgZHtCw==/lib/arm64/libclang_rt.asan-aarch64-android.so (BuildId: d2089f24857cf6bfee934a5c1e8395bab0e414b6)
---------------------------- PROCESS ENDED (28304) for package com.oearth.androearth0vcpkg ----------------------------

从上面的信息是否可以判定：

地址: 0x5748a88
osg::Group::traverse(osg::NodeVisitor&) at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Group.cpp:63
```cpp
void Group::traverse(NodeVisitor& nv)
{
    for(NodeList::iterator itr=_children.begin();
        itr!=_children.end();
        ++itr)
    {
        (*itr)->accept(nv);//<-----_children里的node已经被销毁了
    }
}
```

## YuanbaoAI

**是的，您的判断是正确的！** 从完整的堆栈信息可以明确判定这是一个**多线程竞态条件**导致的 use-after-free 错误。

### 1. 错误原因确认

#### 1.1 多线程冲突时间线

**线程T0（主线程）** - 进行相交检测：
```
1. touchZoomEvent 触发
2. → EarthManipulator::recalculateCenterFromLookVector
3. → 执行相交检测，遍历场景图
4. → Group::traverse() 遍历子节点
5. → 访问 _children 中的节点（已被销毁）
```

**线程T21（GLThread 17）** - 释放资源：
```
1. 销毁 TileNode
2. → 销毁 SurfaceNode
3. → 销毁 Drawable
4. → 销毁 KdTree
5. → 释放 KdTree 节点内存
```

### 2. 问题根因分析

#### 2.1 关键问题代码
```cpp
// Group.cpp:63 - 问题代码
void Group::traverse(NodeVisitor& nv)
{
    for(NodeList::iterator itr = _children.begin();
        itr != _children.end();
        ++itr)
    {
        (*itr)->accept(nv);  // ❌ 这里访问了已被销毁的子节点
    }
}
```

#### 2.2 竞态条件的具体表现
- **主线程**正在遍历 `_children` 列表
- **GL线程**同时删除 `_children` 中的节点
- 没有同步机制保护这个遍历过程

### 3. 解决方案

#### 3.1 立即修复：添加遍历锁

修改 `osg/Group.cpp` 的 `traverse` 方法：

```cpp
// 修复版本1：添加读写锁
void Group::traverse(NodeVisitor& nv)
{
    // 添加遍历锁保护
    OpenThreads::ScopedReadLock lock(_traverseMutex);
    
    for(NodeList::iterator itr = _children.begin();
        itr != _children.end();
        ++itr)
    {
        // 在访问前检查节点是否仍然有效
        if (itr->valid()) {
            (*itr)->accept(nv);
        }
    }
}
```

#### 3.2 更安全的遍历实现

```cpp
// 修复版本2：复制子节点列表进行安全遍历
void Group::traverse(NodeVisitor& nv)
{
    // 创建子节点快照，避免遍历过程中被修改
    NodeList childrenSnapshot;
    {
        OpenThreads::ScopedReadLock lock(_childrenMutex);
        childrenSnapshot = _children;  // 复制列表
    }
    
    // 安全遍历快照
    for(NodeList::iterator itr = childrenSnapshot.begin();
        itr != childrenSnapshot.end();
        ++itr)
    {
        if (itr->valid()) {
            (*itr)->accept(nv);
        }
    }
}
```

#### 3.3 修改子节点管理

在 `Group` 类中添加线程安全的子节点操作：

```cpp
class Group : public Node {
public:
    // 线程安全的子节点操作
    void addChild(Node* child) {
        OpenThreads::ScopedWriteLock lock(_childrenMutex);
        _children.push_back(child);
    }
    
    void removeChild(Node* child) {
        OpenThreads::ScopedWriteLock lock(_childrenMutex);
        _children.erase(std::remove(_children.begin(), _children.end(), child), _children.end());
    }
    
    void safeTraverse(NodeVisitor& nv) {
        OpenThreads::ScopedReadLock lock(_childrenMutex);
        for(auto& child : _children) {
            if (child.valid()) child->accept(nv);
        }
    }

private:
    mutable OpenThreads::RWLock _childrenMutex;
};
```

### 4. 针对 OSG Earth 的特殊修复

#### 4.1 修改 TileNode 的遍历逻辑

```cpp
// 在 TileNode.cpp 中修复
void TileNode::traverse(NodeVisitor& nv)
{
    // 检查当前节点是否正在被销毁
    if (_isBeingDestroyed) {
        return;  // 跳过遍历
    }
    
    // 添加引用计数保护
    osg::ref_ptr<TileNode> self(this);
    
    // 安全遍历
    Group::traverse(nv);
}
```

#### 4.2 添加销毁标记

```cpp
class TileNode : public osg::Group {
public:
    void safeDestroy() {
        _isBeingDestroyed = true;
        // 延迟销毁逻辑
    }
    
protected:
    std::atomic<bool> _isBeingDestroyed{false};
};
```

### 5. 应用程序层面的修复

#### 5.1 在应用代码中添加同步

```cpp
// 在 OsgMainApp.cpp 中
void OsgMainApp::touchZoomEvent(double zoomFactor)
{
    // 添加全局场景锁
    OpenThreads::ScopedLock<OpenThreads::Mutex> lock(_sceneMutex);
    
    // 现在安全地进行相交检测
    _earthManipulator->recalculateCenterFromLookVector();
}
```

#### 5.2 修改渲染线程同步

```cpp
// 确保渲染线程不修改场景时进行相交检测
void OsgMainApp::draw()
{
    // 方法1：在渲染帧之间同步
    if (_needsIntersectionTest) {
        OpenThreads::ScopedLock<OpenThreads::Mutex> lock(_intersectionMutex);
        performIntersectionTest();
        _needsIntersectionTest = false;
    }
    
    // 正常渲染
    _viewer->frame();
}
```

### 6. 完整的修复补丁

#### 6.1 OSG 核心修复

创建 `Group_thread_safe.patch`：

```diff
--- a/src/osg/Group.cpp
+++ b/src/osg/Group.cpp
@@ -60,9 +60,15 @@
 
 void Group::traverse(NodeVisitor& nv)
 {
-    for(NodeList::iterator itr=_children.begin();
-        itr!=_children.end();
-        ++itr)
+    // 线程安全：创建子节点快照
+    NodeList childrenSnapshot;
+    {
+        OpenThreads::ScopedReadLock lock(_childrenMutex);
+        childrenSnapshot = _children;
+    }
+    
+    // 安全遍历快照
+    for(NodeList::iterator itr = childrenSnapshot.begin(); itr != childrenSnapshot.end(); ++itr)
     {
         if (itr->valid()) {
             (*itr)->accept(nv);
```

#### 6.2 添加必要的头文件和成员

```diff
--- a/include/osg/Group
+++ b/include/osg/Group
@@ -15,6 +15,7 @@
 #include <osg/CopyOp>
 #include <osg/Node>
 #include <osg/NodeVisitor>
+#include <OpenThreads/ScopedLock>
 
 namespace osg
 {
@@ -25,6 +26,9 @@
     public:
         Group();
         Group(const Group&, const CopyOp& copyop = CopyOp::SHALLOW_COPY);
+        
+        // 线程安全遍历
+        virtual void traverse(NodeVisitor& nv) override;
 
     protected:
         virtual ~Group();
@@ -32,6 +36,7 @@
     private:
         NodeList _children;
+        mutable OpenThreads::RWLock _childrenMutex;
 };
 
 } // namespace osg
```

### 7. 验证修复

#### 7.1 创建多线程测试

```cpp
// 压力测试：模拟多线程访问
void testThreadSafety()
{
    osg::ref_ptr<osg::Group> group = new osg::Group();
    
    // 添加一些子节点
    for (int i = 0; i < 100; ++i) {
        group->addChild(new osg::Node());
    }
    
    std::vector<std::thread> threads;
    
    // 线程1：不断遍历
    threads.emplace_back( {
        for (int i = 0; i < 1000; ++i) {
            osgUtil::IntersectionVisitor iv;
            group->accept(iv);
        }
    });
    
    // 线程2：修改子节点
    threads.emplace_back( {
        for (int i = 0; i < 500; ++i) {
            group->removeChild(0);
            group->addChild(new osg::Node());
        }
    });
    
    for (auto& t : threads) t.join();
}
```

#### 7.2 监控工具

添加调试信息监控竞态条件：

```cpp
void Group::traverse(NodeVisitor& nv)
{
    static std::atomic<int> traverseCount{0};
    int count = ++traverseCount;
    
    OSG_DEBUG << "Group traverse started: " << count << std::endl;
    
    // 安全遍历代码...
    
    OSG_DEBUG << "Group traverse completed: " << count << std::endl;
    --traverseCount;
}
```

### 8. 总结

**确认结论**：您的判断完全正确。这是一个典型的多线程竞态条件问题：

1. **根本原因**：`Group::traverse()` 在多线程环境下不安全
2. **冲突点**：主线程遍历子节点时，GL线程同时删除子节点
3. **解决方案**：添加适当的同步机制保护遍历过程

**推荐修复优先级**：
1. **立即**：应用 Group.cpp 的线程安全补丁
2. **短期**：在应用程序层面添加场景修改同步
3. **长期**：全面审查 OSG 的多线程安全性

这个修复应该能解决您遇到的 use-after-free 崩溃问题。


=================================================
# 2.节点 和group 都用 智能指针 管理了，为何还会有发生：主线程正在遍历 _children列表，而 GL线程同时删除 _children中的节点

**这是一个非常好的问题！** 即使使用智能指针，仍然会出现这种问题。让我详细解释其中的原因：

## 1. 智能指针保护的是对象生命周期，不是数据结构一致性

### 1.1 智能指针的作用范围
```cpp
class Group {
private:
    std::vector<osg::ref_ptr<Node>> _children;  // 智能指针保护节点对象
};
```

**智能指针保护的是**：
- ✅ **Node 对象不会被意外删除**（引用计数）
- ✅ **单个指针的读写是原子的**

**智能指针不保护的是**：
- ❌ **容器的结构一致性**（vector 的增删改）
- ❌ **迭代器的有效性**
- ❌ **遍历过程中的数据竞争**

## 2. 具体竞态条件分析

### 2.1 问题发生的详细时序

```cpp
// 线程A（主线程）：遍历
void Group::traverse() {
    for(auto it = _children.begin(); it != _children.end(); ++it) {
        // 时间点1：读取迭代器 it
        // 时间点2：解引用 (*it)
        // 时间点3：调用 accept()
        
        (*it)->accept(nv);  // 危险区域！
    }
}

// 线程B（GL线程）：删除
void Group::removeChild(Node* child) {
    auto it = std::find(_children.begin(), _children.end(), child);
    if (it != _children.end()) {
        _children.erase(it);  // 这会使得线程A的迭代器失效！
    }
}
```

### 2.2 即使使用智能指针也会崩溃的场景

```cpp
// 场景1：迭代器失效
线程A: it = _children.begin()     // 指向有效位置
线程B: _children.erase(some_it)   // 导致vector重新分配内存
线程A: ++it                       // 💥 访问无效内存

// 场景2：容器结构变化
线程A: 检查 it != _children.end()  // 通过检查
线程B: _children.clear()          // 清空容器
线程A: (*it)->accept()            // 💥 虽然智能指针有效，但容器结构已变

// 场景3：内存重新分配
线程A: 持有指向 _children[5] 的迭代器
线程B: _children.push_back(new_node) // 导致vector扩容
线程A: 访问迭代器                  // 💥 指向已释放的内存
```

## 3. 智能指针的局限性

### 3.1 引用计数的原子性 ≠ 线程安全

```cpp
// 智能指针的原子操作只保护引用计数本身
class ref_ptr {
    T* _ptr;
    std::atomic<int>* _refCount;  // 这个操作是原子的
    
    // 但是容器的结构修改不是原子的！
};
```

### 3.2 典型的错误认知

**错误理解**："智能指针是线程安全的，所以我的代码就是线程安全的"

**实际情况**：
```cpp
// 这个操作是"部分线程安全"的
osg::ref_ptr<Node> node = existingNode;  // 引用计数原子增加，安全

// 但这个操作完全不安全
_children.push_back(node);  // 修改vector，非原子，非线程安全
```

## 4. OSG 中具体的线程安全问题

### 4.1 Group 类的实际实现

查看 OSG 的 Group 实现：

```cpp
class Group : public Node {
protected:
    NodeList _children;  // 通常是 std::vector<ref_ptr<Node>>
    
public:
    void addChild(Node* child) {
        // 没有锁！
        _children.push_back(child);
    }
    
    void removeChild(Node* child) {
        // 没有锁！
        auto it = std::find(_children.begin(), _children.end(), child);
        if (it != _children.end()) {
            _children.erase(it);
        }
    }
    
    void traverse(NodeVisitor& nv) {
        // 没有锁！
        for(auto& child : _children) {
            child->accept(nv);  // 竞态条件发生处
        }
    }
};
```

### 4.2 您案例中的具体时序

从堆栈信息可以重建时间线：

```
时间点 | 主线程 (T0)                    | GL线程 (T21)
-------+-----------------------------+---------------------------
t0     | 开始遍历 _children           | 
t1     | 获取迭代器，指向有效的TileNode | 开始销毁TileNode
t2     | 检查 child.valid() == true   | 从_children中移除TileNode  
t3     | 准备调用 child->accept()     | 释放KdTree内存
t4     | 💥 调用accept()，但节点部分已释放 | 完成销毁
```

## 5. 为什么智能指针没有防止这个崩溃？

### 5.1 引用计数保护的是错误的东西

```cpp
// 崩溃发生时的情况：
osg::ref_ptr<Node> child = *it;  // 增加引用计数，节点对象安全

// 但是问题不在于节点对象被删除！
// 问题在于：节点内部状态在遍历过程中被修改了

// 比如：
class TileNode {
    osg::ref_ptr<osg::KdTree> _kdTree;  // 这个可能在遍历时被其他线程置为nullptr
};
```

### 5.2 智能指针保护的生命周期 vs 对象内部状态

```cpp
// 智能指针保证这个不会发生：
Node* node = getNode();
// 线程B: delete node;  // 被智能指针阻止

// 但无法阻止这个：
node->setSomeInternalState(null);  // 对象存活，但内部状态被修改
```

## 6. 正确的线程安全模型

### 6.1 需要多层次的保护

```cpp
class ThreadSafeGroup : public osg::Group {
public:
    void traverse(NodeVisitor& nv) override {
        // 层次1：保护容器结构
        std::shared_lock<std::shared_mutex> lock(_childrenMutex);
        
        // 创建快照（避免遍历过程中容器被修改）
        NodeList snapshot = _children;
        
        lock.unlock();  // 释放锁，允许其他线程修改容器
        
        // 层次2：保护单个节点的访问
        for(auto& child : snapshot) {
            if (child.valid()) {
                // 层次3：节点内部的线程安全
                child->safeAccept(nv);
            }
        }
    }
    
private:
    mutable std::shared_mutex _childrenMutex;
};
```

### 6.2 节点内部的线程安全

```cpp
class ThreadSafeNode : public osg::Node {
public:
    void safeAccept(NodeVisitor& nv) {
        std::lock_guard<std::mutex> lock(_internalMutex);
        accept(nv);
    }
    
    void setInternalState(SomeType* state) {
        std::lock_guard<std::mutex> lock(_internalMutex);
        _internalState = state;
    }

private:
    mutable std::mutex _internalMutex;
    osg::ref_ptr<SomeType> _internalState;
};
```

## 7. OSG 的设计哲学和局限性

### 7.1 OSG 的线程模型假设

OSG 默认采用**单线程修改，多线程读取**的模型：

```cpp
// 假设的应用场景：
void update() {
    // 只在更新线程中修改场景图
    group->addChild(newNode);
}

void traverse() {
    // 多个线程可以同时遍历（只读）
    group->accept(visitor);
}
```

但您的使用场景打破了这种假设：
- **GL线程**（通常应为只读）在修改场景图
- **主线程**同时在遍历场景图

### 7.2 解决方案：正确的线程边界

```cpp
// 方案1：所有场景图修改都在主线程
void onNodeNeedDelete(osg::Node* node) {
    // 将删除操作派发到主线程
    postToMainThread( {
        node->getParent(0)->removeChild(node);
    });
}

// 方案2：使用读写锁保护
class SafeGroup : public osg::Group {
    void traverse(NodeVisitor& nv) override {
        std::shared_lock lock(_rwMutex);
        osg::Group::traverse(nv);
    }
    
    void addChild(Node* child) override {
        std::unique_lock lock(_rwMutex);
        osg::Group::addChild(child);
    }
};
```

## 8. 在您案例中的具体修复

### 8.1 立即修复：添加遍历锁

```cpp
// 修改 Group::traverse
void Group::traverse(NodeVisitor& nv) {
    // 添加简单的互斥锁（性能较差但安全）
    static std::mutex traverseMutex;
    std::lock_guard<std::mutex> lock(traverseMutex);
    
    for(auto& child : _children) {
        if (child.valid()) {
            child->accept(nv);
        }
    }
}
```

### 8.2 更好的修复：读写锁 + 快照

```cpp
void Group::traverse(NodeVisitor& nv) {
    // 创建子节点快照
    NodeList childrenSnapshot;
    {
        std::shared_lock<std::shared_mutex> lock(_childrenMutex);
        childrenSnapshot = _children;  // 复制（注意性能开销）
    }
    
    // 安全遍历快照
    for(auto& child : childrenSnapshot) {
        if (child.valid()) {
            child->accept(nv);
        }
    }
}
```

## 9. 总结

**根本问题**：智能指针只保护**对象生命周期**，不保护**数据结构的并发访问一致性**。

**关键区别**：
- ✅ **智能指针**：防止对象被意外删除（引用计数）
- ❌ **容器同步**：防止并发修改导致的结构不一致（需要锁）

**在您案例中**：
- 智能指针确保了 `TileNode` 对象本身不会被删除
- 但没有保护 `Group::_children` 这个 vector 的并发访问
- 也没有保护 `TileNode` 内部状态（如 KdTree）的并发修改

**解决方案**：需要在容器访问和节点内部状态访问两个层面都添加适当的同步机制。

=============================================================================
# 3.从堆栈来看，TileNode也是用 osg::ref_ptr来管理的，为何 会在住线程中被使用的情况下， 被渲染线程删除？TileNode是单独的一个，不是放到 children里的

**您观察得非常准确！** 这个问题确实很奇怪。如果 `TileNode` 是用 `osg::ref_ptr` 单独管理的，不应该在还有引用的情况下被删除。让我深入分析这个特殊情况。

## 1. 分析 TileNode 的生命周期管理

### 1.1 从堆栈看 TileNode 的引用管理

```cpp
// 从堆栈看，TileNode 确实通过 ref_ptr 管理
地址: 0x538cc38
osg::ref_ptr<osgEarth::REX::SurfaceNode>::~ref_ptr()

地址: 0x538ce80
osgEarth::REX::TileNode::~TileNode()
```

### 1.2 可能的竞态条件场景

```cpp
// 场景1：引用计数操作非原子（在旧版本OSG中可能）
class Referenced {
    int _refCount;  // 非原子操作！
public:
    int unref() const {
        // 在多线程环境下，这可能导致竞态条件
        int newRef = --_refCount;  // 💥 非原子操作
        if (newRef == 0) delete this;
        return newRef;
    }
};
```

## 2. 深入分析引用计数问题

### 2.1 OSG 引用计数的线程安全性

检查您环境中 OSG 的引用计数实现：

```cpp
// 检查 osg/Referenced.cpp 中的实现
#ifdef _OSG_REFERENCED_USE_ATOMIC_OPERATIONS
    // 使用原子操作
    std::atomic<int> _refCount;
#else
    // 非原子操作
    int _refCount;
    mutable OpenThreads::Mutex* _refMutex;
#endif
```

### 2.2 可能的引用计数竞态条件

```cpp
// 线程A（主线程）：增加引用
void threadA() {
    ref_ptr<TileNode> node = existingNode;  // refCount++
    // 此时 refCount = 2
    node->accept(visitor);  // 使用节点
}

// 线程B（GL线程）：减少引用  
void threadB() {
    ref_ptr<TileNode> node = existingNode;  // 临时引用
    node = nullptr;  // refCount--
    // 如果竞态条件发生，可能导致 refCount 错误地变为 0
}
```

## 3. 检查具体的堆栈信息

### 3.1 分析销毁堆栈

从您的堆栈看，销毁路径是：

```
1. SurfaceNode 的 ref_ptr 析构
2. → TileNode 析构  
3. → KdTree 析构
4. → 内存释放
```

**关键问题**：为什么 `SurfaceNode` 的 `ref_ptr` 会在主线程使用 `TileNode` 时被析构？

### 3.2 可能的解释：父节点删除导致的级联删除

```cpp
// 场景：父节点被删除，导致子节点被删除
void someFunction() {
    // 线程B：删除包含 TileNode 的父节点
    ref_ptr<Group> parentGroup = findParentGroup();
    parentGroup->removeChild(tileNode);  // 移除子节点
    
    // 如果 tileNode 没有其他引用，它会被立即删除
    // 即使主线程正在使用它！
}
```

## 4. 检查 OSG 的特定配置

### 4.1 检查原子操作支持

```cpp
// 在您的构建配置中检查
#include <osg/Config>

void checkAtomicSupport() {
    #ifdef _OSG_REFERENCED_USE_ATOMIC_OPERATIONS
        std::cout << "使用原子引用计数" << std::endl;
    #else
        std::cout << "使用互斥锁保护引用计数" << std::endl;
    #endif
        
    #ifdef _OSG_REFERENCED_USE_ATOMIC_OPERATIONS
        std::cout << "引用计数类型: atomic<int>" << std::endl;
    #else
        std::cout << "引用计数类型: int" << std::endl;
    #endif
}
```

### 4.2 Android NDK 的原子操作问题

在某些 Android 架构上，原子操作可能有兼容性问题：

```cpp
// 测试原子操作的可靠性
void testAtomicOperations() {
    std::atomic<int> counter{1};
    
    // 模拟竞态条件
    bool success = counter.compare_exchange_strong(1, 0);
    if (!success) {
        std::cerr << "原子操作失败！" << std::endl;
    }
}
```

## 5. 具体的竞态条件分析

### 5.1 重现时间线

基于堆栈信息，重建确切的竞态条件：

```
时间点 | 主线程 (使用TileNode)          | GL线程 (删除TileNode)
-------+---------------------------------+--------------------------------
t0     | ref_ptr<TileNode> node = tileNode; | 
t1     | node->accept(visitor);         | parent->removeChild(tileNode);
t2     | 进入TileNode::traverse()       | tileNode->unref(); // 引用计数减1
t3     | 访问KdTree                     | 检查refCount==0 ? 
t4     | 💥 使用已释放的KdTree          | 删除TileNode（如果refCount==0）
```

### 5.2 关键问题：引用计数检查的时机

```cpp
// 问题可能出现在这里：
int Referenced::unref() const {
    int newRef = --_refCount;  // 非原子或原子但时机不对
    
    // 检查时机问题：在减少后立即检查
    if (newRef == 0) {         // 💥 可能错误判断
        delete this;
    }
    return newRef;
}
```

## 6. 验证和诊断方案

### 6.1 添加详细的引用计数日志

```cpp
// 修改 osg/Referenced.cpp 添加调试
int Referenced::ref() const {
    int oldCount;
#ifdef _OSG_REFERENCED_USE_ATOMIC_OPERATIONS
    oldCount = ++_refCount;
#else
    if (_refMutex) {
        OpenThreads::ScopedLock<OpenThreads::Mutex> lock(*_refMutex);
        oldCount = ++_refCount;
    } else {
        oldCount = ++_refCount;
    }
#endif
    
    // 添加调试信息
    OSG_WARN << "引用增加: " << this << " 线程: " << OpenThreads::Thread::CurrentThread() 
             << " 旧计数: " << (oldCount-1) << " 新计数: " << oldCount << std::endl;
    
    return oldCount;
}

int Referenced::unref() const {
    int newRef;
#ifdef _OSG_REFERENCED_USE_ATOMIC_OPERATIONS
    newRef = --_refCount;
#else
    if (_refMutex) {
        OpenThreads::ScopedLock<OpenThreads::Mutex> lock(*_refMutex);
        newRef = --_refCount;
    } else {
        newRef = --_refCount;
    }
#endif
    
    OSG_WARN << "引用减少: " << this << " 线程: " << OpenThreads::Thread::CurrentThread() 
             << " 新计数: " << newRef << std::endl;
    
    if (newRef == 0) {
        OSG_WARN << "删除对象: " << this << " 类型: " << typeid(*this).name() << std::endl;
        delete this;
    }
    
    return newRef;
}
```

### 6.2 创建最小复现测试

```cpp
// 测试引用计数的线程安全性
void testRefCountThreadSafety() {
    osg::ref_ptr<osg::Node> node = new osg::Node;
    
    std::vector<std::thread> threads;
    const int NUM_THREADS = 10;
    const int OPERATIONS_PER_THREAD = 1000;
    
    for (int i = 0; i < NUM_THREADS; ++i) {
        threads.emplace_back( {
            for (int j = 0; j < OPERATIONS_PER_THREAD; ++j) {
                // 模拟竞态条件
                osg::ref_ptr<osg::Node> localRef = node;  // 增加引用
                // 做一些操作
                std::this_thread::sleep_for(std::chrono::microseconds(1));
                // localRef 析构，减少引用
            }
        });
    }
    
    for (auto& t : threads) t.join();
    
    // 最终引用计数应该是1（初始引用）
    std::cout << "最终引用计数: " << node->referenceCount() << std::endl;
}
```

## 7. 具体的修复方案

### 7.1 修复引用计数的原子性

如果检测到原子操作问题：

```cpp
// 强制使用互斥锁保护的引用计数
class ThreadSafeReferenced : public osg::Referenced {
protected:
    virtual ~ThreadSafeReferenced() {}
    
    int ref() const override {
        OpenThreads::ScopedLock<OpenThreads::Mutex> lock(_refMutex);
        return ++_refCount;
    }
    
    int unref() const override {
        OpenThreads::ScopedLock<OpenThreads::Mutex> lock(_refMutex);
        int newRef = --_refCount;
        if (newRef == 0) {
            delete this;
        }
        return newRef;
    }
    
private:
    mutable OpenThreads::Mutex _refMutex;
    int _refCount{0};
};
```

### 7.2 修复 TileNode 的使用模式

```cpp
// 确保在使用 TileNode 期间保持强引用
class SafeTileNodeUser {
public:
    void safeUseTileNode(osg::ref_ptr<osgEarth::REX::TileNode> tileNode) {
        // 在方法开始时增加引用计数
        osg::ref_ptr<osgEarth::REX::TileNode> strongRef = tileNode;
        
        // 现在安全地使用
        if (strongRef.valid()) {
            strongRef->accept(visitor);
        }
        
        // strongRef 析构时自动减少引用计数
    }
};
```

### 7.3 检查编译选项

确保正确的编译选项：

```cmake
# 在 CMakeLists.txt 中
if(ANDROID)
    # 强制使用原子操作
    add_definitions(-D_OSG_REFERENCED_USE_ATOMIC_OPERATIONS)
    
    # 确保 C++11 原子支持
    set(CMAKE_CXX_STANDARD 11)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    
    # 链接原子库（如果需要）
    if(ANDROID_ABI STREQUAL "armeabi-v7a")
        target_link_libraries(your_target atomic)
    endif()
endif()
```

## 8. 根本原因诊断步骤

### 8.1 立即诊断

```bash
# 检查 OSG 的编译配置
grep -r "REFERENCED_USE_ATOMIC" /path/to/osg/headers/

# 检查原子操作支持
echo | aarch64-linux-android-clang++ -dM -E -x c++ - | grep -i atomic
```

### 8.2 运行时检查

```cpp
// 在应用程序启动时检查
void checkEnvironment() {
    std::cout << "原子操作支持检查:" << std::endl;
    std::cout << "atomic<int> 是否无锁: " << std::atomic<int>{}.is_lock_free() << std::endl;
    std::cout << "atomic<void*> 是否无锁: " << std::atomic<void*>{}.is_lock_free() << std::endl;
    
    #ifdef __ATOMIC_RELAXED
    std::cout << "编译器支持 __ATOMIC_RELAXED" << std::endl;
    #endif
    
    #ifdef _OSG_REFERENCED_USE_ATOMIC_OPERATIONS
    std::cout << "OSG 使用原子引用计数" << std::endl;
    #else
    std::cout << "OSG 使用互斥锁引用计数" << std::endl;
    #endif
}
```

## 9. 总结

**最可能的原因**：

1. **引用计数的非原子操作**：在您的构建配置中，OSG 可能没有使用原子操作保护引用计数
2. **Android NDK 的原子操作兼容性问题**：某些 Android 架构上的原子操作实现有问题
3. **竞态条件时机**：引用计数减少和检查 `== 0` 之间存在竞态条件窗口

**推荐诊断步骤**：

1. **立即**：检查 OSG 的 `_OSG_REFERENCED_USE_ATOMIC_OPERATIONS` 定义
2. **验证**：添加引用计数调试日志，重现问题
3. **修复**：如果原子操作有问题，强制使用互斥锁保护

这个问题的根本原因很可能是 OSG 在您的 Android 构建配置中没有正确启用原子引用计数操作。

================================================================
# 4. 释放内存的线程的堆栈，可以看出线程堆栈并不完整，请问原因是什么，是否可以输出完整的线程堆栈

 下面是释放内存的线程的堆栈，可以看出线程堆栈并不完整，请问原因是什么，是否可以输出完整的线程堆栈
```		
0x0056ee3f0218 is located 24 bytes inside of 23040-byte region [0x0056ee3f0200,0x0056ee3f5c00)
		freed by thread T21 (GLThread 17) here: 
#0 0x7b2f9f3ba4  (/data/app/~~d3K_sN68n6UQran2Bv1vcg==/com.oearth.androearth0vcpkg-DoOK1hnmeNdQjr8MgZHtCw==/lib/arm64/libclang_rt.asan-aarch64-android.so+0xf2ba4) (BuildId: d2089f24857cf6bfee934a5c1e8395bab0e414b6) 
地址: 0x46ea088 void std::__ndk1::__libcpp_operator_delete[abi:ne180000]<void*>(void*) at /home/abner/Android/Sdk/ndk/27.0.12077973/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/new:280
地址: 0x46ea038 void std::__ndk1::__do_deallocate_handle_size[abi:ne180000]<>(void*, unsigned long) at /home/abner/Android/Sdk/ndk/27.0.12077973/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/new:302
地址: 0x46e9fdc std::__ndk1::__libcpp_deallocate[abi:ne180000](void*, unsigned long, unsigned long) at /home/abner/Android/Sdk/ndk/27.0.12077973/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/new:317
地址: 0x579c6d0 std::__ndk1::allocator<osg::KdTree::KdNode>::deallocate[abi:ne180000](osg::KdTree::KdNode*, unsigned long) at /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/__memory/allocator.h:131
地址: 0x579c150 std::__ndk1::allocator_traits<std::__ndk1::allocator<osg::KdTree::KdNode>>::deallocate[abi:ne180000](std::__ndk1::allocator<osg::KdTree::KdNode>&, osg::KdTree::KdNode*, unsigned long) at /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/__memory/allocator_traits.h:289
地址: 0x579cccc  std::__ndk1::vector<osg::KdTree::KdNode, std::__ndk1::allocator<osg::KdTree::KdNode>>::__destroy_vector::operator()[abi:ne180000]() at /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/vector:492
地址: 0x579ca30  std::__ndk1::vector<osg::KdTree::KdNode, std::__ndk1::allocator<osg::KdTree::KdNode>>::~vector[abi:ne180000]() at /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/vector:501
地址: 0x57967b4 osg::KdTree::~KdTree() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/KdTree:26
地址: 0x5796808  osg::KdTree::~KdTree() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/KdTree:26
地址: 0x58cc7a8  osg::Referenced::unref() const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:348
地址: 0x56373a4  osg::ref_ptr<osg::Shape>::~ref_ptr() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/include/osg/ref_ptr:61
地址: 0x56380a4  osg::Drawable::~Drawable() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Drawable.cpp:281
地址: 0x5385db4  osgEarth::REX::TileDrawable::~TileDrawable() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/TileDrawable.cpp:73
地址: 0x58cc430 osg::Referenced::signalObserversAndDelete(bool, bool) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:292
地址: 0x58cc7a8  osg::Referenced::unref() const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:348
地址: 0x4966668 osg::ref_ptr<osg::Node>::~ref_ptr() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/ref_ptr:61
地址: 0x5748448  std::__ndk1::vector<osg::ref_ptr<osg::Node>, std::__ndk1::allocator<osg::ref_ptr<osg::Node>>>::~vector[abi:ne180000]() at /home/abner/Android/Sdk/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1/vector:501

地址: 0x574873c  osg::Group::~Group() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Group.cpp:54
地址: 0x5a9caf0  osg::Transform::~Transform() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Transform.cpp:143
地址: 0x57f9b44  osg::MatrixTransform::~MatrixTransform() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/MatrixTransform.cpp:41
地址: 0x535cc88  osgEarth::REX::SurfaceNode::~SurfaceNode() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/SurfaceNode:27
地址: 0x58cc430  osg::Referenced::signalObserversAndDelete(bool, bool) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:292
地址: 0x58cc7a8  osg::Referenced::unref() const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:348
地址: 0x538cc38  osg::ref_ptr<osgEarth::REX::SurfaceNode>::~ref_ptr() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/ref_ptr:61
地址: 0x538ce80 osgEarth::REX::TileNode::~TileNode() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osgearth/src/osgEarthDrivers/engine_rex/TileNode.cpp:81
地址: 0x58cc430 osg::Referenced::signalObserversAndDelete(bool, bool) const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:292
地址: 0x58cc7a8  osg::Referenced::unref() const at /home/abner/abner2/zdev/nv/osgearth0vcpkg/3rd/osg/src/osg/Referenced.cpp:348
地址: 0x47b7efc  osg::ref_ptr<osg::Node>::~ref_ptr() at /home/abner/abner2/zdev/nv/osgearth0vcpkg/build_sh/install/android-asan/3rd/osg/arm64-v8a/include/osg/ref_ptr:61
```  

**是的，您观察得非常准确！这个线程堆栈确实不完整。** 让我分析原因并提供获取完整堆栈的方法。

## 1. 堆栈不完整的原因分析

### 1.1 常见的不完整堆栈原因

```cpp
// 1. 编译器优化导致堆栈帧被优化掉
// 使用 -fomit-frame-pointer 或 -O2 及以上优化级别
void someFunction() {
    // 内联或尾部调用优化可能省略堆栈帧
}

// 2. 信号处理期间的堆栈损坏
void signalHandler(int sig) {
    // 在信号处理函数中，堆栈可能不完整
    printStackTrace(); // 可能得到不完整的堆栈
}

// 3. AddressSanitizer 本身的限制
// ASan 可能在某些情况下无法完整展开堆栈
```

### 1.2 在您案例中的具体原因

从堆栈信息看，问题可能包括：

1. **尾部调用优化**：某些函数调用被优化为跳转，没有新堆栈帧
2. **内联函数**：小函数被内联，没有独立的堆栈帧
3. **Android NDK 的栈展开限制**：在 ARM64 架构上的栈展开可能不完美

## 2. 获取完整堆栈的方法

### 2.1 修改编译选项禁用优化

```cmake
# 在 CMakeLists.txt 中针对调试构建修改优化选项
if(CMAKE_BUILD_TYPE STREQUAL "Debug" OR ASAN_ENABLED)
    # 禁用帧指针省略
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer")
    
    # 禁用尾部调用优化
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-optimize-sibling-calls")
    
    # 减少内联
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-inline -fno-inline-small-functions")
    
    # 确保调试信息完整
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -fno-eliminate-unused-debug-types")
endif()
```

### 2.2 增强 AddressSanitizer 的堆栈跟踪

```bash
# 设置更详细的 ASan 选项
export ASAN_OPTIONS="malloc_context_size=30:fast_unwind_on_malloc=0:verbosity=2"
export ASAN_SYMBOLIZER_PATH=$(which llvm-symbolizer)

# 在代码中强制更详细的堆栈
extern "C" {
    void __sanitizer_print_stack_trace(void);
}

// 在关键点手动打印堆栈
void debugStackTrace() {
    __sanitizer_print_stack_trace();
}
```

### 2.3 添加手动堆栈跟踪

在关键函数中添加堆栈打印：

```cpp
#include <execinfo.h>
#include <cxxabi.h>

void printStackTrace(int max_frames = 63) {
    void* addrlist[max_frames+1];
    
    // 获取堆栈帧地址
    int addrlen = backtrace(addrlist, sizeof(addrlist) / sizeof(void*));
    
    if (addrlen == 0) {
        OSG_WARN << "堆栈为空" << std::endl;
        return;
    }
    
    // 解析符号
    char** symbollist = backtrace_symbols(addrlist, addrlen);
    
    // 打印堆栈
    for (int i = 0; i < addrlen; i++) {
        OSG_WARN << "[" << i << "] " << symbollist[i] << std::endl;
    }
    
    free(symbollist);
}

// 在 Referenced::unref 中添加堆栈跟踪
int Referenced::unref() const {
    // ... 原有代码 ...
    
    if (needDelete) {
        OSG_WARN << "=== 对象将被删除，堆栈跟踪 ===" << std::endl;
        printStackTrace();
        signalObserversAndDelete(true, true);
    }
    
    return newRef;
}
```

## 3. 修复不完整堆栈的具体步骤

### 3.1 修改 Android NDK 构建配置

```cmake
# 针对 Android ASan 构建的特殊配置
if(ANDROID AND ENABLE_ASAN)
    # 确保完整的调试信息
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-omit-frame-pointer")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-optimize-sibling-calls")
    
    # 针对 ARM64 的特定设置
    if(ANDROID_ABI STREQUAL "arm64-v8a")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-frame-address")
    endif()
    
    # 确保展开表信息
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--export-dynamic")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--export-dynamic")
endif()
```

### 3.2 增强 OSG 的调试输出

```cpp
// 修改 osg/Referenced.cpp 添加详细跟踪
int Referenced::unref() const {
    static std::atomic<int> unrefCounter{0};
    int counter = ++unrefCounter;
    
    OSG_WARN << "[" << counter << "] unref() 开始: " << this 
             << " 类型: " << typeid(*this).name() 
             << " 线程: " << OpenThreads::Thread::CurrentThread() << std::endl;
    
    int newRef;
#if defined(_OSG_REFERENCED_USE_ATOMIC_OPERATIONS)
    newRef = --_refCount;
    bool needDelete = (newRef == 0);
#else
    // ... 原有代码 ...
#endif

    if (needDelete) {
        OSG_WARN << "[" << counter << "] 准备删除对象: " << this 
                 << " 引用计数: " << newRef << std::endl;
        
        // 打印删除堆栈
        printStackTrace();
        
        signalObserversAndDelete(true, true);
    }
    
    OSG_WARN << "[" << counter << "] unref() 结束: " << this 
             << " 新引用计数: " << newRef << std::endl;
    
    return newRef;
}
```

### 3.3 使用 GDB 调试符号

```bash
# 构建时包含完整调试信息
./gradlew assembleDebug --debug-jvm

# 使用 gdb 获取完整堆栈
aarch64-linux-android-gdb libandroioearth01.so
(gdb) set solib-search-path ./obj/local/arm64-v8a
(gdb) thread apply all bt full

# 或者使用 addr2line 解析地址
aarch64-linux-android-addr2line -e libandroioearth01.so -f -C 0x57967b4
```

## 4. 创建自定义堆栈跟踪工具

### 4.1 Android 专用的堆栈跟踪类

```cpp
// AndroidStackTracer.h
#pragma once
#include <unwind.h>
#include <dlfcn.h>
#include <cxxabi.h>
#include <sstream>
#include <osg/Notify>

class AndroidStackTracer {
private:
    struct StackTraceInfo {
        void** buffer;
        int max_frames;
        int frame_count;
    };

    static _Unwind_Reason_Code unwindCallback(struct _Unwind_Context* context, void* arg) {
        StackTraceInfo* info = static_cast<StackTraceInfo*>(arg);
        
        if (info->frame_count >= info->max_frames) {
            return _URC_END_OF_STACK;
        }
        
        void* ip = (void*)_Unwind_GetIP(context);
        if (ip) {
            info->buffer[info->frame_count++] = ip;
        }
        
        return _URC_NO_REASON;
    }

public:
    static std::string getStackTrace(int max_frames = 50) {
        void* buffer[max_frames];
        StackTraceInfo info = {buffer, max_frames, 0};
        
        _Unwind_Backtrace(unwindCallback, &info);
        
        std::ostringstream oss;
        for (int i = 0; i < info.frame_count; i++) {
            Dl_info dl_info;
            if (dladdr(buffer[i], &dl_info) && dl_info.dli_sname) {
                int status;
                char* demangled = abi::__cxa_demangle(dl_info.dli_sname, nullptr, nullptr, &status);
                oss << "[" << i << "] " << buffer[i] << " : " 
                    << (demangled ? demangled : dl_info.dli_sname) << std::endl;
                if (demangled) free(demangled);
            } else {
                oss << "[" << i << "] " << buffer[i] << " : <unknown>" << std::endl;
            }
        }
        
        return oss.str();
    }
};
```

### 4.2 在关键位置插入堆栈跟踪

```cpp
// 在销毁路径的关键点添加
TileNode::~TileNode() {
    OSG_WARN << "TileNode 析构开始: " << this << std::endl;
    OSG_WARN << AndroidStackTracer::getStackTrace();
    // ... 原有代码
}

KdTree::~KdTree() {
    OSG_WARN << "KdTree 析构开始: " << this << std::endl;
    OSG_WARN << AndroidStackTracer::getStackTrace();
    // ... 原有代码
}
```

## 5. 使用 Linux 内核特性增强堆栈跟踪

### 5.1 启用内核堆栈跟踪

```bash
# 在设备上启用更好的堆栈跟踪
adb shell echo 8 > /proc/sys/kernel/printk
adb shell echo 1 > /proc/sys/kernel/kptr_restrict

# 设置 ASan 选项以获得更好堆栈
adb shell setprop debug.asan.options malloc_context_size=30:fast_unwind_on_malloc=0
```

### 5.2 创建堆栈跟踪脚本

```bash
#!/bin/bash
# stack_trace_helper.sh

# 从 logcat 提取 ASan 报告并符号化
adb logcat -d | grep -A 100 -B 10 "AddressSanitizer" > asan_report.txt

# 提取地址并符号化
grep -o "0x[0-9a-f]*" asan_report.txt | while read addr; do
    if [ ! -z "$addr" ]; then
        echo "符号化地址: $addr"
        aarch64-linux-android-addr2line -e libandroioearth01.so -f -C $addr
        echo "---"
    fi
done
```

## 6. 分析您的不完整堆栈

### 6.1 从现有堆栈推断完整调用链

虽然堆栈不完整，但我们可以推断出完整的销毁路径：

```
推测的完整调用链：
1. 某个GL线程函数
2. → 删除父节点或场景图部分
3. → Group::~Group() 删除子节点
4. → vector<ref_ptr<Node>>::~vector() 析构子节点列表
5. → ref_ptr<Node>::~ref_ptr() 减少引用
6. → Referenced::unref() 检查引用计数
7. → [缺失的调用帧] 决定删除TileNode
8. → TileNode::~TileNode()
9. → SurfaceNode::~SurfaceNode() 
10. → ... [您提供的堆栈从这里开始]
```

### 6.2 修复缺失的调用帧

在可能缺失调用帧的地方添加日志：

```cpp
// 在Group的析构函数中添加
Group::~Group() {
    OSG_WARN << "Group 析构: " << this << " 子节点数: " << _children.size() << std::endl;
    
    // 记录每个子节点的销毁
    for (size_t i = 0; i < _children.size(); ++i) {
        if (_children[i].valid()) {
            OSG_WARN << "删除子节点[" << i << "]: " << _children[i].get() 
                     << " 类型: " << typeid(*_children[i].get()).name() << std::endl;
        }
    }
    
    // ... 原有代码
}
```

## 7. 最终解决方案：获取完整堆栈

### 7.1 完整的构建配置修复

```cmake
# 最终修复的 CMake 配置
set(CMAKE_CXX_FLAGS_DEBUG 
    "${CMAKE_CXX_FLAGS_DEBUG} 
    -fno-omit-frame-pointer 
    -fno-optimize-sibling-calls 
    -fno-inline 
    -fno-inline-small-functions 
    -fno-inline-functions 
    -g 
    -fno-eliminate-unused-debug-types"
)

# 链接器标志确保调试信息
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} -Wl,--export-dynamic")
set(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG} -Wl,--export-dynamic")

# ASan 特定设置
if(ENABLE_ASAN)
    set(ASAN_FLAGS "-fsanitize=address -fsanitize-address-use-after-scope")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ASAN_FLAGS}")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${ASAN_FLAGS}")
endif()
```

### 7.2 运行时的完整诊断命令

```bash
# 清理并重新构建
make clean
make -j$(nproc)  # 使用修复后的配置

# 运行带有完整诊断的测试
adb shell setprop debug.asan.options malloc_context_size=50:fast_unwind_on_malloc=0:verbosity=2
adb shell setprop log.tag.AddressSanitizer DEBUG

# 运行应用并捕获完整日志
adb logcat -c
adb shell am start -n com.oearth.androearth0vcpkg/.MainActivity
adb logcat | grep -A 200 -B 20 "AddressSanitizer"
```

## 8. 总结

**堆栈不完整的原因**：
1. **编译器优化**（尾部调用、内联）
2. **Android NDK 的栈展开限制**
3. **ASan 报告截断**

**获取完整堆栈的方法**：
1. **禁用优化**：`-fno-omit-frame-pointer` 等
2. **增强 ASan 配置**：增加堆栈深度，禁用快速展开
3. **手动堆栈跟踪**：在关键点添加自定义堆栈打印
4. **符号化工具**：使用 `addr2line` 解析地址

按照上述方法配置后，您应该能够获得完整的堆栈跟踪，从而准确定位导致 KdTree 被删除的根本原因。