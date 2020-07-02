pragma experimental ABIEncoderV2;
pragma solidity ^0.5.0;

contract Escrow {
    
    struct Payment{
        uint amount;
        address sender;
        address receiver;
        address referee;
        bool approved;
        bool delivered;
        bool canceled;
        uint timeout;
    }
    
    event PaymentSent(bytes32 _hash);
    
    mapping(bytes32=>Payment) public availablePayments;
    
    function sendPayment(address receiver, address referee, uint timeout) public payable returns(bytes32 _hash) {
        require(msg.value>0,"No vienen fondos");
        uint _amount = msg.value;
        bytes32 hash = keccak256(abi.encodePacked(msg.sender,receiver,referee,_amount,timeout));
        availablePayments[hash]=Payment(_amount,msg.sender,receiver,referee,false,false,false,timeout);
        emit PaymentSent(hash);
        return hash;
    }
    
    function approvePayment(bytes32 _hash) public {
        require(msg.sender==availablePayments[_hash].sender,"Solo puede aprobar el emisor");
        availablePayments[_hash].approved=true;
    }
    
    function withdrawPayment(bytes32 _hash) public {
        require(msg.sender==availablePayments[_hash].receiver,"Solo puede retirar el receptor");
        require(availablePayments[_hash].approved,"El emisor no ha liberado los fondos");
        require(availablePayments[_hash].canceled==false,"Pago cancelado");
        require(availablePayments[_hash].delivered==false,"Pago ya entregado");
        availablePayments[_hash].delivered=true;
        msg.sender.transfer(availablePayments[_hash].amount);
    }
    
    function cancelPayment(bytes32 _hash) public {
        require(msg.sender==availablePayments[_hash].sender,"Solo puede cancelar el emisor");
        require(block.timestamp > availablePayments[_hash].timeout,"Solo puede cancelar despues del timeout");
        require(availablePayments[_hash].delivered==false,"Pago ya entregado");
        require(availablePayments[_hash].canceled==false,"Pago ya cancelado");
        availablePayments[_hash].canceled=true;
        msg.sender.transfer(availablePayments[_hash].amount);
    }
    
    function approveByReferee(bytes32 _hash) public {
        require(msg.sender==availablePayments[_hash].referee,"No es el arbitro de este pago");
        require(availablePayments[_hash].canceled==false,"Pago cancelado");
        require(availablePayments[_hash].delivered==false,"Pago ya entregado");  
        require(availablePayments[_hash].approved==false,"Pago ya aprobado");
        availablePayments[_hash].approved=true;
    }
    
}
