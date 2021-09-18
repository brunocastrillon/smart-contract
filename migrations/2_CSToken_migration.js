const CSToken = artifacts.require("CSToken");

module.exports = function (deployer) {
  deployer.deploy(CSToken);
};