// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import {DeployMyERC20} from "../script/MyERC20.s.sol";
import {MyERC20} from "../src/MyERC20.sol";

contract DeployMyERC20Test is Test {
    DeployMyERC20 deployer;
    MyERC20 deployedMyERC20;

    function setUp() public {
        deployer = new DeployMyERC20();
    }

    function testDeployMyERC20() public {
        deployedMyERC20 = MyERC20(deployer.run());
        assert(address(deployedMyERC20) != address(0));
    }
}