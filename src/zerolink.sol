// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {MerkleTreeWithHistory} from "./merkleTree.sol";

contract ZeroLink is MerkleTreeWithHistory {
    error InvalidNodes();
    error NullifierUsed();
    error RefundFailed();
    error InvalidDepositAmount();
    error UnknownRoot();

    uint256 constant DEPOSIT_AMOUNT = 0.001 ether;

    mapping(bytes32 => bool) nullifierUsed;

    constructor(address poseidon) MerkleTreeWithHistory(4, poseidon) {}

    function deposit(uint nullifierSecretHash) public payable returns (uint256) {
        // Require 1 ether deposit value.
        // if (msg.value != 0.001 ether) revert InvalidDepositAmount();

        // Compute and update root with `nullifierSecretHash` inserted at `key` index.
        bytes32 leaf = bytes32(hasher_2.hash([nullifierSecretHash, uint(msg.value)]));
        uint leafIndex = _insert(leaf);

        return leafIndex;
    }

    function withdraw(bytes calldata proof, bytes32 nullifier, bytes32 subTreeRoot, bytes32 depositTreeRoot) public {
        // Check `nullifier` to prevent replay.
        if (nullifierUsed[nullifier]) revert NullifierUsed();

        // check only the main root because its sufficient as the subroot will be checked for inclusion.
        // Every subroot change will change the main root, so no point in checking both.
        if (!isKnownRoot(depositTreeRoot)) revert UnknownRoot();
        // Mark `nullifier` as used.
        nullifierUsed[nullifier] = true;

        // The prover verifies the zero knowledge proof, demonstrating
        //   - Knowledge of pre-image of a leaf: `nullifier`, `leafIndex` and `secret` hash.
        //   - The leaf is contained in merkle tree with `subTreeRoot`.
        //   - The subroot is now a leaf of the depositTreeRoot
        //   - The proof is generated for `receiver`.
        // _verifyProof(recipient, nullifier, subTreeRoot, depositTreeRoot, proof);

        // Refund caller.
        // (bool success,) = msg.sender.call{value: 1 ether}("");
        // if (!success) revert RefundFailed();
    }

    // function _verifyProof(address receiver, bytes32 nullifier, bytes32 subTreeRoot, bytes32 depositTreeRoot, bytes calldata proof) internal view {
    //     // Set up public inputs for `proof` verification.
    //     bytes32[] memory publicInputs = new bytes32[](65);

    //     publicInputs[0] = bytes32(uint256(uint160(receiver)));
    //     // publicInputs[1] = nullifier;
    //     // publicInputs[2] = root_;

    //     for (uint256 i; i < 32; i++) {
    //         publicInputs[1 + i] = bytes32(uint256(uint8(nullifier[i])));
    //     }

    //     for (uint256 i; i < 32; i++) {
    //         publicInputs[33 + i] = bytes32(uint256(uint8(root_[i])));
    //     }

    //     // Verify zero knowledge proof.
    //     this.verify(proof, publicInputs);
    // }
}