
var CrudAEOCreate = artifacts.require("./CrudAEOCreate.sol");

module.exports = function(deployer){

        deployer.deploy(CrudAEOCreate,{from: "0x1caFCe8fF232515Dcb07eE7901D49cFF8397eF7c"});
};
