module sender::dangling {
    // use aptos_std::debug::print;
    //
    // struct T has key, drop { f: u64 }
    //
    // public fun borrow_then_remove_bad(a: address) acquires T {
    //     let t_ref: &mut T = borrow_global_mut<T>(a);
    //     // type system complains here
    //     let t = remove_t(a);
    //     print(&t);
    //     // t_ref now dangling!
    //     let uh_oh = *&t_ref.f;
    //     print(&uh_oh);
    // }
    //
    // fun remove_t(a: address): T acquires T {
    //     move_from<T>(a)
    // }
    //
    // #[test]
    // fun test_dangling() acquires T {
    //     borrow_then_remove_bad(@sender);
    // }
}
