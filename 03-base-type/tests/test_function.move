#[test_only]
module sender::test_function {
    use sender::Math;
    use aptos_std::debug::print;
    use sender::Math as M;

    #[test]
    public fun test_math() {
        let sum = Math::add(1, 1);
        print(&sum);

        let subtract = Math::subtract(30, 20);
        print(&subtract);

        let multiply = Math::multiply(10, 10);
        print(&multiply);

        let divide = Math::divide(20, 2);
        print(&divide);

        let mod = Math::mod(10, 7);
        print(&mod);
    }


    #[test]
    public fun test_as() {
        let sum = M::add(1, 1);
        print(&sum);

        let subtract = M::subtract(30, 20);
        print(&subtract);

        let multiply = M::multiply(10, 10);
        print(&multiply);

        let divide = M::divide(20, 2);
        print(&divide);

        let mod = M::mod(10, 7);
        print(&mod);
    }
}
