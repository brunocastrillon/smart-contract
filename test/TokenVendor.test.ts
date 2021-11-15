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

const Vendor = contract.fromArtifact('TokenVendor');
const Gold = contract.fromArtifact('Token');

use(solidity);

describe('vendor-dapp', function () {
    let _vendor: { address: any; transferOwnership: (arg0: any) => any; _parity: () => any; buy: (arg0: { from: any; value: any; }) => any; withdraw: (arg0: { from: any; }) => any; };
    let _token: { address: any; transfer: (arg0: any, arg1: any, arg2: { from: any; }) => any; balanceOf: (arg0: any) => any; }
    let _vendorTokensSupply: { toString: () => any; };
    let _paridade: { toString: () => any; };

    const _owner = accounts[0];
    const _addr1 = accounts[1];

    beforeEach(async function () {
        _token = await Gold.new({ from: _owner });
        _vendor = await Vendor.new(_token.address);

        await _token.transfer(_vendor.address, ethers.utils.parseEther('1000'), { from: _owner });
        await _vendor.transferOwnership(_owner);

        _vendorTokensSupply = await _token.balanceOf(_vendor.address);
        _paridade = await _vendor._parity();
    });

    describe('testando o metodo comprar()', () => {
        it('comprador nao enviou ETH suficiente, transacao foi revertida', async () => {
            const amount = ethers.utils.parseEther('0').toString();

            await expect(
                _vendor.buy({ from: _addr1, value: amount })
            ).to.be.revertedWith("quantidade de ETH insuficiente");
        }).timeout(9000);

        it('distribuidor nao possui tokens suficiente, transacao foi revertida', async () => {
            const amount = ethers.utils.parseEther('93').toString();

            await expect(
                _vendor.buy({ from: _addr1, value: amount })
            ).to.be.revertedWith("saldo do distribuidor insuficiente");
        });

        describe('token comprado com sucesso', () => {
            const amount = ethers.utils.parseEther('1.0');
            let userTokenAmount: { toString: () => any; };

            it('evento emitido: ComprarToken', async () => {
                let vendor = await _vendor.buy({ from: _addr1, value: amount.toString() });
                truffleAssert.eventEmitted(vendor, 'PurchasedToken', (ev: { buyer: any; ethAmount: any; tknAmount: any; }) => {
                    return ev.buyer === _addr1 && ev.ethAmount == amount.toString() && ev.tknAmount == amount.mul(_paridade.toString()).toString();
                });
            }).timeout(3000);

            it('checando o saldo de tokens do usuario', async () => {
                await _vendor.buy({ from: _addr1, value: amount.toString() });

                const userTokenBalance = await _token.balanceOf(_addr1);
                userTokenAmount = ethers.utils.parseEther('100').toString();
                expect(userTokenBalance.toString()).to.equal(userTokenAmount.toString());
            }).timeout(4000);

            it('checando o saldo de tokens do distribuidor', async () => {
                await _vendor.buy({ from: _addr1, value: amount.toString() });

                const vendorTokenBalance = await _token.balanceOf(_vendor.address);
                expect(vendorTokenBalance.toString()).to.equal(ethers.BigNumber.from(_vendorTokensSupply.toString()).sub(userTokenAmount).toString());
            }).timeout(7000);

            it('checando o saldo de ETH do distribuidor', async () => {
                await _vendor.buy({ from: _addr1, value: amount.toString() });

                let vendorETHBalance = await web3.eth.getBalance(_vendor.address);
                expect(vendorETHBalance).to.equal(amount.toString());
            }).timeout(6000);
        });
    });

    describe('testando o metodo sacar()', () => {
        it('o saque foi revertido porque o dono nao possui saldo suficiente', async () => {
            await expect(
                _vendor.withdraw({ from: _owner })
            ).to.be.revertedWith("sem saldo para saque");
        }).timeout(3000);

        it('o saque foi revertido porque o requerente nao e o dono', async () => {
            await expect(
                _vendor.withdraw({ from: _addr1 })
            ).to.be.revertedWith("Ownable: caller is not the owner");
        }).timeout(6000);

        // it('saque realizado com sucesso', async () => {
        //     const ethOfTokenToBuy = ethers.utils.parseEther('1');
      
        //     // buyTokens operation
        //     await _vendor.connect(_addr1).buyTokens({
        //       value: ethOfTokenToBuy,
        //     });
      
        //     // withdraw operation
        //     const txWithdraw = await _vendor.connect(_owner).withdraw();
      
        //     // Check that the Vendor's balance has 0 eth
        //     const vendorBalance = await ethers.provider.getBalance(_vendor.address);
        //     expect(vendorBalance).to.equal(0);
      
        //     // Check the the owner balance has changed of 1 eth
        //     await expect(txWithdraw).to.changeEtherBalance(_owner, ethOfTokenToBuy);
        //   });
    });

    // describe('testando o metodo vender()', () => {

    // });    
});