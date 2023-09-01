// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address remetente, address destinatario, uint256 valor) external returns (bool);
}

contract Cafeteria {
    address public dono;
    mapping(uint => Cafe) public cafes;
    uint public proximoIdCafe;

    struct Cafe {
        uint id;
        string nome;
        uint preco;
        bool vendido;
    }

    event CafeVendido(uint id, address cliente, string nome);

    constructor() {
        dono = msg.sender;
    }

    modifier apenasDono() {
        require(msg.sender == dono, "Apenas o dono pode adicionar cafes");
        _;
    }

    function adicionarCafe(string memory _nome, uint _preco) public apenasDono {
        proximoIdCafe++;
        Cafe memory novoCafe = Cafe(proximoIdCafe, _nome, _preco, false);
        cafes[proximoIdCafe] = novoCafe;
    }

    function comprarCafe(uint _id, address _tokenERC20) public {
        Cafe storage cafe = cafes[_id];
        require(!cafe.vendido, "Cafe ja foi vendido");

        IERC20 token = IERC20(_tokenERC20);
        require(token.transferFrom(msg.sender, dono, cafe.preco), "Falha na transferencia do token");

        cafe.vendido = true;
        emit CafeVendido(_id, msg.sender, cafe.nome);
    }
}
