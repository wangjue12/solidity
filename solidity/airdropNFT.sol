import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract WhiteListMerkle is IERC721Receiver{
    bytes32 public merkleRoot;
    address public tokenAdress;
    mapping(address => bool) public whitelistClaimed;
    uint256 public id;


    // verify the provided _merkleProof
    function whitelistclaim(bytes32[] calldata _merkleProof) public{
        require(!whitelistClaimed[msg.sender], "address has already claimed.");

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invaild proof.");

        whitelistClaimed[msg.sender] = true;

        IERC721 dropToken = IERC721(tokenAdress);
        require(
            dropToken.balanceOf(address(this)) > 0,
            "Insufficient balance"
        );
        dropToken.safeTransferFrom(address(this), msg.sender, id);
        id = id + 1;

    }


    function setRootHash(bytes32 roothash_) external {
        merkleRoot = roothash_;
    }

    function settokenAdress(address tokenAdress_) external {
        tokenAdress = tokenAdress_;
        id = 0;
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        override
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }

}
