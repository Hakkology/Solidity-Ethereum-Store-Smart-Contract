// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*In this case, transfer function is called before the state variable for balance is modified.
This regrettably leaves "withdraw" function vulnerable to re-entrancy attacks.
This can easily be prevented by locking the vulnerable function between booleans, as presented below.*/


contract FeeCollector {
    bool private ReentryLock; 
    address public owner;
    uint256 public balance;

    constructor () {
        owner = msg.sender;
    }

    receive() payable external {
        balance += msg.value;
    }

    function withdraw (uint amount, address payable destAddr) public {
        require(msg.sender == owner, "Only owner can withdraw.");
        require(amount <= balance, "Insufficient funds.");
        ReentryLock = true; 
        destAddr.transfer(amount);
        balance -= amount;
        ReentryLock = false;
    }
}