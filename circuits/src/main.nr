use dep::std;

global ALLOWED: Field = 27422285723297124; // essentially value of "allowed"
global DENIED: Field = 110386806875492; // essentially value of "denied"


// Change 12345 hash to value of "allowed"


/// Main circuit.
fn main(subTreeRoot: Field, subTreePath: [Field; 3], nullifier: Field, randomSecret: Field, subTreeLeafIndex: Field) {

  // Step 1 verify the nullifier and secret
  let calculatedNullifier: Field = std::hash::pedersen([randomSecret, subTreeLeafIndex])[0];
  // assert(calculatedNullifier == nullifier);
  
  // Step 2: Verify if the subtree is valid.
  let subTreeCalculatedRoot: Field = verify_tree(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, subTreeLeafIndex, subTreePath, subTreeRoot);

  // Step 3: Verify if the main tree is now valid
  // assert(verify_tree(subTreeCalculatedRoot, depositTreeIndex, depositTreePath, depositTreeRoot) == depositTreeRoot);

}

fn verify_tree(leafValue: Field, index: Field, treePath: [Field; 3], treeRoot: Field) -> Field {
  let merkle_root = std::merkle::compute_merkle_root(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 0, treePath);
  assert(merkle_root == treeRoot);
  merkle_root
}

fn doit(root: Field) {
  let pathElements: [Field; 4] = [
  0x18d85f3de6dcd78b6ffbf5d8374433a5528d8e3bf2100df0b7bb43a4c59ebd63,
  0x06fd146950e6d7bad88f6ce0d22eaf9544832b3d17158ec62f32cbaf3ae59ecd,
  0x17dba07b1f54e623fce562e728c07be7e02e1fe66e9fd5df2e9e231eaa03c9c3,
  0x1d140f891daded13a72450fbf94b3618815c6b931ffe4dec89d4b0588a44e02e
];
  let merkle_root = std::merkle::compute_merkle_root(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92264, 8, pathElements);
  std::println(merkle_root);
  assert(merkle_root == root);
}

#[test]
fn test_main() {
  doit(0x08e409b71b9c9cf6456f5abf1a0a717cf0a3249c7cfa98ccfffccdac461afad1);
}

