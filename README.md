# VONO Smart Contract – Vesting & Burn-Aware System

This repository contains the source code and documentation for the VONO Token smart contract, including a modern vesting system with burn-awareness, written in Solidity.

## 📌 Key Features

- 🧠 **Burn-Aware Vesting** – When fund tokens are burned, the system reduces the `released` amount, allowing re-minting under the allocation cap.
- 🔒 **Per-Fund Vesting Schedule** – Each fund has its own allocation, interval, and release rate.
- 🛠 **Manual & Automated Release** – `releaseAll()` or per-fund release can be called manually or via bot/cron job.
- 🔎 **Transparent Auditing** – Functions like `getFundReleased()` and `getAllFundReleased()` expose real-time vesting data.
- 🔥 **Secure Token Burning** – Only the fund’s own address can burn tokens to reduce `released`. Others can only burn their own balance.

## 📁 File Overview

| File | Description |
|------|-------------|
| `Vono.sol` | Main smart contract implementing BEP-20, vesting, and burn-aware logic |
| `scripts/releaseBot.js` | Node.js bot for auto-calling `releaseAll()` at intervals |
| `test/FundBalance.js` | Test script to query balances and validate release |
| `V4_Annotated_Guide_BurnAware.docx` | Full dual-language (EN/TH) contract guide |
| `VONO_Annotated_Guide.docx` | Whitepaper (TH) |
| `VONO_Annotated_Guide.docx` | Whitepaper (EN) |

## 🔧 Development Notes

- ✅ Solidity Version: ^0.8.x
- ✅ Based on OpenZeppelin’s ERC20, Ownable, ERC20Burnable
- ✅ Compatible with BSC Testnet / Mainnet

## 📜 Licensing

All smart contracts are released under MIT License unless otherwise specified.
