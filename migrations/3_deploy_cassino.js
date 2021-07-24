const Cassino = artifacts.require("Cassino");

module.exports = function (deployer) {
  deployer.deploy(Cassino);
};