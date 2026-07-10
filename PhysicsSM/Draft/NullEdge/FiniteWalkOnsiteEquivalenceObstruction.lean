import PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit

/-!
# An onsite-equivalence obstruction from Brillouin-corner aliases

Comparing two translation-invariant quantum walks requires specifying the
allowed equivalence.  A momentum-independent onsite basis change acts on every
symbol by the same unitary conjugation.  Such a change preserves equality of
symbols at distinct momenta.  It therefore cannot remove the three exact
zero-quasienergy corner aliases of the live successive-axis walk.

The final no-go theorem is deliberately conditional: any proposed comparison
walk that separates the origin from `(pi,pi,0)` cannot be related to the live
walk by one constant onsite unitary.  A momentum-dependent transformation,
blocking, a changed unit cell, or a coarse-graining map is outside this theorem.
This is the appropriate discriminator for a future detailed comparison with
tetrahedral and body-centered-cubic Dirac walks; no claim about their unevaluated
full symbols is made here.

Provenance: clean-room finite matrix consequence of the corner-alias theorems
in `Finite3Plus1BrillouinAudit`.  Lean 4.28.0.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.FiniteWalkOnsiteEquivalenceObstruction

open PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- Apply one momentum-independent internal basis change to a matrix-valued
symbol. -/
def onsiteConjugate {K : Type*} (V : Mat4) (A : K -> Mat4) (k : K) : Mat4 :=
  V * A k * Vᴴ

/-- A constant unitary onsite conjugation preserves and reflects equality of
symbols at any two momenta. -/
theorem onsiteConjugate_eq_iff {K : Type*} (V : Mat4) (A : K -> Mat4)
    (hV : V ∈ Matrix.unitaryGroup (Fin 4) Complex) (k p : K) :
    onsiteConjugate V A k = onsiteConjugate V A p ↔ A k = A p := by
  constructor
  · intro h
    have h' := congrArg (fun M : Mat4 => Vᴴ * M * V) h
    have hleft : Vᴴ * V = 1 := Matrix.mem_unitaryGroup_iff'.mp hV
    have hright : V * Vᴴ = 1 := Matrix.mem_unitaryGroup_iff.mp hV
    simp only [onsiteConjugate, Matrix.mul_assoc] at h'
    simp only [← Matrix.mul_assoc, hleft, Matrix.one_mul] at h'
    simpa only [Matrix.mul_one] using h'
  · intro h
    simp [onsiteConjugate, h]

/-- Boolean-corner symbol after a constant onsite basis change. -/
def conjugatedCornerWalk (V : Mat4) (bx by_ bz : Bool) : Mat4 :=
  V * cornerWalk bx by_ bz * Vᴴ

/-- Every constant onsite basis change inherits all three nonzero
zero-quasienergy aliases of the live walk. -/
theorem conjugated_origin_aliases (V : Mat4) :
    conjugatedCornerWalk V false false false =
        conjugatedCornerWalk V true true false ∧
      conjugatedCornerWalk V false false false =
        conjugatedCornerWalk V true false true ∧
      conjugatedCornerWalk V false false false =
        conjugatedCornerWalk V false true true := by
  unfold conjugatedCornerWalk
  rw [zero_quasienergy_corner_values.1,
    zero_quasienergy_corner_values.2.1,
    zero_quasienergy_corner_values.2.2.1,
    zero_quasienergy_corner_values.2.2.2]
  simp

/-- **Onsite-equivalence no-go criterion.** If a candidate corner symbol
separates the origin from `(pi,pi,0)`, no momentum-independent onsite matrix
can conjugate the live corner symbol to it.  Unitarity of the candidate basis
change is not needed for this one-way obstruction. -/
theorem no_constant_onsite_equivalence_of_corner_separation
    (target : Bool -> Bool -> Bool -> Mat4)
    (hsep : target false false false ≠ target true true false) :
    ¬ ∃ V : Mat4, ∀ bx by_ bz,
        target bx by_ bz = conjugatedCornerWalk V bx by_ bz := by
  rintro ⟨V, hV⟩
  apply hsep
  rw [hV false false false, hV true true false]
  exact (conjugated_origin_aliases V).1

/-- A second independent discriminator using the `(pi,0,pi)` alias. -/
theorem no_constant_onsite_equivalence_of_second_corner_separation
    (target : Bool -> Bool -> Bool -> Mat4)
    (hsep : target false false false ≠ target true false true) :
    ¬ ∃ V : Mat4, ∀ bx by_ bz,
        target bx by_ bz = conjugatedCornerWalk V bx by_ bz := by
  rintro ⟨V, hV⟩
  apply hsep
  rw [hV false false false, hV true false true]
  exact (conjugated_origin_aliases V).2.1

end PhysicsSM.Draft.NullEdge.FiniteWalkOnsiteEquivalenceObstruction

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteWalkOnsiteEquivalenceObstruction.onsiteConjugate_eq_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteWalkOnsiteEquivalenceObstruction.onsiteConjugate_eq_iff

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteWalkOnsiteEquivalenceObstruction.no_constant_onsite_equivalence_of_corner_separation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteWalkOnsiteEquivalenceObstruction.no_constant_onsite_equivalence_of_corner_separation
