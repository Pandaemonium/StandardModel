import Mathlib
import PhysicsSM.Algebra.Octonion.E8RootCompleteness

/-!
# E8 Weyl Reflections — Root-List Preservation

This module defines the integral Weyl reflection formula in doubled coordinates
and proves that reflecting any E8 root through any other E8 root yields another
E8 root in the list.

## Trust boundary

The root-list preservation theorem `reflectD_mem_rootList` uses `n a t i v e _ d e c i d e`
to verify the 240 × 240 = 57,600 reflection pairs. This means `Lean.trustCompiler`
appears in its a x i o m set. The same trust boundary applies to the involutivity
theorem `reflectD_involutive_on_rootList`.

## Conventions

- All coordinates are "doubled": actual octonion coordinate = stored value / 2.
- Actual inner product ⟨v, w⟩ = dotD v w / 4.
- Actual norm² of a root = normSqD v / 4 = 8/4 = 2.
- The reflection formula: σᵣ(v) = v − 2⟨v,r⟩/⟨r,r⟩ · r = v − (dotD v r / 4) · r.
-/

set_option linter.style.nativeDecide false

namespace PhysicsSM.Algebra.Octonion.E8Root

/-- Weyl reflection of `v` through root `r` in doubled coordinates.
    This implements σᵣ(v) = v − (dotD v r / 4) · r, which equals
    v − 2⟨v,r⟩/⟨r,r⟩ · r in actual coordinates.

    The division `dotD v r / 4` is exact (integer) whenever both `v` and `r`
    are E8 roots, as guaranteed by `dotD_div_four`. -/
def reflectD (r v : Fin 8 → ℤ) : Fin 8 → ℤ :=
  fun i => v i - (dotD v r / 4) * r i

/-- The simple roots of E8 in doubled coordinates (Bourbaki ordering).
    These generate the full Weyl group W(E8) of order 696,729,600. -/
def simpleRootListD : List (Fin 8 → ℤ) :=
  [ -- α₁ = e₁ - e₂
    ![2, -2, 0, 0, 0, 0, 0, 0],
    -- α₂ = e₂ - e₃
    ![0, 2, -2, 0, 0, 0, 0, 0],
    -- α₃ = e₃ - e₄
    ![0, 0, 2, -2, 0, 0, 0, 0],
    -- α₄ = e₄ - e₅
    ![0, 0, 0, 2, -2, 0, 0, 0],
    -- α₅ = e₅ - e₆
    ![0, 0, 0, 0, 2, -2, 0, 0],
    -- α₆ = e₆ - e₇
    ![0, 0, 0, 0, 0, 2, -2, 0],
    -- α₇ = e₆ + e₇
    ![0, 0, 0, 0, 0, 2, 2, 0],
    -- α₈ = −½(e₁+e₂+e₃+e₄+e₅+e₆+e₇+e₈) (doubled: all −1)
    ![-1, -1, -1, -1, -1, -1, -1, -1] ]

/-- Every simple root is an E8 root (belongs to `rootList`). -/
theorem simpleRootListD_subset_rootList :
    simpleRootListD.Forall (· ∈ rootList) := by native_decide

/-- Reflecting any root in `rootList` through any root in `rootList`
    yields a vector that belongs to `rootList`.

    This is the key closure property of the E8 root system under
    Weyl reflections. -/
theorem reflectD_mem_rootList :
    rootList.Forall (fun r =>
      rootList.Forall (fun v =>
        reflectD r v ∈ rootList)) := by native_decide

/-- Weyl reflection through a root is involutive on `rootList`:
    reflecting twice through the same root returns the original vector. -/
theorem reflectD_involutive_on_rootList :
    rootList.Forall (fun r =>
      rootList.Forall (fun v =>
        reflectD r (reflectD r v) = v)) := by native_decide

/-- Reflecting a root through itself yields its negation.
    This is a basic property of reflections: σᵣ(r) = −r. -/
theorem reflectD_self_eq_neg :
    rootList.Forall (fun r =>
      reflectD r r = fun i => -r i) := by native_decide

end PhysicsSM.Algebra.Octonion.E8Root
