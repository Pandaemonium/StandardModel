# Gate C1 — Overlap Index ↔ Anomaly Bridge Plan (C263)

Date: 2026-06-29
Status: strategy / planning document. No new theorem is claimed here; this is a
roadmap that connects two already-formalized, `sorry`-free bodies of work and
names the missing intermediate layer that would join them.

Prompt of record: `AgentTasks\aristotle-prompts\gate-c1-c263-index-anomaly-bridge-plan.prompt.md`
Companion strategy job: C260 (`AgentTasks/null-edge-c260-full-physical-c1-strategy-aristotle-2026-06-28.md`).
Umbrella release plan: `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md`.

---

## 0. One-paragraph summary

The repository already contains two finished, kernel-checked end points:

1. an **algebraic overlap / Ginsparg–Wilson (GW) layer** for Gate C1
   (`OverlapGinspargWilson.dov_ginsparg_wilson` plus the tetrahedral
   Wilson-symbol gap machinery), and
2. an **anomaly-cancellation layer** (the Standard-Model `AnomalyPackage` and
   the Furey `AnomalyBridge` / `ElectroweakAnomalyBridge`).

What is *not* yet formalized is the classical lattice fact that joins them: for
a GW/overlap Dirac operator, the **chiral index** `Tr(γ₅ (1 − ½ a D))` is an
integer that equals the topological charge, and the **measure-level chiral
anomaly** is the same object that the perturbative cubic/gravitational anomaly
sums in `AnomalyPackage` must cancel. This document plans a thin Lean "index
layer" — purely finite-dimensional linear algebra over the existing GW identity
— that turns the GW relation into an integer index and a trace-level anomaly
functional, and then wires that integer to the rational anomaly sums already
proved. The plan is deliberately staged so that each milestone is a small,
self-contained, finite-matrix lemma the prover can attack independently.

---

## 1. Existing assets (exact declarations)

### 1.1 Overlap / Ginsparg–Wilson algebraic core
File: `PhysicsSM/Draft/NullEdge/GateC1/OverlapGinspargWilson.lean`

- `OverlapGinspargWilson.Dov gamma5 eps : Matrix Spin Spin ℂ := 1 + gamma5 * eps`
- `OverlapGinspargWilson.dov_ginsparg_wilson` — for involutions `gamma5² = 1`
  and `eps² = 1`,
  `γ₅·Dov + Dov·γ₅ = Dov·γ₅·Dov` (the normalized GW relation), proved with no
  anticommutation hypothesis.

This is the algebraic seed for the whole index layer: the GW relation is exactly
the hypothesis the lattice index theorem needs.

### 1.2 Tetrahedral Wilson free-symbol gap lane
Files: `TetraQSquareExact.lean`, `TetraQMatrixSquareExact.lean`,
`TetraScalarWilsonSymbol.lean`.

- `TetraQMatrixSquareExact.TetraEuclideanSlashData` (interface), `Q`,
  `Q_square_exact`, `Q_hermitian`, `Q_star_mul_exact`,
  `Q_inverse_formula`, `Q_det_ne_zero_of_exists_ne_zero`.
- `TetraQSquareExact.qExact`, `qLower`, `qExact_eq_zero_iff_forall_eq_zero`,
  `qExact_ne_zero_iff_exists_ne_zero` (the symbol vanishes only at the origin
  of `sin k`).
- `TetraScalarWilsonSymbol.K`, `K_star`, `K_star_mul`
  (`K(k)^* K(k) = ((qExact(sin k)+m(k)²)/a²) I`), the `FirstWilsonBand`
  predicate, `firstBandMu_pos`, and the uniform gap theorems
  `K_symbol_l2NormSq_gap`, `H`, `H_l2NormSq_eq_K_l2NormSq`, `H_symbol_l2NormSq_gap`,
  `scalarWilsonCoeff_pos_of_firstBand`.

This lane already provides a **Hermitian symbol `H` with a uniform spectral
gap** in the first Wilson band — precisely the analytic input an overlap
sign-kernel `eps = sign(H)` needs (Candidate 2 of the release plan,
`H_NED = Γ_lat (D − mR)`, `T = sign(H)`, `Π = (1+T)/2`).

### 1.3 Anomaly-cancellation layer
Files: `PhysicsSM/StandardModel/AnomalyPackage.lean`,
`PhysicsSM/StandardModel/AnomalyCancellation.lean`,
`PhysicsSM/Algebra/Furey/AnomalyBridge.lean`,
`PhysicsSM/Algebra/Furey/ElectroweakAnomalyBridge.lean`.

- `AnomalyPackage`: `ChiralMultiplet`, the six anomaly functionals
  (`gravitationalU1Anomaly`, `u1CubedAnomaly`, `su2SquaredU1Anomaly`,
  `su3SquaredU1Anomaly`, `su3CubedAnomaly`, `weakDoubletCount`),
  `LocalAnomalyFree`, `WittenSU2AnomalyFree`, `standardModelOneGeneration`,
  and the headline theorems `standardModelOneGeneration_localAnomalyFree`,
  `…_wittenAnomalyFree`, `…_anomalyFree`, plus `nCopies` scaling and
  `threeGenerations_anomalyFree`.
- `AnomalyBridge`: `Q_op` eigenvalue table on the Furey `Jbar` ideal
  (`Q_op_omega_bar`, `Q_op_vbar1..6`, `Q_op_nu_bar`),
  `combined_gravitational_anomaly_vanishes`, `combined_cubic_anomaly_vanishes`,
  and re-exports `sm_localAnomalyFree`, `sm_wittenAnomalyFree`.
- `ElectroweakAnomalyBridge`: `fureyDoubletTable`, the Gell-Mann–Nishijima
  check `furey_gellMannNishijima`, `fureyDoubletTable_su2SquaredU1Anomaly`,
  the completion `fureyDoubletTable_append_completion`, and the bundled
  records `ClaimBoundary` / `FureyElectroweakAnomalyBridge`.

> Note: `AnomalyBridge.lean` and `ElectroweakAnomalyBridge.lean` import Furey
> support modules (`OperatorRepresentations`, `ElectroweakCompletePackage`,
> `OneGenerationPackage`, …) that are **not present** in this slim packet. The
> bridge files are included as the contract surface; they will not compile here
> until those modules are restored. The index layer below depends only on
> `OverlapGinspargWilson` and `AnomalyPackage`, both of which are self-contained,
> so it can be built and proved independently of the missing Furey support.

---

## 2. The gap to be bridged

Conceptually there are three rungs between the two end points; only the middle
rung is missing in Lean.

```
   GW / overlap algebra            chiral index                anomaly cancellation
   (Dov, dov_ginsparg_wilson)  --> Tr(γ₅(1 − ½ aD)) ∈ ℤ  -->  Σ Q = 0, Σ Q³ = 0
   [DONE: §1.1, §1.2]              [MISSING: this plan]         [DONE: §1.3]
```

The classical statements being targeted (finite-lattice / finite-matrix forms):

1. **Lüscher index identity.** For an overlap `D` obeying the GW relation,
   `½ Tr(γ₅ a D) = Tr(γ₅ (1 − ½ a D))` is an integer, and it equals
   `n₊ − n₋`, the difference of zero-mode chiralities. In the normalized
   convention `Dov = 1 + γ₅ ε` with `γ₅² = ε² = 1`, the relevant index object
   is `index(Dov) = −½ Tr(γ₅ ε) = −½ Tr(γ₅ (Dov − 1))`.
2. **Index = chirality imbalance.** With `Γ̂ := γ₅(1 − ½ Dov)` (the
   modified, GW-compatible chirality), `Tr Γ̂` is the lattice index, integer
   because `Γ̂² = 1` on the appropriate space (a consequence of the GW relation).
3. **Anomaly = index.** The measure-Jacobian anomaly under a lattice chiral
   rotation is `−2 · index`, and per-species this is the same coefficient
   whose **weighted sum over the spectrum is the perturbative anomaly** that
   `AnomalyPackage` forces to zero. So "anomaly-free fermion content" ⇔ "the
   total lattice index over all species, weighted by gauge charges, vanishes."

Rung (3) is what makes this a *bridge*: the integer index of the overlap
operator, summed with the gauge-charge weights of the multiplets, is the same
rational number computed by `u1CubedAnomaly`, `gravitationalU1Anomaly`, etc.

---

## 3. Target Lean architecture

Create a new module
`PhysicsSM/Draft/NullEdge/GateC1/OverlapIndex.lean`
(importing `OverlapGinspargWilson` and `Mathlib`) and a bridge module
`PhysicsSM/Draft/NullEdge/GateC1/IndexAnomalyBridge.lean`
(importing `OverlapIndex` and `PhysicsSM.StandardModel.AnomalyPackage`).

Keep everything finite-dimensional (`Matrix Spin Spin ℂ`, `Fintype Spin`,
`DecidableEq Spin`). No functional calculus, no operator norms — only `Matrix`
trace identities. This is the regime where the prover is strongest and where the
GW identity already lives.

### 3.1 `OverlapIndex.lean` — definitions

```lean
/-- GW-modified chirality of the normalized overlap matrix. -/
noncomputable def Ghat (gamma5 eps : Matrix Spin Spin ℂ) : Matrix Spin Spin ℂ :=
  gamma5 * (1 - (1/2 : ℂ) • Dov gamma5 eps)

/-- Lattice chiral index of the normalized overlap matrix. -/
noncomputable def overlapIndex (gamma5 eps : Matrix Spin Spin ℂ) : ℂ :=
  (Ghat gamma5 eps).trace
```

### 3.2 `OverlapIndex.lean` — lemma stack (each `by sorry` for the prover)

L1. `Ghat_eq` : `Ghat γ₅ ε = -(1/2) • (γ₅ * ε)`  (since `γ₅(1 − ½(1+γ₅ε)) =
   ½γ₅ − ½γ₅²ε = ½γ₅ − ½ε`… choose the convention that makes `Ghat` the clean
   `−½ γ₅ ε`; fix signs once `γ₅² = 1` is in scope). *Pure rewrite from
   `hgamma5_sq`.*

L2. `Ghat_sq_eq_quarter_one` : under `γ₅² = ε² = 1`,
   `(γ₅ε)² = 1`, hence `Ghat² = (1/4) • 1` after normalization, or with the
   standard `Γ̂ = γ₅ − ½γ₅Dov` convention, `Γ̂² = 1`. *Uses
   `dov_ginsparg_wilson` and the two involution hypotheses.* This is the
   integrality engine.

L3. `overlapIndex_eq` : `overlapIndex γ₅ ε = -(1/2) * (γ₅ * ε).trace`.
   *From L1 and `Matrix.trace_smul`.*

L4. `trace_gamma5_eps_real` : `(γ₅ * ε).trace` is real (in fact an even
   integer) when `γ₅, ε` are Hermitian involutions. Strategy: `γ₅ε` is
   conjugate to its negative via `ε` (since `ε(γ₅ε)ε = εγ₅ = −γ₅ε` *iff* they
   anticommute) — so this rung needs the anticommutation case. Split the module
   into:
   - the **diagonal/commuting case** (route/taste labels): `index = 0`,
     matching the release plan's zero-index no-go;
   - the **anticommuting case** (genuine chirality): `index` is a nonzero
     even integer.
   This mirrors the release-plan acceptance test
   `ChiralIndex Γ₀ χ_target(B0) ≠ 0`.

L5. `overlapIndex_int` : there exists `n : ℤ` with `overlapIndex γ₅ ε = (n : ℂ)`.
   *From L2 via the eigenvalue ±1 structure of `Γ̂`; `Matrix.trace` of an
   involution is the signature, an integer.* The cleanest Lean route is
   `IsHermitian.trace`/eigenvalue counting, or diagonalization of the
   involution `Γ̂`.

### 3.3 `IndexAnomalyBridge.lean` — the join

Define the per-species contribution and the weighted total, then prove the
bridge to the existing rational anomaly functionals.

```lean
/-- Charge-weighted lattice index over a multiplet list, using the same
charge/multiplicity data as `AnomalyPackage.ChiralMultiplet`. -/
noncomputable def weightedOverlapAnomaly
    (idx : ChiralMultiplet → ℤ) (ms : List ChiralMultiplet) : ℚ := …
```

B1. `index_matches_gravitational` : with the convention `idx ≡ +1` per
   left-handed Weyl species, `weightedOverlapAnomaly` reduces to
   `gravitationalU1Anomaly ms` (linear charge sum). *List-fold rewrite +
   `decide`/`norm_num` on `standardModelOneGeneration`.*

B2. `index_matches_cubic` : the cubic-charge weighting reduces to
   `u1CubedAnomaly ms`.

B3. `overlapIndex_anomaly_free_of_localAnomalyFree` : if
   `LocalAnomalyFree ms` then the charge-weighted overlap-index sums vanish.
   *Direct corollary of B1/B2 and `standardModelOneGeneration_localAnomalyFree`
   (re-exported as `sm_localAnomalyFree`).*

B4. Bundled record `IndexAnomalyBridge` (mirroring
   `FureyElectroweakAnomalyBridge`) collecting: `overlapIndex_int`, the GW
   relation witness, B1, B2, B3, and an explicit `ClaimBoundary`-style field
   naming what is still classical-only (functional calculus / locality /
   gauge covariance — see §5).

This produces a single citeable theorem:

> *For an overlap Dirac matrix in normalized GW form, the chiral index is an
> integer, and its gauge-charge-weighted total over the one-generation
> multiplet table equals the Standard-Model perturbative anomaly sums, which
> vanish.*

---

## 4. Milestones and suggested prover batching

Order is bottom-up; each milestone is independently provable.

- **M1 (algebra, easy):** L1, L3, B1, B2. Pure `Matrix.trace` / list-fold
  rewrites + `norm_num`/`decide`. Batch all four in parallel.
- **M2 (integrality, core):** L2 then L5. L2 is the GW-driven `Γ̂² = 1`
  identity (reuse `dov_ginsparg_wilson`); L5 is "trace of an involution is an
  integer." If L5 over general `Spin` is hard, first prove it for
  `Spin = Fin 4` (the tetrahedral case) by `Fintype` exhaustion.
- **M3 (chirality split):** L4 — the commuting (index 0) vs anticommuting
  (index ≠ 0) dichotomy. This is the mathematically delicate rung; decompose
  into the two cases as separate lemmas.
- **M4 (join):** B3, B4 — corollaries; should fall once M1–M2 land.
- **M5 (optional analytic upgrade):** instantiate `eps = sign(H)` using the
  uniform-gap `H` from `TetraScalarWilsonSymbol`, proving `eps² = 1` from the
  gap (`H_symbol_l2NormSq_gap`, `firstBandMu_pos`). This connects the symbol
  lane to the index layer and realizes release-plan Candidate 2.

Recommended first prover batch: **M1**. It validates the definitions and the
list-reduction plumbing to `standardModelOneGeneration` before any hard algebra.

---

## 5. Claim boundary (what this bridge does *not* establish)

Following the repo convention of explicit `ClaimBoundary` records, the index
layer is finite-dimensional linear algebra. It does **not**:

1. construct a functional calculus or `sign(H)` as an operator (only the
   finite-matrix involution `eps`);
2. prove locality / exponential tails of the overlap kernel
   (`NonultralocalControlCertificate`, `ExponentialTail`);
3. prove gauge covariance or background stability
   (`GaugeCovariantOrDressed`, `StableUnderAdmissibleGaugeFields`);
4. address Krein positivity, determinant-line, or regulator stability
   (`KreinPositivePhysicalResidue`, `DeterminantLineControlled`,
   `RegulatorStable`);
5. prove the Furey realization conjecture
   (`FureyRealizesStandardModelOneGeneration`).

These remain the open rungs tracked by the umbrella release plan
(`GateC1_NU_Quantum`, `C112_DeterminantLineAnomalyContract`). The index/anomaly
bridge is the *kinematic* link `AnomalyAccounted` would consume, not the full
quantum contract.

---

## 6. Risks and acceptance tests

- **Sign/normalization drift.** The factor `½ a D` vs `Dov = 1 + γ₅ε` must be
  pinned once. Acceptance: `overlapIndex_eq` gives `−½ Tr(γ₅ε)` and L5 yields an
  integer with the expected parity on a `Fin 4` toy `γ₅, ε`.
- **Zero-index trap (release-plan no-go).** Commuting `γ₅, ε` give index 0 and
  classify route/taste, not chirality. Acceptance test, mirroring the release
  plan: exhibit anticommuting `γ₅, ε` on `Fin 4` with
  `overlapIndex γ₅ ε ≠ 0` via `#eval`/`decide` before investing in L4.
- **Coercion friction `ℤ → ℂ → ℚ`.** Keep the integer index in `ℤ`, cast once
  at the bridge boundary into the `ℚ`-valued anomaly functionals.
- **Missing Furey support modules.** Do the join against `AnomalyPackage`
  (self-contained) rather than the Furey bridge files, so M1–M4 build in this
  packet without restoring `OperatorRepresentations` et al.

---

## 7. Concrete next action

1. Add `OverlapIndex.lean` with `Ghat`, `overlapIndex`, and L1–L5 as
   `by sorry`; confirm it builds (module target `PhysicsSM…OverlapIndex`).
2. Sanity `#eval` the anticommuting `Fin 4` toy to confirm a nonzero index
   exists (kills the zero-index trap early).
3. Prover batch M1 (L1, L3, B1, B2) in parallel; verify with a per-module
   `lean_build` plus a `sorry` grep.
4. Prover M2 (L2, L5), then M3 (L4), then M4 (B3, B4).
5. Optionally M5 to wire the tetrahedral gap symbol `H` into `eps`.

Each step is small, finite-dimensional, and rests on identities already proved
in this repository.
