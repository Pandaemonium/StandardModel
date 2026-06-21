import PhysicsSM.Spinor.PluckerMass

/-!
# Spinor.TwistorPluckerMass

Trusted finite twistor-chart wrappers for the Pluecker mass identities.

This module packages the spinor chart used by the null-edge causal graph
program:

```text
Z = (omega^A, pi_A')
```

Only the `pi` spinor is used in the finite mass identities.  The `omega`
field is retained so later incidence wrappers can extend the chart without
changing this mass-facing API.

Convention and claim boundary:
* dotted spinors use the same concrete carrier `Fin 2 -> ℂ` as visible
  spinors in `PhysicsSM.Spinor.PluckerMass`;
* `infinityTwistorPairing Z W` is defined as the Pluecker wedge of `Z.pi`
  and `W.pi`;
* determinant and trace-pairing normalizations are kept as separate explicit
  definitions;
* this is not a formalization of projective twistor space, twistor cohomology,
  the Penrose transform, or incidence geometry.

Sources and provenance:
* `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
* `AgentTasks/null-edge-overnight-synthesis-aristotle-2026-06-21.md`
* Promoted from the no-s o r r y draft modules
  `PhysicsSM.Draft.TwistorPluckerMass` and
  `PhysicsSM.Draft.NullEdgeOvernightSynthesisAristotle` after semantic review.

Status: trusted, no `s o r r y`.
-/

noncomputable section

namespace PhysicsSM.Spinor.TwistorPluckerMass

open Matrix Complex
open PhysicsSM.Spinor.PluckerMass

/-! ## Spinor chart for twistors -/

/--
A twistor represented only by the two spinor columns needed for the finite
mass calculation.
-/
structure SpinorChartTwistor where
  omega : CSpinor
  pi : CSpinor

/--
The spinor part of the infinity-twistor pairing in this chart.

With the convention `Z = (omega^A, pi_A')`, this is the antisymmetric
contraction `epsilon^{A'B'} pi_A' eta_B'`.  In this concrete chart it is the
Pluecker wedge of the two `pi` spinors.
-/
def infinityTwistorPairing
    (Z W : SpinorChartTwistor) : ℂ :=
  spinorWedge Z.pi W.pi

/-- The squared mass invariant carried by a pair of chart twistors. -/
def twoTwistorMassInvariant
    (Z W : SpinorChartTwistor) : ℂ :=
  complexAbsSq (infinityTwistorPairing Z W)

/-- The visible momentum matrix carried by two chart twistors. -/
def twoTwistorMomentum
    (Z W : SpinorChartTwistor) : Matrix (Fin 2) (Fin 2) ℂ :=
  twoEdgeMomentum Z.pi W.pi

/--
Two-twistor/Plucker matching in the spinor chart.

The spinor part of the two-twistor mass invariant is exactly the Pluecker
mass contribution of the two visible null-spinor edges.
-/
theorem two_twistor_mass_invariant_eq_plucker
    (Z W : SpinorChartTwistor) :
    twoTwistorMassInvariant Z W =
      complexAbsSq (spinorWedge Z.pi W.pi) := rfl

/--
The determinant mass of the visible two-twistor momentum equals the squared
infinity-twistor spinor pairing.
-/
theorem two_twistor_momentum_det_eq_massInvariant
    (Z W : SpinorChartTwistor) :
    (twoTwistorMomentum Z W).det = twoTwistorMassInvariant Z W := by
  exact two_edge_plucker_mass_identity Z.pi W.pi

/-! ## Mass-normalization convention bridges -/

/-- Determinant-convention mass square for two chart twistors. -/
def twoTwistorMassSqDetConvention
    (Z W : SpinorChartTwistor) : ℂ :=
  (twoTwistorMomentum Z W).det

/--
Trace-pairing-convention mass square for two chart twistors, with the factor
`2` kept explicit.
-/
def twoTwistorMassSqTraceConvention
    (Z W : SpinorChartTwistor) : ℂ :=
  2 * (twoTwistorMomentum Z W).det

/-- The determinant convention is exactly the squared twistor spinor pairing. -/
theorem twoTwistorMassSqDetConvention_eq_massInvariant
    (Z W : SpinorChartTwistor) :
    twoTwistorMassSqDetConvention Z W = twoTwistorMassInvariant Z W := by
  exact two_twistor_momentum_det_eq_massInvariant Z W

/-- The trace-pairing convention differs by the explicit factor `2`. -/
theorem twoTwistorMassSqTraceConvention_eq_two_massInvariant
    (Z W : SpinorChartTwistor) :
    twoTwistorMassSqTraceConvention Z W =
      2 * twoTwistorMassInvariant Z W := by
  unfold twoTwistorMassSqTraceConvention
  rw [two_twistor_momentum_det_eq_massInvariant]

/-! ## Rescaling -/

/-- Rescale both spinor entries of a chart twistor by a complex scalar. -/
def rescaleTwistor (a : ℂ) (Z : SpinorChartTwistor) :
    SpinorChartTwistor where
  omega := a • Z.omega
  pi := a • Z.pi

/-- The infinity-twistor spinor pairing is bilinear under chart rescalings. -/
theorem infinityTwistorPairing_rescale
    (a b : ℂ) (Z W : SpinorChartTwistor) :
    infinityTwistorPairing (rescaleTwistor a Z) (rescaleTwistor b W) =
      (a * b) * infinityTwistorPairing Z W := by
  unfold infinityTwistorPairing rescaleTwistor spinorWedge
  simp [smul_eq_mul]
  ring

/-- Squared two-twistor mass scales by the squared moduli of chart rescalings. -/
theorem twoTwistorMassInvariant_rescale
    (a b : ℂ) (Z W : SpinorChartTwistor) :
    twoTwistorMassInvariant (rescaleTwistor a Z) (rescaleTwistor b W) =
      complexAbsSq a * complexAbsSq b * twoTwistorMassInvariant Z W := by
  unfold twoTwistorMassInvariant
  rw [infinityTwistorPairing_rescale]
  unfold complexAbsSq
  simp only [map_mul]
  ring

/-! ## Finite multi-twistor charts -/

/-- A finite family of spinor-chart twistors. -/
structure MultiTwistorChart (n : Nat) where
  twistor : Fin n -> SpinorChartTwistor

/-- The visible momentum matrix of a finite multi-twistor chart. -/
def multiTwistorMomentum {n : Nat} (Z : MultiTwistorChart n) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  finBundleMomentum fun i => (Z.twistor i).pi

/-- The total pairwise infinity-twistor spinor mass of a finite chart. -/
def multiTwistorPairwiseMass {n : Nat} (Z : MultiTwistorChart n) : ℂ :=
  ∑ p ∈ finPairIndexSet n,
    complexAbsSq
      (infinityTwistorPairing (Z.twistor p.1) (Z.twistor p.2))

/--
Multi-twistor/Plucker matching in the spinor chart.

The determinant mass of the visible multi-twistor momentum is exactly the sum
of squared pairwise infinity-twistor spinor pairings.
-/
theorem multi_twistor_momentum_det_eq_pairwiseMass
    {n : Nat} (Z : MultiTwistorChart n) :
    (multiTwistorMomentum Z).det = multiTwistorPairwiseMass Z := by
  exact fin_bundle_plucker_mass_identity fun i => (Z.twistor i).pi

/-- Determinant-convention mass square for a finite multi-twistor chart. -/
def multiTwistorMassSqDetConvention {n : Nat}
    (Z : MultiTwistorChart n) : ℂ :=
  (multiTwistorMomentum Z).det

/-- Trace-pairing-convention mass square for a finite multi-twistor chart. -/
def multiTwistorMassSqTraceConvention {n : Nat}
    (Z : MultiTwistorChart n) : ℂ :=
  2 * (multiTwistorMomentum Z).det

/--
The determinant-convention multi-twistor mass is the total pairwise squared
infinity-twistor spinor pairing.
-/
theorem multiTwistorMassSqDetConvention_eq_pairwiseMass
    {n : Nat} (Z : MultiTwistorChart n) :
    multiTwistorMassSqDetConvention Z = multiTwistorPairwiseMass Z := by
  exact multi_twistor_momentum_det_eq_pairwiseMass Z

/--
The trace-pairing convention differs from the determinant convention by the
explicit factor `2`.
-/
theorem multiTwistorMassSqTraceConvention_eq_two_pairwiseMass
    {n : Nat} (Z : MultiTwistorChart n) :
    multiTwistorMassSqTraceConvention Z =
      2 * multiTwistorPairwiseMass Z := by
  unfold multiTwistorMassSqTraceConvention
  rw [multi_twistor_momentum_det_eq_pairwiseMass]

/-! ## Multi-twistor rescaling and massless loci -/

/-- Independently rescale every chart twistor in a finite multi-twistor chart. -/
def rescaleMultiTwistor {n : Nat} (a : Fin n -> ℂ)
    (Z : MultiTwistorChart n) : MultiTwistorChart n where
  twistor i := rescaleTwistor (a i) (Z.twistor i)

/-- Uniform scalar rescaling of a finite multi-twistor chart. -/
def rescaleMultiTwistorConst {n : Nat} (a : ℂ)
    (Z : MultiTwistorChart n) : MultiTwistorChart n :=
  rescaleMultiTwistor (fun _ => a) Z

/--
Independent rescaling law for finite multi-twistor pairwise mass.  Each pair
term scales by the squared moduli of the two scalar factors.
-/
theorem multiTwistorPairwiseMass_rescale
    {n : Nat} (a : Fin n -> ℂ) (Z : MultiTwistorChart n) :
    multiTwistorPairwiseMass (rescaleMultiTwistor a Z) =
      ∑ p ∈ finPairIndexSet n,
        complexAbsSq (a p.1) * complexAbsSq (a p.2) *
          complexAbsSq
            (infinityTwistorPairing (Z.twistor p.1) (Z.twistor p.2)) := by
  refine Finset.sum_congr rfl fun p hp => ?_
  convert congr_arg complexAbsSq
      (infinityTwistorPairing_rescale
        (a p.1) (a p.2) (Z.twistor p.1) (Z.twistor p.2)) using 1
  simp [complexAbsSq, mul_assoc, mul_comm, mul_left_comm]

/-- Uniform scalar rescaling scales finite multi-twistor mass quadratically. -/
theorem multiTwistorPairwiseMass_rescale_const
    {n : Nat} (a : ℂ) (Z : MultiTwistorChart n) :
    multiTwistorPairwiseMass (rescaleMultiTwistorConst a Z) =
      complexAbsSq a ^ 2 * multiTwistorPairwiseMass Z := by
  convert multiTwistorPairwiseMass_rescale (fun _ => a) Z using 1
  rw [← Finset.mul_sum _ _ _, multiTwistorPairwiseMass]
  ring

/-- Two-twistor mass vanishes exactly when the two momentum spinors are collinear. -/
theorem twoTwistorMassInvariant_eq_zero_iff_pi_collinear
    (Z W : SpinorChartTwistor)
    (hZ : Z.pi 0 ≠ 0 ∨ Z.pi 1 ≠ 0) :
    twoTwistorMassInvariant Z W = 0 ↔
      ∃ c : ℂ, W.pi = c • Z.pi := by
  rw [twoTwistorMassInvariant, infinityTwistorPairing,
    complexAbsSq_eq_zero_iff]
  exact spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero Z.pi W.pi hZ

/--
Finite multi-twistor mass vanishes exactly when all momentum spinors share a
common direction, assuming the chosen base spinor is nonzero.
-/
theorem multiTwistorPairwiseMass_eq_zero_iff_common_pi_direction
    {n : Nat} (Z : MultiTwistorChart n) (base : Fin n)
    (hbase : (Z.twistor base).pi 0 ≠ 0 ∨ (Z.twistor base).pi 1 ≠ 0) :
    multiTwistorPairwiseMass Z = 0 ↔
      ∃ c : Fin n -> ℂ,
        ∀ i : Fin n, (Z.twistor i).pi = c i • (Z.twistor base).pi := by
  rw [← multi_twistor_momentum_det_eq_pairwiseMass]
  exact fin_bundle_mass_zero_iff_common_direction
    (fun i => (Z.twistor i).pi) base hbase

/-- Determinant-convention multi-twistor massless criterion. -/
theorem multiTwistorMassSqDetConvention_eq_zero_iff_common_pi_direction
    {n : Nat} (Z : MultiTwistorChart n) (base : Fin n)
    (hbase : (Z.twistor base).pi 0 ≠ 0 ∨ (Z.twistor base).pi 1 ≠ 0) :
    multiTwistorMassSqDetConvention Z = 0 ↔
      ∃ c : Fin n -> ℂ,
        ∀ i : Fin n, (Z.twistor i).pi = c i • (Z.twistor base).pi := by
  rw [multiTwistorMassSqDetConvention_eq_pairwiseMass]
  exact multiTwistorPairwiseMass_eq_zero_iff_common_pi_direction Z base hbase

/-- Trace-pairing-convention multi-twistor massless criterion. -/
theorem multiTwistorMassSqTraceConvention_eq_zero_iff_common_pi_direction
    {n : Nat} (Z : MultiTwistorChart n) (base : Fin n)
    (hbase : (Z.twistor base).pi 0 ≠ 0 ∨ (Z.twistor base).pi 1 ≠ 0) :
    multiTwistorMassSqTraceConvention Z = 0 ↔
      ∃ c : Fin n -> ℂ,
        ∀ i : Fin n, (Z.twistor i).pi = c i • (Z.twistor base).pi := by
  rw [multiTwistorMassSqTraceConvention_eq_two_pairwiseMass]
  simp only [OfNat.ofNat_ne_zero, mul_eq_zero, false_or]
  exact multiTwistorPairwiseMass_eq_zero_iff_common_pi_direction Z base hbase

end PhysicsSM.Spinor.TwistorPluckerMass

end
