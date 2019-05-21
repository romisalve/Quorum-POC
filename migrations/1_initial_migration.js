
const Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations, {from: "0x1caFCe8fF232515Dcb07eE7901D49cFF8397eF7c"});
};
~
