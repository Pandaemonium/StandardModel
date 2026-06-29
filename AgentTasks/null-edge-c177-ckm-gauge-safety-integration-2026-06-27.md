# Summary of changes for run d8c49785-cd99-4cc4-87c4-82789bb91546
Stated and proved the Gate C1 CKM branch-mass gauge-safety theorem and its no-go failure mode in `RequestProject/Main.lean` (builds cleanly, no proof placeholders, kernel dependencies limited to `propext`/`Quot.sound`).

Model: the total finite space is `Branch ⊗[R] Internal`. SM gauge generators are *internal* blocks `internalOp g = id_Branch ⊗ g` (`g.lTensor Branch`); branch masses are `branchOp b = b ⊗ id_Internal` (`b.rTensor Internal`).

Key results:
- `branchOp_comp_internalOp` / `branchOp_commute_internalOp`: a branch operator and an internal SM operator always commute (both equal `b ⊗ g`). This is the minimal commutation fact.
- `SMActsInternally gens`: the gauge-safety hypothesis — every generator has internal block form `id_Branch ⊗ g`. `GaugeSafe W gens`: `W` commutes with all generators.
- `gauge_safety_of_SMActsInternally`: if the SM acts internally and the mass is any branch operator, it is gauge-safe.
- `W_branchCKM` encodes the candidate `W_branch⁽¹⁾ = r • (15 • R − M_CKM)` as a branch operator; `W_branchCKM_eq` confirms it equals `r • (15 • branchOp R − branchOp M_CKM)`; `W_branchCKM_gaugeSafe` certifies its gauge safety under `SMActsInternally`.
- No-go: `gaugeSafe_no_go` shows a single non-commuting (branch-mixing) generator already destroys safety, and `branch_mixing_noncommute_witness` gives a concrete 2×2 branch-mixing block not commuting with a diagonal branch mass, proving the no-go hypothesis is satisfiable (non-vacuous). The accompanying docstring records that an explicit gauge dressing would be needed to restore safety in that case.
- C159 feed: `CKMGaugeSafetyCertificate` bundles the generators, mass, the `SMActsInternally` audit input and the exported `GaugeSafe` output; `of_internal` and `ckm` build the import-ready certificate (the latter specialised to the CKM candidate).

The file docstring contains the minimal assumptions for commutation, the Furey/Hughes/SM-embedding audit checklist (factorisation, per-generator internality, branch operators staying on the branch factor, hypercharge normalisation, anomalous branch-mixing search), the explicit failure/no-go condition, and the note on how `SMActsInternally` feeds the C159 import certificate. Safety is formulated strictly as an audit hypothesis — the real SM embedding is not assumed to satisfy it automatically.
