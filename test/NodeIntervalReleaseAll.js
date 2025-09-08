// run -> node test/NodeIntervalReleaseAll.js --network localhost 
const { ethers } = require("ethers");

// config
const provider = new ethers.JsonRpcProvider("http://localhost:8545"); // หรือ RPC จริง
const privateKey = "OwnerPrivateKey"; // Address ที่มีสิทธิ์เรียก release (ใครก็ได้) ที่มีเงิน // ถ้าตอน Test ได้หลังจาก npx hardhat node
const contractAddr = "AddressOfContract"; // เปลี่ยนเป็น address ของ contract จริง // ถ้าตอน Test ได้หลังจาก Deploy

// === CONTRACT ABI ===
const abi = [
  "function releaseAll() external"
];

const wallet = new ethers.Wallet(privateKey, provider);
const contract = new ethers.Contract(contractAddr, abi, wallet);

// เรียกทุก 24 ชั่วโมง
setInterval(async () => {
  try {
    const tx = await contract.releaseAll();
    await tx.wait();
    console.log("✅ releaseAll() called at", new Date().toLocaleTimeString());

    const balance = await provider.getBalance(wallet.address);
    const eth = ethers.formatEther(balance);
    console.log(`💰 Wallet: ${wallet.address}`);
    console.log(`Ξ ETH Remaining: ${ethers.formatEther(balance)} ETH\n`);

  } catch (err) {
    console.log("⚠️  Failed:", err.message);
  }
}, 24 * 3600 * 1000);