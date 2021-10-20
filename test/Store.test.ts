import assert = require('assert');

import {
    accounts,
    contract
} from '@openzeppelin/test-environment';

const {
    use,
    expect
} = require('chai');

const { solidity } = require('ethereum-waffle');

const truffleAssert = require('truffle-assertions');
const Store = contract.fromArtifact('Store');

use(solidity);

describe('manage-store', () => {
    let _store: {
        sendOrder: (itemMenu: string, quantity: number, dateTime: number, sender: { from: string; }) => any;
        checkOrder: (id: number, sender: { from: string; }) => any;
        total: (sender: { from: string; }) => any;
        // enviarPreco:(arg0: string, arg1: string, arg2: { from: string; }) => any;
        // enviarPagamentoSeguro: (arg0: number, arg1: { from: string; }) => any;
        // enviarFatura: (arg0: string, arg1: string, arg2: { from: string; }) => any;
        // obterFatura:(arg0: number, arg1: { from: string; }) => any;
        // MarcarPedidoEntregue:(arg0: string, arg1: string, arg2: { from: string; }) => any;
        // _dono:() => any;
    };

    const _itemMenuNULL = "";
    const _quantityZERO = 0;

    const _owner = accounts[0];
    const _customer = accounts[1];
    const _orderIndex = 0;
    const _invoiceIndex = 0;
    const _itemMenu = "express-mj";
    const _price = 69;
    const _quantity = 3;
    const _payment = 207;//_price * _quantity;
    const _orderDate = (new Date()).getTime();
    const _deliveryDate = (new Date()).getTime() + 30000;

    beforeEach(async function () {
        _store = await Store.new({ from: _owner });
    });

    describe('Testando a função sendOrder()', () => {
        it('Usuário não enviou todas as informações: Transação Revertida', async () => {
            await expect(
                _store.sendOrder(_itemMenuNULL, _quantityZERO, 0, { from: _customer })
            ).to.be.revertedWith("informacao invalida");
        });

        it('Ao enviar um novo pedido com sucesso, deve retornar um evento: OrderDispatched()', async () => {
            const store = await _store.sendOrder(_itemMenu, _quantity, _orderDate, { from: _customer });

            truffleAssert.eventEmitted(store, 'OrderDispatched', (ev: { itemMenu: string; quantity: number; orderDate: number, orderNumber: number, customer: string }) => {
                return ev.itemMenu === _itemMenu && ev.quantity == _quantity && ev.orderDate == _orderDate && ev.orderNumber == _orderIndex+1 && ev.customer == _customer;
            });
        });
    });

    describe('Testando a função checkOrder()', () => {
        it('Deverá retornar informações do pedido', async () => {
            await _store.sendOrder(_itemMenu, _quantity, _orderDate, { from: _customer });
            const pedido = await _store.checkOrder(_orderIndex, { from: _customer });
            assert.equal(_itemMenu, pedido.itemMenu);
            assert.equal(_quantity, pedido.quantity);
            assert.equal(0, pedido.price);
            assert.equal(0, pedido.payment);
            assert.equal(_orderDate, pedido.orderDate);
        });
    });

    it("Deverá retornar o total de pedidos", async () => {
        await _store.sendOrder(_itemMenu, _quantity, _orderDate, { from: _customer });
        let pedidos = await _store.total({ from: _customer });
        
        assert.equal(pedidos, 1);
    });  
});