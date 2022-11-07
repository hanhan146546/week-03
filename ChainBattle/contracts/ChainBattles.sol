// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => uint256) public tokenIdToLevels;

    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

function generateCharacter(uint256 tokenId) public returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 300 180">',
        '<style type="text/css"> .base { font-family: microsoft yahei;} .warrior { fill: black; font-size: 28px; font-weight: bolder; } </style>',

        '<text x="50%" y="40%" class="base warrior" dominant-baseline="middle" text-anchor="middle">',"Girls",'</text>',
        '<text x="50%" y="50%" class="base level" dominant-baseline="middle" text-anchor="middle">', "Favorites sports internet pets",'</text>',
        '<text x="50%" y="60%" class="base warrior" dominant-baseline="middle" text-anchor="middle">',"I am from China and",'</text>',
        '<text x="50%" y="70%" class="base level" dominant-baseline="middle" text-anchor="middle">', "I am happy to be here at Alchemy",'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
}
function getLevels(uint256 tokenId) public view returns (string memory) {
    uint256 levels = tokenIdToLevels[tokenId];
    return levels.toString();
}
function getTokenURI(uint256 tokenId) public returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}
function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    tokenIdToLevels[newItemId] = 0;
    _setTokenURI(newItemId, getTokenURI(newItemId));
}
    function train(uint256 tokenId)public{
        require(_exists(tokenId));
        require(ownerOf(tokenId)==msg.sender,"You must own this token to train it");
        uint256 currentLevel=tokenIdToLevels[tokenId];
        tokenIdToLevels[tokenId]=currentLevel+1;
        _setTokenURI(tokenId,getTokenURI(tokenId));
        }
}