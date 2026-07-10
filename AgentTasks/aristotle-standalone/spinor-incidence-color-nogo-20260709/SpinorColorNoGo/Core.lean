import Mathlib

noncomputable section

open Matrix Complex

namespace SpinorIncidenceColorNoGo

abbrev CSpinor := Fin 2 → ℂ

def spinorWedge (psi phi : CSpinor) : ℂ :=
  psi 0 * phi 1 - psi 1 * phi 0

def complexAbsSq (z : ℂ) : ℝ := Complex.normSq z

/-- Exact `GL(2,C)` functor law for the spinor wedge. -/
theorem wedge_mulVec (S : Matrix (Fin 2) (Fin 2) ℂ) (psi phi : CSpinor) :
    spinorWedge (S.mulVec psi) (S.mulVec phi) =
      S.det * spinorWedge psi phi := by
  sorry

theorem sl2_preserves_wedge
    (S : Matrix (Fin 2) (Fin 2) ℂ) (hS : S.det = 1)
    (psi phi : CSpinor) :
    spinorWedge (S.mulVec psi) (S.mulVec phi) = spinorWedge psi phi := by
  sorry

theorem sl2_preserves_wedge_normSq
    (S : Matrix (Fin 2) (Fin 2) ℂ) (hS : S.det = 1)
    (psi phi : CSpinor) :
    complexAbsSq (spinorWedge (S.mulVec psi) (S.mulVec phi)) =
      complexAbsSq (spinorWedge psi phi) := by
  sorry

theorem invertible_preserves_collinearity
    (S : Matrix (Fin 2) (Fin 2) ℂ) (hS : S.det ≠ 0)
    (psi phi : CSpinor) :
    spinorWedge (S.mulVec psi) (S.mulVec phi) = 0 ↔
      spinorWedge psi phi = 0 := by
  sorry

def shearWitness : Matrix (Fin 2) (Fin 2) ℂ := !![1, 1; 0, 1]

theorem shearWitness_det : shearWitness.det = 1 := by
  sorry

theorem shearWitness_moves : shearWitness.mulVec ![0, 1] ≠ ![0, 1] := by
  sorry

theorem sl2_nondegenerate_witness :
    ∃ S : Matrix (Fin 2) (Fin 2) ℂ,
      S.det = 1 ∧ (∃ psi : CSpinor, S.mulVec psi ≠ psi) ∧
      (∀ psi phi : CSpinor,
        spinorWedge (S.mulVec psi) (S.mulVec phi) =
          spinorWedge psi phi) := by
  sorry

theorem finrank_spinor : Module.finrank ℂ (Fin 2 → ℂ) = 2 := by
  sorry

theorem finrank_color : Module.finrank ℂ (Fin 3 → ℂ) = 3 := by
  sorry

/-- No faithful complex-linear color triplet fits in the primitive spinor. -/
theorem color_to_spinor_not_injective :
    ¬ ∃ f : (Fin 3 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ), Function.Injective f := by
  sorry

theorem color_map_has_nontrivial_kernel
    (f : (Fin 3 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ)) :
    0 < Module.finrank ℂ (LinearMap.ker f) := by
  sorry

theorem no_color_spinor_linearEquiv :
    ¬ Nonempty ((Fin 3 → ℂ) ≃ₗ[ℂ] (Fin 2 → ℂ)) := by
  sorry

/-- The obstruction disappears on a carrier with an explicit internal factor. -/
theorem color_embeds_in_larger_carrier :
    ∃ f : (Fin 3 → ℂ) →ₗ[ℂ] (Fin 3 → (Fin 2 → ℂ)),
      Function.Injective f := by
  sorry

theorem spinor_incidence_color_nogo :
    (∃ S : Matrix (Fin 2) (Fin 2) ℂ,
        S.det = 1 ∧ (∃ psi : CSpinor, S.mulVec psi ≠ psi) ∧
        (∀ psi phi : CSpinor,
          spinorWedge (S.mulVec psi) (S.mulVec phi) =
            spinorWedge psi phi))
      ∧ (¬ ∃ f : (Fin 3 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ), Function.Injective f)
      ∧ (∀ f : (Fin 3 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ),
          0 < Module.finrank ℂ (LinearMap.ker f))
      ∧ (¬ Nonempty ((Fin 3 → ℂ) ≃ₗ[ℂ] (Fin 2 → ℂ)))
      ∧ (∃ f : (Fin 3 → ℂ) →ₗ[ℂ] (Fin 3 → (Fin 2 → ℂ)),
          Function.Injective f) := by
  sorry

end SpinorIncidenceColorNoGo
