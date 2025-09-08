#--------------------
npx hardhat node
npx hardhat run scripts/deploy-local.js --network localhost
#---------------VONO deployed to: 0x1234...ABCD == Success
#---------------สำหรับการ test 
1. สร้างไฟล์ JS สำหรับ Test ที่ ./test
2. เปิด Terminal ใหม่
3. npx hardhat test test/[ชื่อไฟล์].js --network localhost
4. Bot สำหรับกระตุ้น Release All ให้ Run ด้วยการ Loop Infinite
    node [path file.js]
#---------------หลังแก้ Code และ Re-run
1. Ctrl-C หน้าที่ npx hardhat node และสั่ง npx hardhat node ใหม่
2. npx hardhat compile
3. npx hardhat run scripts/deploy.js
4. npx hardhat test test/[ชื่อไฟล์].js ใหม่
4. Bot สำหรับกระตุ้น Release All ให้ Run ด้วย Loop Infinite
    node [path file.js]
