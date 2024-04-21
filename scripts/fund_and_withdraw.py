from brownie import FundMe
from scripts.helpful_scripts import get_account

# 这个函数的目的是为 FundMe 合约进行资金注入
def fund():
    fund_me = FundMe[-1]
    account = get_account()
    entrance_fee = fund_me.getEntranceFee()
    print(entrance_fee)
    print(f"The current entry fee is {entrance_fee}")
    print("Funding")
    fund_me.fund({"from": account, "value": entrance_fee})

#这个函数的目的是从 FundMe 合约中提取资金
def withdraw():
    fund_me = FundMe[-1]
    account = get_account()
    fund_me.withdraw({"from": account})


def main():
    fund()
    withdraw()
