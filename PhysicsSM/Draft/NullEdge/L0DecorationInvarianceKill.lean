import Mathlib

/-!
# Non-equivariant decorations can destroy distributional symmetry

This module supplies a finite negative control for the Lorentz-in-distribution
program. A bare probability law may be invariant under a symmetry while an
unchanged fixed-frame mark makes the decorated joint law non-invariant.

The witness is the uniform law on `Bool`, the measure-preserving swap
`Bool.not`, and a mark that records the original coordinate. The two decorated
pushforwards differ on the singleton `{(true, true)}`.

This is an abstract finite distributional counterexample. It does not prove a
Lorentz theorem, classify point-process decorations, or show that every frame
decoration breaks Lorentz invariance. Its role is to make equivariance an
explicit necessary gate rather than an implicit assumption.

The proof was returned by Aristotle project
`ac97f093-2b43-4e74-b16b-feef9597d03f` and replayed under Lean 4.28.
-/

open MeasureTheory ProbabilityTheory

namespace PhysicsSM.Draft.NullEdge.L0DecorationInvarianceKill

/-- There is a probability law and a measure-preserving symmetry for which an
unchanged fixed-frame mark breaks invariance of the joint decorated law. -/
theorem arbitrary_decoration_breaks_invariance :
    ∃ (Y : Type) (_ : MeasurableSpace Y) (P : Measure Y)
      (_ : IsProbabilityMeasure P) (T : Y → Y),
      MeasurePreserving T P P ∧
      Measure.map (fun x => (T x, x)) P ≠
        Measure.map (fun x => (x, x)) P := by
  refine ⟨Bool, inferInstance, (PMF.uniformOfFintype Bool).toMeasure,
    inferInstance, Bool.not, ⟨by measurability, ?_⟩, ?_⟩
  · rw [PMF.toMeasure_map _ _ (by measurability)]
    congr 1
    ext b
    rw [PMF.map_apply]
    simp only [PMF.uniformOfFintype_apply]
    rw [tsum_bool]
    cases b <;> simp
  · intro h
    have hmeas : MeasurableSet ({(true, true)} : Set (Bool × Bool)) := by
      measurability
    have h1 :=
      congrArg (fun μ => μ ({(true, true)} : Set (Bool × Bool))) h
    simp only at h1
    rw [Measure.map_apply (by measurability) hmeas,
      Measure.map_apply (by measurability) hmeas] at h1
    have hlhs :
        (fun x => (Bool.not x, x)) ⁻¹' ({(true, true)} : Set (Bool × Bool)) =
          ∅ := by
      ext x
      cases x <;> simp
    have hrhs :
        (fun x : Bool => (x, x)) ⁻¹' ({(true, true)} : Set (Bool × Bool)) =
          {true} := by
      ext x
      cases x <;> simp
    rw [hlhs, hrhs] at h1
    simp only [measure_empty] at h1
    rw [PMF.toMeasure_apply_singleton _ _ (by measurability)] at h1
    simp only [PMF.uniformOfFintype_apply] at h1
    rw [eq_comm, ENNReal.inv_eq_zero] at h1
    exact (by norm_num : (2 : ENNReal) ≠ ⊤) h1

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.L0DecorationInvarianceKill.arbitrary_decoration_breaks_invariance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms arbitrary_decoration_breaks_invariance

end PhysicsSM.Draft.NullEdge.L0DecorationInvarianceKill
