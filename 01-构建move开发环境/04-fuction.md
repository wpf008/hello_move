# move function & 流程控制

> 本教程是基于aptos搭建的move智能合约开发

## 1.move语言中函数的定义(学过编程语言的，这一小节其实很简单)

```move
[public] fun fun_name(params1: Type1, parmas2: Type2): (ReturnType1, ReturnType2){
    //fun body
}
```

**说明**
> + public 用于访问控制，无public表示仅仅在module内部调用
>
> + 函数的入参可以是0个，也可以是多个
>
> + 函数的返回值可以是0个，也可以是多个，多个用()
>
> + 返回值注意不能加 **;**,**return**可写可不写


----

## 2. as关键字用法

+ 将导入的函数Math改名为M,详细使用见[test_function.move](https://github.com/wpf008/hello_move/tree/master/03-base-type/tests/test_function.move)

```move
use sender::Math as M;  //将导入的函数Math改名为M
```

+ 类型转换,详细使用见[Math.move](https://github.com/wpf008/hello_move/tree/master/03-base-type/sources/Math.move)

```move
public fun multiply(a: u64, b: u64): u128 {
    (a * b as u128)
}
```

----

## 3.流程控制
### 3.1 if 判断
```move
if(condition1){

}else if (condition2){

}else{

};
```

> [示例](https://github.com/wpf008/hello_move/blob/master/03-base-type/sources/Math.move)【注:目前不支持中文注释，记得代码里的中文注释在运行是去除】
>
> **注意下面两个例子的书写方式**
```move
public fun subtract(a: u64, b: u64): u64 {
    if (a < b)
        return 0; //有逗号
    return a - b
}

public fun subtract(a: u64, b: u64): u64 {
    if (a < b){
        return 0 //无逗号
    };//有逗号
    return a - b
}
```

----

### 3.2 while & loop
+ **loop表达式重复执行循环体,直到遇到break**
```move
while (condition) {
        
};

loop{};
```

+ [循环示例](https://github.com/wpf008/hello_move/blob/master/03-base-type/sources/Math.move)
```move
fun sum_while(n: u64): u64 {
    let sum = 0;
    let i = 1;
    while (i <= n) {
        sum = sum + i;
        i = i + 1
    };
    sum
}

fun sum_loop(n: u64): u64 {
    let sum = 0;
    let i = 0;
    loop {
        i = i + 1;
        if (i > n) break;
        sum = sum + i
    };
    sum
}
```

### 3.3 break & continue
+ **break**表达式可用于在条件计算为假之前退出循环。 例如，此循环使用break来查找n中大于1的最小因子：
```move
fun smallest_factor(n: u64): u64 {
    let i = 2;
    while (i <= n) {
        if (n % i == 0) break;
        i = i + 1
    };
    i
}
```

+ continue 表达式跳过循环的其余部分并继续下一次迭代。 此循环使用continue来计算 1、2、...、n的总和，除非该数字能被7整除：
```move
fun sum_intermediate(n: u64): u64 {
    let sum = 0;
    let i = 0;
    while (i < n) {
        i = i + 1;
        if (i % 10 == 0) continue;
        sum = sum + i;
    };
    sum
}

```

## 4.abort & assert
### 4.1 abort是一个带有一个参数的表达式：u64 类型的中止代码。
### 4.2 assert是Move编译器提供的内置的类似宏的操作。它有两个参数，一个bool类型的条件和一个u64类型的代码。

> assert!(condition, value)   condition为false时抛出value

```move
public fun test_abort(a: u8) {
    if (a > 10)
        abort 10;
    assert!(a > 5, 5)
}
```





---

> 至此我们已经学会了使用move语言定义一个函数，在函数体中实现复杂的流程控制逻辑。接下来我们开始move的高级类型。
