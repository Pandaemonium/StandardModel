import Mathlib

/-!
# NullStrand octahedral second moment (manifest node KIN-003, isotropy half)

`octa_secondMoment_isotropic`: the six octahedral rest-space directions `±e_i`
have exactly isotropic second moment `(1/6) ∑_a (ξ_a)_i (ξ_a)_j = (1/3) δ_ij`.
Together with the (already proven) vanishing first moment, this makes the
octahedral fan an exact spherical 2-design — the reason it reproduces the rest
isotropy of the continuum null measure with only six rational directions
(improved roadmap §5.2, W1).

Mathlib-only; focused Aristotle target.
-/

namespace NullStrand.NullFiber

open scoped BigOperators
open Finset

/-- The six octahedral rest-space unit directions `±e_i`. -/
def octaXi : Fin 6 → (Fin 3 → ℝ) :=
  ![![1, 0, 0], ![-1, 0, 0], ![0, 1, 0], ![0, -1, 0], ![0, 0, 1], ![0, 0, -1]]

/-- KIN-003 (isotropy). The octahedral second moment is `(1/3) δ_ij`. -/
theorem octa_secondMoment_isotropic (i j : Fin 3) :
    (1 / 6 : ℝ) * ∑ a, octaXi a i * octaXi a j = if i = j then 1 / 3 else 0 := by
  sorry

end NullStrand.NullFiber
