// const Cafeteria = artifacts.require('Cafeteria');
// const assert = require("chai").assert;
// const truffleAssert = require('truffle-assertions');

// contract('Cafeteria', (accounts) => {
//     let _cafeteria;

//     const _vendedor = accounts[0];
//     const _cliente = accounts[1];
//     const _idPedido = 1;
//     const _idFatura = 1;
//     const _preco = 10;
//     const _itemMenu = "express-mj";
//     const _quantidade = 3;
//     const _dataOrdem = (new Date()).getTime();
//     const _dataEntrega = (new Date()).getTime() + 30000;

//     before(async () => {
//         _cafeteria = await Cafeteria.new(_cliente, { from: _vendedor });
//     });

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