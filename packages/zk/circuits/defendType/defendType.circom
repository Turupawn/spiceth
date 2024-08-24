pragma circom 2.0.0;

include "../circomlib/circuits/poseidon.circom";
include "../circomlib/circuits/comparators.circom";

template DefendTypeCheck() {
    // Inputs
    signal input private_salt;
    signal input private_defense_type;
    signal input public_attack_type;

    // Output signals
    signal output hash_result;
    signal output battle_result;

    // Validate that types can only be 1, 2, or 3
    signal isDefenseValid;
    signal isAttackValid;

    component isDefense1 = IsEqual();
    isDefense1.in[0] <== private_defense_type;
    isDefense1.in[1] <== 1;

    component isDefense2 = IsEqual();
    isDefense2.in[0] <== private_defense_type;
    isDefense2.in[1] <== 2;

    component isDefense3 = IsEqual();
    isDefense3.in[0] <== private_defense_type;
    isDefense3.in[1] <== 3;

    isDefenseValid <== isDefense1.out + isDefense2.out + isDefense3.out;

    component isAttack1 = IsEqual();
    isAttack1.in[0] <== public_attack_type;
    isAttack1.in[1] <== 1;

    component isAttack2 = IsEqual();
    isAttack2.in[0] <== public_attack_type;
    isAttack2.in[1] <== 2;

    component isAttack3 = IsEqual();
    isAttack3.in[0] <== public_attack_type;
    isAttack3.in[1] <== 3;

    isAttackValid <== isAttack1.out + isAttack2.out + isAttack3.out;

    // Force valid types by making the circuit fail if the type is invalid
    // This works as a custom assertion
    signal validCheck;
    validCheck <== isDefenseValid * isAttackValid;
    // Ensure validCheck is always 1
    validCheck === 1;

    // Poseidon hash of the private_salt and private_defense_type
    component hasher = Poseidon(2);
    hasher.inputs[0] <== private_salt;
    hasher.inputs[1] <== private_defense_type;
    hash_result <== hasher.out;

    // Rock-paper-scissors logic for battle result
    signal isRockBeatsScissors;  // Rock beats Scissors (1 vs 3)
    signal isPaperBeatsRock;     // Paper beats Rock (2 vs 1)
    signal isScissorsBeatsPaper; // Scissors beat Paper (3 vs 2)
    signal isSameType;           // Same type condition

    // Rock (Defense type is 1, Attack type is 3)
    component isRock = IsEqual();
    isRock.in[0] <== private_defense_type;
    isRock.in[1] <== 1;

    component isAttackerScissors = IsEqual();
    isAttackerScissors.in[0] <== public_attack_type;
    isAttackerScissors.in[1] <== 3;

    isRockBeatsScissors <== isRock.out * isAttackerScissors.out;  // Rock beats Scissors

    // Paper (Defense type is 2, Attack type is 1)
    component isPaper = IsEqual();
    isPaper.in[0] <== private_defense_type;
    isPaper.in[1] <== 2;

    component isAttackerRock = IsEqual();
    isAttackerRock.in[0] <== public_attack_type;
    isAttackerRock.in[1] <== 1;

    isPaperBeatsRock <== isPaper.out * isAttackerRock.out;  // Paper beats Rock

    // Scissors (Defense type is 3, Attack type is 2)
    component isScissors = IsEqual();
    isScissors.in[0] <== private_defense_type;
    isScissors.in[1] <== 3;

    component isAttackerPaper = IsEqual();
    isAttackerPaper.in[0] <== public_attack_type;
    isAttackerPaper.in[1] <== 2;

    isScissorsBeatsPaper <== isScissors.out * isAttackerPaper.out;  // Scissors beat Paper

    // Same type check
    component isSame = IsEqual();
    isSame.in[0] <== private_defense_type;
    isSame.in[1] <== public_attack_type;

    isSameType <== isSame.out;

    // Determine the battle result
    signal attackerWins;
    signal defenderWins;

    attackerWins <== isRockBeatsScissors + isPaperBeatsRock + isScissorsBeatsPaper;
    defenderWins <== (1 - attackerWins) * (1 - isSameType);

    // Set the battle result: 1 if attacker wins, 0 if defender wins, 2 if it's a tie
    battle_result <== isSameType * 2 + attackerWins;
    log(battle_result);
}

component main {public [public_attack_type]} = DefendTypeCheck();
