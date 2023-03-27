from brownie import ERC20_version1, network, config, accounts
from web3 import Web3

def deploy_erc20():
    account = get_account()
    erc20 = ERC20_version1.deploy({"from": account}) # publish = True means we would like to publish our source code
    print(f"Contract deployed to {erc20.address}")
    #return erc20

def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])

def main():
    deploy_erc20()