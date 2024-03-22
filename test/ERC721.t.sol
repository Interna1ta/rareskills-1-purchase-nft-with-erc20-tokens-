// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ERC721} from "../src/ERC721.sol";
import {ERC20} from "../src/ERC20.sol";

contract ERC721Test is Test {
    ERC721 public erc721;
    string constant NAME = "ERC721";
    string constant RIGHT_NAME = "ERC20";
    string constant WRONG_NAME = "SHITCOIN";
    string constant SYMBOL = "NFT";
    address constant OWNER = makeAddr("owner");
    address constant USER = makeAddr("user");

    function setUp() public {
        vm.prank(OWNER);
        rightErc20 = new ERC20(RIGHT_NAME, SYMBOL, OWNER);
        wrongErc20 = new ERC20(SHITCOIN, SYMBOL, USER);
        erc721 = new ERC721(NAME, SYMBOL, OWNER, address(rightErc20));
    }

    function testMintWithRightERC(uint256 amount) public {
        uint256 initGas = gasleft();
        erc721.mint(amount, address(rightErc20));
        assertEq(counter.number(), 1);
        console.log("Gas used when minting: ", initGas - gasleft());
    }

    function testMintWithWrongERC(uint256 amount) public {
        vm.expectRevert();
        erc721.mint(amount, address(wrongErc20));
    }
}
