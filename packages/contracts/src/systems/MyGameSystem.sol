// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { Character, CharacterData, Player, PlayerData, VerifierContracts, SpicePosition } from "../codegen/index.sol";
import { PlayerPrivateState } from "../codegen/index.sol";
import { Direction } from "../codegen/common.sol";
import { getKeysWithValue } from "@latticexyz/world-modules/src/modules/keyswithvalue/getKeysWithValue.sol";

import { EncodedLengths, EncodedLengthsLib } from "@latticexyz/store/src/EncodedLengths.sol";

interface ICircomRevealVerifier {
    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[3] calldata _pubSignals) external view returns (bool);
}

interface ICircomDefendVerifier {
    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[4] calldata _pubSignals) external view returns (bool);
}

interface ICircomDefend2Verifier {
    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[3] calldata _pubSignals) external view returns (bool);
}

/////// LSDs ///////
/////// LSDs ///////
interface ILiquidityPool { 
    function deposit() external payable returns (uint256);
    function requestWithdraw(address _recipient, uint256 _amount) external returns (uint256);
    function rebase(int128 _accruedRewards) external;
    function getTotalEtherClaimOf(address _user) external view returns (uint256);
    function amountForShare(uint256 _share) external view returns (uint256);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}
/////// LSDs ///////
/////// LSDs ///////


contract MyGameSystem is System {
  function spawn(int32 x, int32 y, uint256 commitment) public {
    //require(PlayerPrivateState.getCommitment(_msgSender()) == 0, "Player already spawned");

    Character.set(x, y, _msgSender(), 1, 0, 0, 0, false);
    Character.set(x, y + 1, _msgSender(), 2, 0, 0, 0, false);
    Character.set(x, y + 2, _msgSender(), 3, 0, 0, 0, false);
    Character.set(x, y + 3, _msgSender(), 4, 0, 0, 0, false);

    PlayerPrivateState.set(_msgSender(), commitment);

  }

  function spawn2(int32 x, int32 y, uint256 commitment) public payable {
    uint SPAWN_PRICE = 0.001 ether;
    require(_msgValue() == SPAWN_PRICE, "Invalid spawn amounta");
    PlayerData memory playerAtDestination = Player.get(_msgSender());
    //require(playerAtDestination.commitment == 0, "Player already spawned");
    Player.set(_msgSender(), x, y, commitment, false, 0, 100, address(0), 0);


    SpicePosition.set(x + 5, y - 2, true);
    SpicePosition.set(x + 2, y + 4, true);
    SpicePosition.set(x -3, y + 1, true);

    //LSDs
    ILiquidityPool(VerifierContracts.getLsdContractAddress()).deposit{value: 0}();
  }

  function attack2(address destination, uint32 attackType) public {
    Player.set(destination,
      Player.getX(destination),
      Player.getY(destination),
      Player.getCommitment(destination),
      true,// isAttacked
      block.timestamp,// attackedAt
      Player.getSpice(destination),
      _msgSender(),// attackedBy
      attackType);
  }

  function defend2(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[3] calldata _pubSignals,
    uint256 newCommitment) public {
    ICircomRevealVerifier(VerifierContracts.getRevealContractAddress()).verifyProof(_pA, _pB, _pC, _pubSignals);
    uint256 commitment = _pubSignals[0];
    uint256 battleResult = _pubSignals[1];
    uint256 attackerType = _pubSignals[2];
    require(commitment == Player.getCommitment(_msgSender()),"Invalid commitment");
    if(battleResult==0)//Defender wins
    {
      Player.setSpice(Player.getAttackedBy(_msgSender()), Player.getSpice(Player.getAttackedBy(_msgSender()))-10);
      Player.setSpice(_msgSender(), Player.getSpice(_msgSender())+10);
    }else if(battleResult==1)//Attacker wins
    {
      Player.setSpice(Player.getAttackedBy(_msgSender()), Player.getSpice(Player.getAttackedBy(_msgSender()))+10);
      Player.setSpice(_msgSender(), Player.getSpice(_msgSender())-10);
    }else if(battleResult==2)//Tie
    {

    }
    Player.setIsAttacked(_msgSender(), false);
    Player.setCommitment(_msgSender(), newCommitment);
  }

  function move2(Direction direction) public {
    PlayerData memory player = Player.get(_msgSender());

    //require(!character.isDead, "Character is dead");
    //require(player.attackedAt == 0, "Player is under attack");

    int32 x = player.x;
    int32 y = player.y;

    if(direction == Direction.Up)
      y -= 1;
    if(direction == Direction.Down)
      y += 1;
    if(direction == Direction.Left)
      x -= 1;
    if(direction == Direction.Right)
      x += 1;

    //PlayerData memory playerAtDestination = Character.get(x, y);
    //require(characterAtDestination.owner == address(0), "Destination is occupied");

    //Character.deleteRecord(characterAtX, characterAtY);
    //Character.set(,  x, y, 0, 0, character.revealedValue, false);
    Player.setX(_msgSender(), x);
    Player.setY(_msgSender(), y);



    if(SpicePosition.getExists(x, y))
    {
      SpicePosition.set(x, y, false);
      Player.setSpice(_msgSender(), Player.getSpice(_msgSender())+1);
    }
  }



  function move(int32 characterAtX, int32 characterAtY, Direction direction) public {
    CharacterData memory character = Character.get(characterAtX, characterAtY);

    //require(!character.isDead, "Character is dead");
    require(character.attackedAt == 0, "Character is under attack");
    require(character.owner == _msgSender(), "Only owner");

    int32 x = characterAtX;
    int32 y = characterAtY;

    if(direction == Direction.Up)
      y -= 1;
    if(direction == Direction.Down)
      y += 1;
    if(direction == Direction.Left)
      x -= 1;
    if(direction == Direction.Right)
      x += 1;

    CharacterData memory characterAtDestination = Character.get(x, y);
    require(characterAtDestination.owner == address(0), "Destination is occupied");

    Character.deleteRecord(characterAtX, characterAtY);
    Character.set(x, y, _msgSender(), character.id, 0, 0, character.revealedValue, false);
  }

  function attack(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[3] calldata _pubSignals,
    int32 fromX, int32 fromY, int32 toX, int32 toY
  ) public {
    ICircomRevealVerifier(VerifierContracts.getRevealContractAddress()).verifyProof(_pA, _pB, _pC, _pubSignals);
    uint256 commitment = _pubSignals[0];
    uint256 characterReveal = _pubSignals[1];
    uint256 valueReveal = _pubSignals[2];

    require(PlayerPrivateState.getCommitment(_msgSender()) == commitment, "Invalid commitment");
    require(characterReveal == Character.getId(fromX, fromY), "Invalid attacker id");
    require(Character.getOwner(fromX, fromY) == _msgSender(), "You're not the planet owner");
    Character.setRevealedValue(fromX, fromY, uint32(valueReveal));
    Character.setAttackedAt(toX, toY, uint32(block.timestamp));
    Character.setAttackedByValue(toX, toY, uint32(valueReveal));
  }

  function defend(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[4] calldata _pubSignals,
    int32 x, int32 y
  ) public {
    ICircomDefendVerifier(VerifierContracts.getDefendContractAddress()).verifyProof(_pA, _pB, _pC, _pubSignals);

    uint256 commitment = _pubSignals[0];
    uint256 battleResult = _pubSignals[1];
    uint256 characterTarget = _pubSignals[2];
    uint256 attackerLevel = _pubSignals[3];

    require(PlayerPrivateState.getCommitment(Character.getOwner(x, y)) == commitment, "Invalid commitment");
    require(characterTarget == Character.getId(x, y), "Invalid character id");
    require(attackerLevel == Character.getAttackedByValue(x, y), "Invalid attacked by value in proof");

    if(battleResult == 1) { // defense won
      Character.setAttackedAt(x, y, 0);
      Character.setAttackedByValue(x, y, 0);
    } else { // attack won
      Character.setIsDead(x, y, true);
    }
  }

  function killUnresponsiveCharacter(int32 x, int32 y) public {
    uint32 attackedAt = Character.getAttackedAt(x, y);
    uint32 MAX_WAIT_TIME = 1 minutes;
    require(attackedAt>0 && (attackedAt - uint32(block.timestamp)) >  MAX_WAIT_TIME, "Can kill character now");
    Character.setIsDead(x, y, true);
  }
}