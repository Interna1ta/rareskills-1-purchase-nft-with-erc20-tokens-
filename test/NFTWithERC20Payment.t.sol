// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {NFTWithERC20Payment} from "../src/NFTWithERC20Payment.sol";
import {MyERC20} from "../src/MyERC20.sol";

contract NFTWithERC20PaymentTest is Test {
    NFTWithERC20Payment public nft;
    MyERC20 public rightErc20;
    MyERC20 public wrongErc20;
    address public OWNER = makeAddr("owner");
    address public USER = makeAddr("user");
    uint256 constant MINT_GAS_TARGET = 219312;
    function setUp() public {
        vm.prank(OWNER);
        rightErc20 = new MyERC20();
        wrongErc20 = new MyERC20();
        nft = new NFTWithERC20Payment(OWNER, address(rightErc20));
    }

    function testMintWithRightERC() public {
        vm.startPrank(OWNER);
        rightErc20.approve(OWNER, 1000);
        rightErc20.mint(OWNER, 100);
        rightErc20.approve(address(nft), 100);
        uint256 initGas = gasleft();
        nft.mint();
        assert((initGas - gasleft()) < MINT_GAS_TARGET);
        assertEq(rightErc20.balanceOf(OWNER), 90);
        assertEq(rightErc20.balanceOf(address(nft)), 10);
    }

    function testRevertOnInsufficientBalance() public {
        vm.startPrank(OWNER);
        vm.expectRevert();
        nft.mint();
    }

    function testMintWithWrongERC() public {
        vm.startPrank(OWNER);
        wrongErc20.approve(OWNER, 1000);
        wrongErc20.mint(OWNER, 100);
        wrongErc20.approve(address(nft), 100);
        vm.expectRevert();
        nft.mint();
    }

    function testWithdraw() public {
        vm.startPrank(OWNER);
        rightErc20.mint(OWNER, 100);
        rightErc20.approve(address(nft), 100);
        nft.mint();
        nft.withdrawPayment();
        assertEq(rightErc20.balanceOf(OWNER), 100);
        vm.stopPrank();
        vm.startPrank(USER);
        rightErc20.mint(USER, 100);
        rightErc20.approve(address(nft), 100);
        nft.mint();
        vm.expectRevert();
        nft.withdrawPayment();
        vm.stopPrank();
    }

    function testRevertOnNonOwnerWithdraw() public {
        vm.startPrank(USER);
        rightErc20.mint(USER, 100);
        rightErc20.approve(address(nft), 100);
        nft.mint();
        vm.expectRevert();
        nft.withdrawPayment();
    }
}
