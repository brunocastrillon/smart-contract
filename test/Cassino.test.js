const Cassino = artifacts.require('Cassino');
const assert = require("chai").assert;
const truffleAssert = require('truffle-assertions');

contract('Cassino', (accounts) => {
    const _cassino;
    const _coeficiente = 10;
    const _contaCassino = accounts[0];
    const _reservaCassino = 100;
    const _apostador01 = accounts[1];

    beforeEach(async () => {
        _cassino = await Cassino.new(_coeficiente, { from: _contaCassino });
        await _cassino.reserva({ from: _contaCassino, value: _reservaCassino });
    });

    afterEach(async () => {
        await _cassino.fechar(_contaCassino);
    });

    if ("deve validar a reserva total do cassino", async () => {
        assert.equal(await web3.eth.getBalance(_cassino.address), _reservaCassino);
    });

    // it("deve perder quando apostar no numero errado", async () => {
    //     let tamanhoAposta = 1;
    //     let numeroAposta = (await web3.eth.getBlock("latest")).number % 10 + 1;
    //     let transacao = await _cassino.apostar(numeroAposta, _apostador01, tamanhoAposta);

    //     truffleAssert.eventEmitted(transacao, 'Apostar', (ev) => {
    //         return ev.jogador === _apostador01 && !ev.numeroAposta.eq(ev.numeroVencedor);
    //     });

    //     truffleAssert.eventNotEmitted(transacao, 'Pagar');

    //     let reservaAtual = await web3.eth.getBalance(_cassino.address);
    //     console.log("reserva-atual: " + reservaAtual);
    //     // let novoSaldo = parseInt(reservaAtual) + (tamanhoAposta * parseInt(_coeficiente));
    //     // console.log("novo-saldo: " + novoSaldo);
    //     // assert.equal(novoSaldo, _reservaCassino + (tamanhoAposta * _coeficiente));
    // });

    // it("deve ganhar quando apostar no numero certo", async () => {
    //     let tamanhoAposta = 1;
    //     let numeroAposta = ((await web3.eth.getBlock("latest")).number + 1) % 10 + 1;
    //     let transacao = await cassino.apostar(numeroAposta, apostador01, tamanhoAposta);

    //     truffleAssert.eventEmitted(transacao, 'Apostar', (ev) => {
    //         return ev.jogador === apostador01 && ev.numeroAposta.eq(ev.numeroVencedor);
    //     });

    //     truffleAssert.eventEmitted(transacao, 'Pagar', (ev) => {
    //         return ev.vencedor === apostador01 && ev.valor.toNumber() === 10 * tamanhoAposta;
    //     });

    //     let reservaAtual = await web3.eth.getBalance(cassino.address);
    //     console.log("reserva-atual: " + reservaAtual);
    //     let novoSaldo = parseInt(reservaAtual)

    //     assert.equal(reservaAtual, reservaCassino - )

    //     //let novoSaldo = parseInt(await web3.eth.getBalance(cassino.address)) - tamanhoAposta
    //     //let teste = reservaCassino + tamanhoAposta - tamanhoAposta * 10;
    //     //console.log("teste: " + teste);
    //     //console.log("reserva-aposta: " + reservaCassino - tamanhoAposta);
    //     //assert.equal(novoSaldo, reservaCassino - tamanhoAposta);
    //     //assert.equal(await web3.eth.getBalance(cassino.address), tamanhoReserva + tamanhoAposta - tamanhoAposta * 10);
    // });     
});