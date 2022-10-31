# move vector & signer

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
| 方法  | 描述                                                  | 是否会abort     |
|:----|:----------------------------------------------------|:-------------|
| vector::empty<T>(): vector<T> | 创建一个可以存储类型值的空向量T                                    | 不会           |
| vector::singleton<T>(t: T): vector<T> | 创建一个大小为1的向量，其中包含t                                   | 不会           |
| vector::push_back<T>(v: &mut vector<T>, t: T) | 添加t到v的末尾                                            | 不会           |
| vector::pop_back<T>(v: &mut vector<T>): T | 删除并返回最后一个元素                                         | 如果v为空        |
| vector::borrow<T>(v: &vector<T>, i: u64): &T | 返回v对应索引i下的不可变元素                                     | 如果i不在范围内     |
| vector::borrow_mut<T>(v: &mut vector<T>, i: u64): &mut T | 返回v对应索引i下的可变元素                                      | 如果i不在范围内     |
| vector::destroy_empty<T>(v: vector<T>) | 删除容器v                                               | 如果v不为空       |
| vector::append<T>(v1: &mut vector<T>, v2: vector<T>) | 将容器v2追加到v1的末尾                                       | 不会           |
| vector::contains<T>(v: &vector<T>, e: &T): bool | 如果e在容器v中，则返回true,否则，返回false                         | 不会           |
| vector::swap<T>(v: &mut vector<T>, i: u64, j: u64) | 交换容器v中第i索引和第j索引下的值                                  | 如果i或j超出范围    |
| vector::reverse<T>(v: &mut vector<T>) | 反转容器v中的元素                                           | 不会           |
| vector::index_of<T>(v: &vector<T>, e: &T): (bool, u64) | e是否在容器中,若存在返回(true, i)。否则返回(false, 0)               | 绝不           |
| ector::remove<T>(v: &mut vector<T>, i: u64): T | 删除容器v中第 i 个元素，并将后续元素全部向前移动。时间复杂度O(n)，但保留向量中元素的顺序    | 如果i超出范围      |
| vector::swap_remove<T>(v: &mut vector<T>, i: u64): T | i将容器中第i个元素与最后一个元素交换，然后最后一个元素，时间复杂度O(1)，但不保留向量中元素的顺序 | 如果i超出范围      |

> [example](https://github.com/wpf008/hello_move/blob/master/03-base-type/tests/test_vector_signer.move)
```move
let a = vector<u8>[1, 2, 3, 4, 5];

vector::push_back(&mut a, 6);
print(&a);//[1, 2, 3, 4, 5, 6]

let x = vector::pop_back(&mut a);
print(&x);//6

let y = vector::borrow(&a, 1);
// *y = 20;  //error
print(y);//2

let z = vector::borrow_mut(&mut a, 2);
print(z); // 3
*z = 10;
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

----

## 2. signer



----

> 本节我们学到了如何创建一个集合，如何操作集合中的元素。已经对signer类型的介绍。接下来我们继续学习move中的references & tuple.
