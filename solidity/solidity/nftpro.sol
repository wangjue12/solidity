// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./IMyToken.sol";


contract MyToken is ERC721, ERC721URIStorage, Ownable, IMyToken {
    using Counters for Counters.Counter;
    using Strings for uint8;

    Counters.Counter private _tokenIdCounter;

    bytes32 public merkleRoot;
    mapping(address => bool) public whitelistClaimed;
    uint256 public totalSupply;
    mapping(uint256 => uint8) public _tokenLevel;
    string public _prefixURI;
    mapping(address => uint256[]) public _ownedTokens;

    constructor() ERC721("MyToken", "MTK") {}

    function safeMint(address to ,  uint8 _level) internal  {
        uint256 tokenId = _tokenIdCounter.current();

        require(tokenId < totalSupply,"Over Supply!");
        
        _ownedTokens[to].push(tokenId);
        _tokenLevel[tokenId] = _level;
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        string memory uri = string(abi.encodePacked(_prefixURI, _level.toString()));
        _setTokenURI(tokenId, uri);
    }

        // verify the provided _merkleProof
    function whitelistclaim(bytes32[] calldata _merkleProof , uint8 _level) public{
        require(!whitelistClaimed[msg.sender], "address has already claimed.");

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invaild proof.");

        whitelistClaimed[msg.sender] = true;
        
        safeMint(msg.sender , _level);

    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        require(index < balanceOf(owner), "Invalid token index");
        return _ownedTokens[owner][index];
    }

    function getHeighestLevelByOwner(address _owner) public view returns(uint256){

        uint level;
        uint HeighestLevel;

        for(uint i = 0 ; i < _tokenIdCounter.current() ; i++){
            if(ownerOf(i) == _owner){
                level = _tokenLevel[i];
            }
            if(level > HeighestLevel)
            {
                HeighestLevel = level;
            }
        }
        return HeighestLevel;
    }

    function setRootHash(bytes32 roothash_) external onlyOwner{
        merkleRoot = roothash_;
    }


    function setPrefixURI(string memory _uri) external onlyOwner{
        _prefixURI = _uri;
    }

    function setTotalSupply(uint256 _totalSupply) external onlyOwner{
        totalSupply = _totalSupply;
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}