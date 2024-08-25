// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";

import { RevealVerifier } from "../src/RevealVerifier.sol";
import { DefendVerifier } from "../src/DefendVerifier.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";

import { VerifierContracts } from "../src/codegen/index.sol";



contract DummyLido { 
    function deposit() external payable returns (uint256) {

    }
    function requestWithdraw(address _recipient, uint256 _amount) external returns (uint256) {

    }
    function rebase(int128 _accruedRewards) external
    {

    }
    function getTotalEtherClaimOf(address _user) external view returns (uint256)
    {

    }
    function amountForShare(uint256 _share) external view returns (uint256){

    }
}




contract PostDeploy is Script {
  function run(address worldAddress) external {
    // Specify a store so that you can use tables directly in PostDeploy
    StoreSwitch.setStoreAddress(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    address revealVerifier = address(new RevealVerifier());
    VerifierContracts.setRevealContractAddress(revealVerifier);

    address defendVerifier = address(new DefendVerifier());
    VerifierContracts.setDefendContractAddress(defendVerifier);

    address dummyLido = address(new DummyLido());
    VerifierContracts.setLsdContractAddress(dummyLido);

    vm.stopBroadcast();
  }
}