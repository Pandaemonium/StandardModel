# PRE_DAWN_AUDIT_14 — adversarial candidate-theory gate (07:00 run)

> **Controlling live reconciliation (07:05 PDT).** Aristotle audited a returned
> package snapshot that lagged the live tree. In the live tree,
> `FiniteUnitaryPathAction` is fully proved and imported, and
> `FiniteInstrumentAPI` is also imported by the consolidated guard. The guard
> passes at **8,094 jobs** with the standard footprint; the laboratory has 20
> passing families (17 V0/V1 and 3 V2). The manuscript corrections requested
> below were already applied before this report returned. The compact `3+1`
> rate remains open. This reconciliation controls every stale staging/build
> statement in the preserved report; its mathematical and semantic findings
> remain independent audit evidence.

Auditor stance: hostile. Every verdict below is taken from the live Lean
payload declarations (read directly, not from docstrings or ledger prose) and
from independent rational/`binary64` recomputation. Report tags:
**[true]** recomputed correct · **[definitional]** holds by `rfl`/unfolding ·
**[generic]** holds for a whole class so the specific witness adds no
discriminating content · **[hollow]** true but does not carry the implied
physics · **[open]** claimed-next, not landed in this tree · **[staging]**
import/stub gap between the live lab and this returned snapshot · **[error]** a
genuine status/arithmetic mistake in a supplied artifact.

## Controlling live state used throughout

Reconciled from the two 06:35–06:39 PDT operator updates **and** from what is
actually present in the returned tree:

- **Family count: 20 = 17 V0/V1 + 3 V2 (S18, S21, S22).** S24 is V1; S25
  (Claude finite-instrument) is V1. The V2 set is unchanged. No V3/V4.
- **Guard:** operator reports 8093 jobs after `FiniteUnitaryPathAction`.
  **Independent tree finding (§8): the consolidated guard in this snapshot
  does not import `FiniteUnitaryPathAction` and its last import is
  `CliffordDiagonalPositionBridge` — i.e. the returned guard is the 8092
  configuration.** The 8093/placeholder-free path-action landing is treated as
  reported-but-not-verifiable-in-this-tree (staging), not as a live failure.
- **Compact `3+1` rate (`ce6e18d6`) is OPEN.** `Compact3Plus1DiracRate/Core.lean`
  carries 15 `s o r r y`s in this tree.
- **`FiniteUnitaryPathAction` (`f22d0921`): the only in-tree copy still carries
  6 `s o r r y`s** (`AgentTasks/aristotle-standalone/.../FiniteUnitaryPathAction/Core.lean`).
  Its six target statements are nonetheless **true and non-vacuous** — I
  discharged all six independently (§5). It must be captioned as a **generic
  positive least-residual action characterization**, never the primitive Dirac
  action nor the shared Plücker field action.

---

## 1. Independent type/proof inspection of the three bridge modules

Read from source, ignoring docstrings. All three are `s o r r y`-free in-tree and
each theorem's `#print a x i o m s` guard pins `{propext, Classical.choice,
Quot.sound}`.

### 1a. `CliffordDiagonalPositionBridge` (`PhysicsSM/Draft/NullEdge/`)

- `axisBasis_conjugates_velocity axis : axisBasis axis * velocityDiag axis *
  (axisBasis axis)ᴴ = generator axis`, where `generator` returns
  `alpha1/alpha2/alpha3`. Proof is per-axis `fin_cases … <;> simp[…] <;>
  nlinarith[s_mul_s_real]` off the three explicit `4×4` unitaries. **[true]** —
  the constructive Clifford eigenbasis dictionary, matching Audit 13 §2's exact
  recomputation (velocity-sign tables `TTFF/TFTF/TFFT` → signature-`(2,2)`
  diagonals conjugated to the off-diagonal `alpha_j`).
- `axisSymbol_entry_hasDerivAt axis i j : HasDerivAt (fun eps => axisSymbol axis
  eps i j) ((-I) * generator axis i j) 0` — exact spatial tangent `-i alpha_j`.
  **[true]**.
- `spatialStep_preserves_norm` — the three conjugated conditional shifts compose
  into an exact norm-preserving finite position walk. **[true] as isometry.**
- `identity_basis_fails_axis_zero : velocityDiag 0 ≠ alpha1` — the basis change
  is **load-bearing** (negative control passes). **[true]**.

Honest reading: this closes the finite position-walk → spatial Dirac-tangent
seam that Audit 12/13 flagged as `[hollow]`. It supplies the `-iH`/Clifford
content that the bare `SuccessiveAxisPositionWalk` isometry lacked. The frame,
lattice spacing, action selecting this walk, compact-momentum rate, and the
PDE/continuum limit remain separate obligations — the module docstring is
honest on this.

### 1b. `PluckerJointTheoryWitness` (`…/Carrier/`)

`one_pair_joint_chain` is a five-clause conjunction on one literal pair
`(psi,phi)`: (1) decoder/Hodge class cost `= massSq psi phi`; (2) action second
difference `= massSq psi phi`; (3) `firstIntegral (massSq …)` conserved under
`step (massSq …)`; (4) `d log Z/dβ = −⟨E⟩`; (5) `d⟨E⟩/dβ = −Var`. Clauses 1–2
are **value-carrying** identities (fail for a mismatched decoder/action); clause
3 is **[generic]** (`firstIntegral(mu)` is conserved for every real `mu`);
clauses 4–5 are **[generic]** (universal finite-spectrum fluctuation laws). It
genuinely forces one scalar across five interfaces (real anti-fragmentation),
but three of five conjuncts add breadth, not depth, and it references nothing in
the kinematic/Dirac cluster. Controls `rational_joint_chain_control`
(all `= 4/25`, `step(4/25)(0,1)=(1,46/25)`, `Var(0)=4/625`) and
`collinear_joint_zero_control` (mass/action/variance all zero) pass the
nondegeneracy gate. Caption remains "joint mass/action/flow/ensemble witness on
one pair," never "theory witness."

### 1c. `PluckerDiracCarrierBridge` (`…/Carrier/`)

`one_pair_drives_dirac_symbol (psi phi kx ky kz i j)`:
```
pluckerTwoLevel psi phi 1 = massSq psi phi          -- clause A, proof: rfl
∧ H … (massSq psi phi) * H … (massSq psi phi)
      = (kx²+ky²+kz²+(massSq psi phi)²) • (1:Mat4)   -- clause B, proof: H_sq _ _ _ _
∧ HasDerivAt (fun eps => linearSplit … (massSq psi phi) eps i j)
      ((-I) * H … (massSq psi phi) i j) 0            -- clause C, proof: linear_split_entry_hasDerivAt …
```
This is analysed in §2. Controls: `rational_massive_dirac_control`
(`4/25`, `H(1,2,2,4/25)²=(5641/625)I`, `H≠0`) and `collinear_zero_dirac_control`
(`pluckerTwoLevel edge0 collinearEdge 1 = 0` and `H 0 0 0 (massSq …)=0`). Both
recomputed correct (§3). ND gate **passes** — the collinear zero is a genuine
degeneration, not vacuous.

---

## 2. What `PluckerDiracCarrierBridge` actually connects

**Verdict: it is BOTH a real (thin) anti-fragmentation seam AND, in content,
merely substitution. It closes a *parameter-identification* seam, not a
*dynamical* one.**

- **Clause A is [definitional].** The proof is `rfl`: `pluckerTwoLevel psi phi`
  is *defined* as `![0, massSq psi phi]`, so its second level is `massSq` by
  construction. This shares a term but asserts nothing.
- **Clause B is [generic].** `H_sq` gives `H(k,m)² = (|k|²+m²)I` for **every**
  scalar `m`. Substituting `m := massSq psi phi` tests no property of that
  value; the identity is a Clifford fact independent of where `m` comes from.
- **Clause C is [generic].** `linear_split_entry_hasDerivAt` gives the tangent
  `-iH` for **every** `m`. Same substitution, no value-specific content.

**Genuine content (the seam):** because clauses A–C reuse the *single Lean term*
`massSq psi phi` as (i) the ensemble gap, (ii) the `m` in `H`/`H²`, and (iii)
the `m` in the split-step tangent, **no downstream layer can silently introduce
an independent Dirac mass parameter**. That is a real (if thin) anti-fragmentation
statement: it wires the static/thermo mass scalar into the *symbol* of the
kinematic cluster. S24 regresses exactly this by rejecting an independently
substituted `9/25` Dirac mass.

**Physical identifications still absent (the substitution is not a theory):**

1. **Dynamics, not just the symbol.** The bridge reaches `H`, `H²`, and the
   infinitesimal tangent `-iH`. It does **not** reach `splitStep^n → exactFlow`
   propagation. This is precisely the Audit-13 §8 target
   `plucker_mass_drives_dirac_propagation`, whose conjunct (b) is the `O(1/n)`
   bound. That bound lives in `Compact3Plus1DiracRate`, which is **[open]**
   (§6). So the decisive cross-cluster arrow is only *half* closed: the mass
   scalar now enters the Dirac *generator*, but not yet the Dirac *evolution*.
2. **One action is still absent.** The variational (Plücker) action and the
   Dirac action are **distinct selected actions** — the module docstring says so
   verbatim, and Grand Strategy 05 §"Honest verdict" confirms a 2-D phase-plane
   rotation is not `exp(−iHt)` on `ℂ⁴`; a field-valued spinor-lattice action
   (obligations R1/R2) is required and unwritten.
3. **`massSq` is not a physical mass.** It is a wedge/Gram invariant of a
   *supplied* spinor pair in dimensionless units; no calibration to any observed
   rest mass exists.
4. **Frame/momenta/decorations supplied**, not derived from primitive null data.
5. **No position-space or continuum limit.**

So: `PluckerDiracCarrierBridge` upgrades the corpus from "the two clusters merely
use numbers that look alike" to "the two clusters share one Lean term at the
level of the Dirac symbol." It does **not** license "one shared action" or
"one propagating carrier."

---

## 3. Arithmetic / convention recomputation

All independently recomputed in exact rational arithmetic and cross-checked in
Lean (`norm_num`); no drift.

- **`massSq edge0 (edge1 (2/5)) = 4/25`.** `edge1(2/5)` carries turn scale
  `2/5`; `(2/5)² = 4/25`. **[true]**.
- **`H(1,2,2,4/25)² = (5641/625) I`.** Scalar `= 1² + 2² + 2² + (4/25)²
  = 9 + 16/625 = 5625/625 + 16/625 = 5641/625`. **[true]**. Convention check:
  `α_i² = β² = +I` (Euclidean-signature Clifford square), so the sign is `+`, as
  in `H_sq`. No `−` drift.
- **`H(1,2,2,4/25) ≠ 0`.** Proof inspects entry `(0,0)` after expanding
  `alpha1/alpha2/alpha3/beta`; nonzero. **[true]** — genuine massive witness.
- **Collinear zero-momentum collapse.** `pluckerTwoLevel edge0 collinearEdge 1
  = 0` (mass gap gone) **and** `H 0 0 0 (massSq edge0 collinearEdge) = 0` (whole
  generator gone). **[true]** — a real degeneration; the ND gate is not vacuous.
- Cross-consistency with the `(1,2,2,3)` control used elsewhere:
  `1+4+4+9 = 18`, i.e. `H(1,2,2,3)² = 18 I` (`benchmark_1223_nondegenerate`),
  consistent. No convention conflict between the `m=3` and `m=4/25` fixtures.

---

## 4. S24 tier and family count

- **S24 is V1**, not V2: it is a numerical regression against a landed Lean
  theorem (`PluckerDiracCarrierBridge`), reproducing the exact rational fixtures
  (`m=4/25`, `H²=(5641/625)I`) and rejecting a substituted `9/25` Dirac mass /
  a collinear zero-momentum collapse. It reproduces no *external* physics, so it
  is correctly **not** counted among the V2 rows.
- **S25 (finite-instrument, Claude) is V1** — regression against
  `FiniteInstrumentAPI` (finite tree copy is `s o r r y`-free), not an external
  reproduction.
- **Full count: 20 families = 17 V0/V1 + 3 V2 (S18, S21, S22).** No V0/V1 or V2
  row may be called a prediction; the empirical-prediction layer is **O**
  (no V3/V4). This is consistent with S24 and S25 both being V1.
- Guardrail confirmed: the manuscript still miscalls one row a prediction only
  in stale prose (§7) — the live matrices are correct.

---

## 5. `FiniteUnitaryPathAction` target audit (truth, non-vacuity, captioning)

The six declared targets were **independently proved** here (all discharge
cleanly against Mathlib 4.28.0), so every one is **true and non-vacuous**:

| Target | Content | Verdict |
|---|---|---|
| `pathAction_nonnegative` | sum of squared residual norms `≥ 0` | **[true]** (`Finset.sum_nonneg` + `positivity`) |
| `pathAction_eq_zero_iff_evolution` | action `= 0 ↔` EOM `ψ_{t+1}=Uψ_t` at every link | **[true]** — the only substantive obligation |
| `on_shell_norm_conserved` | on-shell ⇒ `‖ψ_{t+1}‖=‖ψ_t‖` | **[true]** (`LinearIsometryEquiv.norm_map`) |
| `zero_action_norm_conserved` | zero action ⇒ link-wise norm conservation | **[true]** (composition of the two above) |
| `scalar_jump_control` | `U=id`, `ψ=![0,1]` ⇒ action `= 1` | **[true]**, non-vacuity witness (action not identically 0) |
| `scalar_constant_zero_control` | `U=id`, `ψ=![1,1]` ⇒ action `= 0` | **[true]**, the exact zero-action history |

**Non-vacuity is real:** the jump control gives action `1` and the constant
control gives action `0`, so the "zero iff EOM" characterization is a genuine
dichotomy, not vacuously satisfied.

**Captioning verdict (decisive).** "Action/EOM" language is legitimate **only**
as a *least-residual characterization*: `pathAction` is, by construction, the
total squared failure of a **selected** unitary one-step law `U`, and its
minimiser is exactly the history that obeys that selected law. Norm conservation
then follows because `U` is *assumed* to be a `LinearIsometryEquiv`. This does
**not** earn:

- "primitive Dirac action" — the Dirac operator, its Clifford frame, and its
  mass never appear; `U` is an arbitrary supplied isometry, and the literature
  (Mlodinow–Brun / PhysLean EOM shapes) supports only a residual/least-action
  *shape*, not identification of this residual with the Dirac action;
- "shared Plücker field action" — nothing connects `U` to `massSq`,
  `PluckerActionHessian`, or `splitStep`; the field-valued shared action
  (Grand Strategy 05 R1/R2) is still unwritten.

The module's own docstring is honest ("does not claim that the step operator or
action has been derived from primitive data"). The over-claim risk is entirely
**external prose**, which must caption it: *"a generic positive least-residual
action whose unique zero is the selected unitary EOM, with norm conservation as
a corollary."*

**Landing status (staging):** in this returned tree the only copy still carries
6 `s o r r y`s and is not wired into the consolidated guard. Its truth is not in
doubt (proved above), but its *landing* at 8093 is reported-only here (§8).

---

## 6. Compact-rate audit vs. Audit 13's first-order product estimate

Object: `Compact3Plus1DiracRate/Core.lean` (all 15 obligations still `s o r r y` —
**[open]**; statements audited for truth). Reconciled against Audit 13 §3.

- **First-order product estimate preserved.** `factor(q,g) = cos q · I −
  i sin q · g` equals `exp(−i q g)` for Hermitian `g` with `g²=1`, so
  `splitStep = e^{−iεk_xα₁}e^{−iεk_yα₂}e^{−iεk_zα₃}e^{−iεmβ}` and
  `exactFlow(ε)=e^{−iεH}`. With `A_j = −iε c_j g_j`, `Σ‖A_j‖ = |ε|B ≤ B`, the
  standard bound `‖∏e^{A_j}−e^{ΣA_j}‖ ≤ (Σ_{i<j}‖A_i‖‖A_j‖)e^{Σ‖A_k‖} ≤
  ½B²e^B ε²`. `D4 = 16 B² e^B` is a valid over-estimate (32× the sharp
  `½B²e^B`); "deliberately generous" is honest. **[true]**.
- **Rate is genuinely `O(1/n)`, not `O(1/n²)`.** `unitary_pow_telescope`
  (`‖Uⁿ−Vⁿ‖ ≤ n‖U−V‖`) with `exactFlow_div_pow` gives
  `n·D4·(t/n)² = D4·t²/n`. Any promotion of the **unsymmetrized** x/y/z/mass
  product to second order is **rejected**: the generators anticommute, so
  `α₁α₂ ≠ α₂α₁` (`spatial_generators_noncommute` is the exact control;
  `(α₁α₂)_{00}=I≠−I=(α₂α₁)_{00}`), and the leading Trotter error satisfies
  `n·error → c > 0`. A Strang/palindromic `O(1/n²)` rung is a **separate**
  method and must not be attributed to this product.
- **No silent switches.** Factor order `α₁α₂α₃β` (= S21's `UxUyUzUm`); L2
  operator norm; box majorant `Dbox(K,M)=16(3K+M)²e^{3K+M}` with
  `D4_le_Dbox` correct since `B=|k_x|+|k_y|+|k_z|+|m| ≤ 3K+M`
  (`(1,2,2,3)`: `B=8 ≤ 9`); `box_error_envelope_tendsto_zero` closes the limit.
  `benchmark_1223_nondegenerate` (`H²=18I`, `H≠0`, `Dbox(2,3)>0`) is a genuine
  nonzero witness.

**Verdict:** the compact-rate *statements* are true and correctly first-order;
the theorem is **still open** (unproved) and is the dawn-blocking kinematic
arrow. Do not let S21 (empirical `n·err` stabilisation) or
`PluckerDiracCarrierBridge` (symbol-level substitution) be read as the uniform
rate. Land as stated (optionally sharpen `D4→½B²e^B`).

---

## 7. Independent anchor sweep of M1–M21 (severity order)

Method: for each manuscript claim row, locate the cited payload declaration in
the live tree and compare against `tab:anchors` in
`Sources/Null_Edge_Mass_Rank_Defect_Manuscript_2026-07-09.tex`.

**Severity 1 — genuine error in manuscript prose:**

- **[error] Derivation-spine "theory → experiment" row is doubly wrong.** It
  reads *"fifteen families, S01–S20 … two disclosed V2 reproductions
  (fixed-momentum free Dirac propagator; equal-degeneracy Schottky anomaly)."*
  (i) The live lab is **20 families, S01–S25**. (ii) The V2 set is **three**:
  S18 (1+1 Dirac), S21 (3+1 Dirac), S22 (three-level fluctuation-response).
  (iii) The **Schottky S20 was re-tiered to V0/V1** because its gap cancels
  identically — calling it a V2 reproduction is exactly the over-claim the run
  corrected. This sentence must be rewritten (§9).

**Severity 2 — prose-only / absent anchors (corpus understated):** the anchor
table `tab:anchors` predates the entire overnight dynamics/thermo/joint/bridge
wave. Landed, guarded payloads with **no anchor-table row** (all verified
present in-tree, imported by `OvernightTheoryAxiomGuard`):

| Claim | Missing anchor(s) |
|---|---|
| M3/M16 | `PluckerActionHessian`, `PluckerHessianSL2Invariance` |
| M15 | `NullFactorizationSpinFiber`, `SU2SpinHalfAction`, `UnitaryHistoryComposition` |
| M16 | `PluckerOscillatorDynamics`, `PluckerOscillatorGroup` |
| M17 | `FiniteGibbsResponse`, `FiniteGibbsVariance` |
| M19 | `DiscretePluckerVariationalFlow`, `DiscretePluckerFlowStability`, `DiscretePluckerFlowRotation` |
| M20 | `PluckerJointTheoryWitness.one_pair_joint_chain` |
| M21 | `PluckerDiracCarrierBridge.one_pair_drives_dirac_symbol` |
| M6 | `SuccessiveAxisDiracWalk`, `SuccessiveAxisPositionWalk`, `CliffordDiagonalPositionBridge` |
| (Measurement) | `FiniteInstrumentAPI` (present, `s o r r y`-free, but **not** imported by the guard — see §8) |

**Severity 3 — mismatched anchor coordinates (cosmetic; declarations exist):**

- `spinorWedge_sl2_invariant` is cited at `PhysicsSM/Spinor/PluckerMassCovariance.lean`
  (present) but also lives in `Carrier/PluckerHessianSL2Invariance.lean`; the
  citation is correct, no fix needed.
- `four_mul_det_gram_eq_concurrence_sq` / `TwoEdgeMassConcurrence` cited at
  `NullEdge/TwoEdgeMassConcurrence.lean` — file present, matches. (An older
  `NEdgeMassConcurrence.lean` also exists; not a defect.)

**Severity 4 — stale but not wrong:**

- "mass → dynamics" spine says *"position-space shifts and the many-step limit
  open."* Position-space shifts are now **landed** (`CliffordDiagonalPositionBridge`:
  Clifford-basis walk, norm preservation, `-iH` symbol). The **3+1 many-step
  uniform rate** remains open. Split the sentence accordingly.
- `tab:scoreboard` "many-step theorem remains open": true for 3+1 uniform rate,
  but 1+1 many-step **is** landed (S18/`FixedMomentumManyStepContinuum`). Refine.

All M1–M13 anchors resolve to existing declarations. No M-row cites a
nonexistent declaration.

---

## 8. Four over-claim checks + nondegeneracy gate on every overnight flagship

C1 fidelity (Lean = caption) · C2 non-vacuity · C3 hypothesis exposure ·
C4 footprint (`s o r r y`-free; a x i o m footprint within `{propext, Classical.choice, Quot.sound}`;
guarded) · ND (positive witness **and** a genuinely failing control).

| Flagship | C1 | C2 | C3 | C4 | ND |
|---|---|---|---|---|---|
| `PluckerDiracCarrierBridge.one_pair_drives_dirac_symbol` | **caption**: A definitional, B/C generic; real *symbol*-level shared-term seam, **not** shared action/propagation | pass — `rational_massive_dirac_control` (`4/25`, `5641/625`, `H≠0`) | pass — frame/momenta/actions supplied, disclosed in docstring | pass (in-tree): `s o r r y`-free, pinned a x i o m footprint, guarded | **pass** — `collinear_zero_dirac_control` collapses gap **and** generator |
| `PluckerJointTheoryWitness.one_pair_joint_chain` | **caption**: 5 interfaces, one scalar (true); 3/5 conjuncts generic; no kinematics | pass — `rational_joint_chain_control` | pass — decorations/decoder/action/ensemble supplied | pass: `s o r r y`-free, pinned a x i o m footprint, guarded | **pass** — collinear zero collapses mass/action/variance |
| `CliffordDiagonalPositionBridge` (`axisBasis_conjugates_velocity`, `axisSymbol_entry_hasDerivAt`, `spatialStep_preserves_norm`) | pass — `U D Uᴴ=α_j` and tangent `-iα_j` recomputed exact | pass — `identity_basis_fails_axis_zero` (basis change load-bearing) | pass — bases/signs explicit; isometry vs `-iH` distinguished | pass: `s o r r y`-free, pinned a x i o m footprint, guarded | **pass** — identity-basis negative control |
| `Compact3Plus1DiracRate` (`…_on_box`, `unitary_pow_telescope`) | pass — bound provable, order/norm/quantifier/rate preserved (§6) | pass — `benchmark_1223_nondegenerate` (`H²=18I`) | pass — `|ε|≤1`, `B≤3K+M`, "unsymmetrized ⇒ only O(1/n)" disclosed | **`s o r r y` stub (open)** — statements true, proof not landed | pass — noncommute + phase-reversal falsifier |
| `FiniteUnitaryPathAction` (six targets) | **caption**: least-residual action only, not Dirac/Plücker action | pass — jump control `=1`, constant control `=0` (§5) | pass — `U` is a supplied isometry; nothing derived | **`s o r r y` stub in-tree (staging)** — all six proved true here | pass — jump vs constant controls |
| `FiniteInstrumentAPI` (S25/M22) | pass — normalization/positivity/repeatability/no-disturbance | pass — qubit witness + noncommuting disturbance control | pass — **Born rule imported (P4, grade I)**; do not read as a Born derivation | in-tree `s o r r y`-free **but NOT imported by the consolidated guard** | **pass** — noncommuting disturbance control |

**Substantive items:**

1. **Two caption fixes** (both bridges): "symbol-level shared-scalar seam" and
   "joint mass/action/flow/ensemble witness" — never "shared action," "theory
   witness," or "one propagating carrier."
2. **Guard-scope gap [staging].** In this returned tree, `OvernightTheoryAxiomGuard`
   imports through `CliffordDiagonalPositionBridge` (the 8092 configuration) and
   imports **neither** `FiniteUnitaryPathAction` **nor** `FiniteInstrumentAPI`.
   So the reported 8093/placeholder-free path-action landing and the S25
   instrument are **not verifiable from this snapshot's guard**. Treat as a
   packaging/staging gap between the live lab and the returned tree, not a live
   regression — but do not report FiniteUnitaryPathAction as landed on the
   strength of this tree.
3. **Compact rate is the one true open flagship** (fails C4 only by being
   unlanded, not by any semantic defect).

---

## 9. Exact manuscript corrections + four binary dawn verdicts

### Manuscript corrections (prose only; source not edited)

1. **Derivation spine, "theory → experiment" row** — replace
   *"fifteen families, S01–S20 … two disclosed V2 reproductions (fixed-momentum
   free Dirac propagator; equal-degeneracy Schottky anomaly)"* with:
   *"twenty families, S01–S25, including three disclosed V2 reproductions —
   fixed-momentum free 1+1 Dirac propagator (S18), fixed-momentum free 3+1
   Dirac split-step (S21), and an independent three-level fluctuation-response
   check (S22); the equal-degeneracy Schottky check (S20) is V0/V1 algebraic
   self-consistency, not a V2 reproduction; no V3/V4 prediction yet."*
2. **`tab:anchors`** — add the missing landed anchors listed in §7 (Severity 2):
   `PluckerActionHessian`, `PluckerHessianSL2Invariance`, spin fiber/SU(2),
   oscillator, Gibbs response/variance, variational flow/stability/rotation,
   `one_pair_joint_chain`, `one_pair_drives_dirac_symbol`, successive-axis
   Dirac/position walks, `CliffordDiagonalPositionBridge`. Optionally
   `FiniteInstrumentAPI` once it is placed under the consolidated guard.
3. **"mass → dynamics" spine row** — change "position-space shifts and the
   many-step limit open" to "position-space Clifford shifts landed
   (`CliffordDiagonalPositionBridge`); the 3+1 compact-momentum many-step rate
   remains open."
4. **`tab:scoreboard`** — "the many-step theorem remains open" → "the 1+1
   many-step limit is landed; the 3+1 uniform compact-momentum rate remains
   open."
5. **Add captions** for the two bridges and (if cited) `FiniteUnitaryPathAction`
   exactly as in §2, §5, §8.

### Binary dawn verdicts

- **Coherent finite candidate architecture — YES.** Three end-to-end finite
  chains on shared carriers (dynamics: `massSq`→Hessian→variational
  flow→stability→rotation; ensemble: Gibbs response→variance rigidity;
  one-pair mass/action/flow/ensemble witness), one clean killed route
  (no complex-scalar-square Dirac block), the spatial Clifford walk now landed,
  and a symbol-level scalar seam into the Dirac generator. All `s o r r y`-free and
  guarded in-tree.
- **One shared-action theory — NO.** The variational (Plücker) action and the
  Dirac action are distinct selected actions; the field-valued shared action
  (R1/R2) is unwritten; `PluckerDiracCarrierBridge` shares only the *scalar* at
  the *symbol* level, and `FiniteUnitaryPathAction` is a generic least-residual
  shell, not a shared action.
- **Physical continuum theory — NO.** The 3+1 compact-momentum rate is open
  (`Compact3Plus1DiracRate` all `s o r r y`); only fixed-momentum 1+1 continuum is
  landed; no position-space `ℓ²`/PDE/local-net limit; frame/spacing supplied.
- **Predictive theory — NO.** 17 V0/V1 + 3 V2, no V3/V4; the empirical-prediction
  layer is **O**. All V2 rows import their analytic targets and are not
  predictions.

**One-line bottom line for the manuscript:** *a coherent finite candidate
architecture — not yet one shared-action theory, not yet a physical continuum,
and not yet predictive.*

---

## 10. Single most important theorem after the active rate/action jobs

Assuming `Compact3Plus1DiracRate` (rate) and `FiniteUnitaryPathAction` (action
shell) both land, the next decisive theorem is the **field-valued shared-action
reduction** — the arrow that would upgrade "one shared scalar" to "one shared
action," which is the exact gap keeping verdict 9(b) at NO.

**Exact statement shape** (two reductions of one lattice spinor action
`S_field[ψ] = Σ_x ψ(x)ᴴ(i·Dslash_ε − m)ψ(x)`):

```lean
-- (R1) scalar reduction: the second variation of S_field on the trivial-spin,
--      single-link sector is the M19 recurrence with stiffness mu = massSq.
theorem field_action_scalar_reduction :
    scalarSector.secondVariation S_field
      = DiscretePluckerVariationalFlow.step (massSq psi phi)

-- (R2) spinor first-order limit: the Euler–Lagrange operator of S_field, in the
--      fixed-momentum eps→0 limit, is the Route-B generator -iH.
theorem field_action_dirac_limit :
    Tendsto (fun eps => eulerLagrange S_field eps) (𝓝 0) (𝓝 (-I • H kx ky kz m))
```

- **Witness (nondegenerate).** `mu = 4/25` (i.e. `psi=edge0, phi=edge1(2/5)`)
  for R1; `k=(1,2,2), m=3` (`benchmark_1223_nondegenerate`, `H²=18I`) for R2.
- **Control.** (i) reversed mass phase ⇒ R2 limit is `-iH'`, `H'≠H`;
  (ii) `[α₁,α₂]≠0` forces the unsymmetrized EL operator to be genuinely
  first-order (no spurious `O(ε²)` cancellation).
- **Kill condition (decisive).** If the scalar recurrence's conserved
  `firstIntegral` cannot be realised as a component of the Dirac walk's conserved
  `⟨ψ,ψ⟩` — i.e. R1 and R2 demand *incompatible* time parameterisations — then
  the two dynamics are physically distinct and the manuscript must present **two
  actions** (a scalar stiffness action and a spinor Dirac action), honestly
  labelled, rather than one variational principle. That negative outcome is
  itself publishable and would permanently retire the "one shared-action theory"
  ambition.

Runner-up (cheaper, still dawn-relevant): complete Audit 13 §8's
`plucker_mass_drives_dirac_propagation` by conjoining the now-landed symbol seam
(clause A) with the compact-rate bound (clause b) once `Compact3Plus1DiracRate`
lands — that closes the *dynamical* half of the cross-cluster mass seam that
`PluckerDiracCarrierBridge` only closed at the symbol level.
