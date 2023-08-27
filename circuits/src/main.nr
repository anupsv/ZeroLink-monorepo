use dep::std;

global DEPTH: Field = 4;

/// Get a 32 byte slice from the flattened bytes.
fn get_node(nodes: [u8; 32 * DEPTH], index: Field) -> [u8; 32] {
  let mut out: [u8; 32] = [0; 32];

  for i in 0..32 {
    out[i] = nodes[i + index * 32];
  }

  out
}

fn compute_merkle_root<N>(leaf: Field, index: Field, hash_path: [Field; N]) -> Field {
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

/// Main circuit.
fn main(
  receiver: pub Field,
  key: Field,
  nullifier: pub Field,
  secret: Field,
  nodes: [Field; 2],
  root: pub Field,
) {
  // Compute `leaf` using `nullifier` and `secret`.
  let leaf: Field = std::hash::poseidon::bn254::hash_2([nullifier, secret]);

  // Ensure `leaf` is included in the merkle tree.
  
  assert(compute_merkle_root(leaf, key, nodes) == root);

  // Tie `receiver` into proof.
  // TODO: Is this safe enough?
  // assert(receiver != 0);
}

#[test]
fn test_compute_merkle_root() {
  
//   // Generate the root and pass it in
  let sub_tree_1 = std::hash::poseidon::bn254::hash_2([1234,1234]);
  let sub_tree_2 = std::hash::poseidon::bn254::hash_1([0]);
  let sub_tree_3 = std::hash::poseidon::bn254::hash_1([0]);
  let sub_tree_4 = std::hash::poseidon::bn254::hash_1([0]);

  let sub_tree_left_branch = std::hash::poseidon::bn254::hash_2([sub_tree_1, sub_tree_2]);
  let sub_tree_right_branch = std::hash::poseidon::bn254::hash_2([sub_tree_3, sub_tree_4]);

  let sub_tree_root = std::hash::poseidon::bn254::hash_2([sub_tree_left_branch,  sub_tree_right_branch]);
  

  std::println(compute_merkle_root(sub_tree_1, 0, [sub_tree_2, sub_tree_right_branch]));
  std::println(sub_tree_root);

}