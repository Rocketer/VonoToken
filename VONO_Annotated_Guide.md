# VONO Vesting Smart Contract – Verified Annotated Guide (V3)

## 1. Overview

**EN:**  
This contract VONOToken is an upgradeable BEP-20 token with auto-minting vesting logic across six defined funds. Each fund has its own cap (max), release amount (amountPerInterval), interval (interval), and tracker for released tokens (released). The contract supports burn-aware logic: when a fund beneficiary burns its own tokens, the counter released is decreased to allow reminting within the cap.

**TH:**  
สัญญานี้ชื่อ VONOToken เป็นโทเคน BEP-20 ที่มีระบบ Auto-Vesting แยกตามกองทุน 6 กอง แต่ละกองจะมีเพดาน (max), จำนวนปล่อยต่อรอบ (amountPerInterval), ความถี่ (interval) และตัวนับ (released). สัญญารองรับ burn-aware logic: ถ้ากองทุนเบิร์นเหรียญของตัวเอง จะลดค่า released ทำให้สามารถ mint ซ้ำได้ในอนาคตภายใต้ cap เดิม

## 2. Pragma & Imports

- pragma solidity ^0.8.24;
- ใช้ OpenZeppelin Contracts:
  - ERC20
  - ERC20Burnable
  - ERC20Pausable
  - Ownable

## 3. Enums & Structs

- enum FundIndex { Team, Reserve, Community, Sale, Utility, Buffer }
- struct VestingFund:
  - uint256 max
  - uint256 released
  - uint256 interval
  - uint256 amountPerInterval
  - uint256 lastReleaseTime

## 4. State Variables

- mapping(FundIndex => address) beneficiaries
- mapping(FundIndex => VestingFund) public funds

## 5. Constructor

- ตั้งชื่อ Token เป็น "Vono Token" และ "VONO"
- เรียก _initFund(...) เพื่อกำหนดค่าของแต่ละกอง
- กำหนด beneficiaries ตาม FundIndex

## 6. Release Logic

- release(FundIndex fund):
  - ตรวจสอบว่าเวลาปัจจุบัน >= lastReleaseTime + interval
  - คำนวณ released + amountPerInterval <= max
  - mint โทเคนให้กับ beneficiaries[fund]
  - บันทึกเวลา release ล่าสุด

  - releaseAll():
  - วนรอบ FundIndex ทั้งหมดแล้วเรียก release ทีละกอง

## 7. Burn Logic

- ฟังก์ชัน burn(uint256) มาจาก ERC20Burnable
- ถ้า msg.sender เป็น beneficiary ของกองใด ระบบจะเรียก _restoreTokenCap(...) เพื่อ released -= amount ของกองนั้น
- ไม่อนุญาตให้เบิร์นแทนผู้อื่น

## 8. Admin Controls

- ใช้ Ownable → ฟังก์ชัน pause() และ unpause() ได้
- กำหนด beneficiaries ตอน constructor เท่านั้น (ไม่มีเปลี่ยน)

## 9. View Functions

- getFundReleased(FundIndex) → จำนวน released ของกองนั้น
- getAllFundReleased() → array ของ released ทั้งหมด (เรียงตาม FundIndex)

## 10. Automation

- ไม่มี scheduler ในเชน
- ให้ใช้ bot/off-chain script เรียก releaseAll() ตามรอบเวลา เช่นทุกวัน หรือทุกสัปดาห์

## 11. Security Features

- burn-aware สำหรับเฉพาะ MultiSig ของกองทุน
- ตรวจสอบเวลาอย่างเข้มงวดก่อน mint
- released ต้องไม่เกิน max
- ไม่เปิดช่องให้คนอื่นเบิร์นแทนได้

## 12. Summary

- Token: VONO (BEP-20)
- Funds: 6 แบบ (Team, Reserve, Community, Sale, Utility, Buffer)
- Vesting: Auto release ตาม interval, พร้อม mint
- Burn-aware: กองทุนสามารถ burn เพื่อลด released → คืนโควตา mint