const { accounts, contract } = require('@openzeppelin/test-environment');
const { expect } = require('chai');

const Saudacao = contract.fromArtifact('Saudacao');
const saudacaoInicial = 'ola mundo';
const saudacaoFinal = 'a sociedade do anel';
describe('Saudacao', function () {
    const [owner] = accounts;

    beforeEach(async function () {
        this.contract = await Saudacao.new(saudacaoInicial);
    });

    it('ao publicar o contrato, deve retornar ola mundo', async function () {
        expect((await this.contract.saudar()).toString()).to.equal(saudacaoInicial);
    });

    it('emitir uma nova saudacao', async function () {
        await this.contract.EmitirSaudacao(saudacaoFinal);

        expect((await this.contract.saudar()).toString()).to.equal(saudacaoFinal);
    });
});