var CrudAEOCreate = artifacts.require("./CrudAEOCreate.sol");
var CrudAEOUpdateAndDelete = artifacts.require("./CrudAEOUpdateAndDelete.sol");

module.exports = function(deployer){

  deployer.deploy(CrudAEOUpdateAndDelete,{from: "0x1caFCe8fF232515Dcb07eE7901D49cFF8397eF7c"});

deployer.deploy(CrudAEOUpdateAndDelete,{from: "0x1caFCe8fF232515Dcb07eE7901D49cFF8397eF7c"});

};
