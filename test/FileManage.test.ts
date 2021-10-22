// import assert = require('assert');

// import {
//     accounts,
//     contract
// } from '@openzeppelin/test-environment';

// const {
//     use,
//     expect
// } = require('chai');

// const { solidity } = require('ethereum-waffle');    

// const truffleAssert = require('truffle-assertions');
// const FileManage = contract.fromArtifact('FileManage');

// use(solidity);

// describe("Alexandria-File-Manage-Test", () => {

//     const [_owner, _sender] = accounts;
//     const _contentNull = "";
//     const _content = "QmW8LsLjznWHQs2GDrxJkem6dc93dVQj9xLDT1uAK6Yugd";
//     const _hash = "87d326f47140d195acc2d31db7bda03237da38b60539d3b7053c1b964168f8d0";
//     const _name = "arquivo-teste.pdf";
//     const _description = "alguma descrição do arquivo imputada pelo usuario";
//     const _type = "application/pdf";
//     const _dateTime = (new Date()).getTime();

//     describe('Testando o método add()', () => {
//         it('Usuário não enviou o hash do arquivo gerado pela rede ipfs, a transação foi revertida', async () => {
//             let fileManage = await FileManage.new();

//             await expect(
//                 fileManage.add(_contentNull, _hash, _name, _description, _type, _dateTime, { from: _sender })
//             ).to.be.revertedWith("informacao invalida");
//         });

//         it("Ao adicionar um novo arquivo, deverá retornar o evento: fileAdded", async () => {
//             let fileManage = await FileManage.new();
//             let file = await fileManage.add(_content, _hash, _name, _description, _type, _dateTime, { from: _sender });
    
//             truffleAssert.eventEmitted(file, 'fileAdded', (ev: { sender: string; name: any; }) => {
//                 return ev.sender === _sender && ev.name === _name;
//             });
//         });        
//     })

//     it("Deverá retornar informações do arquivo", async () => {
//         let fileManage = await FileManage.new();
//         await fileManage.add(_content, _hash, _name, _description, _type, _dateTime, { from: _sender });
//         let file = await fileManage.read(0, { from: _sender });

//         assert.equal(_content, file.fileContent);
//         assert.equal(_hash, file.fileHash);
//         assert.equal(_name, file.fileName);
//         assert.equal(_description, file.fileDescription);
//         assert.equal(_type, file.fileType);
//         assert.equal(_dateTime, file.dateTime);
//     });

//     it("Deverá retornar o total de arquivos", async () => {
//         let fileManage = await FileManage.new();
//         await fileManage.add(_content, _hash, _name, _description, _type, _dateTime, { from: _sender });
//         let arquivos = await fileManage.total({ from: _sender });
        
//         assert.equal(arquivos, 1);
//     });    
// });