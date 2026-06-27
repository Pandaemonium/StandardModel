import PhysicsSM.Spinor.PluckerMass

/-!
# Spinor.PluckerObstruction

Canonical-obstruction packaging of the finite Pluecker mass (job B6).

The trusted module `PhysicsSM.Spinor.PluckerMass` proves the finite Pluecker
mass identity

```text
det(sum_i psi_i psi_i^dagger) = sum_{i<j} |psi_i wedge psi_j|^2,
```

together with the masslessness/collinearity criteria.  This module promotes
that identity to the *first canonical masslessness-obstruction instance* of the
null-edge program: a nonnegative real scalar `B_Pl` attached to a visible null
configuration that vanishes exactly on the massless (zero-spread) locus.

Claim boundary (matches the P1 guardrail): this does **not** assert that all
mass is Pluecker spread.  It packages the finite kinematic statement
"massless iff the visible null directions are collinear, with the Pluecker
determinant/spread as the invariant accounting scalar".

The determinant, trace and observer-normalized mass conventions are kept as
*separate* definitions elsewhere; here `B_Pl` is fixed to be the **unnormalized
determinant/spread invariant** (the real part of the momentum determinant).

Status: trusted, no `s o r r y`.
-/

noncomputable section

namespace PhysicsSM.Spinor.PluckerObstruction

open Matrix Complex
open PhysicsSM.Spinor.PluckerMass

/-! ## The canonical masslessness-obstruction interface -/

/--
A canonical masslessness-obstruction on a type of visible configurations
`Config`: a nonnegative real scalar `obstruction` together with a `Massless`
predicate, such that the scalar vanishes exactly on the massless locus.

This is the small reusable wrapper requested by B6.  It is deliberately
minimal: it records only the two facts that make a scalar an *obstruction to
masslessness* — nonnegativity and the vanishing/massless equivalence.
-/
structure MasslessObstruction (Config : Type*) where
  /-- The nonnegative real obstruction scalar `B`. -/
  obstruction : Config → ℝ
  /-- The masslessness predicate the obstruction certifies. -/
  Massless : Config → Prop
  /-- The obstruction is nonnegative. -/
  obstruction_nonneg : ∀ c, 0 ≤ obstruction c
  /-- The obstruction vanishes exactly on the massless locus. -/
  vanishes_iff_massless : ∀ c, obstruction c = 0 ↔ Massless c

/-! ## Two-edge Pluecker obstruction -/

/-- The two-edge Pluecker obstruction `B_Pl`: the squared modulus of the wedge. -/
def twoEdgeObstruction (e : CSpinor × CSpinor) : ℝ :=
  Complex.normSq (spinorWedge e.1 e.2)

/-- Two-edge masslessness: the two visible null directions are collinear. -/
def TwoEdgeMassless (e : CSpinor × CSpinor) : Prop :=
  spinorWedge e.1 e.2 = 0

/-- The two-edge Pluecker obstruction is the real part of the determinant mass. -/
theorem twoEdgeObstruction_eq_det_re (e : CSpinor × CSpinor) :
    twoEdgeObstruction e = ((twoEdgeMomentum e.1 e.2).det).re := by
  rw [two_edge_plucker_mass_identity, complexAbsSq_eq_ofReal_normSq]
  rfl

/-- The canonical two-edge Pluecker obstruction instance `B_Pl`. -/
def bPlTwoEdge : MasslessObstruction (CSpinor × CSpinor) where
  obstruction := twoEdgeObstruction
  Massless := TwoEdgeMassless
  obstruction_nonneg := fun _ => Complex.normSq_nonneg _
  vanishes_iff_massless := fun e => by
    simp only [twoEdgeObstruction, TwoEdgeMassless, Complex.normSq_eq_zero]

/-! ## Finite bundle Pluecker obstruction -/

/-- The finite-bundle Pluecker obstruction `B_Pl`: total pairwise squared spread. -/
def bundleObstruction {n : Nat} (psi : Fin n → CSpinor) : ℝ :=
  finPairwisePluckerMassReal psi

/-- The bundle obstruction is the real part of the determinant mass. -/
theorem bundleObstruction_eq_det_re {n : Nat} (psi : Fin n → CSpinor) :
    bundleObstruction psi = ((finBundleMomentum psi).det).re := by
  rw [bundleObstruction, fin_bundle_det_eq_ofReal_pluckerMassReal]
  simp

/-- The bundle obstruction vanishes exactly when all pairwise wedges vanish. -/
theorem bundleObstruction_eq_zero_iff {n : Nat} (psi : Fin n → CSpinor) :
    bundleObstruction psi = 0 ↔ PairwiseWedgeZero psi := by
  rw [bundleObstruction]
  have h : (finPairwisePluckerMassReal psi : ℂ) = 0 ↔ finPairwisePluckerMassReal psi = 0 :=
    Complex.ofReal_eq_zero
  rw [← h, ← finPairwisePluckerMass_eq_ofReal,
    finPairwisePluckerMass_eq_zero_iff_pair_terms_zero,
    pair_terms_zero_iff_pairwise]

/-- The canonical finite-bundle Pluecker obstruction instance `B_Pl`. -/
def bPlBundle (n : Nat) : MasslessObstruction (Fin n → CSpinor) where
  obstruction := bundleObstruction
  Massless := PairwiseWedgeZero
  obstruction_nonneg := fun psi => finPairwisePluckerMassReal_nonneg psi
  vanishes_iff_massless := fun psi => bundleObstruction_eq_zero_iff psi

/--
Collinearity reading of the bundle obstruction: for a configuration with a
chosen nonzero base spinor, `B_Pl = 0` exactly when every spinor is a scalar
multiple of the base (projective collinearity).
-/
theorem bundleObstruction_eq_zero_iff_common_direction
    {n : Nat} (psi : Fin n → CSpinor) (base : Fin n)
    (hbase : psi base 0 ≠ 0 ∨ psi base 1 ≠ 0) :
    bundleObstruction psi = 0 ↔
      ∃ c : Fin n → ℂ, ∀ i : Fin n, psi i = c i • psi base := by
  rw [bundleObstruction_eq_zero_iff]
  exact pairwise_wedge_zero_iff_common_direction psi base hbase

end PhysicsSM.Spinor.PluckerObstruction

end
