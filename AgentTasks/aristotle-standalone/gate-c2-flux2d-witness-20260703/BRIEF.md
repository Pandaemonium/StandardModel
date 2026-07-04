# Gate C2: the 2D Wilson-Dirac zero-to-nonzero flux index - ROUND 2

Round 1 (a prior Aristotle pass on this exact project) closed 20 of 26
sorry-marked obligations in
PhysicsSM/Draft/NullEdge/GateC2/FluxOverlapIndex2D.lean and correctly
identified, via a kernel-checked counterexample, that the remaining two
block-diagonalization theorems were FALSE as stated due to a convention bug
in the TxFlux/TxFree/Ty shift definitions (the `+1` was on the wrong
Matrix.of argument, building the transpose of the intended shift operator).

That bug is now FIXED in this file (see the module docstring's "Round 1
result and the fix" section for the exact diagnosis) and independently
verified by exact computer algebra to reproduce the literal BFlux/BFree
data to the entry. The 20 previously-proven theorems are unaffected (still
present, still proved, do not touch them) and the two now-moot falsity
witness theorems from round 1 have been removed.

Please complete the remaining 6 sorry-marked declarations: two
block-diagonalization theorems (`HFlux_block_diagonalization`,
`HFree_block_diagonalization` - now believed TRUE; use the same
DFT-orthogonality mechanism as the already-proved `Ufour_unitary` and the
already-proved general helper `triple_entry`, both still present in the
file), two `Invertible` instances, and two capstone theorems
(`overlapIndex_flux2D = 4`, `overlapIndex_free2D = 0`) via the Section 5/6
assembly notes in the module docstring (combine the block-diagonalization
identity with the 8 already-proved block congruences into one combined
congruence via `HermitianSylvester.congruence_preserves_inertia`, then
apply the already-imported `gaugeOverlap_index_eigenvalue_count_form`).
Do not change any other statement. Start with
`lake env lean PhysicsSM/Draft/NullEdge/GateC2/FluxOverlapIndex2D.lean` (not
a full lake build). This remains a large, ambitious target; a partial
result closing some of the 6 while leaving others with a documented reason
is a valuable and acceptable outcome. Do not weaken any theorem statement;
if a statement appears false, STOP and report rather than adjusting it.
Deliverables for each sorry closed: no sorry, no native_decide, axiom
footprint [propext, Classical.choice, Quot.sound].
