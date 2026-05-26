/-
Copyright (c) 2026 PhysicsSM Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Aristotle provenance:
  Cleaned from job 234f49d7-4495-4257-8419-8f2fe4fa628b.
-/
import PhysicsSM.Draft.Sedenions.PSL27FlavorGeometry
import PhysicsSM.Draft.Sedenions.GenerationCancellationGeometry

/-!
# Fano-complement generation geometry

This module extracts the useful positive result from the Fano-complement
generation moonshot into a smaller draft-facing theorem cluster.

The earlier module `GenerationCancellationGeometry` shows that the naive
Cayley-Dickson order-three `psi` action folds the 42 zero-product plaquettes
onto 7 partner-closed sectors.  Those sectors are the vertical-pair expansions
of the 7 complements of Fano lines in the low imaginary half `{1,...,7}`.

This file proves the next finite combinatorial layer:

```text
42 zero-product plaquettes
  = 7 Fano-complement sectors
  * 3 perfect matchings per sector
  * 2 edges per matching
```

For the canonical complement `{4,5,6,7}`, the 6 zero-product plaquettes are
the 6 edges of the complete graph on the 4 complement vertices.  Those 6 edges
have exactly 3 perfect matchings.  The `GL(3,2)` stabilizer of the sector has
order 24 and induces all 6 permutations of the 3 matchings.

Convention note:
This is the recursive Cayley-Dickson convention used throughout the sedenion
draft modules.  It is not silently identified with the trusted project
octonion convention.

Interpretation note:
This is a finite candidate `S3` generation geometry.  It is not claimed to be
the physical `S3` from the Clifford-algebra literature.
-/

set_option linter.style.nativeDecide false

namespace FanoComplementGeneration

open GL32Action

/-! ## The canonical Fano-complement sector -/

/-- The canonical Fano-line complement `{4,5,6,7}` in the low imaginary half. -/
def canonicalComplement : List (Fin 8) := [4, 5, 6, 7]

/--
Sort a four-point mixed support into a stable natural-number key.

The input `(i,j,k,l)` represents the support
`{i, 8+j, k, 8+l}`.  The key forgets the ordering and keeps the retained
coordinate convention used throughout the zero-divisor code computations.
-/
def supportKey (i j k l : Fin 8) : List Nat :=
  [i.val, 8 + j.val, k.val, 8 + l.val] |>.mergeSort (· <= ·)

/--
All oriented zero-product quadruples whose low indices lie in the canonical
complement.

This list still contains many orderings of the same support; `sectorZPKeys`
deduplicates them.
-/
def zpQuadsInCanonicalComplement : List (Fin 8 × Fin 8 × Fin 8 × Fin 8) :=
  canonicalComplement.flatMap fun i =>
  canonicalComplement.flatMap fun j =>
  canonicalComplement.flatMap fun k =>
  canonicalComplement.flatMap fun l =>
    if isZPQuadB (i, j, k, l) then [(i, j, k, l)] else []

/-- The six distinct zero-product support keys in the canonical sector. -/
def sectorZPKeys : List (List Nat) :=
  (zpQuadsInCanonicalComplement.map fun (i, j, k, l) =>
    supportKey i j k l).dedup

/-- The canonical Fano-complement sector contains exactly six ZP supports. -/
theorem canonical_sector_six_zp : sectorZPKeys.length = 6 := by
  native_decide

/-! ## Edges of the complement and the support dictionary -/

/-- An edge of the complete graph on the four complement vertices. -/
abbrev Edge := Fin 8 × Fin 8

/-- A perfect matching is a pair of disjoint edges covering all four vertices. -/
abbrev Matching := Edge × Edge

/-- The six edges of the complete graph on `{4,5,6,7}`. -/
def edgeList : List Edge :=
  [((4 : Fin 8), 5), (4, 6), (4, 7), (5, 6), (5, 7), (6, 7)]

/--
Map an edge `{a,b}` of the complement to the associated ZP support key.

The other two complement vertices become the high coordinates.  This is the
clean finite dictionary behind the phrase "six plaquettes are six edges".
-/
def edgeToSupportKey (e : Edge) : List Nat :=
  let complementPair : List (Fin 8) :=
    canonicalComplement.filter fun x => x != e.1 && x != e.2
  (([e.1.val, e.2.val] : List Nat) ++
    complementPair.map fun (x : Fin 8) => 8 + x.val).mergeSort (· <= ·)

/-- The edge-to-support map gives exactly the six sector support keys. -/
theorem edge_support_keys_eq :
    (edgeList.map edgeToSupportKey).mergeSort (· <= ·) =
      sectorZPKeys.mergeSort (· <= ·) := by
  native_decide

/-- Distinct edges give distinct support keys. -/
theorem edge_map_nodup :
    (edgeList.map edgeToSupportKey).Nodup := by
  native_decide

/-- The canonical sector's six ZP supports are the six edges of `K4`. -/
theorem sector_contains_six_edges_of_complement :
    edgeList.length = 6 ∧
    sectorZPKeys.length = 6 ∧
    (edgeList.map edgeToSupportKey).mergeSort (· <= ·) =
      sectorZPKeys.mergeSort (· <= ·) := by
  exact ⟨by native_decide, canonical_sector_six_zp, edge_support_keys_eq⟩

/-! ## The three perfect matchings -/

/-- The first perfect matching of `K4` on `{4,5,6,7}`. -/
def matching0 : Matching := (((4 : Fin 8), 5), (6, 7))

/-- The second perfect matching of `K4` on `{4,5,6,7}`. -/
def matching1 : Matching := (((4 : Fin 8), 6), (5, 7))

/-- The third perfect matching of `K4` on `{4,5,6,7}`. -/
def matching2 : Matching := (((4 : Fin 8), 7), (5, 6))

/--
A normalized matching: the four endpoints are exactly `{4,5,6,7}`, each edge is
internally ordered, and the two edges are ordered lexicographically.
-/
def isValidMatching (m : Matching) : Bool :=
  let endpoints := [m.1.1.val, m.1.2.val, m.2.1.val, m.2.2.val]
  endpoints.mergeSort (· <= ·) == [4, 5, 6, 7] &&
  decide (m.1.1 < m.1.2) && decide (m.2.1 < m.2.2) &&
  decide (m.1.1 < m.2.1 || (m.1.1 = m.2.1 && m.1.2 < m.2.2))

/-- The list of all normalized perfect matchings in the canonical sector. -/
def allMatchings : List Matching :=
  edgeList.flatMap fun e1 =>
  edgeList.flatMap fun e2 =>
    if isValidMatching (e1, e2) then [(e1, e2)] else []

/-- The six edges of `K4` have exactly three perfect matchings. -/
theorem complement_edges_have_three_matchings :
    allMatchings.length = 3 := by
  native_decide

/-- The three matchings are the explicit matchings listed above. -/
theorem matchings_eq :
    allMatchings = [matching0, matching1, matching2] := by
  native_decide

/-! ## Stabilizer action and induced `S3` -/

/-- An executable list view of `GL(3,2)` basis triples. -/
def gl32List : List (Fin 8 × Fin 8 × Fin 8) :=
  (List.finRange 8).flatMap fun v1 =>
  (List.finRange 8).flatMap fun v2 =>
  (List.finRange 8).flatMap fun v4 =>
    if isValidGL32 (v1, v2, v4) then [(v1, v2, v4)] else []

/-- The list view still has the expected 168 elements. -/
theorem gl32List_length : gl32List.length = 168 := by
  native_decide

/-- Action of a `GL(3,2)` basis triple on the low `Fin 8` labels. -/
def gl32Act (t : Fin 8 × Fin 8 × Fin 8) : Fin 8 → Fin 8 :=
  extendLinear t.1 t.2.1 t.2.2

/-- Boolean test for stabilizing the canonical complement. -/
def stabilizesCanonicalComplement (t : Fin 8 × Fin 8 × Fin 8) : Bool :=
  (canonicalComplement.map (gl32Act t)).mergeSort (· <= ·) ==
    canonicalComplement.mergeSort (· <= ·)

/-- The stabilizer of the canonical complement. -/
def stabilizerList : List (Fin 8 × Fin 8 × Fin 8) :=
  gl32List.filter stabilizesCanonicalComplement

/-- The canonical complement stabilizer has order 24. -/
theorem canonical_stabilizer_card : stabilizerList.length = 24 := by
  native_decide

/-- Normalize a matching after a permutation of vertices. -/
def normalizeMatching (m : Matching) : Matching :=
  let e1 : Edge := if m.1.1 <= m.1.2 then m.1 else (m.1.2, m.1.1)
  let e2 : Edge := if m.2.1 <= m.2.2 then m.2 else (m.2.2, m.2.1)
  if e1.1 < e2.1 || (e1.1 = e2.1 && e1.2 <= e2.2) then (e1, e2) else (e2, e1)

/-- Apply a `GL(3,2)` element to a matching. -/
def actOnMatching (t : Fin 8 × Fin 8 × Fin 8) (m : Matching) : Matching :=
  let f := gl32Act t
  normalizeMatching ((f m.1.1, f m.1.2), (f m.2.1, f m.2.2))

/-- The sector stabilizer preserves the three perfect matchings. -/
theorem gl32_sector_stabilizer_acts_on_matchings :
    ∀ t ∈ stabilizerList, ∀ m ∈ allMatchings,
      actOnMatching t m ∈ allMatchings := by
  native_decide

/-- Index the three explicit matchings by `0`, `1`, and `2`. -/
def matchIdx (m : Matching) : Nat :=
  if m = matching0 then 0 else if m = matching1 then 1 else 2

/-- The induced permutation of the three matchings, encoded as a triple. -/
def matchingPermTriple (t : Fin 8 × Fin 8 × Fin 8) : Nat × Nat × Nat :=
  (matchIdx (actOnMatching t matching0),
   matchIdx (actOnMatching t matching1),
   matchIdx (actOnMatching t matching2))

/-- The list of induced permutations of the three matchings. -/
def inducedPerms : List (Nat × Nat × Nat) :=
  (stabilizerList.map matchingPermTriple).dedup

/-- The induced action produces exactly six permutations. -/
theorem induced_generation_action_card_six :
    inducedPerms.length = 6 := by
  native_decide

/-- The six induced permutations are exactly the full symmetric group on three letters. -/
theorem induced_perms_are_S3 :
    inducedPerms.toFinset =
      {(0, 1, 2), (0, 2, 1), (1, 0, 2), (1, 2, 0), (2, 0, 1), (2, 1, 0)} := by
  native_decide

/-- The orbit of one matching is all three matchings. -/
theorem matching_orbit_transitive :
    (stabilizerList.map fun t => actOnMatching t matching0).dedup =
      allMatchings := by
  native_decide

/-- Elements of the stabilizer that fix all three perfect matchings. -/
def kernelList : List (Fin 8 × Fin 8 × Fin 8) :=
  stabilizerList.filter fun t =>
    actOnMatching t matching0 = matching0 &&
    actOnMatching t matching1 = matching1 &&
    actOnMatching t matching2 = matching2

/-- The kernel of the action on matchings has order four. -/
theorem matching_kernel_card_four : kernelList.length = 4 := by
  native_decide

/-- The finite-cardinality shadow of the quotient `S4 / V4 = S3`. -/
theorem stabilizer_quotient_consistent :
    stabilizerList.length = kernelList.length * inducedPerms.length := by
  native_decide

/-! ## Uniformity across all seven Fano complements -/

/-- The seven Fano lines of `PG(2,2)`, listed in low `Fin 8` labels. -/
def fanoLinesList : List (List (Fin 8)) :=
  [[1, 2, 3], [1, 4, 5], [1, 6, 7], [2, 4, 6],
   [2, 5, 7], [3, 4, 7], [3, 5, 6]]

/-- Complement of a Fano line inside `{1,...,7}`. -/
def complementOf (line : List (Fin 8)) : List (Fin 8) :=
  ([1, 2, 3, 4, 5, 6, 7] : List (Fin 8)).filter fun x => x ∉ line

/-- Stabilizer cardinality for a Fano-line complement. -/
def stabilizerCardOf (line : List (Fin 8)) : Nat :=
  let complement := complementOf line
  (gl32List.filter fun t =>
    (complement.map (gl32Act t)).mergeSort (· <= ·) ==
      complement.mergeSort (· <= ·)).length

/-- Number of zero-product supports inside a Fano-line complement. -/
def zpCountOf (line : List (Fin 8)) : Nat :=
  let complement := complementOf line
  (complement.flatMap fun i =>
   complement.flatMap fun j =>
   complement.flatMap fun k =>
   complement.flatMap fun l =>
      if isZPQuadB (i, j, k, l) then
        [supportKey i j k l]
      else []).dedup.length

/-- Every Fano-line complement has stabilizer of order 24. -/
theorem all_stabilizers_card_24 :
    ∀ line ∈ fanoLinesList, stabilizerCardOf line = 24 := by
  native_decide

/-- Every Fano-line complement contains six zero-product supports. -/
theorem all_sectors_six_zp :
    ∀ line ∈ fanoLinesList, zpCountOf line = 6 := by
  native_decide

/-- `GL(3,2)` acts transitively on the seven Fano-line complements. -/
theorem gl32_transitive_on_complements :
    ∀ line ∈ fanoLinesList,
      ∃ t ∈ gl32List,
        (canonicalComplement.map (gl32Act t)).mergeSort (· <= ·) =
          (complementOf line).mergeSort (· <= ·) := by
  native_decide

/-! ## Summary theorem -/

/--
The finite generation-geometry package for the zero-product plaquettes.

The formal content is intentionally combinatorial: the canonical sector has
six plaquettes, those six plaquettes are the six edges of `K4`, the edges have
three perfect matchings, and the sector stabilizer induces all six
permutations of those matchings.
-/
theorem fano_complement_generation_summary :
    sectorZPKeys.length = 6 ∧
    allMatchings.length = 3 ∧
    stabilizerList.length = 24 ∧
    inducedPerms.length = 6 ∧
    kernelList.length = 4 ∧
    stabilizerList.length = kernelList.length * inducedPerms.length := by
  exact ⟨canonical_sector_six_zp,
    complement_edges_have_three_matchings,
    canonical_stabilizer_card,
    induced_generation_action_card_six,
    matching_kernel_card_four,
    stabilizer_quotient_consistent⟩

end FanoComplementGeneration
