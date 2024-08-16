
# small

## tqdm

进度条

```py
import time
import tqdm


# 方式一
for i in tqdm.tqdm(range(1000)):
    time.sleep(0.01)

# 方式二
for i in tqdm.trange(1000):
    time.sleep(0.01)

# 自定义显示信息
proc_bar = tqdm.tqdm(total=100, desc='progress', unit='')
n = 40
for i in range(n):
    # proc_bar.set_description(f'progress')
    proc_bar.update(100 / n)        # 每次调用进度增加 100/n
    time.sleep(0.05)
proc_bar.close()
```
