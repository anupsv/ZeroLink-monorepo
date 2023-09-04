# We need this because foundry `ffi`
# does not allow chaining commands.
cd circuits/CommitmentProver && nargo prove -p "$1"
