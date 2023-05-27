const hre = require("hardhat");
async function main() {
  const lotterySystem = await hre.ethers.getContractFactory("lotterySystem");
  const lotterysystem = await lotterySystem.deploy();
  await lotterysystem.deployed();
  console.log("lotterysystem deployed to:", lotterysystem.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
