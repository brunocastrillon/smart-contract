const Vendor = artifacts.require("Vendor");
const tokenAddress = '0x2E97e9122C516D7D60174C6e78DBE904AD7e4E9B';
module.exports = function (deployer) {
  deployer.deploy(Vendor, tokenAddress);
};