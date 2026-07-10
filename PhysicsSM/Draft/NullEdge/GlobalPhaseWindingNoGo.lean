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
index.  The three-link control demonstrates that independent branch-adjusted
link increments can carry one unit of winding.

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

/-- Branch-adjusted link data can evade the global-lift no-go: three equal
increments carry exactly one turn. -/
theorem three_link_unit_winding :
    ([2 * Real.pi / 3, 2 * Real.pi / 3, 2 * Real.pi / 3] : List Real).sum =
      2 * Real.pi := by
  simp
  ring

/-- The one-winding link control is genuinely nonzero. -/
theorem three_link_unit_winding_ne_zero :
    ([2 * Real.pi / 3, 2 * Real.pi / 3, 2 * Real.pi / 3] : List Real).sum ≠ 0 := by
  rw [three_link_unit_winding]
  exact mul_ne_zero (by norm_num) Real.pi_ne_zero

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GlobalPhaseWindingNoGo.global_real_lift_forces_zero_winding' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms global_real_lift_forces_zero_winding

/-- info: 'PhysicsSM.Draft.NullEdge.GlobalPhaseWindingNoGo.three_link_unit_winding_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms three_link_unit_winding_ne_zero

end PhysicsSM.Draft.NullEdge.GlobalPhaseWindingNoGo
