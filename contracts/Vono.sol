// ===============================================
// VONO Token Vesting Contract (Annotated)
// คำอธิบายโค้ดฉบับสองภาษา (EN/TH)
// Generated on 2025-08-27 13:27:43
// ===============================================

// SPDX-License-Identifier: MIT
// EN: Solidity compiler version declaration
// TH: ระบุเวอร์ชันคอมไพเลอร์ Solidity
pragma solidity ^0.8.24;

// EN: Import external library or contract definitions
// TH: นำเข้าไลบรารีหรือสัญญา (contract) จากภายนอก
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/// @title VONO Token with Auto-Mint Vesting and Burn-Aware Cap
/// @author Mono Platform
// EN: Contract declaration for VONOToken
// TH: ประกาศสัญญา (contract) ชื่อ VONOToken
contract VONOToken is ERC20, Pausable, ERC20Burnable, Ownable {

    constructor() ERC20("Vono Token", "VONO") Ownable(msg.sender) {
      
        beneficiaries[FundIndex.Team] = 0xb5d6082580743c75625F192EF9968b536F278ACc;
        beneficiaries[FundIndex.Reserve] = 0xE851Fd8dA24F704cce7CCbC3861ECa1705D2D489;
        beneficiaries[FundIndex.Community] = 0xd60B8D0F0eB2058aAC45533F440bb1f72c13f244;
        beneficiaries[FundIndex.Sale] = 0x731E19D3b2fCf66E3ca6a4e438d736B23B3B1F57;
        beneficiaries[FundIndex.Utility] = 0x6D1cf946E1EE96D9E2C2aB89885758b05d405110;
        beneficiaries[FundIndex.Buffer] = 0x7E7b3580172F18cd91547fB51e6Aa4F4aa332358;

        _initFund(FundIndex.Team,      200_000_000 ether, 50_000 ether, 1 days);
        _initFund(FundIndex.Reserve,   100_000_000 ether, 500_000 ether, 30 days);
        _initFund(FundIndex.Community, 100_000_000 ether, 35_000 ether, 1 days);
        _initFund(FundIndex.Sale,      200_000_000 ether, 30_000 ether, 1 days);
        _initFund(FundIndex.Utility,   350_000_000 ether, 50_000 ether, 1 days);
        _initFund(FundIndex.Buffer,     50_000_000 ether, 250_000 ether,   30 days);

        // --- Mint initial released amounts ---
        // EN: Start minting tokens for all funds
        // TH: เริ่มผลิต Token ให้ทุกกองทุน
        _mint(beneficiaries[FundIndex.Team],      5_000_000 ether);
        funds[FundIndex.Team].released      +=    5_000_000 ether;

        _mint(beneficiaries[FundIndex.Reserve],   1_000_000 ether);
        funds[FundIndex.Reserve].released   +=    1_000_000 ether;

        _mint(beneficiaries[FundIndex.Community],  500_000 ether);
        funds[FundIndex.Community].released +=     500_000 ether;

        _mint(beneficiaries[FundIndex.Sale],      1_000_000 ether);
        funds[FundIndex.Sale].released      +=    1_000_000 ether;

        _mint(beneficiaries[FundIndex.Utility],    1_000_000 ether);
        funds[FundIndex.Utility].released   +=     1_000_000 ether;

        // Buffer nothing to mint/release

    }

    // EN: Enum FundIndex defines a set of fixed named values
    // TH: Enum FundIndex ใช้กำหนดชื่อกองทุนที่แน่นอน
    enum FundIndex {
        Team,
        Reserve,
        Community,
        Sale,
        Utility,
        Buffer
    }

// EN: Struct VestingFund groups related fields into one type
// TH: กองทุนการถือครอง (VestingFund)
    struct VestingFund {
// EN: Maximum tokens that can be minted
// TH: จำนวน Tokens สูงสุดที่ผลิตได้
        uint256 max;             // Max allocation for this fund
// EN: Tokens minted so far (minus burned)
// TH: จำนวน Tokens ที่ผลิตมาแล้ว
        uint256 released;          // Total minted so far (minus burned)
// EN: Time interval between each release
// TH: รอบการผลิต
        uint256 interval;          // Time interval between each release
// EN: Amount of tokens produced in each interval
// TH: จำนวน Tokens ที่ผลิตในแต่ละรอบ
        uint256 amountPerInterval; // Fixed amount per release
// EN: Time of last released
// TH: เวลาที่ผลิต Token ล่าสุด
        uint256 lastReleaseTime;   // Last time this fund released tokens
    }

// EN: Beneficiary addresses
// TH: Address ของกองทุน
    mapping(FundIndex => address) public beneficiaries;      // Centralized beneficiary map

// EN: Fund details
// TH: รายละเอียดกองทุน
    mapping(FundIndex => VestingFund) public funds;          // Vesting config per fund

// EN: Start time of the Smart Contract
// TH: เวลาที่เริ่มต้น Smart Contract
    uint256 public immutable startTime = block.timestamp;

// EN: Event TokensReleased is emitted to log on-chain activities
// TH: เมื่อ Token ถูกปล่อยออกมา
    event FundReleased(FundIndex indexed fund, uint256 amount);

// EN: Event TokensBurned is emitted to log on-chain activities
// TH: เมื่อ Token ถูกเผา
    event FundBurned(FundIndex indexed fund, uint256 amount);

// EN: Init starting tokens for all Funds
// TH: สร้าง Tokens เริ่มต้นให้ทุกกองทุน
    function _initFund(FundIndex fund, uint256 max, uint256 perInterval, uint256 interval) internal {
        funds[fund] = VestingFund({
            max: max,
            released: 0, 
            interval: interval,
            amountPerInterval: perInterval,
            lastReleaseTime: startTime
        });
    }

// EN: Get tokens from all Fund
// TH: ดึงข้อมูลทุกกองทุน
    function getAllFundReleased() external view returns (address[6] memory addrs, uint256[6] memory amounts) {
        for (uint8 i = 0; i < 6; i++) {
            FundIndex f = FundIndex(i);
            addrs[i] = beneficiaries[f];
            amounts[i] = funds[f].released;
        }
    }

// EN: Get tokens from specified Fund
// TH: ดึงข้อมูลกองทุนเดียว
    function getFundReleased(uint8 i) external view returns (address addr,uint256 amount) {
        FundIndex f = FundIndex(i);
        addr = beneficiaries[f];
        amount = uint256(funds[f].released);
    }

// EN: Release tokens to specified Fund
// TH: สร้าง Token ให้กองทุนที่ระบุเมื่อถึงเวลา
    function release(FundIndex fund) external whenNotPaused {
        VestingFund storage f = funds[fund];
        require(block.timestamp >= f.lastReleaseTime + f.interval, "Too early");
        require(f.released + f.amountPerInterval <= f.max, "Exceeds allocation");

        uint256 newReleased = f.released + f.amountPerInterval;
        require(newReleased <= f.max, "Exceeds allocation");
        f.released = newReleased;
        f.lastReleaseTime += f.interval;
        _mint(beneficiaries[fund], f.amountPerInterval);
        emit FundReleased(fund, f.amountPerInterval);

    }

// EN: Release tokens to all Fund
// TH: สร้าง Token ให้ทุกกองทุนเมื่อถึงเวลา
    function releaseAll() external whenNotPaused {
        for (uint8 i = 0; i < 6; i++) {
            FundIndex fund = FundIndex(i);
            VestingFund storage f = funds[fund];
            if (
                block.timestamp >= f.lastReleaseTime + f.interval &&
                f.released + f.amountPerInterval <= f.max
            ) {
                f.released += f.amountPerInterval;
                f.lastReleaseTime += f.interval;
                _mint(beneficiaries[fund], f.amountPerInterval);
                emit FundReleased(fund, f.amountPerInterval);
            }
        }
    }

// EN: Get matched index of fund mathed specific address
// TH: ค้นหากองทุนที่ตรงกับที่อยู่ที่ระบุ
    function _fundIndexOf(address who) internal view returns (FundIndex fund, bool ok) {
        unchecked {
            for (uint8 i = 0; i < 6; i++) {
                FundIndex fi = FundIndex(i);
                if (beneficiaries[fi] == who) return (fi, true);
            }
        }
        return (FundIndex(0), false);
    }

// EN: Burn speccified Fund Token, but if Vono Beneficiary, restore its cap
// TH: ใครก็ burn ได้เอง แต่ถ้าเป็นกองทุนของ VONO ให้คืนโควตาให้กองนั้น
    function burn(uint256 amount) public override whenNotPaused {
        require(amount > 0, "amount = 0");

        _burn(msg.sender, amount);

        (FundIndex fund, bool isFund) = _fundIndexOf(msg.sender);
        if (isFund) {
            emit FundBurned(fund, amount);
            _restoreTokenCap(fund, amount);
        }
    }

// EN: Restore cap of Fund when its Token is burned
// TH: คืนโควตาให้กองทุนเมื่อ Token ของกองทุนถูกเผา
    function _restoreTokenCap(FundIndex fund, uint256 amount) internal {

        VestingFund storage f = funds[fund];
        if (amount >= f.released) {
            f.released = 0;             // กัน underflow ชัดเจน
        } else {
            f.released -= amount;       // คืนโควตาตามจำนวนที่ burn
        }

    }

// EN: Pause the contract pause all token transfers and critical actions
// TH: หยุดการทำงานของ Contract หยุดการโอน Token และการทำงานที่สำคัญทั้งหมด
    function pause() public onlyOwner {
        _pause();
    }

// EN: Resume the contract after pause
// TH: เริ่มทำงานของ Contractต่อ
    function unpause() public onlyOwner {
        _unpause();
    }

// EN: Transfers ownership of the contract to a new address
// TH: เปลี่ยนผู้ควบคุม
    function transferOwnership(address newOwner) public onlyOwner override {
        _transferOwnership(newOwner);
    }

// EN: Control then token transfers
// TH: ควบคุมการโอน Token เฉพาะเมื่อไม่ถูก Pause เท่านั้น
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
    {
        //super._beforeTokenTransfer(from, to, amount);
    }

}