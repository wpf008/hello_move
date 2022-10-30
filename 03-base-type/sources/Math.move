module sender::Math {
    use aptos_std::debug::print;

    public fun add(a: u64, b: u64): u64 {
        if (a > 10) {} else if (b > 10) {};
        a + b
    }

    public fun subtract(a: u64, b: u64): u64 {
        if (a < b) {
            return 0
        };
        return a - b
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

    public fun sum_while(n: u64): u64 {
        let sum = 0;
        let i = 1;
        while (i <= n) {
            sum = sum + i;
            i = i + 1
        };
        print(&sum);
        sum
    }

    public fun sum_loop(n: u64): u64 {
        let sum = 0;
        let i = 0;
        loop {
            i = i + 1;
            if (i > n) break;
            sum = sum + i
        };
        print(&sum);
        sum
    }

    public fun smallest_factor(n: u64): u64 {
        let i = 2;
        while (i <= n) {
            if (n % i == 0) break;
            i = i + 1
        };
        print(&i);
        i
    }

    public fun sum_intermediate(n: u64): u64 {
        let sum = 0;
        let i = 0;
        while (i < n) {
            i = i + 1;
            if (i % 7 == 0) continue;
            sum = sum + i;
        };
        print(&sum);
        sum
    }


    public fun test_abort(a: u8) {
        if (a > 10)
            abort 10;
        assert!(a > 5, 5)
    }
}
