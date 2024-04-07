# STL

## algorithm

### all_of

判断迭代器范围是否全为真

```cpp
vector<int> vs = {1, 2, 3, 4};
all_of(vs.begin(), vs.end(), [](int v){ return v > 3; });     // false
```

### any_of

判断迭代器范围是否有任意一个为真

```cpp
vector<int> vs = {1, 2, 3, 4};
any_of(vs.begin(), vs.end(), [](int v){ return v > 3; });     // true
```
