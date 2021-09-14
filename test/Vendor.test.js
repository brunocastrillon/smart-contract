const { accounts, contract } = require('@openzeppelin/test-environment');
const { use, expect } = require('chai');
const { ethers } = require('ethers');
const truffleAssert = require('truffle-assertions');
const Vendor = contract.fromArtifact('Vendor');
const Gold = contract.fromArtifact('Gold');

describe('Staker dApp', function () {
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
        it('comprar reverteu a transacao, eth nao enviado', async () => {
            const amount = ethers.utils.parseEther('0');
            const vendor = await _vendor.comprar({ from: _addr1, value: amount });

            expect(await _vendor.comprar({ from: _addr1, value: amount })).should.be.rejectedWith('quantidade de ETH insuficiente');
            //await expect(_vendor.comprar({ from: _addr1, value: amount }),).to.be.rejectedWith('quantidade de ETH insuficiente');
            //await expect(_vendor.comprar({ from: _addr1, value: amount }),).to.eventually.be.rejectedWith("quantidade de ETH insuficiente");
        });
    });

    // it('devera realizar uma compra de tokens', async () => {
    //     const amount = ethers.utils.parseEther('1');
    //     const vendor = await _vendor.comprar({ from: _addr1, value: amount })

    //     truffleAssert.eventEmitted(vendor, 'ComprarToken', (ev) => {
    //         //return ev.comprador === _addr1;
    //         return ev.comprador === _addr1 && ev.quantidadeETH === ethers.utils.formatEther(amount);
    //         //return ev.comprador === _addr1 && ev.quantidadeETH === amount && ev.quantidadeGLD === amount.mul(_paridade);
    //     });
    // });
});