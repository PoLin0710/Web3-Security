#   Level 12 Privacy
實例地址：`0xC911D9652167D59F35c4D1D3B4DD2A369eE768b1`

##  題目說明
這個合約的開發者非常小心的保護了 storage 敏感資料的區域.

把這個合約解鎖就可以通關喔！

這些可能有幫助：

*   理解 storage 是如何運作的
*   理解 parameter parsing 的原理
*   理解 casting 的原理

小技巧：

*   記住 Metamask 只是個基本的日常工具. 如果使用 Metamask 有遇到問題或障礙，可以試試看使用別的工具。在後面比較困難的關卡，應該會用到包括 Remix、Web3 的操作。
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {
    bool public locked = true;
    uint256 public ID = block.timestamp;
    uint8 private flattening = 10;
    uint8 private denomination = 255;
    uint16 private awkwardness = uint16(block.timestamp);
    bytes32[3] private data;

    constructor(bytes32[3] memory _data) {
        data = _data;
    }

    function unlock(bytes16 _key) public {
        require(_key == bytes16(data[2]));
        locked = false;
    }

    /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
    */
}
```

##  POC
該合約將 `data` 儲存在私有變數中，但我們仍然可以透過查詢 `storage` 的方式來找出 `data` 的值。在 Ethereum ，每個 `storage slot` 的大小為 `bytes32（32 字節）`。如果變數的大小未超過 `bytes32`，則它可能與其他變數一同存儲在同一個 `storage slot` 內。

| Storage Slot | 變數名稱                                      | 資料類型                          | 備註 |
|-------------|--------------------------------|---------------------------|------|
| 0           | `locked`                       | `bool`                    | 佔用 1 byte |
| 1           | `ID`                           | `uint256`                  | 佔用完整 32 bytes |
| 2           | `flattening + denomination + awkwardness` | `uint8 + uint8 + uint16` | 這些變數會打包存入同一個 slot |
| 3           | `data[0]`                      | `bytes32`                  | 陣列第一個元素 |
| 4           | `data[1]`                      | `bytes32`                  | 陣列第二個元素 |
| 5           | `data[2]`                      | `bytes32`                  | 陣列第三個元素 |

1.  獲取 `storge slot`
```bash
cast storage 0xC911D9652167D59F35c4D1D3B4DD2A369eE768b1 5
// storge: 0x306e6bdb66a0e663cb01cf1604d1d653b1b8948eec6079f787776b92508fe5d5
```

2. 取前 16 bytes `0x306e6bdb66a0e663cb01cf1604d1d653`
```
cast send --account=Panda 0xC911D9652167D59F35c4D1D3B4DD2A369eE768b1 "unlock(bytes16)" 0x306e6bdb66a0e663cb01cf1604d1d653
```