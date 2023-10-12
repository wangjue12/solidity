// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 
import "hardhat/console.sol";
// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
// <import file to test>
import "../contracts/MyToken.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract MyTokenTest {
    MyToken myToken;

    function beforeEach() public {
        myToken = new MyToken();
    }

    function testname() public{
        Assert.equal(myToken.name(), "MyToken", "name should be MyToken");
    }

    function testsymbol() public{
        Assert.equal(myToken.symbol(), "MTK", "symbol should be MTK");
    }

    function testSetDxpoolStakingFeePool() public{

        myToken.setDxpoolStakingFeePool(address(0x5FD6eB55D12E759a21C09eF703fe0CBa1DC9d88D));
        Assert.equal(address(myToken.DxpoolStakingFeePool()), address(0x5FD6eB55D12E759a21C09eF703fe0CBa1DC9d88D) , "DxpoolStakingFeePool address should be 0x5FD6eB55D12E759a21C09eF703fe0CBa1DC9d88D");
            
    }

    function testSetDxpoolStakingFeePoolfailed() public{

        myToken.setDxpoolStakingFeePool(address(0x5FD6eB55D12E759a21C09eF703fe0CBa1DC9d88D));
        Assert.equal(address(myToken.DxpoolStakingFeePool()), address(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db) , "DxpoolStakingFeePool address should be 0x5FD6eB55D12E759a21C09eF703fe0CBa1DC9d88D");
        
        console.log(address(myToken.DxpoolStakingFeePool()));
    
    }

    function testSetDxpoolStakingFeePoolfailed1() public{

        myToken.setDxpoolStakingFeePool(address(0x0));
        Assert.equal(address(myToken.DxpoolStakingFeePool()), address(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db) , "DxpoolStakingFeePool address should be 0x5FD6eB55D12E759a21C09eF703fe0CBa1DC9d88D");
        
        console.log(address(myToken.DxpoolStakingFeePool()));
    
    }

    function testSetRootHash() public{

        bytes32[] memory merkleRoot = new bytes32[](3);
        merkleRoot[0] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe);
        merkleRoot[1] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe);
        merkleRoot[2] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe);

        myToken.setRootHash(merkleRoot);
        Assert.equal(bytes32(myToken.merkleRoot(0)), bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe) , "merkleRoot[0]  should be 0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe");
    }

    function testSetRootHash1() public{

        bytes32[] memory merkleRoot = new bytes32[](3);
        merkleRoot[0] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe);
        merkleRoot[1] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe);
        merkleRoot[2] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe);

        myToken.setRootHash(merkleRoot);
        Assert.equal(bytes32(myToken.merkleRoot(1)), bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe) , "merkleRoot[0]  should be 0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe");
    }

    function testSetRootHash2() public{

        bytes32[] memory merkleRoot = new bytes32[](3);
        merkleRoot[0] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe);
        merkleRoot[1] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe);
        merkleRoot[2] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe);

        myToken.setRootHash(merkleRoot);
        Assert.equal(bytes32(myToken.merkleRoot(2)), bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe) , "merkleRoot[0]  should be 0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe");
    }

    function testSetRootHashfailed() public{

        bytes32[] memory merkleRoot = new bytes32[](3);
        merkleRoot[0] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bb1);
        merkleRoot[1] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe);
        merkleRoot[2] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe);

        myToken.setRootHash(merkleRoot);
        Assert.equal(bytes32(myToken.merkleRoot(0)), bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe) , "merkleRoot[0]  should be 0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe");
        
    }

    function testSetRootHashfailed1() public{

        bytes32[] memory merkleRoot = new bytes32[](3);
        merkleRoot[0] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bb1);
        merkleRoot[1] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bb1);
        merkleRoot[2] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bb1);

        myToken.setRootHash(merkleRoot);
        Assert.equal(bytes32(myToken.merkleRoot(1)), bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe) , "merkleRoot[0]  should be 0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe");
        
    }

    function testSetRootHashfailed2() public{

        bytes32[] memory merkleRoot = new bytes32[](3);
        merkleRoot[0] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bb1);
        merkleRoot[1] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bb1);
        merkleRoot[2] = bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bb1);

        myToken.setRootHash(merkleRoot);
        Assert.equal(bytes32(myToken.merkleRoot(2)), bytes32(0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe) , "merkleRoot[0]  should be 0x53c4e5e25bcbb26b82784b9793d8a74a02719aabab34c2d0358b26231e2f4bbe");
        
    }

    function testSetPrefixURI() public{

        myToken.setPrefixURI("ipfs://");
        Assert.equal(myToken._prefixURI(), "ipfs://" , "PrefixURI should be ipfs://");
            
    }

    function testSetPrefixURIfailed() public{

        myToken.setPrefixURI("ipfs:///");
        Assert.equal(myToken._prefixURI(), "ipfs://" , "PrefixURI should be ipfs://");
        console.log(myToken._prefixURI());    
    }

    function testSetPrefixURIfailed1() public{

        myToken.setPrefixURI("");
        Assert.equal(myToken._prefixURI(), "ipfs://" , "PrefixURI should be ipfs://");
        console.log(myToken._prefixURI());    
    }

    function testSetMaxSupply() public{

        uint256[] memory maxSupply = new uint256[](3);
        maxSupply[0] = 10;
        maxSupply[1] = 10;
        maxSupply[2] = 10;

        myToken.setMaxSupply(maxSupply);
        Assert.equal(myToken.maxSupply(0), 10 , "maxSupply should be 10");
            
    }

    function testSetMaxSupplyfailed() public{

        uint256[] memory maxSupply = new uint256[](3);
        maxSupply[0] = 1;
        maxSupply[1] = 10;
        maxSupply[2] = 10;

        myToken.setMaxSupply(maxSupply);
        Assert.equal(myToken.maxSupply(0), 10 , "maxSupply should be 10");
        console.log(myToken.maxSupply(0));        
    }

    function testSetMaxSupplyfailed1() public{

        uint256[] memory maxSupply = new uint256[](3);
        maxSupply[0] = 1;
        maxSupply[1] = 1;
        maxSupply[2] = 1;

        myToken.setMaxSupply(maxSupply);
        Assert.equal(myToken.maxSupply(1), 10 , "maxSupply should be 10");
        console.log(myToken.maxSupply(1));        
    }

    function testSetMaxSupplyfailed2() public{

        uint256[] memory maxSupply = new uint256[](3);
        maxSupply[0] = 1;
        maxSupply[1] = 1;
        maxSupply[2] = 1;

        myToken.setMaxSupply(maxSupply);
        Assert.equal(myToken.maxSupply(2), 10 , "maxSupply should be 10");
        console.log(myToken.maxSupply(2));        
    }

    function testSetMaxSupplyfailed3() public{

        uint256[] memory maxSupply = new uint256[](3);
        maxSupply[1] = 10;
        maxSupply[2] = 10;

        myToken.setMaxSupply(maxSupply);
        Assert.equal(myToken.maxSupply(2), 10 , "maxSupply should be 10");
        console.log(myToken.maxSupply(2));        
    }    

    function testSetMaxSupplyfailed4() public{

        uint256[] memory maxSupply = new uint256[](3);
        maxSupply[1] = 10;
        maxSupply[2] = 10;

        myToken.setMaxSupply(maxSupply);
        Assert.equal(myToken.maxSupply(0), 10 , "maxSupply should be 10");
        console.log(myToken.maxSupply(0));        
    }  

}
    