module sender::MyResources_v2 {
    // use std::vector;
    // use std::signer;
    // use std::string;
    // use aptos_std::debug::print;
    //
    // struct Coin has copy, store, drop {
    //     value: u64,
    //     name: string::String
    // }
    //
    // struct Wallet has key, store {
    //     coins: vector<Coin>
    // }
    //
    // public fun new_coin(value: u64, name: string::String): Coin {
    //     Coin { value, name }
    // }
    //
    //
    // //create a resource wallet
    // public fun create_Wallet(signer: &signer) {
    //     if (!exists<Wallet>(signer::address_of(signer))) {
    //         move_to<Wallet>(signer, Wallet {
    //             coins: vector::empty<Coin>()
    //         });
    //     };
    // }
    //
    //
    // public fun existWallet(add: address): bool {
    //     exists<Wallet>(add)
    // }
    //
    // public fun deposit(coin: Coin, add: address)acquires Wallet {
    //     if (exists<Wallet>(add)) {
    //         let wallet = borrow_global_mut<Wallet>(add);
    //         let coins = wallet.coins;
    //         if (vector::is_empty(&coins)) {
    //             vector::push_back(&mut coins, coin);
    //             wallet.coins = coins;
    //         }else {
    //             let x = 0 ;
    //             let len = vector::length(&coins);
    //             let flag = false;
    //             while (x < len) {
    //                 let c = vector::borrow_mut(&mut coins, x);
    //                 if (c.name == coin.name) {
    //                     flag = true;
    //                     let value = c.value + coin.value;
    //                     let new = new_coin(value, c.name);
    //                     vector::remove(&mut coins, x);
    //                     vector::push_back(&mut coins, new);
    //                     wallet.coins = coins;
    //                     break
    //                 };
    //                 x = x + 1;
    //             };
    //             if (!flag) {
    //                 vector::push_back(&mut coins, coin);
    //                 wallet.coins = coins;
    //             }
    //         }
    //     }
    // }
    //
    //
    // public fun withdraw(add: address) acquires Wallet{
    //
    // }
    //
    // public fun wallet_info(add: address) acquires Wallet {
    //     if (exists<Wallet>(add)) {
    //         let wallet = borrow_global<Wallet>(add);
    //         print(&wallet.coins);
    //     }
    // }
}
