#[test_only]
module sender::test_ownership {
    use aptos_std::debug::print;
    fun add(a: u64, b: u64):u64 {
        a+b
    }
    #[test]
    fun test_ownership() {
        let a = 20;
        let b = 10;
        let c = add(move a, b);
        // print(&a);//error Invalid usage of previously moved variable 'a'.
        print(&b);
        print(&c);
    }
}
