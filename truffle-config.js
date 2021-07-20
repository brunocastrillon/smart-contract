module.exports = {
  networks: {
    dev: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 7545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },
    // pro: {
    // port: 8777,              // Custom port
    // network_id: 1342,        // Custom network
    // gas: 8500000,            // Gas sent with each transaction (default: ~6700000)
    // gasPrice: 20000000000,   // 20 gwei (in wei) (default: 100 gwei)
    // from: <address>,         // Account to send txs from (default: accounts[0])
    // websocket: true          // Enable EventEmitter interface for web3 (default: false)
    // }
  },
  mocha: {
    reporter: 'eth-gas-reporter',
    reporterOptions: {
      excludeContracts: ['Migrations']
    }
  },
  compilers: {
    solc: {
      version: "^0.8.0",      // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    }
  },
  db: {
    // Truffle DB is currently disabled by default; to enable it, change enabled: false to enabled: true
    // Note: if you migrated your contracts prior to enabling this field in your Truffle project and want
    // those previously migrated contracts available in the .db directory, you will need to run the following:
    // $ truffle migrate --reset --compile-all    
    enabled: false
  },
  plugins: ["solidity-coverage"]
};