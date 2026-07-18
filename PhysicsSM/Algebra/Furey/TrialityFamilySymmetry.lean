import PhysicsSM.Algebra.Furey.TrialityTriple

/-!
# The Z3 triality family symmetry: three generations as one triality orbit

SM-branch foundation, item 4 (three generations), 2026-07-17. The Furey-Hughes
triality-triple scaffold (`TrialityTriple`, arXiv:2409.17948) provides the three
representation slots `{spinorPlus, spinorMinus, vector}` but, by its own claim
boundary, asserts NO action or equivariance. This module adds the missing
piece: the `Z3` triality automorphism cyclically permuting the three slots, and
proves it has order three and acts transitively - so the three slots form a
SINGLE triality orbit. This is the algebraic content of "three generations from
triality": the `Z3 subset S3 = Out(Spin(8))` outer automorphism forces exactly
three, in one orbit, not two and not four.

Derived here: the `Z3` family symmetry (order 3, transitive, single orbit).
Still open (brick 4's deeper remainder): that these three orbit slots ARE the
three physical fermion generations with the correct `SU(3) x SU(2) x U(1)`
representation content - which requires the full `Spin(8)` triality on the
`C(x)H(x)O` representation space, not just the permutation of labels.

Clean-room; [comp] for the triality route (Furey-Hughes), [orig] for the
formalization. Axiom footprint at or below standard-three (guards below).
-/

noncomputable section

namespace PhysicsSM.Algebra.Furey.TrialityFamilySymmetry

open PhysicsSM.Algebra.Furey

/-- The `Z3` triality cycle on the three representation roles:
`spinorPlus -> spinorMinus -> vector -> spinorPlus`. -/
def trialityCycle : TrialityRole → TrialityRole
  | .spinorPlus => .spinorMinus
  | .spinorMinus => .vector
  | .vector => .spinorPlus

/-- **Triality has order three.** Applying the cycle three times is the
identity, so it generates a `Z3` - matching the order-3 heart of the
`S3 = Out(Spin(8))` triality automorphism. -/
theorem trialityCycle_order_three (r : TrialityRole) :
    trialityCycle (trialityCycle (trialityCycle r)) = r := by
  cases r <;> rfl

/-- The cycle is not the identity (it genuinely permutes the slots). -/
theorem trialityCycle_ne_id : trialityCycle ≠ id := by
  intro h
  have := congrFun h TrialityRole.spinorPlus
  simp [trialityCycle] at this

/-- **Transitivity: the three roles form one triality orbit.** Every role is
reached from `spinorPlus` by iterating the cycle, so the three generations are a
single `Z3` orbit - exactly three, none distinguished. -/
theorem trialityCycle_transitive (r : TrialityRole) :
    r = TrialityRole.spinorPlus ∨
      r = trialityCycle TrialityRole.spinorPlus ∨
      r = trialityCycle (trialityCycle TrialityRole.spinorPlus) := by
  cases r
  · exact Or.inl rfl
  · exact Or.inr (Or.inl rfl)
  · exact Or.inr (Or.inr rfl)

/-- The three-element role type is finite (local instance; `TrialityRole` derives
only `DecidableEq/Repr/Inhabited` upstream). -/
instance : Fintype TrialityRole :=
  ⟨{TrialityRole.spinorPlus, TrialityRole.spinorMinus, TrialityRole.vector},
    by intro x; cases x <;> decide⟩

/-- **The orbit has exactly three elements.** As a permutation of the
three-element role type, the triality cycle's orbit is the whole type - the
three-generation count is `Fintype.card TrialityRole = 3`. -/
theorem triality_generation_count : Fintype.card TrialityRole = 3 := by
  decide

/-- The cycle is a bijection (an automorphism of the role set). -/
theorem trialityCycle_bijective : Function.Bijective trialityCycle := by
  constructor
  · intro a b h; cases a <;> cases b <;> simp_all [trialityCycle]
  · intro b; cases b
    · exact ⟨TrialityRole.vector, rfl⟩
    · exact ⟨TrialityRole.spinorPlus, rfl⟩
    · exact ⟨TrialityRole.spinorMinus, rfl⟩

end PhysicsSM.Algebra.Furey.TrialityFamilySymmetry

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Algebra.Furey.TrialityFamilySymmetry.trialityCycle_order_three' does not depend on any axioms -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Algebra.Furey.TrialityFamilySymmetry.trialityCycle_order_three

/-- info: 'PhysicsSM.Algebra.Furey.TrialityFamilySymmetry.triality_generation_count' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Algebra.Furey.TrialityFamilySymmetry.triality_generation_count

end
