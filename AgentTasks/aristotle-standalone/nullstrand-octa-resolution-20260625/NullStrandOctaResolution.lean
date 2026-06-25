import Mathlib

/-!
# NullStrand finite null resolution + octahedral instance (manifest DEF-004, KIN-004)

`FiniteNullResolution`: a finite probability law on normalized future-null
directions with prescribed barycenter `U` (the public kinematic interface every
flux theorem assumes). `octahedralResolution`: the exact six-direction octahedral
design `U ± e_i` instantiates it for the rest vector — rational coordinates, exact
first two moments (improved roadmap §5.2, W1).

Convention: Minkowski `(+---)`. Mathlib-only; focused Aristotle target.
-/

namespace NullStrand.NullFiber

open scoped BigOperators
open Finset

/-- Minkowski `(+---)` inner product on real 4-vectors. -/
def minkowskiInner (p q : Fin 4 → ℝ) : ℝ :=
  p 0 * q 0 - p 1 * q 1 - p 2 * q 2 - p 3 * q 3

/-- DEF-004. A finite probability law on normalized future-null directions with
prescribed barycenter `U`. -/
structure FiniteNullResolution (Ω : Type*) [Fintype Ω] (U : Fin 4 → ℝ) where
  weight : Ω → ℝ
  dir : Ω → (Fin 4 → ℝ)
  weight_nonneg : ∀ w, 0 ≤ weight w
  weight_sum : ∑ w, weight w = 1
  null : ∀ w, minkowskiInner (dir w) (dir w) = 0
  normalized : ∀ w, minkowskiInner U (dir w) = 1
  barycenter : ∑ w, weight w • dir w = U

/-- The six octahedral rest-frame null directions `U ± e_i`. -/
def octaDir : Fin 6 → (Fin 4 → ℝ) :=
  ![![1, 1, 0, 0], ![1, -1, 0, 0], ![1, 0, 1, 0], ![1, 0, -1, 0], ![1, 0, 0, 1], ![1, 0, 0, -1]]

/-- KIN-004. The octahedral design instantiates `FiniteNullResolution` for the
rest vector `(1,0,0,0)`. -/
noncomputable def octahedralResolution : FiniteNullResolution (Fin 6) ![1, 0, 0, 0] where
  weight := fun _ => (1 : ℝ) / 6
  dir := octaDir
  weight_nonneg := by sorry
  weight_sum := by sorry
  null := by sorry
  normalized := by sorry
  barycenter := by sorry

end NullStrand.NullFiber
