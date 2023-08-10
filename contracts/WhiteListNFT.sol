//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

//imports
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

//errors
error WhiteListNFT__senderNotEligibleForMinting();


/**
 * @title A sample NFT token
 * @author Ritik Raj
 * @notice This is a sample NFT token with whitelisting and normal users are allowed to safe mint NFT after a certain phase
 *  duration 
 * @dev This contract uses imports of ERC721 token, Ownable contract and Counters library from openzeppelin
 */

contract WhiteListNFT is ERC721, Ownable {

    using Counters for Counters.Counter;

    mapping (address => bool) private whiteList;
    
    // state variables
    Counters.Counter private tokenIdTracker;
    uint256 public mintingStartTime;
    uint256 public immutable phaseDuration;

    constructor(string memory _name, string memory _symbol, uint256 _phaseDuration) ERC721(_name, _symbol){
         phaseDuration = _phaseDuration;
         mintingStartTime = block.timestamp;
    }
    
    //modifier
    //This allows only whitelisted wallets to mint nft for a certain duration and normal addresses can mint the nft
    //after a certain time has passed
    modifier onlyWhiteListed {
        
        if(!whiteList[msg.sender] || block.timestamp < mintingStartTime + phaseDuration){
            revert WhiteListNFT__senderNotEligibleForMinting();
   
        }
        _;
    }

    //whitelisting functions
    function addToWhiteList(address _address) external onlyOwner {
        whiteList[_address] = true;
    }

    function removeFromWhiteList(address _address) external onlyOwner {
        whiteList[_address] = false;
    }
   
    //Function to mint nft
    function mintNFT(address _to) external onlyWhiteListed {

        uint256 tokenId = tokenIdTracker.current();
        _safeMint(_to, tokenId);
        tokenIdTracker.increment();
    }
    
    //getter functions
    function getPhaseDuration() public view returns(uint256) {
        return phaseDuration;
    }

}
