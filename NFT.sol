// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract NodeShares is ERC721URIStorage, Pausable, Ownable {
    constructor() ERC721("NodeShares", "NODES") {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(
        address to,
        uint256 tokenId,
        string memory tokenURI
    ) public onlyOwner {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    function settokenURI(uint256 tokenId, string memory tokenURI)
        public
        onlyOwner
    {
        _setTokenURI(tokenId, tokenURI);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
