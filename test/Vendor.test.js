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

    beforeEach(async function () {
        _token = await Gold.new({ from: _owner });
        _vendor = await Vendor.new(_token.address);

        await _token.transfer(_vendor.address, ethers.utils.parseEther('1000'), { from: _owner });
        await _vendor.transferOwnership(_owner);

        _vendorTokensSupply = await _token.balanceOf(_vendor.address);
        _paridade = await _vendor._paridade();
    });

    describe('testando o metodo comprar()', () => {
        it('comprador nao enviou ETH suficiente, transacao foi revertida', async () => {
            const amount = ethers.utils.parseEther('0').toString();

            await expect(
                _vendor.comprar({ from: _addr1, value: amount })
            ).to.be.revertedWith("quantidade de ETH insuficiente");
        });

        it('distribuidor nao possui tokens suficiente, transacao foi revertida', async () => {
            const amount = ethers.utils.parseEther('93').toString();

            await expect(
                _vendor.comprar({ from: _addr1, value: amount })
            ).to.be.revertedWith("saldo do distribuidor insuficiente");
        });

        describe('token comprado com sucesso', () => {
            const amount = ethers.utils.parseEther('1.0');
            let userTokenAmount;

            it('evento emitido: ComprarToken', async () => {
                let vendor = await _vendor.comprar({ from: _addr1, value: amount.toString() });
                truffleAssert.eventEmitted(vendor, 'ComprarToken', (ev) => {
                    return ev.comprador === _addr1 && ev.quantidadeETH == amount.toString() && ev.quantidadeGLD == amount.mul(_paridade.toString()).toString();
                });
            });

            it('checando o saldo de tokens do usuario', async () => {
                await _vendor.comprar({ from: _addr1, value: amount.toString() });

                const userTokenBalance = await _token.balanceOf(_addr1);
                userTokenAmount = ethers.utils.parseEther('100').toString();
                expect(userTokenBalance.toString()).to.equal(userTokenAmount.toString());
            });

            it('checando o saldo de tokens do distribuidor', async () => {
                await _vendor.comprar({ from: _addr1, value: amount.toString() });

                const vendorTokenBalance = await _token.balanceOf(_vendor.address);
                expect(vendorTokenBalance.toString()).to.equal(ethers.BigNumber.from(_vendorTokensSupply.toString()).sub(userTokenAmount).toString());
            });

            it('checando o saldo de ETH do distribuidor', async () => {
                await _vendor.comprar({ from: _addr1, value: amount.toString() });

                let vendorETHBalance = await web3.eth.getBalance(_vendor.address);
                expect(vendorETHBalance).to.equal(amount.toString());
            });
        });
    });

    describe('testando o metodo sacar()', () => {
        it('o saque foi revertido porque o dono nao possui saldo suficiente', async () => {
            await expect(
                _vendor.sacar({ from: _owner })
            ).to.be.revertedWith("sem saldo para saque");
        });

        it('o saque foi revertido porque o requerente nao e o dono', async () => {
            await expect(
                _vendor.sacar({ from: _addr1 })
            ).to.be.revertedWith("Ownable: caller is not the owner");
        });        
    });

    // describe('testando o metodo vender()', () => {

    // });    
});