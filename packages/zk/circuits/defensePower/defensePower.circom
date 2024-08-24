pragma circom 2.0.0;

include "../circomlib/circuits/comparators.circom";

template BattlePowerCheck() {
    // Inputs
    signal input private_defendant_type; // 1 for Rock, 2 for Paper, 3 for Scissors
    signal input public_defendant_level;
    signal input public_attacker_level;
    signal input public_attacker_type; // 1 for Rock, 2 for Paper, 3 for Scissors

    // Output signal for the battle result
    signal output battleResult;

    // Rock-paper-scissors logic
    signal isRockVsScissors;  // Rock beats Scissors (1 vs 3)
    signal isPaperVsRock;     // Paper beats Rock (2 vs 1)
    signal isScissorsVsPaper; // Scissors beat Paper (3 vs 2)
    signal isSameType;        // Same type condition

    // Rock (Defendant type is 1, Attacker type is 3)
    component isRock = IsEqual();
    isRock.in[0] <== private_defendant_type;
    isRock.in[1] <== 1;

    component isAttackerScissors = IsEqual();
    isAttackerScissors.in[0] <== public_attacker_type;
    isAttackerScissors.in[1] <== 3;

    isRockVsScissors <== isRock.out * isAttackerScissors.out; // Rock beats Scissors

    // Paper (Defendant type is 2, Attacker type is 1)
    component isPaper = IsEqual();
    isPaper.in[0] <== private_defendant_type;
    isPaper.in[1] <== 2;

    component isAttackerRock = IsEqual();
    isAttackerRock.in[0] <== public_attacker_type;
    isAttackerRock.in[1] <== 1;

    isPaperVsRock <== isPaper.out * isAttackerRock.out; // Paper beats Rock

    // Scissors (Defendant type is 3, Attacker type is 2)
    component isScissors = IsEqual();
    isScissors.in[0] <== private_defendant_type;
    isScissors.in[1] <== 3;

    component isAttackerPaper = IsEqual();
    isAttackerPaper.in[0] <== public_attacker_type;
    isAttackerPaper.in[1] <== 2;

    isScissorsVsPaper <== isScissors.out * isAttackerPaper.out; // Scissors beat Paper

    // Same type check
    component isSame = IsEqual();
    isSame.in[0] <== private_defendant_type;
    isSame.in[1] <== public_attacker_type;

    isSameType <== isSame.out;

    // Combine special cases for defendant winning
    signal isDefendantWins;
    isDefendantWins <== (isRockVsScissors + isPaperVsRock + isScissorsVsPaper) * (1 - isSameType);

    // Combine special cases for attacker winning
    signal isAttackerWins;
    isAttackerWins <== (1 - isDefendantWins) * (1 - isSameType);

    // Set effective levels with 2x boost for the winner
    signal effective_defendant_level;
    signal effective_attacker_level;

    effective_defendant_level <== public_defendant_level * (1 + isDefendantWins);
    effective_attacker_level <== public_attacker_level * (1 + isAttackerWins);

    // Compare effective levels to determine the winner
    component compareLevels = LessThan(64); // Remove the bit-width assumption
    compareLevels.in[0] <== effective_defendant_level;
    compareLevels.in[1] <== effective_attacker_level;
    signal finalAttackerWins <== compareLevels.out;

    // Return 1 if the attacker wins, otherwise 0
    battleResult <== finalAttackerWins;

    // Log effective levels and special case
    log(effective_attacker_level);
    log(effective_defendant_level);
    log(battleResult);
}

component main {public [public_defendant_level, public_attacker_level, public_attacker_type]} = BattlePowerCheck();
