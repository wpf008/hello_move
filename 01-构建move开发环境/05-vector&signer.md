# move vector & string & signer

> 本教程是基于aptos搭建的move智能合约开发

## 1.vector

### 1.1 vector<T>是Move提供的唯一原始集合类型。可以放一系列同类型T的数据的集合

### 1.2 vector的初始化

```move
let a = vector<u8>[];                   //创建一个可以存储类型T的vector
let b = vector<bool>[true, false];      //创建一个可以存储类型T的vector;  也可以简写成 let b = vector[true, false];
let c = vector::empty<u64>();           //创建一个可以存储类型T的vector
let d = vector::singleton(888u128);     //创建包含一个元素的vector
```

### 1.3 std::vector通过Move标准库中的模块支持以下操作:

| 方法                                                       | 描述                                                  | 是否会abort |
|:---------------------------------------------------------|:----------------------------------------------------|:---------|
| vector::empty<T>(): vector<T>                            | 创建一个可以存储类型值的集合T                                     | 不会       |
| vector::singleton<T>(t: T): vector<T>                    | 创建一个大小为1的集合，其中包含t                                   | 不会       |
| vector::length<T>(v: &vector<T>): u64                    | 返回集合的元素个数                                           | 不会       |
| vector::is_empty<T>(v: &vector<T>): bool                 | 集合的是否有元素                                            | 不会       |
| vector::push_back<T>(v: &mut vector<T>, t: T)            | 添加t到v的末尾                                            | 不会       |
| vector::pop_back<T>(v: &mut vector<T>): T                | 删除并返回最后一个元素                                         | 如果v为空    |
| vector::borrow<T>(v: &vector<T>, i: u64): &T             | 返回v对应索引i下的不可变元素                                     | 如果i不在范围内 |
| vector::borrow_mut<T>(v: &mut vector<T>, i: u64): &mut T | 返回v对应索引i下的可变元素                                      | 如果i不在范围内 |
| vector::destroy_empty<T>(v: vector<T>)                   | 删除集合v                                               | 如果v不为空   |
| vector::append<T>(v1: &mut vector<T>, v2: vector<T>)     | 将集合v2追加到v1的末尾                                       | 不会       |
| vector::contains<T>(v: &vector<T>, e: &T): bool          | 如果e在集合v中，则返回true,否则，返回false                         | 不会       |
| vector::swap<T>(v: &mut vector<T>, i: u64, j: u64)       | 交换集合v中第i索引和第j索引下的值                                  | 如果i或j超出范围 |
| vector::reverse<T>(v: &mut vector<T>)                    | 反转集合v中的元素                                           | 不会       |
| vector::index_of<T>(v: &vector<T>, e: &T): (bool, u64)   | e是否在集合中,若存在返回(true, i)。否则返回(false, 0)               | 绝不       |
| ector::remove<T>(v: &mut vector<T>, i: u64): T           | 删除集合v中第 i 个元素，并将后续元素全部向前移动。时间复杂度O(n)，但保留集合中元素的顺序    | 如果i超出范围  |
| vector::swap_remove<T>(v: &mut vector<T>, i: u64): T     | i将集合中第i个元素与最后一个元素交换，然后最后一个元素，时间复杂度O(1)，但不保留集合中元素的顺序 | 如果i超出范围  |
| vector::destroy_empty<T>(v: vector<T>)                   | 删除集合v                                               | 如果v不是空   |

> [example](https://github.com/wpf008/hello_move/blob/master/03-base-type/tests/test_vector_signer.move)

```move
let a = vector<u8>[1, 2, 3, 4, 5];

vector::push_back(&mut a, 6);
print(&a);//[1, 2, 3, 4, 5, 6]

let x = vector::pop_back(&mut a);
print(&x);//6

let y = vector::borrow(&a, 1);
// *y = 20;  //error  borrow with immutable  
print(y);//2

let z = vector::borrow_mut(&mut a, 2);
print(z); // 3
*z = 10; // correct
print(&a); // [1, 2, 10, 4, 5]


let b = vector::singleton(8);
vector::append(&mut a, b);
print(&a); //[1, 2, 10, 4, 5, 8]

let exist = vector::contains(&a, &8);
print(&exist); //true


vector::swap(&mut a, 3, 4);
print(&a);//[1, 2, 10, 5, 4, 8]

vector::reverse(&mut a);
print(&a);//[8, 4, 5, 10, 2, 1]


let (flag, index) = vector::index_of(&a, &10);
print(&flag);//true
print(&index);//3

vector::remove(&mut a, 3);
print(&a);//[8, 4, 5, 2, 1]

vector::swap_remove(&mut a, 0);
print(&a);//[1, 4, 5, 2]        
```

### 1.3 std::vector的其他操作

+ 遍历vector

```move
let index = 0;
let len = vector::length(&a);
while (index < len) {
    print(vector::borrow(&a, index));
    index = index + 1;
};
```

+ [vector排序](https://github.com/wpf008/hello_move/blob/master/03-base-type/tests/test_vector_signer.move)

> 插入排序。通过插入排序的案例可以很深刻的理解&、&mut、vector::borrow、vector::borrow_mut、*作用，希望大家能熟练掌握。

```move
public fun sort() {
    let v = vector<u64>[4, 3, 6, 2, 1];
    if (!vector::is_empty(&v)) {
        let current: u64 ;
        let length: u64 = vector::length(&v);
        let index: u64 = 0;
        while (index < length - 1) {
            current = *vector::borrow(&v, index + 1);  // * 解引用，拿到其值赋值给current
            let preIndex = index + 1; // index + 1 主要是因为move中没有负数
            let value = *vector::borrow(&v, preIndex - 1); //同理
            while (preIndex >= 1 && value > current) {
                let temp = vector::borrow_mut(&mut v, preIndex); // borrow_mut()拿到preIndex索引下的可修改引用
                *temp = value; //将value赋值给temp，即v[preIndex] = value
                preIndex = preIndex - 1;
                if(preIndex > 0){
                    value  = *vector::borrow(&v, preIndex-1);
                };
            };
            let temp = vector::borrow_mut(&mut v, preIndex);
            *temp = current;
            index = index + 1;
        };
    };
    print(&v);
}
```
> 冒泡排序
```
#[test_only]
module sender::test_sort {
    use std::vector::length;
    use std::vector;
    use aptos_std::debug;

    public fun sort(arr: vector<u8>) :vector<u8>{
        let index = 0;
        let size = length(&arr);
        while (index < size) {
            let innerIndex = index + 1;
            while (innerIndex < size) {
                let num0 = *vector::borrow(&mut arr, index);
                let innerNum = *vector::borrow(&arr, innerIndex);
                if (innerNum < num0) {
                    vector::swap(&mut arr, index, innerIndex);
                };
                innerIndex = innerIndex + 1;
            };
            index = index + 1;
        };
        arr
    }

    #[test]
    public fun test() {
        let a = vector<u8>[8, 3, 6, 2, 7, 1, 5];
        a = sort(a);
        debug::print(&a)
    }
}
```



+ std::string底层实现

```move
struct String has copy, drop, store {
    bytes: vector<u8>,
}
```

可以看到std::string的底层数据时使用vector<u8>存储的，string的相关操作都是调用了vector的标准方法去实现的。接下来我们会详细介绍。

----

## 2. std::string
### 2.1 string的实例化
```move
let x = b"hello world";
let s1 = string::utf8(x);
print(&s1);     //[104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100]
let y = vector<u8>[1,2,3,4,5,6];
let s2 = string::utf8(y);
print(&s2);     // [1, 2, 3, 4, 5, 6]
```

### 2.2 std::string通过Move标准库中的模块支持以下操作:

| 方法                                             | 描述                                      | 是否会abort    |
|:-----------------------------------------------|:----------------------------------------|:------------|
| utf8(bytes: vector<u8>): String                | 实例化一个字符编码为UTF的string                    | 不是UFT8编码的字符 |
| try_utf8(bytes: vector<u8>): Option<String>    | 实例化一个字符编码为UTF的string                    | 不会          |
| bytes(s: &String): &vector<u8>                 | 返回对基础字节向量的引用。                           | 不会          |
| is_empty(s: &String): bool                     | 字符串是否为空                                 | 不会          |
| length(s: &String): u64                        | 字符串长度                                   | 不会          |
| append(s: &mut String, r: String)              | 将字符串r追加到s                               | 不会          |
| append_utf8(s: &mut String, bytes: vector<u8>) | 将 vector<u8>追加到s                        | 不会          |
| insert(s: &mut String, at: u64, o: String)     | 在给定字符串的字节索引处插入另一个字符串。 索引必须是有效的 utf8 字符  | 不会          |
| index_of(s: &String, r: &String)               | 计算字符串第一次出现的索引。 如果未找到匹配项，则返回 `length(s)` | 不会          |
| sub_string(s: &String, i: u64, j: u64): String | 截取s[i，j)的字符串                            | 不会          |

> std::string的相关api建议自行练习一下
----

## 3. signer
> signer是一个内置的Move资源类型。signer是一种允许持有人代表特定address。signer值是特殊的，因为它们不能通过文字或指令创建，只能由 Move VM 创建。
>
> 在 VM 运行带有 type 参数的脚本之前signer，它会自动创建signer值并将它们传递给脚本。
>

```move
#[test(s = @sender)]  // @sender在Move.toml中定义，自动创建signer值并将它们传递给脚本
public fun test_signer(s: &signer) {
    print(s);
}
```

| 方法                                           | 描述                 | 是否会abort    |
|:---------------------------------------------|:-------------------|:------------|
| signer::borrow_address(s: &signer): &address | 返回此 &signer 中的地址引用 | 不会  |
| signer::address_of(s: &signer): address              | 返回此 &signer 中的地址 | 不会          |

```move
let a = signer::address_of(s);
print(&a);
let b = signer::borrow_address(s);
print(b);
```

> 此外，move_to<T>(&signer, T) 全局存储操作符需要一个&signer参数来在signer.address的帐户下发布资源T。 这确保了只有经过身份验证的用户才能选择在其地址下发布资源。


> **测试脚本如何传入参数将在接下来的测试脚本一节详细介绍**



----

> 本节我们学到了如何创建一个集合、如何操作集合中的元素、move中string的实现原理、已经相关API的介绍、signer类型的介绍。接下来我们继续学习move中的references & tuple.
