// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title A custom token with buy/sell mechanism
 * @author Ritik kumar
 * @notice This contract is a sample custom token with buy/sell mechanism with tax and additional fee for token minted
 * @dev This contract uses import of ERC20 token from openzeppelin library
 */

contract CustomToken is ERC20 {

    //state variables
    address private feeWallet;
    uint256 private feeConversionRate;
    uint256 private buySellTaxPercentage;
    uint256 private additionalFeesPercentage;
    
    constructor(
        uint _initialSupply,
        address _feeWallet,
        uint _feeConversionRate,
        uint _buySellTaxPercentage,
        uint _additionalFeesPercentage
    ) ERC20("CustomToken", "CT") {
        _mint(msg.sender, _initialSupply * 10**decimals());
        feeWallet = _feeWallet;
        feeConversionRate = _feeConversionRate;
        buySellTaxPercentage = _buySellTaxPercentage;
        additionalFeesPercentage = _additionalFeesPercentage;
    }
    

    //function to transfer the tokens to the recipient and tax and additional fee to the designated wallet
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 buySellTax = calculateBuySellTax(amount);
        uint256 additionalFees = calculateAdditionalFees(amount);
        uint256 transferAmount = amount - buySellTax - additionalFees;
        
        _transfer(_msgSender(), recipient, transferAmount);
        
        _transfer(_msgSender(), feeWallet, buySellTax + additionalFees);
        convertFeesToETH(buySellTax + additionalFees);
        
        return true;
    }
    
    function calculateBuySellTax(uint256 amount) private view returns (uint256) {
        return (amount * buySellTaxPercentage) / 100;
    }
    
    function calculateAdditionalFees(uint256 amount) private view returns (uint256) {
        return (amount * additionalFeesPercentage) / 100;
    }
    
    function convertFeesToETH(uint256 amount) private view returns(uint256){
        return (amount * feeConversionRate) / 10**decimals();
        // Implement the logic to swap the token for ETH and transfer to the fee wallet
        // using a decentralized exchange protocol like Uniswap
        // This step requires integration with external protocols, and the exact implementation may vary
        // and depend on the specific exchange protocol being used.
    }
}