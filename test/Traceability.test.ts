// import assert = require('assert');

// import {
//    accounts,
//    contract,
//    web3
// } from '@openzeppelin/test-environment';

// const {
//    use,
//    expect
// } = require('chai');

// const { solidity } = require('ethereum-waffle');

// const truffleAssert = require('truffle-assertions');
// const Traceability = contract.fromArtifact('Traceability');

// use(solidity);

// describe('manage-store', () => {
//    let _trace: {
//       createToken: (owner: string, uri: string, sender: { from: string }) => any;
//       addOrginToken: (tokenId: number, tokenOriginId: number, sender: { from: string }) => any;
//       getOrginToken: (tokenId: number, indexOfOrigin: number, sender: { from: string }) => any;
//       getTotalOriginToken: (tokenId: number, sender: { from: string }) => any;
//       address: any;
//    };

//    let _productItem;
//    let _pItem;

//    const _owner = accounts[0];
//    const _addr1 = accounts[1];
//    const _addr2 = accounts[2];

//    const _uri01 = "https://testIPAddr/token1.json";
//    const _uri02 = "https://testIPAddr/token2.json";
//    const _uri03 = "https://testIPAddr/token3.json";

//    beforeEach(async () => {
//       _trace = await Traceability.new();
//    });

//    it("deve criar um token", async () => {
//       let newToken = await _trace.createToken(_owner, _uri01, { from: _owner });

//       truffleAssert.eventEmitted(newToken, 'TokenCreation', (ev: { owner: string; tokenURI: string; newTokenId: number; }) => {
//          return ev.owner === _owner && ev.tokenURI === _uri01 && ev.newTokenId == 1;
//       });
//    });

//    it("deve criar dois tokens encadeados", async () => {
//       await _trace.createToken(_owner, _uri01, { from: _owner });
//       await _trace.createToken(_owner, _uri02, { from: _owner });

//       let origin = await _trace.addOrginToken(2, 1, { from: _owner });

//       truffleAssert.eventEmitted(origin, 'TokenOrigin', (ev: { tokenId: number; tokenOrigin: number; }) => {
//          return ev.tokenId == 2 && ev.tokenOrigin == 1;
//       });
//    });

//    it("deve recuperar a origem do token", async () => {
//       await _trace.createToken(_owner, _uri01, { from: _owner });
//       await _trace.createToken(_owner, _uri02, { from: _owner });
//       await _trace.addOrginToken(2, 1, { from: _owner });

//       assert.equal(await _trace.getOrginToken(2, 0, { from: _owner }), 1);
//    });   

//    it("deve recuperar o total do token de origem", async () => {
//       await _trace.createToken(_owner, _uri01, { from: _owner });
//       await _trace.createToken(_owner, _uri02, { from: _owner });
//       await _trace.addOrginToken(2, 1, { from: _owner });

//       assert.equal(await _trace.getTotalOriginToken(1, { from: _owner }), 0);
//       assert.equal(await _trace.getTotalOriginToken(2, { from: _owner }), 1);
//    });
// });