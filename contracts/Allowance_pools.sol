//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";


contract WalletAllowance is Ownable{
    
    
    mapping(address=>uint) public allowanceMap;
    
    function isOwner()public view returns(bool){
        return msg.sender==owner();
    }
    
    
    modifier owner_and_managers(uint _amount){
        require ( isOwner() || allowanceMap[msg.sender] >= _amount ,"Not enough allowance");
        _;
    }
    
    
    function allow_account(address _person,uint _amount)public onlyOwner{
        allowanceMap[_person]=_amount;
    }

    //reduce allowance when withdrawMoney
    function reduce_allowance(address  _person,uint _amount ) internal{
        
        //set allowance
        allowanceMap[_person]-=_amount;
        
    }
    
    
    function Contract_balance()public view returns(uint){
        
       return address(this).balance;
        
    }
    
    //
    function withdraw_Money(address payable _to ,uint _amount)public owner_and_managers(_amount) {
        require(_amount <= address(this).balance,"There are no enough Wei's")    ; 
         if (!isOwner()){
             reduce_allowance(msg.sender,_amount);
         }
         
        _to.transfer(_amount);
     }
    
    //deposi
    function deposit ()external payable  {
        
        
    }
    
    
    
    
    
    
    
} 