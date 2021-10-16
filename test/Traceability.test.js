const Traceability = artifacts.require('Traceability');
const assert = require("chai").assert;
const truffleAssert = require('truffle-assertions');

contract('Traceability', (accounts) => {
   let _trace;
   let _productItem;
   let _pItem;

   const _owner = accounts[0];
   const _addr1 = accounts[1];
   const _addr2 = accounts[2];

   const _uri01 = "https://testIPAddr/token1.json";
   const _uri02 = "https://testIPAddr/token2.json";
   const _uri03 = "https://testIPAddr/token3.json";

   beforeEach(async () => {
      _trace = await Traceability.new();
   });

   it("deve criar um token", async () => {
      let newToken = await _trace.createToken(_owner, _uri01);

      truffleAssert.eventEmitted(newToken, 'TokenCreation', (ev) => {
         return ev.owner === _owner && ev.tokenURI === _uri01 && ev.newTokenId == 1;
      });
   });

   it("deve criar dois tokens encadeados", async () => {
      await _trace.createToken(_owner, _uri01);
      await _trace.createToken(_owner, _uri02);

      let origin = await _trace.addOrginToken(2, 1);

      truffleAssert.eventEmitted(origin, 'TokenOrigin', (ev) => {
         return ev.tokenId == 2 && ev.tokenOrigin == 1;
      });
   });

   it("deve recuperar a origem do token", async () => {
      await _trace.createToken(_owner, _uri01);
      await _trace.createToken(_owner, _uri02);
      await _trace.addOrginToken(2, 1);
      assert.equal(await _trace.getOrginToken(2, 0), 1);
   });

   it("deve recuperar o total do token de origem", async () => {
      await _trace.createToken(_owner, _uri01);
      await _trace.createToken(_owner, _uri02);
      await _trace.addOrginToken(2, 1);

      assert.equal(await _trace.getTotalOriginToken(1), 0);
      assert.equal(await _trace.getTotalOriginToken(2), 1);
   });    
});

// const { expect} = require("chai");

// describe("Traceability Test", function() {
//    let ProductItem ;
//    let pItem ;
//    let owner, addr1, addr2 ;

//    beforeEach(async () => {
//       [owner, addr1, addr2] = await ethers.getSigners();
//       ProductItem = await ethers.getContractFactory("Traceability");
//       pItem = await ProductItem.deploy();
//       await pItem.deployed();
//    });

//    it("Test: Link Tokens 1", async function() {
//       expect(await pItem.createToken(owner.address, "https://testIPAddr/token1.json")).to.emit(pItem, "TokenCreation").withArgs(owner.address, "https://testIPAddr/token1.json", 1);
//       expect(await pItem.createToken(owner.address, "https://testIPAddr/token2.json")).to.emit(pItem, "TokenCreation").withArgs(owner.address, "https://testIPAddr/token2.json", 2);
//       expect(await pItem.createToken(owner.address, "https://testIPAddr/token3.json")).to.emit(pItem, "TokenCreation").withArgs(owner.address, "https://testIPAddr/token3.json", 3);

//       expect(await pItem.addOrginToken(2, 1)).to.emit(pItem, "TokenOrigin").withArgs(2, 1);
//       expect(await pItem.addOrginToken(3, 1)).to.emit(pItem, "TokenOrigin").withArgs(3, 1);

//       expect(await pItem.getTotalOriginToken(1)).to.equal(0);
//       expect(await pItem.getTotalOriginToken(2)).to.equal(1);
//       expect(await pItem.getTotalOriginToken(3)).to.equal(1); 

//       expect(await pItem.getOrginToken(2, 0)).to.equal(1);
//       expect(await pItem.getOrginToken(2, 0)).to.not.equal(3);
//       expect(await pItem.getOrginToken(3, 0)).to.equal(1);
//    });
// });