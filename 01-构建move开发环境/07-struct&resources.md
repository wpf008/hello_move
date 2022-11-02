# ```move中的结构、泛型与资源```

> 本教程是基于aptos搭建的move智能合约开发




## 1.struct
### 1.1 struct 介绍
> ```struct``` 是由一批数据组合而成的结构型数据。组成结构型数据的每个数据称为结构型数据的“成员”。
> 
>结构可以存储任何非引用类型，包括其他结构，无法再存储自身结构，即结构不能递归。
>
> 默认情况下，结构是线性的和短暂的。即不能被复制，不能被删除，不能被存储在全局存储中。 这意味着所有值都必须转移所有权（线性），并且必须在程序执行结束时处理这些值。
> 
> 我们可以通过赋予 ```struct``` 允许```copy```或```drop```以及存储在全局存储中或定义全局存储模式的能力来实现这种行为。
> 
> 如果结构值无法复制且无法删除，我们通常将其称为**资源**。在这种情况下，资源值必须在函数结束时转移所有权。此属性使资源特别适合用于定义全局存储模式或表示重要值（例如令牌）。
>

### 1.2 struct 定义

+ 结构必须在模块内定义
+ 结构必须以大写字母A-Z开头,后面可以使用A-Z、a-z、0-9、_
+ 结构体中可以定义0-65535个字段
+ **结构类型只能在定义结构的模块内创建（“打包”）、销毁（“解包”）。**
+ **结构的字段只能在定义结构的模块内部访问。**

> 结构的语法
```move
//<T1,T2>表示结构的泛型  []表示可选
struct struct_name<T1,T2> [has] [key | copy | drop | store] {
    filed_01:T1,
    filed_02:T2,
    filed_03:Type_03,
    ....
    filed_n:Type_n
}

```

### 1.2.1 默认情况下，结构声明是线性且短暂的
```move
module sender::Coin {
    use std::string;
    struct OtherInfo {}
    struct CoinInfo {
        name: string::String,
        symbol: string::String,
        decimals: u8,
        supply: u128,
        cap: u128,
        otherInfo: OtherInfo,
        //c:CoinInfo,//error Circular reference of type 'CoinInfo'
    }
}
```

### 1.2.2 结构声明具有```copy``` ```drop``` ```store```能力,此时结构体具有复制、删除、将其存储在全局存储中或将其用作存储模式
```move
module sender::Coin {
    use std::string;
    struct OtherInfo has copy,drop{}
    struct CoinInfo has copy,drop{
        name: string::String,
        symbol: string::String,
        decimals: u8,
        supply: u128,
        cap: u128,
        otherInfo: OtherInfo,
    }
}
```

### 1.2.3 使用泛型的结构定义
```move
module sender::Coin {
    use std::string;
    struct OtherInfo has copy, store, drop {}
    struct CoinInfo<T> has copy, store, drop {
        name: string::String,
        symbol: string::String,
        decimals: T,
        supply: u128,
        cap: u128,
        otherInfo: OtherInfo,
    }
}
```


### 1.3 struct 创建与使用
```move
//在Coin.move模块里定义了一个创建CoinInfo的方法
public fun new_CoinInfo(name:string::String, symbol: string::String): CoinInfo {
    let otherInfo = OtherInfo {};
    CoinInfo {
        name, symbol, decimals: 10, supply: 10, cap: 10, otherInfo
    }
}
//在Coin.move模块里定义了一个可修改supply的函数
public fun setSupply(coinInfo: &mut CoinInfo, supply: u128) {
    coinInfo.supply = supply;
}

//在test_struct_resource.move实际去创建结构体并修改结构体属性
#[test]
public fun test_struct() {
    let coin = Coin::new_CoinInfo(string::utf8(b"test"), string::utf8(b"T"));
    print(&coin);
    Coin::setSupply(&mut coin,100);
    print(&coin);
}
```




## 2.泛型(generics)
>泛型是允许程序员在强类型程序设计语言中编写代码时使用一些以后才指定的类型，在实例化时作为参数指明这些类型。
>
>函数和结构都可以在其签名中采用类型参数列表，并用一对尖括号括起来<...>

### 2.1 定义函数时使用泛型
```move
fun fun_name<T>(x: T): T {
    // this type annotation is unnecessary but valid
    (x: T)
}
```

### 2.2 定义结构时使用泛型
```move
struct Foo<T> has copy, drop { x: T }

struct Bar<T1, T2> has copy, drop {
    x: T1,
    y: vector<T2>,
}
```

### 2.3 ```phantom```类型的泛型
> 在结构定义中，可以通过在声明之前添加```phantom```关键字来将类型参数声明为```phantom```。 如果一个类型参数被声明为```phantom```，我们就说它是幻像类型参数。
> 
> 被```phantom```修饰的类型参数将不参与结构的能力推导。这样，在派生泛型类型的能力时，不考虑幻像类型参数的参数，从而避免了对虚假能力注释的需要。
> 
> 定义结构时，```Move```的类型检查器确保每个幻像类型参数要么不在结构定义中使用，要么仅用作幻像类型参数的参数。

```move
//不在结构定义中使用泛型
struct A<phantom T1,T2> {
    foo: T2
}
//仅用作幻像类型参数的参数
struct B<phantom T> {
    a:A<T,u8>
}
```


---

## 3.resources
只有具有```key```能力的结构才能直接保存在持久性全局存储中。存储在这些key结构中的所有值都必须具有这种```store```能力

---

> 至此我们已经学会了move中的引用和元组。接下来我们学习````struct```，利用````
> struct```构建复杂的结构体并在全局存储中存储资源````resources```。
