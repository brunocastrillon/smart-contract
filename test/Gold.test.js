const { accounts, contract } = require('@openzeppelin/test-environment');
const { expect } = require('chai');
const Gold = contract.fromArtifact('Gold');

describe('Gold', function () {
    const [owner] = accounts;
    const totalSupply = 3000;

    beforeEach(async function () {
        this.contract = await Gold.new(owner, totalSupply);
    });

    it('deve retornar o total de tokens emitidos', async function () {
        expect((await this.contract.balanceOf(owner)).toString()).to.equal(totalSupply.toString());
    });
});