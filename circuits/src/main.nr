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

  // Step 1 verify the nullifier and secret
  let calculatedNullifier: Field = std::hash::poseidon::bn254::hash_2([randomSecret, subTreeLeafIndex]);
  assert(calculatedNullifier == nullifier);
  
  // Step 2: Verify if the subtree is valid.
  verify_tree(std::hash::poseidon::bn254::hash_2([nullifier, 1]), subTreeLeafIndex, subTreePath, subTreeRoot);

  // Step 3: check if the leaf is blocked from withdrawal
  // assert(((blocked as u32) & (1 << (subTreeLeafIndex as u32))) == 0x01);

}


fn verify_tree(leafValue: Field, index: Field, treePath: [Field; 2], treeRoot: Field) {
  let merkle_root = compute_merkle_root(leafValue, index, treePath);
  assert(merkle_root == treeRoot);
}



#[test]

fn test_subtree_allow_verification_with_deposit_tree() {

//   // Generate the root and pass it in
  let calculatedNullifier: Field = std::hash::poseidon::bn254::hash_2([1234, 0]);
  let sub_tree_1 = std::hash::poseidon::bn254::hash_2([calculatedNullifier, 1]);
  let sub_tree_2 = std::hash::poseidon::bn254::hash_1([0]); 
  let sub_tree_3 = std::hash::poseidon::bn254::hash_1([0]); 
  let sub_tree_4 = std::hash::poseidon::bn254::hash_1([0]); 

  let sub_tree_left_branch = std::hash::poseidon::bn254::hash_2([sub_tree_1, sub_tree_2]);
  let sub_tree_right_branch = std::hash::poseidon::bn254::hash_2([sub_tree_3, sub_tree_4]);

  let sub_tree_root = std::hash::poseidon::bn254::hash_2([sub_tree_left_branch,  sub_tree_right_branch]);

  // std::println(std::hash::poseidon::bn254::hash_2([1234, 1]));
  std::println(sub_tree_1);
  std::println(sub_tree_2);
  std::println(sub_tree_left_branch);
  std::println(sub_tree_right_branch);
  std::println(sub_tree_root);
  let x :Field = 268435455268435455;

  std::println(x as u64 & 0xff);

//   // // Now the main tree
//   // let main_tree_1 = std::hash::pedersen([110386806875492])[0]; // some other deposit
//   // let main_tree_2 = std::hash::pedersen([110386806875492])[0]; // some other deposit
//   // let main_tree_3 = sub_tree_root; // concerned subtree deposit
//   // let main_tree_4 = std::hash::pedersen([110386806875492])[0]; // some other deposit

//   // let main_tree_left_branch = std::hash::pedersen([main_tree_1, main_tree_2])[0];
//   // let main_tree_right_branch = std::hash::pedersen([main_tree_3, main_tree_4])[0];

//   // let main_tree_root = std::hash::pedersen([main_tree_left_branch,  main_tree_right_branch])[0];

//   // main(sub_tree_root, [sub_tree_1, sub_tree_right_branch], std::hash::pedersen([5, 1])[0], 5, 1, 2, [main_tree_4, main_tree_left_branch], main_tree_root);
}