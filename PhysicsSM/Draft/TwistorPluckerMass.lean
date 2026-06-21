import PhysicsSM.Spinor.PluckerMass

/-!
# Draft.TwistorPluckerMass

A narrow twistor/Plucker matching wrapper for the null-edge causal graph
program.

This module is intentionally modest.  It does not formalize projective twistor
space, twistor cohomology, the Penrose transform, or the incidence equation.
It only packages the spinor chart used by two-twistor and multi-twistor mass
models:

```text
Z = (omega^A, pi_{A'})
```

and records that the spinor part of the infinity-twistor pairing,

```text
I(Z,W) = epsilon^{A'B'} pi_{A'} eta_{B'},
```

is exactly the two-spinor Plucker wedge.  Therefore its squared modulus is
the two-edge determinant mass already proved in
`PhysicsSM.Spinor.PluckerMass`.

Convention note:
- we model dotted spinors by the same concrete carrier `Fin 2 -> ℂ` used for
  visible spinors in `PhysicsSM.Spinor.PluckerMass`;
- `pi` is the spinor that contributes to visible momentum;
- `omega` is carried only as chart/incidence data and is not used in the
  finite mass theorem;
- possible factors of `2`, signs, or complex conjugations in the physics
  literature are outside this wrapper and should be handled by separate
  convention-bridge lemmas.

Status: draft-facing convention wrapper, no `sorry`.
-/

noncomputable section

namespace PhysicsSM.Draft.TwistorPluckerMass

open Matrix Complex
open PhysicsSM.Spinor.PluckerMass

/-! ## Spinor chart for twistors -/

/--
A twistor represented only by the two spinor columns needed for the finite
mass calculation.

The field `pi` is the momentum spinor selected by the infinity twistor.  The
field `omega` is retained so that later incidence wrappers can extend this
structure without changing the mass-facing API.
-/
structure SpinorChartTwistor where
  omega : CSpinor
  pi : CSpinor

/--
The spinor part of the infinity-twistor pairing in this chart.

With the convention `Z = (omega^A, pi_{A'})`, this is the antisymmetric
contraction `epsilon^{A'B'} pi_{A'} eta_{B'}`.  In the concrete two-spinor
coordinates of this project, it is the Plucker wedge of the two `pi` spinors.
-/
def infinityTwistorPairing
    (Z W : SpinorChartTwistor) : ℂ :=
  spinorWedge Z.pi W.pi

/-- The squared mass invariant carried by a pair of chart twistors. -/
def twoTwistorMassInvariant
    (Z W : SpinorChartTwistor) : ℂ :=
  complexAbsSq (infinityTwistorPairing Z W)

/-- The visible momentum matrix carried by the two chart twistors. -/
def twoTwistorMomentum
    (Z W : SpinorChartTwistor) : Matrix (Fin 2) (Fin 2) ℂ :=
  twoEdgeMomentum Z.pi W.pi

/--
Two-twistor/Plucker matching in the spinor chart.

The spinor part of the two-twistor mass invariant is exactly the Plucker
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

/--
The determinant convention for the two-twistor spinor-chart mass.

This is the convention used by `PhysicsSM.Spinor.PluckerMass`: the invariant
mass squared of a Hermitian momentum matrix is its determinant.
-/
def twoTwistorMassSqDetConvention
    (Z W : SpinorChartTwistor) : ℂ :=
  (twoTwistorMomentum Z W).det

/--
The trace-pairing convention often used when identifying Hermitian matrices
with Minkowski vectors.  In that convention the Lorentz norm square is
`2 * det(P)`.

This wrapper deliberately keeps the factor explicit instead of silently
changing the finite Plucker theorem.
-/
def twoTwistorMassSqTraceConvention
    (Z W : SpinorChartTwistor) : ℂ :=
  2 * (twoTwistorMomentum Z W).det

/-- The determinant convention is exactly the squared twistor spinor pairing. -/
theorem twoTwistorMassSqDetConvention_eq_massInvariant
    (Z W : SpinorChartTwistor) :
    twoTwistorMassSqDetConvention Z W = twoTwistorMassInvariant Z W := by
  exact two_twistor_momentum_det_eq_massInvariant Z W

/--
The trace-pairing convention differs from the Plucker mass invariant by the
explicit factor `2`.
-/
theorem twoTwistorMassSqTraceConvention_eq_two_massInvariant
    (Z W : SpinorChartTwistor) :
    twoTwistorMassSqTraceConvention Z W =
      2 * twoTwistorMassInvariant Z W := by
  unfold twoTwistorMassSqTraceConvention
  rw [two_twistor_momentum_det_eq_massInvariant]

/-! ## Projective rescaling -/

/-- Projectively rescale both spinor entries of a chart twistor. -/
def rescaleTwistor (a : ℂ) (Z : SpinorChartTwistor) :
    SpinorChartTwistor where
  omega := a • Z.omega
  pi := a • Z.pi

/--
The infinity-twistor spinor pairing is bilinear under independent chart
rescalings.
-/
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

/-! ## Finite multi-twistor chart -/

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
The trace-pairing convention differs from the determinant-convention
multi-twistor Plucker mass by the explicit factor `2`.
-/
theorem multiTwistorMassSqTraceConvention_eq_two_pairwiseMass
    {n : Nat} (Z : MultiTwistorChart n) :
    multiTwistorMassSqTraceConvention Z =
      2 * multiTwistorPairwiseMass Z := by
  unfold multiTwistorMassSqTraceConvention
  rw [multi_twistor_momentum_det_eq_pairwiseMass]

end PhysicsSM.Draft.TwistorPluckerMass

end
