#   Level 18 Magic Number
實例地址：`0x18bAe2C7ABB23c24Ae0141E0A83a6F93508AB898`

##  題目說明
To solve this level, you only need to provide the Ethernaut with a Solver, a contract that responds to whatIsTheMeaningOfLife() with the right 32 byte number.

Easy right? Well... there's a catch.

The solver's code needs to be really tiny. Really reaaaaaallly tiny. Like freakin' really really itty-bitty tiny: 10 bytes at most.

Hint: Perhaps its time to leave the comfort of the Solidity compiler momentarily, and build this one by hand O_o. That's right: Raw EVM bytecode.

Good luck!
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MagicNum {
    address public solver;

    constructor() {}

    function setSolver(address _solver) public {
        solver = _solver;
    }

    /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
    */
}
```

##  POC
部屬合約的 `bytescode` 主要由`Creation Code` 和 `Runtime Code` 兩部分組合而成，題目限定我們只能的 `Runtime Code` 的部分不能超過 10 `opcode`,所以我們必須手動撰寫 `bytecsode` 來部屬合約。

### Runtime code
題目要求是回傳 42 ，所以對應的 `opcode` 會是 `RETURN`，但是 `RETURN` 需要帶有兩個參數，第一個是變數所從在記憶體的位置，第二個為變數大小，所以我們需要用到 `MSTORE` 來將變數存入記憶體中，也是需要兩個參數第一個是記憶體的位置， 第二個為變數數值。
```bash
OPCODE       NAME
------------------
 0x60        PUSH1 # 將值推入 STACK 中
 0x52        MSTORE # 從STACK 拿取兩個數值，第一個出來為記憶體位置，第二個出來為變數數值
 0xf3        RETURN # 從STACK 拿取兩個數值，第一個出來為記憶體位置，第二個出來為變數大小
```
#### 步驟
``` bash
OPCODE   DETAIL
------------------------------------------------
602a     將 42 推入堆疊當中
6080     將 80 推入堆疊當中， 80 為我們假設的記憶體位置(建議 80 之後，前面皆為系統常用)
52       將 42 存入記憶體位置為 80 的地方
#----存入操作----#
6020     將 20 推入堆疊當中， 20 為 uint256 的大小
6080     將 80 推入堆疊當中， 80 為我們剛存入 42 的記憶體位置
f3       將 42 回傳出去
```
`RUNTIME CODE` = `602a60805260206080f3`

### CREATION CODE
這邊就是負責將剛剛撰寫好的 `RUNTIME CODE` 回傳給 `EVM` 上，所以我們也是會使用 `RETURN`，那當然我們就需要把 `RUNTIME CODE` 複製到記憶體中，我們將會使用 `COPYCODE` 將代碼進行複製，`COPYCODE`需要三個參數，第一個複製程式碼到記憶體目的地的位置，第二個 `RUNTIME CODE` 的當前位置以 byte 為單位，第三個以 byte 為單位的程式碼大小。
```bash
OPCODE       NAME
------------------
 0x60        PUSH1 # 將值推入 STACK 中
 0xf3        RETURN # 從STACK 拿取兩個數值，第一個出來為記憶體位置，第二個出來為變數大小
 0x39        CODECOPY # 從STACK 拿取三個數值，第一個出來為記憶體位置，第二個出來複製起始位置，第三個為程式碼大小
```

#### 步驟
``` bash
OPCODE   DETAIL
------------------------------------------------
600a     將 0a 推入堆疊當中，0a 代表我們 Runtime code 大小為 10 bytes(20 位)
60??     這邊 ?? 是要計算 CREATION CODE + RUNTIME CODE，RUNTIME CODE 的實際位置
6000     將 00 推入堆疊當中，00 代表我們記憶體位置(不須考量 Free memory point)
39
600a     將 0a 推入堆疊當中，0a 代表我們 Runtime code 大小 10 bytes(20 位)
6000     將 00 推入堆疊當中，00 代表我們記憶體位置
f3       將 RUNTIME　CODE 回傳出去
------------------------------------------------
600a60??600039600a6000f3 長度為24 12 bytes 等於 0c
```
`CREATION CODE`= `600a600c600039600a6000f3`

部屬合約 `bytescode` = `0x600a600c600039600a6000f3602a60805260206080f3`

創建合約
```bash
cast send --account=Panda --create "0x600a600c600039600a6000f3602a60805260206080f3"
```