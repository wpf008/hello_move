# move function

> 本教程是基于aptos搭建的move智能合约开发

## 1.move语言中函数的定义(学过编程语言的，这一小节其实很简单)
```move
[public] fun fun_name(params1:Type1,parmas2:Type2):(ReturnType1,ReturnType2){
       // fun body
}
```
**说明**
> public 用于访问控制，无public表示仅仅在module内部调用
> 
> 函数的入参可以是0个，也可以是多个
> 
> 函数的返回值可以是0个，也可以是多个，多个用()
> 
> 返回值注意不能加 **;**,**return**可写可不写


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


---

> 至此move的环境搭建是否成功已得到验证且使用move语言开发helloworld程序已经完成，接下来我们开始move基本语法。
