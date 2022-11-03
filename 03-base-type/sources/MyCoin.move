module sender::MyCoin {
    use std::signer;
    use std::string;
    use aptos_std::debug::print;

    struct Coin has key, copy, store, drop {
        value: u64,
        name: string::String
    }

    struct Wallet has key, store,drop {
        coin: Coin
    }

    public fun new_coin(value: u64, name: string::String): Coin {
        Coin { value, name }
    }

    //create a resource wallet
    public fun init_Wallet(signer: &signer) {
        if (!exists<Wallet>(signer::address_of(signer))) {
            move_to<Wallet>(signer, Wallet {
                coin: Coin {
                    value: 0,
                    name: string::utf8(b"APT")
                }
            });
        };
    }

    public fun deposit(signer: &signer, amount: u64) acquires Wallet {
        if (!existWallet(signer::address_of(signer))) {
            init_Wallet(signer)
        };
        let wallet = borrow_global_mut<Wallet>(signer::address_of(signer));
        wallet.coin.value = wallet.coin.value + amount;
    }


    public fun existWallet(addr: address): bool {
        exists<Wallet>(addr)
    }

    public fun transfer(from: &signer, to: &signer, amount: u64) acquires Wallet {
        if (exists<Wallet>(signer::address_of(from))) {
            let wallet = borrow_global_mut<Wallet>(signer::address_of(from));
            if (wallet.coin.value >= amount) {
                wallet.coin.value = wallet.coin.value - amount;
                deposit(to, amount);
            }
        }
    }


    public fun destory(add: address) acquires Wallet {
        move_from<Wallet>(add);
    }

    public fun balanceOf(add: address) acquires Wallet {
        if (exists<Wallet>(add)) {
            let wallet = borrow_global<Wallet>(add);
            print(&wallet.coin.value);
        }
    }
}
