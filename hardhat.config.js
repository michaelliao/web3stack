require("@nomicfoundation/hardhat-toolbox");
require('hardhat-abi-exporter');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    testnet: {
      // Keep private key secret:
      accounts: ['0x72b3...bd2b'],
      url: "https://matic-mumbai.chainstacklabs.com"
    }
  },
  abiExporter: {
    path: "./abi",
    clear: false,
    flat: true,
    pretty: false,
    runOnCompile: true,
  },
};
