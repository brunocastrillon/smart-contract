// const Teste = artifacts.require('Teste');
// const assert = require("chai").assert;
// const truffleAssert = require('truffle-assertions');

// contract('Teste', (accounts) => {
//     let _teste;
//     const _remetente = accounts[0];
//     const _numero = 3;

//     beforeEach(async () => {
//         _teste = await Teste.new();
//     });

//     it("testar resultado", async () => {
        
//         for (let index = 0; index < 10; index++) {
//             await _teste.adicionar(index, { from: _remetente });
//         }

//         let estrutura;
//         const total = await _teste.listar({ from: _remetente });

//         for (let index = 0; index < total; index++) {
//             estrutura = await _teste.ler(index);
//             console.log(estrutura.words[0]);
//         }

//         console.log("---");

//         for (let index = 0; index < total; index++) {
//             if (index == 3) {
//                 await _teste.alterar(index, 666);
//             }

//             estrutura = await _teste.ler(index);
            
//             console.log(estrutura.words[0]);
//         }

//         console.log("---");

//         for (let index = 0; index < total; index++) {
//             estrutura = await _teste.ler(index);

//             if (estrutura.words[0] == 666) {
//                 await _teste.alterar(index, index);
//             }
//             else {
//                 await _teste.alterar(index, 999);
//             }

//             estruturaAlterada = await _teste.ler(index);

//             console.log(estruturaAlterada.words[0]);
//         }

//         console.log("---");

//         for (let index = 0; index < total; index++) {
//             estrutura = await _teste.ler(index);

//             if (estrutura.words[0] == 999) {
//                 await _teste.alterar(index, index);
//             }

//             estruturaAlterada = await _teste.ler(index);

//             console.log(estruturaAlterada.words[0]);
//         }           

//         // truffleAssert.eventEmitted(arquivo, 'adicionado', (ev) => {
//         //     return ev.hashh === _hash && ev.remetente === _remetente;
//         // });
//     });
// });