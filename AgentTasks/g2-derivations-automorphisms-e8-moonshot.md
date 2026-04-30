# Task: G2 From the Ground Up — Der(𝕆)=14, conjBy Automorphism, E8 Cartan, Hamming-Fano

**Agent**: Aristotle
**Status**: In progress
**Job ID**: `270e946c-7615-49ff-aded-15f9a2c68c15`
**Submitted**: 2026-04-29
**Priority**: MOONSHOT — Six independent phases, all finite computation
**Output**: `AgentTasks/aristotle-output/g2-derivations-automorphisms-e8-moonshot`

---

## Overview and ambition

This task targets six independent goals, each a kernel-verifiable result, in one
submission. Together they constitute the formal algebraic foundation for the chain

```
Hamming code [7,4,3] = Fano plane
         ↓ Construction A
E8 Cartan matrix (rank 8, det 1)
         ↓
conjBy automorphism group of O ⊇ {a : normSq a = 1, cube a = ±1}
         ↓
Der(O) = 14-dimensional Lie algebra (G2 in the making)
```

**Every single theorem in this task is a FINITE COMPUTATION.** No abstract
algebra, no new axioms. The proof template for nearly every statement is one of:
```lean
ext <;> simp [...] <;> ring                   -- polynomial identity
fin_cases i <;> fin_cases j <;> decide        -- finite case check
native_decide                                 -- large but decidable computation
```

**Oracle validation:** All results were checked numerically against 30–100 random
samples before this prompt was written. Every claimed identity passes.

---

## Files to modify

All new definitions and theorems go into existing files. Do NOT create new files.

**Primary files:**
- `PhysicsSM/Algebra/Octonion/TrialityCompanions.lean` — Phases A and F
- `PhysicsSM/Lie/Exceptional/E8.lean` — Phase D
- `PhysicsSM/Algebra/Octonion/OctonionSymmetry.lean` — Phase B
- `PhysicsSM/Algebra/Octonion/Basic.lean` — Phase E (small addition)

**Already available via imports:**
- `normSq`, `normSq_mul`, `normSq_conj`, `conj_mul`, `mul_conj` from `Norm.lean`
- `left_alternative`, `right_alternative` from `Basic.lean`
- `moufang_left`, `moufang_right`, `moufang_middle`, `flexible` from `Moufang.lean`
- `conjBy`, `cube`, `conjBy_mul_of_unit_cube_eq_one`, `conjBy_mul_of_unit_cube_eq_neg_one`,
  `conjBy_iter_three_*`, `unit_mul_conj_eq_one`, `unit_conj_mul_eq_one` from `TrialityCompanions.lean`
- `octonionDot`, `IsImaginary`, `octonionCommutator` from `OctonionSymmetry.lean`

---

## Phase A — conjBy as a full algebra automorphism (5 theorems)

File: `PhysicsSM/Algebra/Octonion/TrialityCompanions.lean`

The existing file proves `conjBy a` preserves multiplication when `cube a = ±1`.
These theorems complete the picture: `conjBy a` is a full algebra automorphism
(ring isomorphism) in those cases.

### A1. normSq preservation (*oracle-verified*)

```lean
/-- For a unit octonion a, conjBy a preserves the squared norm.
    Proof: normSq(conjBy a x) = normSq((a*x)*conj a)
         = normSq(a*x) * normSq(conj a)       [normSq_mul]
         = normSq(a) * normSq(x) * normSq(a)  [normSq_mul twice]
         = 1 * normSq(x) * 1 = normSq(x).    [normSq a = 1, normSq_conj]
    No Moufang or cube hypothesis needed. -/
theorem conjBy_normSq {a : Octonion} (ha : normSq a = 1) (x : Octonion) :
    normSq (conjBy a x) = normSq x := by
  unfold conjBy
  rw [normSq_mul, normSq_mul, normSq_conj, ha, ha]
  ring
```

### A2. conjBy preserves conjugation (*oracle-verified*)

```lean
/-- conjBy a commutes with octonion conjugation for unit a. -/
theorem conjBy_conj {a : Octonion} (ha : normSq a = 1) (x : Octonion) :
    conjBy a (conj x) = conj (conjBy a x) := by
  unfold conjBy
  -- conj((a*x)*conj a) = conj(conj a) * conj(a*x) = a * (conj x * conj a)
  rw [conj_mul, conj_mul, conj_conj]
  -- need to show (a * conj x) * conj a = a * (conj x * conj a):
  -- Use right_alternative with the specific structure
  ext <;> simp [conj, Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
               Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
               Octonion.mul_c6, Octonion.mul_c7] <;> ring
```

### A3. conjBy is injective (from normSq preservation)

```lean
/-- conjBy a is injective for unit a, since it preserves normSq and the map
    x ↦ conjBy a x = (a*x)*conj(a) has an explicit inverse: conjBy (conj a). -/
theorem conjBy_injective {a : Octonion} (ha : normSq a = 1) :
    Function.Injective (conjBy a) := by
  intros x y hxy
  -- Left-inverse: conjBy (conj a) (conjBy a x) = x
  have hinv : ∀ z, conjBy (conj a) (conjBy a z) = z := by
    intro z
    unfold conjBy
    rw [conj_conj]
    -- ((conj a * ((a * z) * conj a)) * a)
    -- Use unit_conj_mul_cancel_left and unit_mul_conj_cancel_right
    ext <;> simp [conj, Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
                 Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
                 Octonion.mul_c6, Octonion.mul_c7] <;> ring
  calc x = conjBy (conj a) (conjBy a x) := (hinv x).symm
       _ = conjBy (conj a) (conjBy a y) := by rw [hxy]
       _ = y                             := hinv y
```

### A4. conjBy is surjective

```lean
/-- conjBy a is surjective: its right inverse is conjBy (conj a). -/
theorem conjBy_surjective {a : Octonion} (ha : normSq a = 1) :
    Function.Surjective (conjBy a) := by
  intro y
  exact ⟨conjBy (conj a) y, by
    unfold conjBy; rw [conj_conj]
    ext <;> simp [conj, Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
                 Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
                 Octonion.mul_c6, Octonion.mul_c7] <;> ring⟩
```

### A5. conjBy is a full algebra automorphism when cube a = ±1

```lean
/-- For a unit octonion a with cube a = 1, conjBy a is an algebra automorphism:
    it is additive, preserves multiplication, fixes the scalar unit, and is bijective.
    This is the complete automorphism statement, finishing what the existing
    conjBy_mul_of_unit_cube_eq_one started. -/
theorem conjBy_isAlgAut_of_unit_cube_one {a : Octonion}
    (ha : normSq a = 1) (hc : cube a = 1) :
    conjBy a 1 = 1 ∧
    (∀ x y, conjBy a (x + y) = conjBy a x + conjBy a y) ∧
    (∀ x y, conjBy a (x * y) = conjBy a x * conjBy a y) ∧
    Function.Bijective (conjBy a) := by
  exact ⟨conjBy_one_of_unit ha,
         conjBy_add a,
         conjBy_mul_of_unit_cube_eq_one ha hc,
         ⟨conjBy_injective ha, conjBy_surjective ha⟩⟩
```

---

## Phase B — Associator antisymmetry (*oracle-verified, 100 random triples*)

File: `PhysicsSM/Algebra/Octonion/OctonionSymmetry.lean`

The associator `assoc a b c = (a * b) * c - a * (b * c)` is alternating (antisymmetric
in every pair of arguments). This is the algebraic fingerprint of alternativity.

**Proof strategy.** From `left_alternative` (a*(a*x) = (a*a)*x) linearized at a→a+b:
replace a by a+b, expand, subtract the two pure cases. The result is the crossed
term, giving the antisymmetry. Then `ring` after `simp` expansion.

```lean
/-- The octonion associator is antisymmetric in the first two arguments.
    Source: standard consequence of left alternativity (linearization).
    Oracle-verified over 100 random triples. -/
theorem assoc_antisymm_12 (a b c : Octonion) :
    (a * b) * c - a * (b * c) = -((b * a) * c - b * (a * c)) := by
  ext <;>
    simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
      Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
      Octonion.mul_c6, Octonion.mul_c7,
      Octonion.sub_c0, Octonion.sub_c1, Octonion.sub_c2,
      Octonion.sub_c3, Octonion.sub_c4, Octonion.sub_c5,
      Octonion.sub_c6, Octonion.sub_c7,
      Octonion.neg_c0, Octonion.neg_c1, Octonion.neg_c2,
      Octonion.neg_c3, Octonion.neg_c4, Octonion.neg_c5,
      Octonion.neg_c6, Octonion.neg_c7] <;>
    ring

/-- The octonion associator is antisymmetric in the last two arguments.
    Oracle-verified over 100 random triples. -/
theorem assoc_antisymm_23 (a b c : Octonion) :
    (a * b) * c - a * (b * c) = -((a * c) * b - a * (c * b)) := by
  ext <;>
    simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
      Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
      Octonion.mul_c6, Octonion.mul_c7,
      Octonion.sub_c0, Octonion.sub_c1, Octonion.sub_c2,
      Octonion.sub_c3, Octonion.sub_c4, Octonion.sub_c5,
      Octonion.sub_c6, Octonion.sub_c7,
      Octonion.neg_c0, Octonion.neg_c1, Octonion.neg_c2,
      Octonion.neg_c3, Octonion.neg_c3, Octonion.neg_c4,
      Octonion.neg_c5, Octonion.neg_c6, Octonion.neg_c7] <;>
    ring
```

---

## Phase C — dim(Der(𝕆)) = 14 via the Leibniz constraint matrix

File: `PhysicsSM/Algebra/Octonion/OctonionSymmetry.lean`

A derivation D : Octonion → Octonion is a ℝ-linear map satisfying
D(x * y) = D(x) * y + x * D(y) (the Leibniz rule). The space of all such maps
has dimension exactly 14, equal to the dimension of the exceptional Lie algebra G₂.

**Key insight.** A derivation is determined by 64 real parameters (the 8×8 matrix of
D(eᵢ) components). The Leibniz rule for all basis pairs imposes exactly 512 linear
constraints. The constraint matrix has INTEGER entries in {-2,-1,0,1,2}, so its
rank is computable by `native_decide` over ℚ. The rank is 50, giving dim = 64 - 50 = 14.
All 14 derivations in the null space were verified to satisfy Leibniz over 30 random
samples each.

**Step 1: Define the Leibniz predicate**

```lean
/-- A ℝ-linear map D on octonions is a derivation if it satisfies the Leibniz rule. -/
def IsDerivation (D : Octonion → Octonion) : Prop :=
  (∀ r x, D (r • x) = r • D x) ∧       -- ℝ-linearity
  (∀ x y, D (x + y) = D x + D y) ∧     -- additivity
  (∀ x y, D (x * y) = D x * y + x * D y)  -- Leibniz
```

**Step 2: Prove D(1) = 0 for any derivation**

```lean
/-- Every derivation kills the unit: D(1) = 0.
    Proof: D(1) = D(1*1) = D(1)*1 + 1*D(1) = 2*D(1) → D(1) = 0. -/
theorem derivation_kills_one {D : Octonion → Octonion} (hD : IsDerivation D) :
    D 1 = 0 := by
  have hL := hD.2.2 1 1
  simp [Octonion.one_mul, Octonion.mul_one] at hL  -- from one_mul, mul_one
  -- hL : D 1 = D 1 + D 1
  linarith [hL]  -- but this is Octonion not ℝ; use ext
  ext <;> simp [hL, ...] <;> linarith
```

**Step 3: The constraint matrix rank computation**

Define the 512×64 integer constraint matrix explicitly (using the XOR multiplication
table) and prove its rank over ℚ equals 50:

```lean
/-- The constraint matrix encoding the Leibniz rule for octonion derivations.
    Rows are indexed by (i, j, output-component) triples, columns by derivation matrix entries.
    Entries are in {-2,-1,0,1,2} from the structure constants of the XOR multiplication. -/
def derivationConstraintMatrix : Matrix (Fin 512) (Fin 64) ℚ :=
  -- Row (i*64 + j*8 + m) encodes the (eᵢ*eⱼ, component m) Leibniz constraint:
  -- s_{ij} * M[i⊕j, m] - Σ_{k: k⊕j=m} s_{kj} * M[i, k] - Σ_{k: i⊕k=m} s_{ik} * M[j, k] = 0
  fun row col =>
    let i := row.val / 64; let j := (row.val / 8) % 8; let m := row.val % 8
    let ij := i ^^^ j  -- XOR product index
    let s_ij := lookupSign ⟨i, by omega⟩ ⟨j, by omega⟩  -- from Basic.lean
    -- [Fill in explicitly using lookupSign from Basic.lean]
    sorry -- Aristotle: fill this in using the XOR multiplication table

theorem derivationConstraintMatrix_rank : derivationConstraintMatrix.rank = 50 := by
  native_decide  -- finite computation over ℚ

/-- The space of octonion derivations has dimension 14. -/
theorem dim_derivations_eq_14 :
    Module.rank ℝ {D : Octonion →ₗ[ℝ] Octonion | IsDerivation D} = 14 := by
  -- From derivationConstraintMatrix_rank: ker has dim 64 - 50 = 14
  sorry  -- Aristotle: connect constraint rank to module rank
```

**Note on the constraint matrix.** The matrix has the following structure:
- First 8 rows (D(1) = 0 constraints): 8 unit-vector rows, rank 8
- Remaining 504 rows (Leibniz for basis pairs): rank 42 additional constraints
- Total rank: 50 → null space dimension 14

If `native_decide` is too slow for the full 512×64 matrix, split into two parts:
the 8 easy constraints (rank 8) and the remaining 504 (rank 42).

---

## Phase D — E8 Cartan matrix: definition and unimodularity

File: `PhysicsSM/Lie/Exceptional/E8.lean`

The E8 Cartan matrix in Bourbaki labelling (0-indexed, node 1 branches off node 3):

```
Connected pairs: (0,2), (2,3), (3,4), (4,5), (5,6), (6,7), (1,3)
```

```lean
/-- The E8 Cartan matrix in Bourbaki labelling (nodes 0-7).
    Node 1 branches off node 3 in the chain 0-2-3-4-5-6-7.
    Diagonal entries = 2; off-diagonal = -1 for adjacent nodes, 0 otherwise.
    Source: Bourbaki "Lie Groups and Lie Algebras" Ch. 4-6, Table Exc. -/
def e8Cartan : Matrix (Fin 8) (Fin 8) ℤ
  | i, j =>
    if i = j then 2
    else if (i, j) ∈ ({(0,2),(2,0),(2,3),(3,2),(3,4),(4,3),(4,5),(5,4),
                        (5,6),(6,5),(6,7),(7,6),(1,3),(3,1)} : Finset (Fin 8 × Fin 8))
    then -1 else 0

-- The 8×8 matrix is explicitly:
-- row 0: [ 2, 0,-1, 0, 0, 0, 0, 0]
-- row 1: [ 0, 2, 0,-1, 0, 0, 0, 0]
-- row 2: [-1, 0, 2,-1, 0, 0, 0, 0]
-- row 3: [ 0,-1,-1, 2,-1, 0, 0, 0]
-- row 4: [ 0, 0, 0,-1, 2,-1, 0, 0]
-- row 5: [ 0, 0, 0, 0,-1, 2,-1, 0]
-- row 6: [ 0, 0, 0, 0, 0,-1, 2,-1]
-- row 7: [ 0, 0, 0, 0, 0, 0,-1, 2]

theorem e8Cartan_diag (i : Fin 8) : e8Cartan i i = 2 := by
  fin_cases i <;> decide

theorem e8Cartan_off_diag_nonpos (i j : Fin 8) (h : i ≠ j) :
    e8Cartan i j = 0 ∨ e8Cartan i j = -1 := by
  fin_cases i <;> fin_cases j <;> simp_all (config := {decide := true}) [e8Cartan]

theorem e8Cartan_symm_zero (i j : Fin 8) :
    e8Cartan i j = 0 ↔ e8Cartan j i = 0 := by
  fin_cases i <;> fin_cases j <;> decide

/-- The E8 Cartan matrix is unimodular: its determinant equals 1.
    This is the algebraic content of E8 being self-dual (equal to its own dual lattice).
    Proof: native_decide on the explicit 8×8 integer matrix.
    Oracle-verified: det([[2,0,-1,...],[0,2,0,-1,...] ,...]) = 1 -/
theorem e8Cartan_det_eq_one :
    Matrix.det e8Cartan = 1 := by native_decide
```

---

## Phase E — Fano plane = Hamming parity-check skeleton (Q1.7)

File: `PhysicsSM/Algebra/Octonion/Basic.lean`

The seven nonzero vectors of 𝔽₂³ serve simultaneously as the seven Fano plane
points (encoding octonion multiplication via `fanoTriples`) and the seven columns
of the parity-check matrix of the [7,4,3] Hamming code.

The formal content: every Fano triple (a, b, c) satisfies `a XOR b = c` (bitwise
on the 3-bit labels), which is the same as saying {a, b, c} is a line of the projective
plane PG(2,2), which is the same as saying the 3-vector representation is a parity-check
row of the Hamming code.

```lean
/-- Every Fano triple (a, b, c) in fanoTriples satisfies the XOR closure property:
    the binary labels satisfy a ⊕ b = c (bitwise XOR).
    This is the combinatorial skeleton shared by the Fano plane and the [7,4,3]
    Hamming parity-check matrix: each line of PG(2,2) corresponds to one Hamming
    constraint. -/
theorem fanoTriple_xor_closure :
    ∀ t ∈ fanoTriples, t.1.val ^^^ t.2.1.val = t.2.2.val := by
  decide

/-- The seven Fano lines are in bijection with the seven rows of the standard
    3×7 parity-check matrix H of the [7,4,3] Hamming code, where the j-th column
    of H is the 3-bit binary representation of j+1. -/
theorem fano_lines_are_hamming_parity_rows :
    ∀ t ∈ fanoTriples,
    (Nat.testBit t.1.val 0 : Bool) = (Nat.testBit t.2.1.val 0 ^^^ Nat.testBit t.2.2.val 0) ∧
    (Nat.testBit t.1.val 1 : Bool) = (Nat.testBit t.2.1.val 1 ^^^ Nat.testBit t.2.2.val 1) ∧
    (Nat.testBit t.1.val 2 : Bool) = (Nat.testBit t.2.1.val 2 ^^^ Nat.testBit t.2.2.val 2) := by
  decide

/-- The 14 Fano triples (7 lines × 2 cyclic orderings) partition the 42
    ordered pairs of distinct elements of {1,...,7} — exactly the structure
    of the [7,4,3] Hamming code's dual (the simplex code).
    This confirms the Fano plane IS the combinatorial skeleton of the [7,4,3] code. -/
theorem fano_covers_all_ordered_pairs :
    ∀ (a b : Fin 8) (ha : a.val ∈ Finset.range 7 |>.map ⟨(· + 1), by simp⟩)
                     (hb : b.val ∈ Finset.range 7 |>.map ⟨(· + 1), by simp⟩)
                     (hab : a ≠ b),
    ∃ t ∈ fanoTriples, (t.1 = a ∧ t.2.1 = b) ∨ (t.1 = b ∧ t.2.1 = a) ∨
                        (t.2.1 = a ∧ t.2.2 = b) ∨ (t.2.1 = b ∧ t.2.2 = a) ∨
                        (t.1 = a ∧ t.2.2 = b) ∨ (t.1 = b ∧ t.2.2 = a) := by
  decide
```

---

## Phase F — STRETCH GOAL: Converse automorphism criterion

File: `PhysicsSM/Algebra/Octonion/TrialityCompanions.lean`

The existing file proves:
- `conjBy_mul_of_unit_cube_eq_one`: `cube a = 1 ⟹ PreservesMul (conjBy a)` for unit a
- `conjBy_mul_of_unit_cube_eq_neg_one`: same for `cube a = -1`

The converse would complete the Baez 2025 criterion: `cube a = ±1` is NECESSARY
and SUFFICIENT for `conjBy a` to be a multiplication-preserving automorphism.

```lean
/-- STRETCH GOAL: The converse automorphism criterion (Baez 2025 open question direction).
    If conjBy a preserves multiplication for a unit octonion a, then cube a = 1 or cube a = -1.

    Proof strategy: If (a*x)*(conj a) * ((a*y)*(conj a)) = (a*(x*y))*(conj a) for all x, y,
    then specializing x = a, y = a:
    (a*a)*(conj a) * ((a*a)*(conj a)) = (a*(a*a))*(conj a)
    i.e. (cube a)*(conj a) * (cube a)*(conj a) = (a*(a*a))*(conj a)
    Further substitution gives cube(cube a) = cube a (using normSq a = 1)
    → (cube a)^3 = ±1 as a scalar (since cube a has normSq 1 by normSq_mul)
    → cube a is a real-scalar unit octonion satisfying t^3 = ±1
    → t = ±1, so cube a = 1*e000 or cube a = -1*e000.

    This is the hardest theorem in this file. If a complete proof cannot be found,
    leave a careful sorry with a proof sketch using the strategy above. -/
theorem preservesMul_conjBy_iff_cube {a : Octonion} (ha : normSq a = 1) :
    PreservesMul (conjBy a) ↔ cube a = 1 ∨ cube a = -1 := by
  constructor
  · -- Hard direction: PreservesMul → cube = ±1
    intro hP
    -- Specialize hP at x = a * a (= a^2), y = a
    have hspec := hP.2 (a * a) a
    -- This gives: conjBy a (a*a) * conjBy a a = conjBy a ((a*a)*a)
    -- i.e., conjBy a (a*a) * conjBy a a = conjBy a (cube a)
    -- Using conjBy_one_of_unit and the group structure, derive cube a = ±1
    sorry  -- Hard; include a proof sketch
  · -- Easy direction: cube = ±1 → PreservesMul (already proved)
    rintro (h | h)
    · exact PreservesMul_of_unit_cube_one ha h  -- or the existing theorem
    · exact PreservesMul_of_unit_cube_neg_one ha h
```

---

## What is and is not expected

**Phases A, D, E** are straightforward finite computations. Aristotle should prove
all of these completely.

**Phase B** (associator antisymmetry) should be provable by `ext <;> simp <;> ring`
after the mul_c simp lemmas expand everything to ℝ-component polynomial identities.

**Phase C** (derivation dimension) is ambitious. The hard part is constructing the
512×64 constraint matrix in Lean and invoking `native_decide` on its rank. If
`native_decide` is too slow, try:
1. Split into two matrices of size 8×64 and 504×64
2. Prove rank of each piece separately
3. Alternatively: construct 14 explicit linearly independent derivations and prove
   each satisfies Leibniz (by `ext <;> simp <;> ring`), then prove the space is
   at most 14-dimensional via the constraint argument

**Phase F** (converse criterion): This is the wildly ambitious stretch goal.
Include the best proof Aristotle can find; a careful sorry with a complete
proof sketch is acceptable and valuable.

---

## Constraints

1. **No sorry except in Phase F** (converse criterion, where a careful sorry is
   acceptable as a handoff note).
2. **No new axioms.** All proofs use only propext, Classical.choice, Quot.sound.
3. **All definitions in correct namespaces.** TrialityCompanions goes in
   `PhysicsSM.Algebra.Octonion`, E8 goes in `PhysicsSM.Lie.Exceptional`.
4. **Verbose comments.** Every theorem needs a docstring explaining the
   mathematical content and why the parenthesization is the one chosen.
5. **The octonion multiplication is non-associative.** Never rewrite under
   multiplication unless a specific alternative/Moufang lemma justifies it.

---

## Verification

```bash
lake env lean PhysicsSM/Algebra/Octonion/TrialityCompanions.lean
lake env lean PhysicsSM/Algebra/Octonion/OctonionSymmetry.lean
lake env lean PhysicsSM/Lie/Exceptional/E8.lean
lake env lean PhysicsSM/Algebra/Octonion/Basic.lean
```

Zero errors (except possibly a sorry in Phase F).
No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe def` in Phases A–E.

---

## Mathematical payoff

After this job, the repository will have kernel-verified:
- **Phase A**: conjBy(a) is a full algebra automorphism for unit a with cube a = ±1
- **Phase B**: The octonion associator is fully antisymmetric (foundational for G2)
- **Phase C**: dim(Der(𝕆)) = 14 (the algebraic proof that G2 has the right dimension)
- **Phase D**: The E8 Cartan matrix is unimodular (det = 1, from the Boyle/Baez E8 story)
- **Phase E**: The Fano plane and [7,4,3] Hamming code share the same combinatorial skeleton
- **Phase F (stretch)**: The Baez 2025 criterion: conjBy(a) is an automorphism ↔ cube a = ±1

Together, this is the largest single leap toward G2 = Aut(𝕆) in the project so far.
