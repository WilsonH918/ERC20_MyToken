from brownie import FundMe
from scripts.helpful_scripts import get_account

# 1. To deploy the Contract to the Test Net, type in "brownie run deploy.py --network goerli".
# 2. Go to Etherscan and search for your deployed contract using the contract address.
# 3. (1) Manual way: Click "Verify and Publish" your contract on Etherscan. (if you imported anything from CHAINLINK in your contract, the way will NOT work)
#    (2) Automate way: [1] Get the API key from your Etherscan account and put the API key to .env file
#                      [2] In your Python code, type in publish_source = True when you are deploying your contract (see below)


def deploy_fund_me():
    account = get_account()
    fund_me_py = FundMe.deploy({"from": account}, publish_source = True) # publish = True means we would like to publish our source code
    print(f"Contract deployed to {fund_me_py.address}")
    return fund_me_py

def main():
    deploy_fund_me()