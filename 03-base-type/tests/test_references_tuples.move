#[test_only]
module sender::test_references_tuples {

    use aptos_std::debug::print;

    fun swap(a: &mut u8, b: &mut u8) {
        let c = *a;
        *a = *b;
        *b = c;
    }

    #[test]
    public fun test_swap() {
        let a = 10;
        let b = 20;
        print(&a);
        print(&b);
        swap(&mut a, &mut b);
        print(&a);
        print(&b);
    }


    fun hello_tuple(): (u64, bool, address) {
        let a = 10u64;
        let b = false;
        (a, b, @sender)
    }

    #[test]
    public fun test_tuples() {
        let (a, b, c) = hello_tuple();
        print(&a);
        print(&b);
        print(&c);

    }
}
