const { accounts, contract } = require('@openzeppelin/test-environment');
const { expect } = require('chai');
const Counter = contract.fromArtifact('Counter');

describe('Counter', function () {

    beforeEach(async function () {
        this.contract = await Counter.new();
    });

    it(`deve incrementar o contador`, async function () {
        await this.contract.increase();

        // expect((await this.contract.balanceOf(account001)).toString()).to.equal(transfer);
    });
});