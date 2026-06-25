import Mathlib
import PhysicsSM.NullStrand.NullFiber.Basic
import PhysicsSM.NullStrand.NullFiber.FiniteDesign

/-!
# NullStrand.NullFiber.FiniteRestFrame

Rest-frame finite octahedral lift in explicit `(+---)` coordinates.

This is a concrete finite instance of the abstract `NullFiber` / `RestSphere`
interface in `PhysicsSM.NullStrand.NullFiber.Basic` for the standard rest
observer `U₀ = (1,0,0,0)`.  It is used as a small consistency and test bed
for the later intrinsic-measure constructions.
-/

noncomputable section

namespace PhysicsSM.NullStrand.NullFiber

open scoped BigOperators
open Finset

/-- Rest-frame observer used for the finite octahedral design examples. -/
def restObserver : Minkowski4 := fun i => if i = 0 then 1 else 0

/-- Rest observer is unit future timelike. -/
theorem restObserver_isUnitFutureTimelike : IsUnitFutureTimelike restObserver := by
  constructor
  · dsimp [IsFuture, restObserver]
    simp
  · dsimp [minkowskiSq, minkowskiInner, restObserver]
    norm_num

/-- Finite octahedral null lift in the rest frame is well-defined. -/
theorem octaDirection_restObserver_lifts (k : Fin 6) :
    Nonempty (NullFiber restObserver) := by
  have hFuture : IsFuture (fun i => restObserver i + octaDirection k i) := by
    dsimp [IsFuture, restObserver]
    rw [octaDirection_time_eq_zero k]
    norm_num
  have hNull : IsNull (fun i => restObserver i + octaDirection k i) := by
    dsimp [IsNull, minkowskiSq, minkowskiInner, restObserver]
    fin_cases k <;> simp [octaDirection, e1, e2, e3]
  have hNorm : minkowskiInner restObserver (fun i => restObserver i + octaDirection k i) = 1 := by
    dsimp [minkowskiInner, restObserver]
    fin_cases k <;> simp [octaDirection, e1, e2, e3]
  exact ⟨restToNull restObserver
      (xi := ⟨fun i => octaDirection k i, by
        dsimp [minkowskiInner, restObserver]
        fin_cases k <;> simp [octaDirection, e1, e2, e3], by
        simpa using octaDirection_minkowskiSq_eq_neg_one k⟩)
      hFuture hNull hNorm⟩

end PhysicsSM.NullStrand.NullFiber
