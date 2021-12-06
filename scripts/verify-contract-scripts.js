const hre = require("hardhat");

async function main() {
  await hre.run('compile');

  const SignatureVerify = await hre.ethers.getContractFactory("VerifySign");
  const signv = await SignatureVerify.deploy();

  await signv.deployed();

  console.log("Signature Verification Contract deployed to:", signv.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
