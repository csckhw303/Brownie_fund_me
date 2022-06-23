from brownie import FundMe, MockV3Aggregator,network, config

from scripts.helpful_scripts import get_account, deploy_mocks, LOCAL_BLOCKCHAIN_ENVIRONMENTS,FORKED_LOCAL_ENVIRONMENTS

FORKED_LOCAL_ENVIRONMENTS
def deploy_fund_me():
    account = get_account()

    # 3rd party service used 
    price_fedd_address =""
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        price_fedd_address = config["networks"][network.show_active()]["eth_usd_price_feed"]
    else:
        deploy_mocks()
        price_fedd_address = MockV3Aggregator[-1].address
       
    #####
    fundMe = FundMe.deploy(
        price_fedd_address,
        {"from": account}, 
        publish_source=config["networks"][network.show_active()].get("verify"))
    print(f"Contract deployed to {fundMe.address}")
    return fundMe
    
def main():
    deploy_fund_me()


