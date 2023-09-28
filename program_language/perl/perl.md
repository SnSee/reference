
# perl

[菜鸟教程](https://www.runoob.com/perl/perl-tutorial.html)

数据类型

```perl
# 标量（数字，字符串等，以 $ 开头命名）
$a = 1;
$b = 1.2;
$c = "test";
# 字符串
print "$a\n$b";      # 双引号会解析变量及转义字符
print '$a\n$b';      # 单引号会原样输出

# 数组（以 @ 开头命名）
@arr = (1, 2, 3);

# 哈希
%hash=('a'=>1, 'b'=>2);
```

变量

```perl
sub test {
    # 默认为全局变量
    $global_ver = "global";
    # 局部变量
    my $local_var = "local";
}
```

数组

```perl
@arr = (1, 2, 3)    # 创建数组
@arr = []           # 创建空数组
$#arr               # 数组长度
scalar $arr         # 数组长度
$arr[0]             # 访问元素

#!/usr/bin/perl
 
@sites = ("google","runoob","taobao");
$new_size = @sites ;
# 在数组结尾添加一个元素
$new_size = push(@sites, "baidu");
# 在数组开头添加一个元素
$new_size = unshift(@sites, "weibo");
# 删除数组末尾的元素
$new_byte = pop(@sites);
# 移除数组开头的元素
$new_byte = shift(@sites);
```

哈希

```perl
$hash{'a'}              # 访问元素
@names = keys %hash     # 获取所有 key
exists($hash{'a'})      # 查看是否存在元素
$hash{'c'} = 3          # 插入元素
delete $hash{'a'}       # 删除元素

# 迭代
foreach $key (keys %hash) {}
while(($key, $val) = each(%hash)) {}
```

数学运算

```perl
```

条件语句

```perl
$a = 100;
if( $a  ==  20 ){
}elsif( $a ==  30 ){
}else{
}
```

switch

```perl
use Switch;
 
switch(argument){
   case 1            { print "数字 1" }
   case "a"          { print "字符串 a" }
   case [1..10,42]   { print "数字在列表中" }
   case (\@array)    { print "数字在数组中" }
   case /\w+/        { print "正则匹配模式" }
   case qr/\w+/      { print "正则匹配模式" }
   case (\%hash)     { print "哈希" }
   case (\&sub)      { print "子进程" }
   else              { print "不匹配之前的条件" }
}
```

三目运算符

```perl
# c 语法
exp1 ? exp2 : exp3;
```

循环

```perl
while() {}
for($i=0; $i < 10; $i = $i + 1) {}
foreach $var (@list) {}

next    # 相当于 continue
last    # 相当于 break
```

调用shell命令

```perl
my @dirs = `ls ~`
```

文件操作

```perl
open(DATA, "<file.txt") or die "file.txt 文件无法打开, $!";
 
while(<DATA>){
   print "$_";
}
```

split 拆分字符串

```perl
my $str = "a.b.c";
my @parts = split(/\./, $str);
# print "@parts[0]\n"
foreach my $part (@parts) {
    print "$part\n";
}
```
