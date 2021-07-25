const Cassino = artifacts.require('Cassino');
const assert = require("chai").assert;
const truffleAssert = require('truffle-assertions');

contract('Cassino', (accounts) => {
    let _cassino;
    const _contaCassino = accounts[0];
    const _reservaCassino = 100;
    const _apostador01 = accounts[1];

    beforeEach(async () => {
        _cassino = await Cassino.new({ from: _contaCassino, value: _reservaCassino });
    });

    afterEach(async () => {
        await _cassino.fechar(_contaCassino);
    });

    it("deve validar a reserva total do cassino", async () => {
        let reservaAtual = await web3.eth.getBalance(_cassino.address);
        assert.equal(reservaAtual, _reservaCassino);
    });

    it("deve validar o coeficiente", async () => {
        let coeficiente = await _cassino.obterCoeficiente();
        assert.equal(coeficiente, _reservaCassino / 10);
    });

    it("deve perder quando apostar no numero errado", async () => {
        let tamanhoAposta = 1;
        let coeficiente = await _cassino.obterCoeficiente();
        let numeroAposta = (await web3.eth.getBlock("latest")).number % parseInt(coeficiente) + 1;
        let transacao = await _cassino.apostar(numeroAposta, _apostador01, tamanhoAposta);

        truffleAssert.eventEmitted(transacao, 'Apostar', (ev) => {
            return ev.jogador === _apostador01 && !ev.numeroAposta.eq(ev.numeroVencedor);
        });

        truffleAssert.eventNotEmitted(transacao, 'Pagar');

        await _cassino.coletar({ from: _apostador01, value: tamanhoAposta });

        let reservaAtual = await web3.eth.getBalance(_cassino.address);
        assert.equal(reservaAtual, _reservaCassino + tamanhoAposta);
    });

    it("deve ganhar quando apostar no numero certo", async () => {
        let tamanhoAposta = 1;
        let coeficiente = await _cassino.obterCoeficiente();
        let numeroAposta = ((await web3.eth.getBlock("latest")).number + 1) % coeficiente + 1;
        let transacao = await _cassino.apostar(numeroAposta, _apostador01, tamanhoAposta);

        truffleAssert.eventEmitted(transacao, 'Apostar', (ev) => {
            return ev.jogador === _apostador01 && ev.numeroAposta.eq(ev.numeroVencedor);
        });

        truffleAssert.eventEmitted(transacao, 'Pagar', (ev) => {
            return ev.vencedor === _apostador01 && ev.valor.toNumber() === coeficiente * tamanhoAposta;
        });

        let reservaAtual = await web3.eth.getBalance(_cassino.address);
        assert.equal(reservaAtual, _reservaCassino - (coeficiente * tamanhoAposta));
    })
});