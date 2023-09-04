// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {MerkleTreeWithHistory} from "./merkleTree.sol";
import {Poseidon} from "./Poseidon.sol";
import {UltraVerifier} from "../circuits/contract/zerolink/plonk_vk.sol";


contract ZeroLink is MerkleTreeWithHistory, UltraVerifier {
    error InvalidNodes();
    error NullifierUsed();
    error RefundFailed();
    error InvalidDepositAmount();
    error UnknownRoot();
    error LeafAlreadyCommitted();

    uint256 constant DEPOSIT_AMOUNT = 0.001 ether;
    // left to right is the order, same as how the leaves are filled.
    uint blocked = 9999999;

    mapping(uint => bool) nullifierUsed;
    mapping(uint => bool) committedNullifier;

    constructor() MerkleTreeWithHistory() {}

    event Deposit(uint indexed commitment, uint leafIndex, uint256 timestamp, bytes32 lastroot);

    function updateBlocked(uint newValue) public {
        blocked = newValue;
    }

    function deposit(uint nullifierSecretHash) public payable returns (uint256) {
        // Require 1 ether deposit value.
        if (msg.value != DEPOSIT_AMOUNT) revert InvalidDepositAmount();
        
        if (committedNullifier[nullifierSecretHash]) revert LeafAlreadyCommitted();
        committedNullifier[nullifierSecretHash] = true;

        // Compute and update root with `nullifierSecretHash` inserted at `key` index.
        bytes32 leaf = bytes32(nullifierSecretHash);
        uint leafIndex = _insert(leaf);
        
        emit Deposit(nullifierSecretHash, leafIndex, block.timestamp, getLastRoot());
        return leafIndex;
    }

    function withdraw(bytes calldata proof, uint nullifier, bytes32 subTreeRoot) public {
        // Check `nullifier` to prevent replay.
        if (nullifierUsed[nullifier]) revert NullifierUsed();

        // check only the main root because its sufficient as the subroot will be checked for inclusion.
        // Every subroot change will change the main root, so no point in checking both.
        if (!isKnownRoot(subTreeRoot)) revert UnknownRoot();
        // Mark `nullifier` as used.
        nullifierUsed[nullifier] = true;

        // The prover verifies the zero knowledge proof, demonstrating
        //   - Knowledge of pre-image of a leaf: `nullifier`, `leafIndex` and `secret` hash.
        //   - The leaf is contained in merkle tree with `subTreeRoot`.
        //   - The subroot is now a leaf of the depositTreeRoot
        //   - The proof is generated for `receiver`.
        _verifyProof(nullifier, subTreeRoot, proof);

        // Refund caller.
        (bool success,) = msg.sender.call{value: DEPOSIT_AMOUNT}("");
        if (!success) revert RefundFailed();
    }

    function _verifyProof(uint nullifier, bytes32 subTreeRoot, bytes calldata proof) internal view {
        // Set up public inputs for `proof` verification.
        bytes32[] memory publicInputs = new bytes32[](3);

        publicInputs[0] = subTreeRoot;
        publicInputs[1] = bytes32(nullifier);
        publicInputs[2] = bytes32(blocked);

        // Verify zero knowledge proof.
        this.verify(proof, publicInputs);
    }
}