#[test_only]
module 0x1::test_helloworld {
    use 0x1::helloworld;

    #[test]
    public fun helloworld(){
        helloworld::hello();
    }
}
