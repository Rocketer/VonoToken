import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-ethers";      // ethers v6
import "@nomiclabs/hardhat-etherscan";        // verify
import "dotenv/config";

const config = {
  solidity: {
    version: "0.8.24",
    settings: { optimizer: { enabled: true, runs: 200 } },
  },
  networks: {
    bscTestnet: {
      url: "https://data-seed-prebsc-1-s1.bnbchain.org:8545",
      chainId: 97
    },
    bscMainnet: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56
    },
  },
  etherscan: {
    apiKey: {
      bscTestnet: "YOUR API KEY"  // จาก https://bscscan.com/,
    },
    customChains: [
      {
        network: "bscTestnet",
        chainId: 97,
        urls: {
          apiURL: "https://api-testnet.bscscan.com/api",
          browserURL: "https://testnet.bscscan.com",
        },
      },
    ],
  },
};

export default config;
