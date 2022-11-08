from aptos_sdk.client import RestClient
from aptos_sdk.account import Account
from aptos_sdk.account_address import AccountAddress
from aptos_sdk.transactions import TransactionArgument, EntryFunction, TransactionPayload
from aptos_sdk.bcs import Serializer

TEST_NODE = 'https://fullnode.testnet.aptoslabs.com/v1'
rest_client = RestClient(TEST_NODE)
resource_type = "0xf068e8d56201ed146349ca2d9b0181030b5ec0f3c969b8e2373c82c8bc6a036d::FirstToken::CoinStore"
function_id = "0xf068e8d56201ed146349ca2d9b0181030b5ec0f3c969b8e2373c82c8bc6a036d::FirstToken"

# 获取余额
def get_balance(account_address: AccountAddress) -> str:
    balance = rest_client.account_resource(
        account_address,
        resource_type
    )
    return balance["data"]["coin"]["value"]

# 注册资源
def register(acc: Account) -> str:
    transaction_arguments = []
    payload = EntryFunction.natural(function_id,"register",[],transaction_arguments)
    signed_transaction = rest_client.create_single_signer_bcs_transaction(acc, TransactionPayload(payload))
    txn_hash = rest_client.submit_bcs_transaction(signed_transaction)
    rest_client.wait_for_transaction(txn_hash)
    return txn_hash

# 铸造代币
def mint(_from: Account, _to: AccountAddress) -> str:
    transaction_arguments = [
        TransactionArgument(_to, Serializer.struct),
        TransactionArgument(5000, Serializer.u128),
    ]
    payload = EntryFunction.natural(function_id,"mint",[],transaction_arguments)
    signed_transaction = rest_client.create_single_signer_bcs_transaction(_from, TransactionPayload(payload))
    txn_hash = rest_client.submit_bcs_transaction(signed_transaction)
    rest_client.wait_for_transaction(txn_hash)
    return txn_hash

#主函数
if __name__ == "__main__":
    account_address = AccountAddress.from_hex(
        '0xf068e8d56201ed146349ca2d9b0181030b5ec0f3c969b8e2373c82c8bc6a036d')
    balance = get_balance(account_address)
    print(balance)
    _from = Account.load("alice.txt")#请自行配置合约部署对应的私钥
    _to = Account.load('bob.txt')#请自行配置转账的私钥
    # tx_hash = register(_to)#只需要注册一次
    # print(tx_hash)
    # tx_hash = mint(_from, _to.account_address)
    # print(tx_hash)
    bob_balance = get_balance(_to.account_address)
    print(bob_balance)
