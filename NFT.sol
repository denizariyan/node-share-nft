// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract TestShares is ERC721URIStorage, Pausable, Ownable {
    mapping(string => string) private _nodeTypes;
    mapping(uint256 => string) private _typeOfNode;
    mapping(address => uint256) private _escrow;

    uint256 private _numOfMints;
    string[] private _nodeTypeNames;

    constructor() ERC721("TESTSHARES", "TESTS") {
        _nodeTypeNames = new string[](0);
        _numOfMints = 0;
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

    function getEscrowAmountOf(address addr) public view returns (uint256) {
        return _escrow[addr];
    }

    function getNumberOfMints() public view returns (uint256) {
        return _numOfMints;
    }

    function addToEscrow(string memory nodeTypeToPay, uint256 amountToAdd)
        public
        onlyOwner
    {
        for (uint256 i = 0; i < _numOfMints; i++) {
            if (
                keccak256(abi.encodePacked((_typeOfNode[i]))) ==
                keccak256(abi.encodePacked((nodeTypeToPay)))
            ) _escrow[ownerOf(i)] += amountToAdd;
        }
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

    function safeMint(address to, string memory nodeName) public onlyOwner {
        require(isValidNodeType(nodeName), "Not a valid node type!");
        _numOfMints++;
        _safeMint(to, _numOfMints);
        _setTokenURI(_numOfMints, _nodeTypes[nodeName]);
        _typeOfNode[_numOfMints] = nodeName;
    }

    function safeMintMultiple(
        address to,
        string memory nodeName,
        uint256 numberOfMints
    ) public onlyOwner {
        require(isValidNodeType(nodeName), "Not a valid node type!");
        for (uint256 index = 0; index < numberOfMints; index++) {
            _numOfMints++;
            _safeMint(to, _numOfMints);
            _setTokenURI(_numOfMints, _nodeTypes[nodeName]);
            _typeOfNode[_numOfMints] = nodeName;
        }
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
