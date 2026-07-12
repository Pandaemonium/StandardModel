import PhysicsSM.Draft.NullEdge.FullBlochSplitDeterminants
import PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge

/-!
# Global chirality boundary of the live ordered Bloch step

This target tests the actual all-momentum split step. It asks whether the same
constant chirality that splits the local cubic tangent commutes with the full
Bloch update. The intended sharp answer is: exactly in the massless angles
where `sin theta = 0`.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.FullBlochGlobalChirality

open FullBlochSplitDeterminants

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

noncomputable def Xi : Mat4 :=
  PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge.Xi

theorem Xi_sq : Xi * Xi = 1 := by
  sorry

theorem Xi_commutes_alpha1 : Xi * alpha1 = alpha1 * Xi := by
  sorry

theorem Xi_commutes_alpha2 : Xi * alpha2 = alpha2 * Xi := by
  sorry

theorem Xi_commutes_alpha3 : Xi * alpha3 = alpha3 * Xi := by
  sorry

theorem Xi_anticommutes_beta : Xi * beta + beta * Xi = 0 := by
  sorry

theorem Xi_commutes_spatial_factor (q : Real) (A : Mat4)
    (hA : Xi * A = A * Xi) :
    Xi * factor q A = factor q A * Xi := by
  sorry

/-- The complete massless live Bloch step has a global constant chirality. -/
theorem massless_splitStep_commutes (qx qy qz : Real) :
    Xi * splitStep qx qy qz 0 = splitStep qx qy qz 0 * Xi := by
  sorry

/-- Sharp global boundary: the complete live step commutes with this chirality
exactly when its mass angle has zero sine. -/
theorem splitStep_commutes_iff_sin_theta_zero
    (qx qy qz theta : Real) :
    (Xi * splitStep qx qy qz theta = splitStep qx qy qz theta * Xi) ↔
      Real.sin theta = 0 := by
  sorry

/-- Mandatory nonzero control at a quarter-turn mass angle. -/
theorem quarter_mass_breaks_global_chirality :
    Xi * splitStep 0 0 0 (Real.pi / 2) ≠
      splitStep 0 0 0 (Real.pi / 2) * Xi := by
  sorry

end PhysicsSM.Draft.NullEdge.FullBlochGlobalChirality
