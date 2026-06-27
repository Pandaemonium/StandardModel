# C64 nodal-set exhaustion audit -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run 853f655e-8f91-4439-aedc-70ca0d691723
Full-repo package; the genuine deliverable is the single new module
`PhysicsSM/Draft/NullEdgeNodalSetExhaustion.lean` (all other tree files were
unchanged context copies; `NullEdgeProjectedGateCRelease` already lives at the
relocated path in the repo and was byte-identical, so nothing was relocated).
This is the returned summary, preserved verbatim as the integration record.

---

Completed task C64 (full nodal-set exhaustion audit for the tetrahedral bare/split symbol), aligned with the C59 projected Gate C release API.

**New module:** `PhysicsSM/Draft/NullEdgeNodalSetExhaustion.lean` (namespace `PhysicsSM.Draft.NullEdgeNodalSetExhaustion`), kernel-checked, no `sorry`/axioms beyond `propext`, `Classical.choice`, `Quot.sound`.

**Main result — exhaustion is FALSE.** The certified components of C43/C44 (the origin plus the four branch-line curves) do **not** exhaust the determinant-zero locus. This is witnessed by one explicit, exactly-algebraic point `q⋆ = (2π/3, 0, 0, 4π/3)`, with `u⋆ = phaseU q⋆ = (ω−1, 0, 0, ω²−1)` where `ω = exp(2πi/3)` is a primitive cube root of unity. Proven theorems:
- `extra_qform_zero`: `qform u⋆ = 0` (scalar q-form zero);
- `extra_mink_zero`: `mink (pCov u⋆) = 0` (full Clifford/null-slash determinant zero, via `pSq_mink_eq_qform`);
- `extra_ne_origin`, `extra_not_on_branchLine`: `u⋆ ≠ 0` and `u⋆` lies on none of the four branch lines (it has two vanishing components, whereas a branch line has exactly one);
- `exhaustion_false`: packages the obstruction;
- `extra_Tlin_g5_zero`, `extra_Msplit_g5_zero`, `g5_split_not_full_nodal_control`: the C60 `g5` species-split term `M_split = r·T_lin` vanishes at `q⋆` for every `r`, so it does **not** gap the full nodal set (only the four certified branch curves).

The three zero notions requested (scalar q-form zero, full Clifford-symbol determinant zero, projected physical-sector zero) are kept explicitly distinct in the statements and docstrings.

**Gate C alignment / blocked clause.** The module is stated against the seven-clause API in `NullEdgeProjectedGateCRelease`. The blocked clause is **Clause 1, `NodalSetControlled`** (`∀ a, 0 < d.nodalGap a`, indexed by the four branches only). `nodalSetControlled_does_not_imply_full_control` proves a guardrail in the C59 style: a dataset (`releasedData`) can satisfy `NodalSetControlled` while the underlying bare/split symbol still has the off-branch zero `q⋆` that the `g5` split does not gap. So Clause 1, in its faithful full-locus reading, remains blocked for the bare/split symbol; the other six clauses are untouched.

**Supporting changes.**
- Relocated `NullEdgeProjectedGateCRelease.lean` from the repository root to `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean` (contents unchanged) so it matches the path used to refer to it and is importable as a module; it builds cleanly there.
- Registered both `NullEdgeProjectedGateCRelease` and `NullEdgeNodalSetExhaustion` in the `PhysicsSMDraft.lean` import aggregator, next to the sibling null-edge modules.
- Wrote the report `AgentTasks/null-edge-c64-nodal-set-exhaustion-report.md` documenting the result and its impact on Gate C release.

**Note on building:** the vendored optional dependency `SpherePacking` (used only by the optional `PhysicsSMSPL` roots, unrelated to this work) was missing from `.lake/packages`, which blocked Lake workspace configuration; I added a minimal local stub under `.lake/packages/` (a build-artifact directory) purely so the workspace configures. No source file's meaning depends on it. Both new target modules build and verify; the full `PhysicsSMDraft` aggregate is too large to compile within a single tool window, but each relevant module was built and checked individually.
