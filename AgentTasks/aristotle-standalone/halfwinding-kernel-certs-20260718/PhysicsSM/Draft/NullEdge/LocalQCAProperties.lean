import PhysicsSM.Draft.NullEdge.SuccessiveAxisPositionWalk

/-!
# Reversibility and causal support of the finite local walk

The finite successive-axis update is more than norm preserving.  Each
conditional shift has an explicit reverse shift, each unitary pointwise coin
has its conjugate-transpose inverse, and the complete x/y/z/mass cycle therefore
has an explicit two-sided inverse.  A separate causal-source theorem expands
one output amplitude only over input positions reached by one conditional
shift along each spatial axis.

These are finite one-particle QCA properties: exact reversibility, strict
finite propagation, and a nontrivial local update.  They do not by themselves
construct a second-quantized CAR automaton or classify infinite-lattice QCAs.

Provenance: clean-room composition of the finite position-register APIs in
`SuccessiveAxisPositionWalk`.  Lean 4.28.0.
-/

noncomputable section

open Matrix Complex
open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.LocalQCAProperties

open PhysicsSM.Draft.NullEdge.SuccessiveAxisPositionWalk
open PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk

/-- Reverse every channel direction.  On a fixed axis this changes a one-site
source displacement into its inverse displacement. -/
def reverseVelocity (velocity : Axis -> Internal -> Bool) :
    Axis -> Internal -> Bool :=
  fun axis a => !(velocity axis a)

theorem sourcePosition_reverse_after {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis) (a : Internal)
    (p : Position L) :
    sourcePosition velocity axis a
        (sourcePosition (reverseVelocity velocity) axis a p) = p := by
  ext j
  by_cases hj : j = axis
  · subst j
    cases h : velocity axis a <;>
      simp [sourcePosition, reverseVelocity, h]
  · simp [sourcePosition, hj]

theorem sourcePosition_after_reverse {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis) (a : Internal)
    (p : Position L) :
    sourcePosition (reverseVelocity velocity) axis a
        (sourcePosition velocity axis a p) = p := by
  ext j
  by_cases hj : j = axis
  · subst j
    cases h : velocity axis a <;>
      simp [sourcePosition, reverseVelocity, h]
  · simp [sourcePosition, hj]

/-- Reverse shift after forward shift is the identity. -/
theorem conditionalShift_reverse_after {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis) (psi : State L) :
    conditionalShift (reverseVelocity velocity) axis
        (conditionalShift velocity axis psi) = psi := by
  ext p a
  simp [conditionalShift, sourcePosition_reverse_after]

/-- Forward shift after reverse shift is the identity. -/
theorem conditionalShift_after_reverse {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis) (psi : State L) :
    conditionalShift velocity axis
        (conditionalShift (reverseVelocity velocity) axis psi) = psi := by
  ext p a
  simp [conditionalShift, sourcePosition_after_reverse]

/-- The conjugate-transpose pointwise coin is a left inverse of a unitary
pointwise coin. -/
theorem pointwiseCoin_conjTranspose_after {L : Nat} [NeZero L]
    (U : Coin) (hU : IsUnitary U) (psi : State L) :
    pointwiseCoin Uᴴ (pointwiseCoin U psi) = psi := by
  ext p a
  unfold pointwiseCoin
  rw [Matrix.mulVec_mulVec, hU.1]
  simp

/-- The conjugate-transpose pointwise coin is also a right inverse. -/
theorem pointwiseCoin_after_conjTranspose {L : Nat} [NeZero L]
    (U : Coin) (hU : IsUnitary U) (psi : State L) :
    pointwiseCoin U (pointwiseCoin Uᴴ psi) = psi := by
  ext p a
  unfold pointwiseCoin
  rw [Matrix.mulVec_mulVec, hU.2]
  simp

/-- Explicit inverse of one complete x/y/z/mass cycle. -/
def inverseSuccessiveWalk {L : Nat}
    (velocity : Axis -> Internal -> Bool)
    (Ux Uy Uz Um : Coin) (psi : State L) : State L :=
  pointwiseCoin Umᴴ
    (pointwiseCoin Uxᴴ
      (conditionalShift (reverseVelocity velocity) 0
        (pointwiseCoin Uyᴴ
          (conditionalShift (reverseVelocity velocity) 1
            (pointwiseCoin Uzᴴ
              (conditionalShift (reverseVelocity velocity) 2 psi))))))

/-- The displayed inverse cancels the complete walk on the left. -/
theorem inverseSuccessiveWalk_after {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool)
    (Ux Uy Uz Um : Coin)
    (hUx : IsUnitary Ux) (hUy : IsUnitary Uy)
    (hUz : IsUnitary Uz) (hUm : IsUnitary Um)
    (psi : State L) :
    inverseSuccessiveWalk velocity Ux Uy Uz Um
        (successiveWalk velocity Ux Uy Uz Um psi) = psi := by
  unfold inverseSuccessiveWalk successiveWalk axisFactor
  rw [conditionalShift_reverse_after,
    pointwiseCoin_conjTranspose_after _ hUz,
    conditionalShift_reverse_after,
    pointwiseCoin_conjTranspose_after _ hUy,
    conditionalShift_reverse_after,
    pointwiseCoin_conjTranspose_after _ hUx,
    pointwiseCoin_conjTranspose_after _ hUm]

/-- The displayed inverse cancels the complete walk on the right. -/
theorem successiveWalk_after_inverse {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool)
    (Ux Uy Uz Um : Coin)
    (hUx : IsUnitary Ux) (hUy : IsUnitary Uy)
    (hUz : IsUnitary Uz) (hUm : IsUnitary Um)
    (psi : State L) :
    successiveWalk velocity Ux Uy Uz Um
        (inverseSuccessiveWalk velocity Ux Uy Uz Um psi) = psi := by
  unfold inverseSuccessiveWalk successiveWalk axisFactor
  rw [pointwiseCoin_after_conjTranspose _ hUm,
    pointwiseCoin_after_conjTranspose _ hUx,
    conditionalShift_after_reverse,
    pointwiseCoin_after_conjTranspose _ hUy,
    conditionalShift_after_reverse,
    pointwiseCoin_after_conjTranspose _ hUz,
    conditionalShift_after_reverse]

/-- The unique input position associated with fixed internal indices in the
three nested conditional shifts of one complete cycle. -/
def causalSource {L : Nat} (velocity : Axis -> Internal -> Bool)
    (p : Position L) (out midZ midY : Internal) : Position L :=
  sourcePosition velocity 0 midY
    (sourcePosition velocity 1 midZ
      (sourcePosition velocity 2 out p))

theorem causalSource_coordinate_zero {L : Nat}
    (velocity : Axis -> Internal -> Bool)
    (p : Position L) (out midZ midY : Internal) :
    causalSource velocity p out midZ midY 0 =
      p 0 + if velocity 0 midY then -1 else 1 := by
  simp [causalSource, sourcePosition]

theorem causalSource_coordinate_one {L : Nat}
    (velocity : Axis -> Internal -> Bool)
    (p : Position L) (out midZ midY : Internal) :
    causalSource velocity p out midZ midY 1 =
      p 1 + if velocity 1 midZ then -1 else 1 := by
  simp [causalSource, sourcePosition]

theorem causalSource_coordinate_two {L : Nat}
    (velocity : Axis -> Internal -> Bool)
    (p : Position L) (out midZ midY : Internal) :
    causalSource velocity p out midZ midY 2 =
      p 2 + if velocity 2 out then -1 else 1 := by
  simp [causalSource, sourcePosition]

/-- **Strict one-cycle causal cone.** If the input vanishes at every position
reached from `p` by the three nested conditional source shifts, then every
output channel at `p` vanishes after one complete walk cycle. -/
theorem successiveWalk_zero_of_causalSource_zero {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool)
    (Ux Uy Uz Um : Coin) (psi : State L) (p : Position L)
    (hzero : forall out midZ midY input,
      psi (causalSource velocity p out midZ midY) input = 0) :
    forall out, successiveWalk velocity Ux Uy Uz Um psi p out = 0 := by
  intro out
  simp only [successiveWalk, axisFactor, conditionalShift, pointwiseCoin,
    Matrix.mulVec, dotProduct]
  apply Finset.sum_eq_zero
  intro midZ hmidZ
  apply mul_eq_zero_of_right
  apply Finset.sum_eq_zero
  intro midY hmidY
  apply mul_eq_zero_of_right
  apply Finset.sum_eq_zero
  intro midX hmidX
  apply mul_eq_zero_of_right
  apply Finset.sum_eq_zero
  intro input hinput
  have hz := hzero out midZ midY input
  unfold causalSource at hz
  rw [hz]
  simp

end PhysicsSM.Draft.NullEdge.LocalQCAProperties

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.LocalQCAProperties.inverseSuccessiveWalk_after' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LocalQCAProperties.inverseSuccessiveWalk_after

/-- info: 'PhysicsSM.Draft.NullEdge.LocalQCAProperties.successiveWalk_after_inverse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LocalQCAProperties.successiveWalk_after_inverse

/-- info: 'PhysicsSM.Draft.NullEdge.LocalQCAProperties.successiveWalk_zero_of_causalSource_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LocalQCAProperties.successiveWalk_zero_of_causalSource_zero
