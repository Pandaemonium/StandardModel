import Mathlib
import PhysicsSM.NullStrand.Conventions

/-!
# NullStrand.NullFiber.FiniteDesign

Finite octahedral rest-direction pilot used by the null-strand roadmap.

The six directions are plus/minus e1, plus/minus e2, plus/minus e3, with zero
time component.
-/

noncomputable section

namespace PhysicsSM.NullStrand.NullFiber

open scoped BigOperators
open Finset

def e1 : Minkowski4 := fun i : Fin 4 => if i = 1 then 1 else 0
def e2 : Minkowski4 := fun i : Fin 4 => if i = 2 then 1 else 0
def e3 : Minkowski4 := fun i : Fin 4 => if i = 3 then 1 else 0

/-- Six octahedral rest directions `±e1, ±e2, ±e3`. -/
def octaDirection (k : Fin 6) : Minkowski4 :=
  match k.val with
  | 0 => e1
  | 1 => -e1
  | 2 => e2
  | 3 => -e2
  | 4 => e3
  | 5 => -e3
  | _ => 0

/-- Sum of the six octahedral directions is zero. -/
theorem octaDirection_sum_eq_zero :
    (∑ k : Fin 6, octaDirection k) = 0 := by
  ext i
  fin_cases i <;> simp +decide [octaDirection, e1, e2, e3, Fin.sum_univ_succ]

/-- Spatial index `0,1,2` mapped to coordinates `1,2,3`. -/
def spatialIndex (i : Fin 3) : Fin 4 :=
  match i.val with
  | 0 => 1
  | 1 => 2
  | 2 => 3
  | _ => 0

/-- Mean squared moment for each spatial coordinate of the octahedral set. -/
def octaSpatialSecondMoment (i : Fin 3) : ℝ :=
  (1 / (6 : ℝ)) * (∑ k : Fin 6, (octaDirection k (spatialIndex i)) ^ 2)

/-- Each spatial second moment equals `1/3` by symmetry of the octahedral design. -/
theorem octaDirection_secondMoment_eq_oneThird (i : Fin 3) :
    octaSpatialSecondMoment i = (1 / 3 : ℝ) := by
  fin_cases i <;>
    simp +decide [octaSpatialSecondMoment, spatialIndex, octaDirection, e1, e2, e3,
      Fin.sum_univ_succ] <;> norm_num

/-- Time component of each octahedral direction is zero. -/
theorem octaDirection_time_eq_zero (k : Fin 6) : octaDirection k 0 = 0 := by
  fin_cases k <;> simp [octaDirection, e1, e2, e3]

/-- Each octahedral direction is unit spacelike: Minkowski norm `-1`. -/
theorem octaDirection_minkowskiSq_eq_neg_one (k : Fin 6) :
    minkowskiSq (octaDirection k) = -1 := by
  fin_cases k <;> simp [octaDirection, e1, e2, e3, minkowskiSq, minkowskiInner]

/-- Finite exact null resolution identity `U = (1/6) Σ (U + ξ)`. -/
theorem octaNull_mean_eq_timelike (U : Minkowski4) :
    (1 / (6 : ℝ)) • (∑ k : Fin 6, (fun i => U i + octaDirection k i)) = U := by
  ext i
  fin_cases i <;> simp [octaDirection, e1, e2, e3, Fin.sum_univ_succ] <;> ring

end PhysicsSM.NullStrand.NullFiber
