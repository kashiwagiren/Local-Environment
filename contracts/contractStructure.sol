// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract SimpleBank {
    // === State Variables ===
    address public owner;
    mapping(address => uint256) private balances;

    // === Events ===
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    // === Modifiers ===
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier hasBalance(uint256 amount) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        _;
    }

    // === Constructor ===
    constructor() {
        owner = msg.sender;
    }

    // === Public Functions ===

    // Deposit ETH into the bank
    function deposit() public payable {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    // Withdraw ETH from the bank
    function withdraw(uint256 amount) public hasBalance(amount) {
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);
    }

    // Check your balance
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // Only owner can check total ETH in contract
    function contractBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    // === Internal or Private Functions (if any) ===
    // (Optional) Add internal logic here as needed

}