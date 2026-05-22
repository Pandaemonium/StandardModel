import Mathlib.Tactic
import CodeLatticeE8.E8.ShortVectors
import CodeLatticeE8.E8.Roots

/-!
# The Construction A short shell bijects with the E8 root list

This module proves that the Hamming Construction A short shell (vectors
of unscaled squared norm four in the Construction A lattice) bijects
with the 240-element E8 root list in doubled coordinates.

## The two models

| Model | Norm condition | Actual E8 squared norm |
|---|---|---|
| Short shell: `z ∈ hammingConstructionA`, `sqNorm z = 4` | `sqNorm / 2 = 2` | 2 |
| Root list: `r ∈ Roots.rootList`, `Roots.normSq r = 8` | `normSq / 4 = 2` | 2 |

## The bridge map

The map `shortVectorToRootCoords` uses the 8×8 Sylvester-Hadamard
matrix `H` (satisfying `H * Hᵀ = 8 · I`).  For a short vector `z`:

1. Compute `h = H · z / 2`.  (The evenness of `H · z` for all short
   vectors is verified by finite computation.)
2. If the first and second halves of `h` share a parity, `h` is already
   a valid doubled-coordinate root.  Otherwise apply a parity
   correction.

The 16 type-1 short vectors (one coordinate `±2`) map to type-1 doubled
roots.  The 224 type-2 short vectors (±1 on a weight-4 Hamming support)
map, after correction, to type-2 doubled roots.

## Main results

- `shortVectorToRootCoords_mem_rootList`: the image of every short
  shell vector lies in `Roots.rootList`.
- `rootList_preimage_in_shortShell`: every root has a preimage in the
  short shell.
- `shortShell_perm_rootList`: the mapped list is a permutation of
  `Roots.rootList`.

## Proof strategy and trust boundary

The permutation theorem is derived *structurally* from three
independent facts:

1. **Nodup**: the mapped list has no duplicates (kernel-verified
   `decide`).
2. **Subset**: every mapped element lies in `rootList` (kernel-verified
   `decide` over the 240 membership checks, backed by
   `mem_rootList_iff_isE8Root`).
3. **Length**: the mapped list has length 240, matching `rootList`.
   This is derived *semantically* from the structural short-vector
   count (`hammingConstructionA_short_vector_count`), avoiding a
   second enumeration.

The surjection `rootList_preimage_in_shortShell` is derived from the
permutation rather than by independent computation.

### Kernel-verified `decide` facts

| Fact | Role |
|---|---|
| `shortShellVectorList_nodup` | nodup of the 240-element source list |
| `shortShellVectorList_length_raw` | list has 240 entries |
| `shortShellVectorList_mem_shortShell` | membership of each entry |
| `shortVectorToRootCoords_mem_rootList_all` | bridge map lands in `rootList` |
| `shortVectorToRootCoords_map_nodup` | nodup of the mapped list |

These are all *local* predicates on the explicit lists, verified by
the Lean 4 kernel (`decide`), not by compiled native code.

### Structurally derived facts

| Fact | Now derived from |
|---|---|
| `shortShell_mem_shortShellVectorList` | nodup + length + mem + ncard (set equality) |
| `shortShellVectorList_length` | structural count + list-set bijection |
| `shortVectorToRootCoords_perm` | nodup + subset + length |
| `rootList_surjected_all` | permutation theorem |

The previous `shortShell_encoded_in_list` (which iterated over all
`Fin 5 ^ 8 = 390625` vectors) has been eliminated: the reverse
containment `hammingE8ShortShell ⊆ shortShellVectorList` is now
derived from the structural cardinality argument.

## Sources

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 7–8.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.style.maxHeartbeats false

namespace CodeLatticeE8.E8.RootBridge

open CodeLatticeE8.ConstructionA
open CodeLatticeE8.Code
open CodeLatticeE8.E8
open CodeLatticeE8.E8.Roots

/-! ## Hadamard bridge matrix -/

/--
The Sylvester-Hadamard matrix used by the short-shell/root-list bridge.

The bridge map below applies this matrix to a Construction A short
vector and then performs a small parity correction.  Keeping the matrix
public makes the coordinate convention inspectable from the theorem
statements and avoids hiding the main map behind private
implementation names.
-/
def hadamardBridgeMatrix : Matrix (Fin 8) (Fin 8) ℤ :=
  !![ 1,  1,  1,  1,  1,  1,  1,  1;
      1, -1,  1, -1,  1, -1,  1, -1;
      1,  1, -1, -1,  1,  1, -1, -1;
      1, -1, -1,  1,  1, -1, -1,  1;
      1,  1,  1,  1, -1, -1, -1, -1;
      1, -1,  1, -1, -1,  1, -1,  1;
      1,  1, -1, -1, -1, -1,  1,  1;
      1, -1, -1,  1, -1,  1,  1, -1]

/-- The bridge matrix is orthogonal up to the scalar factor `8`. -/
theorem hadamardBridgeMatrix_self_mul :
    hadamardBridgeMatrix * hadamardBridgeMatrix.transpose =
      8 • (1 : Matrix (Fin 8) (Fin 8) ℤ) := by decide

/-- The bridge matrix is symmetric: `Hᵀ = H`. -/
theorem hadamardBridgeMatrix_symmetric :
    hadamardBridgeMatrix.transpose = hadamardBridgeMatrix := by
  decide

/-! ## Hadamard norm identity

The Hadamard matrix `H` satisfies `H Hᵀ = 8 I` and `H = Hᵀ`, from
which `H^2 = 8 I` and thus `||Hz||^2 = 8 ||z||^2` for any integer
vector `z`.  This is the key norm-preservation identity underlying
the bridge map. -/

/-- The Hadamard transform scales the squared norm by `8`:
`∑ i, (H z)ᵢ^2 = 8 * ∑ i, zᵢ^2`.

Proved algebraically from the matrix identity `H Hᵀ = 8 I` and the
symmetry `H = Hᵀ`, without enumerating individual entries. -/
theorem hadamard_sqNorm_scale (z : Fin 8 → ℤ) :
    ∑ i : Fin 8, (Matrix.mulVec hadamardBridgeMatrix z i) ^ 2 =
      8 * ∑ i : Fin 8, (z i) ^ 2 := by
  have sq_eq_dot : ∀ v : Fin 8 → ℤ,
      ∑ i, (v i) ^ 2 = dotProduct v v := by
    intro v; simp [dotProduct, sq]
  rw [sq_eq_dot, sq_eq_dot]
  rw [Matrix.dotProduct_mulVec
    (Matrix.mulVec hadamardBridgeMatrix z) hadamardBridgeMatrix z]
  conv_lhs =>
    rw [show hadamardBridgeMatrix = hadamardBridgeMatrix.transpose
      from hadamardBridgeMatrix_symmetric.symm]
  rw [Matrix.vecMul_transpose, Matrix.mulVec_mulVec,
      hadamardBridgeMatrix_self_mul,
      Matrix.smul_mulVec, Matrix.one_mulVec, smul_dotProduct]
  simp

/-! ## Explicit short-vector list -/

/-- The 16 coordinate short vectors: one coordinate is `±2`, the rest
are zero. -/
def coordinateShortVectorList : List (Fin 8 → ℤ) :=
  do
    let i ← List.finRange 8
    let s ← [(2 : ℤ), -2]
    return fun k => if k = i then s else 0

/--
The 224 short vectors with four nonzero coordinates.

The filter uses the Hamming parity-check equations and the unscaled
norm condition, so this list is tied directly to the Construction A
model rather than to an external root-list convention.
-/
def weightFourShortVectorList : List (Fin 8 → ℤ) :=
  do
    let c0 ← [(-1 : ℤ), 0, 1]; let c1 ← [(-1 : ℤ), 0, 1]
    let c2 ← [(-1 : ℤ), 0, 1]; let c3 ← [(-1 : ℤ), 0, 1]
    let c4 ← [(-1 : ℤ), 0, 1]; let c5 ← [(-1 : ℤ), 0, 1]
    let c6 ← [(-1 : ℤ), 0, 1]; let c7 ← [(-1 : ℤ), 0, 1]
    let v : Fin 8 → ℤ := ![c0, c1, c2, c3, c4, c5, c6, c7]
    guard (Matrix.mulVec extendedHamming8ParityCheck
             (reduceModTwo v) = 0 ∧
           ConstructionA.sqNorm v = 4)
    return v

/--
The explicit 240-element list of Hamming Construction A short vectors.

This list is a concrete enumeration of `hammingE8ShortShell`.  The
public bridge theorem below maps this list to `Roots.rootList`.
-/
def shortShellVectorList : List (Fin 8 → ℤ) :=
  coordinateShortVectorList ++ weightFourShortVectorList

/-- Decidability of short-shell membership via the parity-check
criterion. -/
private instance : DecidablePred (· ∈ hammingE8ShortShell) := fun z =>
  @instDecidableAnd _ _
    (decidable_of_iff _
      (mem_hammingConstructionA_iff_parityCheck z).symm)
    (Int.decEq (ConstructionA.sqNorm z) 4)

-- Kernel-verified membership: 240 parity-check and norm evaluations.
set_option maxRecDepth 4096 in
set_option maxHeartbeats 3200000 in
private theorem shortShellVectorList_mem_shortShell :
    shortShellVectorList.Forall (· ∈ hammingE8ShortShell) := by
  decide

/-! ### List nodup, length, and reverse containment

The nodup property and list length are verified directly by kernel
reduction (`decide`).  The reverse containment
(`hammingE8ShortShell ⊆ shortShellVectorList`) is then derived
*structurally*:

1. `shortShellVectorList` has 240 distinct entries (nodup + length).
2. Every entry lies in `hammingE8ShortShell` (mem_shortShell).
3. `hammingE8ShortShell` has `ncard = 240` (structural counting).

Since the list's `toFinset` is a 240-element subset of a set with
`ncard = 240`, they are equal as sets.  No enumeration over
`Fin 5 ^ 8 = 390625` candidate vectors is needed. -/

-- Kernel-verified: pairwise distinctness of 240 source vectors.
set_option maxRecDepth 4096 in
set_option maxHeartbeats 12800000 in
theorem shortShellVectorList_nodup :
    shortShellVectorList.Nodup := by decide

-- Kernel-verified: counting the filtered list entries.
set_option maxRecDepth 4096 in
set_option maxHeartbeats 1600000 in
private theorem shortShellVectorList_length_raw :
    shortShellVectorList.length = 240 := by decide

/-- Every short shell vector lies in `shortShellVectorList`.

Derived structurally from the cardinality argument: the list's
`toFinset` is a 240-element subset of `hammingE8ShortShell` (which
has `ncard = 240`), so they are equal as sets. -/
theorem shortShell_mem_shortShellVectorList {z : Fin 8 → ℤ}
    (hz : z ∈ hammingE8ShortShell) :
    z ∈ shortShellVectorList := by
  -- The list's toFinset is a subset of the short shell
  have h_sub :
      (↑shortShellVectorList.toFinset : Set (Fin 8 → ℤ)) ⊆
        hammingE8ShortShell := by
    intro x hx
    simp only [Finset.mem_coe, List.mem_toFinset] at hx
    exact List.forall_iff_forall_mem.mp
      shortShellVectorList_mem_shortShell x hx
  -- The toFinset has card = 240
  have h_card : shortShellVectorList.toFinset.card = 240 := by
    rw [List.toFinset_card_of_nodup shortShellVectorList_nodup,
        shortShellVectorList_length_raw]
  -- The short shell has ncard = 240
  have h_ncard_le :
      hammingE8ShortShell.ncard ≤
        Set.ncard
          (↑shortShellVectorList.toFinset : Set (Fin 8 → ℤ)) := by
    rw [Set.ncard_coe_finset, h_card,
        hammingConstructionA_short_vector_count]
  -- Since toFinset ⊆ shell and ncard(shell) ≤ ncard(toFinset),
  -- they are equal
  have h_finite :
      (hammingE8ShortShell : Set (Fin 8 → ℤ)).Finite :=
    Set.finite_of_ncard_ne_zero
      (by rw [hammingConstructionA_short_vector_count]; omega)
  have h_eq :=
    Set.eq_of_subset_of_ncard_le h_sub h_ncard_le h_finite
  have hmem : z ∈ (↑shortShellVectorList.toFinset : Set _) :=
    h_eq ▸ hz
  exact List.mem_toFinset.mp (Finset.mem_coe.mp hmem)

/-- The short-vector list has exactly 240 elements.

Derived semantically from `hammingConstructionA_short_vector_count`
via the bijection between `shortShellVectorList` and
`hammingE8ShortShell`, rather than by a second enumeration of the
240-element list. -/
theorem shortShellVectorList_length :
    shortShellVectorList.length = 240 := by
  have h_eq :
      (↑shortShellVectorList.toFinset : Set (Fin 8 → ℤ)) =
        hammingE8ShortShell := by
    ext z
    simp only [Finset.mem_coe, List.mem_toFinset]
    exact ⟨fun h => List.forall_iff_forall_mem.mp
             shortShellVectorList_mem_shortShell z h,
           shortShell_mem_shortShellVectorList⟩
  rw [← List.toFinset_card_of_nodup shortShellVectorList_nodup,
    ← Set.ncard_coe_finset, h_eq,
    hammingConstructionA_short_vector_count]

/-! ## The bridge map -/

/--
The coordinate map from Construction A short vectors to
doubled-coordinate E8 roots.

It first applies `hadamardBridgeMatrix` and divides by `2`, then
applies a small parity correction so the result satisfies the
doubled-coordinate root predicate.  The correctness statements below
should be used instead of unfolding this definition.
-/
def shortVectorToRootCoords (z : Fin 8 → ℤ) : Fin 8 → ℤ :=
  let h : Fin 8 → ℤ :=
    fun i => Matrix.mulVec hadamardBridgeMatrix z i / 2
  if h 0 % 2 = h 4 % 2 then h
  else if h 0 % 2 = 0 then
    let s := (h 0 + h 1 + h 2 + h 3) / 2
    fun i => if i.val < 4 then h i - s else h i
  else
    let oddSum := h 0 + h 1 + h 2 + h 3
    let minSign := if oddSum > 0 then -1 else 1
    let k : Fin 8 :=
      if h 0 = minSign then 0
      else if h 1 = minSign then 1
      else if h 2 = minSign then 2 else 3
    fun i =>
      if i = k then 2 * h k
      else if i.val ≥ 4 then h i else 0

-- Kernel-verified: 240 bridge-map image membership checks.
set_option maxRecDepth 4096 in
set_option maxHeartbeats 6400000 in
private theorem shortVectorToRootCoords_mem_rootList_all :
    shortShellVectorList.Forall
      (fun z => shortVectorToRootCoords z ∈ rootList) := by
  decide

-- Kernel-verified: pairwise distinctness of 240 mapped vectors.
set_option maxRecDepth 4096 in
set_option maxHeartbeats 12800000 in
private theorem shortVectorToRootCoords_map_nodup :
    (shortShellVectorList.map shortVectorToRootCoords).Nodup := by
  decide

/-! ## Structural permutation proof

The permutation is derived from three independent facts rather than
a monolithic comparison of two 240-element lists:

1. **Nodup**: the mapped list has no duplicates
   (`shortVectorToRootCoords_map_nodup`, kernel-verified `decide`).
2. **Subset**: every element of the mapped list lies in `rootList`
   (`shortVectorToRootCoords_map_subset`, from kernel-verified
   `decide`).
3. **Length**: both lists have 240 elements: the source length from
   `hammingConstructionA_short_vector_count`, the target from
   `rootList_length`.

This transparent chain replaces the previous single compiler-trusted finite
comparison that directly compared the two 240-element enumerations. -/

/-- Every element of the mapped short-vector list lies in
`rootList`. -/
private theorem shortVectorToRootCoords_map_subset :
    ∀ v ∈ shortShellVectorList.map shortVectorToRootCoords,
      v ∈ rootList := by
  intro v hv
  rw [List.mem_map] at hv
  obtain ⟨z, hz, rfl⟩ := hv
  exact List.forall_iff_forall_mem.mp
    shortVectorToRootCoords_mem_rootList_all z hz

/-- The mapped short-vector list is a permutation of `rootList`.

Proved as a structural chain: the mapped list is a nodup subset of
`rootList` with matching length 240, and therefore a permutation. -/
private theorem shortVectorToRootCoords_perm :
    (shortShellVectorList.map shortVectorToRootCoords).Perm
      rootList :=
  (List.subperm_of_subset shortVectorToRootCoords_map_nodup
    shortVectorToRootCoords_map_subset).perm_of_length_le
      (by simp [rootList_length, List.length_map,
                shortShellVectorList_length])

/-! ## Public interface -/

/-- Every Construction A short shell vector maps into
`Roots.rootList` under the bridge map. -/
theorem shortVectorToRootCoords_mem_rootList {z : Fin 8 → ℤ}
    (hz : z ∈ hammingE8ShortShell) :
    shortVectorToRootCoords z ∈ rootList :=
  List.forall_iff_forall_mem.mp
    shortVectorToRootCoords_mem_rootList_all z
    (shortShell_mem_shortShellVectorList hz)

/-- Every root in `Roots.rootList` has a preimage in
`hammingE8ShortShell`.

Derived from the permutation theorem rather than by independent
enumeration. -/
theorem rootList_preimage_in_shortShell {r : Fin 8 → ℤ}
    (hr : r ∈ rootList) :
    ∃ z ∈ hammingE8ShortShell,
      shortVectorToRootCoords z = r := by
  have hmem := shortVectorToRootCoords_perm.mem_iff.mpr hr
  rw [List.mem_map] at hmem
  obtain ⟨z, hzlist, hrz⟩ := hmem
  exact ⟨z,
    List.forall_iff_forall_mem.mp
      shortShellVectorList_mem_shortShell z hzlist,
    hrz⟩

/-- **Main bijection**: the bridge map sends the short-vector list to
a permutation of `Roots.rootList`.

`List.Perm l₁ l₂` asserts that `l₁` and `l₂` contain the same
elements with the same multiplicities.  Since both lists have 240
distinct elements, this witnesses a complete bijection between the
Construction A short shell and the doubled-coordinate E8 root system.

**Proof structure**: derived from
- `shortVectorToRootCoords_map_nodup` (nodup of the mapped list),
- `shortVectorToRootCoords_mem_rootList_all` (each image lies in
  `rootList`),
- `shortShellVectorList_length` (length 240, from the structural
  short-vector count `hammingConstructionA_short_vector_count`), and
- `rootList_length` (length 240).

No monolithic 240-by-240 list comparison is used. -/
theorem shortShell_perm_rootList :
    (shortShellVectorList.map shortVectorToRootCoords).Perm
      rootList :=
  shortVectorToRootCoords_perm

/-- **Norm preservation**: the bridge map sends short shell vectors
(unscaled squared norm `4`) to doubled-coordinate E8 roots (doubled
squared norm `8`).

Both conditions encode the same E8 root squared norm `2`:
`sqNorm z / 2 = 2` and `Roots.normSq r / 4 = 2`. -/
theorem shortVectorToRootCoords_normSq {z : Fin 8 → ℤ}
    (hz : z ∈ hammingE8ShortShell) :
    Roots.normSq (shortVectorToRootCoords z) = 8 :=
  normSq_eq_eight_of_mem
    (shortVectorToRootCoords_mem_rootList hz)

end CodeLatticeE8.E8.RootBridge
