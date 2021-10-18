import assert = require('assert');

import {
    accounts,
    contract
} from '@openzeppelin/test-environment';

const {
    use,
    expect
} = require('chai');

const { solidity } = require('ethereum-waffle');

const truffleAssert = require('truffle-assertions');
const Madeira = contract.fromArtifact('Madeira');

use(solidity);

describe('gerenciar-madeira', () => {
    let _madeira: {
        adicionarLote: (arg0: string, arg1: string, arg2: number, arg3: { from: string; }) => any;
        obterLote: (arg0: number, arg1: { from: string; }) => any;
        contabilizarLotes:(arg0: {from: string}) => any;
    };

    const _owner = accounts[0];
    const _sender = accounts[1];
    const _descricaoNull = "";
    const _nomeFazendaNull = "";
    const _quantidadeNull = 0;
    const _descricao = "alguma descrição do lote";
    const _nomeFazenda = "nome da fazenda";
    const _quantidade = 3;

    beforeEach(async function () {
        _madeira = await Madeira.new({ from: _owner });
    });

    describe('Testando a função adicionarLote()', () => {
        it('Usuário não enviou todas as informações: Transação Revertida', async () => {
            await expect(
                _madeira.adicionarLote(_descricaoNull, _nomeFazendaNull, _quantidadeNull, { from: _sender })
            ).to.be.revertedWith("informacao invalida");
        });

        it('Ao adicionar um novo lote, deve retornar um evento: LoteAdicionado()', async () => {
            const madeira = await _madeira.adicionarLote(_descricao, _nomeFazenda, _quantidade, { from: _sender });

            truffleAssert.eventEmitted(madeira, 'LoteAdicionado', (ev: { descricao: string; nomeFazenda: string; quantidade: any }) => {
                return ev.descricao === _descricao && ev.nomeFazenda === _nomeFazenda && ev.quantidade == _quantidade;
            });
        });
    });

    describe('Testando a função obterLote()', () => {
        it('Usuário enviou um Id inválido: Transação Revertida', async () => {
            await expect(
                _madeira.obterLote(3, { from: _sender })
            ).to.be.revertedWith("lote nao encontrado");
        });

        it('Deverá retornar informações do lote', async () => {
            await _madeira.adicionarLote(_descricao, _nomeFazenda, _quantidade, { from: _sender });
            const madeira = await _madeira.obterLote(0, { from: _sender });

            assert.equal(_descricao, madeira.descricao);
            assert.equal(_nomeFazenda, madeira.nomeFazenda);
            assert.equal(_quantidade, madeira.quantidade);
        });
    });

    describe('testando a função contabilizarLotes()', () => {
        it('Deverá retornar o total de lotes', async () => {
            await _madeira.adicionarLote(_descricao, _nomeFazenda, _quantidade, { from: _sender });
            const madeira = await _madeira.contabilizarLotes({ from: _sender });
            assert.equal(madeira, 1);
        });
    });

    describe('Testando a função registrarRemessa()', () => {
        it('...: Transação Revertida', () => {

        });

        it('Ao registrar uma nova remessa, deve retornar um evento: RemessaRegistrada()', () => {

        });
    });

    // describe('Testando a mudança de estado da remessa', () => {
    //     it('...: Transação Revertida', () => {

    //     });

    //     it('Deve registrar uma remessa com o status: Iniciada', () => {

    //     });        

    //     it('Deve registrar uma remessa com o status: Em Transito', () => {

    //     });

    //     it('Deve registrar uma remessa com o status: Entregue', () => {

    //     });        
    // });    
});