// const { accounts, contract } = require('@openzeppelin/test-environment');
// const Gold = contract.fromArtifact('Gold');

// describe('Gold', function () {
//     let _token;
//     const _owner = accounts[0];
//     const _addr1 = accounts[1];
//     const _addr2 = accounts[2];
//     const _supply = 9000;
//     const transfer = 3;
    

//     beforeEach(async function () {
//         _token = await Gold.new(_owner, _supply);
//     });

//     it('deverá validar o saldo da carteira ' + _owner, async () => {
//         let saldo = await _token.balanceOf(_owner);

//         assert.equal(saldo, _supply);
//     });
// });