
# math

## 排列组合

### 组合

```cpp
// 计算 C(m, n)
// (m * (m-1) * ... * (m-n-1)) / (1 * 2 * ... * n)
int comb(int m, int n) {
    if (n > m) return 0;
    if (n == 0 || n == m) return 1;
    if (m - n < n) {
        n = m - n;
    }
    int count = 1;
    for (int i = 0; i < n; ++i) {
        count *= (m - i);
        count /= (i + 1);     // 可以保证能够整除
    }
    return count;
}
```
