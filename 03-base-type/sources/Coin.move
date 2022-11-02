module sender::Coin {
    use std::string;

    struct OtherInfo has copy, store, drop {}

    struct CoinInfo<T> has copy, store, drop {
        name: string::String,
        symbol: string::String,
        decimals: T,
        supply: u128,
        cap: u128,
        otherInfo: OtherInfo,
    }

    public fun new_CoinInfo(name: string::String, symbol: string::String): CoinInfo<u8> {
        let otherInfo = OtherInfo {};
        let coin = CoinInfo<u8> {
            name, symbol, decimals: 10, supply: 10, cap: 10, otherInfo
        };
        coin
    }

    public fun setSupply(coinInfo: &mut CoinInfo<u8>, supply: u128) {
        coinInfo.supply = supply;
    }

    struct A<phantom T>{
        a:T;
    }


}
