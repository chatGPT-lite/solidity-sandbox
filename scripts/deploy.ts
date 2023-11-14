import hre, { ethers } from "hardhat";

function delay(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
  const tokenContract = await ethers.deployContract("Token", {});
  await tokenContract.waitForDeployment();
  const tokenAddress = await tokenContract.getAddress();

  console.log(`Token deployed to: ${tokenAddress}`);

  const constructorArgs = [tokenAddress];
  const splitsContract = await ethers.deployContract("Splits", constructorArgs);

  await splitsContract.waitForDeployment();
  const splitsAddress = await splitsContract.getAddress();

  console.log(`Splits deployed to: ${splitsAddress}`);

  await delay(30000); // Wait for 30 seconds before verifying the contract
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
