var StructuresAndVariables= artifacts.require("./StructuresAndVariables.sol");
var CrudAEOStructures= artifacts.require("./CrudAEOStructures.sol");
var CrudAEOCreateAndRead= artifacts.require("./CrudAEOCreateAndRead.sol");
var CrudAEOUpdateAndDelete = artifacts.require("./CrudAEOUpdateAndDelete.sol");

module.exports = function(deployer){

  deployer.deploy(StructuresAndVariables);
  deployer.link(StructuresAndVariables,CrudAEOStructures);
  deployer.link(StructuresAndVariables,CrudAEOCreateAndRead);

  deployer.deploy(CrudAEOStructures,{from: "0x1caFCe8fF232515Dcb07eE7901D49cFF8397eF7c"}, {overwrite: false}).then(function() {
  	return deployer.deploy(CrudAEOCreateAndRead, CrudAEOStructures.address, {from: "0x1caFCe8fF232515Dcb07eE7901D49cFF8397eF7c"});
 });



};
