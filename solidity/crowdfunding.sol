pragma solidity ^0.8.0;
contract CrowdFunding{
    mapping(address => uint) public contributors;
    address public admin;
    uint public noOfContributor;
    uint public minmumContribution;
    uint public deadline;
    uint public goal;
    uint public raiseAmount;

    event ContributeEvent(address _sender,uint _value);
    event CreateRequestEvent(string _description,address _recipient,uint _value);
    event MakePaymentEvent(address _recipient,uint _value);

    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint => Request) public requests;
    uint public numRequests;


    constructor(uint _goal, uint _deadline){
        goal=_goal;
        deadline = block.timestamp + _deadline;
        minmumContribution=100 wei;
        admin=msg.sender;
    }
    function contribute() payable public {
        require(block.timestamp < deadline);
        require(msg.value > minmumContribution);

        if(contributors[msg.sender]==0){
            noOfContributor++;
        }
        contributors[msg.sender]=contributors[msg.sender]+msg.value;
        raiseAmount = raiseAmount + msg.value;

        emit ContributeEvent(msg.sender,msg.value);

    }
    receive() payable external{
        contribute();
    }
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    function getReFund() public{
        require(block.timestamp > deadline && raiseAmount < goal);
        require(contributors[msg.sender] > 0);

        address payable recipient = payable(msg.sender);
        recipient.transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0;

    }
    
    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }

    function createRequest(string memory _description,address payable _recipient, uint _value) public onlyAdmin{
        Request storage newRequest = requests[numRequests];
        numRequests++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;

        emit CreateRequestEvent(newRequest.description,newRequest.recipient,newRequest.value);

    }

    function voteRequest(uint _requestNo) public{
        require(contributors[msg.sender] > 0);
        Request storage thisRequest = requests[_requestNo];

        require(thisRequest.voters[msg.sender] == false);
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyAdmin{
        require(raiseAmount > goal);
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false);
        require(thisRequest.noOfVoters > noOfContributor / 2);
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;

        emit MakePaymentEvent(thisRequest.recipient,thisRequest.value);
    }

}