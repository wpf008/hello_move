# ```move```进阶:```python aptos-sdk```与```FirstToken```合约交互

## 1. 引入相关依赖，配置客户端

```python
from aptos_sdk.client import RestClient
from aptos_sdk.account import Account
from aptos_sdk.account_address import AccountAddress
from aptos_sdk.transactions import TransactionArgument, EntryFunction, TransactionPayload
from aptos_sdk.bcs import Serializer

TEST_NODE = 'https://fullnode.testnet.aptoslabs.com/v1'
rest_client = RestClient(TEST_NODE)
# 0xf068e8d56201ed146349ca2d9b0181030b5ec0f3c969b8e2373c82c8bc6a036d 请自己部署合约的地址
resource_type = "0xf068e8d56201ed146349ca2d9b0181030b5ec0f3c969b8e2373c82c8bc6a036d::FirstToken::CoinStore"
function_id = "0xf068e8d56201ed146349ca2d9b0181030b5ec0f3c969b8e2373c82c8bc6a036d::FirstToken"
```

## 2. 获取余额

```python
def get_balance(account_address: AccountAddress) -> str:
    balance = rest_client.account_resource(account_address,resource_type)
    return balance["data"]["coin"]["value"]
```

## 4. 注册资源

```python
def register(acc: Account) -> str:
    transaction_arguments = []
    payload = EntryFunction.natural(function_id, "register", [],transaction_arguments)
    signed_transaction = rest_client.create_single_signer_bcs_transaction(acc, TransactionPayload(payload))
    txn_hash = rest_client.submit_bcs_transaction(signed_transaction)
    rest_client.wait_for_transaction(txn_hash)
    return txn_hash
```

## 4. mint代币

```python
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
```

> [完整代码](https://github.com/wpf008/hello_move/blob/master/python/FirstToken.py)

## 5. 使用SDK部署合约


----
> 至此我们学习了```aptos-sdk```常用API，我们将使用```aptos```,接下来将使用```Python SDK```与合约交互。










