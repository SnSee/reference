
# sql

SQL(Structured Query Language) 用于管理关系型数据库(RDBMS), 可以对数据进行增删改查。

* 一个数据库通常包含多张表，每个表有唯一的名称
* sql 语句对关键字大小写不敏感

## 语法

### 注释

```sql
-- 单行注释
/* 多行
   注释
*/
```

### 数据类型

|type |desc
|- |-
|tinyint        |1 字节整数
|smallint       |2 字节整数
|integer/int    |4 字节整数
|bigint         |8 字节整数
|float          |单精度浮点数
|double         |双精度浮点数
|decimal        |定点数，相当于用字符串表示的浮点数，decimal(总位数, 小数位数)
|char(n)        |长度为 n 的字符串，不足填充空格
|varchar(n)     |最大长度为 n 的字符串，按实际长度存储
|text           |长文本，通常没有长度限制或非常大
|date           |日期(年月日)
|time           |时间(时分秒)
|datetime       |日期 + 时间
|timestamp      |时间戳

### 操作表

#### 条件

##### WHERE 条件

|operator | desc
|- |-
|=          |等于
|<>         |不等于
|>          |大于
|<          |小于
|>=         |大于等于
|<=         |小于等于
|IN         |是否存在于序列内
|BETWEEN    |区间
|LIKE       |模糊匹配(通配符为 %)

##### AND / OR

```sql
-- 连接 WHERE 条件
SELECT * FROM 表名 WHERE 条件1 AND 条件2 [AND 条件3 ...];
SELECT * FROM 表名 WHERE 条件1 OR  条件2 [OR  条件3 ...];
```

##### NOT

```sql
-- 条件取反
SELECT * FROM 表名 WHERE NOT 条件;
```

##### IN

```sql
-- 存在性判断
SELECT * FROM 表名 WHERE 列名 IN (值1, 值2, 值3);
```

##### LIMIT

```sql
-- 只获取第一条数据
SELECT * FROM 表名 WHERE 条件 LIMIT 1;
```

#### create

```sql
-- 创建数据库
CREATE DATABASE 数据库名;
-- 设置当前数据库
USE 数据库名称;

-- 创建表
CREATE TABLE 表名 (
    列名1 数据类型 [约束],
    列名2 数据类型 [约束],
    列名3 数据类型 [约束],
    ...
);
```

##### 约束条件

|constraint |desc
|- |-
|PRIMARY KEY    |该列为主键，值必须唯一且不能为空，一个表只能有一个主键
|FOREIGN KEY    |该列值必须在另一个表的主键列的值中
|UNIQUE         |该列值必须唯一
|NOT NULL       |该列值不能为空
|CHECK          |该列值必须满足指定条件
|DEFAULT        |该列具有默认值

```sql
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    CustomerID INT,
    FullName VARCHAR(255) UNIQUE,
    Age TINYINT,
    Class TINYINT DEFAULT 1,
    CHECK (Age > 6),
    CONSTRAINT fk_name FOREIGN KEY (CustomerID) REFERENCES 表名,
);
```

##### 检查是否存在表

```sql
-- sqlite3: 返回空字符串在不存在
select name from sqlite_master where type='table' and name='表名';
```

##### 获取表列信息

```sql
PRAGMA table_info(表名);
select sql from sqlite_master where type='table' and name='表名';
```

#### insert

```sql
-- 插入一行数据
INSERT INTO 表名 VALUES (值1[, 值2, ...]);
-- 插入时只设置指定列的值，未设置的值为 null
INSERT INTO 表名 (列1[, 列2, ...]) VALUES (值1[, 值2, ...]);
```

#### select

```sql
-- 查询数据, 名称可以使用通配符
SELECT 列1[, 列2, ...] FROM 表名 [WHERE 条件 ORDER BY 列];
```

##### ORDER BY

对查询结果排序，DESC 降序，ASC 升序(默认)
ASC null 在最后
DESC null 在最前
优先级高的列相同时，优先级低的列如果未指定默认按 ASC 排序

```sql
SELECT * FROM 表名称 ORDER BY 列1[, 列2, ...] DESC;
```

##### AS

```sql
-- 表别名
SELECT * FROM 表名 AS 表别名;

-- 列别名
SELECT 列名 as 列别名 FROM 表名;
-- AS 可省略，但是别名需要加上双引号
SELECT 列名 "列别名" FROM 表名;
```

##### GROUP BY

```sql
-- 对结果分组计数, 通常与聚合函数（如 COUNT、SUM、AVG、MAX、MIN）一起使用
-- 列1的值可能对应多个列2的值，对这些列2的值使用聚合函数得到单一值作为结果
-- 可对多个列进行分组
SELECT 列1, 聚合函数(列2)
FROM 表名 WHERE 条件 GROUP BY 列1;
```

##### HAVING

```sql
-- 对 GROUP BY 结果进行过滤
SELECT 列1, 聚合函数(列2) AS ret
FROM 表名 WHERE 条件 GROUP BY 列1
HAVING ret 条件;
```

#### distinct

```sql
-- 去重查询
SELECT DISTINCT 列1[, 列2, ...] FROM 表名称;
```

#### update

```sql
-- 更新数据，符合 where 的行都会更新
UPDATE 表名 SET 列1=值1[, 列2=值2, ...] WHERE 条件;
```

#### delete

```sql
-- 删除行
DELETE FROM 表名 WHERE 条件;
-- 删除所有行(保留表头)
DELETE FROM 表名;
```

#### truncate

```sql
-- 清空表
TRUNCATE TABLE 表名;
```

#### drop

```sql
-- 删除表
DROP TABLE 表名;
-- 删除数据库
DROP DATABASE 数据库名;
```

#### join

多表关联查询

* 如果表1中某行对应表2中多行，则都会返回

##### inner join

返回两个表中满足连接条件的行指定列, 不满足的行结果为空

```sql
SELECT 表1.列1, 表2.列2 FROM 表1
INNER JOIN 表2 ON 表1.主键 = 表2.主键;
```

##### left join

返回表1中所有行指定列; 对表1任意行, 如果表2有满足条件行返回对应列，否则返回 null

```sql
SELECT 表1.列1, 表2.列2 FROM 表1
LEFT JOIN 表2 ON 表1.主键 = 表2.主键;
```

##### right join

返回表2中所有行指定列; 对表2任意行, 如果表1有满足条件行返回对应列，否则返回 null

```sql
SELECT 表1.列1, 表2.列2 FROM 表1
RIGHT JOIN 表2 ON 表1.主键 = 表2.主键;
```

##### full join

返回表1和表2所有行指定列; 对表1任意行, 如果表2有满足条件的行返回对应列，否则返回 null，反之亦然

```sql
SELECT 表1.列1, 表2.列2 FROM 表1
FULL JOIN 表2 ON 表1.主键 = 表2.主键;
```

##### cross join

返回两个表的笛卡尔积，即每个左侧表的行都会与右侧表的每一行配对

```sql
SELECT 表1.列1, 表2.列2 FROM 表1
CROSS JOIN 表2;
```

### 内置函数

#### AVG

```sql
-- 求平均值
SELECT AVG(列名) FROM 表名;
```

#### COUNT

```sql
-- 求总行数
SELECT COUNT(*) FROM 表名;
-- 求不重复总行数
SELECT COUNT(DISTINCT 列名) FROM 表名;
-- 求总行数
SELECT COUNT(列名) FROM 表名;
```

#### MAX / MIN

```sql
-- 求最大值
SELECT MAX(列名) FROM 表名;
-- 求最小值
SELECT MIN(列名) FROM 表名;
```

#### SUM

```sql
-- 求和
SELECT SUM(列名) FROM 表名;
```

#### UPPER / LOWER

```sql
-- 字符串全部大写
SELECT UPPER(列名) FROM 表名;
-- 字符串全部小写
SELECT LOWER(列名) FROM 表名;
```

#### LENGTH

```sql
-- 获取字符串长度
SELECT LENGTH(列名) FROM 表名;
```

#### ROUND

```sql
-- 对小数部分四舍五入
SELECT ROUND(列名,保留小数位数) FROM 表名;
```

#### NOW / SYSDATA

```sql
-- 获取当前时间
SELECT SYSDATE FROM dual;  
```
