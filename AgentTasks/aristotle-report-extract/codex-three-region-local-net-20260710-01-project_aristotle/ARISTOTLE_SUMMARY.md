# Summary of changes for run 1a0558b8-3848-4f3f-91b1-7161df5b42e2
All proofs in `ThreeRegionNet/Core.lean` are now complete; no definitions or statements were changed. `lake env lean ThreeRegionNet/Core.lean` compiles cleanly with no warnings and no `sorry`.

Proved:
- `left_middle_commute`, `left_right_commute`, `middle_right_commute`: exact pairwise commutation of the three supplied tensor factors (each acting nontrivially on a distinct qubit slot of the `Fin 2 × Fin 2 × Fin 2` fixture), via entrywise expansion of the Kronecker/matrix products.
- `overlapping_left_noncommutative`: retains the overlapping-region control by showing `σx` and `σz` on the same (left) factor fail to commute, derived from a concrete differing matrix entry.
- `three_region_locality_packet`: assembles the three commutations plus the overlapping non-commutation.

Verified axioms are only `propext`, `Classical.choice`, `Quot.sound`.

Scope note: the tensor factorization is taken as supplied; these results are exact commutation statements about that finite fixture and do not assert graph-derived separation, a continuum Haag–Kastler net, the split property, or Lorentzian locality.
