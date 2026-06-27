import Mathlib
import PhysicsSM.Draft.NullEdgeFureyPhiH
import PhysicsSM.Draft.NullEdgeFureyChiE
import PhysicsSM.Draft.NullEdgeFureyInternalSpectrum
import PhysicsSM.Algebra.Furey.ConjugateIdeal

/-!
# FUR-H7A — Narrow concrete `Φ_H` coordinate bridge

This file bridges the **abstract gauge-covariant internal Yukawa interface**
`Φ_H` of `PhysicsSM.Draft.NullEdgeFureyPhiH` to the **coordinate
occupation / internal-spectrum model** used by

* `PhysicsSM.Draft.NullEdgeFureyInternalSpectrum`
  (the eight-state Furey-`J` occupation lattice, charge multiset
  `fureyJChargeMultiset`), and
* `PhysicsSM.Algebra.Furey.ConjugateIdeal`
  (the eight-dimensional conjugate ideal `J*`, charges `qJ`/`qJstar`).

## What is built

We instantiate the abstract `Φ_H` carrier `H_L ⊕ H_R` with a small, fully
concrete **coordinate left/right finite-state model**:

```text
H_L = H_R = Hcoord := EuclideanSpace ℂ (Fin 8)
```

i.e. the left factor is the coordinate space of the Furey particle ideal `J`
(eight occupation states) and the right factor is the coordinate space of the
conjugate ideal `J*`.  The constant chirality-flip block is the concrete
nonzero coupling `Mcoord = id`, giving the off-diagonal operator
`PhiH_coord = phiH Mcoord`.

## What is proved (coordinate level only)

* `PhiH_coord_chiE_odd` — `Φ_H` is **off-diagonal / `χ_E`-odd**:
  `{χ_E, Φ_H} = 0`, in the abstract `IsOdd` sense of `NullEdgeFureyChiE`.
* `PhiH_coord_gammaS_even` — `Φ_H` is **`Γ_s`-even** (commutes with the internal
  restriction `1` of the spacetime chirality), in the abstract `IsEven` sense.
* `chiE_coord_isZ2Grading` — `χ_E` is a genuine `Z/2` grading (`χ_E² = 1`).
* `PhiH_coord_sign_dichotomy` — the `±Φ_H²` super-Dirac sign dichotomy, obtained
  by feeding the two facts above into `NullEdgeFureyChiE.sign_bridge_with_grading`.
* `PhiH_coord_ne_zero` — the bridge is **non-vacuous**: the constructed `Φ_H` is
  a genuinely nonzero off-diagonal block.

## Gauge covariance: a named conditional bridge

Full gauge covariance is supplied **conditionally**, exactly as the abstract
interface demands: the data of a gauge representation `(ρ_L, ρ_R)` together with
the named intertwining hypotheses (`intertwine`, `intertwine_adj`) is packaged in
`CoordinateGaugeData`, and `coordinate_conditional_bridge` proves the full
bundled `GaugeCovariantPhiH.isProperPhiH` correctness package from it.  A
concrete non-vacuity witness (`trivialGaugeData`, the identity gauge action) is
provided so the conditional theorem is known to be inhabited.

## Bridge to the occupation / conjugate-ideal charges

* `coordinate_charge_conjugation` — the left (particle) and right (antiparticle)
  coordinate charges satisfy `q_R = -q_L`, reusing
  `ConjugateIdeal.qJstar_eq_neg_qJ` (charge conjugation across the off-diagonal
  block).
* `coordinate_left_charge_multiset` — the left coordinate charge multiset is
  exactly `NullEdgeFureyInternalSpectrum.fureyJChargeMultiset`, the computed
  Furey-`J` occupation spectrum.

## Claim boundary (honoured)

* This is **coordinate-level only**.  We do *not* touch the live octonion / `Jbar`
  bridge, no `ℂ⊗𝕆` algebra, no ladder operators.
* `Mcoord = id` is an *arbitrary* nonzero constant coupling; no Yukawa eigenvalues
  are derived.
* The all-left occupation/charge basis is **not** identified with the physical
  Dirac `L ⊕ R` kinetic basis; we only reuse its finite charge tables as the
  coordinate labels of the two chiral factors, matching the guardrail already
  documented in `NullEdgeFureyPhiH` and `NullEdgeFureyInternalSpectrum`.
* No new axioms; everything is finite linear algebra plus the two imported
  charge tables.
-/

namespace PhysicsSM.Draft.FureyPhiHCoordinateBridge

open PhysicsSM.Draft.FureyPhiH
open PhysicsSM.NullEdge.FureyChiE
open scoped ComplexConjugate

/-! ## 1. The coordinate left/right finite-state carrier -/

/-- The coordinate space of one eight-state Furey ideal, used for **both** the
left (particle `J`) and right (antiparticle `J*`) chiral factors. -/
abbrev Hcoord : Type := EuclideanSpace ℂ (Fin 8)

/-- The concrete constant chirality-flip block `M : H_R →ₗ[ℂ] H_L`.  We take the
simplest nonzero gauge-neutral coupling, the identity; the structural facts below
hold for *any* `M`. -/
noncomputable def Mcoord : Hcoord →ₗ[ℂ] Hcoord := LinearMap.id

/-- The concrete coordinate internal Yukawa / chirality-flip operator
`Φ_H = [[0, M],[Mᴴ,0]]` on `H_L ⊕ H_R`. -/
noncomputable def PhiH_coord : Module.End ℂ (Hcoord × Hcoord) := phiH Mcoord

/-! ## 2. Off-diagonality (`χ_E`-oddness), `Γ_s`-evenness, grading -/

/-- `χ_E` is a genuine `Z/2` grading on the coordinate carrier: `χ_E² = 1`. -/
theorem chiE_coord_isZ2Grading :
    IsZ2Grading (chiE : Module.End ℂ (Hcoord × Hcoord)) :=
  chiE_sq

/-- **Off-diagonal / `χ_E`-odd.** `Φ_H` anticommutes with the internal chirality
grading `χ_E`, in the abstract `IsOdd` sense of `NullEdgeFureyChiE`:
`{χ_E, Φ_H} = 0`. -/
theorem PhiH_coord_chiE_odd :
    IsOdd (chiE : Module.End ℂ (Hcoord × Hcoord)) PhiH_coord :=
  phiH_chiE_odd Mcoord

/-- **`Γ_s`-even.** `Φ_H` commutes with the internal restriction `1` of the
spacetime chirality `Γ_s`, in the abstract `IsEven` sense of
`NullEdgeFureyChiE`. -/
theorem PhiH_coord_gammaS_even :
    IsEven (1 : Module.End ℂ (Hcoord × Hcoord)) PhiH_coord :=
  phiH_gammaS_even Mcoord

/-- `1` is a (trivial) `Z/2` grading: the internal restriction of `Γ_s`. -/
theorem gammaS_coord_isZ2Grading :
    IsZ2Grading (1 : Module.End ℂ (Hcoord × Hcoord)) := by
  simp [IsZ2Grading]

/-- **Super-Dirac `±Φ_H²` sign dichotomy at the coordinate level.**  Pairing
`Φ_H` with the (commuting) spacetime chirality `Γ_s` gives the physical `+Φ_H²`;
pairing it with the (anticommuting) internal chirality `χ_E` gives the tachyonic
`−Φ_H²`.  Obtained by feeding the two structural facts above into the abstract
`NullEdgeFureyChiE.sign_bridge_with_grading`. -/
theorem PhiH_coord_sign_dichotomy :
    ((1 : Module.End ℂ (Hcoord × Hcoord)) * PhiH_coord) *
        (1 * PhiH_coord) = PhiH_coord * PhiH_coord ∧
      (chiE * PhiH_coord) * (chiE * PhiH_coord) =
        -(PhiH_coord * PhiH_coord) :=
  sign_bridge_with_grading 1 chiE PhiH_coord
    gammaS_coord_isZ2Grading chiE_coord_isZ2Grading
    PhiH_coord_gammaS_even PhiH_coord_chiE_odd

/-! ## 3. Non-vacuity: the off-diagonal block is genuinely nonzero -/

/-- The constructed `Φ_H` is a **nonzero** off-diagonal block: it flips a nonzero
right-chiral state to a nonzero left-chiral state.  So the `χ_E`-oddness above is
not vacuous. -/
theorem PhiH_coord_ne_zero : PhiH_coord ≠ 0 := by
  intro h
  obtain ⟨v, hv⟩ := exists_ne (0 : Hcoord)
  have hkey : PhiH_coord ((0 : Hcoord), v) = 0 := by rw [h]; rfl
  rw [PhiH_coord, phiH_apply] at hkey
  have h1 : Mcoord v = 0 := congrArg Prod.fst hkey
  rw [Mcoord] at h1
  simp only [LinearMap.id_coe, id_eq] at h1
  exact hv h1

/-! ## 4. Conditional gauge-covariant bridge -/

/-- **Named coordinate gauge-covariance datum.**  A gauge representation
`(ρ_L, ρ_R)` of a group `G` on the two chiral factors, together with the two
intertwining hypotheses that make the constant block `Mcoord` a gauge
intertwiner.  These are exactly the hypotheses required to instantiate the
abstract `GaugeCovariantPhiH` interface. -/
structure CoordinateGaugeData (G : Type*) [Monoid G] where
  /-- Gauge representation on the left chiral factor. -/
  rhoL : G → Module.End ℂ Hcoord
  /-- Gauge representation on the right chiral factor. -/
  rhoR : G → Module.End ℂ Hcoord
  /-- `Mcoord` is a gauge intertwiner. -/
  intertwine : ∀ g, rhoL g ∘ₗ Mcoord = Mcoord ∘ₗ rhoR g
  /-- Adjoint intertwining relation (gauge action is chirality-diagonal). -/
  intertwine_adj :
    ∀ g, rhoR g ∘ₗ LinearMap.adjoint Mcoord = LinearMap.adjoint Mcoord ∘ₗ rhoL g

/-- Package a coordinate gauge datum into the abstract `GaugeCovariantPhiH`. -/
noncomputable def CoordinateGaugeData.toDatum
    {G : Type*} [Monoid G] (d : CoordinateGaugeData G) :
    GaugeCovariantPhiH Hcoord Hcoord G where
  M := Mcoord
  rhoL := d.rhoL
  rhoR := d.rhoR
  intertwine := d.intertwine
  intertwine_adj := d.intertwine_adj

/-- **Conditional bridge theorem.**  From any coordinate gauge datum the
resulting `Φ_H`:
1. is `χ_E`-odd;
2. is `Γ_s`-even (commutes with the internal `1`);
3. is gauge-covariant for every group element;
4. has `Φ_H²` equal to the block-diagonal checkerboard mass block.

This is the abstract `GaugeCovariantPhiH.isProperPhiH` correctness package,
specialised to the coordinate carrier. -/
theorem coordinate_conditional_bridge
    {G : Type*} [Monoid G] (d : CoordinateGaugeData G) :
    (chiE * d.toDatum.op = -(d.toDatum.op * chiE))
      ∧ ((1 : Module.End ℂ (Hcoord × Hcoord)) * d.toDatum.op = d.toDatum.op * 1)
      ∧ (∀ g, d.toDatum.act g * d.toDatum.op = d.toDatum.op * d.toDatum.act g)
      ∧ (d.toDatum.op * d.toDatum.op =
          LinearMap.prodMap (Mcoord ∘ₗ LinearMap.adjoint Mcoord)
            (LinearMap.adjoint Mcoord ∘ₗ Mcoord)) :=
  d.toDatum.isProperPhiH

/-- **Non-vacuity of the conditional bridge.**  The identity gauge action
(`ρ_L = ρ_R = 1`) is a coordinate gauge datum for any monoid `G`, so the
hypotheses of `coordinate_conditional_bridge` are inhabited. -/
noncomputable def trivialGaugeData (G : Type*) [Monoid G] : CoordinateGaugeData G where
  rhoL := fun _ => LinearMap.id
  rhoR := fun _ => LinearMap.id
  intertwine := by intro g; simp
  intertwine_adj := by intro g; simp

/-! ## 5. Bridge to the occupation / conjugate-ideal charges -/

/-- The left (particle) coordinate charge label of basis state `i`: the Furey-`J`
electric charge `qJ` reproduced from `ConjugateIdeal`. -/
def chargeL (i : Fin 8) : ℚ := PhysicsSM.Algebra.Furey.ConjugateIdeal.qJ i

/-- The right (antiparticle) coordinate charge label of basis state `i`: the
conjugate-ideal charge `qJstar`. -/
def chargeR (i : Fin 8) : ℚ := PhysicsSM.Algebra.Furey.ConjugateIdeal.qJstar i

/-- **Charge conjugation across the off-diagonal block.**  The right-chiral
(antiparticle) coordinate charges are the negatives of the left-chiral (particle)
charges, `q_R = -q_L`; this is `ConjugateIdeal.qJstar_eq_neg_qJ`. -/
theorem coordinate_charge_conjugation (i : Fin 8) : chargeR i = - chargeL i :=
  PhysicsSM.Algebra.Furey.ConjugateIdeal.qJstar_eq_neg_qJ i

/-- **Bridge to the occupation spectrum.**  The multiset of left-chiral
coordinate charges is exactly the computed Furey-`J` occupation charge multiset
`fureyJChargeMultiset` of `NullEdgeFureyInternalSpectrum`. -/
theorem coordinate_left_charge_multiset :
    (((List.finRange 8).map chargeL : List ℚ) : Multiset ℚ) =
      PhysicsSM.NullEdge.FureyJ.fureyJChargeMultiset := by
  native_decide

end PhysicsSM.Draft.FureyPhiHCoordinateBridge
