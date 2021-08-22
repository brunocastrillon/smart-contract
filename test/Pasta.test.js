const Pasta = artifacts.require('Pasta');
const assert = require("chai").assert;
const truffleAssert = require('truffle-assertions');

contract('Pasta', (accounts) => {
    let _pasta;
    const _remetente = accounts[0];
    const _hash = "0x64EC88CA00B268E5BA1A35678A1B5316D212F4F366B2477232534A8AECA37F3C";
    const _nome = "arquivo-teste.pdf";
    const _tipo = "tipo-01";
    const _data = (new Date()).getTime();

    beforeEach(async () => {
        _pasta = await Pasta.new();
    });

    it("deve adicionar um novo arquivo", async () => {
        let arquivo = await _pasta.adicionar(_hash, _nome, _tipo, _data, { from: _remetente });

        truffleAssert.eventEmitted(arquivo, 'adicionado', (ev) => {
            return ev.hashh === _hash && ev.remetente === _remetente;
        });
    });

    it("deve retornar o total de arquvivos", async () => {
        await _pasta.adicionar(_hash, _nome, _tipo, _data, { from: _remetente });
        let arquivos = await _pasta.listar({ from: _remetente });
        assert.equal(arquivos, 1);
    });

    it("deve retornar informacoes do arquivo", async () => {
        await _pasta.adicionar(_hash, _nome, _tipo, _data, { from: _remetente });
        let arquivo = await _pasta.ler(0, { from: _remetente });

        assert.equal(_hash, arquivo.hashh);
        assert.equal(_nome, arquivo.nome);
        assert.equal(_tipo, arquivo.tipo);
        assert.equal(_data, arquivo.data);
    });
});