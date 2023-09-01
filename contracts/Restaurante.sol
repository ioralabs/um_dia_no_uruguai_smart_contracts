// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(
        address remetente,
        address destinatario,
        uint256 valor
    ) external returns (bool);
}

contract Restaurante {
    address public dono;
    mapping(uint => Prato) public pratos;
    uint public proximoIdPrato;

    struct Prato {
        uint id;
        string nome;
        uint preco;
        bool vendido;
    }

    event PratoVendido(uint id, address cliente, string nome);

    constructor() {
        dono = msg.sender;
    }

    modifier apenasDono() {
        require(msg.sender == dono, "Apenas o dono pode adicionar pratos");
        _;
    }

    function adicionarPrato(
        string memory _nome,
        uint _preco
    ) public apenasDono {
        proximoIdPrato++;
        Prato memory novoPrato = Prato(proximoIdPrato, _nome, _preco, false);
        pratos[proximoIdPrato] = novoPrato;
    }

    function comprarPrato(uint _id, address _tokenERC20) public {
        Prato storage prato = pratos[_id];
        require(!prato.vendido, "Prato ja foi vendido");

        IERC20 token = IERC20(_tokenERC20);
        require(
            token.transferFrom(msg.sender, dono, prato.preco),
            "Falha na transferencia do token"
        );

        prato.vendido = true;
        emit PratoVendido(_id, msg.sender, prato.nome);
    }
}
