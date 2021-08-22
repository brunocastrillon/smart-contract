const Pasta = artifacts.require("Pasta");

module.exports = function (deployer) {
  deployer.deploy(Pasta);
};