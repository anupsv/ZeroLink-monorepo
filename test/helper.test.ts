// @ts-ignore
import ethers, { Contract } from 'ethers';
import { test, beforeAll, describe, expect } from 'vitest';
import {Fr} from "@aztec/bb.js/dest/node/types";
import {MerkleTree} from "./merkleTree";
import blake2 from 'blake2';

describe('Setup', () => {

  let merkleTree: MerkleTree;

  beforeAll(async () => {

    let arr = [
      "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
      "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92267",
      "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92268",
      "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92269",
      "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92260",
      "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92261",
      "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92262",
      "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92263",
      "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92264"
    ];
    merkleTree = new MerkleTree(4);
    const denied = Fr.fromBuffer(Buffer.from("denied"));
    const allowed = Fr.fromBuffer(Buffer.from("allowed"));
    await merkleTree.initialize([]);

    await Promise.all(
        arr.map(async (addr: any) => {
          // @ts-ignore
          const leaf = Fr.fromString(addr);
          merkleTree.insert(leaf);
        }),
    );
    let index = merkleTree.getIndex(Fr.fromString("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92264"));
    console.log(index);
    console.log(merkleTree.root().toString());
    console.log(merkleTree.proof(index).pathElements.map(el => el.toString()));
  });

  test('adds 1 + 2 to equal 3', () => {
    expect(1+2).toBe(3);
  });
});
