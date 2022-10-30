module sender::Math {
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    public fun subtract(a: u64, b: u64): u64 {
        if (a < b) {
            return 0u64
        };
        a - b
    }

    public fun multiply(a: u64, b: u64): u128 {
        (a * b as u128)
    }

    public fun divide(a: u64, b: u64): u64 {
        assert!(b != 0, 100);
        a / b
    }


    public fun mod(a: u64, b: u64): u64 {
        assert!(b != 0, 100);
        a % b
    }
}
