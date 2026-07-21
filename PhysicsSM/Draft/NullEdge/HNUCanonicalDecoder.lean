import PhysicsSM.Draft.NullEdge.HNUDecodedLocalStay

/-!
# Canonical orthogonal decoder for the local HNU selected sector

The integrated local construction used a convenient coordinate-reading left
inverse. This draft replaces that choice by the normalized orthogonal
coefficient along the selected transverse profile `w`. It asks for exact
encode/decode projector identities and the induced real-space dynamics.

This removes an arbitrary coordinate choice in the decoder. It does not derive
the transverse selector from a physical symmetry or action.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.FloquetTransverseComposite
open PhysicsSM.Draft.NullEdge.HNUDecodedLocalStay

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUCanonicalDecoder

/-- Normalized orthogonal coefficient along the selected profile `w`. -/
def canonicalDecode {L : Nat} (psi : ExtendedState L) :
    PhysicsSM.Draft.NullEdge.HNURealSpace.State L :=
  fun x s => (1 / 5 : Complex) * dotProduct w (fun t => psi x (t, s))

/-- Constant nonzero control state. -/
def constantOneState (L : Nat) :
    PhysicsSM.Draft.NullEdge.HNURealSpace.State L :=
  fun _ _ => 1

/-- The canonical decoder is a left inverse of the physical embedding. -/
theorem canonicalDecode_encode {L : Nat}
    (phi : PhysicsSM.Draft.NullEdge.HNURealSpace.State L) :
    canonicalDecode (encode phi) = phi := by
  ext x s
  simp [canonicalDecode, encode, dotProduct, w, Fin.sum_univ_three]
  ring

/-- Decoding and re-encoding is exactly the onsite orthogonal selector. -/
theorem encode_canonicalDecode {L : Nat} (psi : ExtendedState L) :
    encode (canonicalDecode psi) = selected psi := by
  ext x q
  unfold encode canonicalDecode selected
  rw [selector_mulVec]
  simp
  ring

/-- The canonical coefficient ignores precisely the orthogonal complement. -/
theorem canonicalDecode_selected {L : Nat} (psi : ExtendedState L) :
    canonicalDecode (selected psi) = canonicalDecode psi := by
  rw [← encode_canonicalDecode psi, canonicalDecode_encode]

/-- The decoded physical update is exactly the original local HNU schedule. -/
theorem canonicalDecode_update_encode {L : Nat} [NeZero L]
    (phi : PhysicsSM.Draft.NullEdge.HNURealSpace.State L) :
    canonicalDecode (update (encode phi)) =
      PhysicsSM.Draft.NullEdge.HNURealSpace.schedule phi := by
  rw [update_encode, canonicalDecode_encode]

/-- Nonvacuity: the canonical decoder recovers an explicit nonzero encoded
state rather than annihilating the selected sector. -/
theorem canonicalDecode_nonzero_control {L : Nat} [NeZero L] :
    canonicalDecode (encode (constantOneState L)) = constantOneState L := by
  exact canonicalDecode_encode (constantOneState L)

/-! ## Decoder-class audit -/

/-
The canonical decoder is additive.
-/
theorem canonicalDecode_add {L : Nat} (psi phi : ExtendedState L) :
    canonicalDecode (psi + phi) = canonicalDecode psi + canonicalDecode phi := by
  ext x s; simp +decide [canonicalDecode] <;> ring
  simp +decide [dotProduct, Finset.sum_add_distrib, mul_add, add_mul]

/-
The canonical decoder is homogeneous over the complex scalars.
-/
theorem canonicalDecode_smul {L : Nat} (c : Complex) (psi : ExtendedState L) :
    canonicalDecode (c • psi) = c • canonicalDecode psi := by
  ext x s
  simp +decide [canonicalDecode]
  ring
  simp +decide [dotProduct, mul_left_comm, Finset.mul_sum _ _ _]

/-
Strict fiberwise locality: an output coefficient reads only the matching
site and spin fiber, not any other lattice site or spin component.
-/
theorem canonicalDecode_fiberwise_local {L : Nat} (psi phi : ExtendedState L) (x) (s)
    (h : ∀ t, psi x (t, s) = phi x (t, s)) :
    canonicalDecode psi x s = canonicalDecode phi x s := by
  unfold canonicalDecode
  simp +decide [h]

/-
The canonical decoder annihilates the onsite selector complement.
-/
theorem canonicalDecode_complement {L : Nat} (psi : ExtendedState L) :
    canonicalDecode (complement psi) = 0 := by
  unfold complement
  ext x s
  simp +decide [canonicalDecode, dotProduct, selector]
  norm_num [Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  simp +decide [w, vecMulVec]
  ring

/-! ## Uniqueness among local complex-linear decoders -/

/-- The explicit hypothesis package for a fiberwise complex-linear local
left decoder. No arbitrary function is called "linear" or "local" without
these laws: both complex-linear laws and strict locality at each site-spin
fiber are fields, alongside complement annihilation and left inversion. -/
structure IsFiberwiseComplexLinearLocalDecoder {L : Nat}
    (D : ExtendedState L → PhysicsSM.Draft.NullEdge.HNURealSpace.State L) : Prop where
  map_add : ∀ psi phi, D (psi + phi) = D psi + D phi
  map_smul : ∀ (c : Complex) psi, D (c • psi) = c • D psi
  fiberwise_local : ∀ (psi phi : ExtendedState L) x s,
    (∀ t, psi x (t, s) = phi x (t, s)) → D psi x s = D phi x s
  annihilates_complement : ∀ psi, D (complement psi) = 0
  left_inverse : ∀ phi, D (encode phi) = phi

/-
The canonical decoder itself satisfies every visible requirement of the
class, so the uniqueness theorem below is nonvacuous.
-/
theorem canonicalDecode_isFiberwiseComplexLinearLocalDecoder {L : Nat} :
    IsFiberwiseComplexLinearLocalDecoder (@canonicalDecode L) := by
  refine ⟨canonicalDecode_add, canonicalDecode_smul, ?_,
    canonicalDecode_complement, canonicalDecode_encode⟩
  intro psi phi x s h
  exact canonicalDecode_fiberwise_local psi phi x s h

/-- Global uniqueness in the explicitly stated decoder class. In fact, the
proof shows that additivity, complement annihilation, and left inversion force
the result; complex homogeneity and fiberwise locality remain visible because
they are defining requirements of the decoder class requested here. -/
theorem canonicalDecode_unique {L : Nat}
    (D : ExtendedState L → PhysicsSM.Draft.NullEdge.HNURealSpace.State L)
    (hD : IsFiberwiseComplexLinearLocalDecoder D) :
    D = canonicalDecode := by
  funext psi
  have hsplit : D psi = D (selected psi + complement psi) := by
    rw [selected_add_complement]
  rw [hsplit, hD.map_add, hD.annihilates_complement, add_zero,
    ← encode_canonicalDecode, hD.left_inverse]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCanonicalDecoder.encode_canonicalDecode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms encode_canonicalDecode

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCanonicalDecoder.canonicalDecode_update_encode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalDecode_update_encode

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCanonicalDecoder.canonicalDecode_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalDecode_unique

end PhysicsSM.Draft.NullEdge.HNUCanonicalDecoder
