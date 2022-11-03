#[test_only]
module sender::test_struct_resource {

    use sender::Coin;
    use std::string;
    use aptos_std::debug::print;
    use sender::MyCoin;
    use std::signer;

    #[test]
    public fun test_struct() {
        let coin = Coin::new_CoinInfo(string::utf8(b"test"), string::utf8(b"T"));
        print(&coin);
        Coin::setSupply(&mut coin, 100);
        print(&coin);
    }

    struct Foo { x: u64, y: bool }

    struct Bar { foo: Foo }

    struct Baz {}

    #[test]
    fun example_destroy_foo_assignment() {
        let x: u64;
        let y: bool;
        Foo { x, y } = Foo { x: 3, y: false };
        print(&x);
        print(&y);
        x = 4;
        y = true;
        print(&x);
        print(&y);
    }


    #[test(from = @from, to = @to)]
    fun test_refrence(from: signer, to: signer) {
        MyCoin::init_Wallet(&from);
        MyCoin::init_Wallet(&to);

        MyCoin::balanceOf(signer::address_of(&from));
        MyCoin::balanceOf(signer::address_of(&to));

        MyCoin::deposit(&from, 100);
        MyCoin::balanceOf(signer::address_of(&from));

        MyCoin::transfer(&from, &to, 10);

        MyCoin::balanceOf(signer::address_of(&from));
        MyCoin::balanceOf(signer::address_of(&to));

        print(&MyCoin::existWallet(signer::address_of(&from)));
        print(&MyCoin::existWallet(signer::address_of(&to)));

        MyCoin::destory(signer::address_of(&from));
        MyCoin::destory(signer::address_of(&to));

        print(&MyCoin::existWallet(signer::address_of(&from)));
        print(&MyCoin::existWallet(signer::address_of(&to)));
    }


    // #[test(from = @from)]
    // fun test_dangling(from: signer) {
        // dangling::borrow_then_remove_bad(signer::address_of(&from));
    // }

}
