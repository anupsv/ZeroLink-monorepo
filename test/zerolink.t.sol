// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2 as console} from "forge-std/Test.sol";
import {BaseUltraVerifier} from "../circuits/contract/zerolink/plonk_vk.sol";
import {ZeroLink} from "../src/ZeroLink.sol";
import {Poseidon} from "../src/Poseidon.sol";

/// @dev Prime field order
uint256 constant PRIME_FIELD = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

contract MockZeroLink is ZeroLink {
    function verifyProof(uint nullifier, bytes32 root_, bytes calldata proof) public view {
        _verifyProof(nullifier, root_, proof);
    }
}

contract ZeroLinkTest is Test {
    address bob = address(0xb0b);
    address babe = address(0xbabe);
    uint DEPTH = 2;
    uint leafIndex = 0;
    uint secret = 1234;
    uint nullifierSecretHash = Poseidon.hash([secret, 0]);

    bytes proof;
    MockZeroLink zerolink = new MockZeroLink();

    function setUp() public {
        proof = vm.parseBytes(vm.readLine("circuits/proofs/zerolink.proof"));

        deal(bob, 100 ether);
        deal(babe, 100 ether);
    }

    // /// Can successfully generate proofs.
    // function test_generate() public {
    //     uint256 key;

    //     generateProof(babe, key, nullifier, secret, nodes);
    // }

    /// Can successfully deposit.
    // function test_deposit() public {
    //     vm.prank(babe);
    //     zerolink.deposit{value: 0.001 ether}(1234);

    //     vm.prank(bob);
    //     zerolink.deposit{value: 0.001 ether}(4567);

    //     vm.prank(babe);
    //     zerolink.deposit{value: 0.001 ether}(7890);
    // }

    function test_deposit_and_withdraw() public {
        vm.prank(babe);
        uint index = zerolink.deposit{value: 0.001 ether}(nullifierSecretHash);

        // Read new `root`.
        bytes32 root = zerolink.getLastRoot();

        console.log("index", index);
        console.log("root", vm.toString(root));
        vm.prank(babe);
        zerolink.withdraw(proof, nullifierSecretHash, root);
    }
}
