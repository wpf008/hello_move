# move base type

> 本教程是基于aptos搭建的move智能合约开发

## 1.move语言中类型的声明和赋值
```let variable_name:<type> = variable_valuel;```
+ 1.类型推导&赋值
+ 2.显示定义&赋值
+ 3.值&类型
+ 4.先定义后赋值
```
//example
let a = true;           //类型推导&赋值
let x:u64 =666;         //显示定义&赋值
let y = 888u128;        //值&类型
let account:address;    //先定义后赋值
account = @0x1
```

## 1.数值类型
#### 数值类型声明和赋值
+ u8
+ u64
+ u128

```move
let x = 10;//auto inferred: u8
let y = 1000;//auto inferred: u64

let explicit_u8 = 1u8;
let explicit_u64 = 2u64;
let explicit_u128 = 3u128;

let simple_u8: u8 = 1;
let simple_u64: u64 = 200;
let simple_u128: u128 = 99999;

let complex_u8 = 8; // inferred: u8
let _unused = 10 << complex_u8;

let x: u8 = 38;
let complex_u8 = 2; // inferred: u8
let _unused = x + complex_u8;

let hex_u8: u8 = 0x1;
let hex_u64: u64 = 0xAOB;
let hex_u128: u128 = 0xABCDEF;
```
#### 数值的运算符，包括：
##### 算数运算符,： 
+ 加：+
+ 减：-
+ 乘：*、
+ 取余：%、
+ 除：/、
+ 左移：<<
+ 右移>>
##### 比较运算符：
 <、>、<=、>=、==、!=

#### 数值的类型转换：(e as T)
```move
let x = 10;
let y = x as u64;
```

## 2.bool
#### 布尔值的声明和赋值
```move
  let a = true;
  let flag:bool = false;
```

#### 布尔值的运算符，包括：
+ ! （逻辑非）
+ && （逻辑与， "and" ）
+ || （逻辑或， "or" ）
+ == （等于）
+ != （不等于）


## 3.address
#### 布尔值的声明和赋值
```move
let a: address = @0x1;
let b: address = @sender;  //sender in Move.toml
```
> address值是一个128位（16字节）的标识符。在给定的地址，可以存储两件事：模块和资源(将会在模块和资源详细介绍)。
```move
move_to(acc:&singer,res:T);         //  发布资源T到acc地址下，singer将在下一讲讲述
move_from<T>(add:address);          //  在add地址下移除资源T并返回T
exists<u8>(add:address);            //  T资源在add地址下是否存在
borrow_global<T>(add:address);      //  向add地址借出不可变的资源T
borrow_global_mut<T>(add:address);  //  向add地址借出可变的资源T
```
>[注] mut修饰的变量具有可变性，可以修改其内容，而无mut修饰的变量不具有可变性，无法修改其值。详细理解可以深入学习[Rust](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html).
```move
let a = 10;
let b = a;              //含义：a绑定的资源10转移给b，b拥有这个资源10
let b = &a;             //含义：a绑定的资源10借给b使用，b只有资源10的读权限
let b = &mut a;         //含义：a绑定的资源10借给b使用，b有资源10的读写权限
let mut b = &mut a;     //含义：a绑定的资源10借给b使用，b有资源10的读写权限。同时，b可绑定到新的资源上面去（更新绑定的能力）
```



> 至此move的环境搭建是否成功已得到验证且使用move语言开发helloworld程序已经完成，接下来我们开始move基本语法。
