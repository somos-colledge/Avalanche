pragma solidity ^0.6;

import "openzeppelin-solidity/contracts/access/Ownable.sol";

contract Apuestas is Ownable {
    
    string public nombre;
    bool public apuestasAbiertas;
    string public alternativa1;    
    string public alternativa2;
    uint public ganador;
    uint public guarismo;
    uint public total1;
    uint public total2;
    
    mapping(address=>uint) public apostadores1;
    mapping(address=>uint) public apostadores2;
    
    constructor(string memory _nombre, string memory _alternativa1, string memory _alternativa2) public {
        nombre = _nombre;
        apuestasAbiertas = true;
        alternativa1 = _alternativa1;
        alternativa2 = _alternativa2;
    }
    
    function apostar(uint _alternativa) public payable {
        require(apuestasAbiertas,"Apuestas Cerradas");
        if(_alternativa == 1) {
            apostadores1[msg.sender] = apostadores1[msg.sender] + msg.value;
            total1 = total1 + msg.value;
        } else {
            apostadores2[msg.sender] = apostadores2[msg.sender] + msg.value;
            total2 = total2 + msg.value;
        }
    }
    
    function cerrarApuestas(uint _resultado) public onlyOwner {
        apuestasAbiertas= false;
        ganador = _resultado;
        if(_resultado==1) {
            guarismo = (total1+total2)/total1;
        } else {
            guarismo = (total1+total2)/total2;
        }
    }
    
    function cobrar() public {
        require(apuestasAbiertas=false,"Apuestas todavia abiertas");
        if(ganador==1) {
            require(apostadores1[msg.sender]>0);
            uint pago = apostadores1[msg.sender]*guarismo;
            apostadores1[msg.sender] = 0;
            msg.sender.transfer(pago);
        } else {
            require(apostadores2[msg.sender]>0);    
            uint pago = apostadores2[msg.sender]*guarismo;
            apostadores2[msg.sender] = 0;
            msg.sender.transfer(pago);
        }
    }    

}