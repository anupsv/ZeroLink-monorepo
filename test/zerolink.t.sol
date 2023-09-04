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
    uint nullifier = 12356789;
    uint nullifierSecretHash = Poseidon.hash([nullifier, secret]);

    bytes proof;
    MockZeroLink zerolink = new MockZeroLink();

    function setUp() public {
        proof = hex"22bdb408410437802c8251c891ecbb914a2d780ea7c8845c7739f6b151ee427b0d78dff55fefd936ec8a95013c46de2e97ca1cb6fa0a3eedc9e7b21a1708580111f68c1bc7a96c4ed4c9f5376f4a5c88931e597afa3e79914c4b2b59c98d796d0cec2fc2d2cf6cecbb73190d981e08bc216986f64a41ef81b1b0710f8128b297129425432a1f16420a215228bc1a07e3e884f081993c3019da943f2999049eb62d322a0bffa6bffc4a6b9c32578b89e118a4e43746c8a1984113fd9def24bd7a17205d83ee72789edd4eb099688ed369016f47b6b48b97e1131c4676fb4a933d0eed5caa32cea889c51d3596efc6886517093493bc74e6b4a8e8f6d2015f90a20693d5517db300d9a0e92d06d8ea2659dcb93590c6e63755e57411ad11d61be91d67352ecef900605e3f3232e15582ecf1bf1cdcf525e4eac9d7c2faf09f177f24e476990c522c4c46b3ca6a7671bed06d158da9e59863fd1b57ede872b9bcf330341634075502839eba4c80308054cbeeffa83b2ad6381222f1ce048e1dc94b1ccf03b5e02635c16770eebb0e015ca2ae3d525b4284415f9e8951a704a93a7f1aee7b9971ca8a009528a3fa1f9a83a78915da123091d6d2c070f8af352ad82c03be6d4dacf63e63116bfffd437fac7acb5bd95343764ea98190ce038fed023f1d8ea6d901f9e098abdcaa196f849e50709573fea2a835cdccd45f5ac926566f2654c8bb233df9c44e9f9c00befa0b5e6eae3d82d8af882af50a7a47b78b5bda03bf2be597eeb797c2f2d6f2236b7e85e6c726c9a2f455dd0979005ef1acd5b42c13b2a691a77874884bb1af621156ef2f9a2d808f67f8b17e2a0a946a1dc10206fafdd2abf2736549c20dbd433dd2dece87e046bec7b1b3c109bd51559874042eb3c132ddc1c3fea2b2a30ad64c84ff3d9122ea8fd5ad7d81e99e25207bf9460c78d0c5002287b79d263b3b2b0f54edd41fa2f1897548a11b20bc8dd3de921124d026607c1e8976f62eeeea98072569827394baaf0ddce03ba6703ba602b05f1e094b620675120f0c6bc094802f510580d9b9047862ae7927a4b31d2c229b6b2b5563624cb73ddf97cf73fb11a448f50138c8aa31029dda1c09ed69cbbda2120522de880a0f8a3a0d25e0f880b4d311a1924c8762d3f88b5f32dded740329e72d21ead4b5a65626f786eb2e3ac932452e5abd240af22a35b2b32bb7012e02bd28c4d97919d6cedbb221af54d0372090cd3d21dd74f9bd61c82ca079977e4199041b4fda70480b92e09f6e36d30f46c650186146223bafbcb7d7cec18d92ba0800609b0c6f53c051a69882c319a069e2c049c5fbbb75de42a6d61802c2835d8d119764ce7c7f7505dd98c246be65eaad2749b3d3deb157eef1e1ddef2167253b2b221bd796cec3c9a8d9e22d331bc87e4d18ab729d344109641b7fa599baec8b24bec8cd53ec5cb16a31acefcc192723f8f6704d97bbd80c0f713a7d35c80d5f0b2874002711b54d190075448567cd3557ff8a707742941a31748eebc3fe1c691905ce04799c91c4a992c868e0acd8f2fc5b940615f611cb78822f6f8fc053360ea549237b65f9af7a0df4929f78287ca1c6c2b6873be338532777a632fcb20418e3629f8fb4404ac05b0a4e0b42ed9a456fa803f15a981631c8820fc5ac426f1eec05fa8d49baf54322608c71650e876157b45026bd0bc97538dcf1d8ac140e1cfb1a5ef5be2fb68b729c6b532906532ecd75a656681d0897261318b9a2c0f32849b11158f5755bcc4541411e6ccd7b02625ef6f8f8c0233f9f901e0e1626831decaeecacf35a7f40edc826ee64855ee7d7973f42878045b3479662e5622e7b2d49db559ebd414f412a3e0d06438ccf1701b4c60f4e750a7d481bd93460a76427d517fd9a3c400fc90eaf868ebec5fdf61b0256e4fd0ea206697c4fdaa7b24a19194327c6a719391c13142916b0f5eac9b8f852b5be3f86db007f667b901abd1728578c2f1b8dfa64635007f874edb6972eb9a8e56950c5fcedb58d5c86c7a215376bf0979002bbacb38be6da38e58264a47aff151462051edaebb43d7d7487134680550004777cf503c7c5bbfcdd4e321a3c5544bf734440c821db1e74216c1b0a2ec35e32a477d3c2d84a34ecfe1efc4336fc86132e47b913493f9a996dd81c832a7c22cf3d3b075043164869177ffbb958a563ea632dec47b03f5e6e18f22893b99482f3b472d93459bcc6564f2eba24acdbb9ba1a6fb7c6fe5aa1ffd86b0d615c9b52640d49d7f9964c4b831d5a2268a927980199b978ffb20c458a57d40e43933579ef1fe2eeb38d08070317a040fe9c1c1030347159eaab1b5e48062c08275448badee5ed8f07d39c4b88281b83e7f676bbf0f4569867723338d05d9713cd5bae740b46915e139ebeddb84325ee6333763f5386af44cf8a891c62b59b184c04252f92712ad2e9d1fc31aebc83dd7cfda2b71d4fbadc36e6b34c00c800218f541ab6d930d7f7411a8a8c48896a6a605752e12bb9e41fe88976aa86ba6401166cdbd85b2e3bf648f88788c27ebe900e03d73224a62f8665cd08d422ae93015f6ab774768f8390b94ebb74b10a2abf6e810630951a7b0193f884f8e3e78a04f6f57f904883259b8b84fcaaf029a4113b1bbcd3c079369f2ccd11d9ddf2e32cdc70a84752f5be41a5cceb6a74ecf6a87514d6e627f1c4737921c54be0252e186752d232010f79404b7b23c7e8a9dca264e26f3c79384c307ce9cbc4dd7d9c03f234fc1caf29343ef1295c255c66c29c54b00792ca7ed3ed80b1d23ddad60a1fe16598e88ee318f5e71d4b04517c05be7865e862d535ecee666f6ca6d82e791cb262c39788496ea0ae9cd6d49c093b31e01262cc956d28fe9a5b9a7884c3802d24bd765c92615ce462d9fd3d4bc043c8e3537c0cf95767ab38af2cf1451123091cefddc7cb56b0736def3f340be89e98e53144f2e860a28ebc3af128f94fd526339a454e2ca9c43517e3aacfb7c787432af4a14e63d1e28c4a31cee9b121cb";

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
        zerolink.withdraw(proof, nullifier, root);

        assertEq(babe.balance, 100 ether);
    }

    // /// Can successfully withdraw with old root.
    function test_withdraw_old_root() public {
        vm.prank(babe);
        zerolink.deposit{value: 0.001 ether}(nullifierSecretHash);

        bytes32 root = zerolink.getLastRoot();

        vm.prank(bob);
        zerolink.deposit{value: 0.001 ether}(12345);

        // Alice's proof is still valid.
        vm.prank(babe);
        zerolink.withdraw(proof, nullifier, root);
    }

    // /// Can't withdraw with a valid proof but invalid root.
    function test_withdraw_revert_InvalidRoot() public {

        // `root` corresponds to valid proof, but it was never committed.
        vm.prank(babe);
        vm.expectRevert(ZeroLink.UnknownRoot.selector);
        zerolink.withdraw(proof, nullifier, bytes32(bytes("nope")));
    }

    //  /// The same `nullifier` cannot be used twice.
    function test_withdraw_revert_NullifierUsed() public {

        vm.prank(babe);
        zerolink.deposit{value: 0.001 ether}(nullifierSecretHash);

        bytes32 root = zerolink.getLastRoot();
        vm.prank(babe);
        zerolink.withdraw(proof, nullifier, root);

        vm.prank(babe);
        vm.expectRevert(ZeroLink.NullifierUsed.selector);
        zerolink.withdraw(proof, nullifier, root);
    }

    // /// Cannot modify `nullifier` in proof.
    function test_verify_revert_PROOF_FAILURE_invalid_nullifier(uint nullifier_) public {

        vm.prank(babe);
        zerolink.deposit{value: 0.001 ether}(nullifierSecretHash);

        bytes32 root = zerolink.getLastRoot();

        vm.assume(nullifierSecretHash != nullifier_);

        vm.expectRevert();
        zerolink.withdraw(proof, nullifier_, root);
    }

    /// Cannot modify `root` in proof.
    function test_verify_revert_PROOF_FAILURE_invalid_root(bytes32 root_) public {

        vm.prank(babe);
        zerolink.deposit{value: 0.001 ether}(nullifierSecretHash);

        bytes32 root = zerolink.getLastRoot();

        vm.assume(root != root_);

        vm.expectRevert();
        zerolink.verifyProof(nullifier, root_, proof);
    }

    /// Cannot modify `proof`.
    function test_verify_revert_invalidProof(bytes calldata proof_) public {
        vm.assume(keccak256(proof) != keccak256(proof_));

        vm.prank(babe);
        zerolink.deposit{value: 0.001 ether}(nullifierSecretHash);

        bytes32 root = zerolink.getLastRoot();

        vm.expectRevert();
        zerolink.verifyProof(nullifier, root, proof_);
    }

    /// Cannot modify any proof inputs.
    function test_verify_revert_invalidInputs(address sender, bytes calldata proof_, uint nullifier_, bytes32 root_)
        public
    {
        bool validProof;
        vm.prank(babe);
        zerolink.deposit{value: 0.001 ether}(nullifierSecretHash);
        bytes32 root = zerolink.getLastRoot();
        validProof = validProof && root == root_;
        validProof = validProof && sender == babe;
        validProof = validProof && nullifier == nullifier_;
        validProof = validProof && keccak256(proof) == keccak256(proof_);
        vm.assume(!validProof);

        vm.expectRevert();
        zerolink.verifyProof(nullifier_, root_, proof_);
    }

}
