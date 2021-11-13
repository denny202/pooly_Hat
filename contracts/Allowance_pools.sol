//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";


contract Wallet_allowance is Ownable{

    
    mapping(address=>uint) public allowance_map;


    event Allowance_event(address indexed _toperson , address indexed _fromperson,uint _oldamount,uint _newamount );

    event sentFunds(address indexed _to,uint _amount );
    
    event depositedFunds(address indexed _from ,uint _amount);

    
    function isOwner()public view returns(bool){
        return msg.sender==owner();
    }
    
    
    modifier owner_and_managers(uint _amount){
        require ( isOwner() || allowance_map[msg.sender] >= _amount ,"Not enough allowance");
        _;
    }
    
    
    function allow_account(address _person,uint _amount)public onlyOwner{
        emit Allowance_event(_person,msg.sender,allowance_map[_person],_amount);
        
        allowance_map[_person]=_amount;
    }

    //reduce allowance when withdrawMoney
    function reduce_allowance(address  _person,uint _amount ) internal{
        
        emit Allowance_event(_person,msg.sender,allowance_map[_person],allowance_map[_person]-_amount);
        //set allowance
        allowance_map[_person]-=_amount;
        
    }
    
    
    function Contract_balance()public view returns(uint){
        
       return address(this).balance;
        
    }
    

    function withdraw_Money(address payable _to ,uint _amount)public owner_and_managers(_amount) {
        require(_amount <= address(this).balance,"There are no enough Wei's")    ; 
         if (!isOwner()){
             reduce_allowance(msg.sender,_amount);
         }
         emit sentFunds(_to,_amount);
        _to.transfer(_amount);
     }
    
    //deposi
    function deposit ()external payable  {
        
        emit depositedFunds(msg.sender,msg.value);
        
    }
    

    
} 