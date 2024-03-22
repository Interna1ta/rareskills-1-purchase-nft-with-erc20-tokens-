// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ERC20} from "../src/ERC20.sol";

contract ERC20Test is Test {
    ERC20 public erc20;
    string constant NAME = "ERC20";
    string constant SYMBOL = "ERC";
    address constant OWNER = makeAddr("owner");
    function setUp() public {
        vm.prank(OWNER);
        erc20 = new ERC20(NAME, SYMBOL, OWNER);
    }

    function testMint(uint256 amount) public {
        uint256 initGas = gasleft();
        erc20.mint(amount);
        assertEq(counter.number(), 1);
        console.log("Gas used when minting: ", initGas - gasleft());
    }
}
