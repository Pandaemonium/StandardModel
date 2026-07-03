# Gate C1 — C262 branch-retention audit (scalar / flavored Wilson)

Date: 2026-06-29

Scope: audit the *branch-retention* status of the Gate C1 scalar Wilson Lean
chain, and assess the gap between the formalized scalar construction and the
flavored / species-splitting Wilson term that the non-ultralocal release plan
identifies as the actual physical target.

This report is grounded in two sources that are present in the packet:

* the Lean files under `PhysicsSM/Draft/NullEdge/GateC1/`;
* the strategy document `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md`.

---

## 0. Executive summary

* The scalar Wilson free-symbol chain is now **machine-verified end to end**.
  The only missing dependency, `TetrahedralGlobalGap.lean`, was reconstructed
  from its usage contract and the chain builds with no `sorry` and only the
  standard axioms (`propext`, `Classical.choice`, `Quot.sound`).
* What the scalar chain **retains**: a strictly positive, *uniform*
  inverse-symbol gap throughout the first Wilson band `0 < ρ < 2r`, i.e. the
  scalar Wilson/free symbol `K(k)` is uniformly invertible (no kernel) on the
  whole momentum torus, with an explicit gap constant. This is the
  "complement has a true inverse(-propagator) gap" half of the
  branch-retention criterion.
* What the scalar chain **does not retain (by design)**: any chiral-index /
  spectral-island content. The scalar Wilson mass is a multiple of the
  identity on spin, so it cannot split branches/species and carries **no**
  origin chiral index. It therefore cannot, on its own, satisfy the
  branch-retention criterion, whose first clause requires a *target spectral
  island with nonzero origin chiral index* (release plan §"central unknown" and
  the island/index/gap clauses around lines 282–285).
* The **flavored / species-splitting** Wilson term (`W_branch`, Adams-style
  flavored mass) that the release plan repeatedly nominates as the correct
  branch-retaining object is **not yet formalized** in the packet. This is the
  principal open item for branch retention.

---

## 1. Branch-retention criterion (reference)

The release plan states the criterion a null-edge branch observable `B(U)` must
satisfy (release plan, lines ~282–285):

1. `B(U)` has a target spectral island separated by `δ > 0`;
2. the target island has **nonzero chiral index**;
3. the complement admits a **true inverse bad-sector gap**
   (an inverse-propagator gap, *not* a propagator-zero / mirror removal).

"Branch retention" for a Wilson-type term means: after adding the Wilson/branch
mass, the physical chiral branch survives as a gapped, index-carrying spectral
island while the doubler/bad sector is pushed out by a genuine inverse gap.

The audit measures the scalar and flavored Wilson constructions against these
three clauses.

---

## 2. Packet inventory and build status

The packet is a **slim strategy/audit packet**: several modules referenced by
`import` are not included. Present vs. missing PhysicsSM modules:

Present (build inputs to the scalar Wilson chain):

* `PhysicsSM/Draft/NullEdge/GateC1/TetraQSquareExact.lean`
* `PhysicsSM/Draft/NullEdge/GateC1/TetraQMatrixSquareExact.lean`
* `PhysicsSM/Draft/NullEdge/GateC1/TetraScalarWilsonSymbol.lean`
* `PhysicsSM/Draft/NullEdge/GateC1/OverlapGinspargWilson.lean` (standalone)
* `PhysicsSM/StandardModel/AnomalyPackage.lean`,
  `PhysicsSM/StandardModel/AnomalyCancellation.lean`

Missing (referenced by imports, not in packet):

* `PhysicsSM/Draft/NullEdge/GateC1/TetrahedralGlobalGap.lean` — **reconstructed
  in this audit** (see §5).
* The Furey anomaly-bridge chain:
  `Algebra/Furey/OperatorRepresentations`, `…/ElectroweakCompletePackage`,
  `…/ElectroweakPaperPackage`, `…/OneGenerationPackage`,
  `…/JbarElectroweakAnomaly`, `StandardModel/OneGenerationTable`,
  `StandardModel/FamilyAnomalyNaturality`. These feed the anomaly-bridge files
  and are tangential to scalar/flavored Wilson branch retention; they are
  **not** reconstructed here.

Build status after this audit:

* The scalar Wilson chain
  (`TetrahedralGlobalGap → TetraQSquareExact → TetraQMatrixSquareExact →
  TetraScalarWilsonSymbol`) and `OverlapGinspargWilson` **build cleanly** with
  no `sorry`.
* The default `PhysicsSM` library target still fails to build because the Furey
  bridge imports remain unresolved (out of scope for this audit).

---

## 3. The scalar Wilson chain: what is formalized

### 3.1 Abstract Euclidean tetrahedral slash (`TetraQMatrixSquareExact`)

* `TetraEuclideanSlashData` abstracts four Hermitian slash matrices `B_A` with
  the Euclidean Clifford/Gram anticommutator
  `B_A B_B + B_B B_A = 2·tetraGram(A,B)·I`, `tetraGram` = `5/8` on the diagonal,
  `-1/8` off-diagonal.
* `Q_square_exact`: `Q(s)² = qExact(s)·I` (representation-independent),
  with `qExact(s) = (3/4)Σ s_A² − (1/8)(Σ s_A)²`.
* `Q_inverse_formula_of_exists_ne_zero`,
  `Q_det_ne_zero_of_exists_ne_zero`: away from the origin (`s ≠ 0`) the slash is
  invertible with explicit Clifford inverse and nonzero determinant.

Branch reading: this fixes the **kinetic** (doubler-structure) part. The
quadratic form `qExact` is positive-definite in `s` (eigenvalues `1/4, 3/4,
3/4, 3/4` of `tetraGram`), so `qExact(s) ≥ (1/4)Σ s_A²`.

### 3.2 Scalar Wilson/free symbol (`TetraScalarWilsonSymbol`)

* `K(k) = a⁻¹ (i·Q(sin k) + m(k)·I)`, with the **scalar** Wilson mass
  `m(k) = mWilson r ρ k = r·Σ_A(1 − cos k_A) − ρ`.
* `K_star_mul` (exact Hilbert-sign-kernel identity):
  `K(k)* K(k) = ((qExact(sin k) + m(k)²)/a²)·I`.
  Cross terms cancel **precisely because the Wilson mass is a scalar multiple of
  the identity** (`Q` Hermitian, `m` central).
* `FirstWilsonBand r ρ := 0 < r ∧ 0 < ρ ∧ ρ < 2r`.
* `scalarWilsonCoeff_uniform_gap`: explicit uniform lower bound
  `firstBandMu r ρ > 0 ≤ qLower(sin k) + m(k)²` for **all** `k`, with
  `firstBandMu` the explicit `min` certificate.
* `scalarWilsonExactCoeff_uniform_gap` / `K_star_mul_uniform_coeff_gap`: the
  same uniform gap, scaled by `a⁻²`, attached to the exact symbol square.
* `K_symbol_l2NormSq_gap`: `∃ γ>0, γ·‖ψ‖² ≤ ‖K(k)ψ‖²` for all `k, ψ`
  (finite L² norm). This is the operator-facing **uniform inverse gap**.
* `H = γ₅·K` with `H_symbol_l2NormSq_gap`: the same gap transfers to the
  Hermitian sign-kernel symbol under a unitary `γ₅`.
* `OverlapGinspargWilson.dov_ginsparg_wilson`: the normalized overlap matrix
  `D = 1 + γ₅·ε` satisfies the Ginsparg–Wilson relation from `γ₅² = ε² = 1`
  alone (algebraic brick, no locality/functional calculus).

All of the above are verified with only the standard axioms.

---

## 4. Branch-retention findings (scalar Wilson)

Measured against the three-clause criterion of §1:

| Clause | Scalar Wilson status | Evidence |
|---|---|---|
| (3) complement / bad sector has a **true inverse gap** | **Retained, uniformly.** `K` (and `H = γ₅K`) is uniformly invertible across the whole torus in the first Wilson band, with an explicit gap constant. This is a genuine inverse-symbol gap, not a propagator zero. | `K_symbol_l2NormSq_gap`, `scalarWilsonCoeff_uniform_gap`, `K_star_mul` |
| (1) **target spectral island** separated by `δ>0` | **Not established.** The chain proves a *global* lower gap (no kernel anywhere), which is invertibility, but it does **not** isolate a separated target island vs. complement; there is no spectral-island / Riesz-projector construction in the packet. | — |
| (2) target island has **nonzero chiral index** | **Not retained — structurally impossible for the scalar term.** The Wilson mass `m(k)·I` is central on spin, so it acts identically on all chirality components and cannot split branches/species; it carries no origin chiral index. | `K_star_mul` (mass enters as `m²·I`) |

Key positive result for the audit: the *coefficient positivity* requested by the
gap-facing API, `scalarWilsonCoeff_pos_of_firstBand`
(`0 < (qExact(sin k) + m(k)²)/a²` for all `k`), is now fully proved (its
previously-missing pointwise positivity dependency
`tetrahedral_freeGapScalar_pos` is supplied — see §5).

Interpretation. The scalar Wilson term **does** what a scalar Wilson term can
do: it lifts the doublers and gives a uniform inverse-propagator gap so that the
free symbol has no zero mode anywhere on the torus in the band `0<ρ<2r`. This is
real branch-retention progress on clause (3). It **cannot** by itself satisfy
clauses (1)–(2): a scalar (identity-valued) mass has no branch/flavor structure,
so there is no nonzero origin chiral index to retain. This matches the release
plan's repeated warning that a scalar Wilson term is the wrong primitive for the
branch and that an Adams-style flavored / species-splitting `W_branch` is needed
(release plan §26, §"C150", and the `W_branch` discussion: "`W_branch` should be
developed as a null-edge analogue of an Adams-style flavored mass or
species-splitting Wilson term … This matches the finite branch-Pauli/qutrit seed
better than a scalar Wilson term").

---

## 5. Reconstruction of `TetrahedralGlobalGap.lean`

`TetraQSquareExact.lean` imports `TetrahedralGlobalGap`, which was absent from
the packet, so the entire scalar Wilson chain failed to elaborate. The interface
consumed downstream fully pins the missing module; it was reconstructed and is
now verified:

* `TetrahedralBranchWindow.vTetra`, `wTetra`: the symmetric tetrahedral coframe
  coefficients. `wTetra = √3`, and
  `vTetra s i = (√3/2)·s i + ((1−√3)/8)·Σ_A s_A`, i.e. the action of the unique
  symmetric positive square root of the tetrahedral Gram matrix `tetraGram`
  (decomposition `G = (1/4)P₁ + (3/4)P₁⊥`).
* `tetraKineticCoeff`, `tetraKineticCoeffNormSq`: the kinetic coefficient vector
  and its squared finite norm. By construction
  `tetraKineticCoeffNormSq k = qExact(sin k)`; this is the equality
  `TetraQSquareExact.tetraKineticCoeffNormSq_eq_qExact`, whose proof was made
  robust via a `linear_combination` using `(√3)² = 3` (the certificate identity
  `LHS − RHS = ((√3)² − 3)·(Σs²/4 − (Σs)²/16)`).
* `wilsonScalar r ρ k = r·Σ_A(1 − cos k_A) − ρ`, definitionally equal to
  `mWilson`.
* `freeGapScalar r ρ k = tetraKineticCoeffNormSq k + (wilsonScalar r ρ k)²`.
* `tetrahedral_freeGapScalar_pos`: pointwise strict positivity of
  `freeGapScalar` in the first Wilson band, **now proved**. The argument: if
  some `sin(k_A) ≠ 0`, the kinetic part is `≥ (1/4)Σ sin² > 0`; if all
  `sin(k_A)=0` then each `cos(k_A) = ±1`, so `Σ(1−cos k_A) ∈ {0,2,4,6,8}`, and
  `r·Σ − ρ` is either `−ρ ≠ 0` (sum `0`) or `≥ 2r−ρ > 0` (sum `≥ 2`); the Wilson
  square is then strictly positive.

The `hper` periodicity hypothesis (kept for API compatibility with the
downstream caller `scalarWilsonCoeff_pos_of_firstBand`) turned out to be
unnecessary for the proof and is marked `_hper`.

Caveat. `TetrahedralGlobalGap.lean` is a faithful reconstruction of the
*contract* used by the rest of the chain (it never existed in this repo's git
history). The definitions are pinned up to the two hard constraints
`tetraKineticCoeffNormSq = qExact(sin·)` and `wilsonScalar = mWilson`; the
specific coframe presentation (symmetric Gram square root) is one natural choice
consistent with the `√3` normalization the original proof referenced. The
downstream theorems do not depend on the internal coframe presentation, only on
these two equalities, so the reconstruction is behaviorally equivalent for the
chain.

---

## 6. Flavored Wilson status (the actual branch target)

The release plan's branch-retaining object is a **matrix-valued, flavored /
species-splitting** Wilson term `W_branch` (Adams-style flavored mass /
staggered-overlap analogue), audited by a Schur-parity criterion, designed so
that:

* the target chiral branch becomes a separated spectral island with **nonzero
  origin chiral index** (clause 2), and
* the bad/mirror sector gets a **true inverse-propagator gap** (clause 3),
  explicitly *not* a propagator-zero mirror removal.

Formalization status in this packet: **absent.** Concretely missing for
flavored branch retention:

1. A matrix-valued Wilson/branch mass `W_branch(k)` (replacing the central
   `m(k)·I`) that is non-central on the branch/flavor factor.
2. The exact symbol square for `K_flavored = a⁻¹(i·Q + W_branch)`. Note this is
   **strictly harder** than `K_star_mul`: the cross terms
   `i(Q·W_branch − W_branch·Q)` cancel in the scalar case only because `m` is
   central; for a genuine flavored mass they cancel only if `W_branch`
   anticommutes/commutes appropriately with `Q`, which must be an explicit
   hypothesis or theorem.
3. A spectral-island separation theorem (clause 1) — no Riesz/resolvent
   projector or mass-window island is formalized.
4. A nonzero-origin-chiral-index theorem for the target island (clause 2) — the
   decisive clause; the release plan flags that balance-commuting spectral
   projectors give *zero* chiral index, so this needs the balance-odd
   Schur/branch structure.
5. A true inverse bad-sector gap for the complement (clause 3) at the flavored
   level (the scalar uniform gap is the right *template* but does not transfer
   automatically once the mass is non-central).

---

## 7. Retention checklist (status)

| Item | Status |
|---|---|
| Scalar kinetic slash square `Q² = qExact·I` | ✔ proved |
| Scalar Wilson symbol square `K*K = coeff·I` | ✔ proved |
| Uniform inverse gap for `K` / `H` in band `0<ρ<2r` | ✔ proved |
| Pointwise free-gap positivity `freeGapScalar > 0` | ✔ proved (reconstructed dep) |
| Ginsparg–Wilson algebra for `D = 1 + γ₅ε` | ✔ proved (abstract) |
| Branch-retention clause (3): inverse bad-sector gap (scalar) | ✔ retained (uniform) |
| Branch-retention clause (1): separated target spectral island | ✘ not formalized |
| Branch-retention clause (2): nonzero origin chiral index | ✘ not retained by scalar term; not formalized |
| Flavored/species-splitting `W_branch` symbol + square | ✘ not formalized |
| Flavored uniform inverse gap | ✘ not formalized |
| `sign(H)` / `ε = sign(H_ne)` functional calculus, locality | ✘ not formalized |

---

## 8. Recommendations (priority order)

1. **Introduce a flavored branch mass.** Generalize `TetraScalarWilsonSymbol`
   from the central `m(k)·I` to a matrix-valued `W_branch(k)` on a
   branch/flavor factor, isolating exactly the commutation hypothesis with `Q`
   needed to keep the symbol-square cross terms cancelling. State it abstractly
   (as `TetraEuclideanSlashData` does) so it does not depend on a concrete
   gamma representation.
2. **Transfer the uniform gap.** Re-prove the `K_symbol_l2NormSq_gap` template
   for the flavored symbol; the scalar `firstBandMu` certificate is the model.
   This re-establishes clause (3) at the flavored level.
3. **Formalize a spectral island + index.** Build a Riesz/resolvent projector
   onto the target island and a chiral-index functional, then prove the index
   is nonzero on the balanced origin fiber (clause 2) and the island is
   `δ`-separated (clause 1). This is the decisive and hardest step.
4. **Connect to overlap.** Feed `ε = sign(H_flavored)` into the existing
   `OverlapGinspargWilson` brick, then pursue locality/admissibility separately
   (currently only the algebraic GW identity is formalized).
5. **Restore the Furey bridge imports** if the anomaly-cancellation tie-in is to
   be machine-checked in the same project (out of scope here).

---

## 9. Provenance / verification notes

* All cited theorems build under Lean 4 / Mathlib `v4.28.0` and depend only on
  `propext`, `Classical.choice`, `Quot.sound` (checked via `#print axioms`).
* The reconstruction (`TetrahedralGlobalGap.lean`) and the one edited proof
  (`tetraKineticCoeffNormSq_eq_qExact`) are the only changes to the Lean
  sources; the scalar Wilson chain now elaborates with no `sorry`.
* This report makes no claim about the missing Furey bridge modules beyond
  recording that they are absent.
