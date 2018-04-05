pragma solidity ^0.4.18;

import "./math.sol";

/*
 * ERC20 interface
 */
contract ERC20 {
  uint public totalSupply;
  function balanceOf(address who) constant returns (uint);
  function transfer(address to, uint value);
  function allowance(address owner, address spender) constant returns (uint);

  function transferFrom(address from, address to, uint value);
  function approve(address spender, uint value);

  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}

contract ExxStandart is ERC20 {
    using SafeMath for uint;
    
	string  public name        = "Exxcoin";
    string  public symbol      = "EXX";
    uint8   public decimals    = 0;

	mapping (address => mapping (address => uint)) allowed;
	mapping (address => uint) balances;

	function transferFrom(address _from, address _to, uint _value) {
		balances[_from] = balances[_from].sub(_value);
		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
		balances[_to] = balances[_to].add(_value);
		Transfer(_from, _to, _value);
	}

	function approve(address _spender, uint _value) {
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
	}

	function allowance(address _owner, address _spender) constant returns (uint remaining) {
		return allowed[_owner][_spender];
	}

	function transfer(address _to, uint _value) {
		balances[msg.sender] = balances[msg.sender].sub(_value);
		balances[_to] = balances[_to].add(_value);
		Transfer(msg.sender, _to, _value);
	}

	function balanceOf(address _owner) constant returns (uint balance) {
		return balances[_owner];
	}
}

contract owned {
    
    address public owner;
    address public newOwner;
	
    function owned() public payable {
        owner = msg.sender;
    }
	
    modifier onlyOwner {
        require(owner == msg.sender);
        _; /* return */
    }
	
    function changeOwner(address _owner) onlyOwner public {
        require(_owner != 0);
        newOwner = _owner;
    }
    
    function confirmOwner() public {
        require(newOwner == msg.sender);
        owner = newOwner;
        delete newOwner;
    }
}

contract Exxcoin is owned, ExxStandart {
	address public manager = 0x123;

	modifier onlyManager {
		require(manager == msg.sender);
		_;
	}
    
    function changeTotalSupply(uint _totalSupply) onlyOwner public {
        totalSupply = _totalSupply;
    }
    
	function setManager(address _manager) onlyOwner public {
		manager = _manager;
	}

	function delManager() onlyOwner public {
		manager = 0x123;
	}

    function () payable {
		
	}

    function sendTokensManager(address _to, uint _tokens) onlyManager public{
		require(manager != 0x123);
		_to.send(_tokens);
		balances[_to] = _tokens;
        Transfer(msg.sender, _to, _tokens);
	}

    function sendTokens(address _to, uint _tokens) onlyOwner public{
		_to.send(_tokens);
		balances[_to] = _tokens;
        Transfer(msg.sender, _to, _tokens);
    }
}