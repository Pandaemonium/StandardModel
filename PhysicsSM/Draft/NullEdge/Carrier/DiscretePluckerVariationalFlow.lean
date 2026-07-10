import PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian

/-!
# An action-derived discrete Pluecker flow

An adjacent-link kinetic-minus-Pluecker Lagrangian has exact left and right
derivatives. Their discrete Euler-Lagrange equation selects a second-order
recurrence, and that recurrence preserves a nontrivial quadratic first
integral. The stiffness parameter can be instantiated by the same arbitrary
spinor Pluecker invariant that appears as the finite action Hessian.

This closes a finite action-to-EOM-to-step-to-conservation chain. The discrete
Lagrangian itself remains selected, and stability, interactions, field degrees
of freedom, and a continuum limit are separate obligations.

Provenance: theorem shape informed by discrete variational mechanics; proofs
completed by Aristotle project `535b0922-8096-431f-84e6-7b928aa30810` and
locally validated from an in-progress snapshot on 2026-07-10.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerVariationalFlow

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary
open PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass
open PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian

abbrev State := ℝ × ℝ

/-- One-link discrete Lagrangian: kinetic difference minus Pluecker stiffness. -/
noncomputable def lagrangian (mu q next : ℝ) : ℝ :=
  (1 / 2 : ℝ) * (next - q) ^ 2 - (1 / 2 : ℝ) * mu * q ^ 2

/-- The finite Euler-Lagrange residual for consecutive values `(prev,q,next)`. -/
def eulerLagrange (mu prev q next : ℝ) : ℝ :=
  (q - prev) + (q - next) - mu * q

/-- The recurrence selected by the discrete Euler-Lagrange equation. -/
def step (mu : ℝ) (x : State) : State :=
  (x.2, (2 - mu) * x.2 - x.1)

/-- The exact quadratic first integral of the variational recurrence. -/
def firstIntegral (mu : ℝ) (x : State) : ℝ :=
  x.1 ^ 2 + x.2 ^ 2 - (2 - mu) * x.1 * x.2

theorem lagrangian_hasDerivAt_right (mu prev q : ℝ) :
    HasDerivAt (fun x => lagrangian mu prev x) (q - prev) q := by
  have h : HasDerivAt (fun x => lagrangian mu prev x)
      ((1 / 2 : ℝ) * (2 * (q - prev) ^ (2 - 1) * (1 - 0)) - 0) q := by
    apply HasDerivAt.sub
    · exact HasDerivAt.const_mul _
        (((hasDerivAt_id q).sub (hasDerivAt_const q prev)).pow 2)
    · exact hasDerivAt_const q _
  convert h using 1; ring

theorem lagrangian_hasDerivAt_left (mu q next : ℝ) :
    HasDerivAt (fun x => lagrangian mu x next) (q - next - mu * q) q := by
  have h : HasDerivAt (fun x => lagrangian mu x next)
      ((1 / 2 : ℝ) * (2 * (next - q) ^ (2 - 1) * (0 - 1))
        - (1 / 2 : ℝ) * mu * (2 * q ^ (2 - 1) * 1)) q := by
    apply HasDerivAt.sub
    · exact HasDerivAt.const_mul _
        (((hasDerivAt_const q next).sub (hasDerivAt_id q)).pow 2)
    · exact HasDerivAt.const_mul _ ((hasDerivAt_id q).pow 2)
  convert h using 1; ring

theorem euler_lagrange_eq_adjacent_variations (mu prev q next : ℝ) :
    eulerLagrange mu prev q next =
      (q - prev) + (q - next - mu * q) := by
  -- By definition of eulerLagrange, we have:
  simp [eulerLagrange];
  -- By simplifying, we can see that both sides are equal.
  ring

theorem euler_lagrange_iff_recurrence (mu prev q next : ℝ) :
    eulerLagrange mu prev q next = 0 ↔
      next = (2 - mu) * q - prev := by
  unfold eulerLagrange; constructor <;> intro h <;> linarith;

theorem step_satisfies_euler_lagrange (mu : ℝ) (x : State) :
    eulerLagrange mu x.1 x.2 (step mu x).2 = 0 := by
  simp only [eulerLagrange, step]; ring

theorem first_integral_conserved (mu : ℝ) (x : State) :
    firstIntegral mu (step mu x) = firstIntegral mu x := by
  unfold firstIntegral; unfold step; ring;

theorem rational_plucker_flow_control :
    step (4 / 25) ((0, 1) : State) = (1, 46 / 25) ∧
      eulerLagrange (4 / 25) 0 1 (46 / 25) = 0 ∧
      firstIntegral (4 / 25) (step (4 / 25) ((0, 1) : State)) = 1 ∧
      firstIntegral (4 / 25) ((0, 1) : State) = 1 := by
  -- Let's simplify the goal.
  norm_num [step, eulerLagrange, firstIntegral]

/-- A wrong-sign potential recurrence fails the displayed first integral. -/
theorem wrong_sign_control :
    firstIntegral (4 / 25) ((1, (2 + 4 / 25)) : State) ≠
      firstIntegral (4 / 25) ((0, 1) : State) := by
  norm_num [ firstIntegral ]

/-- The action-derived recurrence conserves its first integral when the
stiffness is the supplied pair's Pluecker invariant, and that stiffness is
exactly the positive-direction Hessian of the finite action. -/
theorem spinor_variational_flow_conserved
    (psi phi : CSpinor) (x : State) (q : Quartet) :
    firstIntegral (massSq psi phi) (step (massSq psi phi) x) =
        firstIntegral (massSq psi phi) x ∧
      massSq psi phi =
        action psi phi (q + qe2) + action psi phi (q - qe2) -
          2 * action psi phi q := by
  refine ⟨first_integral_conserved _ _, ?_⟩
  exact (action_positive_hessian psi phi q).symm

theorem rational_plucker_variational_control :
    massSq edge0 (edge1 (2 / 5)) = 4 / 25 ∧
      step (massSq edge0 (edge1 (2 / 5))) ((0, 1) : State) =
        (1, 46 / 25) ∧
      firstIntegral (massSq edge0 (edge1 (2 / 5))) ((0, 1) : State) = 1 := by
  norm_num [massSq, edge0, edge1, spinorWedge, Complex.normSq,
    step, firstIntegral]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerVariationalFlow.lagrangian_hasDerivAt_left' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lagrangian_hasDerivAt_left

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerVariationalFlow.spinor_variational_flow_conserved' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spinor_variational_flow_conserved

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerVariationalFlow.rational_plucker_variational_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_plucker_variational_control

end PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerVariationalFlow
