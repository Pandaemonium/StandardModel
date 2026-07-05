# Q6 `pairSum_le_expBound` DAG progress

Session 2026-07-05. Aristotle project
`7c0ed511-8438-47c6-94a4-c46da94468e7`, task
`ef1a738b-fb69-4576-afa9-2e2fbd4d7df8`, completed and was harvested locally.

## Outcome

The main Q6 crux `pairSum_le_expBound` is not closed. Its statement remains
unchanged and still carries the existing draft proof placeholder. The older
downstream handoffs `kp_convergence_bound_of_selfIncompatible` and
`kp_tail_bound` are untouched.

Three locally verified helper lemmas from the planned proof DAG were integrated
in `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`:

- `exists_canonical_root`: a cluster touching `g` has a least slot carrying
  `g`. This supplies the canonical root for the future deletion argument.
- `rhs_forest_expand`: expands the RHS partial exponential into ordered child
  tuples using `Finset.sum_pow'`. This is the ordered-forest shape expected
  after deleting the canonical root.
- `factorial_mul_prod_factorial_le`: proves the arithmetic normalization
  `k! * prod_j m_j! <= (1 + sum_j m_j)!` for positive child-block sizes.
  This supplies the factorial comparison needed after a future geometric
  fiber-count theorem supplies the block decomposition.

The follow-up helper `tree_root_child_mem_nbhd` is also now integrated.  It
proves that if a spanning-tree subgraph edge leaves a slot carrying the root
polymer `g`, then the adjacent child slot's polymer lies in `nbhd S hdec g`.
This discharges the immediate root-neighbor membership fact needed by the
future canonical-root deletion argument.

The follow-up object `treeRootChildren` is also integrated.  It packages the
finite set of slots adjacent to the root in a tree subgraph, with checked
membership, loopless-root exclusion, and `treeRootChildren_poly_mem_nbhd`
showing every such child slot carries a polymer in `nbhd S hdec g`.
It also has `treeRootChildren_subset_erase` and
`treeRootChildren_card_add_one_le`, proving the children are non-root slots and
their arity is at most `n - 1`; this is the finite bound needed by the later
child-forest truncation.

## Remaining blocker

The remaining core is the geometric deletion and counting construction:

- define `rootDeletion` for a spanning tree rooted at the canonical `g` slot;
- split the deleted tree into connected blocks indexed from the
  `treeRootChildren` set, using the checked arity bound;
- reindex each block as a smaller ordered cluster;
- prove the corresponding subtree touches a neighbor of `g` beyond the
  immediate root-edge membership already supplied by `tree_root_child_mem_nbhd`;
- prove the block-level `absWeight` factorization;
- prove the geometric fiber-count bound that uses the multinomial
  normalization.

This is still finite labeled rooted-tree/species infrastructure, not an
analytic KP ambiguity and not a statement about physics.

## Verification

Local check passed after integrating the two helper lemmas:

```powershell
lake env lean PhysicsSM\Draft\NullEdge\GateYM\PolymerKPConclusion.lean
```

The check reported only the known Q6 draft proof-placeholder warnings in this
file.
