import Mathlib

/-!
# NullStrand.NullFiber.OctaSecondMoment

Manifest node KIN-003 (isotropy half): the six octahedral rest-space directions
`±e_i` have exactly isotropic second moment `(1/6) ∑_a (ξ_a)_i (ξ_a)_j = (1/3) δ_ij`.
Together with the vanishing first moment (`octaNull_mean_eq_timelike`), this makes
the octahedral fan an exact spherical 2-design — the reason it reproduces continuum
rest isotropy with only six rational directions (improved roadmap §5.2, W1).

Provenance: clean-room statement; proof from Aristotle project
`43e6ddc9-dc11-49cf-a5bf-0f843da02247`, verified `sorry`/`axiom`-free and
statement-identical, integrated 2026-06-25.
-/

namespace PhysicsSM.NullStrand.NullFiber

open scoped BigOperators
open Finset

/-- The six octahedral rest-space unit directions `±e_i`. -/
def octaXi : Fin 6 → (Fin 3 → ℝ) :=
  ![![1, 0, 0], ![-1, 0, 0], ![0, 1, 0], ![0, -1, 0], ![0, 0, 1], ![0, 0, -1]]

/-- KIN-003 (isotropy). The octahedral second moment is `(1/3) δ_ij`. -/
theorem octa_secondMoment_isotropic (i j : Fin 3) :
    (1 / 6 : ℝ) * ∑ a, octaXi a i * octaXi a j = if i = j then 1 / 3 else 0 := by
  fin_cases i <;> fin_cases j <;> simp [octaXi, Fin.sum_univ_six] <;> norm_num

end PhysicsSM.NullStrand.NullFiber
