//run > npx hardhat test test/FundReleased.js --network localhost

const { expect } = require("chai");
const { ethers } = require("hardhat");

// ถ้าชื่อสัญญาไม่ใช่ "VONOToken" ให้แก้ที่ตัวแปรนี้
const CONTRACT_NAME = "VONOToken";
const CONTRACT_ADDRESS = "AddressOfFund"; // เปลี่ยนเป็น address ของ contract

// ตั้งชื่อกองตามลำดับ enum FundIndex ในสัญญา (0..5)
const FUND_NAMES = ["Team", "Reserve", "Community", "Sale", "Utility", "Buffer"];

function printRow(name, addr, balanceWei, decimals = 18) {
  const human = ethers.formatUnits(balanceWei, decimals);
  console.log(`${name.padEnd(10)} | ${addr} | ${human} VONO`);
}

describe("VONOToken – show fund released", function () {
  let token;

  beforeEach(async () => {
    token = await ethers.getContractAt(CONTRACT_NAME, CONTRACT_ADDRESS);
  });

  it("Print balances of all fund addresses (via getAllFundReleased)", async function () {
    // พยายามอ่าน decimals ถ้ามี ไม่มีก็ใช้ 18
    let decimals = 18;
    if (token.decimals) {
      try { decimals = Number(await token.decimals()); } catch {}
    }

    const [addrs, bals] = await token.getAllFundReleased();

    console.log("\n=== All Fund Released (getAllFundReleased) ===");
    for (let i = 0; i < FUND_NAMES.length; i++) {
      printRow(FUND_NAMES[i], addrs[i], bals[i], decimals);
    }

    // แค่ให้มี assertion บางอย่างเพื่อให้เทสเข้มขึ้น
    expect(addrs.length).to.equal(6);
    expect(bals.length).to.equal(6);
  });

});