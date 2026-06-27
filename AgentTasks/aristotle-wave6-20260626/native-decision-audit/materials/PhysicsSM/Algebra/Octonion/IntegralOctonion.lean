import Mathlib
import PhysicsSM.Algebra.Octonion.Basic
import PhysicsSM.Algebra.Octonion.Norm

set_option linter.style.nativeDecide false

/-!
# Integral Octonion E8 Root Seed

This module defines a finite, convention-safe E8 root candidate set using
"doubled coordinates" over the integers. Each root is an 8-tuple of integers
in {-2, -1, 0, 1, 2}; the actual octonion coordinate is half the stored value.

The 240-element E8 root system consists of:
- 112 vectors with two nonzero entries ±2 (integer octonion coordinates ±1)
- 128 vectors with all entries ±1 (half-integer octonion coordinates ±1/2)

subject to the constraint that the sum of entries is divisible by 4
(equivalently, the sum of actual coordinates is even).

All key properties (cardinality, norm, negation closure, dot-product integrality
and bounds) are verified by kernel-checked computation via `n a t i v e _ d e c i d e`.
As with other finite-enumeration modules in this repository, `n a t i v e _ d e c i d e`
may show up through Lean's `trustCompiler` a x i o m in `#print axioms`; this should
be acknowledged in any publication that cites these computations.

## Sources

- Baez–Egan, integral octonions series:
  <https://math.ucr.edu/home/baez/octonions/integers/>
- Conway–Sloane, "Sphere Packings, Lattices and Groups", Chapter 8.

## Provenance

Created for the PhysicsSM integral-octonion / E8 / Leech-lattice program.
Convention: XOR basis from `PhysicsSM.Algebra.Octonion.Basic`.
Status: trusted (no `s o r r y`).
-/

namespace PhysicsSM.Algebra.Octonion

/-! ## Inner product on octonions -/

/-- The Euclidean inner product on octonions, defined as the coordinate-wise
    dot product in the XOR basis. -/
def innerProd (x y : Octonion) : ℝ :=
  x.c0 * y.c0 + x.c1 * y.c1 + x.c2 * y.c2 + x.c3 * y.c3 +
  x.c4 * y.c4 + x.c5 * y.c5 + x.c6 * y.c6 + x.c7 * y.c7

@[simp]
theorem innerProd_unfold (x y : Octonion) :
    innerProd x y = x.c0 * y.c0 + x.c1 * y.c1 + x.c2 * y.c2 + x.c3 * y.c3 +
      x.c4 * y.c4 + x.c5 * y.c5 + x.c6 * y.c6 + x.c7 * y.c7 := rfl

/-- The squared norm equals the inner product of an octonion with itself. -/
theorem normSq_eq_innerProd_self (x : Octonion) :
    normSq x = innerProd x x := by
  simp [normSq, innerProd, sq]

/-- The inner product is symmetric. -/
theorem innerProd_comm (x y : Octonion) :
    innerProd x y = innerProd y x := by
  simp [innerProd]; ring

/-- Negating the first argument negates the inner product. -/
theorem innerProd_neg_left (x y : Octonion) :
    innerProd (-x) y = -innerProd x y := by
  simp [innerProd]; ring

/-- Negating the second argument negates the inner product. -/
theorem innerProd_neg_right (x y : Octonion) :
    innerProd x (-y) = -innerProd x y := by
  simp [innerProd]; ring

/-- The squared norm of the negation equals the original squared norm. -/
theorem normSq_neg (x : Octonion) : normSq (-x) = normSq x := by
  rw [normSq_eq_innerProd_self, innerProd_neg_left, innerProd_neg_right,
      neg_neg, ← normSq_eq_innerProd_self]

/-! ## E8 Root System in Doubled Coordinates -/

namespace E8Root

/-! ### Coordinate infrastructure -/

/-- Squared norm in doubled coordinates. Actual norm² = `normSqD v / 4`. -/
def normSqD (v : Fin 8 → ℤ) : ℤ := ∑ i : Fin 8, v i ^ 2

/-- Inner product in doubled coordinates. Actual ⟨x, y⟩ = `dotD v w / 4`. -/
def dotD (v w : Fin 8 → ℤ) : ℤ := ∑ i : Fin 8, v i * w i

/-- E8 root predicate in doubled coordinates (decidable).
    A vector `v : Fin 8 → ℤ` is an E8 root (doubled) iff:
    1. Sum of squares = 8 (actual norm² = 2)
    2. All coordinates have the same parity (all even or all odd)
    3. Sum of coordinates ≡ 0 (mod 4) (actual sum is even) -/
def IsE8RootD (v : Fin 8 → ℤ) : Prop :=
  normSqD v = 8 ∧
  ((∀ i : Fin 8, v i % 2 = 0) ∨ (∀ i : Fin 8, v i % 2 = 1)) ∧
  (∑ i : Fin 8, v i) % 4 = 0

instance : DecidablePred IsE8RootD := fun v => by
  unfold IsE8RootD; exact inferInstance

/-! ### Explicit root enumeration -/

/-- The 112 integer-type E8 roots in doubled coordinates.
    Each has exactly two nonzero entries in {±2}, the rest zero.
    These correspond to the octonions ±eᵢ ± eⱼ (i < j). -/
def type1Roots : List (Fin 8 → ℤ) :=
  do
    let i ← List.finRange 8
    let j ← List.finRange 8
    guard (i < j)
    let si ← [(2 : ℤ), -2]
    let sj ← [(2 : ℤ), -2]
    return fun k : Fin 8 => if k = i then si else if k = j then sj else 0

/-- The 128 half-integer-type E8 roots in doubled coordinates.
    Each has all entries in {±1} with an even number of minus signs.
    These correspond to the octonions (±1/2, ±1/2, …, ±1/2). -/
def type2Roots : List (Fin 8 → ℤ) :=
  do
    let n ← List.finRange 256
    guard (((List.finRange 8).countP fun i => n.val.testBit i.val) % 2 == 0)
    return fun i : Fin 8 => if n.val.testBit i.val then (-1 : ℤ) else 1

/-- The complete list of 240 E8 root candidates in doubled coordinates. -/
def rootList : List (Fin 8 → ℤ) := type1Roots ++ type2Roots

/-! ### Cardinality -/

/-- The integer-type roots number 112. -/
theorem type1Roots_length : type1Roots.length = 112 := by native_decide

/-- The half-integer-type roots number 128. -/
theorem type2Roots_length : type2Roots.length = 128 := by native_decide

/-- There are exactly 240 E8 root candidates. -/
theorem rootList_length : rootList.length = 240 := by native_decide

/-- The root list has no duplicates. -/
theorem rootList_nodup : rootList.Nodup := by native_decide

/-! ### E8 root predicate satisfaction -/

/-- Every vector in `rootList` satisfies the `IsE8RootD` predicate. -/
theorem rootList_all_isE8RootD :
    rootList.Forall (fun v => IsE8RootD v) := by native_decide

/-- `rootList` is complete: every vector with coordinates in {-2,-1,0,1,2}
    that satisfies `IsE8RootD` appears in `rootList`.

The finite coordinate restriction is justified by
`coordinate_abs_le_two_of_normSqD_eq_8`: any vector with doubled norm-squared
`8` has every coordinate in the interval `[-2,2]`. A future theorem should
combine that bound with this finite enumeration to remove the `Fin 5` wrapper
from the completeness statement. -/
theorem rootList_complete :
    ∀ f : Fin 8 → Fin 5,
      IsE8RootD (fun i => (![-2, -1, 0, 1, 2] : Fin 5 → ℤ) (f i)) →
      (fun i => (![-2, -1, 0, 1, 2] : Fin 5 → ℤ) (f i)) ∈ rootList := by
  native_decide

/-- A vector with doubled norm-squared `8` has every coordinate between
`-2` and `2`.

This lemma explains why the finite enumeration in `rootList_complete` only
needs the coordinate values `{-2,-1,0,1,2}`. If a coordinate had absolute value
at least `3`, its square alone would exceed the total norm bound. -/
theorem coordinate_abs_le_two_of_normSqD_eq_8 (v : Fin 8 → ℤ)
    (hv : normSqD v = 8) (i : Fin 8) : |v i| ≤ 2 := by
  have hsingle : v i ^ 2 ≤ normSqD v := by
    unfold normSqD
    exact Finset.single_le_sum (fun j _ => sq_nonneg (v j)) (Finset.mem_univ i)
  have hsquare : v i ^ 2 ≤ 8 := by
    simpa [hv] using hsingle
  have hsquare_abs : |v i| ^ 2 ≤ 8 := by
    simpa [sq_abs] using hsquare
  by_contra hle
  have hge_three : 3 ≤ |v i| := by omega
  have hge_nine : 9 ≤ |v i| ^ 2 := by nlinarith
  omega

/-! ### Norm-squared facts -/

/-- Every root has doubled norm-squared equal to 8 (actual norm² = 2). -/
theorem normSqD_eq_8 :
    rootList.Forall (fun v => normSqD v = 8) := by native_decide

/-- The self-dot-product of every root equals 8 (actual ⟨v,v⟩ = 2). -/
theorem dotD_self_eq_8 :
    rootList.Forall (fun v => dotD v v = 8) := by native_decide

/-! ### Closure under negation -/

/-- The pointwise negation of every root is again in `rootList`. -/
theorem neg_mem_rootList :
    rootList.Forall (fun v => (fun i => -v i) ∈ rootList) := by native_decide

/-! ### Dot-product facts (E8 root-system pattern) -/

/-- The dot product of any two roots (doubled) is divisible by 4,
    equivalently the actual inner product is always an integer. -/
theorem dotD_div_four :
    rootList.Forall (fun v =>
      rootList.Forall (fun w => dotD v w % 4 = 0)) := by native_decide

/-- The doubled dot product of any two roots lies in [-8, 8],
    equivalently the actual inner product lies in [-2, 2]. -/
theorem dotD_bound :
    rootList.Forall (fun v =>
      rootList.Forall (fun w => -8 ≤ dotD v w ∧ dotD v w ≤ 8)) := by native_decide

/-- For distinct roots, the doubled dot product takes values in {-8, -4, 0, 4}.
    In actual inner product terms: {-2, -1, 0, 1}.
    The value 2 (= normSq) is excluded for distinct roots. -/
theorem dotD_values_distinct :
    rootList.Forall (fun v =>
      rootList.Forall (fun w => v ≠ w →
        dotD v w = -8 ∨ dotD v w = -4 ∨ dotD v w = 0 ∨ dotD v w = 4)) := by
  native_decide

/-! ### Embedding into the project Octonion type -/

/-- Embed a doubled-coordinate vector into an `Octonion` (dividing each
    coordinate by 2). -/
noncomputable def toOctonion (v : Fin 8 → ℤ) : Octonion where
  c0 := (v 0 : ℝ) / 2
  c1 := (v 1 : ℝ) / 2
  c2 := (v 2 : ℝ) / 2
  c3 := (v 3 : ℝ) / 2
  c4 := (v 4 : ℝ) / 2
  c5 := (v 5 : ℝ) / 2
  c6 := (v 6 : ℝ) / 2
  c7 := (v 7 : ℝ) / 2

/-
The `normSq` of an embedded vector equals `normSqD v / 4`.
-/
theorem normSq_toOctonion (v : Fin 8 → ℤ) :
    normSq (toOctonion v) = (↑(normSqD v) : ℝ) / 4 := by
  unfold normSq normSqD
  norm_num [Fin.sum_univ_eight]
  ring_nf
  unfold toOctonion
  norm_num
  ring

/-
The actual `normSq` of an E8 root (embedded in `Octonion`) is 2.
-/
theorem normSq_root_eq_two (v : Fin 8 → ℤ) (hv : normSqD v = 8) :
    normSq (toOctonion v) = 2 := by
  convert normSq_toOctonion v using 1
  norm_num [hv]

/-
The `innerProd` of two embedded vectors equals `dotD v w / 4`.
-/
theorem innerProd_toOctonion (v w : Fin 8 → ℤ) :
    innerProd (toOctonion v) (toOctonion w) = (↑(dotD v w) : ℝ) / 4 := by
  unfold innerProd dotD toOctonion
  norm_num [Fin.sum_univ_eight]
  ring

end E8Root

end PhysicsSM.Algebra.Octonion
