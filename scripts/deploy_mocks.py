from brownie import (
    MockV3Aggregator,
    network,
)
from scripts.helpful_scripts import (
    get_account,
)

DECIMALS = 8
# This is 2,000
INITIAL_VALUE = 200000000000


def deploy_mocks():
    """
    Use this script if you want to deploy mocks to a testnet
    """
    print(f"The active network is {network.show_active()}")
    print("Deploying Mocks...")
    account = get_account()
    #这个参数告诉以太坊网络谁应该负责执行部署操作以及支付相关的 gas 费用
    MockV3Aggregator.deploy(DECIMALS, INITIAL_VALUE, {"from": account})
    print("Mocks Deployed!")


def main():
    deploy_mocks()
