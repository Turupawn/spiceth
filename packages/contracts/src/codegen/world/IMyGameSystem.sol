// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { Direction } from "../common.sol";

/**
 * @title IMyGameSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IMyGameSystem {
  function app__spawn(int32 x, int32 y, uint256 commitment) external;

  function app__spawn2(int32 x, int32 y, uint256 commitment) external;

  function app__attack2(address destination, uint32 attackType) external;

  function app__defend2(
    uint[2] calldata _pA,
    uint[2][2] calldata _pB,
    uint[2] calldata _pC,
    uint[3] calldata _pubSignals,
    uint256 newCommitment
  ) external;

  function app__move2(Direction direction) external;

  function app__move(int32 characterAtX, int32 characterAtY, Direction direction) external;

  function app__attack(
    uint[2] calldata _pA,
    uint[2][2] calldata _pB,
    uint[2] calldata _pC,
    uint[3] calldata _pubSignals,
    int32 fromX,
    int32 fromY,
    int32 toX,
    int32 toY
  ) external;

  function app__defend(
    uint[2] calldata _pA,
    uint[2][2] calldata _pB,
    uint[2] calldata _pC,
    uint[4] calldata _pubSignals,
    int32 x,
    int32 y
  ) external;

  function app__killUnresponsiveCharacter(int32 x, int32 y) external;
}
