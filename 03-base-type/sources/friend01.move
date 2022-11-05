module sender::friend01 {
    friend sender::friend02;
    public(friend) fun add(a: u64, b: u64): u64 {
        a + b
    }

    public fun subtract(a: u64, b: u64): u64 {
        if (a > b) {
            return a + b
        };
        0
    }
}
