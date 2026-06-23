import Mathlib.Tactic

/-!
# P9 boundary-over-volume scaling scaffold

This draft module isolates the finite arithmetic behind the P9 area-vs-volume
route. If a source-visible sector is bounded by a boundary-size count while the
observer volume grows one dimension faster, the selected trace density scales
like boundary divided by volume.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9BoundaryVolumeScaling

/-- Toy four-dimensional volume growth at linear scale `L`. -/
def volume4 (L : Real) : Real := L ^ 4

/-- Toy boundary growth with coefficient `C` at linear scale `L`. -/
def boundary4 (C L : Real) : Real := C * L ^ 3

/-- Boundary-over-volume density. -/
def boundaryDensity4 (C L : Real) : Real := boundary4 C L / volume4 L

/-- In four dimensions, boundary-over-volume density is `C / L`. -/
theorem boundaryDensity4_eq_C_div_L
    (C L : Real) (hL : Not (L = 0)) :
    boundaryDensity4 C L = C / L := by
  unfold boundaryDensity4 boundary4 volume4
  field_simp [hL]

/--
If the linear scale is at least `C / eps`, the toy boundary-over-volume density
is at most `eps`.
-/
theorem boundaryDensity4_le_eps_of_scale_ge
    {C L eps : Real}
    (hC : 0 <= C) (hLpos : 0 < L) (heps : 0 < eps)
    (hscale : C / eps <= L) :
    boundaryDensity4 C L <= eps := by
  have _hC : 0 <= C := hC
  rw [boundaryDensity4_eq_C_div_L C L (ne_of_gt hLpos)]
  have hmul : C <= eps * L := by
    calc
      C = (C / eps) * eps := by
        field_simp [ne_of_gt heps]
      _ <= L * eps := by
        exact mul_le_mul_of_nonneg_right hscale (le_of_lt heps)
      _ = eps * L := by
        ring
  calc
    C / L <= (eps * L) / L := by
      exact div_le_div_of_nonneg_right hmul (le_of_lt hLpos)
    _ = eps := by
      field_simp [ne_of_gt hLpos]

/-- For fixed coefficient `C`, doubling the scale halves the toy density. -/
theorem boundaryDensity4_double_scale
    (C L : Real) (hL : Not (L = 0)) :
    boundaryDensity4 C (2 * L) = boundaryDensity4 C L / 2 := by
  have h2L : Not (2 * L = 0) := by
    intro h
    have hLzero : L = 0 := by nlinarith
    exact hL hLzero
  rw [boundaryDensity4_eq_C_div_L C (2 * L) h2L,
    boundaryDensity4_eq_C_div_L C L hL]
  field_simp [hL]

end PhysicsSM.Draft.NullEdgeP9BoundaryVolumeScaling

end
