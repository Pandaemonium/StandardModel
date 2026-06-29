import Mathlib

/-!
# NullEdgeOverlapReferenceImport

Design / API layer connecting the **null-edge-derived Hermitian Wilson kernel**
`H_ne` to the existing Gate C1 Draft spine via a *reference import*.

The strategy is **not** to solve overlap chiral gauge theory from scratch.
Instead we prove that `H_ne` lives in the *same gapped sign/index sector* as a
known Wilson/Neuberger overlap reference kernel `H_ref`, transported by a
norm-preserving similarity `S`:

```
H_refS = S H_ref S⁻¹ ,
H_t    = (1 - t) • H_refS + t • H_ne ,
σ_min(H_t) ≥ δ > 0 .
```

The sufficient first condition is the *below-margin* bound

```
‖H_ne - H_refS‖ ≤ ε < gap(H_refS).
```

## What is proved here (genuine Lean facts)

* `homotopy_lower_bound` / `gapped_homotopy` :
  the below-margin bound yields a **uniform spectral lower bound** `δ = gap − ε > 0`
  along the whole homotopy. This is the no-ghost inverse-gap requirement.
* `sector_import` : *given* the `SignStability` source contract, the sector
  signature (sign/index data) is constant along the gapped homotopy, hence
  `sig H_refS = sig H_ne`.

## What stays a *source contract* (NOT proved here)

Bundled in `SourceContracts` and `SignStabilityContract`:
Neuberger overlap construction, Ginsparg–Wilson algebra, HJL locality,
Lüscher determinant/measure, anomaly accounting. These are imported from the
physics literature; they are explicit hypotheses, never proved Lean theorems.

## Relation to existing Draft modules

* `GappedHomotopy.lean`   ← `homotopy_lower_bound`, `gapped_homotopy` realise its
  abstract κ-to-gapped-homotopy result for the affine path.
* `SignStability.lean`    ← supplies `SignStabilityContract`.
* `SpectralProjectorAPI.lean` ← supplies the concrete `SectorSignature.sig`
  (projector range/kernel dimension count); here it is an o p a q u e interface.
* `OperatorFreeze.lean`   ← `NullEdgeOverlapReferenceImport` is *independent of*
  but *exports into* `FrozenOverlap` / `BudgetDecomposition` (see
  `toFrozenInterface`): the import provides the gap budget `δ` those modules
  consume, rather than re-deriving freezing here.
* `CKMWilsonWindow.lean`  ← the mass-window / `gamma_free` style bounds feed the
  numeric value of `ε` and `gap` (the `below_margin`/`margin` fields).

This file makes **no claim** that the Standard Model chiral gauge theory is
solved, and makes **no claim** of local repo verification of the physics
contracts. Free / background-gauge / quantum layers are kept strictly separate
(`GateC1Layer`).
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1

open scoped BigOperators

/-! ## 1. Source-contract boundary -/

/-- Physics-literature contracts imported by the Gate C1 route. These are *named
o p a q u e propositions together with the assumption that they hold*; they are
**not** proved Lean facts. Keeping them as data (Prop-valued fields plus a
`holds` witness) prevents a source contract from masquerading as a theorem. -/
structure SourceContracts where
  /-- Neuberger overlap construction of `D_ov` from a Hermitian kernel. -/
  neubergerOverlap : Prop
  /-- Ginsparg–Wilson algebra `{D, γ₅} = a D γ₅ D`. -/
  gwAlgebra : Prop
  /-- Hernández–Jansen–Lüscher locality of the overlap operator. -/
  hjlLocality : Prop
  /-- Lüscher determinant / fermion measure construction. -/
  luscherDeterminantMeasure : Prop
  /-- Gauge-anomaly accounting / cancellation bookkeeping. -/
  anomalyAccounting : Prop
  /-- The contracts are assumed to hold (imported, not derived). -/
  holds : neubergerOverlap ∧ gwAlgebra ∧ hjlLocality ∧
      luscherDeterminantMeasure ∧ anomalyAccounting

/-! ## 2. Gap (no-ghost inverse-gap) predicate -/

/-- `GapBound gap A` : the self-adjoint kernel `A` has a spectral gap `gap` at 0,
expressed as the uniform lower bound `gap · ‖x‖ ≤ ‖A x‖`. This is exactly the
no-ghost inverse-gap requirement `σ_min(A) ≥ gap`. -/
def GapBound {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (gap : ℝ) (A : E →L[ℝ] E) : Prop :=
  ∀ x : E, gap * ‖x‖ ≤ ‖A x‖

/-! ## 3. The reference-import datum -/

/-- The reference-import package. It bundles the reference kernel `H_ref`, the
null-edge kernel `H_ne`, the norm-preserving similarity `S`, the transported
reference `H_refS = S H_ref S⁻¹`, and the quantitative gap / margin data.

It is deliberately **independent** of `OperatorFreeze.FrozenOverlap` and
`BudgetDecomposition` (it does not `extend` them): the import *produces* the gap
budget those modules *consume*. The export direction is given separately by
`toFrozenInterface`. -/
structure NullEdgeOverlapReferenceImport
    (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] where
  /-- Known Wilson/Neuberger overlap reference kernel (Hermitian). -/
  H_ref : E →L[ℝ] E
  /-- Null-edge-derived Hermitian Wilson kernel. -/
  H_ne : E →L[ℝ] E
  /-- Norm-preserving similarity transporting the reference frame. -/
  S : E ≃ₗᵢ[ℝ] E
  /-- Transported reference kernel `H_refS = S H_ref S⁻¹`. -/
  H_refS : E →L[ℝ] E
  /-- Conjugation relation, stated pointwise to avoid coercion friction. -/
  refS_apply : ∀ x, H_refS x = S (H_ref (S.symm x))
  /-- Reference spectral gap. -/
  gap : ℝ
  /-- Below-margin perturbation size. -/
  eps : ℝ
  /-- Positivity of the reference gap. -/
  gap_pos : 0 < gap
  /-- The transported reference is gapped (no-ghost inverse-gap). -/
  ref_gapped : GapBound gap H_refS
  /-- The null-edge kernel is within the perturbation margin. -/
  below_margin : ‖H_ne - H_refS‖ ≤ eps
  /-- Margin condition `ε < gap`. -/
  margin : eps < gap
  /-- Imported physics contracts. -/
  contracts : SourceContracts

namespace NullEdgeOverlapReferenceImport

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- The affine reference-import homotopy `H_t = (1 - t) • H_refS + t • H_ne`. -/
def homotopy (D : NullEdgeOverlapReferenceImport E) (t : ℝ) : E →L[ℝ] E :=
  (1 - t) • D.H_refS + t • D.H_ne

/-- The transported gap budget `δ = gap − ε`. -/
def delta (D : NullEdgeOverlapReferenceImport E) : ℝ := D.gap - D.eps

/-- `δ > 0` follows from the margin condition `ε < gap`: this is the surviving
no-ghost inverse-gap of the homotopy. -/
theorem delta_pos (D : NullEdgeOverlapReferenceImport E) : 0 < D.delta := by
  have := D.margin
  simp only [delta]
  linarith

/-! ## 4. Core provable theorem: below-margin ⇒ gapped homotopy -/

/-
**Gapped-homotopy lower bound (abstract).** If `A` is gapped with constant
`gap`, and `‖B − A‖ ≤ ε`, then every convex combination `(1 − t) • A + t • B`
with `t ∈ [0,1]` is gapped with constant `gap − ε`.

This is the realisation, for the affine path, of the abstract κ-to-gapped
homotopy result in `GappedHomotopy.lean`.
-/
theorem homotopy_lower_bound
    (A B : E →L[ℝ] E) {gap eps t : ℝ}
    (hA : GapBound gap A) (hAB : ‖B - A‖ ≤ eps)
    (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    GapBound (gap - eps) ((1 - t) • A + t • B) := by
  intro x
  have h_apply : ‖(1 - t) • A x + t • B x‖ ≥ gap * ‖x‖ - t * eps * ‖x‖ := by
    have h_apply : ‖(1 - t) • A x + t • B x‖ ≥ ‖A x‖ - ‖t • (B x - A x)‖ := by
      have := norm_sub_le ( ( 1 - t ) • A x + t • B x ) ( t • ( B x - A x ) ) ; simp_all +decide [ sub_smul, smul_sub ] ;
      convert this using 2 ; abel_nf;
    simp_all +decide [ norm_smul_of_nonneg ht0 ];
    nlinarith [ hA x, show ‖B x - A x‖ ≤ eps * ‖x‖ by simpa using ContinuousLinearMap.le_of_opNorm_le _ hAB x ];
  simp_all +decide [ mul_assoc, mul_comm ];
  nlinarith [ show 0 ≤ eps * ‖x‖ by exact mul_nonneg ( le_trans ( norm_nonneg _ ) hAB ) ( norm_nonneg _ ) ]

/-- **Gapped homotopy for the reference import.** The below-margin bound yields a
uniform spectral lower bound `δ = gap − ε > 0` along the entire homotopy. -/
theorem gapped_homotopy (D : NullEdgeOverlapReferenceImport E)
    {t : ℝ} (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    GapBound D.delta (D.homotopy t) := by
  simpa [homotopy, delta] using
    homotopy_lower_bound D.H_refS D.H_ne D.ref_gapped D.below_margin ht0 ht1

/-! ## 5. Sector signature and the sign/index import -/

/-- Abstract sector signature: the sign/index data of a gapped self-adjoint
kernel (e.g. `dim P₊ − dim P₋`, the overlap index). The actual computation is
delivered by `SpectralProjectorAPI.lean`; here it is an o p a q u e interface. -/
structure SectorSignature (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] where
  /-- The integer sector signature of a kernel. -/
  sig : (E →L[ℝ] E) → ℤ

/-- **Source contract (`SignStability.lean`).** Along any uniformly gap-bounded
homotopy the sector signature is constant. This is *not* proved here — it is the
sign-stability-under-below-margin-perturbations contract, consumed as a
hypothesis. -/
def SignStabilityContract (sg : SectorSignature E) : Prop :=
  ∀ (P : ℝ → (E →L[ℝ] E)) (δ : ℝ), 0 < δ →
    (∀ t ∈ Set.Icc (0 : ℝ) 1, GapBound δ (P t)) →
    sg.sig (P 0) = sg.sig (P 1)

/-- **Sector / sign / index import.** Given the sign-stability contract, the
sector signature is imported from the reference to the null-edge kernel:
`sig H_refS = sig H_ne`. The whole physical weight sits in `hstab` and in the
o p a q u e `sg`; this theorem only transports the signature along the *proved*
gapped homotopy. -/
theorem sector_import (D : NullEdgeOverlapReferenceImport E)
    (sg : SectorSignature E) (hstab : SignStabilityContract sg) :
    sg.sig D.H_refS = sg.sig D.H_ne := by
  have h := hstab D.homotopy D.delta D.delta_pos
    (fun t ht => D.gapped_homotopy ht.1 ht.2)
  simpa [homotopy] using h

/-! ## 6. Gate C1 layer stratification

The free / background-gauge / quantum layers are kept strictly separate.
Each layer's claim is exactly "same sector as the reference" *plus* the
additional source contracts that layer is entitled to invoke. No layer claims
the Standard Model is solved; the quantum layer is only as strong as the
(unproved) contracts it conjoins. -/

/-- The four Gate C1 layers. -/
inductive GateC1Layer
  /-- Pure formal sector-import statement (no gauge field). -/
  | formal
  /-- Null-edge route, free fermions. -/
  | NU_Free
  /-- Null-edge route in a fixed background gauge field. -/
  | NU_BackgroundGauge
  /-- Null-edge route with the dynamical gauge measure. -/
  | NU_Quantum
  deriving DecidableEq, Repr

/-- The claim attached to each layer. The sector equality is the *proved* core
(`sector_import`); each higher layer conjoins strictly more source contracts,
making the contract dependence explicit and monotone. -/
def GateC1Claim (D : NullEdgeOverlapReferenceImport E)
    (sg : SectorSignature E) : GateC1Layer → Prop
  | .formal => sg.sig D.H_refS = sg.sig D.H_ne
  | .NU_Free =>
      sg.sig D.H_refS = sg.sig D.H_ne ∧
      D.contracts.neubergerOverlap ∧ D.contracts.gwAlgebra
  | .NU_BackgroundGauge =>
      sg.sig D.H_refS = sg.sig D.H_ne ∧
      D.contracts.neubergerOverlap ∧ D.contracts.gwAlgebra ∧
      D.contracts.hjlLocality
  | .NU_Quantum =>
      sg.sig D.H_refS = sg.sig D.H_ne ∧
      D.contracts.neubergerOverlap ∧ D.contracts.gwAlgebra ∧
      D.contracts.hjlLocality ∧ D.contracts.luscherDeterminantMeasure ∧
      D.contracts.anomalyAccounting

/-- The free-layer claim forgets to the formal sector-import claim. -/
theorem GateC1Claim.formal_of_NU_Free (D : NullEdgeOverlapReferenceImport E)
    (sg : SectorSignature E) :
    GateC1Claim D sg .NU_Free → GateC1Claim D sg .formal :=
  And.left

/-- The background-gauge claim forgets to the free-layer claim. -/
theorem GateC1Claim.NU_Free_of_NU_BackgroundGauge
    (D : NullEdgeOverlapReferenceImport E) (sg : SectorSignature E) :
    GateC1Claim D sg .NU_BackgroundGauge → GateC1Claim D sg .NU_Free := by
  intro h
  exact ⟨h.1, h.2.1, h.2.2.1⟩

/-- The quantum claim forgets to the background-gauge claim. -/
theorem GateC1Claim.NU_BackgroundGauge_of_NU_Quantum
    (D : NullEdgeOverlapReferenceImport E) (sg : SectorSignature E) :
    GateC1Claim D sg .NU_Quantum → GateC1Claim D sg .NU_BackgroundGauge := by
  intro h
  exact ⟨h.1, h.2.1, h.2.2.1, h.2.2.2.1⟩

/-- At the `formal` layer the claim is fully discharged by `sector_import`
(given the sign-stability contract). Higher layers additionally require the
named source contracts and so are *not* proved unconditionally here. -/
theorem gateC1_formal (D : NullEdgeOverlapReferenceImport E)
    (sg : SectorSignature E) (hstab : SignStabilityContract sg) :
    GateC1Claim D sg .formal :=
  D.sector_import sg hstab

/-- The free layer is discharged from the proved sector import together with the
two source contracts it is entitled to invoke (taken from `D.contracts.holds`). -/
theorem gateC1_NU_Free (D : NullEdgeOverlapReferenceImport E)
    (sg : SectorSignature E) (hstab : SignStabilityContract sg) :
    GateC1Claim D sg .NU_Free :=
  ⟨D.sector_import sg hstab, D.contracts.holds.1, D.contracts.holds.2.1⟩

/-- The background-gauge layer is discharged from the proved sector import plus
the Neuberger, Ginsparg-Wilson, and HJL locality source contracts. -/
theorem gateC1_NU_BackgroundGauge (D : NullEdgeOverlapReferenceImport E)
    (sg : SectorSignature E) (hstab : SignStabilityContract sg) :
    GateC1Claim D sg .NU_BackgroundGauge := by
  rcases D.contracts.holds with ⟨hNeu, hGW, hHJL, _hMeasure, _hAnomaly⟩
  exact ⟨D.sector_import sg hstab, hNeu, hGW, hHJL⟩

/-- The quantum layer is discharged from the proved sector import plus all named
source contracts, including determinant/measure and anomaly accounting. -/
theorem gateC1_NU_Quantum (D : NullEdgeOverlapReferenceImport E)
    (sg : SectorSignature E) (hstab : SignStabilityContract sg) :
    GateC1Claim D sg .NU_Quantum := by
  rcases D.contracts.holds with ⟨hNeu, hGW, hHJL, hMeasure, hAnomaly⟩
  exact ⟨D.sector_import sg hstab, hNeu, hGW, hHJL, hMeasure, hAnomaly⟩

/-! ## 7. Export interface to OperatorFreeze

Rather than `extend`ing `FrozenOverlap` / `BudgetDecomposition`, the import
*exports* the data those modules consume: a gapped kernel (`homotopy 1 = H_ne`)
together with the surviving inverse-gap budget `δ > 0`. -/

/-- The data handed to `OperatorFreeze`: the frozen kernel and its positive gap
budget. (Interface stub matching the `FrozenOverlap`/`BudgetDecomposition` API.) -/
structure FrozenInterface (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] where
  /-- The kernel that is frozen / sign-projected downstream. -/
  kernel : E →L[ℝ] E
  /-- Its positive inverse-gap budget. -/
  budget : ℝ
  /-- Positivity of the budget (no-ghost requirement). -/
  budget_pos : 0 < budget
  /-- The kernel is gapped by the budget. -/
  kernel_gapped : GapBound budget kernel

/-- Export the reference import to the `OperatorFreeze` interface, with
`kernel = H_ne` and `budget = δ = gap − ε`. -/
def toFrozenInterface (D : NullEdgeOverlapReferenceImport E) : FrozenInterface E where
  kernel := D.H_ne
  budget := D.delta
  budget_pos := D.delta_pos
  kernel_gapped := by
    have h := D.gapped_homotopy (t := 1) (by norm_num) (le_refl 1)
    simpa [homotopy] using h

end NullEdgeOverlapReferenceImport
end GateC1
end NullEdge
end Draft
end PhysicsSM
