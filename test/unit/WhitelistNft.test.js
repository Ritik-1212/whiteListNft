const {assert, expect} = require("chai");
const {developmentChains, phaseDuration} = require("../../helper.hardhat.config");
const { network, ethers, deployments } = require("hardhat");
const { it } = require("node:test");

!developmentChains.includes(network.name) ? describe.skip :

describe("WhiteListNFT", function(){
    let WhiteListNft
    let deployer
    let user

    beforeEach(async function(){
        const accounts = await ethers.getSigners();
        deployer = accounts[0];
        user = accounts[1];

        await deployments,fixture(["all"]);

        WhiteListNft = await ethers.getContract("WhiteListNFT");
        await WhiteListNft.addToWhiteList(deployer.address);
    });

    describe("mintNFT", function(){
          it("Should not allow non-whitelisted users to mint during the phase", async ()=> {
                // Try to mint from user2, who is not whitelisted
                await expect(WhiteListNft.connect(user).mintNFT(user.address)).to.be.revertedWith(
                  "WhiteListNFT__senderNotEligibleForMinting"
                );
             });

         it("should allow whitelisted users to mint nft", async() =>{
                await WhiteListNft.connect(deployer);
                await WhiteListNft.mintNFT(deployer.address);
                const balance = await WhiteListNft.balanceOf(deployer.address);
                assert.equal(balance.toString(), "1")
             });
         it("should allow anyone to mint after phase duration", async function(){
                await network.provider.send("evm_increaseTime", [phaseDuration]);
                await network.provider.send("evm_mine");

                await WhiteListNft.connect(user).mintNFT(user.address);
                assert.equal(await WhiteListNft.balanceOf(user.address).toString(), "1");
         });
     });
 });
