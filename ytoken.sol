// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract yToken is ERC20 {

    event Deposite(address indexed from, uint256 amount);
    event Withdraw(address indexed from, uint256 amount);

    constructor() ERC20("yToken", "yTK") {}

    ///Deposit Ether and mint specified token amount (1 ETH = 1 yTK)
    function deposit() external payable {
        uint256 tokenAmount = msg.value;
        require(tokenAmount > 0, "Msg Value must be greater than 0");
        _mint(msg.sender, tokenAmount);
        emit Deposite(msg.sender, tokenAmount);
    }

    /// Withdraw ETH by burning tokens (1 yTK = 1 ETH)
    function withdraw(uint256 tokenAmount) external {
        require(tokenAmount > 0, "Token amount must be greater than 0");
        require(balanceOf(msg.sender) >= tokenAmount, "Insufficient token balance");
        require(address(this).balance >= tokenAmount, "Contract has insufficient Ether");
        _burn(msg.sender, tokenAmount);
        payable(msg.sender).transfer(tokenAmount);
        emit Withdraw(msg.sender, tokenAmount);
    }
}
