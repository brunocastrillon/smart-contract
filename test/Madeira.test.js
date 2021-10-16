const {
    accounts,
    contract,
    web3 } = require('@openzeppelin/test-environment');

const {
    use,
    expect } = require('chai');

const { solidity } = require('ethereum-waffle');
const { ethers } = require('ethers');

const truffleAssert = require('truffle-assertions');

const Madeira = contract.fromArtifact('Madeira');

use(solidity);

describe('gerenciar-madeira', () => {
    let _madeira;
    const _owner = accounts[0];

    beforeEach(async function () {
        _madeira = await Madeira.new({ from: _owner });
    });

    describe('Testando a função adicionarLote()', () => {
        it('...: Transacao Revertida', () => {

        });

        it('Ao adicionar um novo lote, deve retornar um evento: LoteAdicionado()', () => {

        });
    });

    describe('Testando a função registrarRemessa()', () => {
        it('...: Transacao Revertida', () => {

        });

        it('Ao registrar uma nova remessa, deve retornar um evento: RemessaRegistrada()', () => {

        });
    });

    describe('Testando a mudança de estado da remessa', () => {
        it('...: Transacao Revertida', () => {

        });

        it('Deve registrar uma remessa com o status: Iniciada', () => {

        });        

        it('Deve registrar uma remessa com o status: Em Transito', () => {

        });

        it('Deve registrar uma remessa com o status: Entregue', () => {

        });        
    });    
});