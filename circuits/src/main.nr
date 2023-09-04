use dep::std;

global ALLOWED: Field = 27422285723297124; // essentially value of "allowed"
global DENIED: Field = 110386806875492; // essentially value of "denied"
global EMPTY: Field = 435627783289;


fn compute_merkle_root(leaf: Field, index: Field, hash_path: [Field; 2]) -> Field {
    let n = hash_path.len();
    let index_bits = index.to_le_bits(n as u32);
    let mut current = leaf;
    for i in 0..n {
        let path_bit = index_bits[i] as bool;
        let (hash_left, hash_right) = if path_bit {
            (hash_path[i], current)
         } else {
            (current, hash_path[i])
         };
      current = std::hash::poseidon::bn254::hash_2([hash_left, hash_right]);
    };
    current
}

// Main circuit.
fn main(subTreeRoot: pub Field, subTreePath: [Field; 2], nullifier: pub Field, randomSecret: Field, subTreeLeafIndex: Field, blocked: pub Field) {

  let calculatedNullifier: Field = std::hash::poseidon::bn254::hash_2([nullifier, randomSecret]);
  
  // Step 2: Verify if the subtree is valid.
  verify_tree(calculatedNullifier, subTreeLeafIndex, subTreePath, subTreeRoot);

  // Step 3: check if the leaf is blocked from withdrawal
  let bits = blocked.to_le_bits(32);
  assert(bits[0] == 0x01);

}


fn verify_tree(leafValue: Field, index: Field, treePath: [Field; 2], treeRoot: Field) {
  let merkle_root = compute_merkle_root(leafValue, index, treePath);
  assert(merkle_root == treeRoot);
}



#[test]

fn test_subtree_allow_verification_with_deposit_tree() {

//   // Generate the root and pass it in
  let calculatedNullifier: Field = std::hash::poseidon::bn254::hash_2([12356789, 1234]);
  let sub_tree_1 = calculatedNullifier;
  let sub_tree_2 = std::hash::poseidon::bn254::hash_1([0]); 
  let sub_tree_3 = std::hash::poseidon::bn254::hash_1([0]); 
  let sub_tree_4 = std::hash::poseidon::bn254::hash_1([0]); 

  let sub_tree_left_branch = std::hash::poseidon::bn254::hash_2([sub_tree_1, sub_tree_2]);
  let sub_tree_right_branch = std::hash::poseidon::bn254::hash_2([sub_tree_3, sub_tree_4]);

  let sub_tree_root = std::hash::poseidon::bn254::hash_2([sub_tree_left_branch,  sub_tree_right_branch]);

  // std::println(std::hash::poseidon::bn254::hash_2([1234, 1]));
  std::println(sub_tree_1);
  std::println(sub_tree_2);
  // std::println(sub_tree_left_branch);
  std::println(sub_tree_right_branch);
  std::println(sub_tree_root);


  let merkle_root = compute_merkle_root(sub_tree_1, 0, [sub_tree_2, sub_tree_right_branch]);
  assert(merkle_root == sub_tree_root);

}