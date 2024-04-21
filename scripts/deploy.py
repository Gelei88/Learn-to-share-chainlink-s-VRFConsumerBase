from brownie import FundMe, MockV3Aggregator, network, accounts

#这个函数实现了根据当前网络环境部署 FundMe 合约的功能，并根据需要获取相应的价格反馈合约地址
def deploy_fund_me():
    # LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["Binance Smart Chain", "bsc-test"],
    account = accounts.load("gelei")
    # if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
    #     price_feed_address = config["networks"][network.show_active()][
    #         "eth_usd_price_feed"
    #     ]
    # else:
    # deploy_mocks()
    price_feed_address = MockV3Aggregator[-1].address

    fund_me = FundMe.deploy(
    price_feed_address,
    {"from": account},
    #该参数用于控制是否将合约源代码上传到区块链上。根据配置文件中的设置，如果当前网络要求验证合约，则上传源代码。
    publish_source=True
)
    print(f"Contract deployed to {fund_me.address}")
    return fund_me


def main():
    deploy_fund_me()
