# Summary of changes for run cb0b79f1-a98b-4110-b999-b5a65722eef9
Created `CovarianceGroupFull.lean` giving the COMPLETE covariance-group description of the derived mass-operator family `{B z = !![0, z; conj z, 0]}`, addressing the red-team note that the full covariance group is BOTH cosets (not just the diagonal chiral-phase branch of the original `covariance_group_eq_chiralPhase`).

The file builds with no `sorry` and uses only the standard axioms (`propext`, `Classical.choice`, `Quot.sound`); it is the default build target. Definitions (`massOperator`, `chiralPhase`, `IsDiagonal`, `IsAntidiagonal`) and the classification lemmas (`classification`, `orientation_preserving`, `orientation_flip`, `covariance_group_eq_chiralPhase`) are copied verbatim from `context/MassCovarianceForcing.lean`.

Main deliverable — `covariance_group_full`: a 2×2 unitary `W` is covariant for `{B z}` (i.e. `W*Wᴴ = 1` and admits spectral images at the two probes `z = 1, i`, packaged as the predicate `Covariant`) **iff** `W` has one of two explicit shapes:
- (a) diagonal `W = λ • chiralPhase u` with `‖λ‖ = ‖u‖ = 1` — the orientation-preserving chiral-phase circle mod global phase; or
- (b) antidiagonal `W = λ • chiralFlip u` (with `chiralFlip u = !![0,u;1,0]`) and `‖λ‖ = ‖u‖ = 1` — the orientation-flip coset.

Both branches are proved genuinely covariant (`chiralPhase_shape_covariant`, `chiralFlip_shape_covariant`), so the full group is the union of the two cosets, not just the diagonal one.

Group / coset structure (all proved):
- `covariant_one`, `covariant_conjTranspose` (closure under inverse, since `Wᴴ = W⁻¹` for unitaries), `covariant_mul` (closure under multiplication) — the covariant unitaries form a group.
- `covariant_disjoint_shapes` — no unitary is simultaneously diagonal and antidiagonal (a matrix that is both is the zero matrix, excluded by unitarity), so the diagonal circle is a proper index-2 subgroup and the antidiagonal set is its genuinely disjoint nontrivial coset.
- `chiralFlip_sq` — `(chiralFlip u)^2 = u • 1` is diagonal, witnessing that the flip squared lands back in the diagonal subgroup.

Supporting lemmas: `diagonal_unitary_entries`, `antidiagonal_unitary_entries` (unimodular entries), and `diagonal_shape`/`antidiagonal_shape` (the two explicit-shape normal forms). All results are elementary 2×2 complex-matrix algebra.
