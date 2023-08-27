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
    uint nullifier = uint(0x222244448888);
    bytes32 secret = bytes32(uint256(0x1337));
    uint nullifierSecretHash = Poseidon.hash([uint256(0x222244448888), uint(1)]);

    bytes proof;
    MockZeroLink zerolink = new MockZeroLink();

    function setUp() public {
        // proof = getProofBytes();

        deal(bob, 100 ether);
        deal(babe, 100 ether);
    }

    // /// Can successfully generate proofs.
    // function test_generate() public {
    //     uint256 key;

    //     generateProof(babe, key, nullifier, secret, nodes);
    // }

    /// Can successfully deposit.
    function test_deposit() public {
        vm.prank(babe);
        zerolink.deposit{value: 0.001 ether}(1234);

        vm.prank(bob);
        zerolink.deposit{value: 0.001 ether}(4567);

        vm.prank(babe);
        zerolink.deposit{value: 0.001 ether}(7890);
    }
}
