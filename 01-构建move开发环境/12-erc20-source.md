# ```move```进阶:```move```实现```ERC20```代币源码解读

## 1.```ERC20```合约解读

> ```ERC20（Ethereum Request for Comments 20）```
> 一种代币标准。[EIP-20](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md) 中提出。
> ERC20代币合约跟踪同质化（可替代）代币：任何一个代币都完全等同于任何其他代币；没有任何代币具有与之相关的特殊权利或行为。这使得ERC20代币可用于交换货币、投票权、质押等媒介。

```solidity
pragma solidity ^0.4.24;
/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {

    function totalSupply() external view returns (uint256);//代币发行数量。

    function balanceOf(address who) external view returns (uint256);//返回该地址的代币数量。

    function transfer(address to, uint256 value) external returns (bool);//调用者想to转账

    //allowance, approve, transferFrom 支持如授权其他一些以太坊地址代表各自的持有人使用代币的高级功能
    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);//调用transfer方法触发的转移事件

    event Approval(address indexed owner, address indexed spender, uint256 value);//调用approve方法触发的转移事件
}
```

## 2.```move```实现```ERC20```代币解读

> ```move```语言最大的特色就是面向资源编程。用户的所有资源都存在自己的账户下面，只有持有该资源的账户可以对资源进行操作，如转移，销毁等。
>
> ![image](../asset/first_token_resource.png)


> 合约源码

```move
module sender::FirstToken {
    use std::signer;
    use std::string;
    use aptos_framework::account;
    use aptos_framework::event;

    //DepositEvent:在调用deposit时触发这个事件，aptos中的事件将会在AptosFramwork核心源码解读
    //相当于:event Transfer(address indexed from, address indexed to, uint256 value);
    struct DepositEvent has drop, store {
        amount: u128,
    }

    //WithdrawEvent
    struct WithdrawEvent has drop, store {
        amount: u128,
    }

    //每个持有FirstToken代币的数量都会存储在这个数据机构中
    //相当于solidity mapping(address => uint256) private _balances;
    struct Coin has store {
        value: u128
    }

    struct CoinStore has key {
        coin: Coin,
        deposit_events: event::EventHandle<DepositEvent>,
        withdraw_events: event::EventHandle<WithdrawEvent>,
    }

    //Token基本信息,相当于ERC20中的下面的字段
    // uint256 private _totalSupply;
    //string private _name;
    //string private _symbol;
    //uint8 private _decimals;
    struct CoinInfo has key {
        name: string::String,
        symbol: string::String,
        decimals: u8,
        supply: u128,
        cap: u128,//当前代币发行数量。满足cap<=supply
    }

    //权限控制
    const OWNER: address = @sender;

    const REGISTERED: u64 = 1;

    const INVALID_OWNER: u64 = 2;

    const THE_ACCOUNT_IS_NOT_REGISTERED: u64 = 3;

    const INSUFFICIENT_BALANCE: u64 = 4;

    const ECOIN_INFO_ALREADY_INIT: u64 = 5;

    const EXCEEDING_THE_TOTAL_SUPPLY: u64 = 6;

    //FirstToken代币基本信息初始化
    //合约外部函数
    public entry fun initialize(
        address: &signer,
        name: string::String,
        symbol: string::String,
        decimals: u8,
        supply: u128
    ) {
        assert!(signer::address_of(address) == OWNER, INVALID_OWNER);//只有合约部署者有权限设置
        assert!(!exists<CoinInfo>(OWNER), ECOIN_INFO_ALREADY_INIT);//initialize已经调用过，就无法在调用
        move_to(address, CoinInfo { name, symbol, decimals, supply, cap: 0 });//初始化代币基本信息，并将其存入合约部署者的地址下
    }

    //account_addr账户存入代币
    //在操作相应资源时需要加:acquires CoinStore
    //合约内部函数
    fun deposit(account_addr: address, coin: Coin) acquires CoinStore {
        assert!(
            exists_coin(account_addr),
            THE_ACCOUNT_IS_NOT_REGISTERED
        );//account_addr下必须已经调用register方法，拥有CoinStore这个资源
        let balance = getBalance(account_addr);//当前账户余额
        let coin_store = borrow_global_mut<CoinStore>(account_addr);//拿到当前账户CoinStore资源
        let balance_ref = &mut coin_store.coin.value;//账户余额的可变引用
        *balance_ref = balance + coin.value;//存入代币
        event::emit_event(&mut coin_store.deposit_events, DepositEvent { amount: coin.value }); //触发DepositEvent事件
        let Coin { value: _ } = coin;//传过来的coin资源进行销毁,Coin { value: _ } 下划线表示不接受任何资源，coin赋值给左边即销毁资源
    }

    //account_addr账户取出代币
    //合约内部函数
    fun withdraw(account_addr: address, amount: u128): Coin acquires CoinStore {
        assert!(
            exists_coin(account_addr),
            THE_ACCOUNT_IS_NOT_REGISTERED
        );//account_addr下必须已经调用register方法，拥有CoinStore这个资源
        let balance = getBalance(account_addr);//当前账户余额
        assert!(balance >= amount, INSUFFICIENT_BALANCE);//判断余额是否充足
        let coin_store = borrow_global_mut<CoinStore>(account_addr);//拿到当前账户CoinStore资源
        let balance_ref = &mut coin_store.coin.value;//账户余额的可变引用
        *balance_ref = balance - amount;//扣钱余额
        event::emit_event(&mut coin_store.withdraw_events, WithdrawEvent { amount });//触发WithdrawEvent事件
        Coin { value: amount } //返回取出的代币
    }


    //转账
    public entry fun transfer(from: &signer, to: address, amount: u128) acquires CoinStore {
        let coin = withdraw(signer::address_of(from), amount);//先从转账人账户中取出代币
        deposit(to, coin);//充值到收款人的账户中
    }

    //销毁代币
    public entry fun burn(owner: &signer, amount: u128) acquires CoinStore, CoinInfo {
        assert!(signer::address_of(owner) == OWNER, INVALID_OWNER);//必须是合约创建者
        let coin = withdraw(signer::address_of(owner), amount);//取出要销毁的代币
        let Coin { value: amount } = coin;//销毁代币
        let cap = &mut borrow_global_mut<CoinInfo>(OWNER).cap;
        *cap = *cap - amount;//扣除当前代币发行数量
        let supply = &mut borrow_global_mut<CoinInfo>(OWNER).supply;
        *supply = *supply - amount;//扣除总供应量
    }

    //为to地址铸造代币
    public entry fun mint(owner: &signer, to: address, amount: u128) acquires CoinStore, CoinInfo {
        assert!(signer::address_of(owner) == OWNER, INVALID_OWNER);//必须是合约创建者
        assert!(
            borrow_global<CoinInfo>(OWNER).cap + amount <= borrow_global<CoinInfo>(OWNER).supply,
            EXCEEDING_THE_TOTAL_SUPPLY
        );//不能大于总发行量
        deposit(to, Coin { value: amount });//存入对应账户
        let cap = &mut borrow_global_mut<CoinInfo>(OWNER).cap;
        *cap = *cap + amount;//变更当前代币发行数量
    }

    //获取余额
    public fun getBalance(owner: address): u128 acquires CoinStore {
        assert!(exists_coin(owner), THE_ACCOUNT_IS_NOT_REGISTERED);
        borrow_global<CoinStore>(owner).coin.value
    }

    //注册资源
    public entry fun register(address: &signer) {
        let account = signer::address_of(address);
        assert!(!exists<CoinStore>(account), REGISTERED);//每个账户只能初始化一次
        move_to(address, CoinStore {
            coin: Coin { value: 0 },   // 初始化代币资源，数量默认为0
            deposit_events: account::new_event_handle<DepositEvent>(address), //初始化事件
            withdraw_events: account::new_event_handle<WithdrawEvent>(address) //初始化事件
        });
    }

    //判读资源是否存在
    public fun exists_coin(account_addr: address): bool {
        exists<CoinStore>(account_addr)
    }
}
```

----
> 至此我们完成了一个标准的ERC20合约源码分析，我们将使用```aptos```,接下来将使用```Python SDK```与合约交互。










