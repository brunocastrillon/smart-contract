// // 1º - mode de realizar testes, utilizando Chai
// // const { expect } = require('chai');

// // // Load compiled artifacts
// // const Box = artifacts.require('Box');

// // // Start test block
// // contract('Box', function () {
// //     beforeEach(async function () {
// //         // Deploy a new Box contract for each test
// //         this.box = await Box.new();
// //     });

// //     // Test case
// //     it('retrieve returns a value previously stored', async function () {
// //         // Store a value
// //         await this.box.store(42);

// //         // Test if the returned value is the same one
// //         // Note that we need to use strings to compare the 256 bit integers
// //         expect((await this.box.retrieve()).toString()).to.equal('42');
// //     });
// // });

// // 2º - primeira forma mais elaborada, agora validando o Owner
// // const { expect } = require('chai');

// // // Import utilities from Test Helpers
// // const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');

// // // Load compiled artifacts
// // const Box = artifacts.require('Box');

// // // Start test block
// // contract('Box', function ([owner, other]) {
// //     // Use large integers ('big numbers')
// //     const value = new BN('42');

// //     beforeEach(async function () {
// //         this.box = await Box.new({ from: owner });
// //     });

// //     it('retrieve returns a value previously stored', async function () {
// //         await this.box.store(value, { from: owner });

// //         // Use large integer comparisons
// //         expect(await this.box.retrieve()).to.be.bignumber.equal(value);
// //     });

// //     it('store emits an event', async function () {
// //         const receipt = await this.box.store(value, { from: owner });

// //         // Test that a ValueChanged event was emitted with the new value
// //         expectEvent(receipt, 'ValueChanged', { value: value });
// //     });

// //     it('non owner cannot store a value', async function () {
// //         // Test a transaction reverts
// //         await expectRevert(
// //             this.box.store(value, { from: other }),
// //             'Ownable: caller is not the owner',
// //         );
// //     });
// // });


// // - 3º mode de realizar testes, utilizando Mocha/Chai
// const { accounts, contract } = require('@openzeppelin/test-environment');
// const { expect } = require('chai');

// const Box = contract.fromArtifact('Box');

// describe('Box', function () {
//     const [owner] = accounts;

//     beforeEach(async function () {
//         this.contract = await Box.new({ from: owner });
//     });

//     it('retrieve retorna o valor preveamente armazenado', async function () {
//         await this.contract.store(42, { from: owner });

//         // Note that we need to use strings to compare the 256 bit integers
//         expect((await this.contract.retrieve()).toString()).to.equal('42');
//     });
// });