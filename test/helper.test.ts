import { expect } from 'chai';
// import { describe, it } from 'mocha';
import { NoirNode } from "./NoirNode";
import { convertToHex } from "./common";

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

  async function getMerkleTree() {
    let commitment1 = await noir.pedersenHash([BigInt(110386806875492)]);
    let commitment2 = await noir.pedersenHash([BigInt(27422285723297124n)]);
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