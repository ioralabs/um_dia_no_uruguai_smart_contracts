// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract Barbearia {
    address public dono;
    mapping(uint => Servico) public servicos;
    uint public proximoIdServico;

    struct Servico {
        uint id;
        string nomeServico;
        uint preco;
        bool realizado;
    }

    event ServicoRealizado(uint id, address cliente, string nomeServico);

    constructor() {
        dono = msg.sender;
    }

    modifier apenasDono() {
        require(msg.sender == dono, "Apenas o dono pode adicionar servicos");
        _;
    }

    function adicionarServico(string memory _nomeServico, uint _preco) public apenasDono {
        proximoIdServico++;
        Servico memory novoServico = Servico(proximoIdServico, _nomeServico, _preco, false);
        servicos[proximoIdServico] = novoServico;
    }

    function realizarServico(uint _id, address _tokenERC20) public {
        Servico storage servico = servicos[_id];
        require(!servico.realizado, "Servico ja foi realizado");
        require(_tokenERC20 != address(0), "Invalid ERC20 token address");

        IERC20 token = IERC20(_tokenERC20);
        require(token.transferFrom(msg.sender, dono, servico.preco), "Transferencia de token falhou");

        servico.realizado = true;
        emit ServicoRealizado(_id, msg.sender, servico.nomeServico);
    }
}
