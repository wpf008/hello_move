from aptos_sdk.client import RestClient
from aptos_sdk.account import Account
from aptos_sdk.account_address import AccountAddress
from aptos_sdk.transactions import TransactionArgument, EntryFunction, TransactionPayload
from aptos_sdk.bcs import Serializer

TEST_NODE = 'https://fullnode.testnet.aptoslabs.com/v1'
rest_client = RestClient(TEST_NODE)
resource_type = "0x1aade402e3a2ddd9ba391c819765956cabad4d5bee6f9ce65be724ca108c7c8f::FirstToken::CoinStore"
function_id = "0x1aade402e3a2ddd9ba391c819765956cabad4d5bee6f9ce65be724ca108c7c8f::FirstToken"


# 发布合约
def publish_first_token(account: Account):
    module_path = 'FirstToken.mv'  # 自己的文件路径
    metadata_path = 'package-metadata.bcs'  # 自己的文件路径
    with open(module_path, "rb") as f:
        module = f.read()
    with open(metadata_path, "rb") as f:
        metadata = f.read()
    print("\nPublishing FirstToken package.")
    txn_hash = rest_client.publish_package(account, metadata, [module])
    rest_client.wait_for_transaction(txn_hash)
    print(txn_hash)


# 初始化代币信息
def initialize(acc: Account):
    transaction_arguments = [TransactionArgument('Kobe#Bryant', Serializer.str),
                             TransactionArgument('Kobe', Serializer.str),
                             TransactionArgument(8, Serializer.u8),
                             TransactionArgument(3364300000000, Serializer.u128)]
    payload = EntryFunction.natural(function_id, "initialize", [], transaction_arguments)
    signed_transaction = rest_client.create_single_signer_bcs_transaction(acc, TransactionPayload(payload))
    txn_hash = rest_client.submit_bcs_transaction(signed_transaction)
    rest_client.wait_for_transaction(txn_hash)
    print(txn_hash)


# 注册资源
def register(acc: Account):
    transaction_arguments = []
    payload = EntryFunction.natural(function_id, "register", [], transaction_arguments)
    signed_transaction = rest_client.create_single_signer_bcs_transaction(acc, TransactionPayload(payload))
    txn_hash = rest_client.submit_bcs_transaction(signed_transaction)
    rest_client.wait_for_transaction(txn_hash)
    print(txn_hash)


# 铸造代币
def mint(_from: Account, _to: AccountAddress,amount:int):
    transaction_arguments = [
        TransactionArgument(_to, Serializer.struct),
        TransactionArgument(amount, Serializer.u128),
    ]
    payload = EntryFunction.natural(function_id, "mint", [], transaction_arguments)
    signed_transaction = rest_client.create_single_signer_bcs_transaction(_from, TransactionPayload(payload))
    txn_hash = rest_client.submit_bcs_transaction(signed_transaction)
    rest_client.wait_for_transaction(txn_hash)
    print(txn_hash)


# 转账
def transfer(_from: Account, _to: AccountAddress,amount:int):
    transaction_arguments = [
        TransactionArgument(_to, Serializer.struct),
        TransactionArgument(amount, Serializer.u128),
    ]
    payload = EntryFunction.natural(function_id, "transfer", [], transaction_arguments)
    signed_transaction = rest_client.create_single_signer_bcs_transaction(_from, TransactionPayload(payload))
    txn_hash = rest_client.submit_bcs_transaction(signed_transaction)
    rest_client.wait_for_transaction(txn_hash)
    print(txn_hash)


# 获取余额
def get_balance(account_address: AccountAddress):
    balance = rest_client.account_resource(
        account_address,
        resource_type
    )
    print(balance["data"]["coin"]["value"])

# 主函数
if __name__ == "__main__":
    alice = Account.load("alice.txt")  # 请自行配置合约部署对应的私钥
    bob = Account.load('bob.txt')  # 请自行配置转账的私钥
    # publish_first_token(alice); #alice 部署合约 只需执行一次

    # initialize(alice)  # 初始化代币信息 必须是合约部署者 只需执行一次

    # register(alice);    #alice生产CoinStore资源 只需执行一次
    # register(bob);      #bob生产CoinStore资源 只需执行一次

    # mint(alice,alice.account_address,88888888)
    # get_balance(alice.account_address)

    # transfer(alice,bob.account_address,6666666)
    get_balance(alice.account_address)
    get_balance(bob.account_address)
