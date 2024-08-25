import { getComponentValue } from "@latticexyz/recs";
import { ClientComponents } from "./createClientComponents";
import { SetupNetworkResult } from "./setupNetwork";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { groth16 } from "snarkjs";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

let privateSalt = Math.floor(Math.random() * 1000) + 1;
let privateType = Math.floor(Math.random() * 3) + 1;
let defending = false;

export function createSystemCalls(
  { worldContract, waitForTransaction, playerEntity }: SetupNetworkResult,
  { Character }: ClientComponents,
) {
  const spawn = async (x: number, y: number) => {
    const { proof, publicSignals } = await groth16.fullProve(
      {
          character1: 4,
          character2: 1,
          character3: 2,
          character4: 3,
          privateSalt: 123,
          characterReveal: 1,
          valueReveal: 4,
      },
      "./zk_artifacts/reveal.wasm",
      "./zk_artifacts/reveal_final.zkey"
    );
    let commitment : number = publicSignals[0];
    const tx = await worldContract.write.app__spawn([x, y, commitment]);
    await waitForTransaction(tx);
    return getComponentValue(Character, singletonEntity);
  };

  const spawn2 = async (x: number, y: number) => {
    privateSalt = Math.floor(Math.random() * 1000) + 1;
    privateType = Math.floor(Math.random() * 3) + 1;

    defending = false;

    const { proof, publicSignals } = await groth16.fullProve(
      {
        "private_salt": "" + privateSalt,
        "private_defense_type": privateType,
        "public_attack_type": 3
      },
      "./zk_artifacts/defendType.wasm",
      "./zk_artifacts/defendType_final.zkey"
    );
    let commitment : number = publicSignals[0];

    const tx = await worldContract.write.app__spawn2([x, y, commitment],{
      value:  1000000000000000n
    });
    await waitForTransaction(tx);
    return getComponentValue(Character, singletonEntity);
  };

  const attack2 = async (destination: number, attackType: number) => {
    const tx = await worldContract.write.app__attack2([destination, attackType]);
    await waitForTransaction(tx);
    return getComponentValue(Character, singletonEntity);
  };

  const generateNewCommitment = async () => {
    privateSalt = Math.floor(Math.random() * 1000) + 1;
    privateType = Math.floor(Math.random() * 3) + 1;
    const { proof, publicSignals } = await groth16.fullProve(
      {
        "private_salt": "" + privateSalt,
        "private_defense_type": privateType,
        "public_attack_type": 3
      },
      "./zk_artifacts/defendType.wasm",
      "./zk_artifacts/defendType_final.zkey"
    );
    return publicSignals[0]
  }

  const defend2 = async (attackerType: number) => {
    if(defending==true)
    {
      return;
    }

    defending = true;
    console.log("attackerType:");
    console.log(attackerType);
    const { proof, publicSignals } = await groth16.fullProve(
      {
        "private_salt": "" + privateSalt,
        "private_defense_type": privateType,
        "public_attack_type": attackerType
      },
      "./zk_artifacts/defendType.wasm",
      "./zk_artifacts/defendType_final.zkey"
    );

    let pa = proof.pi_a
    let pb = proof.pi_b
    let pc = proof.pi_c
    pa.pop()
    pb.pop()
    pc.pop()

    let commitment : number = publicSignals[0];

    // Begin generate new commitment
    //privateSalt = Math.floor(Math.random() * 1000) + 1;
    //privateType = Math.floor(Math.random() * 3) + 1;
    const newCommitment = await generateNewCommitment();
    // End generate new commitment
    
    const tx = await worldContract.write.app__defend2([pa, pb, pc, publicSignals, newCommitment]);
    await waitForTransaction(tx);

    defending = false;

    return getComponentValue(Character, singletonEntity);
  };

  const move2 = async (direction: number) => {
    const tx = await worldContract.write.app__move2([direction]);
    await waitForTransaction(tx);
    return getComponentValue(Character,  singletonEntity);
  }

  const move = async (x: number, y: number, direction: number) => {
    const tx = await worldContract.write.app__move([x, y, direction]);
    await waitForTransaction(tx);
    return getComponentValue(Character,  singletonEntity);
  }

  const attack = async (fromX: number, fromY: number, toX: number, toY: number, circuitInputs: any) => {
    const { proof, publicSignals } = await groth16.fullProve(circuitInputs,
      "./zk_artifacts/reveal.wasm",
      "./zk_artifacts/reveal_final.zkey"
    );

    let pa = proof.pi_a
    let pb = proof.pi_b
    let pc = proof.pi_c
    pa.pop()
    pb.pop()
    pc.pop()

    const tx = await worldContract.write.app__attack([pa, pb, pc, publicSignals, fromX, fromY, toX, toY]);
    await waitForTransaction(tx);
    return getComponentValue(Character,  singletonEntity);
  }

  const defend = async (x: number, y: number, circuitInputs: any) => {
    const { proof, publicSignals } = await groth16.fullProve(circuitInputs,
      "./zk_artifacts/defend.wasm",
      "./zk_artifacts/defend_final.zkey"
    );

    let pa = proof.pi_a
    let pb = proof.pi_b
    let pc = proof.pi_c
    pa.pop()
    pb.pop()
    pc.pop()

    const tx = await worldContract.write.app__defend([pa, pb, pc, publicSignals, x, y]);
    await waitForTransaction(tx);
    return getComponentValue(Character,  singletonEntity);
  }

  const getPrivateType = () => {
    return privateType;
  };

  return {
    spawn, spawn2, move, move2, attack, attack2, defend, defend2, playerEntity, getPrivateType
  };
}