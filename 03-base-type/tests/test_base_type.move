#[test_only]
module sender::test_base_typemove {
    use aptos_std::debug::print;




    #[test]
    fun test_base_type_init() {
        let a = true;
        let x: u64 = 666;
        let y = 888u128;
        let account: address;
        account = @0x1;

        print(&a);
        print(&x);
        print(&y);
        print(&account);
    }


    #[test]
    fun test() {
        // let x = 10;//auto inferred: u8
        // let y = 1000;//auto inferred: u64
        //
        // let explicit_u8 = 1u8;
        // let explicit_u64 = 2u64;
        // let explicit_u128 = 3u128;
        //
        // let simple_u8: u8 = 1;
        // let simple_u64: u64 = 200;
        // let simple_u128: u128 = 99999;
        //
        // let complex_u8 = 8; // inferred: u8
        // let _unused = 10 << complex_u8;
        //
        // let x: u8 = 38;
        // let complex_u8 = 2; // inferred: u8
        // let _unused = x + complex_u8;
        //
        // let hex_u8: u8 = 0x1;
        // let hex_u64: u64 = 0xAOB;
        let hex_u128: u128 = 0xABCDEF;
        print(&hex_u128)
    }


    #[test]
    fun test_bool() {
        let a = true;
        let flag: bool = false;
        print(&a);
        print(&flag);
    }


    #[test]
    fun test_address() {
        let a: address = @0x1;
        let b: address = @sender;  //sender in Move.toml
        print(&a);
        print(&b);
    }
}
