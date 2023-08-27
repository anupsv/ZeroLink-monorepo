use dep::std;

global ALLOWED: Field = 27422285723297124; // essentially value of "allowed"
global DENIED: Field = 110386806875492; // essentially value of "denied"
global EMPTY: Field = 435627783289;


// Change 12345 hash to value of "allowed"


// Main circuit.
fn main(subTreeRoot: Field, subTreePath: [Field; 2], nullifier: Field, randomSecret: Field, subTreeLeafIndex: Field, 
depositTreeIndex: Field, depositTreePath: [Field; 2], depositTreeRoot: Field) {

  // Step 1 verify the nullifier and secret
  let calculatedNullifier: Field = std::hash::pedersen([randomSecret, subTreeLeafIndex])[0];
  assert(calculatedNullifier == nullifier);
  
  // Step 2: Verify if the subtree is valid.
  let subTreeCalculatedRoot: Field = verify_tree(std::hash::pedersen([ALLOWED])[0], subTreeLeafIndex, subTreePath, subTreeRoot);

  // Step 3: Verify if the main tree is now valid
  verify_tree(subTreeCalculatedRoot, depositTreeIndex, depositTreePath, depositTreeRoot);

}


fn verify_tree(leafValue: Field, index: Field, treePath: [Field; 2], treeRoot: Field) -> Field {
  let merkle_root = std::merkle::compute_merkle_root(leafValue, index, treePath);
  assert(merkle_root == treeRoot);
  merkle_root
}



#[test]

fn test_subtree_allow_verification_with_deposit_tree() {

//   // Generate the root and pass it in
//   let sub_tree_1 = std::hash::poseidon::bn254::hash_1([110386806875492]); // denied deposit
//   let sub_tree_2 = std::hash::poseidon::bn254::hash_1([27422285723297124]); // allowed deposit
//   let sub_tree_3 = std::hash::poseidon::bn254::hash_1([110386806875492]); // denied deposit
//   let sub_tree_4 = std::hash::poseidon::bn254::hash_1([110386806875492]); // denied deposit

//   let sub_tree_left_branch = std::hash::poseidon::bn254::hash_2([sub_tree_1, sub_tree_2]);
//   let sub_tree_right_branch = std::hash::poseidon::bn254::hash_2([sub_tree_3, sub_tree_4]);

//   let sub_tree_root = std::hash::poseidon::bn254::hash_2([sub_tree_left_branch,  sub_tree_right_branch]);

  std::println(std::hash::poseidon::bn254::hash_2([1,1]));
  assert(217234377348884654691879377518794323857294947151490278790710809376325639809 == 217234377348884654691879377518794323857294947151490278790710809376325639809);


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