import Mathlib

/-!
# NullStrand.NullFiber.Barycentric

Manifest nodes DEF-004 and KIN-004: the public PMF-style finite null-resolution
interface (a finite probability law on normalized future-null directions with a
prescribed barycenter `U`), and its exact octahedral instance `U ± e_i` for the
rest vector — rational coordinates with exact first two moments (improved roadmap
§5.2, W1).

Placed in a dedicated `Barycentric` sub-namespace so its `FiniteNullResolution`
and local `minkowskiInner` do not collide with the raw-weight resolution in
`NullLift.FiniteResidualCurrent` or `Conventions.minkowskiInner`.

Provenance: clean-room statements; proofs from Aristotle project
`e675d945-d923-4298-807b-4f0c74f52b9e`, verified `sorry`/`axiom`-free and
statement-identical, integrated 2026-06-25.
-/

namespace PhysicsSM.NullStrand.NullFiber.Barycentric

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
  weight_nonneg := by intro w; norm_num
  weight_sum := by simp [Finset.sum_const]
  null := by intro w; fin_cases w <;> simp [minkowskiInner, octaDir]
  normalized := by intro w; fin_cases w <;> simp [minkowskiInner, octaDir]
  barycenter := by
    funext i
    fin_cases i
    all_goals simp [octaDir, Fin.sum_univ_six]
    all_goals norm_num

end PhysicsSM.NullStrand.NullFiber.Barycentric
