# E12 FMS finite composite (Gate E) -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run 0db9ede8-7231-4ec0-adc8-d3ab2ffef344
The focused package did not ship the standalone report file; this is the
returned summary, preserved verbatim as the integration record.

---

Delivered the E12 / Gate-E FMS finite composite target as a new kernel-checked Lean module.

## New module
`PhysicsSM/Draft/NullEdgeFMSFiniteComposite.lean` (382 lines, registered in `PhysicsSMDraft.lean`). Builds clean via `lake build PhysicsSM.Draft.NullEdgeFMSFiniteComposite` with **no `sorry`/`admit`/`axiom`/`@[implemented_by]`**; spot-checked theorems use only `propext, Classical.choice, Quot.sound`. It imports and reuses the existing electroweak stabilizer module (`NullEdgeElectroweakStabilizer`: `T₁..Y/2`, `rho`, `H0`, `Qgen`, `B_EW`, `B_EW_eq_matrix`, `ew_stabilizer_kernel`) rather than re-deriving that data.

## What it proves, mapped to the requested tasks
1. **Finite gauge-invariant Higgs-link functional** — `linkStiffnessEW = ∑_e ‖U_e H_{t(e)} − H_{s(e)}‖²` for a genuinely non-abelian (`U(2)`/`SU(2)`) matrix-valued connection on `ℂ²` doublets (the electroweak upgrade of the abelian link file), with exact gauge invariance `linkStiffnessEW_gauge_invariant` under `H_v ↦ g_v H_v`, `U_e ↦ g_{s(e)} U_e g_{t(e)}⁻¹` (unitary `g_v`); supported by `cnorm2_mulVec_of_unitary` / `cinner_mulVec_of_unitary`.
2. **Orbit-stiffness theorem** — holonomy level: `holonomyCost_eq_zero_iff_stabilizer` (zero cost ⇔ stabilises the Higgs reference section) and `holonomyCost_pos_of_not_stabilizer` (positive otherwise); Lie-algebra level: `massForm`, its closed form `massForm_eq = (v²/8)(x₀²+x₁²+(x₂−x₃)²)`, and `massForm_kernel` showing the zero set is `span ℝ {Q} = u(1)_em` (the unique massless/photon direction).
3. **Corrected FMS composite observable** — `fmsComposite = H_s^† τ^a U_e H_t`, with the gauge-invariant singlet variant (`τ = 1`) proved invariant (`fmsSinglet_gauge_invariant`).
4. **Toy expansion theorem (W/Z as leading term)** — for the linearised holonomy `U = 1 + iε ρ(X)`: `fms_leading_W` gives the `τ¹` matrix element `(v²/4)(x₀ − i x₁)` (the `W^∓` combination `A¹ ∓ i A²`), `fms_leading_Z` gives the `τ³` element `(v²/4)(x₂ − x₃)` (the `Z` combination `A³ − B`), and `fms_linear_expansion_W` assembles the full linear expansion whose vacuum constant vanishes, so the W field is the leading fluctuation. The orthogonal photon combination is absent, consistent with `massForm_kernel`.
5. **Separated coefficient normalisation** — `massForm_coupling_form`, `mW = gv/2`, `mZ = √(g²+g'²)v/2` (`mW_sq`, `mZ_sq`), and the bridge `massForm_physical_normalization` identifying the mass form with the canonical `½ m_W²(A¹²+A²²) + ½ m_Z² Z²`; these convention-dependent coefficients are isolated and not used by the structural Part-B theorems.

## Conventions / language guardrails
Hermitian generators, full Pauli `τ` matrices, "unitary" = `star M * M = 1`. No "local gauge-symmetry breaking" language: everything is phrased as gauge-invariant composites / stabilizer / orbit stiffness. The module docstring explicitly labels the result a gauge-invariant orbit-stiffness reconstruction with an explicit W/Z leading-term theorem — not a completed physical composite-spectrum (pole/two-point) theorem.

A semantic-alignment / acceptance note is saved at `AgentTasks/null-edge-fms-finite-composite-report-2026-06-26.md`, including next Lean targets.

Note (pre-existing, unrelated): the repo's `PhysicsSM.lean` root imports a missing `PhysicsSM/Prelude.lean`, so the full `PhysicsSM` library target does not build; the new module was built via its own module target and its dependency.
