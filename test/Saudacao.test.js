const { accounts, contract } = require('@openzeppelin/test-environment');
const { expect } = require('chai');

const Saudacao = contract.fromArtifact('Saudacao');
const saudacao = 'ola mundo';
describe('Saudacao', function() {
    beforeEach(async function () {
        this.contract = await Saudacao.new(saudacao);
    });

    it('deve retornar ola mundo', async function () {
        expect((await this.contract.saudar()).toString()).to.equal(saudacao);
    });
});