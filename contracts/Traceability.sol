// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Traceability is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _idToken;
    using Strings for uint256;

    mapping(uint256 => mapping(uint256 => uint256)) private _tokenOriginList;               // - mapping from tokenID to list of origin tokens
    mapping(uint256 => uint256) private _tokenOriginCount ;                                 // - mapping from tokenID to the total number of origin tokens

    event TokenCreation(address indexed owner, string tokenURI, uint256 newTokenId);        // - Event to log the token creation, the owner address and the token ID are logged in this event.
    event TokenOrigin(uint256 tokenId, uint256 tokenOrigin);                                // - Event to log each token origin, The token ID and the origin Token ID are logged in this event.

    constructor() ERC721( "TraceabilityToken", "PTT") {}

    function createToken
    (
        address owner,
        string memory tokenURI
    )
        public
        returns (uint256 id)
    {
        _idToken.increment();
        uint256 newTokenId = _idToken.current();

        _mint(owner, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        emit TokenCreation(owner, tokenURI, newTokenId);
        
        return newTokenId;
    }

    function addOrginToken
    (
        uint256 _tokenId,
        uint256 _originTokenId
    )
        public
        returns (bool)
    {
        require(_exists(_tokenId), "ERC721_Traceability: tokenId does not exist");
        require(_exists(_originTokenId), "ERC721_Traceability: tokenId of origin does not exist");

        if (_tokenOriginCount[_tokenId] > 0)
        {
            uint256 index = _tokenOriginCount[_tokenId];
            uint256 totalCount = index + 1;
            _tokenOriginList[_tokenId][index] = _originTokenId;
            _tokenOriginCount[_tokenId] = totalCount;
        } else {
            _tokenOriginList[_tokenId][0] = _originTokenId;
            _tokenOriginCount[_tokenId] = 1;
        }

        emit TokenOrigin( _tokenId, _originTokenId);
        
        return true;
    }

    function getOrginToken
    (
        uint256 _tokenId,
        uint256 indexOfOrigin
    )
        public
        view
        returns (uint256 originId)
    {
        require(_exists(_tokenId), "ERC721_Traceability: tokenId does not exist");
        require( indexOfOrigin >= 0, "ERC721_Traceability: index is not correct");

        if( _tokenOriginCount[_tokenId] > 0)
        {
            return _tokenOriginList[_tokenId][indexOfOrigin];
        } else {
            return 0;
        }
    }

    function getTotalOriginToken
    (
        uint256 _tokenId
    )
        public
        view
        returns(uint256)
    {
        require(_exists(_tokenId), "ERC721_Traceability: tokenId does not exist");

        return _tokenOriginCount[_tokenId];
    }    
}