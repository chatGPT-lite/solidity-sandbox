import { parseUnits } from "ethers";
import { ethers } from "hardhat";

async function main() {
    const ownerAddress = "0x1a236AbF4860E3b2EF3D2ff9ec9C26B93178C6D9";
    const tokenAddress = "0xD3B4BfD5ECb1B9FDA17DcC2bc46F884F7A9a8A2F";
    const splitsAddress = "0xaDB3d6190fcc2e58B771134229a0F354a0eC41AE";
    const recvAddress = "0x5593f4304E209B31042d378b9bcaF50D7B80ae13";
    
    const tokenContract = await ethers.getContractAt("Token", tokenAddress); 
    const splitsContract = await ethers.getContractAt("Splits", splitsAddress);
    

    ////////////////
    //  SENDING  //
    //////////////
    const batchAmounts = [100, 110, 120, 130, 140, 150];

    for (let i = 0; i < batchAmounts.length; i++) {
        const numTransfers = batchAmounts[i];

        console.log("=====================================");
        // Mint the amount of tokens needed for the test
        const totalTokens = parseUnits(`${numTransfers}`, 18);
        const mintTx = await tokenContract.mint(ownerAddress, totalTokens); // Mint 1000 tokens to the owner
        console.log(`NumTokens Minted: ${numTransfers}`);
        console.log(`Minted txnHash ${mintTx.hash}`);
        const mintReceipt = await mintTx.wait(); 
    

        // Transfer the tokens
        const startTime = Date.now();
        const transferTxn =  await tokenContract.transferMultiple(recvAddress, totalTokens, numTransfers);
        console.log(`== ${numTransfers} transfers: ${transferTxn.hash}`);
        const xferReceipt = await transferTxn.wait(); 
        const endTime = Date.now();
        
        console.log(`== Gas used: ${xferReceipt?.gasUsed.toString()}`);
        console.log(`== Time taken: ${endTime - startTime} ms`);

    }
}
    
// To run it, invoke `npx hardhat run scripts/interact.ts --network <network_name>`
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
