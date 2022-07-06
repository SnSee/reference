# 插件流程梳理

插件机制核心原理:

```text
创建虚基类，并在业务代码中通过基类指针调用虚函数;
在插件中继承虚基类并重写虚函数；
把插件打包成动态库；
根据插件名称加载动态库并通过约定的函数名称获取插件对象；
将插件对象赋值给业务代码中使用的基类指针。
```

以RegionQuery插件为例分析golden的插件流程。

----

## 1. 用户流程

### 1.1 加载插件

一般会提供一个静态成员函数供用户调用用来初始化，如:

```cpp
static void init(const oaString &plugInName);
```

[oaRegionQuery::init](#31-初始化)

### 1.2 初始化数据表

```cpp
void initForRegionQuery(oaUInt4 index, oaBoolean updateUsedIn=true) const;
```

用户可手动调用[oaBlock::initForRegionQuery](#initForRegionQuery)初始化，否则后续查询时自动调用

### 1.3 业务逻辑

做一些和插件相关的操作。

### 1.4 查询

```cpp
// 创建查询对象
oaShapeQuery sq;
sq.query(...);
sq.getLayerNum()
```

[详细查询流程](#34-查询操作)

## 2. 插件流程

### 2.1 继承插件基类

插件工厂，用于创建相关对象

```cpp
class oaXYTreePlugMgr : public PlugInBase<IRegionQueryPlugMgr> {
public:
    static  IFactory            *getFactory();
private:
    virtual void                getName(oaString &name);
    virtual oaRegionQueryPlug   *createPlug(oaBlockTbl  *blkTbl,
                                            oaUInt4     blkIndex,
                                            const oaBox &initialBBox);
    virtual oaShapeQueryPvt     *createShapeQuery(oaShapeQuery *queryIn);
    static Factory<oaXYTreePlugMgr> factory;

    friend class oaBlockTbl;
    friend class oaXYTreePlug;
};
```

<a id="工作插件">实际工作的插件，在[initForRegionQuery](#initForRegionQuery)中实例化</a>

```cpp
class oaXYTreePlug : public oaRegionQueryPlug {
public:
    virtual void    addShape(oaShapeTbl *tbl, oaUInt4 index, oaBoolean bulk=false);
protected:
    oaBlockTbl              *blkTbl;
    oaUInt4                 blkIndex;
    oaArray<oaXYObjTree<oaShapeTbl>*> shapeTrees;
};
```

<a id="查询插件">实际查询类，被封装在[oaShapeQuery](#oaShapeQuery)中</a>

```cpp
class oaXYShapeQueryPvt : public oaShapeQueryPvt {
public:
                            oaXYShapeQueryPvt(oaShapeQuery *queryIn);

    virtual void            processDesign(oaDesignData *dsData);
};

class oaShapeQueryPvt : public oaRegionQueryPvt {
public:
    // 获取查询结果
    oaLayerNum getLayerNum() const;
    // 生成查询结果
    void produce(oaDesignData    *topDesignDataIn,
                 oaLayerNum      layerNumIn,
                 oaPurposeNum    purposeNumIn,
                 const oaBox     &regionIn,
                 oaUInt4         filterSize = 0,
                 oaUInt4         startLevel = 0,
                 oaUInt4         stopLevel = 100);
protected:
    oaLayerNum              layerNum;
};
```

### 2.2 重写虚函数

<a id="插件添加逻辑">重写添加逻辑</a>

```cpp
// 记录数据
void oaXYTreePlug::addShape(oaShapeTbl *tbl, oaUInt4 index, oaBoolean bulk) {
    oaUInt4 index = tbl->getLPPHeader(index);
    oaUInt4 numObj = oaLPPHeaderTbl::get(tbl->getDesignData())->getNumShapes(index);
    shapeTrees[index] = new oaXYObjTree<oaShapeTbl>(tbl, numObj);
}
```

<a id="插件查询逻辑">重写查询逻辑</a>

```cpp
// 生成查询数据
void oaShapeQueryPvt::produce(oaDesignData   *topDesignDataIn,
                              oaLayerNum     layerNumIn,
                              oaPurposeNum   purposeNumIn,
                              const oaBox    &regionIn,
                              oaUInt4        filterSizeIn,
                              oaUInt4        startLevelIn,
                              oaUInt4        stopLevelIn) {
    layerNum = layerNumIn;
    oaRegionQueryPvt::produce(
        topDesignDataIn, regionIn, filterSizeIn, startLevelIn, stopLevelIn
    );
}
```

[oaRegionQueryPvt::produce](#oaRegionQueryPvt::produce)

[调用位置](#34-查询操作)

<a id="oaXYShapeQueryPvt::processDesign">重写处理逻辑</a>

```cpp
void oaXYShapeQueryPvt::processDesign(oaDesignData *dsData) {
    oaBlockTbl      *blkTbl = oaBlockTbl::get(dsData);
    oaUInt4         bIndex = blkTbl->getTop();
    oaXYTreePlug    *plug = (oaXYTreePlug*) blkTbl->getRegionQueryPlug(bIndex);
    oaXYObjTree<oaShapeTbl> *tree = NULL;
    oaLPPHeaderTbl  *lppTbl = oaLPPHeaderTbl::get(dsData);
    oaUInt4         lppIndex = lppTbl->find(layerNum, purposeNum);
    plug->getObjTree(tree, lppIndex);
}
```

[通过getRegionQueryPlug获取插件](#331-获取插件)

[调用位置](#342-生成查询结果)

返回查询数据

```cpp
oaLayerNum oaShapeQueryPvt::getLayerNum() const {
    return layerNum;
}
```

<a id="getClassObject"><a>

### 2.3 定义函数getClassObject，在[加载插件](#getClassFactory)时会调用

```cpp
extern "C" long
getClassObject(const char           *classID,
               const oaCommon::Guid &interfaceID,
               void                 **ptr)
{
    return oaCommon::FactoryBase::getClassObject(classID, interfaceID, ptr);
}
```

[FactoryBase::getClassObject](#FactoryBase::getClassObject)

<a id="Factory::Constructor"><a>

### 2.4 通过静态变量的构造函数注册插件

```cpp
Factory<oaXYTreePlugMgr> oaXYTreePlugMgr::factory("oaRQXYTree");

template<class T>
class Factory : public FactoryBase {};

template<class T>
Factory<T>::Factory(const char *classID) {
    insertFactory(classID, this);
}

void FactoryBase::insertFactory(const char *classID, FactoryBase  *factory) {
    string className(classID);
    factories->insert(pair<string, FactoryBase*>(className, factory));
}
```

### 2.5 oaXYTreePlug的主要数据结构

```cpp
class oaXYTreePlug : public oaRegionQueryPlug {
    oaXYObjTree<oaMarkerTbl>                *markerTree;
    oaXYObjTree<oaRowTbl>                   *rowTree;
    oaXYObjTree<oaBoundaryTbl>              *boundaryTree;
    oaXYObjTree<oaGuideTbl>                 *guideTree;
    oaArray<oaXYInstTree*>                  instTrees;
    oaArray<oaXYViaTree*>                   viaTrees;
    oaArray<oaXYObjTree<oaShapeTbl>*>       shapeTrees;
    oaArray<oaXYObjTree<oaBlockageTbl>*>    blockageTrees;
    oaArray<oaXYObjTree<oaSteinerTbl>*>     steinerTrees;
    oaXYObjTree<oaFigGroupTbl>              *figGroupTree;
};
```

## 3. 业务流程

### 3.1 初始化

```cpp
IRegionQueryPlugMgr *oaRegionQuery::rqMgr = NULL;
void oaRegionQuery::init(const oaString &plugInName) {
    // 获取工厂对象
    rqMgr = SPtr<IRegionQueryPlugMgr>(plugInName).detach();
}
```

[查看初始化位置](#11-加载插件)

<a id="initForRegionQuery">初始化oaBlockTbl</a>

```cpp
void
oaBlock::initForRegionQuery() {
    oaBlockI            imp(this);
    const oaUInt4       index = imp.getIndex();
    oaBlockTbl*const    tbl = imp.getTbl();
    tbl->initForRegionQuery(index);
}

void
oaBlockTbl::initForRegionQuery(oaUInt4      index,
                               oaBoolean    updateUsedIn) const
{
    oaBlockTbl          *tmp = const_cast<oaBlockTbl*>(this);
    oaRegionQueryPlug   *plug = oaRegionQuery::getMgr()->createPlug(tmp, index, bBoxTbl[index]);
    regionQueryPlugTbl[index] = plug;
}
```

#### 3.1.1 创建工厂对象

```cpp
template<class T>
SPtr<T>::SPtr(const char *classID, bool factory=false) {
    createInstance(classID);
}

template<class T>
inline void SPtr<T>::createInstance(const char *classID, IBase *reserved) {
    T **ptrObj = &obj;
    oaPlugInMgr::getPlugInMgr()->createInstance(
        classID, reserved, T::getId(), (void**) ptrObj
    );
}

void oaPlugInMgr::createInstance(const char  *classID, IBase *reserved,
                                 const Guid &interfaceID, void **ptr) {
    IFactory *factory = NULL;
    // 加载插件
    getClassFactory(classID, IID_IFactory, reinterpret_cast<void**>(&factory));
    oaUInt4 status = factory->createInstance(reserved, interfaceID, ptr);
    checkCompatibility((IBase*) *ptr, classID);
    factory->release();
}
```

<a id="getClassFactory"></a>

#### 3.1.2 加载插件

```cpp
void oaPlugInMgr::getClassFactory(
    const char *classID, const Guid &interfaceID, void **ptr) {
    IBase *base;
    // 防止重复加载
    if (table->find(classID, base)) {return;}
    // 加载动态库类
    PlugInLib       lib(classID);
    typedef oaUInt4 (*FuncType)(const char*, const Guid&, void**);
    // 获取工厂对象入口
    FuncType fun = (FuncType)lib.getSymbol("getClassObject");
    // 进入插件getClassObject函数
    oaUInt4 result = fun(lib.getActualClassId(), interfaceID, ptr);
    char *classIdCopy = new char[strlen(classID) + 1];
    strcpy(classIdCopy, classID);
    // 记录已经加载工厂
    table->insert(classIdCopy, static_cast<IBase*>(*ptr));
}
```

[定义 getClassObject 位置](#getClassObject)

#### 3.1.3 加载动态库

```cpp
PlugInLib::PlugInLib(const char *classIdIn) : SharedLib(""), classId(classIdIn) {
    // 查找动态库
    getSharedLibName(path);
    // 加载动态库
    open();
}

void SharedLib::open() {
    lib = dlopen(getPath(), RTLD_LAZY | RTLD_GLOBAL);
}

void * SharedLib::getSymbol(const char *name) const {
    // 获取动态库内函数
    return dlsym(lib, name);
}
```

#### 3.1.4 查找动态库

```cpp
void PlugInLib::getSharedLibName(string &sharedLibName) {
    PlugInDef def(classId);
    def.load();
    def.getLibBaseName(baseName);
    sharedLibName = string("");
    getName(sharedLibName);
    string      dirName;
    if (def.getLibDir(dirName)) {
        string sharedLibPath;
        getFullPath(dirName, def.getPlugInFile(), sharedLibPath);
        sharedLibName = sharedLibPath + InstallDir::getDirSep() + sharedLibName;
    }
}

void PlugInDef::load() {
    // PlugInParser继承自XmlParser
    PlugInParser parser(this);
    // 解析xml
    parser.parse(plugInFile.c_str());
}

// 获取动态库路径
bool PlugInDef::getLibDir(string &dir) const {
    return getAttrValue("directory", dir);
}
```

<a id="FactoryBase::getClassObject"></a>

### 3.2 获取插件工厂

#### 3.2.1 初始化时获取注册的工厂对象

```cpp
oaUInt4
FactoryBase::getClassObject(const char  *classID,
                            const Guid  &interfaceID,
                            void        **ptr)
{
    FactoryBaseMap::iterator    it = factories->find(classID);
    if (it == factories->end()) { return IBase::cFail; }
    FactoryBase                 *factory = it->second;
    return factory->queryInterface(interfaceID, ptr);
}
```

[查看插件工厂注册位置](#Factory::Constructor)

```cpp
// 校验id
long FactoryBase::queryInterface(const Guid &idIn, void **iPtr) {
    if (idIn == IID_IBase || idIn == IID_IFactory) {
        *iPtr = reinterpret_cast<void*>(static_cast<IFactory*>(this));
        addRef();
        return cOK;
    } else {
        *iPtr = NULL;
        return cFail;
    }
}
```

#### 3.2.2 初始化后获取工厂对象

```cpp
IRegionQueryPlugMgr *oaRegionQuery::getMgr() {
    return rqMgr;
}
```

### 3.3 调用插件

#### 3.3.1 获取插件

```cpp
inline oaRegionQueryPlug *
oaBlockTbl::getRegionQueryPlug(oaUInt4      index,
                               oaBoolean    create) const
{
    if (create && !regionQueryPlugTbl[index]) {
        initForRegionQuery(index);
    }
    return regionQueryPlugTbl[index];
}
```

在[操作插件](#332-操作插件)和[查询数据](#oaRegionQueryPvt::produce)时都要先通过该接口获取插件

#### 3.3.2 操作插件

```cpp
void oaLPPHeaderTbl::addShapeBBox(oaUInt4 index, oaUInt4 shapeIndex) {
    oaShapeTbl          *sTbl = oaShapeTbl::get(getDesignData());
    oaBlockTbl          *bTbl = oaBlockTbl::get(getDesignData());
    oaRegionQueryPlug   *rqPlug = bTbl->getRegionQueryPlug(bTbl->getTop());
    if (rqPlug) {
        bTbl->invalidateBlkBBox(bTbl->getTop(), sTbl->getBBox(shapeIndex));
        rqPlug->addShape(sTbl, shapeIndex);
    }
}
```

### 3.4 查询操作

<a id="oaShapeQuery"></a>

#### 3.4.1 通过oaShapeQuery查询

```cpp
// 初始化用来查询的对象
oaShapeQuery::oaShapeQuery() {
    // 成员变量: oaRegionQueryPvt *pvt;
    pvt = getMgr()->createShapeQuery(this);
}

// 使用对象查询
void oaShapeQuery::query(oaDesign        *design,
                         oaLayerNum      layerNum,
                         oaPurposeNum    purposeNum,
                         const oaBox     &region,
                         oaDist          filterSize,
                         oaUInt4         startLevel,
                         oaUInt4         stopLevel) {
    oaDesignData    *dsData = oaDesignI::get(design);
    oaShapeQueryPvt *sqPvt = (oaShapeQueryPvt*) pvt;
    sqPvt->produce(dsData, layerNum, purposeNum,
                   region, filterSize, startLevel, stopLevel);
}

// 返回查询结果
oaLayerNum oaShapeQuery::getLayerNum() const {
    return ((oaShapeQueryPvt*) pvt)->getLayerNum();
}
```

[用户操作](#14-查询)

[插件查询接口](#插件查询逻辑)

<a id="oaRegionQueryPvt::produce"></a>

#### 3.4.2 生成查询结果

```cpp
inline void
oaRegionQueryPvt::produce(oaDesignData  *topDesignDataIn,
                          const oaBox   &regionIn,
                          oaUInt4       filterSizeIn,
                          oaUInt4       startLevelIn,
                          oaUInt4       stopLevelIn) {
    topDesignData = topDesignDataIn;
    isAborted = false;
    region = regionIn;
    curRegion = regionIn;
    filterSize = filterSizeIn;
    startLevel = startLevelIn;
    stopLevel = stopLevelIn;
    topDesignData->addTopDesign();

    oaBlockTbl *blkTbl = oaBlockTbl::get(topDesignData);
    if (blkTbl) {
        oaUInt4 top = blkTbl->getTop();
        if (top != oacNullIndex) {
            blkTbl->getRegionQueryPlug(top, true);
            processDesign(topDesignData);
        }
    }
}
```

[重写processDesign](#oaXYShapeQueryPvt::processDesign)

## 4. west v100插件

```text
west当前插件机制
PluginControllerImpl::CreatePlugin先通过PluginDynaLib::LoadLibrary加载动态库，然后通过调用注册的Create函数创建对象
通过PluginDynaLib::LoadLibrary加载动态库，
加载动态库时通过宏REG_PLUGIN(class_name, plugin_name)创建的静态变量PluginReg会初始化，
在其构造函数中注册Create回调函数{name: PluginCreator<T>::Create}
PluginCreator<T>::Create默认实现是通过调用T::GetInterface接口创建对象的，
PluginReference提供默认的GetInterface函数，传出自身即REG_PLUGIN时class_name类创建的对象
```
