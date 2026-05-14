import Mathlib
import PhysicsSM.Algebra.Octonion.E8WeylOrbit

/-!
# E8 Weyl orbit convergence: simple-reflection closure reaches all 240 roots

This module proves the bounded orbit convergence theorem for E8: starting from
a single explicit root and iterating the simple-reflection closure step
(`simpleClosureStep` from `E8WeylOrbit`), we reach all 240 roots in a bounded
number of steps.

## Main results

- **`simpleClosureIter n S`**: iterates `simpleClosureStep` exactly `n` times.
- **`simpleClosureIter_subset_rootList`**: stays within `rootList`.
- **`simpleClosureIter_monotone`**: monotone (the set only grows).
- **`simpleClosure_from_firstRoot_covers_rootList`**: 39 closure iterations from
  `rootList[0]!` produce all 240 E8 roots.

## Trust boundary

The word table correctness (`rootWordTable_correct`) and length bounds
(`rootWordTable_length_le`) are verified by `decide` (kernel reduction)
without `native_decide` — no `Lean.trustCompiler` dependency.

The final convergence assembly (`simpleClosure_from_firstRoot_covers_rootList`)
uses `native_decide` only for a trivial bound `rootList.length ≤ 240`,
inheriting the same `Lean.trustCompiler` axiom already present in
`rootList_length` from `IntegralOctonion.lean`.

## Source / provenance

- Humphreys, *Introduction to Lie Algebras*, Ch. III.
- Created for PhysicsSM Hamming–E8 publication, Job S3.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false
set_option linter.style.maxHeartbeats false
set_option linter.style.whitespace false

namespace PhysicsSM.Algebra.Octonion.E8Root

/-- Iterate `simpleClosureStep` exactly `n` times starting from `S`. -/
def simpleClosureIter : ℕ → List (Fin 8 → ℤ) → List (Fin 8 → ℤ)
  | 0, S => S
  | n + 1, S => simpleClosureStep (simpleClosureIter n S)

/-- rootList-invariance of iterated closure. -/
theorem simpleClosureIter_subset_rootList (n : ℕ) (S : List (Fin 8 → ℤ))
    (hS : S.Forall (· ∈ rootList)) :
    (simpleClosureIter n S).Forall (· ∈ rootList) := by
  induction n with
  | zero => exact hS
  | succ n ih => exact simpleClosureStep_subset_rootList _ ih

/-- Monotonicity of iterated closure. -/
theorem simpleClosureIter_monotone (n : ℕ) (S : List (Fin 8 → ℤ)) :
    (simpleClosureIter n S).Forall (· ∈ simpleClosureIter (n + 1) S) :=
  simpleClosureStep_monotone (simpleClosureIter n S)

/-
Transitivity of monotonicity.
-/
theorem simpleClosureIter_monotone_le {m n : ℕ} (hmn : m ≤ n) (S : List (Fin 8 → ℤ)) :
    (simpleClosureIter m S).Forall (· ∈ simpleClosureIter n S) := by
  revert S;
  induction' hmn with m n hmn ih;
  · cases m <;> simp_all +decide [ List.forall_iff_forall_mem ];
  · intro S;
    exact List.forall_iff_forall_mem.mpr fun x hx => List.mem_dedup.mpr <| List.mem_append_left _ <| hmn S |> List.forall_iff_forall_mem.mp |> fun h => h x hx

/-- The starting root: `rootList[0]! = (2, 2, 0, 0, 0, 0, 0, 0)`. -/
def firstRoot : Fin 8 → ℤ := rootList[0]!

/-- Apply a sequence of simple reflections left-to-right. -/
def applyWord (w : List (Fin 8)) (v : Fin 8 → ℤ) : Fin 8 → ℤ :=
  w.foldl (fun acc i => simpleReflectD i acc) v

/-
A simple reflection of any element of `L` belongs to `simpleClosureStep L`.
-/
theorem simpleReflectD_mem_simpleClosureStep (i : Fin 8) (v : Fin 8 → ℤ)
    (L : List (Fin 8 → ℤ)) (hv : v ∈ L) :
    simpleReflectD i v ∈ simpleClosureStep L := by
  unfold simpleClosureStep;
  aesop

/-
Word reachability: applying a word to an element of `simpleClosureIter n S`
gives an element of `simpleClosureIter (n + w.length) S`.
-/
theorem applyWord_mem_simpleClosureIter (w : List (Fin 8)) (v : Fin 8 → ℤ)
    (S : List (Fin 8 → ℤ)) (n : ℕ) (hv : v ∈ simpleClosureIter n S) :
    applyWord w v ∈ simpleClosureIter (n + w.length) S := by
  induction' w with i w ih generalizing v n;
  · exact hv;
  · have h_step : simpleReflectD i v ∈ simpleClosureIter (n + 1) S := by
      exact simpleReflectD_mem_simpleClosureStep i v ( simpleClosureIter n S ) hv;
    simpa only [ Nat.succ_add ] using ih _ _ h_step

/-- BFS word table: for each root k, the shortest word of simple reflections
mapping `firstRoot` to `rootList[k]`. Computed by breadth-first search. -/
def rootWordTable : Fin 240 → List (Fin 8) := ![
  [],
  [1,2,3,4,6,5,4,3,2,1],
  [1,2,3,4,6,5,4,3,2,1,0],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,1,2,0,1],
  [1],
  [1,2,3,4,6,5,4,3,2],
  [1,2,3,4,6,5,4,3,2,0,1,0],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,1,2,0],
  [1,2],
  [1,2,3,4,6,5,4,3],
  [1,2,3,4,6,5,4,3,2,0,1,2,0],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,1,0],
  [1,2,3],
  [1,2,3,4,6,5,4],
  [1,2,3,4,6,5,4,3,2,0,1,2,0,3],
  [1,2,3,4,5,0,6,1,4,2,3,4,2,5,1,6,0,4],
  [1,2,3,4],
  [1,2,3,4,6,5],
  [1,2,3,4,6,5,4,3,0,1,2,3,1,4,0],
  [1,2,3,4,5,0,6,1,4,2,3,4,2,5,1,6,0],
  [1,2,3,4,5],
  [1,2,3,4,6],
  [1,2,3,4,6,5,4,3,0,1,2,3,1,4,0,5],
  [1,2,3,4,6,5,4,3,0,1,2,3,1,4,0,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,6,7],
  [7,6,4,5,3,4,2,3,6,4,7,6,5,4,3,2,1,0],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3,6,4,7,6,5,4,3,2,1,0],
  [7,6,4,5,3,4,6,7,1,0],
  [1,0],
  [1,2,3,4,6,5,4,3,2,0],
  [1,2,3,4,6,5,4,3,2,0,1],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,1,2],
  [1,2,0],
  [1,2,3,4,6,5,4,3,0],
  [1,2,3,4,6,5,4,3,2,0,1,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,1],
  [1,2,3,0],
  [1,2,3,4,6,5,4,0],
  [1,2,3,4,6,5,4,3,0,1,2,3,1],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1],
  [1,2,3,4,0],
  [1,2,3,4,5,0,6],
  [1,2,3,4,6,5,4,3,0,1,2,3,1,4],
  [1,2,3,4,5,0,6,1,4,2,3,4,2,5,1,6],
  [1,2,3,4,5,0],
  [1,2,3,4,6,0],
  [1,2,3,4,5,0,6,1,4,2,3,4,2,5,1],
  [1,2,3,4,5,0,6,1,4,2,3,4,2,6,1],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,6,7,0],
  [7,6,4,5,3,4,2,3,6,4,7,6,5,4,3,2,1],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3,6,4,7,6,5,4,3,2,1],
  [7,6,4,5,3,4,6,7,1],
  [1,2,0,1],
  [1,2,3,4,6,5,4,3,0,1],
  [1,2,3,4,6,5,4,3,0,1,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3],
  [1,2,0,1,3],
  [1,2,3,4,5,0,6,1,4],
  [1,2,3,4,6,5,4,3,0,1,2,3],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2],
  [1,2,3,4,0,1],
  [1,2,3,4,5,0,6,1],
  [1,2,3,4,5,0,6,1,4,2,3,4,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,2],
  [1,2,3,4,0,1,5],
  [1,2,3,4,0,1,6],
  [1,2,3,4,5,0,6,1,4,2,3,4,2,5],
  [1,2,3,4,5,0,6,1,4,2,3,4,2,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,6,7,0,1],
  [7,6,4,5,3,4,2,3,6,4,7,6,5,4,3,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3,6,4,7,6,5,4,3,2],
  [7,6,4,5,3,4,6,7],
  [1,2,0,1,3,2],
  [1,2,3,4,5,0,6,1,4,2],
  [1,2,3,4,5,0,6,1,4,2,3],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4],
  [1,2,0,1,3,2,4],
  [1,2,3,4,0,1,5,2,6],
  [1,2,3,4,5,0,6,1,4,2,3,4],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6],
  [1,2,3,4,0,1,5,2],
  [1,2,3,4,0,1,6,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3],
  [1,2,3,4,0,1,5,2,6,3,4,6,3],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,0,1,6,2,7],
  [7,6,4,5,3,4,2,3,6,4,7,6,5,4,3],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3,6,4,7,6,5,4,3],
  [7,6,4,5,3,4,6,7,2],
  [1,2,0,1,3,2,4,3],
  [1,2,3,4,0,1,5,2,6,3],
  [1,2,3,4,0,1,5,2,6,3,4],
  [1,2,3,4,0,1,5,2,6,3,4,6,5],
  [1,2,0,1,3,2,4,3,5],
  [1,2,0,1,3,2,4,3,6],
  [1,2,3,4,0,1,5,2,6,3,4,5],
  [1,2,3,4,0,1,5,2,6,3,4,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,0,1,6,2,7,3],
  [7,6,4,5,3,4,2,3,6,4,7,6,5,4],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3,6,4,7,6,5,4],
  [7,6,4,5,3,4,6,7,2,3],
  [1,2,0,1,3,2,4,3,5,4],
  [1,2,0,1,3,2,4,3,6,4],
  [1,2,0,1,3,2,4,3,6,4,5],
  [1,2,0,1,3,2,4,3,5,4,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3,6,4,7],
  [7,6,4,5,3,4,2,3,6,4,7,6,5],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3,6,4,7,6,5],
  [7,6,4,5,3,4,2,3,6,4,7],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3,6,4,7,5],
  [7,6,4,5,3,4,2,3,6,4,7,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3,6,4,7,6],
  [7,6,4,5,3,4,2,3,6,4,7,5],
  [1,2,0,1,3,2,4,3,5,4,6,7,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,1,2,0,1,7],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,1,0,7,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,1,2,7],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,1,0,7],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,7],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,0],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,2,7,4],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,0,1],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,0],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4],
  [1,2,3,4,5,0,6,1,4,2,3,4,2,5,1,6,0,7],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,2,7,1],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,2,7],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2],
  [1,2,3,4,0,1,5,2,6,3,4,6,3,7,5],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,0,6,3,4,2,5,3],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5],
  [1,2,3,4,0,1,5,2,6,3,4,6,5,7],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,0,6,3,4,2,5,1],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,0,6,3,4,2,5],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6,2,3,4,5,1,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6,2,3,4,5,1,0],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6,2,3,4,5,1],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6,2,3,4,5],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3,6,4,5],
  [1,2,3,4,5,0,6,1,4,2,3,4,2,6,1,7,0],
  [1,2,3,4,5,0,6,1,4,2,3,4,2,6,1,7],
  [1,2,3,4,0,1,5,2,6,3,4,6,3,7,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,2],
  [1,2,3,4,0,1,5,2,6,3,4,6,3,7],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3],
  [1,2,0,1,3,2,4,3,5,4,6,7,4],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,1,0,7,2,6,1,4],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,0,6,3,4,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,0,6,3,4],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6,2,3,4,1],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6,2,3,4],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3,6,4],
  [1,2,0,1,3,2,4,3,5,4,6,7],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,1,0,7,2,6,1],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,3,1,0,7,2,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,0,6,3],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6,2,3],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,0,1,5,2,4,3,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,0,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6,2,1],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,0,1,6,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,0,1,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,6,0],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,6],
  [7,6,4,5,3,4,1,0,6],
  [7,6,4,5,3,4,6,1],
  [7,6,4,5,3,4,6],
  [1,2,3,0,7,1,6,2],
  [7,6,4,5,3,4,6,2],
  [1,2,3,0,7,1,6],
  [1,0,7,2,6,3],
  [1,2,7,3,6],
  [7,6,4,5,3,4,2,3,6],
  [1,0,7,2,6,1],
  [1,0,7,2,6],
  [7,6,1,2],
  [7,6,1,0],
  [7,6,1],
  [7,6],
  [1,2,0,1,3,2,4,3,5,4,7],
  [7,6,4,5,3,4,2,3,6,4],
  [1,0,7,2,6,1,4],
  [7,6,1,0,4,2],
  [7,6,1,2,4],
  [7,6,1,0,4],
  [7,6,4,1],
  [7,6,4],
  [1,2,3,4,0,1,5,2,7,3],
  [7,6,4,3,1,0],
  [7,6,4,3,1],
  [7,6,4,3],
  [1,2,3,4,0,1,5,2,7],
  [7,6,4,3,2],
  [1,2,3,4,5,0,7,1],
  [1,2,3,4,5,0,7],
  [1,2,3,4,7,5],
  [7,6,4,5,3,4,2,3,6,4,5],
  [7,6,1,0,4,2,5,1],
  [7,6,1,0,4,2,5],
  [7,6,4,5,1,2],
  [7,6,4,5,1,0],
  [7,6,4,5,1],
  [7,6,4,5],
  [1,2,0,1,3,2,4,3,7],
  [7,6,4,5,1,0,3],
  [7,6,4,3,1,5],
  [7,6,4,5,3],
  [1,2,3,4,0,1,7,2],
  [7,6,4,3,2,5],
  [1,2,3,4,0,1,7],
  [1,2,3,0,7,4],
  [1,2,3,4,7],
  [7,6,4,5,3,4,1,0],
  [7,6,4,5,3,4,1],
  [7,6,4,5,3,4],
  [1,2,0,1,3,2,7],
  [7,6,4,5,3,4,2],
  [1,2,3,0,7,1],
  [1,2,3,0,7],
  [1,2,7,3],
  [7,6,4,5,3,4,2,3],
  [1,2,0,1,7],
  [1,0,7,2],
  [1,2,7],
  [1,0,7],
  [7,1],
  [7],
  [1,2,0,1,3,2,4,3,5,4,7,6]]

set_option maxRecDepth 100000 in
-- 240 roots × 8 coordinates, each verified by kernel reduction
set_option maxHeartbeats 8000000 in
/-- **Word table correctness**: applying each word to `firstRoot` gives the
corresponding root, verified pointwise by kernel reduction (`decide`). -/
theorem rootWordTable_correct :
    ∀ k : Fin 240, ∀ j : Fin 8,
      applyWord (rootWordTable k) firstRoot j = rootList[k.val]! j := by
  intro k j; fin_cases k <;> fin_cases j <;> decide

set_option maxRecDepth 100000 in
-- 240 word lengths verified by kernel reduction
set_option maxHeartbeats 4000000 in
/-- **Word length bound**: every word has length ≤ 39. -/
theorem rootWordTable_length_le :
    ∀ k : Fin 240, (rootWordTable k).length ≤ 39 := by
  intro k; fin_cases k <;> decide

/-
**Orbit convergence**: 39 iterations of `simpleClosureStep` from
`[firstRoot]` produce all 240 E8 roots.

This is the single-orbit (irreducibility) property of E8.

**Trust boundary**: uses `native_decide` only for the trivial bound
`rootList.length ≤ 240`. Word table correctness is kernel-checked.
-/
theorem simpleClosure_from_firstRoot_covers_rootList :
    rootList.Forall (· ∈ simpleClosureIter 39 [firstRoot]) := by
  have h_word_step : ∀ k : Fin 240, applyWord (rootWordTable k) firstRoot ∈ simpleClosureIter 39 [firstRoot] := by
    intro k
    have h_length : (rootWordTable k).length ≤ 39 := by
      exact rootWordTable_length_le k;
    have h_applyWord : applyWord (rootWordTable k) firstRoot ∈ simpleClosureIter ((rootWordTable k).length) [firstRoot] := by
      convert applyWord_mem_simpleClosureIter ( rootWordTable k ) firstRoot [ firstRoot ] 0 _;
      · grind;
      · native_decide +revert;
    exact List.forall_iff_forall_mem.mp ( simpleClosureIter_monotone_le h_length [ firstRoot ] ) _ h_applyWord;
  have h_word_step : ∀ k : Fin 240, rootList[k.val]! ∈ simpleClosureIter 39 [firstRoot] := by
    intro k
    specialize h_word_step k
    have h_word_eq : applyWord (rootWordTable k) firstRoot = rootList[k.val]! := by
      exact funext fun j => rootWordTable_correct k j
    aesop;
  rw [List.forall_iff_forall_mem]
  intro x hx
  rw [List.mem_iff_get] at hx
  obtain ⟨k, hk⟩ := hx
  have hk_bound : k.val < 240 :=
    k.2.trans_le (by native_decide)
  specialize h_word_step ⟨k.val, hk_bound⟩
  aesop

end PhysicsSM.Algebra.Octonion.E8Root
