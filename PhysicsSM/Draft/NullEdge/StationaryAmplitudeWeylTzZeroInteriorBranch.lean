import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylLiveMatrixNumeratorBridge
import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylAlgebraicOffAxisAlias
import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylExactOffCornerAlias

/-!
# Target: exact `tz = 0` interior branch census

This target classifies the real zeros of the exact live stationary-Weyl Pauli
numerators on the finite tangent-chart slice `tz = 0`.  It uses the verified
`Fx`, `Fy`, and `Fz` bridge definitions directly and reconstructs the imported
live `weylStep`; it does not copy the projector-walk fixture.

Exact rational elimination gives precisely two points:

* `(0, 0, 0)`, where all tangent coordinates vanish;
* `(-5/4, 5/4, 0)`, where exactly the `tz` coordinate vanishes.

Both points reconstruct the live matrix as `+I`, not `-I`.  The second point
is the tangent-coordinate form of the imported `9-40-41` exact off-corner
alias.

Provenance: exact `QQ` algebra checked with SymPy 1.14.0 from the generated
certificate source in
`Scripts/oracle/certify_stationary_weyl_tangent_elimination.py`; live matrix
reconstruction is tied to the imported theorem
`StationaryAmplitudeWeylExactOffCornerAlias.exact_offCorner_alias`.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTzZeroInteriorBranch

open StationaryAmplitudeWeylTangent
open StationaryAmplitudeWeylLiveMatrixNumeratorBridge
open StationaryAmplitudeWeylAlgebraicOffAxisAlias
open StationaryAmplitudeWeylExactOffCornerAlias

/-- The origin is an explicit zero of all three generated numerators. -/
theorem origin_numerators_zero :
    Fx 0 0 0 = 0 ∧ Fy 0 0 0 = 0 ∧ Fz 0 0 0 = 0 := by
  norm_num [Fx, Fy, Fz]

/-- The nonorigin rational point on the `tz = 0` slice is also an explicit
zero of all three generated numerators. -/
theorem offCorner_numerators_zero :
    Fx (-5 / 4) (5 / 4) 0 = 0 ∧
      Fy (-5 / 4) (5 / 4) 0 = 0 ∧
      Fz (-5 / 4) (5 / 4) 0 = 0 := by
  norm_num [Fx, Fy, Fz]

/-- Tangent coordinate `-5/4` reconstructs the imported first phase of the
`9-40-41` alias. -/
theorem unitPhase_neg_five_fourths :
    unitPhase (-5 / 4) = phaseX := by
  apply Complex.ext <;>
    norm_num [unitPhase, phaseX, Complex.div_re, Complex.div_im,
      Complex.normSq, Complex.add_re, Complex.add_im, Complex.sub_re,
      Complex.sub_im, Complex.mul_re, Complex.mul_im]

/-- Tangent coordinate `5/4` reconstructs the imported conjugate phase of the
`9-40-41` alias. -/
theorem unitPhase_five_fourths :
    unitPhase (5 / 4) = phaseY := by
  apply Complex.ext <;>
    norm_num [unitPhase, phaseY, Complex.div_re, Complex.div_im,
      Complex.normSq, Complex.add_re, Complex.add_im, Complex.sub_re,
      Complex.sub_im, Complex.mul_re, Complex.mul_im]

/-- The all-zero tangent point reconstructs the live matrix as `+I`. -/
theorem origin_reconstructs_positive_identity :
    weylStep (unitPhase 0) (unitPhase 0) (unitPhase 0) = 1 := by
  simpa [unitPhase] using weylStep_one

/-- The nonorigin `tz = 0` point also reconstructs the live matrix as `+I`. -/
theorem offCorner_reconstructs_positive_identity :
    weylStep (unitPhase (-5 / 4)) (unitPhase (5 / 4)) (unitPhase 0) = 1 := by
  rw [unitPhase_neg_five_fourths, unitPhase_five_fourths]
  simpa [unitPhase] using exact_offCorner_alias

/-- Complete real classification of the generated numerator system on the
finite tangent-chart slice `tz = 0`. -/
theorem numerators_zero_and_tz_zero_iff (tx ty tz : Real) :
    tz = 0 ∧ Fx tx ty tz = 0 ∧ Fy tx ty tz = 0 ∧ Fz tx ty tz = 0 ↔
      (tx = 0 ∧ ty = 0 ∧ tz = 0) ∨
      (tx = -5 / 4 ∧ ty = 5 / 4 ∧ tz = 0) := by
  constructor
  · rintro ⟨rfl, hx, hy, hz⟩
    have hzFactor : tx * ty * (16 * tx * ty + 25) = 0 := by
      unfold Fz at hz
      linear_combination hz / 150
    rcases mul_eq_zero.mp hzFactor with hxy | hlinear
    · rcases mul_eq_zero.mp hxy with htx | hty
      · left
        subst tx
        have : ty = 0 := by
          unfold Fx at hx
          nlinarith [sq_nonneg ty]
        exact ⟨rfl, this, rfl⟩
      · left
        subst ty
        have : tx = 0 := by
          unfold Fx at hx
          nlinarith
        exact ⟨this, rfl, rfl⟩
    · right
      have hxSlice :
          -700 * tx ^ 2 * ty ^ 2 - 875 * tx * ty ^ 2 - 3125 * tx -
              2500 * ty ^ 2 = 0 := by
        unfold Fx at hx
        ring_nf at hx ⊢
        exact hx
      have hyPolynomial :
          (4 * ty - 5) * (64 * ty ^ 2 + 45 * ty + 100) = 0 := by
        linear_combination
          (-64 * ty / 625) * hxSlice -
            (112 * tx * ty ^ 2 + 140 * ty ^ 2 - 175 * ty + 500) / 25 * hlinear
      have hquadratic : 0 < 64 * ty ^ 2 + 45 * ty + 100 := by
        nlinarith [sq_nonneg (128 * ty + 45)]
      have hty : ty = 5 / 4 := by
        rcases mul_eq_zero.mp hyPolynomial with hfirst | hsecond
        · linarith
        · exact (ne_of_gt hquadratic hsecond).elim
      have htx : tx = -5 / 4 := by
        rw [hty] at hlinear
        norm_num at hlinear ⊢
        linarith
      exact ⟨htx, hty, rfl⟩
  · rintro (⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩)
    · exact ⟨rfl, origin_numerators_zero⟩
    · exact ⟨rfl, offCorner_numerators_zero⟩

/-- Strong live census: each numerator zero on the `tz = 0` interior slice is
one of the two explicit rational points, both give `+I`, and the coordinate
vanishing pattern is recorded branch by branch. -/
theorem tz_zero_interior_live_census (tx ty tz : Real) :
    tz = 0 ∧ Fx tx ty tz = 0 ∧ Fy tx ty tz = 0 ∧ Fz tx ty tz = 0 ↔
      (tx = 0 ∧ ty = 0 ∧ tz = 0 ∧
        weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz) = 1) ∨
      (tx = -5 / 4 ∧ ty = 5 / 4 ∧ tz = 0 ∧ tx ≠ 0 ∧ ty ≠ 0 ∧
        weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz) = 1) := by
  constructor
  · intro h
    rcases (numerators_zero_and_tz_zero_iff tx ty tz).mp h with h0 | h1
    · rcases h0 with ⟨rfl, rfl, rfl⟩
      exact Or.inl ⟨rfl, rfl, rfl, origin_reconstructs_positive_identity⟩
    · rcases h1 with ⟨rfl, rfl, rfl⟩
      exact Or.inr ⟨rfl, rfl, rfl, by norm_num, by norm_num,
        offCorner_reconstructs_positive_identity⟩
  · rintro (h0 | h1)
    · exact (numerators_zero_and_tz_zero_iff tx ty tz).mpr
        (Or.inl ⟨h0.1, h0.2.1, h0.2.2.1⟩)
    · exact (numerators_zero_and_tz_zero_iff tx ty tz).mpr
        (Or.inr ⟨h1.1, h1.2.1, h1.2.2.1⟩)

/-- There are two explicit real witnesses, and their coordinate-zero patterns
and positive-identity reconstructions are nonvacuous. -/
theorem explicit_witnesses :
    (Fx 0 0 0 = 0 ∧ Fy 0 0 0 = 0 ∧ Fz 0 0 0 = 0 ∧
      (0 : Real) = 0 ∧ (0 : Real) = 0 ∧ (0 : Real) = 0 ∧
      weylStep (unitPhase 0) (unitPhase 0) (unitPhase 0) = 1) ∧
    (Fx (-5 / 4) (5 / 4) 0 = 0 ∧
      Fy (-5 / 4) (5 / 4) 0 = 0 ∧
      Fz (-5 / 4) (5 / 4) 0 = 0 ∧
      (-5 / 4 : Real) ≠ 0 ∧ (5 / 4 : Real) ≠ 0 ∧ (0 : Real) = 0 ∧
      weylStep (unitPhase (-5 / 4)) (unitPhase (5 / 4)) (unitPhase 0) = 1) := by
  exact ⟨⟨origin_numerators_zero.1, origin_numerators_zero.2.1,
      origin_numerators_zero.2.2, rfl, rfl, rfl,
      origin_reconstructs_positive_identity⟩,
    ⟨offCorner_numerators_zero.1, offCorner_numerators_zero.2.1,
      offCorner_numerators_zero.2.2, by norm_num, by norm_num, rfl,
      offCorner_reconstructs_positive_identity⟩⟩

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTzZeroInteriorBranch
