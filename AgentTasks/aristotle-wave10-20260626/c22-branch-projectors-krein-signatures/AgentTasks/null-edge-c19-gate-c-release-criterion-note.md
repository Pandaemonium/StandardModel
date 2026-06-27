# C19 Gate C release criterion — semantic-alignment note and blocker report

Date: 2026-06-26
Deliverable: new module `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean`
(kernel-clean, axioms `propext, Classical.choice, Quot.sound` only).

## Verdict

**Gate C: PENDING (not RELEASED).** The flavored-chirality / taste signs are now
proved to be *forced up to a global sign* by any ±1 operator branch-chirality
assignment, but the identification of that branch chirality with `g5` (the
spacetime-chirality eigenvalue per branch) is the single remaining operator-level
theorem and is **not** discharged here. Per the §23.6 / §25.3 protocol the
one-line verdict is `PENDING on OperatorForcesAlignment`.

We deliberately do **not** claim release: the signs are not assigned by hand, but
their pinning to `g5` is still an open operator obligation rather than a proved
operator fact in the current files.

## 1. Actual branch/taste data available in Lean

- The four high-momentum null branches are the `{0,π}^4` corners with exactly
  three `π` edges, classified in
  `PhysicsSM.Draft.TetrahedralNullBranch` (`threePi_null`,
  `count_highMomentumNull = 4`, Lorentzian `pSq_mink_eq_qform`).
- The finite five-grading model (`GammaS`, `tasteT`/`tau`, `GammaF`, `chiE`,
  `kdParity`, `kreinJ`), the null projector `Pnull`, and the naive/flavored index
  witnesses (`naive_index_zero`, `flavored_index_eq_four`) live in
  `PhysicsSM.Draft.NullEdgeFlavoredChirality`.
- Crucially, the only operator data present in the Lean files at branch level is
  the **scalar** quadratic form `qform` and its null corners. There is no
  Clifford symbol `c(p(q))`, no per-branch kernel, and no per-branch
  chirality/Krein eigenvalue in the current files. This is the gap that keeps
  Gate C at PENDING.

## 2. Release-criterion theorem

The minimally-doubled flavored chirality of §25.3,
`Γ_flav = Σ_ρ ε_ρ · P_ρ Γ_s P_ρ`, is built from an **abstract operator-sign**
vector `s : Fin 4 → ℝ` (`s a = ε_a`) via `GammaFlavOp`. Its index reduces to a
closed form depending only on the operator signs:

- `flavoredOp_index : (GammaFlavOp s * Pnull).trace = ∑ a, s a * g5 a`.
- `Pnull_eq_sum_Pbranch : Pnull = ∑ a, Pbranch a` (the four per-branch projectors).
- `Pbranch_GammaS_Pbranch : Pbranch a * GammaS * Pbranch a = g5 a • Pbranch a`.

The release criterion is `Releases s := (GammaS*Pnull).trace = 0 ∧
(GammaFlavOp s * Pnull).trace ≠ 0`.

## 3. Conditional release + forcing

- `OperatorForcesAlignment (bc) := bc = g5` — the *exact* residual operator
  obligation (branch chirality = spacetime chirality `g5` per branch).
- `gateC_conditional_release : OperatorForcesAlignment bc → Releases bc` —
  conditional release theorem (naive index `0`, flavored index `4 ≠ 0`).
- `aligned_index_eq_four : (GammaFlavOp g5 * Pnull).trace = 4`.
- **Forcing / uniqueness** (the heart of C19, why the signs are *not* a free
  choice): for ±1 operator signs,
  - `aligned_signs_forced : trace = 4 ↔ s = g5`,
  - `antialigned_signs_forced : trace = -4 ↔ s = -g5`,
  - `flavoredOp_index_le_four : |trace| ≤ 4`.
  Hence a *maximal/coherent* release forces `s = ±g5`.
- `model_taste_eq_chirality : tau = g5` and `model_realizes_alignment` show the
  Wave-8 hand-model is exactly the `s = g5` instance of this forced family — the
  earlier sign choice was the operator-aligned one, not an arbitrary input.
- `gateC_release_conditional_summary` bundles sufficiency + forcing.

## 4. Precise no-build blocker (what discharges PENDING)

To upgrade `PENDING → RELEASED`, a future operator-level module must supply a
Lean proof of `OperatorForcesAlignment branchChirality`, i.e. that the actual
flat tetrahedral retarded dual-soldered null-edge Clifford symbol `c(p(q))`
assigns spacetime-chirality eigenvalue `g5 a` (a definite ±1) to the zero mode on
branch `a`. Concretely the missing Lean targets are:

1. the Clifford symbol `c : (Fin 4 → ℂ) → Matrix _ _ ℂ` (mostly-minus gamma
   matrices) with `c(p)^2 = (mink p) • 1` on the null corners;
2. the per-branch kernel `ker (c (pCov (cornerU (tasteCorner a))))` and a proof
   it is one-dimensional (or its chirality-graded multiplicity is `±1`);
3. the chirality eigenvalue `Γ_s` restricted to that kernel equals `g5 a`
   (this is the BCK/minimally-doubled alignment), and/or the Krein `J`-signature
   matching it.

Given (1)–(3), `gateC_conditional_release` closes Gate C and
`aligned_signs_forced` certifies the signs were forced, not chosen.

## Convention / axiom notes

- Mostly-minus signature, tetrahedral inverse Gram `G⁻¹ = -3/4·I + 1/4·J`
  (`docs/CONVENTIONS.md`), reused via `TetrahedralNullBranch`.
- All new theorems depend only on `propext, Classical.choice, Quot.sound`.
- No statements were weakened; the open part is isolated in the explicit
  hypothesis `OperatorForcesAlignment` rather than hidden.
