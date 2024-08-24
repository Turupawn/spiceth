
```
circom defendType.circom --r1cs --wasm --sym
node defendType_js/generate_witness.js defendType_js/defendType.wasm input.json witness.wtns
```


```
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
snarkjs groth16 setup defendType.r1cs pot12_final.ptau defendType_0000.zkey
snarkjs zkey contribute defendType_0000.zkey defendType_0001.zkey --name="1st Contributor Name" -v
snarkjs zkey export verificationkey defendType_0001.zkey verification_key.json
snarkjs zkey export solidityverifier defendType_0001.zkey ../../../contracts/src/DefendTypeVerifier.sol
```


```
mkdir ../../../client/public/zk_artifacts/
cp defendType_js/defendType.wasm ../../../client/public/zk_artifacts/
cp defendType_0001.zkey ../../../client/public/zk_artifacts/defendType_final.zkey
```