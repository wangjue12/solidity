// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

interface IDxpoolStakingFeePool{
 function onNftTransfer(address from, address to) external;
}

contract MyToken is ERC721 ,ERC721URIStorage, Ownable,ERC721Enumerable {
    using Counters for Counters.Counter;
    using Strings for uint8;

    Counters.Counter private _tokenIdCounter;

    bytes32 public merkleRoot;
    mapping(address => bool) public whitelistClaimed;
    uint256 public maxSupply;
    mapping(uint256 => uint8) public _tokenLevel;
    string public _prefixURI;
    IDxpoolStakingFeePool public DxpoolStakingFeePool;

    constructor() ERC721("MyToken", "MTK") ERC721Enumerable()  {}

    function safeMint(address to ,  uint8 _level) public  {
        uint256 tokenId = _tokenIdCounter.current();

        require(tokenId < maxSupply,"Over Supply!");
        
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

    function getHeighestLevelByOwner(address _owner) public view returns(uint256){

        uint level;
        uint HeighestLevel;

        uint256 OwnedTokenBalance = balanceOf(_owner);
        for(uint i = 0 ; i < OwnedTokenBalance ; i++){

            uint256 OwnedTokenId = tokenOfOwnerByIndex(_owner, i);
            level = _tokenLevel[OwnedTokenId];

            if(level > HeighestLevel)
            {
                HeighestLevel = level;
            }
        }
        return HeighestLevel;
    }

    function setDxpoolStakingFeePool(address _IDxpoolStakingFeePool) public {
        DxpoolStakingFeePool = IDxpoolStakingFeePool(_IDxpoolStakingFeePool);
    }

    function setRootHash(bytes32 roothash_) external onlyOwner{
        merkleRoot = roothash_;
    }

  
    function setPrefixURI(string memory _uri) external onlyOwner{
        _prefixURI = _uri;
    }

    function setMaxSupply(uint256 _MaxSupply) external onlyOwner{
        maxSupply = _MaxSupply;
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
        override(ERC721, ERC721URIStorage,ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }



    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    )  public override (ERC721 , IERC721){
        // 添加你的自定义逻辑
        // 在执行转移之前，进行必要的检查或添加其他功能
        // ...
        
        // DxpoolStakingFeePool.onNftTransfer( from, to);
        // 调用父合约的 transferFrom 方法执行实际的转移
        super.transferFrom(from, to, tokenId);

        // 添加你的自定义逻辑
        // 在转移完成后，执行其他操作
        // ...
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override (ERC721 , IERC721){
        // 添加你的自定义逻辑
        // 在执行转移之前，进行必要的检查或添加其他功能
        // ...

        // DxpoolStakingFeePool.onNftTransfer( from, to);
        // 调用父合约的 safeTransferFrom 方法执行实际的转移
        super.safeTransferFrom(from, to, tokenId);

        // 添加你的自定义逻辑
        // 在转移完成后，执行其他操作
        // ...
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public override (ERC721 , IERC721){
        // 添加你的自定义逻辑
        // 在执行转移之前，进行必要的检查或添加其他功能
        // ...

        // DxpoolStakingFeePool.onNftTransfer( from, to);
        // 调用父合约的 safeTransferFrom 方法执行实际的转移
        super.safeTransferFrom(from, to, tokenId, data);

        // 添加你的自定义逻辑
        // 在转移完成后，执行其他操作
        // ...
    }

    function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal override(ERC721 ,ERC721Enumerable) {
    // Add your custom logic here
    // Call base implementations
    super._beforeTokenTransfer(from, to, firstTokenId , batchSize);
    }

} 