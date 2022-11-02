#[test_only]
module sender::test_struct_resource {

    use sender::Coin;
    use std::string;
    use aptos_std::debug::print;

    #[test]
    public fun test_struct() {
        let coin = Coin::new_CoinInfo(string::utf8(b"test"), string::utf8(b"T"));
        print(&coin);
        Coin::setSupply(&mut coin,100);
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
}
