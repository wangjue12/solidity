// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
interface IRockXStaking{
    function getTotalStaked() external view returns (uint256);
    function getPendingEthers() external view returns (uint256);
    function getReportedValidators() external view returns (uint256);
}

contract rewardPool{

    receive() external payable { }

    address public ETHX;
    address payable public official;
    address payable public staking;

    uint256 public officialValidatorCount;
    uint256 public rewardDistributeToOfficial;
    uint256 public rewardDistributeToStaking;


    uint256 TotalStaked = IRockXStaking(ETHX).getTotalStaked();
    uint256 PendingEthers = IRockXStaking(ETHX).getPendingEthers();
    uint256 userETH = TotalStaked + PendingEthers;

    uint256 ReportedValidators = IRockXStaking(ETHX).getReportedValidators();

    uint256 officialGetRewardETH = (officialValidatorCount + ReportedValidators) * 32 - userETH;
    
    // function sendEther(address payable recipient) external payable {
    //     recipient.transfer(msg.value);
    // }

    function setETHXAddress(address _ETHX) public {
        ETHX = _ETHX;
    }

    function setOfficialAddress(address payable _official) public {
        official = _official;
    }
    
    function setStakingAddress(address payable _staking) public {
        staking = _staking;
    }

    function setOfficialValidatorCount(uint256 _officialValidatorCount) public {
        officialValidatorCount = _officialValidatorCount;
    }

    function getRewardDistributeToOfficial() public{
        rewardDistributeToOfficial = address(this).balance / ((officialValidatorCount + ReportedValidators) * 32) * officialGetRewardETH;
         
    }

    function getRewardDistributeToStaking() public{
        rewardDistributeToStaking = address(this).balance / ((officialValidatorCount + ReportedValidators) * 32) * userETH;
    }

    function transferToOfficial() public payable{
        official.transfer(rewardDistributeToOfficial);  
    }

    function transferToStaking() public payable{
        staking.transfer(rewardDistributeToStaking);  
    }

}