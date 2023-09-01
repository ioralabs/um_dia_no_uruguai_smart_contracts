// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ViagemUruguai {
    address public dono;
    mapping(uint => Passagem) public passagens;
    uint public proximoIdPassagem;

    struct Passagem {
        uint id;
        address donoPassagem;
        string nomePassageiro;
        bool checkinRealizado;
    }

    event PassagemEmitida(uint id, address donoPassagem, string nomePassageiro);
    event CheckinRealizado(uint id);
    event PassagemTransferida(uint id, address novoDono);

    constructor() {
        dono = msg.sender;
    }

    modifier apenasDono() {
        require(msg.sender == dono, "Apenas o dono pode emitir passagens");
        _;
    }

    modifier apenasDonoPassagem(uint _id) {
        require(msg.sender == passagens[_id].donoPassagem, "Apenas o dono da passagem pode realizar esta operacao");
        _;
    }

    function emitirPassagem(address _donoPassagem, string memory _nomePassageiro) public apenasDono {
        proximoIdPassagem++;
        Passagem memory novaPassagem = Passagem(proximoIdPassagem, _donoPassagem, _nomePassageiro, false);
        passagens[proximoIdPassagem] = novaPassagem;

        emit PassagemEmitida(proximoIdPassagem, _donoPassagem, _nomePassageiro);
    }

    function fazerCheckin(uint _id) public apenasDonoPassagem(_id) {
        Passagem storage passagem = passagens[_id];
        require(!passagem.checkinRealizado, "Check-in ja foi realizado");

        passagem.checkinRealizado = true;
        emit CheckinRealizado(_id);
    }

    function transferirPassagem(uint _id, address _novoDono) public apenasDonoPassagem(_id) {
        Passagem storage passagem = passagens[_id];
        passagem.donoPassagem = _novoDono;

        emit PassagemTransferida(_id, _novoDono);
    }
}
