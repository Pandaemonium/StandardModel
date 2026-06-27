# C74 plan: post-gauge residue and ghost safety for `D_phys`

Status: report-only theorem plan (no Lean code is asserted here as proven).

Inputs read:

- Task note: `AgentTasks/null-edge-wave17-c74-null-wilson-residue-ghost-safety-aristotle-2026-06-27.md`
- Context pack: `AgentTasks/context-packs/null-edge-gate-c-null-wilson-20260627-063900.md`
- Working plan §11–§12.3 (`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`)
- Existing Lean modules (verbatim conventions reused, not duplicated):
  - C47/C48 `PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean`
  - C59 `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean`
  - C62 `PhysicsSM/Draft/NullEdgeCompositeZeroEscape.lean`
  - C63 `PhysicsSM/Draft/NullEdgeProjectedGhostSafety.lean`
  - C69 `PhysicsSM/Draft/NullEdgeOffBranchZeroSector.lean`
  - K2 `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean`

## 0. The hazard and the non-negotiable guardrail

Golterman–Shamir (arXiv:2311.12790) warn that a propagator/determinant **zero**
of the Dirac symbol is not automatically benign: once weak gauge coupling is
switched on, a zero can promote to a **gauge-coupled propagating state with
wrong-sign (negative Krein) residue** — a unitarity-violating ghost — *even while
the flavored index / anomaly behaviour survives*.

Guardrail (restated from the task and already formalized as negative results in
C59 `chirality_not_ghostSafe`, `index_not_sufficient` and C63
`chirality_index_covariance_not_ghostSafe`):

> Ghost safety must **not** be claimed from a nonzero flavored index, projected
> chirality alignment, or gauge covariance of the link-dressed projector — alone
> or in combination. These are kinematic certificates; ghost safety is a separate,
> dynamical (post-gauge **residue-sign**) certificate.

The point of C74 is to make that separate certificate finite and provable: it is
the **residue-sign formula** evaluated at each pole of `D_phys`, on the physical
quotient, after gauge coupling. Everything below reduces ghost safety to a finite
list of residue-sign obligations and supplies the smallest Lean API,
`PostGaugeResiduePositive`, that carries them.

---

## Q1. What finite data define a pole/sheet for `D_phys`?

`D_phys` is the regulated/projected operator of Working Plan §12.3:
`D_phys` is built from the bare retarded null symbol `D_+` (`D_N`), a
null-Wilson / overlap branch-control regulator `R_W(q) = (r/h) Σ_a (1 − cos q_a)`
(§12.1), and the K2 physical-sector projection `P_phys` (retain Krein-positive
branches `{0,2}`, project out `{1,3}`).

A **pole/sheet datum** is the following finite record (one per candidate zero `j`).
It refines C47/C48 `ZeroDatum` (which already carries `kind`, `kreinResidue`,
`gaugeCoupledPropagating`) by exposing the analytic data the residue formula needs.

Finite data per pole `j`:

1. **Location** `q⋆_j : Fin 4 → ℝ` — the candidate momentum, a real-torus point
   (mod `2π`). Reuse the C69 locus language: `qform (phaseU q⋆) = 0` for branch /
   off-branch zeros; the null-Wilson cost `W(q⋆_j) = Σ_a (1 − cos q⋆_{j,a})`
   classifies it as origin (`W = 0`) vs. non-origin (`W > 0`).
2. **Symbol germ** `D_phys` as a finite real matrix `Sym n` (reuse C62
   `abbrev Sym (n : ℕ) := Matrix (Fin n) (Fin n) ℝ`) together with its value
   `D_phys(q⋆_j)` and singularity witness `D_phys(q⋆_j).det = 0`
   (C62 `IsPropagatorZero`).
3. **Kernel mode** `v_j : Fin n → ℝ` with `KernelMode (D_phys q⋆_j) v_j`
   (C62 `KernelMode`: `v_j ≠ 0 ∧ D_phys(q⋆_j) *ᵥ v_j = 0`). The right
   eigenvector at the pole.
4. **Left mode** `w_j : Fin n → ℝ` — left/Krein-adjoint kernel mode (see Q3),
   `wᵀ_j (J D_phys(q⋆_j)) = 0`.
5. **Energy slice / sheet label** `(q_0 axis, sign s_j ∈ {advanced, retarded})` —
   the variable in which the pole is a simple zero (see Q2), plus a discrete
   **sheet/branch label** distinguishing the two square-root sheets forced by the
   mass square root (Falsification ledger "Two-sheet structure"). Finite: a
   `Bool` (or `Fin 2`) for retarded/advanced × a `Bool`/`Fin 2` for the
   square-root sheet.
6. **Order** `m_j : ℕ` — pole order in `q_0` (we require simple, `m_j = 1`, as a
   checkable side condition; higher order is a downgrade flag).
7. **Krein grading** `J` (the modeled `kreinJ` of K2 / C22) restricted to the
   physical quotient `P_phys`.
8. **Classification** `kind : ZeroKind` and the C47/C48 booleans
   `gaugeCoupledPropagating`, plus the **residue** `Z_j⁻¹` (a real number; see Q4).

A **sheet** is then the finite collection of pole data sharing one
(retarded/advanced, square-root) label pair, on the physical quotient
`range P_phys`. The whole enumerated zero locus is a `List` of these records — the
same `List ZeroDatum` shape C47/C48/C59 already enumerate, enriched with `(q⋆_j,
v_j, w_j, q_0-axis, m_j)`.

**New Lean carrier (proposed):** a structure `PoleDatum n` bundling
`(loc, D : Sym n, v, w, sheet : Fin 2 × Fin 2, order : ℕ, base : ZeroDatum)` with
a field `isZero : IsPropagatorZero D` and `ker : KernelMode D v`. The existing
`ZeroDatum` is recovered as `PoleDatum.base`, so all C47–C63 predicates apply
unchanged.

---

## Q2. What is the correct energy variable `q_0` in the tetrahedral / null-edge setting?

The tetrahedral null edges `ℓ_a` (the four branch directions) are **null**, so
there is no single distinguished lattice time axis; the four `q_a = h·k(ℓ_a)` are
null-edge phases. The residue formula needs a variable in which "going around the
pole / crossing the cut" and "positive frequency" are well defined. Three honest
candidates and the recommended choice:

- **Naive choice (reject):** one lattice phase `q_a`. Wrong, because no single
  `q_a` is timelike; differentiating in `q_a` mixes the null directions and the
  branch projector, and the sign has no observer meaning.
- **Recommended choice:** the **observer energy** `q_0 := p·u`, the contraction of
  the covariant momentum `pCov(phaseU q)` (the `pCov`/`mink` data already in C69
  `TetrahedralNullBranch`) with a fixed timelike observer covector `u` (the P1
  observer-normalization frame). Concretely `q_0 = mink(pCov(phaseU q), u)` along
  the ray `q = q⋆ + q_0 · n_u`, where `n_u` is the dual null/observer direction.
  This is the Minkowski energy of the mode in the chosen frame; positive-frequency
  (retarded) means `Im q_0 → 0⁺`. The deformed dispersion shell
  `ε_a(k)² − |q_a(k)|² = m²` from `Sources/Null_Edge_Key_Conjectures.md` makes
  `ε ≡ q_0` the canonical energy.
- **Equivalent algebraic surrogate (for finite proofs):** parametrize the pole by
  a single real `t` along the energy ray and define `q_0 := t`, so
  `∂_{q_0} D_phys = (d/dt) D_phys(q⋆ + t n_u)|_{t=0}`. This keeps the residue a
  finite matrix derivative, no complex analysis required: the residue is a ratio
  of finite real bilinear forms (Q4).

**Decision for C74:** use the observer energy `q_0 = p·u` realized as the
directional derivative along the timelike observer ray; record the
retarded/advanced choice as the sheet `Bool`. State frame-independence of the
**sign** of the residue as a separate lemma (`residueSign_observer_invariant`):
under a change of timelike `u` within the forward cone the residue may rescale by
a positive factor (`∂_{q_0}` rescales by `du/dq_0 > 0`), so `sign Z_j` is
observer-independent even though `Z_j` is not. This is exactly the frame-relative
caveat flagged in the Falsification ledger, handled honestly: only the **sign** is
claimed invariant.

---

## Q3. How should left eigenvectors be defined: Hilbert adjoint, Krein adjoint, or retarded/advanced paired adjoint?

`D_phys` is an indefinite-metric (Krein) operator: the physical inner product is
the K2/C22 metric `J = kreinJ`, not the Euclidean one. Therefore:

- **Hilbert (Euclidean) adjoint `D_physᵀ`** — wrong norm. Its left eigenvectors
  measure Euclidean overlap and give residues with no Krein-sign meaning. Reject
  as the *physical* pairing (but keep available; see below).
- **Krein adjoint `D_phys^{[†]} := J⁻¹ D_physᵀ J`** — correct for residue
  positivity. The left eigenvector is `w_j` with `(D_phys^{[†]})(q⋆_j) w_j = 0`,
  equivalently `wᵀ_j (J D_phys(q⋆_j)) = 0`. This is the pairing in which the
  residue norm `wᵀ_j J (∂_{q_0} D_phys) v_j` is the **Krein** residue whose sign
  decides ghost vs. physical (C47/C48 `kreinResidue`).
- **Retarded/advanced paired adjoint** — needed only to *fix which* left null
  vector to take when the pole sits on the real axis (the `iε` prescription
  selects the retarded boundary value). It is not a different inner product; it is
  the **sheet selection** of Q1.5 that pairs `w_j` (advanced) with `v_j`
  (retarded) consistently. Encode as the sheet `Bool`; it changes `w_j` by the
  cut crossing, not the metric.

**Decision for C74:** left eigenvectors are **Krein-adjoint** kernel modes,
`wᵀ_j (J D_phys(q⋆_j)) = 0`, with the retarded/advanced sheet `Bool` fixing the
boundary value. On the physical quotient `range P_phys`, where `J` restricts to
`+1` (K2 `Pphys_kreinPositive`, `Pphys_krein_form`), the Krein adjoint reduces to
the Hilbert adjoint, so on the *retained* sector the two coincide — this is the
lemma `kreinAdjoint_eq_hilbert_on_physical` that lets all positivity be proved
against the ordinary transpose once we are inside `P_phys`.

---

## Q4. Residue positivity as `Z_j⁻¹ = w_j† J (∂_{q_0} D_phys) v_j` with `Z_j > 0`?

Yes — this is the central, finite formula, and it is the only certificate that
discharges ghost safety. Concretely:

Definition (finite real bilinear form):

```text
Zinv j := wᵀ_j  *  ( J  *  (∂_{q_0} D_phys)(q⋆_j) )  *ᵥ  v_j        -- a real number
```

with `∂_{q_0} D_phys` the directional energy derivative of Q2 and `J = kreinJ`.

- `Z_j := (Zinv j)⁻¹` is the **field-strength / residue** of the pole.
- **Residue positivity (the physical certificate):** `0 < Zinv j` for every pole
  `j` retained on the physical quotient, i.e. `wᵀ_j J (∂_{q_0} D_phys) v_j > 0`,
  equivalently `Z_j > 0`.

Why this is exactly the ghost test:

- The propagator near a simple pole is `≈ Z_j · (v_j wᵀ_j J) / (q_0 − q_0(j))`.
  The residue **numerator sign** is `sign Zinv j`. A wrong-sign (negative) residue
  is precisely a negative-Krein-norm propagating state — the Golterman–Shamir
  ghost. So `Zinv j > 0` ⇔ `kreinResidue > 0` of C47/C48 for that pole.
- Hence `PostGaugeResiduePositive` (Q6) ⇒ `KreinPositivePhysicalSector` /
  `GhostZeroSafe` of C47/C48/C59, *but not conversely from kinematic data* — it is
  the genuine dynamical input.

Required side conditions for the formula to be valid (each a finite checkable
obligation, listed so none is hidden):

1. **Simple pole:** `order m_j = 1` (else the residue is not the leading
   coefficient; downgrade flag if violated).
2. **Nondegenerate energy derivative on the mode:**
   `wᵀ_j J (∂_{q_0} D_phys) v_j ≠ 0` (the pole genuinely propagates in `q_0`); a
   zero value means a kinematical / non-propagating zero (C47 `kinematicalZero`),
   not a particle — handled by the C62 `CompositeRemovable` route, not by residue
   positivity.
3. **On the physical quotient:** `v_j, w_j ∈ range P_phys`, so the Krein form is
   positive-definite there (K2 `Pphys_krein_form`); discarded branches `{1,3}`
   are projected out (K2 `discarded_krein_negative`) and never contribute a pole.
4. **Post-gauge:** `D_phys` is the *gauge-coupled* symbol; the residue is computed
   at small coupling `g` and `sign Zinv j` must be stable for `0 < g ≤ g₀` — this
   is exactly the C47 `PostGaugeGhostSafe` weak-coupling threshold, now in residue
   form (Q6 `PostGaugeResiduePositive`).

Connection back to existing predicates (the bridge theorems to prove):

- `residuePositive_imp_kreinResidue_pos`: `0 < Zinv j → 0 < (base j).kreinResidue`
  (definitional identification of `kreinResidue` with `Zinv`).
- `residuePositive_imp_not_fatal`: `0 < Zinv j ∧ gaugeCoupledPropagating →
  ¬ (base j).IsFatalGhost` (reuses C47 `IsFatalGhost`).
- `residuePositive_spectrum_imp_ghostSafe`: all-poles residue positivity ⇒
  `GhostZeroSafe` (the C47 list-level predicate) ⇒ C59 clause 6.

---

## Q5. Which known C47/C48 ghost-zero predicates can be reused?

Reuse verbatim (no re-definition), all from
`PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety`:

- `ZeroKind` (incl. `physicalPole`, `kinematicalZero`, `compositeRemovable`,
  `kreinArtifact`, `fatalGhostZero`) and `ZeroKind.IsBenign` — pole classification.
- `ZeroDatum` (`kind`, `kreinResidue`, `gaugeCoupledPropagating`) — becomes
  `PoleDatum.base`; `Zinv` *is* the provenance of `kreinResidue`.
- `ZeroDatum.IsFatalGhost`, `ZeroDatum.WellClassified`,
  `ZeroDatum.not_fatal_of_wellClassified_of_label_ne` — the ghost criterion.
- `GhostZeroSafe (zs : List ZeroDatum)`, `ghostZeroSafe_iff`,
  `ghostZeroSafe_of_no_fatal_label` — spectrum-level safety; `ghostZeroSafe_iff`
  is the residue-control restatement the C74 formula plugs into.
- `KreinPositivePhysicalSector` — physical-pole positivity (the C74 conclusion).
- `PostGaugeGhostSafe`, `postGaugeGhostSafe_of_residue_nonneg`,
  `postGaugeGhostSafe_benign_example`, `postGaugeGhostSafe_violation_example` —
  the weak-coupling contract; `PostGaugeResiduePositive` (Q6) is its residue-form
  refinement and must imply it.
- Witnesses `ghostZeroWitness`, `physicalPoleWitness`,
  `ghostZeroWitness_isFatal` — for non-vacuity and separation tests.

From C62 `NullEdgeCompositeZeroEscape` (the *non*-residue escape route, for the
kinematical/composite-removable poles where the residue formula does not apply):

- `Sym n`, `IsPropagatorZero`, `KernelMode`, `singular_iff_kernelMode`.
- `AlgebraicEscape`, `CompositeRemovable`, `CompositeRemovable.not_fatal`,
  `CompositeRemovable.wellClassified`, `compositeRemovable_ghostSafe`.

From C59 `NullEdgeProjectedGateCRelease`: `ProjData`, the seven clauses (esp.
`GhostZeroSafe`, `ProjectedKreinPositive`, `KreinPositivePhysicalSector`),
`projected_gateC_release`, and the negative guardrails `index_not_sufficient`,
`chirality_not_ghostSafe`.

From C63 `NullEdgeProjectedGhostSafety`: `ResidueControlled`,
`residueControlled_iff_ghostSafe`, `ghostZeroSafe_of_postGaugeConst`,
`chirality_index_covariance_not_ghostSafe`. **`ResidueControlled` is the abstract
nonnegativity predicate;** C74 supplies its concrete content via the
bilinear-form residue `Zinv`. Prove
`postGaugeResiduePositive_imp_residueControlled`.

From K2 `NullEdgeKreinPositiveReleaseCriterion`: `kreinJ` (the `J` of the
formula), `KreinPositiveSector`, `Pphys`, `Pphys_kreinPositive`,
`Pphys_krein_form`, `physSel`, `discarded_krein_negative`,
`kreinPositive_sector_subset_phys`. These provide `J`, the physical quotient
`range P_phys`, and the fact that `J = +1` there.

From C69 `NullEdgeOffBranchZeroSector`: `OffBranchZero`, `offBranch_nonempty`,
`OffBranchSectorDischarged`, `offBranch_discharged_ghostSafe`,
`pSq_mink_eq_qform`. These say the residue obligation must be discharged on the
off-branch sector too, or those zeros routed to `CompositeRemovable`.

**Do not reuse as a safety certificate:** `flavoredIndex`, `flavoredIndex_aligned`
(C47); `ProjectedChiralityAligned` (C59); `DressedBranchProjector.GaugeCovariant`
(C61). The guardrail theorems already prove these do not imply safety; they enter
C74 only as *necessary-but-insufficient* companions, never as the residue input.

---

## Q6. Smallest Lean API for `PostGaugeResiduePositive`

Goal: the minimal set of declarations so that `PostGaugeResiduePositive` is (a)
stated as the finite residue-sign certificate, (b) provably implies the existing
ghost-safety predicates, and (c) is non-vacuous and non-trivial. Live in
`namespace PhysicsSM.Draft.NullEdgePostGaugeResidue`, `import Mathlib` plus the
six modules above. Sketch (`by sorry` for the subagent):

```lean
open PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety
open PhysicsSM.Draft.NullEdgeCompositeZeroEscape (Sym)
open PhysicsSM.Draft.NullEdgeProjectedGhostSafety (ResidueControlled)

/-- Minimal finite pole record: the energy-derivative symbol `dD := ∂_{q_0} D_phys`
at the pole, the Krein metric `J`, the right kernel mode `v`, the Krein-adjoint
left mode `w`, and the C47/C48 classification `base`. -/
structure ResiduePole (n : ℕ) where
  J    : Sym n                      -- Krein metric (kreinJ, restricted)
  dD   : Sym n                      -- ∂_{q_0} D_phys at the pole (Q2)
  v    : Fin n → ℝ                  -- right kernel mode
  w    : Fin n → ℝ                  -- left (Krein-adjoint) kernel mode (Q3)
  base : ZeroDatum                  -- reused C47/C48 carrier

/-- The residue inverse `Z⁻¹ = wᵀ J (∂_{q_0}D_phys) v` (Q4), a real number. -/
def ResiduePole.Zinv {n : ℕ} (p : ResiduePole n) : ℝ :=
  (p.w ⬝ᵥ ((p.J * p.dD) *ᵥ p.v))

/-- Residue positivity at one pole: `Z⁻¹ > 0`, i.e. `Z > 0`. -/
def ResiduePole.ResiduePositive {n : ℕ} (p : ResiduePole n) : Prop := 0 < p.Zinv

/-- The certificate the residue computes the C47 Krein residue. -/
def ResiduePole.ResidueConsistent {n : ℕ} (p : ResiduePole n) : Prop :=
  p.base.kreinResidue = p.Zinv

/-- Spectrum-level post-gauge residue positivity: at small gauge coupling every
gauge-coupled pole on the physical quotient has strictly positive residue. -/
def PostGaugeResiduePositive {n : ℕ} (ps : List (ResiduePole n)) : Prop :=
  ∀ p ∈ ps, p.base.gaugeCoupledPropagating = true → 0 < p.Zinv
```

Core theorems (the whole deliverable; each `by sorry` for the subagent):

```lean
-- 1. residue sign ⇒ not a fatal ghost (uses ResidueConsistent)
theorem ResiduePole.not_fatal_of_residuePositive {n} (p : ResiduePole n)
    (hc : p.ResidueConsistent) (hg : p.base.gaugeCoupledPropagating = true)
    (hZ : 0 < p.Zinv) : ¬ p.base.IsFatalGhost := by sorry

-- 2. spectrum residue positivity ⇒ C63 ResidueControlled on the bases
theorem postGaugeResiduePositive_imp_residueControlled {n}
    (ps : List (ResiduePole n)) (hc : ∀ p ∈ ps, p.ResidueConsistent)
    (h : PostGaugeResiduePositive ps) :
    ResidueControlled (ps.map ResiduePole.base) := by sorry

-- 3. hence GhostZeroSafe (via residueControlled_iff_ghostSafe)
theorem postGaugeResiduePositive_imp_ghostSafe {n}
    (ps : List (ResiduePole n)) (hc : ∀ p ∈ ps, p.ResidueConsistent)
    (h : PostGaugeResiduePositive ps) :
    GhostZeroSafe (ps.map ResiduePole.base) := by sorry

-- 4. Krein-adjoint = Hilbert-adjoint on the physical quotient (Q3 reduction)
theorem kreinAdjoint_eq_hilbert_on_physical {n} (p : ResiduePole n)
    (hJ : p.J * (??Pphys-style projector??) = (??...??)) : True := by sorry  -- shape TBD

-- 5. observer-sign invariance: rescaling ∂_{q_0} by c>0 preserves the sign (Q2)
theorem residueSign_scale_invariant {n} (p : ResiduePole n) {c : ℝ} (hc : 0 < c) :
    (0 < p.Zinv) ↔ (0 < ({ p with dD := c • p.dD } : ResiduePole n).Zinv) := by sorry

-- 6. non-vacuity: a benign pole has positive residue
theorem residuePositive_example : ∃ (p : ResiduePole 1), p.ResiduePositive := by sorry

-- 7. non-triviality / honesty: a wrong-sign residue is a fatal ghost
theorem residueNegative_isFatal_example :
    ∃ (p : ResiduePole 1), p.base.gaugeCoupledPropagating = true ∧ p.Zinv < 0 ∧
      p.ResidueConsistent ∧ p.base.IsFatalGhost := by sorry

-- 8. GUARDRAIL (must remain provable): index + chirality + covariance ⇏ residue positive
theorem residue_not_from_kinematics {n} :
    ∃ (ps : List (ResiduePole n)), ¬ PostGaugeResiduePositive ps := by sorry
```

Integration theorem (ties C74 into the C59 release certificate, replacing the
abstract clause 6 input by the concrete residue certificate):

```lean
-- residue positivity discharges C59 clause 6 (GhostZeroSafe) on the projected data
theorem projectedGateCRelease_from_wilson_residue {n}
    (d : NullEdgeProjectedGateCRelease.ProjData) (ps : List (ResiduePole n))
    (hzeros : d.zeros = ps.map ResiduePole.base)
    (hc : ∀ p ∈ ps, p.ResidueConsistent)
    (hRes : PostGaugeResiduePositive ps)
    (hNodal hProj hKer hChir hKrein hSpecies : _) :
    NullEdgeProjectedGateCRelease.ProjectedGateCRelease d := by sorry
```

This is the named target `projectedGateCRelease_from_wilson_residue` of Working
Plan §12.3.

API minimality notes:

- One structure `ResiduePole n`, one scalar `Zinv`, one per-pole `Prop`
  (`ResiduePositive`), one list `Prop` (`PostGaugeResiduePositive`), one
  consistency `Prop` (`ResidueConsistent`). Everything else reuses C47/C59/C63.
- `Zinv` uses only `Matrix.mulVec` and `dotProduct` (`⬝ᵥ`) — finite, decidable on
  concrete witnesses (`decide`/`norm_num`), so theorems 6/7 are immediate.
- The four side conditions of Q4 (simple pole, nondegenerate `Zinv`, on quotient,
  post-gauge) are exactly: `order = 1` (carry on `PoleDatum`, not needed in the
  minimal `ResiduePole`), `Zinv ≠ 0` (subsumed by `0 < Zinv`), `v,w ∈ range Pphys`
  (a hypothesis only where K2 is imported), and the `gaugeCoupledPropagating`
  guard already in `PostGaugeResiduePositive`.

---

## Sequencing / suggested proof order for the subagent

1. Add `ResiduePole`, `Zinv`, `ResiduePositive`, `ResidueConsistent`,
   `PostGaugeResiduePositive` (definitions only) and verify the file builds.
2. Prove theorems 6 and 7 (concrete `Fin 1` witnesses, `decide`/`norm_num`) —
   fast non-vacuity / honesty.
3. Prove theorem 1, then 2, then 3 (pure logic over the reused C47/C63 lemmas;
   theorem 3 = theorem 2 + `residueControlled_iff_ghostSafe`).
4. Prove theorem 5 (`mul_pos` / sign algebra) and state/settle theorem 4 once the
   `Pphys` projector shape is pinned against K2.
5. Prove guardrail theorem 8 (reuse `ghostZeroWitness`, residue `−1`).
6. Prove the integration theorem `projectedGateCRelease_from_wilson_residue`
   via C59 `projected_gateC_release` with clause 6 supplied by theorem 3.

Each step is a focused, single-concept lemma suitable for the theorem-proving
subagent; none asserts ghost safety from flavored index, projected chirality, or
gauge covariance — the only safety input anywhere is the residue-sign certificate
`PostGaugeResiduePositive`.

## Honesty ledger

- `D_phys`, the null-Wilson regulator `R_W`, and the gauge-coupled deformation are
  *modeled* inputs; the residue formula is exact given them, but inhabiting
  `PostGaugeResiduePositive` on the actual gauge-coupled symbol is the open
  dynamical obligation (the weak-coupling perturbation estimate). C74 reduces
  ghost safety **to** this certificate; it does not magically discharge it.
- Only the **sign** of the residue is claimed observer/frame-independent
  (theorem 5); the residue magnitude `Z_j` is frame-relative (Q2).
- All negative guardrails of C59/C63 remain in force and must continue to compile
  alongside the new module.
