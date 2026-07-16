import Mathlib

/-!
# A non-equivariant decoration destroys distributional symmetry

This atomic negative control separates invariance of a bare position law from
invariance of a decorated law. The witness is the uniform law on `Bool`, the
measure-preserving swap `Bool.not`, and a mark that records the original
fixed-frame coordinate.
-/

open MeasureTheory ProbabilityTheory

namespace PoissonDecorationKill

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

end PoissonDecorationKill
