circom defensePower.circom --r1cs --wasm --sym
node defensePower_js/generate_witness.js defensePower_js/defensePower.wasm input.json witness.wtns
