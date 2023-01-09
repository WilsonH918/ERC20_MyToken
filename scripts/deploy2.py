from brownie import FundMe2, MockV3Aggregator, network, config
from scripts.helpful_scripts import get_account, deploy_mocks, LOCAL_BLOCKCHAIN_ENVIRONMENTS
from web3 import Web3

def deploy_fund_me2():
    account = get_account()
    # Pass the priceFeed address to our FundMe contract

    #If we are on a persistent network like goerli, use the associated address
    # otherwise, deploy mocks
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS: #IF the network is NOT development or NOT ganache-local, price_feed_address = the real priceFeed address defined in "brownie-config.yaml"
        # We can go to "brownie-config.yaml and add different address for different networks"
        price_feed_address = config["networks"][network.show_active()]["eth_usd_price_feed"]
    else:
        # ELSE IF the network is development or is ganache-local, then set price_feed_address to a fake priceFeed Cpntract's address (MockV3Aggregator)
        '''
        print(f"The active network is {network.show_active()}")
        print("Deploying Mocks...")
        if len(MockV3Aggregator) <= 0: # If the MockV3Aggregator is deployed already, we don't need to deploy it again
            MockV3Aggregator.deploy(18, 2000000000000000000, {"from": account})
            print("Mock is deployed!!")
        '''
        deploy_mocks() #this works the same as above code, the above code were defined in helpful_scripts.py
        price_feed_address = MockV3Aggregator[-1].address # Get the most recent MockV3Aggregator's address

    fund_me2_py = FundMe2.deploy(
        price_feed_address,#"0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e" Add value to constructors
        {"from": account}, 
        publish_source=config["networks"][network.show_active()].get("verify"))
    print(f"Contract deployed to {fund_me2_py.address}")
    return fund_me2_py

def main():
    deploy_fund_me2()