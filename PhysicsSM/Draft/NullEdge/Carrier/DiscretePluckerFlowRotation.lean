import PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerFlowStability

/-!
# Exact rotation form of the action-derived Pluecker flow

On the elliptic parameter circle, an injective phase-coordinate change
conjugates the selected Euler-Lagrange recurrence to an exact unit-circle
rotation. The rational Pluecker stiffness `mu=4/25` gives
`c=23/25` and `s=4*sqrt(6)/25`, so every iterate preserves Euclidean phase
energy in the transformed coordinates.

The normalization `c^2+s^2=1` is load-bearing. The originally prepared target
omitted it and is false at `(mu,c,s,x)=(0,1,1,(0,1))`; this module records that
counterexample explicitly. The theorem derives a reversible rotation law from
the selected adjacent-link recurrence, but does not derive the action, choose a
physical time calibration, or establish a continuum field equation.

Provenance: Aristotle project `e4dfa6d2-cc6f-4785-a50d-720701e96ca3`
identified the missing normalization hypothesis and completed the corrected
proofs; integrated through the live variational-flow API on 2026-07-10.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerFlowRotation

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary
open PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian
open PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerVariationalFlow

/-- Coordinates in which the second-order recurrence becomes a rotation. -/
noncomputable def phaseCoordinates (c s : ℝ) (x : State) : State :=
  (x.2, (c * x.2 - x.1) / s)

def rotation (c s : ℝ) (x : State) : State :=
  (c * x.1 + s * x.2, -s * x.1 + c * x.2)

theorem phaseCoordinates_injective (c s : ℝ) (hs : s ≠ 0) :
    Function.Injective (phaseCoordinates c s) := by
  intro a b h
  simp only [phaseCoordinates, Prod.mk.injEq] at h
  obtain ⟨h1, h2⟩ := h
  rw [div_eq_div_iff hs hs] at h2
  have h2' := mul_right_cancel₀ hs h2
  have hx1 : a.1 = b.1 := by
    rw [h1] at h2'
    linarith
  exact Prod.ext hx1 h1

/-- After the phase-coordinate change, the recurrence is exactly a rotation.
The circle normalization is necessary, not cosmetic. -/
theorem phaseCoordinates_intertwines_step
    (mu c s : ℝ) (htrace : 2 - mu = 2 * c)
    (hnorm : c ^ 2 + s ^ 2 = 1) (hs : s ≠ 0)
    (x : State) :
    phaseCoordinates c s (step mu x) =
      rotation c s (phaseCoordinates c s x) := by
  simp only [phaseCoordinates, step, rotation, Prod.mk.injEq]
  refine ⟨?_, ?_⟩
  · field_simp
    linear_combination x.2 * htrace
  · field_simp
    linear_combination c * x.2 * htrace + x.2 * hnorm

theorem rotation_energy_conserved (c s : ℝ)
    (hnorm : c ^ 2 + s ^ 2 = 1) (x : State) :
    (rotation c s x).1 ^ 2 + (rotation c s x).2 ^ 2 =
      x.1 ^ 2 + x.2 ^ 2 := by
  simp only [rotation]
  nlinarith [hnorm]

theorem iterated_phase_energy_conserved
    (mu c s : ℝ) (htrace : 2 - mu = 2 * c)
    (hnorm : c ^ 2 + s ^ 2 = 1) (hs : s ≠ 0)
    (n : ℕ) (x : State) :
    let y := phaseCoordinates c s x
    let yn := phaseCoordinates c s ((step mu)^[n] x)
    yn.1 ^ 2 + yn.2 ^ 2 = y.1 ^ 2 + y.2 ^ 2 := by
  simp only
  induction n with
  | zero => simp
  | succ k ih =>
    rw [Function.iterate_succ', Function.comp_apply,
      phaseCoordinates_intertwines_step mu c s htrace hnorm hs,
      rotation_energy_conserved c s hnorm]
    exact ih

noncomputable def pluckerCosine : ℝ := 23 / 25

noncomputable def pluckerSine : ℝ := 4 * Real.sqrt 6 / 25

theorem plucker_phase_controls :
    2 - (4 / 25 : ℝ) = 2 * pluckerCosine ∧
      pluckerCosine ^ 2 + pluckerSine ^ 2 = 1 ∧
      pluckerSine ≠ 0 := by
  refine ⟨by norm_num [pluckerCosine], ?_, ?_⟩
  · have h6 : Real.sqrt 6 ^ 2 = 6 := Real.sq_sqrt (by norm_num)
    have hps : pluckerSine ^ 2 = 96 / 625 := by
      simp only [pluckerSine]
      rw [div_pow, mul_pow, h6]
      norm_num
    rw [hps]
    norm_num [pluckerCosine]
  · simp only [pluckerSine]
    have : Real.sqrt 6 > 0 := Real.sqrt_pos.mpr (by norm_num)
    positivity

/-- The nonzero `mu=4/25` action-derived recurrence is exactly conjugate to a
unit-circle rotation and has conserved Euclidean phase energy. -/
theorem rational_plucker_flow_conjugate_to_rotation :
    Function.Injective (phaseCoordinates pluckerCosine pluckerSine) ∧
      (∀ x : State,
        phaseCoordinates pluckerCosine pluckerSine (step (4 / 25) x) =
          rotation pluckerCosine pluckerSine
            (phaseCoordinates pluckerCosine pluckerSine x)) ∧
      (∀ n : ℕ, ∀ x : State,
        let y := phaseCoordinates pluckerCosine pluckerSine x
        let yn := phaseCoordinates pluckerCosine pluckerSine
          ((step (4 / 25))^[n] x)
        yn.1 ^ 2 + yn.2 ^ 2 = y.1 ^ 2 + y.2 ^ 2) := by
  obtain ⟨htrace, hnorm, hs⟩ := plucker_phase_controls
  refine ⟨phaseCoordinates_injective _ _ hs, ?_, ?_⟩
  · intro x
    exact phaseCoordinates_intertwines_step
      (4 / 25) _ _ htrace hnorm hs x
  · intro n x
    exact iterated_phase_energy_conserved
      (4 / 25) _ _ htrace hnorm hs n x

/-- The rotation law is attached to the same nonzero spinor Pluecker invariant
that supplies the selected recurrence stiffness. -/
theorem rational_spinor_flow_rotation_control :
    massSq edge0 (edge1 (2 / 5)) = 4 / 25 ∧
      Function.Injective (phaseCoordinates pluckerCosine pluckerSine) ∧
      (∀ x : State,
        phaseCoordinates pluckerCosine pluckerSine
            (step (massSq edge0 (edge1 (2 / 5))) x) =
          rotation pluckerCosine pluckerSine
            (phaseCoordinates pluckerCosine pluckerSine x)) := by
  have hmass : massSq edge0 (edge1 (2 / 5)) = 4 / 25 := by
    norm_num [massSq, edge0, edge1, spinorWedge, Complex.normSq]
  refine ⟨hmass, rational_plucker_flow_conjugate_to_rotation.1, ?_⟩
  rw [hmass]
  exact rational_plucker_flow_conjugate_to_rotation.2.1

/-- Without circle normalization, trace matching and a nonzero denominator do
not imply conjugacy. -/
theorem normalization_is_load_bearing :
    2 - (0 : ℝ) = 2 * 1 ∧ (1 : ℝ) ≠ 0 ∧
      phaseCoordinates 1 1 (step 0 ((0, 1) : State)) ≠
        rotation 1 1 (phaseCoordinates 1 1 ((0, 1) : State)) := by
  norm_num [phaseCoordinates, step, rotation]

theorem wrong_cosine_control :
    2 - (4 / 25 : ℝ) ≠ 2 * (3 / 5 : ℝ) := by
  norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerFlowRotation.rational_plucker_flow_conjugate_to_rotation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_plucker_flow_conjugate_to_rotation

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerFlowRotation.normalization_is_load_bearing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normalization_is_load_bearing

end PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerFlowRotation
