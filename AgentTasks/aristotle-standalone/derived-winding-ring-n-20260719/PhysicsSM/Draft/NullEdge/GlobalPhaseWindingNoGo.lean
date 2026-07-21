import PhysicsSM.Draft.NullEdge.VariablePlueckerPhaseConnection

/-!
# No nonzero winding from a global real phase lift

On a finite periodic cycle, the raw increments of a globally single-valued
real phase telescope exactly to zero.  Therefore a nonzero winding number
cannot be extracted from the `PhaseField` used for local chiral conjugacy
without extra branch, patch-transition, or link data.  In particular, a
nonzero complex-mass defect must either meet a zero of the Pluecker field or
carry transition data on which no global real lift exists.

This is a theorem-level obstruction, not a construction of the missing defect
index.  The three-link control is packaged as an explicit periodic link field
with integer winding, and is proved not to arise from any global real lift.

Provenance: elementary finite telescoping on `ZMod`; clean-room formalization
motivated by the local phase connection in
`VariablePlueckerPhaseConnection`.  Lean 4.28.0.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.GlobalPhaseWindingNoGo

/-- Raw one-edge difference of a globally defined real phase lift. -/
def rawPhaseIncrement {L : Nat} (theta : ZMod L -> Real) (p : ZMod L) : Real :=
  theta (p + 1) - theta p

/-- Every globally lifted phase has exactly zero total raw increment around a
finite periodic cycle. -/
theorem rawPhaseIncrement_sum_zero {L : Nat} [NeZero L]
    (theta : ZMod L -> Real) :
    ∑ p : ZMod L, rawPhaseIncrement theta p = 0 := by
  unfold rawPhaseIncrement
  rw [Finset.sum_sub_distrib]
  have hshift := Equiv.sum_comp (Equiv.addRight (1 : ZMod L)) theta
  have hshift' : (∑ p : ZMod L, theta (p + 1)) = ∑ p, theta p := by
    simpa [add_comm] using hshift
  rw [hshift']
  exact sub_self _

/-- **Global-lift winding no-go.** If the raw increment sum is declared to be
`2*pi*w`, then the integer winding must be zero. -/
theorem global_real_lift_forces_zero_winding {L : Nat} [NeZero L]
    (theta : ZMod L -> Real) (w : Int)
    (hwind : (∑ p : ZMod L, rawPhaseIncrement theta p) =
      (2 * Real.pi) * (w : Real)) :
    w = 0 := by
  rw [rawPhaseIncrement_sum_zero] at hwind
  have hprod : (2 * Real.pi) * (w : Real) = 0 := hwind.symm
  have htwoPi : (2 * Real.pi : Real) ≠ 0 :=
    mul_ne_zero (by norm_num) Real.pi_ne_zero
  have hwReal : (w : Real) = 0 :=
    (mul_eq_zero.mp hprod).resolve_left htwoPi
  exact_mod_cast hwReal

/-- Independent periodic link increments together with their integer winding
constraint.  Unlike `rawPhaseIncrement`, this data need not admit a global
real-valued vertex potential. -/
structure LinkWindingData (L : Nat) [NeZero L] where
  increment : ZMod L -> Real
  winding : Int
  sum_eq_turns :
    ∑ p : ZMod L, increment p = (2 * Real.pi) * (winding : Real)

/-- Three equal branch-adjusted links carrying one turn. -/
def threeLinkUnitWinding : LinkWindingData 3 where
  increment := fun _ => 2 * Real.pi / 3
  winding := 1
  sum_eq_turns := by
    norm_num [Finset.sum_const]
    ring

/-- The explicit three-link field has winding one. -/
theorem threeLinkUnitWinding_winding : threeLinkUnitWinding.winding = 1 := rfl

/-- The explicit three-link field sums to one complete turn. -/
theorem three_link_unit_winding :
    ∑ p : ZMod 3, threeLinkUnitWinding.increment p = 2 * Real.pi := by
  rw [threeLinkUnitWinding.sum_eq_turns]
  rw [threeLinkUnitWinding_winding]
  norm_num

/-- The one-winding link control is genuinely nonzero. -/
theorem three_link_unit_winding_ne_zero :
    (∑ p : ZMod 3, threeLinkUnitWinding.increment p) ≠ 0 := by
  rw [three_link_unit_winding]
  exact mul_ne_zero (by norm_num) Real.pi_ne_zero

/-- The winding-one link field is genuinely patched data: no globally defined
real vertex phase has these raw increments on every edge. -/
theorem threeLinkUnitWinding_not_global_lift :
    ¬ ∃ theta : ZMod 3 -> Real,
      ∀ p, rawPhaseIncrement theta p = threeLinkUnitWinding.increment p := by
  rintro ⟨theta, htheta⟩
  have hsum :
      (∑ p : ZMod 3, rawPhaseIncrement theta p) =
        ∑ p : ZMod 3, threeLinkUnitWinding.increment p := by
    exact Finset.sum_congr rfl fun p _ => htheta p
  rw [rawPhaseIncrement_sum_zero, three_link_unit_winding] at hsum
  exact (mul_ne_zero (by norm_num) Real.pi_ne_zero) hsum.symm

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GlobalPhaseWindingNoGo.global_real_lift_forces_zero_winding' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms global_real_lift_forces_zero_winding

/-- info: 'PhysicsSM.Draft.NullEdge.GlobalPhaseWindingNoGo.three_link_unit_winding_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms three_link_unit_winding_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.GlobalPhaseWindingNoGo.threeLinkUnitWinding_not_global_lift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms threeLinkUnitWinding_not_global_lift

end PhysicsSM.Draft.NullEdge.GlobalPhaseWindingNoGo
