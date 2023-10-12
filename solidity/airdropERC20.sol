import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
contract WhiteListMerkle {
    bytes32 public merkleRoot;
    address public tokenAdress = 0x358AA13c52544ECCEF6B0ADD0f801012ADAD5eE3;
    using SafeERC20 for IERC20;
    mapping(address => bool) public whitelistClaimed;

    // verify the provided _merkleProof
    function whitelist(bytes32[] calldata _merkleProof ,uint256 _amount) public{
        require(!whitelistClaimed[msg.sender], "address has already claimed.");

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invaild proof.");

        whitelistClaimed[msg.sender] = true;

        IERC20 dropToken = IERC20(tokenAdress);
        require(
            dropToken.balanceOf(address(this)) >= _amount,
            "Insufficient balance"
        );
        dropToken.safeTransfer(msg.sender, _amount);

    }


    function setRootHash(bytes32 roothash_) external {
        merkleRoot = roothash_;
    }
}
