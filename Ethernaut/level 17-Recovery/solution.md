#   Level 17 Recovery
實例地址：`0x18a6948FA18A2efF062c0a6ADF07E1A157C29094`

##  題目說明
A contract creator has built a very simple token factory contract. Anyone can create new tokens with ease. After deploying the first token contract, the creator sent 0.001 ether to obtain more tokens. They have since lost the contract address.

This level will be completed if you can recover (or remove) the 0.001 ether from the lost contract address.
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Recovery {
    //generate tokens
    function generateToken(string memory _name, uint256 _initialSupply) public {
        new SimpleToken(_name, msg.sender, _initialSupply);
    }
}

contract SimpleToken {
    string public name;
    mapping(address => uint256) public balances;

    // constructor
    constructor(string memory _name, address _creator, uint256 _initialSupply) {
        name = _name;
        balances[_creator] = _initialSupply;
    }

    // collect ether in return for tokens
    receive() external payable {
        balances[msg.sender] = msg.value * 10;
    }

    // allow transfers of tokens
    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender] - _amount;
        balances[_to] = _amount;
    }

    // clean up after ourselves
    function destroy(address payable _to) public {
        selfdestruct(_to);
    }
}
```

##  POC
這邊有兩種方式，一種是計算合約創建的下一筆地址 `keccak256(address, nonce)`，另一種是透過 etherscan 查找原地址的 `internal transaction` 所新創建的地址，再向新地址發送 `destroy` 即可催回此合約並領回 ether。

```bash
cast send --account=Panda 0xc80d55c30f0249db6487e0288f75414f02ccc283 "destroy(address payable)" 0xEBA2Ef27A1B85a4685953E82848e9d2E9ED5b0B6
```