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

    function transfer(address to ,uint tokens) public override returns(bool success){
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

    function transferFrom(address from ,address to ,uint tokens) public override returns(bool success){
        require(allowed[from][to] >= tokens);
        require(balances[from] >= tokens);
        balances[from] = balances[from] - tokens;
        balances[to] = balances[to] + tokens;
        allowed[from][to] = allowed[from][to] - tokens;

        return true;

    }


}