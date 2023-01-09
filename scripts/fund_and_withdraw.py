from brownie import FundMe2
from scripts.helpful_scripts import get_account

# This script is used to interact with the contract (FundMe2, ganache-local)

def fund():
    fund_me = FundMe2[-1]
    account = get_account()
    entrance_fee = fund_me.getEntranceFee()
    print(entrance_fee)
    print(f"The current entry fee is {entrance_fee}")
    print("Funding")
    fund_me.fund({"from": account, "value": entrance_fee})


def withdraw():
    fund_me = FundMe2[-1]
    account = get_account()
    fund_me.withdraw({"from": account})


def main():
    fund()
    withdraw()