// run -> npx hardhat test test/Balance.js --network localhost 
const { ethers } = require("hardhat");

async function main() {
  const CONTRACT = "AddressOfContract"; // ที่อยู่สัญญา
  const NAME     = "VONOToken"; // ชื่อสัญญาใน Vono.sol
  const TARGET   = "AddressToCheckBalance";             // address ที่อยากเช็คยอด

  if (!CONTRACT) throw new Error("Missing ENV: CONTRACT");
  if (!TARGET)   throw new Error("Missing ENV: TARGET");

  // กันพลาด: เช็คว่า address นี้มี bytecode บนเน็ตที่กำลังรัน
  const code = await ethers.provider.getCode(CONTRACT);
  if (code === "0x") throw new Error("CONTRACT ไม่มี bytecode บนเครือข่ายนี้ (เช็ก --network ให้ตรง)");

  const token = await ethers.getContractAt(NAME, CONTRACT);
  const [name, symbol, decimals, bal] = await Promise.all([
    token.name(), token.symbol(), token.decimals(), token.balanceOf(TARGET)
  ]);

  console.log(`✅ ${symbol} (${name}) dec=${decimals}`);
  console.log(`👛 Target : ${TARGET}`);
  console.log(`💰 Balance: ${ethers.formatUnits(bal, decimals)} ${symbol}`);
}

main().catch((e) => { console.error(e); process.exitCode = 1; });