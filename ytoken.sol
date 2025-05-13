// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract yToken is ERC20, ERC20Burnable, Ownable, ERC20Permit {
    constructor(address initialOwner)
        ERC20("yToken", "yTK")
        Ownable(initialOwner)
        ERC20Permit("yToken")
    {}

    ///Deposit Ether and mint specified token amount (1 ETH = 1 yTK)
    function deposit(uint256 tokenAmount) external payable {
        require(tokenAmount > 0, "Token amount must be greater than 0");
        uint256 requiredEther = tokenAmount; // 1 token = 1 ETH
        // Ensure that the user sent the correct amount of Ether
        require(msg.value == requiredEther, "Incorrect Ether sent");
        // Mint the specified number of tokens to the user
        _mint(msg.sender, tokenAmount);
    }

    /// Withdraw ETH by burning tokens (1 yTK = 1 ETH)
    function withdraw(uint256 tokenAmount) external {
        require(tokenAmount > 0, "Token amount must be greater than 0");
        require(balanceOf(msg.sender) >= tokenAmount, "Insufficient token balance");
        uint256 etherAmount = tokenAmount;
        require(address(this).balance >= etherAmount, "Contract has insufficient Ether");
        _burn(msg.sender, tokenAmount);
        payable(msg.sender).transfer(etherAmount);
    }

    /// Disable public minting
    function mint(address, uint256) public pure {
        revert("Minting is disabled");
    }

    /// Disable public burning from user
    function burn(uint256) public pure override {
        revert("Burning is disabled");
    }

    function burnFrom(address, uint256) public pure override {
        revert("Burning is disabled");
    }


}
