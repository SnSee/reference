# google test

## 使用类测试

### 基本用法

```cpp
#include "gtest/gtest.h"

class TestClass :public testing::Test {
protected:
    void SetUp() override {
        ...
    }

    void TearDown() override {
        ...
    }

    int num;
};
```

```cpp
TEST_F(TestClass, case_1) {
    ASSERT_TRUE(true);
}
```
