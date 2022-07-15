# google test

## 1. 使用基类测试

### 1.1. 基本用法

定义测试用例

```cpp
#include "gtest/gtest.h"

// 定义测试类
class TestClass :public testing::Test {
protected:
    // 执行具体的case之前会先调用SetUp
    void SetUp() override {
        ...
    }

    // 执行具体的case之后会调用SetUp
    void TearDown() override {
        ...
    }

    int num;
};

// 定义测试用例
TEST_F(TestClass, case_1) {
    ASSERT_TRUE(true);
}
```

运行测试用例

```cpp
#include "gtest/gtest.h"

int main() {
    int ret = RUN_ALL_TESTS();
    return 0;
}
```

### 1.2. 原理

```cpp
TEST_F宏函数展开后主要分成 4 部分

1.static_assert部分: 做类型尺寸约束
2.根据TEST_F参数定义子类，如TEST_F(TestClass, case1)会定义为
class TestClass_case1_Test : public TestClass {
    ...
private:
    virtual void TestBody();
    ...
}
3.创建全局变量，主要作用是注册测试用例，后续在RUN_ALL_TESTS中便可直接调用
    注册接口为:
        TestInfo* MakeAndRegisterTestInfo(...);
    通过AddTestInfo在test_info_list_中统一维护
        void TestSuite::AddTestInfo(TestInfo* test_info);
4.定义TestBody
    void TestClass_case1_Test::TestBody()
    宏到此就展开完毕，正好接上宏后的函数体
```

## 2. 不使用基类测试

### 2.1. 基本用法

```cpp
// 定义测试用例
#include "gtest/gtest.h"

TEST(module_name, case_name) {
    ...
}
```

### 2.2. 原理

```cpp
和TEST_F相同，不过第 2 部分继承的是 ::testing::Test
```
