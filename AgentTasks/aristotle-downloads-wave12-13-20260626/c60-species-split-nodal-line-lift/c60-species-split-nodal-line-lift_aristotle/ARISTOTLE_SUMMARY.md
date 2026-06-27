# Summary of changes for run ea86e1cb-8ff3-4337-89af-e724c9c7c7ea
Delivered `PhysicsSM/Draft/NullEdgeSpeciesSplitNodalLine.lean` (C60), a self-contained Lean module (no `sorry`; only the standard `propext`/`Classical.choice`/`Quot.sound` axioms) that proves the species-splitting lift of the exact high-branch nodal curves exposed by C43/C44.

Method/context. I inspected the nodal-set and species-splitting modules. Note: the sibling files `NullEdgeSpectralGraphNodalSet.lean` and `NullEdgeActualCliffordSymbol.lean` do not compile in this project because they import modules (`TetrahedralHighMomentumNullBranch`, `NullEdgeFlavoredChirality`) that are absent. So, following the standalone pattern of `NullEdgeSymmetryForcedSpeciesSplit.lean`, the new module imports only Mathlib and self-containedly reconstructs the minimal nodal-curve machinery (`phaseU`, `qform`, `branchLinePhase`/`branchLineU`, the high `cornerPhase`).

Definitions added. The linear taste function `Tlin s q = ½ Σ_a s_a cos qₐ` (working plan §29.5), the modeled species-splitting term `Msplit r s q = r · Tlin s q`, the tracelessness condition `Traceless s := Σ_a s_a = 0`, and the literature pattern `g5 = (+,+,−,−)`.

Theorems proved.
- `branchLine_qform_zero`: the bare scalar determinant zero `qform u = 0` persists on the whole branch line for all `t` (C43/C44, reproved here) — the splitting does not touch this scalar channel.
- `Tlin_corner`: for traceless `s`, `T_lin` on the high corner `q^(a)` equals the branch sign `s_a`.
- `Tlin_branchLine`: along branch `a`'s exact line, `T_lin = s_a·(1 + cos t)/2`.
- `Tlin_origin`: at the origin endpoint `t = π`, `T_lin = 0` (origin unlifted).
- The lift theorem, as `Msplit_branchLine` (`= r·s_a·(1+cos t)/2`), `Msplit_high_corner_ne_zero` (value `r·s_a ≠ 0` at the high corner `t = 0`), `Msplit_origin_zero` (zero at `t = π`), and `Msplit_branchLine_zero_iff` (for nonzero `r`, `s_a`, the only zeros on the line are at `cos t = −1`, i.e. the origin endpoint).
- `g5_traceless` and `g5_split_lifts_high_branch`: the `(+,+,−,−)` pattern is traceless and realises the lift for every branch and any nonzero `r`.
- `species_split_lift_summary`: packaged statement.

Explicit scope (in the module docstring). What is lifted: the modeled species/taste mass channel `M_split = r·T_lin`, shown nonzero along the high nodal line away from the origin (a modeled branch-taste degeneracy split). What is NOT claimed: the bare scalar determinant zero is unchanged (separate channel), and there is no claim of physical ghost safety, propagator positivity, or Krein/causality control (those require the §29.6 cost-ledger audit, out of scope). Moduli verdict carried over from C45/C46: the coefficient `r` remains a free real modulus — any nonzero `r` realises the lift and none is symmetry-distinguished — so this is reconstruction/branch control, not a magnitude prediction.

The lift theorem is true and well-specified as formalized, so no no-go report was needed. The new file builds cleanly with no warnings; the rest of the project's pre-existing build breakage (missing imported modules) is unrelated and was left untouched.
