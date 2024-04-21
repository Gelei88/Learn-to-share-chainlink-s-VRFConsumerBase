from brownie import network, config, accounts, MockV3Aggregator
#network: 允许与以太坊网络进行交互
#config提供对Brownie项目中配置设置的访问
#ccounts: 处理以太坊账户
from web3 import Web3

#本地区块链从以太坊主网分叉的环境。用于本地环境中测试智能合约
#这种本地区块链从以太坊主网分叉的环境通常是由以太坊开发工具和框架提供的
#第二行列表就是使用本地的开发工具ganache
FORKED_LOCAL_ENVIRONMENTS = ["Binance Smart Chain"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["Binance Smart Chain", "bsc-test"]
#这行代码设置了代币的小数位数
DECIMALS = 8
#这行代码设置了某物的起始价格
STARTING_PRICE = 200000000000

#
def get_account():
    if (#show_active() 函数。该函数用于获取当前活动的以太坊网络名称
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        or network.show_active() in FORKED_LOCAL_ENVIRONMENTS
    ):
        return accounts[0]
    else:#当不在本地环境时，它会从项目配置文件 config 中的钱包列表中添加一个账户
        return accounts.add(config["wallets"]["from_key"])

#打印函数
def deploy_mocks():
    account = account[0]
    print(f"The active network is {network.show_active()}")
    print("Deploying Mocks...")
    #它检查是否已经部署了模拟器，如果没有部署则调用MockV3Aggregator.deploy部署一个新的模拟器
    if len(MockV3Aggregator) <= 0:
        MockV3Aggregator.deploy(DECIMALS, STARTING_PRICE, {"from": account[0]})
    print("Mocks Deployed!")
