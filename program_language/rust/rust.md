
# rust

[官网](https://www.rust-lang.org)
[The Rust Standard Library](https://doc.rust-lang.org/stable/std/)

## 语法

### main函数

```rust
// 行注释
/* 行注释 */
/*
 * 多行注释
 */

/// 会被解析到doc中的 行注释
//! 会被解析到doc中的 作用域(enclosing item)注释

fn main() {
    println!("Hello World!");
}
```

### 格式化输出

[example](https://doc.rust-lang.org/rust-by-example/hello/print.html)

```text
format!  : 格式化到 String
print!   : 格式化输出到 io::stdout，不会自动换行
println! : 格式化输出到 io::stdout，会自动换行
eprint!  : 格式化输出到 io::stderr，不会自动换行
eprintln!: 格式化输出到 io::stderr，会自动换行
```

```rust
println!("{} days", 31);
println!("v1 {1} v0 {0}", 0, 1);
println!("{v1} {v2}", v1=1, v2=2);

// 指定进制
println!("Base 10:               {}",   69420); // 69420
println!("Base 2 (binary):       {:b}", 69420); // 10000111100101100
println!("Base 8 (octal):        {:o}", 69420); // 207454
println!("Base 16 (hexadecimal): {:x}", 69420); // 10f2c
println!("Base 16 (hexadecimal): {:X}", 69420); // 10F2C

// 十六进制，最小位宽 2，不足补 0
println!("RGB ({0}, {1}, {2}) 0x{0:0>2X}{1:0>2X}{2:0>2X}", r, g, b);
```

Debug 和 Display 模式打印复数

```rust
use std::fmt;

#[derive(Debug)]        // 继承 Debug，会有默认的 Debug 输出
struct Complex {        // 定义复数
    real: f64,
    imag: f64,
}

// 实现 Complex 的 Display 方法
impl fmt::Display for Complex {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} + {}i", self.real, self.imag)
    }
}

fn main() {
    let c = Complex {real: 3.2, imag: 7.2}; // 创建变量
    println!("{}", c);                      // Display 方式输出
    println!("{:?}", c);                    // Debug 方式输出
}
```

打印列表

```rust
use std::fmt;

struct List(Vec<i32>);          // 定义列表

impl fmt::Display for List {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let vec = &self.0;      // 获取实际容器

        // write! 会产生一个 fm::Result
        // 加上 ? 后只有发生 error 才会返回
        write!(f, "[")?;
        // 遍历列表
        for (count, v) in vec.iter().enumerate() {
            if count != 0 { write!(f, ", ")?; }
            write!(f, "{}: {}", count, v)?;
        }
        write!(f, "]")
    }
}

fn main() {
    let v = List(vec![1, 2, 3]);
    println!("{}", v);
}
```
