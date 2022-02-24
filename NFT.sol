// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract NodeShares is ERC721URIStorage, Pausable, Ownable {
    mapping(string => string) private _nodeTypes;
    string[] private _nodeTypeNames;

    constructor() ERC721("NodeShares", "NODES") {
        _nodeTypeNames = new string[](0);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function addNodeType(string memory nodeName, string memory nodeURI)
        public
        onlyOwner
    {
        _nodeTypeNames.push(nodeName);
        _nodeTypes[nodeName] = nodeURI;
    }

    function getNodeNames() public view returns (string[] memory) {
        return _nodeTypeNames;
    }

    function isValidNodeType(string memory nodeName)
        private
        view
        returns (bool)
    {
        for (uint256 i = 0; i < _nodeTypeNames.length; i++) {
            if (
                keccak256(abi.encodePacked((_nodeTypeNames[i]))) ==
                keccak256(abi.encodePacked((nodeName)))
            ) return true;
        }
        return false;
    }

    function safeMint(
        address to,
        uint256 tokenId,
        string memory nodeName
    ) public onlyOwner {
        _safeMint(to, tokenId);
        require(isValidNodeType(nodeName), "Not a valid node type!");
        _setTokenURI(tokenId, _nodeTypes[nodeName]);
    }

    function setTokenURI(uint256 tokenId, string memory tokenURI)
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
