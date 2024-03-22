// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.21;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error NFTWithERC20Payment__PaymentFailed(string message);

contract NFTWithERC20Payment is ERC721, Ownable {
    IERC20 public paymentToken;
    uint256 public constant PRICE = 10;
    uint256 public totalSupply = 0;

    event NFTMinted(address indexed owner, uint256 indexed tokenId);

    constructor(
        address initialOwner,
        address _paymentToken
    ) payable ERC721("MyToken", "MTK") Ownable(initialOwner) {
        paymentToken = IERC20(_paymentToken);
    }

    function mint() public onlyOwner {
        bool success = paymentToken.transferFrom(
            msg.sender,
            address(this),
            PRICE
        );
        if (!success) {
            revert NFTWithERC20Payment__PaymentFailed("Payment failed");
        }
        uint256 newItemId = totalSupply + 1;
        _safeMint(msg.sender, newItemId);
        totalSupply++;
        emit NFTMinted(msg.sender, newItemId);
    }

    function withdrawPayment() external onlyOwner {
        paymentToken.transfer(owner(), paymentToken.balanceOf(address(this)));
    }

    receive() external payable {
        revert("This contract does not accept Ether");
    }
}
