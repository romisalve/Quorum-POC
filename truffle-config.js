 
module.exports = {

 networks: {

 development: {
      host: "192.168.26.9",     // Localhost (default: none)
      port: 22000,            // Standard Ethereum port (default: none)
      network_id: "73053",       // Any network (default: none)
      gasPrice: 0,
      gas:450000000,
      type: "quorum",
//    from: '0x0252e5482545d09469b50794ae99889bed0079cc',
//    websockets: true

},


  // Configure your compilers
  compilers: {
    solc: {
     version: "^0.4.23",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    }
  }
}
