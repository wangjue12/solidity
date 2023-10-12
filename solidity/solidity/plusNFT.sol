// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyToken is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    bytes32 public merkleRoot;
    // string public uri;
    mapping(address => bool) public whitelistClaimed;
    uint256 public totalSupply;
    mapping(address => uint256[]) public _ownedTokens;

    string  tokenURI1 = "ipfs://QmTG6vB1C8ZWkEyV8e8JrQ5uiyzSPKa5MuY9vkcgCDEU5u";
    string  tokenURI2 = "ipfs://QmdqSV4jybTtgjY56HNPieswcgb9DCQz3tvC4HpdjQy6nZ";
    string  tokenURI3 = "ipfs://QmcdTSEUQAeHcojxtDD92XeXb9kUMKxQz995azUNTqHDcw";

    mapping (string => uint256) public _URIMAP;
    function uriMap() public {
        _URIMAP[tokenURI1] = 1;
        _URIMAP[tokenURI2] = 2;
        _URIMAP[tokenURI3] = 3;
    }

    constructor() ERC721("MyToken", "MTK") {}

    function safeMint(address to , string memory _uri) public   {
        uint256 tokenId = _tokenIdCounter.current();
        _ownedTokens[to].push(tokenId);
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _uri);
    }

        // verify the provided _merkleProof
    function whitelistclaim(bytes32[] calldata _merkleProof , uint256 _level) public{
        require(!whitelistClaimed[msg.sender], "address has already claimed.");

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invaild proof.");

        whitelistClaimed[msg.sender] = true;
        
        if(_level == 1){
          safeMint(msg.sender , tokenURI1);
        }else if(_level == 2){
          safeMint(msg.sender , tokenURI2);
        }else if(_level == 3){
          safeMint(msg.sender , tokenURI3);
        }

    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        require(index < balanceOf(owner), "Invalid token index");
        return _ownedTokens[owner][index];
    }

    function getHeighestLevelByOwner(address _owner) public  view returns(uint256){
        // uint256 ownedTokenBalance = balanceOf(_owner);
        // uint[] memory level;
        // for(uint256 i = 0 ; i < ownedTokenBalance ; i++){

        //    uint256 ownedTokenId = tokenOfOwnerByIndex(_owner , i);

        //    string memory tokenuri = tokenURI(ownedTokenId);
        // //    if(keccak256(abi.encodePacked(tokenuri)) == keccak256(abi.encodePacked(tokenURI1))) {level[i] = 1;}
        // //    else if(keccak256(abi.encodePacked(tokenuri)) == keccak256(abi.encodePacked(tokenURI2))) {level[i] = 2;}
        // //    else if(keccak256(abi.encodePacked(tokenuri)) == keccak256(abi.encodePacked(tokenURI3))) {level[i] = 3;}
        // }
        
        // uint HeighestLevel = level[0];
        // for (uint i = 0; i < ownedTokenBalance; i++) {
        //     if (level[i] > HeighestLevel) {
        //         HeighestLevel = level[i];
        //     }
        // }
        uint level;
        uint max = 0;
        for(uint i=0;i<_tokenIdCounter.current();i++){
            if(ownerOf(i) == _owner){
                string memory tokenuri = tokenURI(i);
                level = _URIMAP[tokenuri];
            }
            if(level > max)
            {
                max = level;
            }

        }

        return max;

    }

    function setRootHash(bytes32 roothash_) external onlyOwner{
        merkleRoot = roothash_;
    }

    // function setUri(string memory _uri) external onlyOwner{
    //     uri = _uri;
    // }

    function setTotalSupply(uint256 _totalSupply) external onlyOwner{
        totalSupply = _totalSupply;
    }

    // The following functions are overrides required by Solidity.

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