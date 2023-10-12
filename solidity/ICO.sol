pragma solidity ^0.8.17;

interface ERC20Interface{
    function totalSupply() external view returns(uint);
    function balanceOf(address tokenOwner) external view returns(uint balance);
    function transfer(address to ,uint tokens) external returns(bool success);

    function allowance(address tokenOwner,address spender) external view returns(uint remaining);
    function approve(address spender ,uint tokens) external returns (bool success);
    function transferFrom(address from ,address to ,uint tokens) external returns(bool success);
    
    event Transfer(address indexed from,address indexed to,uint tokens);
    event Approal(address indexed tokenOwner, address indexed spender ,uint tokens);

}

contract ERC20 is ERC20Interface{
    string public name ="MyCoin";
    string public symbol ="MC";
    uint public decimals = 18;
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;

    mapping(address => mapping(address => uint)) allowed;

    constructor(){
        totalSupply =100000;
        founder =msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns(uint balance){
        return balances[tokenOwner];
    }

    function transfer(address to ,uint tokens) public virtual override returns(bool success){
        require(balances[msg.sender]>tokens);
        balances[msg.sender] = balances[msg.sender] - tokens;
        balances[to] = balances[to] + tokens;
        emit Transfer(msg.sender ,to, tokens);

        return true;
    }

    function allowance(address tokenOwner, address spender) view public override returns(uint){
        return allowed[tokenOwner][spender];
    }

    function approve(address spender ,uint tokens) public override returns(bool success){
        require(balances[msg.sender]>tokens);
        require(tokens > 0);
        allowed[msg.sender][spender] = tokens;

        emit Approal(msg.sender ,spender, tokens);
        return true;
    }

    function transferFrom(address from ,address to ,uint tokens) public virtual override returns(bool success){
        require(allowed[from][to] >= tokens);
        require(balances[from] >= tokens);
        balances[from] = balances[from] - tokens;
        balances[to] = balances[to] + tokens;
        allowed[from][to] = allowed[from][to] - tokens;

        return true;

    }


}

contract ICO is ERC20{
    address public admin;
    address payable public deposit;
    uint public tokenPrice =0.001 ether;
    uint public hardCap = 300 ether;
    uint public raiseAmount;
    uint public saleStart = block.timestamp;
    uint public saleEnd = block.timestamp + 10000;
    uint public tokenTradeStart = saleEnd + 10000;
    uint public maxInvestment = 5 ether;
    uint public minInvestment = 0.1 ether;

    enum State{beforeStart , running , afterEnd , halted}
    State public icoState;

    constructor(address payable _deposit){
        deposit = _deposit;
        admin = msg.sender;
        icoState = State.beforeStart;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }

    function halt() public onlyAdmin{
        icoState = State.halted;
    }

    function resume() public onlyAdmin{
        icoState = State.running;
    }
    
    function changeDepositAddress(address payable newDeposit) public onlyAdmin{
        deposit = newDeposit;

    }

    function getCurrentState() public view returns(State){
        if(icoState == State.halted){
            return State.halted;
        }else if(block.timestamp <= saleStart){
            return State.beforeStart;
        }else if(block.timestamp > saleStart && block.timestamp <= saleEnd){
            return State.running;
        }else{
            return State.afterEnd;
        }
    }

    event Invest(address investor , uint value ,uint tokens);

    function invest() payable public returns(bool){
        icoState = getCurrentState();
        require(icoState == State.running);

        require(msg.value >= minInvestment && msg.value <= maxInvestment);
        raiseAmount = raiseAmount + msg.value;
        require(raiseAmount <= hardCap);
        uint tokens = msg.value / tokenPrice;
        balances[founder] = balances[founder] - tokens;
        balances[msg.sender] = balances[msg.sender] + tokens;
        deposit.transfer(msg.value);
        emit Invest(msg.sender , msg.value , tokens);
        return true;
    }

    receive() payable external {
        invest();
    }

    function transfer(address to ,uint tokens) public override returns(bool success){
        require(block.timestamp > tokenTradeStart);
        super.transfer(to,tokens);
        return true;

    }


    function transferFrom(address from ,address to ,uint tokens) public override returns(bool success){

        require(block.timestamp > tokenTradeStart);
        super.transferFrom(from,to,tokens);
        return true;

    }
    
    function burn() public returns(bool){
        icoState = getCurrentState();
        require(icoState == State.afterEnd);
        balances[founder] = 0;
        return true;

    }

}


