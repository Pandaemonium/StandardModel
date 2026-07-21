import PhysicsSM.Draft.NullEdge.StationaryAmplitudeLiveAxisNoGo

/-!
# Minimal architecture obstruction for a strict Dirac QCA

A four-component, translation-invariant, range-one, single-factor walk has a
degree-one Laurent symbol `e^(iq) A + B + e^(-iq) C`.  For each of the three
live involutory Dirac generators, exact all-momentum unitarity and the exact
Dirac tangent force the stationary coefficient `B` to vanish.  Consequently a
nonzero onsite Wilson-like correction cannot be inserted into any of the three
axis factors within this architecture.

The no-go is nonvacuous: explicit degree-one factors with `B=0` realize every
Hermitian involutory tangent exactly and unitarily.  The existing relaxed
witness shows that a stationary channel and zone-edge separation become
possible when the tangent is allowed a stationary kernel.  Therefore a strict
successor retaining the full live tangent must leave the single-factor
degree-one four-channel class, for example through extra range, substeps, or
blocked/ancillary channels.  This module does not assert which escape is
minimal among those larger classes.

Provenance: clean-room composition of `StationaryAmplitudeNoGo`, its three
live-axis specializations, and `Compact3Plus1DiracRate.factor`.  Lean 4.28.0.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.StrictQCAMinimalArchitecture

open PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo
open PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- Directed hopping projectors for a Hermitian involutory generator. -/
def positiveHop (g : Mat4) : Mat4 :=
  (1 / 2 : Complex) • ((1 : Mat4) - g)

def negativeHop (g : Mat4) : Mat4 :=
  (1 / 2 : Complex) • ((1 : Mat4) + g)

/-- The canonical degree-one Laurent factor is exactly the usual trigonometric
Dirac factor. -/
theorem canonical_laurent_eq_factor (g : Mat4) (q : Real) :
    laurentStep (positiveHop g) 0 (negativeHop g) q = factor q g := by
  have hplus : Complex.exp (I * q) =
      (Real.cos q : Complex) + (Real.sin q : Complex) * I := by
    rw [Complex.exp_eq_exp_re_mul_sin_add_cos]
    norm_num
  have hminus : Complex.exp (-I * q) =
      (Real.cos q : Complex) - (Real.sin q : Complex) * I := by
    rw [Complex.exp_eq_exp_re_mul_sin_add_cos]
    norm_num
    ring
  rw [laurentStep, hplus, hminus]
  ext i j
  simp [positiveHop, negativeHop, factor]
  ring

/-- The degree-one class is populated by an exact all-momentum unitary for
every Hermitian involutory generator. -/
theorem canonical_laurent_unitary (g : Mat4)
    (hgH : g.IsHermitian) (hg2 : g * g = 1) :
    UnitaryAllMomenta (laurentStep (positiveHop g) 0 (negativeHop g)) := by
  intro q
  rw [canonical_laurent_eq_factor]
  exact factor_mem_unitary q g hgH hg2

theorem canonical_laurent_tangent (g : Mat4) :
    HasRegulatedTangent
      (laurentStep (positiveHop g) 0 (negativeHop g)) g := by
  constructor
  · rw [laurentStep_zero]
    ext i j
    simp [positiveHop, negativeHop]
    ring
  · convert laurentStep_hasDerivAt (positiveHop g) 0 (negativeHop g) using 1
    ext i j
    simp [positiveHop, negativeHop]
    ring

/-- No three-axis four-channel range-one single-factor architecture can carry
a nonzero stationary correction while retaining exact unitarity and all three
live Dirac tangents. -/
theorem live_three_axis_stationary_no_go :
    ¬ ∃ Ax Bx Cx Ay By Cy Az Bz Cz : Mat4,
      UnitaryAllMomenta (laurentStep Ax Bx Cx) ∧
      HasRegulatedTangent (laurentStep Ax Bx Cx) alpha1 ∧
      UnitaryAllMomenta (laurentStep Ay By Cy) ∧
      HasRegulatedTangent (laurentStep Ay By Cy) alpha2 ∧
      UnitaryAllMomenta (laurentStep Az Bz Cz) ∧
      HasRegulatedTangent (laurentStep Az Bz Cz) alpha3 ∧
      (Bx ≠ 0 ∨ By ≠ 0 ∨ Bz ≠ 0) := by
  rintro ⟨Ax, Bx, Cx, Ay, By, Cy, Az, Bz, Cz,
    hUx, hTx, hUy, hTy, hUz, hTz, hB⟩
  have hx := StationaryAmplitudeLiveAxisNoGo.alpha1_stationary_forces_zero
    Ax Bx Cx hUx hTx
  have hy := StationaryAmplitudeLiveAxisNoGo.alpha2_stationary_forces_zero
    Ay By Cy hUy hTy
  have hz := StationaryAmplitudeLiveAxisNoGo.alpha3_stationary_forces_zero
    Az Bz Cz hUz hTz
  rcases hB with hB | hB | hB
  · exact hB hx
  · exact hB hy
  · exact hB hz

/-- Once the stationary coefficient vanishes, normalization forces every
degree-one factor to equal `-I` at the zone edge. -/
theorem laurent_pi_eq_neg_one_of_stationary_zero
    (A B C M : Mat4)
    (hT : HasRegulatedTangent (laurentStep A B C) M)
    (hB : B = 0) :
    laurentStep A B C Real.pi = -(1 : Mat4) := by
  have hsum := sum_of_regulated A B C M hT
  rw [hB] at hsum
  have hp : Complex.exp (I * (Real.pi : Complex)) = -1 := by
    rw [mul_comm, Complex.exp_pi_mul_I]
  have hm : Complex.exp (-I * (Real.pi : Complex)) = -1 := by
    rw [show -I * (Real.pi : Complex) = -((Real.pi : Complex) * I) by ring,
      Complex.exp_neg, Complex.exp_pi_mul_I]
    norm_num
  unfold laurentStep
  rw [hp, hm, hB]
  have hAC : A + C = 1 := by simpa using hsum
  rw [neg_one_smul, neg_one_smul, add_zero, ← neg_add, hAC]

/-- Ordered product of three separable axis factors followed by an arbitrary
momentum-independent onsite coin. -/
def factorizedStep (Ax Bx Cx Ay By Cy Az Bz Cz Q : Mat4)
    (qx qy qz : Real) : Mat4 :=
  laurentStep Ax Bx Cx qx * laurentStep Ay By Cy qy *
    laurentStep Az Bz Cz qz * Q

/-- **Even-corner alias lower bound.** In the live four-channel degree-one
factorized class, exact factorwise unitarity and the three exact Dirac tangents
force every even-parity corner to equal the origin after any onsite coin `Q`.
Hence no momentum-independent Pluecker mass coin removes these aliases. -/
theorem live_degree_one_factorized_lower_bound
    (Ax Bx Cx Ay By Cy Az Bz Cz Q : Mat4)
    (hUx : UnitaryAllMomenta (laurentStep Ax Bx Cx))
    (hTx : HasRegulatedTangent (laurentStep Ax Bx Cx) alpha1)
    (hUy : UnitaryAllMomenta (laurentStep Ay By Cy))
    (hTy : HasRegulatedTangent (laurentStep Ay By Cy) alpha2)
    (hUz : UnitaryAllMomenta (laurentStep Az Bz Cz))
    (hTz : HasRegulatedTangent (laurentStep Az Bz Cz) alpha3) :
    Bx = 0 ∧ By = 0 ∧ Bz = 0 ∧
      factorizedStep Ax Bx Cx Ay By Cy Az Bz Cz Q 0 0 0 =
        factorizedStep Ax Bx Cx Ay By Cy Az Bz Cz Q
          Real.pi Real.pi 0 ∧
      factorizedStep Ax Bx Cx Ay By Cy Az Bz Cz Q 0 0 0 =
        factorizedStep Ax Bx Cx Ay By Cy Az Bz Cz Q
          Real.pi 0 Real.pi ∧
      factorizedStep Ax Bx Cx Ay By Cy Az Bz Cz Q 0 0 0 =
        factorizedStep Ax Bx Cx Ay By Cy Az Bz Cz Q
          0 Real.pi Real.pi := by
  have hx := StationaryAmplitudeLiveAxisNoGo.alpha1_stationary_forces_zero
    Ax Bx Cx hUx hTx
  have hy := StationaryAmplitudeLiveAxisNoGo.alpha2_stationary_forces_zero
    Ay By Cy hUy hTy
  have hz := StationaryAmplitudeLiveAxisNoGo.alpha3_stationary_forces_zero
    Az Bz Cz hUz hTz
  have hxpi := laurent_pi_eq_neg_one_of_stationary_zero Ax Bx Cx alpha1 hTx hx
  have hypi := laurent_pi_eq_neg_one_of_stationary_zero Ay By Cy alpha2 hTy hy
  have hzpi := laurent_pi_eq_neg_one_of_stationary_zero Az Bz Cz alpha3 hTz hz
  have hx0 := hTx.1
  have hy0 := hTy.1
  have hz0 := hTz.1
  refine ⟨hx, hy, hz, ?_, ?_, ?_⟩ <;>
    simp [factorizedStep, hx0, hy0, hz0, hxpi, hypi, hzpi]

/-- Nonvacuity control for all three live axes: exact unitary degree-one
factors with the required tangents exist when the stationary terms vanish. -/
theorem live_three_axis_zero_stationary_witness :
    UnitaryAllMomenta (laurentStep (positiveHop alpha1) 0 (negativeHop alpha1)) ∧
      HasRegulatedTangent
        (laurentStep (positiveHop alpha1) 0 (negativeHop alpha1)) alpha1 ∧
      UnitaryAllMomenta (laurentStep (positiveHop alpha2) 0 (negativeHop alpha2)) ∧
      HasRegulatedTangent
        (laurentStep (positiveHop alpha2) 0 (negativeHop alpha2)) alpha2 ∧
      UnitaryAllMomenta (laurentStep (positiveHop alpha3) 0 (negativeHop alpha3)) ∧
      HasRegulatedTangent
        (laurentStep (positiveHop alpha3) 0 (negativeHop alpha3)) alpha3 := by
  rcases generators_hermitian_square_one with
    ⟨h1, h2, h3, _, hs1, hs2, hs3, _⟩
  exact ⟨canonical_laurent_unitary alpha1 h1 hs1,
    canonical_laurent_tangent alpha1,
    canonical_laurent_unitary alpha2 h2 hs2,
    canonical_laurent_tangent alpha2,
    canonical_laurent_unitary alpha3 h3 hs3,
    canonical_laurent_tangent alpha3⟩

/-- The first explicit escape control: dropping tangent involutivity permits a
nonzero stationary channel and separates the zone edge. -/
theorem noninvolutory_tangent_escape_witness :
    ∃ A B C M : Mat4,
      Mᴴ = M ∧ M * M ≠ 1 ∧
      UnitaryAllMomenta (laurentStep A B C) ∧
      HasRegulatedTangent (laurentStep A B C) M ∧
      HasStationaryAmplitude B ∧ SeparatesPi (laurentStep A B C) :=
  relaxed_witness

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.StrictQCAMinimalArchitecture.live_three_axis_stationary_no_go' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms live_three_axis_stationary_no_go

/-- info: 'PhysicsSM.Draft.NullEdge.StrictQCAMinimalArchitecture.live_three_axis_zero_stationary_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms live_three_axis_zero_stationary_witness

/-- info: 'PhysicsSM.Draft.NullEdge.StrictQCAMinimalArchitecture.live_degree_one_factorized_lower_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms live_degree_one_factorized_lower_bound

/-- info: 'PhysicsSM.Draft.NullEdge.StrictQCAMinimalArchitecture.noninvolutory_tangent_escape_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms noninvolutory_tangent_escape_witness

end PhysicsSM.Draft.NullEdge.StrictQCAMinimalArchitecture
