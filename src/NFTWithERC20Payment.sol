// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.21;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error NFTWithERC20Payment__PaymentFailed(string message);

contract NFTWithERC20Payment is ERC721, Ownable {
    IERC20 immutable i_paymentToken;
    uint256 public constant PRICE = 10;
    uint256 public s_totalSupply = 0;

    event NFTMinted(address indexed owner, uint256 indexed tokenId);

    constructor(
        address initialOwner,
        address _paymentToken
    ) payable ERC721("MyNFT", "MNF") Ownable(initialOwner) {
        i_paymentToken = IERC20(_paymentToken);
    }

    function mint() public {
       i_paymentToken.transferFrom(
            msg.sender,
            address(this),
            PRICE
        );

        uint256 newItemId = s_totalSupply + 1;
        _safeMint(msg.sender, newItemId);
        unchecked {
            s_totalSupply++;
        }
        emit NFTMinted(msg.sender, newItemId);
    }

    function withdrawPayment() external onlyOwner {
        i_paymentToken.transfer(
            owner(),
            i_paymentToken.balanceOf(address(this))
        );
    }
}
