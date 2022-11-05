# move function & 流程控制

> 本教程是基于aptos搭建的move智能合约开发

## 1.move语言中函数的定义(学过编程语言的，这一小节其实很简单)

```move
[public] fun fun_name(params1: Type1, parmas2: Type2): (ReturnType1, ReturnType2){
    //fun body
}
```

**说明**
> + public用于访问控制，无public表示仅仅在module内部调用
>
> + 函数的入参可以是0个，也可以是多个
>
> + 函数的返回值可以是0个，也可以是多个，多个用()
>
> + 返回值注意不能加 **;**,**return**可写可不写
>

## 2.move语言中的函数可见性
### 2.1 ```public```
>```public```修饰的函数可以被任何模块或脚本中定义的任何函数调用。如以下示例所示，可以通过以下方式调用函数：
> + 在同一模块中定义的其他函数
> + 在另一个模块中定义的函数
> + 脚本中定义的函数

### 2.2 ```public(friend)```
>```public(friend)```可见性修饰符是一种更受限制的修饰符形式,可以通过以下方式调用函数：
> + 在同一模块中定义的其他函数
> + 在好友列表中明确指定的模块中定义的函数

[example]()
```move
module sender::friend01 {
    friend sender::friend02;
    public(friend) fun add(a:u64,b:u64):u64{
        a+b
    }
    public fun subtract(a:u64,b:u64):u64{
        if(a>b){
            return a+b
        };
        0
    }
}

module sender::friend02 {
    use sender::friend01;
    fun test_friend(){
        friend01::subtract(8,6);
        friend01::add(8,6); // 如果没有在friend01模块中声明 friend sender::friend02 ; 此函数将无法调用
    }
}
```

> ````friend````的声明规则
> + 模块不能将自身声明为friend
> + friend模块必须在同一个账户地址内
> + friend关系不能创建循环模块依赖关系
> + 不能将脚本声明为模块的友元,脚本中定义的函数永远不能调用public(friend)函数

```move
//1.模块不能将自身声明为friend
module sender::m{
    friend sender::m;//error
}
//2.friend模块必须在同一个账户地址内
module 0x1::m{
    friend 0x2::n;//error
}
module 0x2::n{
}
//3.friend关系不能创建循环模块依赖关系
module 0x1::a{
    friend 0x2::b;
}
module 0x2::b{
    friend 0x2::c;
}
module 0x2::c{
    friend 0x2::a;
}
```

### 2.2 ```entry```
> entry 修饰符旨在允许像脚本一样安全直接地调用模块函数。 
> 这允许模块编写者指定哪些函数可以开始执行。 然后，模块编写者知道任何非入口函数都将从已经在执行的```Move```程序中调用。
> 但请注意，其他```Move```函数仍然可以调用入口函数。 因此，虽然它们可以作为 Move 程序的开始，但它们并不局限于这种情况。

----

## 3. as关键字用法

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

## 4.流程控制
### 4.1 if 判断
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

### 4.2 while & loop
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

### 4.3 break & continue
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

## 5.abort & assert
### 5.1 abort是一个带有一个参数的表达式：u64 类型的中止代码。
### 5.2 assert是Move编译器提供的内置的类似宏的操作。它有两个参数，一个bool类型的条件和一个u64类型的代码。

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
