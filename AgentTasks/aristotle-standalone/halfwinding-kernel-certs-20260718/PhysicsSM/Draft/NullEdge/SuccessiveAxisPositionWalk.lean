import PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk

/-!
# A finite position-register successive-axis walk

States now carry a finite periodic three-dimensional position register and four
internal components. Each axis factor applies a pointwise unitary internal coin
and then a channel-dependent local one-site translation. Conditional shifts
preserve the finite inner product because every source-position map is a
bijection; composing the three axis shifts with the mass coin is therefore
exactly norm preserving.

The concrete L=5 shift is nonidentity, and deleting one site is an explicit
nonunitary control. The final theorems instantiate the internal coins with the
landed normalized `alpha1`, `alpha2`, `alpha3`, and `beta` factors.

This is a genuine finite position-space/locality layer for Route B. It does not
yet prove that `tetraVelocity` is the spectral-projector dictionary of the
Clifford generators, that the full spatial tangent is `-iH`, or that any
continuum/Trotter limit holds.

Provenance: generic position-walk proofs completed by Aristotle project
`624c8719-13a9-488c-a0fc-036f18457f9b`; clean-room integration with the live
Route-B coin API on 2026-07-10.
-/

open Matrix Complex
open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.SuccessiveAxisPositionWalk

open PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk

abbrev Axis := Fin 3
abbrev Internal := Fin 4
abbrev Position (L : ℕ) := Axis → ZMod L
abbrev State (L : ℕ) := Position L → Internal → Complex
abbrev Coin := Mat4

noncomputable def inner {L : ℕ} [NeZero L]
    (psi phi : State L) : Complex :=
  ∑ p, ∑ a, star (psi p a) * phi p a

/-- Source position for a local one-site conditional shift. -/
def sourcePosition {L : ℕ} (velocity : Axis → Internal → Bool)
    (axis : Axis) (a : Internal) (p : Position L) : Position L :=
  fun j => if j = axis then
    p j + if velocity axis a then -1 else 1
  else p j

noncomputable def conditionalShift {L : ℕ}
    (velocity : Axis → Internal → Bool) (axis : Axis)
    (psi : State L) : State L :=
  fun p a => psi (sourcePosition velocity axis a p) a

noncomputable def pointwiseCoin {L : ℕ} (U : Coin)
    (psi : State L) : State L :=
  fun p => U.mulVec (psi p)

noncomputable def axisFactor {L : ℕ}
    (velocity : Axis → Internal → Bool) (axis : Axis) (U : Coin)
    (psi : State L) : State L :=
  conditionalShift velocity axis (pointwiseCoin U psi)

noncomputable def successiveWalk {L : ℕ}
    (velocity : Axis → Internal → Bool)
    (Ux Uy Uz Um : Coin) (psi : State L) : State L :=
  axisFactor velocity 2 Uz
    (axisFactor velocity 1 Uy
      (axisFactor velocity 0 Ux (pointwiseCoin Um psi)))

theorem sourcePosition_bijective {L : ℕ} [NeZero L]
    (velocity : Axis → Internal → Bool) (axis : Axis) (a : Internal) :
    Function.Bijective (sourcePosition (L := L) velocity axis a) := by
  constructor
  · intro p q h
    ext j
    have hj := congr_fun h j
    have ha := congr_fun h axis
    unfold sourcePosition at *
    aesop
  · intro p
    use fun j => if j = axis then
      p j - if velocity axis a then -1 else 1 else p j
    ext j
    unfold sourcePosition
    aesop

theorem conditionalShift_inner {L : ℕ} [NeZero L]
    (velocity : Axis → Internal → Bool) (axis : Axis)
    (psi phi : State L) :
    inner (conditionalShift velocity axis psi)
        (conditionalShift velocity axis phi) = inner psi phi := by
  unfold inner conditionalShift
  rw [Finset.sum_comm]
  conv_rhs => rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  exact Equiv.sum_comp
    (Equiv.ofBijective (sourcePosition (L := L) velocity axis a)
      (sourcePosition_bijective velocity axis a))
    (fun p => star (psi p a) * phi p a)

theorem pointwiseCoin_inner {L : ℕ} [NeZero L]
    (U : Coin) (hU : IsUnitary U) (psi phi : State L) :
    inner (pointwiseCoin U psi) (pointwiseCoin U phi) = inner psi phi := by
  unfold inner
  simp [pointwiseCoin]
  have h_fubini : ∀ x : Position L,
      ∑ a, star (U.mulVec (psi x) a) * U.mulVec (phi x) a =
        ∑ a, star (psi x a) * phi x a := by
    intro x
    have h_unitary : Uᴴ * U = 1 := hU.1
    have h_simp :
        ∑ a, star ((U *ᵥ psi x) a) * (U *ᵥ phi x) a =
          ∑ a, star (psi x a) *
            (U.conjTranspose *ᵥ (U *ᵥ phi x)) a := by
      simp +decide [Matrix.mulVec, dotProduct, mul_assoc, mul_comm,
        mul_left_comm, Finset.mul_sum _ _ _]
      exact Finset.sum_comm.trans (Finset.sum_congr rfl fun _ _ =>
        Finset.sum_congr rfl fun _ _ =>
          Finset.sum_congr rfl fun _ _ => by ring)
    simp_all +decide
  simp_all +decide

/-- A finite position-register successive-axis walk is exactly norm preserving
when every internal factor is unitary. -/
theorem successiveWalk_preserves_norm {L : ℕ} [NeZero L]
    (velocity : Axis → Internal → Bool)
    (Ux Uy Uz Um : Coin)
    (hUx : IsUnitary Ux) (hUy : IsUnitary Uy)
    (hUz : IsUnitary Uz) (hUm : IsUnitary Um)
    (psi : State L) :
    inner (successiveWalk velocity Ux Uy Uz Um psi)
        (successiveWalk velocity Ux Uy Uz Um psi) = inner psi psi := by
  unfold successiveWalk
  simp +decide [*, axisFactor]
  rw [conditionalShift_inner, pointwiseCoin_inner,
    conditionalShift_inner, pointwiseCoin_inner,
    conditionalShift_inner, pointwiseCoin_inner, pointwiseCoin_inner] <;>
    assumption'

/-- A concrete four-channel sign table for three successive axes. -/
def tetraVelocity (axis : Axis) (a : Internal) : Bool :=
  match axis, a with
  | 0, 0 => true | 0, 1 => true | 0, 2 => false | 0, 3 => false
  | 1, 0 => true | 1, 1 => false | 1, 2 => true | 1, 3 => false
  | 2, 0 => true | 2, 1 => false | 2, 2 => false | 2, 3 => true

def origin {L : ℕ} : Position L := fun _ => 0

noncomputable def deltaState {L : ℕ} : State L :=
  fun p a => if p = origin ∧ a = 0 then 1 else 0

/-- The spatial shift is genuinely nonidentity on a five-site torus. -/
theorem tetrahedral_shift_nontrivial :
    conditionalShift (L := 5) tetraVelocity 0 deltaState ≠ deltaState := by
  intro h
  have h0 := congr_fun (congr_fun h origin) 0
  simp +decide [conditionalShift, deltaState] at h0

noncomputable def lossyDeleteOrigin {L : ℕ} (psi : State L) : State L :=
  fun p a => if p = origin then 0 else psi p a

/-- Negative control: deleting one site is not norm preserving. -/
theorem lossy_delete_origin_control :
    inner (lossyDeleteOrigin (L := 5) deltaState)
        (lossyDeleteOrigin (L := 5) deltaState) ≠
      inner (deltaState (L := 5)) deltaState := by
  unfold inner
  simp +decide [deltaState, lossyDeleteOrigin]
  rw [Finset.sum_eq_single origin, Finset.sum_eq_single origin] <;>
    simp +decide <;> aesop

/-- The position walk can be instantiated by the actual normalized Route-B
Clifford factors. The velocity/projector dictionary remains a successor
theorem. -/
theorem normalized_routeb_spatial_walk_preserves_norm {L : ℕ} [NeZero L]
    (velocity : Axis → Internal → Bool)
    (ax bx ay by_ az bz am bm : ℝ)
    (hx : ax ^ 2 + bx ^ 2 = 1)
    (hy : ay ^ 2 + by_ ^ 2 = 1)
    (hz : az ^ 2 + bz ^ 2 = 1)
    (hm : am ^ 2 + bm ^ 2 = 1)
    (psi : State L) :
    inner
        (successiveWalk velocity
          (normalizedFactor ax bx alpha1)
          (normalizedFactor ay by_ alpha2)
          (normalizedFactor az bz alpha3)
          (normalizedFactor am bm beta) psi)
        (successiveWalk velocity
          (normalizedFactor ax bx alpha1)
          (normalizedFactor ay by_ alpha2)
          (normalizedFactor az bz alpha3)
          (normalizedFactor am bm beta) psi) = inner psi psi := by
  apply successiveWalk_preserves_norm <;>
    apply normalized_factor_unitary <;>
    simp_all [generators_hermitian, generators_square_one]

theorem rational_routeb_position_walk_preserves_norm
    (psi : State 5) :
    inner
        (successiveWalk tetraVelocity
          (normalizedFactor (3 / 5) (4 / 5) alpha1)
          (normalizedFactor (3 / 5) (4 / 5) alpha2)
          (normalizedFactor (3 / 5) (4 / 5) alpha3)
          (normalizedFactor (3 / 5) (4 / 5) beta) psi)
        (successiveWalk tetraVelocity
          (normalizedFactor (3 / 5) (4 / 5) alpha1)
          (normalizedFactor (3 / 5) (4 / 5) alpha2)
          (normalizedFactor (3 / 5) (4 / 5) alpha3)
          (normalizedFactor (3 / 5) (4 / 5) beta) psi) = inner psi psi := by
  apply normalized_routeb_spatial_walk_preserves_norm <;> norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SuccessiveAxisPositionWalk.rational_routeb_position_walk_preserves_norm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_routeb_position_walk_preserves_norm

/-- info: 'PhysicsSM.Draft.NullEdge.SuccessiveAxisPositionWalk.tetrahedral_shift_nontrivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms tetrahedral_shift_nontrivial

/-- info: 'PhysicsSM.Draft.NullEdge.SuccessiveAxisPositionWalk.lossy_delete_origin_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lossy_delete_origin_control

end PhysicsSM.Draft.NullEdge.SuccessiveAxisPositionWalk
