module 0x1::helloworld {
    use aptos_std::debug::print;

    public fun hello() {
        print(&b"hello world");
    }
}
