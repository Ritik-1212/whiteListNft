const { network } = require("hardhat");
const {phaseDuration, Nft_name, symbol} = require("../helper.hardhat.config");

module.exports = async({getNamedAccounts, deployments})=>{

    const {deploy, log} = deployments;
    const {deployer} = await getNamedAccounts();


    arguments = [Nft_name, symbol, phaseDuration];
    
    log ("deploying.................");
    
    const WhiteListNft = await deploy("WhiteListNFT", {
        from: deployer,
        args: arguments,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    });
}

module.exports.tags = ["all", "WLNFT"];