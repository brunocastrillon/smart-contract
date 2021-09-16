const {
    accounts,
    contract } = require('@openzeppelin/test-environment');

const {
    deployContract,
    MockProvider,
    solidity } = require('ethereum-waffle');

const {
    use,
    expect } = require('chai');
    
const { ethers } = require('ethers');
const truffleAssert = require('truffle-assertions');

const Vendor = contract.fromArtifact('Vendor');
const Gold = contract.fromArtifact('Gold');

use(solidity);

describe('vendor-dapp', function () {
    let _vendor;
    let _token
    let _vendorTokensSupply;
    let _paridade;

    const _owner = accounts[0];
    const _addr1 = accounts[1];
    const _addr2 = accounts[2];
    const _addr3 = accounts[3];
    const _supply = 1000 * 10 ** 18;

    beforeEach(async function () {
        _token = await Gold.new({ from: _owner });
        _vendor = await Vendor.new(_token.address);

        await _token.transfer(_vendor.address, ethers.utils.parseEther('1000'), { from: _owner });
        await _vendor.transferOwnership(_owner);

        _vendorTokensSupply = await _token.balanceOf(_vendor.address);
        _paridade = await _vendor._paridade();
    });

    describe('testando o metodo comprar()', () => {
        // it('comprador nao enviou ETH suficiente, transacao foi revertida', async () => {
        //     const amount = ethers.utils.parseEther('0');

        //     await expect(
        //         _vendor.comprar({ from: _addr1, value: amount })
        //     ).to.be.revertedWith("quantidade de ETH insuficiente");
        // });

        // it('distribuidor nao possui tokens suficiente, transacao foi revertida', async () => {
        //     const amount = ethers.utils.parseEther('93');

        //     await expect(
        //         _vendor.comprar({ from: _addr1, value: amount })
        //     ).to.be.revertedWith("saldo do distribuidor insuficiente");
        // });

        it('token comprado com sucesso', async () => {
            const amount = ethers.utils.parseEther('1.0');

            // - checando se o processo de compra ocorreu com sucesso e se emitu o evento
            let vendor = await _vendor.comprar({ from: _addr1, value: amount });
            truffleAssert.eventEmitted(vendor, 'ComprarToken', (ev) => {
                return ev.comprador === _addr1 && ev.quantidadeETH == amount.toString(10) && ev.quantidadeGLD == amount.mul(_paridade.toString()).toString(10);
            });

            // - checando o saldo de tokens do usuario
            const userTokenBalance = await _token.balanceOf(_addr1);
            const userTokenAmount =  ethers.utils.parseEther('100.0');
            expect(userTokenBalance.toString()).to.equal(userTokenAmount.toString(10));

            // - checando o saldo de tokens do distribuidor
            const vendorTokenBalance = await _token.balanceOf(_vendor.address);
            expect(vendorTokenBalance.toString()).to.equal(ethers.BigNumber.from(_vendorTokensSupply.toString()).sub(userTokenAmount).toString());

            // - checando o saldo de ETH do distribuidor
            const vendorBalance = await ethers.provider.getBalance(_vendor.address);
        });        
    });
});

// - checando se o processo de compra ocorreu com sucesso e se emitu o evento
// - Error: [object Promise] is not a valid transaction
// await expect(
//     _vendor.comprar({ from: _addr1, value: amount })
// ).to.emit(_vendor, 'ComprarToken').withArgs(_addr1, amount.toString(10), amount.mul(_paridade.toString()).toString(10));