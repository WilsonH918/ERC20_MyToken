from brownie import accounts
def getaccount():
    print(f"accounts[0] is {accounts[0]}")
    print(f"the data type is {type(accounts[0])}")
    print("/n")
    print(f"accounts[1] is {accounts[1]}")
    print(f"the data type is {type(accounts[1])}")

def main():
    getaccount()