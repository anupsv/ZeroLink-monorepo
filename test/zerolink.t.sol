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
    uint nullifierSecretHash = Poseidon.hash([secret, leafIndex]);

    bytes proof;
    MockZeroLink zerolink = new MockZeroLink();

    function setUp() public {
        proof = hex"09fd9b2007076eaa441bafd0691d62844a30a097b5c76336671481b8f8ee6b741267deb7b230d192e449fcddfe624b5e44a0f8ef74c9eb1aea700dc151f499e9276e22bd0ec386b0238718574b5b70c3a219a113d59abd99d8da8a6d696aa8ef10002ca03f5cb1b07ae9c906a642e5beae01aa3c33b7d86f8c4586a5620a152e1b4b6184c75a95f0df335183e06c1861c44355e0eaacf1a60e70ee854679a4f529b8bcb9f621d5e4a3994d46786cfbb4ce0a0ef67afeca8f6ff38547d50ed50d2cf3a5898e154e131a97a9ba3c255b76935d50e7c2c8c7da6e7495584788055c1120da3aa5286a4cdfc2a02bb4249cd07c06b2424f993a660fd1a5ff8c2fcccc2fc71011956872473b3daae31a645ad270ed91e2060fe8c0b33e90d4ccc9b4080bb656a974430b5c43bd571051a3f8257960d4658275262d0522b1f3a7c8e0291299571b06b1e8bba7d94d0680ec6a54428716573b0183929f18e95c302b40aa2d976e8859e741f8a354b5b49d8c8e090cb8d083295c505475c6a89f04a3f5d9069b6bad5455ed7e8a16302a32cab1a312b6d5aa0c53a36ff9d9392ac684ae0a21d62e9c44467e4b3a20a67dde69bf216b3930a5b98b874f23a75423242daa292132c707a1222484557f25d796def990e84d5e400decda1d78f2438a4e6d9f382490d2f221607843c9b1dd8487eb654232da61f4bef37d381a9d658b13eca94513d74daafda10719e2f7e9729f1f08168ce6b66a54dc4cdf269bf494ad899f38016ec00d8a1d2634e0000819e4abcc970e9e535257004c38f22dbc786c38d3fb0bfe8b86c0cd1c9b6c8acb904db6ef920d016274a8ff49f26ec0a89bd31566ae28250febd263ed4cfcf47f9eef5f7e5dcd5c2a204e4000246ec4a50f61f759c60f8a2de7a95cf81e0bdfdccf0aed1f6572022324bb2d31ef35ce88fcba2e9e55055a9e6dd7e42aaebf5537c95ec13ae9f29552399651cf129c15f22b07e58025014b0d061f90394b1f4f2f755fa2791212ecc2ad8d41d14913d8080b8aceb28d0e8ac2c576120215adfc02402bc13b2c7ec71a7983dece7cd401357f1f8a5da61c46db47d9de9301cdf3308f1736ea84a5e99d901f1ad25aa2885dc8f52e30521e3aab0a0ce34e54866fc1a06bf10c4705dd2f819837e2107100b5502cdaeb820a3480f76af38614c7dc0c991149625d1b43128e03ed7d0bc17d92e31d0e8a7206aee13cb3bcb2d78e2c2933dc491c4fef32ec5e417701b16c8e43660813036e22671f325dc8d9d5d77094d159b0a8d24db957e9dc4c05d0d99c910f2c736e2526a3a6a09001b540c1e07102cc9173ebe137329ec2640b0c3dbde7064d1ce7552379592e09e4dff13db40352c4ec6bdbc5701f081c0d760c4051c34b7a7dda44153f206b7f035d56ca82485c3fc137c47feb3bea6a0caf17d328c2831951eb6915f203600f31ea4b779853f2b3d936567cb3d7ea091d1688b91814d56a35f7f2171e922cd90c5a1f80bb3dd84259ce34ade06ebd244886915d65851e1fa6df2708e4a1fb97b54652acfc0c4db3dd9c8c60d74e357819fcc5ec9590abb2d609112d7810065013e23f59a45bb260370243c08d0b1350422d0d5dfb0858bd20399f11b9415cc474af9af4fc856ed1a9e1be4acc4035d18789542674b4d4d5be301120eb051016cadf7133647dec0dc5d181bb0dc3df0daba1cd15a41f401f50f3eb1471eb79ce42a66fdf3874ad00943d1bc26fc51891480008c8877b87b659f2931eba822ccd7a2f98b699887b04656b185d16f898a45d53ebd9f92f903c2a440208870cfb6076026d2c8e133cd05ae3a39cf4f3ecfaf82a78b0de7a363693795e002d7a2c21d9e5e665999e58f0cfc7b232942a167bbe579b28c0777b254c96d8216d71eb92f0375bf7817b60ca4b6608804458b43003d9ff79b17685eddb663c2be406c01e63d496ef30a7e567b26cacf967afd4123a2d11723029aad46befe41f6aed29d5db9b959b049ea65a80d84700c9b10d95d68b4d251385f26b74ee8c12f1d3938d53629446d895674d4f43e1082bb2471972e988d7f6e23a027ded340678b9fd44cb2992f2ac8c28401daf7b0f8db3809d0f47c48ada3e819986ebdc07f8d1e385ba6d6e8b0c6b6df362a8b5c9d1c65214e45e447b6ad7cf4d62f13b1c92b9da8e23eccdccf2c5b1012a635b4d82fc5b6a58719fc4810a643b0f9c412e1038904bf50c022f1537af4aa21a63a9c5da7c1e727525900c7f7cec14cddf0f5ee63392d626973cf28d0af7acecb40675f008598370c055befc169e1e59e720c7a22d0522c14ed42e79eaa82c400c631e4866d97218c291ff84632ea376a71810188bb7764540e722985752fb2dfca98d47ff82f0a0e7cdee3f3a51a917c10fa7f54d5958994c4233debfcfa9ad8398e81249aab93fd06d5ab3206142b2450879785e7b52e2d914c02bc01a43e44922fdc4b0a216f05e9b572b7e20e0e1e726edd1847e35528acb6620bfd2866f821dd5f694f25ce8af4035c38fc36c629207fb236a1bd56a91a7ee150c849be52fa28d94e99a5e9f4c56db46d54f3bc971027ccc85f8a5488d3dc08b302a6892decca0012ac42767ae5a4a026e4ca1f3c119eaa36266e886084ac8a76d70b6ebeda6f4b05c42c0283e4001a28a2f8a4597114387f7a1c8b87ccc36bcfadbc659c93a76631e87b9bbd3bd78bfa7455a68bb26dd9ea6cd18ca9894b21471240cc616256b36d49b167a61e98ba09d847746cb0c1366e317373c8aa4dd2630ead1da05e82c224234b9c85ed1bc8bffd39424da21ad7d9242874ea66d587da733184652d320f5f8481686ecfdcf6cf612b102ea1f5e758d97ed23c4e2b71f8a3db445154412499da91925804e436c27a129b23f0e4fc09230c992d4f35a76c3c0a44e028d60176aed8b7830e9093bfa041515652487c864b314fc09b8575c00b8b13b6ebfd03bb4d0843b2a42ef804d2ed20e632a84e2423bce263b36f5eae9e8180f7a4a045ca214a02c1b736552035a1874b9";

        deal(bob, 100 ether);
        deal(babe, 100 ether);
    }


    // Can successfully deposit.
    function test_deposit() public {
        vm.prank(babe);
        zerolink.deposit{value: 0.001 ether}(1234);

        vm.prank(bob);
        zerolink.deposit{value: 0.001 ether}(4567);

        vm.prank(babe);
        zerolink.deposit{value: 0.001 ether}(7890);
    }

    /// Deposit failure.
    function test_deposit_revert_LeafAlreadyCommitted() public {
        vm.prank(babe);
        zerolink.deposit{value: 0.001 ether}(1234);

        vm.prank(bob);
        vm.expectRevert(ZeroLink.LeafAlreadyCommitted.selector);
        zerolink.deposit{value: 0.001 ether}(1234);
    }

    function test_deposit_and_withdraw() public {
        vm.prank(babe);
        uint index = zerolink.deposit{value: 0.001 ether}(nullifierSecretHash);

        // Read new `root`.
        bytes32 root = zerolink.getLastRoot();

        vm.prank(babe);
        zerolink.withdraw(proof, nullifierSecretHash, root);

        assertEq(babe.balance, 100 ether);
    }

    /// Can successfully withdraw with old root.
    function test_withdraw_old_root() public {
        vm.prank(babe);
        zerolink.deposit{value: 0.001 ether}(nullifierSecretHash);

        bytes32 root = zerolink.getLastRoot();

        vm.prank(bob);
        zerolink.deposit{value: 0.001 ether}(12345);

        // Alice's proof is still valid.
        vm.prank(babe);
        zerolink.withdraw(proof, nullifierSecretHash, root);
    }

    /// Can't withdraw with a valid proof but invalid root.
    function test_withdraw_revert_InvalidRoot() public {

        // `root` corresponds to valid proof, but it was never committed.
        vm.prank(babe);
        vm.expectRevert(ZeroLink.UnknownRoot.selector);
        zerolink.withdraw(proof, nullifierSecretHash, bytes32(bytes("nope")));
    }

}
