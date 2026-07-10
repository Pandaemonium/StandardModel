import PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerVariationalFlow

/-!
# Stability of the action-derived discrete Pluecker flow

The quadratic first integral of `DiscretePluckerVariationalFlow` decomposes
into two weighted squares. It is nonnegative on `0 <= mu <= 4`, positive
definite on `0 < mu < 4`, and yields an explicit uniform bound on every
iterate when `0 < mu <= 2`.

This supplies a finite Lyapunov-stability theorem for the selected discrete
Lagrangian. It does not derive that Lagrangian from more primitive data, select
a physical time scale, establish a continuum limit, or introduce dissipation.

Provenance: theorem target and controls prepared locally; proofs completed by
Aristotle project `04affe6e-0743-465f-bd70-179795f8f827` and adapted to reuse
the live variational-flow definitions on 2026-07-10.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerFlowStability

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary
open PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian
open PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerVariationalFlow

theorem first_integral_decomposition (mu : ℝ) (x : State) :
    firstIntegral mu x =
      (mu / 4) * (x.1 + x.2) ^ 2 +
        ((4 - mu) / 4) * (x.1 - x.2) ^ 2 := by
  unfold firstIntegral
  ring

theorem first_integral_nonnegative (mu : ℝ)
    (hmu0 : 0 ≤ mu) (hmu4 : mu ≤ 4) (x : State) :
    0 ≤ firstIntegral mu x := by
  rw [first_integral_decomposition]
  nlinarith [sq_nonneg (x.1 + x.2), sq_nonneg (x.1 - x.2)]

theorem first_integral_zero_iff (mu : ℝ)
    (hmu0 : 0 < mu) (hmu4 : mu < 4) (x : State) :
    firstIntegral mu x = 0 ↔ x = 0 := by
  rw [first_integral_decomposition]
  constructor <;> intro h <;> simp_all +decide [Prod.ext_iff]
  have h1 : (x.1 + x.2) ^ 2 = 0 := by
    nlinarith
  have h2 : (x.1 - x.2) ^ 2 = 0 := by
    nlinarith
  grind +qlia

theorem iterate_first_integral_conserved (mu : ℝ) (n : ℕ) (x : State) :
    firstIntegral mu ((step mu)^[n] x) = firstIntegral mu x := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [Function.iterate_succ_apply', first_integral_conserved, ih]

theorem coordinate_bound (mu : ℝ) (hmu2 : mu ≤ 2) (x : State) :
    (mu / 2) * (x.1 ^ 2 + x.2 ^ 2) ≤ firstIntegral mu x := by
  unfold firstIntegral
  nlinarith [sq_nonneg (x.1 - x.2)]

theorem all_iterates_bounded (mu : ℝ) (hmu0 : 0 < mu) (hmu2 : mu ≤ 2)
    (n : ℕ) (x : State) :
    0 < mu / 2 ∧
      (mu / 2) * ((((step mu)^[n] x).1) ^ 2 +
        (((step mu)^[n] x).2) ^ 2) ≤ firstIntegral mu x := by
  refine ⟨by positivity, ?_⟩
  convert iterate_first_integral_conserved mu n x ▸
    coordinate_bound mu hmu2 _ using 1

/-- Every iterate is bounded when the stiffness is a positive Pluecker mass
square no greater than two. The hypotheses display the selected stability
window rather than hiding it in the physical interpretation. -/
theorem spinor_all_iterates_bounded (psi phi : CSpinor)
    (hpos : 0 < massSq psi phi) (hle : massSq psi phi ≤ 2)
    (n : ℕ) (x : State) :
    0 < massSq psi phi / 2 ∧
      (massSq psi phi / 2) *
          (((((step (massSq psi phi))^[n] x).1) ^ 2) +
            ((((step (massSq psi phi))^[n] x).2) ^ 2)) ≤
        firstIntegral (massSq psi phi) x :=
  all_iterates_bounded (massSq psi phi) hpos hle n x

theorem rational_stability_control :
    firstIntegral (4 / 25) ((0, 1) : State) = 1 ∧
      (4 / 25 : ℝ) / 2 * ((0 : ℝ) ^ 2 + 1 ^ 2) ≤ 1 ∧
      firstIntegral 5 ((1, -1) : State) < 0 := by
  norm_num [firstIntegral]

/-- The nonzero Pluecker pair gives a stable action-derived flow, while the
explicit `mu = 5` state shows that positivity does not extend past the proved
window. -/
theorem rational_plucker_stability_control :
    massSq edge0 (edge1 (2 / 5)) = 4 / 25 ∧
      0 < massSq edge0 (edge1 (2 / 5)) ∧
      massSq edge0 (edge1 (2 / 5)) ≤ 2 ∧
      (∀ n : ℕ,
        (massSq edge0 (edge1 (2 / 5)) / 2) *
            (((((step (massSq edge0 (edge1 (2 / 5))))^[n]
                ((0, 1) : State)).1) ^ 2) +
              ((((step (massSq edge0 (edge1 (2 / 5))))^[n]
                ((0, 1) : State)).2) ^ 2)) ≤ 1) ∧
      firstIntegral 5 ((1, -1) : State) < 0 := by
  have hmass : massSq edge0 (edge1 (2 / 5)) = 4 / 25 := by
    norm_num [massSq, edge0, edge1, spinorWedge, Complex.normSq]
  refine ⟨hmass, by rw [hmass]; norm_num, by rw [hmass]; norm_num, ?_, ?_⟩
  · intro n
    rw [hmass]
    have hbound := all_iterates_bounded (4 / 25) (by norm_num) (by norm_num)
      n ((0, 1) : State)
    norm_num [firstIntegral] at hbound ⊢
    exact hbound
  · norm_num [firstIntegral]

/-- Positive coordinate-control coefficient on the full elliptic window. -/
noncomputable def stabilityCoefficient (mu : ℝ) : ℝ :=
  min mu (4 - mu) / 2

theorem stability_coefficient_positive (mu : ℝ)
    (hmu0 : 0 < mu) (hmu4 : mu < 4) :
    0 < stabilityCoefficient mu := by
  unfold stabilityCoefficient
  have hmin : 0 < min mu (4 - mu) := lt_min hmu0 (by linarith)
  linarith

/-- The positive-definite first integral controls the Euclidean coordinate
norm on the full elliptic window `0 < mu < 4`. -/
theorem full_window_coordinate_bound (mu : ℝ) (x : State) :
    stabilityCoefficient mu * (x.1 ^ 2 + x.2 ^ 2) ≤
      firstIntegral mu x := by
  rw [first_integral_decomposition]
  unfold stabilityCoefficient
  have hm1 : min mu (4 - mu) ≤ mu := min_le_left _ _
  have hm2 : min mu (4 - mu) ≤ 4 - mu := min_le_right _ _
  nlinarith [mul_nonneg (sub_nonneg.mpr hm1) (sq_nonneg (x.1 + x.2)),
    mul_nonneg (sub_nonneg.mpr hm2) (sq_nonneg (x.1 - x.2))]

theorem all_iterates_full_window_bounded (mu : ℝ)
    (hmu0 : 0 < mu) (hmu4 : mu < 4)
    (n : ℕ) (x : State) :
    0 < stabilityCoefficient mu ∧
      stabilityCoefficient mu *
          ((((step mu)^[n] x).1) ^ 2 + (((step mu)^[n] x).2) ^ 2) ≤
        firstIntegral mu x := by
  refine ⟨stability_coefficient_positive mu hmu0 hmu4, ?_⟩
  have hbound :=
    full_window_coordinate_bound mu ((step mu)^[n] x)
  rw [iterate_first_integral_conserved] at hbound
  exact hbound

theorem spinor_all_iterates_full_window_bounded (psi phi : CSpinor)
    (hpos : 0 < massSq psi phi) (hlt : massSq psi phi < 4)
    (n : ℕ) (x : State) :
    0 < stabilityCoefficient (massSq psi phi) ∧
      stabilityCoefficient (massSq psi phi) *
          (((((step (massSq psi phi))^[n] x).1) ^ 2) +
            ((((step (massSq psi phi))^[n] x).2) ^ 2)) ≤
        firstIntegral (massSq psi phi) x :=
  all_iterates_full_window_bounded (massSq psi phi) hpos hlt n x

/-- `mu=3` lies outside the earlier `mu<=2` bound but inside the true stable
window; `mu=5` remains an indefinite failure control. -/
theorem upper_half_window_control :
    stabilityCoefficient 3 = 1 / 2 ∧
      0 < stabilityCoefficient 3 ∧
      (∀ n : ℕ,
        stabilityCoefficient 3 *
            ((((step 3)^[n] ((0, 1) : State)).1) ^ 2 +
              (((step 3)^[n] ((0, 1) : State)).2) ^ 2) ≤ 1) ∧
      firstIntegral 5 ((1, -1) : State) < 0 := by
  refine ⟨by norm_num [stabilityCoefficient],
    by norm_num [stabilityCoefficient], ?_, by norm_num [firstIntegral]⟩
  intro n
  have hbound := (all_iterates_full_window_bounded 3
    (by norm_num) (by norm_num) n ((0, 1) : State)).2
  have hvalue : firstIntegral 3 ((0, 1) : State) = 1 := by
    norm_num [firstIntegral]
  rw [hvalue] at hbound
  exact hbound

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerFlowStability.all_iterates_bounded' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms all_iterates_bounded

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerFlowStability.rational_plucker_stability_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_plucker_stability_control

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerFlowStability.all_iterates_full_window_bounded' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms all_iterates_full_window_bounded

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerFlowStability.upper_half_window_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms upper_half_window_control

end PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerFlowStability
