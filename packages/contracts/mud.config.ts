import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  namespace: "app",
  enums: {
    Direction: [
      "Up",
      "Down",
      "Left",
      "Right"
    ]
  },
  tables: {
    Character: {
      schema: {
        x: "int32",
        y: "int32",
        owner: "address",
        id: "uint32",
        attackedAt: "uint32",
        attackedByValue: "uint32",
        revealedValue: "uint32",
        isDead: "bool",
      },
      key: ["x", "y"]
    },
    Player: {
      schema: {
        owner: "address",
        x: "int32",
        y: "int32",
        commitment: "uint256",
        isAttacked: "bool",
        attackedAt: "uint256",
      },
      key: ["owner"]
    },
    PlayerPrivateState: {
      schema: {
        account: "address",
        commitment: "uint256",
      },
      key: ["account"]
    },
    VerifierContracts: {
      schema: {
        revealContractAddress: "address",
        defendContractAddress: "address"
      },
      key: [],
    },
  },
});