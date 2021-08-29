// const { accounts, contract } = require('@openzeppelin/test-environment');
// const { expect } = require('chai');
// const Gold = contract.fromArtifact('Gold');

// describe('Gold', function () {
//     const [owner] = accounts;
//     const supply = 3000000;
//     const transfer = 4000000;
//     const account001 = "0xeF0af390c20A0b58f5A5a15F79e2f79F0A8082bF";

//     beforeEach(async function () {
//         this.contract = await Gold.new(owner, supply);
//     });

//     it('deverá validar o saldo da carteira ' + owner, async function () {
//         expect((await this.contract.balanceOf(owner)).toString()).to.equal(supply.toString());
//     });

//     it('deverá retornar o total igual a ' + supply, async function () {
//         expect((await this.contract.totalSupply()).toString()).to.equal(supply.toString());
//     });

//     // it(`deverá realizar uma aprovacao de transferencia de ${owner}`, async function () {
//     //     const aprovado = await this.contract.approve(owner, transfer);
//     //     expect((await this.contract.approve(owner, transfer))).to.equal(true);
//     // });

//     // it(`deverá realizar uma transferencia de ${owner} para ${account001}`, async function () {
//     //     await this.contract.approve(owner, transfer);
//     //     await this.contract.transferFrom(owner, account001, transfer);
//     //     expect((await this.contract.balanceOf(account001)).toString()).to.equal(transfer);
//     // });
// });

// // 0xEBf7f56cf9A8F8fc942CEE8a41f2F530DAed8586
// // 0xeF0af390c20A0b58f5A5a15F79e2f79F0A8082bF