from brownie import network, accounts, config, MockV3Aggregator
from web3 import Web3
DECIMALS = 8
STARTING_PRICE = 200000000000
LOCAL_BLOCKCHAIN_ENVIRONMENTS =  ["development", "ganache-local"]
FORKED_LOCAL_ENVIRONMENTS = ["mainnet-fork-dev-alch"]

def get_account():
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS or FORKED_LOCAL_ENVIRONMENTS:
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])

def deploy_mocks():
     print("Deploying mocks...")
     # deploy will make contract array
     if len(MockV3Aggregator) <=0:
        MockV3Aggregator.deploy(DECIMALS, Web3.toWei(STARTING_PRICE, "ether"), {"from" : get_account()})
     print("Mock deployed")
     # deploy most recent
    