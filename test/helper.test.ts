import { expect } from 'chai';
// import { describe, it } from 'mocha';
import { NoirNode } from "./NoirNode";
import { convertToHex } from "./common";

import { beforeAll, afterAll, describe } from 'vitest';
import circuit from '../circuits/target/zerolink.json' assert { type: "json" };
import {MerkleTree} from "./merkleTree";
import {Fr} from "@aztec/bb.js/dest/node/types";
import {Buffer} from "buffer";

const noir = new NoirNode();

describe('Integration tests', function () {
  let merkleData: any;

  beforeAll(async () => {
    await noir.init(circuit);
    merkleData = await getMerkleTree();
    console.log(merkleData);

    // let mt= new MerkleTree(2);
    // mt.initialize([]);
    // mt.insert(Fr.fromBuffer(Buffer.from("1")))
    // mt.insert(Fr.fromBuffer(Buffer.from("2")))
    // mt.insert(Fr.fromBuffer(Buffer.from("3")))
    // mt.insert(Fr.fromBuffer(Buffer.from("4")))
    // console.log(mt.root().toString())
  });

  afterAll(async () => {
    await noir.destroy();
  });

  function generateInitialWitness(input: any) {
    const initialWitness = new Map<number, string>();

    initialWitness.set(1, input.root);
    initialWitness.set(2, convertToHex(input.index));
    initialWitness.set(3, input.hash_path[0]);
    initialWitness.set(4, input.hash_path[1]);
    initialWitness.set(5, convertToHex(input.secret));
    initialWitness.set(6, convertToHex(input.proposalId));

    return initialWitness;
  }

  async function getMerkleTree() {
    let commitment1 = await noir.pedersenHash([BigInt(110386806875492)]);
    let commitment2 = await noir.pedersenHash([BigInt(27422285723297124)]);
    let commitment3 = await noir.pedersenHash([BigInt(110386806875492)]);
    let commitment4 = await noir.pedersenHash([BigInt(110386806875492)]);

    let leftSubtree = await noir.pedersenHash([commitment1, commitment2]);
    let rightSubtree = await noir.pedersenHash([commitment3, commitment4]);

    let root = await noir.pedersenHash([leftSubtree, rightSubtree]);

    return {
      root: convertToHex(root),
      hashPath: [convertToHex(commitment2), convertToHex(rightSubtree)]
    }
  }
});