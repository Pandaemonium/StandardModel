import PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry

/-!
# Tetrad and spin reconstruction boundary

This module records two local nonuniqueness facts that a graph-to-GR
reconstruction must respect.

First, a metric does not select a unique coframe.  An explicit nonidentity
rational transformation preserves the four-dimensional mostly-minus form
`diag(1, -1, -1, -1)`.  Acting on the identity coframe therefore produces a
distinct nondegenerate coframe with exactly the same induced metric.  A
reconstruction can at most select a Lorentz-gauge class unless it supplies a
gauge choice or additional structure.

Second, the two matrices `S` and `-S`, paired with inverse candidates `SInv`
and `-SInv`, induce the same matrix-conjugation action but opposite actions on
spinors. The explicit determinant-one identity witness shows that this central
sign algebra is nonvacuous. Interpreting it as the local sign ambiguity of a
Lorentz spin lift additionally requires the Hermitian-matrix realization of
Minkowski vectors and the standard `SL(2, C)` covering action; neither is
constructed here.

These are finite local algebraic boundary theorems.  They do not establish the
existence of a tetrad, derive a tetrad from a bare graph, construct a global
spin structure, or discharge the topological obstruction to a spin lift.
-/

open Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary

/-! ## A metric determines only a coframe gauge class -/

/-- Mostly-minus rational Minkowski form in four dimensions. -/
def eta4 : Matrix (Fin 4) (Fin 4) ℚ :=
  !![1, 0, 0, 0;
     0, -1, 0, 0;
     0, 0, -1, 0;
     0, 0, 0, -1]

/-- A nonidentity rational boost in the first spatial direction. -/
def boost4 : Matrix (Fin 4) (Fin 4) ℚ :=
  !![5 / 3, 4 / 3, 0, 0;
     4 / 3, 5 / 3, 0, 0;
     0, 0, 1, 0;
     0, 0, 0, 1]

/-- The inverse rational boost. -/
def boost4Inv : Matrix (Fin 4) (Fin 4) ℚ :=
  !![5 / 3, -4 / 3, 0, 0;
     -4 / 3, 5 / 3, 0, 0;
     0, 0, 1, 0;
     0, 0, 0, 1]

/-- The displayed boost and inverse multiply to the identity in both orders. -/
theorem boost4_inverse :
    boost4Inv * boost4 = 1 ∧ boost4 * boost4Inv = 1 := by
  constructor <;>
    ext i j <;>
    fin_cases i <;> fin_cases j <;>
    simp [boost4Inv, boost4, Matrix.mul_apply, Fin.sum_univ_four] <;>
    norm_num

/-- The rational boost preserves the mostly-minus Minkowski form. -/
theorem boost4_lorentz : boost4ᵀ * eta4 * boost4 = eta4 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [boost4, eta4, Matrix.mul_apply, Fin.sum_univ_four] <;>
    norm_num

/-- The rational boost is genuinely different from the identity. -/
theorem boost4_ne_one : boost4 ≠ 1 := by
  intro h
  have h01 := congrFun (congrFun h 0) 1
  simp [boost4] at h01

/-- Invertibility of the displayed boost implies coframe nondegeneracy. -/
theorem boost4_nondegenerate :
    PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate boost4 := by
  unfold PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate
  have hdet : boost4Inv.det * boost4.det = 1 := by
    rw [← Matrix.det_mul, boost4_inverse.1, Matrix.det_one]
  exact right_ne_zero_of_mul_eq_one hdet

/-- **Local coframe nonuniqueness witness.** Two distinct nondegenerate
four-dimensional rational coframes induce the same mostly-minus metric. -/
theorem metric_does_not_fix_coframe_witness :
    ∃ (eta e e' : Matrix (Fin 4) (Fin 4) ℚ),
      PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate e ∧
      PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate e' ∧
      e' ≠ e ∧
      PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.inducedMetric eta e' =
        PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.inducedMetric eta e := by
  refine ⟨eta4, 1, boost4, ?_, boost4_nondegenerate, boost4_ne_one, ?_⟩
  · simp [PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate]
  · simpa [PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.transformCoframe] using
      PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.inducedMetric_frame_invariant
        eta4 boost4 (1 : Matrix (Fin 4) (Fin 4) ℚ) boost4_lorentz

/-! ## Central sign algebra behind a local spin lift -/

/-- Conjugation action of a matrix and a chosen inverse candidate. -/
def vectorConjugation
    (S SInv X : Matrix (Fin 2) (Fin 2) ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  S * X * SInv

/-- Fundamental two-component spinor action. -/
def spinorAction
    (S : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin 2 -> ℂ) : Fin 2 -> ℂ :=
  S *ᵥ psi

/-- Simultaneously negating a matrix and its inverse candidate leaves its
conjugation action unchanged. -/
theorem vectorConjugation_neg
    (S SInv X : Matrix (Fin 2) (Fin 2) ℂ) :
    vectorConjugation (-S) (-SInv) X = vectorConjugation S SInv X := by
  unfold vectorConjugation
  noncomm_ring

/-- Negating the lifting matrix negates its action on every spinor. -/
theorem spinorAction_neg
    (S : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin 2 -> ℂ) :
    spinorAction (-S) psi = -spinorAction S psi := by
  ext i
  simp [spinorAction, Matrix.mulVec]
  ring

/-- Explicit identity element of the two-component determinant-one group. -/
def spinIdentity : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, 1]

/-- A nonzero reference spin-up vector. -/
def up : Fin 2 -> ℂ := ![1, 0]

/-- The explicit lifting matrix and its negative both have determinant one. -/
theorem spinIdentity_and_neg_det :
    spinIdentity.det = 1 ∧ (-spinIdentity).det = 1 := by
  constructor
  · simp [spinIdentity, Matrix.det_fin_two]
  · rw [Matrix.det_neg]
    simp [spinIdentity, Matrix.det_fin_two]

/-- The explicit identity lift is its own inverse. -/
theorem spinIdentity_inverse : spinIdentity * spinIdentity = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [spinIdentity, Matrix.mul_apply, Fin.sum_univ_two]

/-- The negative identity lift is also its own inverse. -/
theorem negSpinIdentity_inverse : (-spinIdentity) * (-spinIdentity) = 1 := by
  rw [neg_mul_neg, spinIdentity_inverse]

/-- The identity lift fixes the reference spinor. -/
theorem spinIdentity_action_up : spinorAction spinIdentity up = up := by
  ext i
  fin_cases i <;>
    norm_num [spinorAction, spinIdentity, up, Matrix.mulVec, Fin.sum_univ_two]

/-- The negative identity lift negates the reference spinor. -/
theorem negSpinIdentity_action_up : spinorAction (-spinIdentity) up = -up := by
  rw [spinorAction_neg, spinIdentity_action_up]

/-- The two explicit lifts act differently on the nonzero reference spinor. -/
theorem spinIdentity_actions_ne :
    spinorAction (-spinIdentity) up ≠ spinorAction spinIdentity up := by
  rw [negSpinIdentity_action_up, spinIdentity_action_up]
  intro h
  have h0 := congrFun h 0
  change -(up 0) = up 0 at h0
  norm_num [up] at h0

/-- **Central sign witness for a future spin-lift construction.** Two
determinant-one inverse pairs have the same conjugation action on every matrix
and different actions on a nonzero spinor. This theorem does not itself define
the Lorentz covering action on Hermitian Minkowski matrices. -/
theorem spinLift_sign_witness :
    ∃ (S SInv : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin 2 -> ℂ),
      S.det = 1 ∧
      (-S).det = 1 ∧
      SInv * S = 1 ∧
      S * SInv = 1 ∧
      (-SInv) * (-S) = 1 ∧
      (-S) * (-SInv) = 1 ∧
      (∀ X, vectorConjugation (-S) (-SInv) X =
        vectorConjugation S SInv X) ∧
      spinorAction (-S) psi ≠ spinorAction S psi := by
  exact ⟨spinIdentity, spinIdentity, up,
    spinIdentity_and_neg_det.1, spinIdentity_and_neg_det.2,
    spinIdentity_inverse, spinIdentity_inverse,
    negSpinIdentity_inverse, negSpinIdentity_inverse,
    fun X => vectorConjugation_neg spinIdentity spinIdentity X,
    spinIdentity_actions_ne⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.metric_does_not_fix_coframe_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.metric_does_not_fix_coframe_witness

/-- info: 'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.vectorConjugation_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.vectorConjugation_neg

/-- info: 'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinorAction_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinorAction_neg

/-- info: 'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinLift_sign_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinLift_sign_witness

end PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary
