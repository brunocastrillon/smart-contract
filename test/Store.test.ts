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
        sendOrder: (arg0: string, arg1: number, arg2: { from: string; }) => any;
        // verificarPedido: (arg0: number, arg1: { from: string; }) => any;
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
    const _orderId = 1;
    const _invoiceId = 1;
    const _price = 69;
    const _itemMenu = "express-mj";
    const _quantity = 3;
    const _orderDate = (new Date()).getTime();
    const _deliveryDate = (new Date()).getTime() + 30000;

    beforeEach(async function () {
        _store = await Store.new({ from: _owner });
    });

    describe('Testando a função sendOrder()', () => {
        it('Usuário não enviou todas as informações: Transação Revertida', async () => {
            await expect(
                _store.sendOrder(_itemMenuNULL, _quantityZERO, { from: _customer })
            ).to.be.revertedWith("informacao invalida");
        });

        it('Ao enviar um novo pedido com sucesso, deve retornar um evento: OrderDispatched()', async () => {
            const store = await _store.sendOrder(_itemMenu, _quantity, { from: _customer });

            truffleAssert.eventEmitted(store, 'OrderDispatched', (ev: { customer: string; itemMenu: string; quantity: any, orderId: any }) => {
                return ev.customer === _customer && ev.itemMenu === _itemMenu && ev.quantity == _quantity && ev.orderId == _orderId;
            });
        });
    });

});

//     it("a conta da cafeteria deve ser dona do contrato", async () => {
//         var cafe;
//         return await Cafeteria.new(_cliente, { from: _vendedor }).then((instancia) => {
//             cafe = instancia;
//             return cafe._vendedor();
//         }).then((dono) => {
//             assert.equal(_vendedor, dono, "a conta da cafeteria nao e dono do contrato");
//         });
//     })
// })