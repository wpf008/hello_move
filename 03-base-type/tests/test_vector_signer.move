#[test_only]
module sender::test_vector_signer {
    use std::vector;
    use aptos_std::debug::print;

    #[test]
    public fun test_vector() {
        let a = vector<u8>[1, 2, 4, 5, 6, 7, 1];
        print(&a);
        vector::remove(&mut a, 1);
        print(&a)
    }
}
