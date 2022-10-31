#[test_only]
module sender::test_vector_signer {
    use std::vector;
    use aptos_std::debug::print;

    #[test]
    public fun test_vector() {
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
    }
}
