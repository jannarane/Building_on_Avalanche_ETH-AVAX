// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/utils/Strings.sol";

/**
 Functionality
    A new token is created on Avalanche Fuji Testnet
    All requirements are met

    owner: 0x8dda581427a2555b2c17e1bc22a9ecda7a4b4a10
    other: 0xf976fdf9e110b175248f77bb13dbeb4236149f2a
*/

contract JanaToken is ERC20, Ownable {
    using Strings for uint256; 

    string private constant tokenName = "Degen";
    string private constant tokenAbbr = "DGN";

    struct Item {
        string name;
        uint256 price; 
    }

    Item[] private shopItems; 

    constructor() ERC20(tokenName, tokenAbbr) {
        shopItems.push(Item("Armor", 100));
        shopItems.push(Item("Enchanted Dagger", 150));
        shopItems.push(Item("Shield", 50));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    function transfer(address account, uint256 amount) public override returns (bool) {
        require(balanceOf(_msgSender()) >= amount, "Balance insufficient");
        return super.transfer(account, amount);
    }

    function buyItem(uint256 itemId) public {
        require(itemId < shopItems.length, "Item does not exist");
        Item memory item = shopItems[itemId];
        require(balanceOf(_msgSender()) >= item.price, "Insufficient token balance");

        _transfer(_msgSender(), owner(), item.price);
    }

    function seeItems() public view returns (string memory) {
        uint256 itemCount = shopItems.length;
        string memory allItems = "";

        for (uint256 i = 0; i < itemCount; i++) {
            allItems = string(
                abi.encodePacked(
                    allItems,
                    '"', shopItems[i].name, '" ', shopItems[i].price.toString()
                )
            );
            if (i < itemCount - 1) {
                allItems = string(abi.encodePacked(allItems, ", "));
            }
        }

        return allItems;
    }

    function getBalance() public view returns (uint256) {
        return balanceOf(_msgSender());
    }
}
