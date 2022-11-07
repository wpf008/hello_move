module sender::FirstToken {
    use std::signer;
    use std::string;
    use aptos_framework::account;
    use aptos_framework::event;

    struct DepositEvent has drop, store {
        amount: u128,
    }

    struct WithdrawEvent has drop, store {
        amount: u128,
    }

    struct Coin has store {
        value: u128
    }

    struct CoinStore has key {
        coin: Coin,
        deposit_events: event::EventHandle<DepositEvent>,
        withdraw_events: event::EventHandle<WithdrawEvent>,
    }

    struct CoinInfo has key {
        name: string::String,
        symbol: string::String,
        decimals: u8,
        supply: u128,
        cap: u128,
    }


    const OWNER: address = @sender;

    const REGISTERED: u64 = 1;

    const INVALID_OWNER: u64 = 2;

    const THE_ACCOUNT_IS_NOT_REGISTERED: u64 = 3;

    const INSUFFICIENT_BALANCE: u64 = 4;

    const ECOIN_INFO_ALREADY_INIT: u64 = 5;

    const EXCEEDING_THE_TOTAL_SUPPLY: u64 = 6;

    public entry fun initialize(
        address: &signer,
        name: string::String,
        symbol: string::String,
        decimals: u8,
        supply: u128
    ) {
        assert!(signer::address_of(address) == OWNER, INVALID_OWNER);
        assert!(!exists<CoinInfo>(OWNER), ECOIN_INFO_ALREADY_INIT);
        move_to(address, CoinInfo {  name, symbol, decimals, supply, cap: 0 });
    }

    fun deposit(account_addr: address, coin: Coin) acquires CoinStore {
        assert!(exists_coin(account_addr), THE_ACCOUNT_IS_NOT_REGISTERED);
        let balance = getBalance(account_addr);
        let coin_store = borrow_global_mut<CoinStore>(account_addr);
        let balance_ref = &mut coin_store.coin.value;
        *balance_ref = balance + coin.value;
        event::emit_event(&mut coin_store.withdraw_events,WithdrawEvent { amount: coin.value });
        let Coin { value: _ } = coin;
    }


    fun withdraw(account_addr: address, amount: u128): Coin acquires CoinStore {
        assert!(exists_coin(account_addr), THE_ACCOUNT_IS_NOT_REGISTERED);
        let balance = getBalance(account_addr);
        assert!(balance >= amount, INSUFFICIENT_BALANCE);
        let coin_store = borrow_global_mut<CoinStore>(account_addr);
        let balance_ref = &mut coin_store.coin.value;
        *balance_ref = balance - amount;
        event::emit_event(&mut coin_store.withdraw_events,WithdrawEvent {amount});
        Coin { value: amount }
    }

    public entry fun transfer(from: &signer, to: address, amount: u128) acquires CoinStore {
        let coin = withdraw(signer::address_of(from), amount);
        deposit(to, coin);
    }


    public entry fun burn(owner: &signer, amount: u128) acquires CoinStore, CoinInfo {
        assert!(signer::address_of(owner) == OWNER, INVALID_OWNER);
        let coin = withdraw(signer::address_of(owner), amount);
        let Coin { value: amount } = coin;
        let cap = &mut borrow_global_mut<CoinInfo>(OWNER).cap;
        *cap = *cap - amount;
        let supply = &mut borrow_global_mut<CoinInfo>(OWNER).supply;
        *supply = *supply - amount;
    }

    public entry fun mint(owner: &signer, to: address, amount: u128) acquires CoinStore, CoinInfo {
        assert!(signer::address_of(owner) == OWNER, INVALID_OWNER);
        assert!(
            borrow_global<CoinInfo>(OWNER).cap + amount <= borrow_global<CoinInfo>(OWNER).supply,
            EXCEEDING_THE_TOTAL_SUPPLY
        );
        deposit(to, Coin { value: amount });
        let cap = &mut borrow_global_mut<CoinInfo>(OWNER).cap;
        *cap = *cap + amount;
    }


    public fun getBalance(owner: address): u128 acquires CoinStore {
        assert!(exists_coin(owner), THE_ACCOUNT_IS_NOT_REGISTERED);
        borrow_global<CoinStore>(owner).coin.value
    }

    public entry fun register(address: &signer) {
        let account = signer::address_of(address);
        assert!(!exists<CoinStore>(account), REGISTERED);
        move_to(address, CoinStore {
            coin: Coin { value: 0 },
            deposit_events: account::new_event_handle<DepositEvent>(address),
            withdraw_events: account::new_event_handle<WithdrawEvent>(address)
        });
    }

    public fun exists_coin(account_addr: address): bool {
        exists<CoinStore>(account_addr)
    }
}