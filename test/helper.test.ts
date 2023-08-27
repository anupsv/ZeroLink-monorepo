import { expect } from 'chai';
// import { describe, it } from 'mocha';
import { NoirNode, generateWitness } from "./noirNode";
import { convertToHex } from "./common";
import {ethers} from "ethers";
import { Ptr, Fr } from '@aztec/bb.js/dest/node/types/index.js';

import { beforeAll, afterAll, describe } from 'vitest';
import circuit from '../circuits/target/zerolink.json' assert { type: "json" };

const noir = new NoirNode();

describe('Integration tests', function () {
  let merkleData: any;

  beforeAll(async () => {
    await noir.init(circuit);
    merkleData = await getMerkleTree();
  });

  afterAll(async () => {
    await noir.destroy();
  });

  async function generateInitialWitness (input: any) {
    const initialWitness = new Map<number, string>();
    const nulli = await noir.pedersenHash([BigInt(input.secret), input.index]);

    initialWitness.set(1, input.root);
    initialWitness.set(2, input.hash_path[0]);
    initialWitness.set(3, input.hash_path[1]);
    initialWitness.set(4, convertToHex(nulli));
    initialWitness.set(5, convertToHex(BigInt(input.secret)));
    initialWitness.set(6, convertToHex(input.index));
    // initialWitness.set(2, convertToHex(input.index));
    // initialWitness.set(3, input.hash_path[0]);
    // initialWitness.set(4, input.hash_path[1]);
    // initialWitness.set(5, convertToHex(input.secret));
    // initialWitness.set(6, convertToHex(input.proposalId));

    return initialWitness;
}

  async function getMerkleTree() {
    // let hexVal = ethers.utils.hexZeroPad(`0x656d707479`, 32);
    // console.log(Fr.fromString(hexVal));
    let commitment1 = await noir.pedersenHash([BigInt(27422285723297124)]);
    let commitment2 = await noir.pedersenHash([BigInt(110386806875492)]);
    let commitment3 = await noir.pedersenHash([BigInt(110386806875492)]);
    let commitment4 = await noir.pedersenHash([BigInt(110386806875492)]);

    let leftSubtree = await noir.pedersenHash([commitment1, commitment2]);
    let rightSubtree = await noir.pedersenHash([commitment3, commitment4]);

    let root = await noir.pedersenHash([leftSubtree, rightSubtree]);

    return {
      root: convertToHex(root),
      hashPath: [convertToHex(commitment2), convertToHex(rightSubtree)],
      leafIndex: 0
    }
  }

  it("Should be able to generate proof and verify it for valid inputs", async () => {
    
    let mktree = await getMerkleTree();

    let inputs = {
        root: mktree.root,
        index: 0,
        hash_path: mktree.hashPath,
        secret: 1,
    }
    
    const initialWitness = await generateInitialWitness(inputs)
    const witness = await noir.generateWitness(initialWitness);
    const proof = await noir.generateProof(witness);

    expect(proof instanceof Uint8Array).to.be.true;

    const verified = await noir.verifyProof(proof);

    expect(verified).to.be.true;
  });
});