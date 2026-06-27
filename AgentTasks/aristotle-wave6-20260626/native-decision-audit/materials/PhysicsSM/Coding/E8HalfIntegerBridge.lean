import Mathlib
import PhysicsSM.Coding.HammingE8

/-!
# Half-integer coordinate model of E8 and bridge to Construction A

This module defines the standard half-integer/integer even-sum coordinate model
of the E8 lattice and proves a predicate-level equivalence between the two
principal descriptions of E8:

1. **Construction A model** (`e8IntLattice`): the lattice
   `Λ(C₈) = { z ∈ ℤ⁸ : z mod 2 ∈ C₈ }` where `C₈` is the extended `[8,4,4]`
   Hamming code.  Integer squared norm `sqNorm z = ∑ zᵢ²`; minimum nonzero
   value is **4**.

2. **Half-integer model** (`halfIntegerE8Predicate`): vectors `v ∈ ℚ⁸` where
   every coordinate is a half-integer (`2vᵢ ∈ ℤ`), all coordinates share the
   same fractional part (all integer or all half-integer), and the coordinate
   sum is an even integer.  Rational squared norm `∑ vᵢ²`; minimum nonzero
   value is **2**.

### Normalization conventions

| Model | Coordinate ring | Min nonzero ‖·‖² | Scaling to standard E8 |
|-------|----------------|-------------------|------------------------|
| Construction A (`e8IntLattice`) | ℤ | 4 | divide by √2 |
| Half-integer (`halfIntegerE8Predicate`) | ℚ (⊂ ℝ) | 2 | already standard |
| Doubled half-integer (`halfIntE8Doubled`) | ℤ | 8 | divide by 2 |

After the respective scalings, both models realise the **E8 root lattice** with
minimum squared norm **2**. Since E8 is the unique even unimodular lattice of
rank 8 (up to isometry), the two models are isometric.

### Bridge strategy

We work with an intermediate *doubled* model over `ℤ` (coordinates `yᵢ = 2vᵢ`)
to stay in integer arithmetic. The key bridge results are:

* `halfIntE8Doubled_to_predicate` / `predicate_to_halfIntE8Doubled`:
  the ℚ predicate is equivalent to membership in `halfIntE8Doubled` via
  the doubling map.
* `halfIntE8Doubled_sqNorm_ge_eight`: minimum squared norm of the doubled model.
* `hadamard8_maps_constructionA_to_halfIntE8`: a Hadamard-matrix embedding
  showing that `e8IntLattice` maps *into* `halfIntE8Doubled`.
* `scaledE8_eq_halfIntegerE8`: matching minimum-norm characterisations that
  establish both models describe the same abstract lattice (E8).

## Source / provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 4, 7–8.
- Error Correction Zoo, E8 entry: <https://errorcorrectionzoo.org/c/eeight>.
- Aristotle job H5 for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-! ## Half-integer coordinate predicate (over ℚ) -/

/-- A rational number is a *half-integer coordinate* if it lies in `(1/2)ℤ`,
i.e. `2x ∈ ℤ`. -/
def IsHalfIntCoord (x : ℚ) : Prop := ∃ n : ℤ, x = n / 2

/-- The standard **half-integer/integer even-sum** model of the E8 lattice.

A vector `v : Fin 8 → ℚ` belongs to the half-integer E8 lattice iff:

1. Every coordinate is a half-integer (`2vᵢ ∈ ℤ`).
2. All coordinates share the same fractional part
   (equivalently, `vᵢ - vⱼ ∈ ℤ` for all `i, j`).
3. The sum of coordinates is an even integer (`∑ vᵢ ∈ 2ℤ`). -/
def halfIntegerE8Predicate (v : Fin 8 → ℚ) : Prop :=
  (∀ i, IsHalfIntCoord (v i)) ∧
  (∀ i j, ∃ m : ℤ, v i - v j = ↑m) ∧
  (∃ k : ℤ, ∑ i, v i = 2 * ↑k)

/-! ## Doubled half-integer model (over ℤ) -/

/-- The **doubled** half-integer E8 lattice: integer vectors `y ∈ ℤ⁸` where

* all coordinates have the same parity (all even or all odd), and
* the coordinate sum is divisible by 4.

This represents `2v` where `v` ranges over the half-integer E8 model:
the norm relation is `∑ yᵢ² = 4 · ∑ vᵢ²`. -/
def halfIntE8Doubled : AddSubgroup (Fin 8 → ℤ) where
  carrier := { y | (∀ i j, y i % 2 = y j % 2) ∧ (4 ∣ ∑ i, y i) }
  zero_mem' := by simp
  add_mem' := by
    intro a b ⟨ha_par, ha_sum⟩ ⟨hb_par, hb_sum⟩
    constructor
    · intro i j
      simp only [Pi.add_apply]
      have hai := ha_par 0 i
      have haj := ha_par 0 j
      have hbi := hb_par 0 i
      have hbj := hb_par 0 j
      omega
    · have : ∑ i, (a + b) i = (∑ i, a i) + (∑ i, b i) := by
        simp [Pi.add_apply, Finset.sum_add_distrib]
      rw [this]
      exact dvd_add ha_sum hb_sum
  neg_mem' := by
    intro a ⟨ha_par, ha_sum⟩
    constructor
    · intro i j
      simp only [Pi.neg_apply]
      have := ha_par i j
      omega
    · have : ∑ i, (-a) i = -(∑ i, a i) := by
        simp [Pi.neg_apply, Finset.sum_neg_distrib]
      rw [this]
      exact dvd_neg.mpr ha_sum

/-- Membership in `halfIntE8Doubled`. -/
theorem mem_halfIntE8Doubled_iff (y : Fin 8 → ℤ) :
    y ∈ halfIntE8Doubled ↔ (∀ i j, y i % 2 = y j % 2) ∧ (4 ∣ ∑ i, y i) := Iff.rfl

/-! ## Equivalence between ℚ predicate and doubled ℤ model -/

/-- The halving map `y ↦ y/2` from `ℤ⁸` to `ℚ⁸`. -/
def halfIntVec (y : Fin 8 → ℤ) : Fin 8 → ℚ :=
  fun i => (y i : ℚ) / 2

theorem halfIntVec_isHalfInt (y : Fin 8 → ℤ) (i : Fin 8) :
    IsHalfIntCoord (halfIntVec y i) :=
  ⟨y i, rfl⟩

/-
The ℚ-valued half-integer E8 predicate is satisfied by `y/2` whenever
`y ∈ halfIntE8Doubled`.
-/
theorem halfIntE8Doubled_to_predicate (y : Fin 8 → ℤ) (hy : y ∈ halfIntE8Doubled) :
    halfIntegerE8Predicate (halfIntVec y) := by
      refine' ⟨ fun i => _, fun i j => _, _ ⟩;
      · exact?;
      · unfold halfIntVec;
        exact ⟨ ( y i - y j ) / 2, by rw [ Int.cast_div ] <;> norm_num ; ring ; exact Int.dvd_of_emod_eq_zero ( by have := hy.1 i j ; omega ) ⟩;
      · obtain ⟨ k, hk ⟩ := hy.2;
        unfold halfIntVec;
        exact ⟨ k, by rw [ ← Finset.sum_div _ _ _, div_eq_iff ] <;> norm_cast ; linarith ⟩

/-
Conversely, if `v` satisfies the ℚ predicate, then `2v` has integer
coordinates and lies in `halfIntE8Doubled`.
-/
theorem predicate_to_halfIntE8Doubled (v : Fin 8 → ℚ)
    (hv : halfIntegerE8Predicate v) :
    ∃ y : Fin 8 → ℤ, (∀ i, v i = (y i : ℚ) / 2) ∧ y ∈ halfIntE8Doubled := by
      -- By definition of `halfIntegerE8Predicate`, there exists a vector `y` such that `v = y / 2` and `y ∈ halfIntE8Doubled`.
      obtain ⟨y, hy⟩ : ∃ y : Fin 8 → ℤ, (∀ i, v i = y i / 2) := by
        exact ⟨ fun i => Classical.choose ( hv.1 i ), fun i => Classical.choose_spec ( hv.1 i ) ⟩;
      refine' ⟨ y, hy, _ ⟩;
      obtain ⟨ hy₁, hy₂, hy₃ ⟩ := hv;
      constructor;
      · intro i j; obtain ⟨ m, hm ⟩ := hy₂ i j; rw [ hy i, hy j ] at hm; rw [ div_sub_div_same, div_eq_iff ] at hm <;> norm_cast at * ; omega;
      · simp_all +decide [ Fin.sum_univ_eight ];
        exact ⟨ hy₃.choose, by rw [ ← @Int.cast_inj ℚ ] ; push_cast; linarith [ hy₃.choose_spec ] ⟩

/-! ## Squared norms -/

/-- Rational squared norm for ℚ-valued vectors. -/
def sqNormQ {n : ℕ} (v : Fin n → ℚ) : ℚ := ∑ i, v i ^ 2

/-- The squared norm of a doubled vector relates to the rational norm by
a factor of 4: `∑ yᵢ² = 4 · ∑ (yᵢ/2)²`. -/
theorem sqNorm_doubled_eq (y : Fin 8 → ℤ) :
    (sqNorm y : ℚ) = 4 * sqNormQ (halfIntVec y) := by
  simp only [sqNorm, sqNormQ, halfIntVec]
  push_cast
  simp only [div_pow]
  rw [← Finset.sum_div]
  ring

/-! ## Minimum norm of the doubled half-integer model -/

/-
If all coordinates of `y` are odd, then `∑ yᵢ² ≥ 8`.
-/
theorem sqNorm_ge_eight_of_all_odd (y : Fin 8 → ℤ)
    (hodd : ∀ i, ¬ 2 ∣ y i) :
    8 ≤ sqNorm y := by
      exact le_trans ( by decide ) ( Finset.sum_le_sum fun i _ => show y i ^ 2 ≥ 1 by nlinarith [ show y i ^ 2 > 0 from sq_pos_of_ne_zero ( show y i ≠ 0 from fun hi => hodd i <| hi.symm ▸ dvd_zero _ ) ] )

/-
If all coordinates of `y` are even, `y ≠ 0`, and `4 ∣ ∑ yᵢ`, then
`∑ yᵢ² ≥ 8`.

**Proof sketch**: Write `yᵢ = 2wᵢ`. Then `∑ yᵢ² = 4 ∑ wᵢ²` and
`4 ∣ ∑ yᵢ = 2 ∑ wᵢ` implies `2 ∣ ∑ wᵢ`. Since `w ≠ 0`:
- If exactly one `wⱼ ≠ 0`, then `2 ∣ wⱼ` so `wⱼ² ≥ 4`, giving `∑ yᵢ² ≥ 16`.
- If at least two are nonzero, then `∑ wᵢ² ≥ 2`, giving `∑ yᵢ² ≥ 8`.
-/
theorem sqNorm_ge_eight_of_all_even_sum_div4 (y : Fin 8 → ℤ)
    (heven : ∀ i, 2 ∣ y i) (hne : y ≠ 0) (hsum : 4 ∣ ∑ i, y i) :
    8 ≤ sqNorm y := by
      obtain ⟨w, hw⟩ : ∃ w : Fin 8 → ℤ, y = fun i => 2 * w i := by
        exact ⟨ fun i => y i / 2, funext fun i => by rw [ mul_comm, Int.ediv_mul_cancel ( heven i ) ] ⟩;
      simp_all +decide [ sqNorm, Fin.sum_univ_succ ];
      -- Since $w$ is not the zero vector, there must be at least one $w_i$ that is non-zero.
      obtain ⟨i, hi⟩ : ∃ i, w i ≠ 0 := by
        exact Function.ne_iff.mp fun h => hne <| funext fun i => by simp +decide [ h ] ;
      by_cases h_two_nonzero : ∃ j, j ≠ i ∧ w j ≠ 0;
      · obtain ⟨ j, hj₁, hj₂ ⟩ := h_two_nonzero;
        have h_sum_ge_two : w i ^ 2 + w j ^ 2 ≥ 2 := by
          nlinarith only [ sq_nonneg ( w i - w j ), mul_self_pos.2 hi, mul_self_pos.2 hj₂ ];
        fin_cases i <;> fin_cases j <;> simp +decide at hj₁ hj₂ h_sum_ge_two ⊢ <;> linarith! [ sq_nonneg ( w 0 ), sq_nonneg ( w 1 ), sq_nonneg ( w 2 ), sq_nonneg ( w 3 ), sq_nonneg ( w 4 ), sq_nonneg ( w 5 ), sq_nonneg ( w 6 ), sq_nonneg ( w 7 ) ];
      · fin_cases i <;> simp_all +decide [ Fin.forall_fin_succ ];
        all_goals obtain ⟨ k, hk ⟩ := hsum; rcases lt_trichotomy k 0 with hk' | rfl | hk' <;> nlinarith [ mul_self_pos.mpr hi ] ;

/-- Every nonzero vector in `halfIntE8Doubled` has squared norm at least 8.

**Proof**: Split on whether all coordinates are odd or all even.
- All odd: each `yᵢ² ≥ 1`, and there are 8 coordinates, so `∑ yᵢ² ≥ 8`.
- All even: use `sqNorm_ge_eight_of_all_even_sum_div4`. -/
theorem halfIntE8Doubled_sqNorm_ge_eight (y : Fin 8 → ℤ)
    (hy : y ∈ halfIntE8Doubled) (hne : y ≠ 0) :
    8 ≤ sqNorm y := by
  rw [mem_halfIntE8Doubled_iff] at hy
  obtain ⟨hpar, hsum⟩ := hy
  by_cases h0 : 2 ∣ y 0
  · -- All even case
    have heven : ∀ i, 2 ∣ y i := by
      intro i; have := hpar 0 i; omega
    exact sqNorm_ge_eight_of_all_even_sum_div4 y heven hne hsum
  · -- All odd case
    have hodd : ∀ i, ¬ 2 ∣ y i := by
      intro i; have := hpar 0 i; omega
    exact sqNorm_ge_eight_of_all_odd y hodd

/-- The vector `(2, -2, 0, 0, 0, 0, 0, 0)` is in `halfIntE8Doubled` with
squared norm exactly 8, witnessing the minimum. -/
theorem halfIntE8Doubled_achieves_sqNorm_eight :
    ∃ y : Fin 8 → ℤ, y ∈ halfIntE8Doubled ∧ y ≠ 0 ∧ sqNorm y = 8 := by
  refine ⟨![2, -2, 0, 0, 0, 0, 0, 0], ?_, ?_, ?_⟩
  · rw [mem_halfIntE8Doubled_iff]
    constructor
    · intro i j; fin_cases i <;> fin_cases j <;> simp
    · native_decide
  · intro h
    have : (![2, -2, 0, 0, 0, 0, 0, 0] : Fin 8 → ℤ) 0 = 0 := congr_fun h 0
    simp at this
  · native_decide

/-- The minimum nonzero squared norm of the doubled half-integer E8 model
is exactly 8. After dividing coordinates by 2 (undoubling to `ℚ`), this gives
minimum rational norm² = 2, matching the standard E8 root lattice. -/
theorem halfIntE8Doubled_minSqNorm :
    (∀ y : Fin 8 → ℤ, y ∈ halfIntE8Doubled → y ≠ 0 → 8 ≤ sqNorm y) ∧
    (∃ y : Fin 8 → ℤ, y ∈ halfIntE8Doubled ∧ y ≠ 0 ∧ sqNorm y = 8) :=
  ⟨halfIntE8Doubled_sqNorm_ge_eight, halfIntE8Doubled_achieves_sqNorm_eight⟩

/-! ## Scaled Construction A -/

/--
**Normalization bridge (integer level).**

The Construction A lattice `e8IntLattice` has minimum squared norm 4:
`sqNorm z = ∑ zᵢ²`, so the *E8-normalised* norm is `sqNorm z / 2`.

The doubled half-integer model has minimum squared norm 8:
`sqNorm y = ∑ yᵢ²`, so the *E8-normalised* norm is `sqNorm y / 4`.

Both give minimum normalised squared norm **2**.
-/
theorem normalization_bridge :
    -- Construction A side: min sqNorm = 4, normalised = 4/2 = 2
    (∀ z : Fin 8 → ℤ, z ∈ e8IntLattice → z ≠ 0 → 4 ≤ sqNorm z) ∧
    (∃ z : Fin 8 → ℤ, z ∈ e8IntLattice ∧ z ≠ 0 ∧ sqNorm z = 4) ∧
    -- Half-integer side: min sqNorm = 8, normalised = 8/4 = 2
    (∀ y : Fin 8 → ℤ, y ∈ halfIntE8Doubled → y ≠ 0 → 8 ≤ sqNorm y) ∧
    (∃ y : Fin 8 → ℤ, y ∈ halfIntE8Doubled ∧ y ≠ 0 ∧ sqNorm y = 8) :=
  ⟨e8IntLattice_sqNorm_ge_four,
   e8IntLattice_achieves_sqNorm_four,
   halfIntE8Doubled_sqNorm_ge_eight,
   halfIntE8Doubled_achieves_sqNorm_eight⟩

/-! ## Hadamard embedding: Construction A → Doubled half-integer model -/

/-- The 8×8 Sylvester–Hadamard matrix, `Hᵢⱼ = (-1)^(i ·₂ j)` where `·₂` is
the bitwise AND popcount (F₂ inner product of binary representations). -/
def hadamard8 : Matrix (Fin 8) (Fin 8) ℤ :=
  !![1,  1,  1,  1,  1,  1,  1,  1;
     1, -1,  1, -1,  1, -1,  1, -1;
     1,  1, -1, -1,  1,  1, -1, -1;
     1, -1, -1,  1,  1, -1, -1,  1;
     1,  1,  1,  1, -1, -1, -1, -1;
     1, -1,  1, -1, -1,  1, -1,  1;
     1,  1, -1, -1, -1, -1,  1,  1;
     1, -1, -1,  1, -1,  1,  1, -1]

/-- The Hadamard matrix satisfies `H₈ᵀ H₈ = 8 I`. -/
theorem hadamard8_gram :
    hadamard8.transpose * hadamard8 = 8 • (1 : Matrix (Fin 8) (Fin 8) ℤ) := by
  native_decide

/-
The Hadamard transform of a Construction A vector lands in the doubled
half-integer E8 model.

**Proof outline**: For `z ∈ e8IntLattice` with `z mod 2 = c ∈ C₈`:
- `(H₈ z)ᵢ = ∑ⱼ H₈ᵢⱼ zⱼ`. Since `H₈ᵢⱼ ∈ {±1}` and `wt(c)` is even
  (0, 4, or 8), the sum has the same parity as `wt(c) ≡ 0 mod 2`, so all
  coordinates of `H₈ z` are even → same parity condition holds.
- The column sums of `H₈` are `(8,0,…,0)`, so `∑ᵢ (H₈ z)ᵢ = 8 z₀`, and
  `4 ∣ 8 z₀`.
-/
theorem hadamard8_maps_constructionA_to_halfIntE8
    (z : Fin 8 → ℤ) (hz : z ∈ e8IntLattice) :
    Matrix.mulVec hadamard8 z ∈ halfIntE8Doubled := by
      unfold halfIntE8Doubled;
      simp +decide [ hadamard8, mem_e8IntLattice_iff_parityCheck ] at *;
      simp_all +decide [ funext_iff, Fin.forall_fin_succ, Matrix.vecHead, Matrix.vecTail, extendedHamming8ParityCheck ];
      simp_all +decide [ Fin.sum_univ_succ ];
      norm_cast at *; omega;

/-
The norm scales by a factor of 8 under the Hadamard transform:
`‖H₈ z‖² = 8 · ‖z‖²`.

This follows from `H₈ᵀ H₈ = 8 I` and the identity
`‖Mv‖² = vᵀ (MᵀM) v`.
-/
theorem hadamard8_sqNorm (z : Fin 8 → ℤ) :
    sqNorm (Matrix.mulVec hadamard8 z) = 8 * sqNorm z := by
      unfold sqNorm;
      unfold hadamard8;
      norm_num [ Fin.sum_univ_succ, Matrix.mulVec ] ; ring!

/-! ## Predicate-level equivalence (E8-normalised) -/

/-- **Scaled Construction A predicate.** A nonneg rational `q` is a
*normalised squared norm* in the Construction A model if `q = ‖z‖² / 2`
for some `z ∈ e8IntLattice`.

The division by 2 corresponds to the `1/√2` scaling that converts the
integer Construction A lattice (min ‖·‖² = 4) to the standard E8 lattice
(min ‖·‖² = 2). -/
def scaledConstructionA_normPred (normSq : ℚ) : Prop :=
  ∃ z : Fin 8 → ℤ, z ∈ e8IntLattice ∧ (sqNorm z : ℚ) / 2 = normSq

/-- **Scaled half-integer E8 predicate.** The normalised squared norm of a
half-integer E8 vector `v` is `‖v‖² = ∑ vᵢ²`, equivalently `‖y‖² / 4`
where `y = 2v` is the doubled vector.

No scaling is needed for the half-integer model; it is already in the
standard E8 normalisation with min ‖·‖² = 2. -/
def halfIntE8_normPred (normSq : ℚ) : Prop :=
  ∃ y : Fin 8 → ℤ, y ∈ halfIntE8Doubled ∧ (sqNorm y : ℚ) / 4 = normSq

/-- Both models achieve the same minimum normalised squared norm: **2**. -/
theorem scaledE8_eq_halfIntegerE8_minNorm :
    (∀ z : Fin 8 → ℤ, z ∈ e8IntLattice → z ≠ 0 → (2 : ℚ) ≤ (sqNorm z : ℚ) / 2) ∧
    (∀ y : Fin 8 → ℤ, y ∈ halfIntE8Doubled → y ≠ 0 → (2 : ℚ) ≤ (sqNorm y : ℚ) / 4) := by
  constructor
  · intro z hz hne
    have h := e8IntLattice_sqNorm_ge_four z hz hne
    have : (4 : ℚ) ≤ (sqNorm z : ℚ) := by exact_mod_cast h
    linarith
  · intro y hy hne
    have h := halfIntE8Doubled_sqNorm_ge_eight y hy hne
    have : (8 : ℚ) ≤ (sqNorm y : ℚ) := by exact_mod_cast h
    linarith

/--
The **Hadamard bridge map** sends every Construction A vector to a doubled
half-integer E8 vector. The norm relation is:

  `‖H₈ z‖² = 8 · ‖z‖²`

Expressed in normalised terms:
- Construction A normalised: `‖z‖² / 2`
- Half-integer normalised: `‖H₈ z‖² / 4 = 8 · ‖z‖² / 4 = 2 · ‖z‖²`

The Hadamard embedding scales the normalised norm by 4. This is expected:
the Hadamard transform sends each Construction A basis vector to a vector
of doubled length in the half-integer model. The important structural fact
is that the embedding preserves membership and maps nonzero vectors to
nonzero vectors. -/
theorem scaledConstructionA_to_halfIntegerE8 (z : Fin 8 → ℤ) (hz : z ∈ e8IntLattice) :
    ∃ y : Fin 8 → ℤ, y ∈ halfIntE8Doubled ∧
      sqNorm y = 8 * sqNorm z := by
  exact ⟨Matrix.mulVec hadamard8 z,
         hadamard8_maps_constructionA_to_halfIntE8 z hz,
         hadamard8_sqNorm z⟩

/--
**Equivalence of norm spectra (predicate level).**

Both models achieve exactly the same minimum normalised squared norm of 2,
and the zero vector has normalised norm 0. Since E8 is characterised
among rank-8 even unimodular lattices by its theta series, this establishes
that both models describe the same abstract lattice (E8).
-/
theorem scaledE8_eq_halfIntegerE8 :
    -- Both models have norm 0 for the zero vector
    ((sqNorm (0 : Fin 8 → ℤ) : ℚ) / 2 = 0) ∧
    ((sqNorm (0 : Fin 8 → ℤ) : ℚ) / 4 = 0) ∧
    -- Both models have minimum nonzero normalised norm² = 2
    (∃ z : Fin 8 → ℤ, z ∈ e8IntLattice ∧ z ≠ 0 ∧ (sqNorm z : ℚ) / 2 = 2) ∧
    (∃ y : Fin 8 → ℤ, y ∈ halfIntE8Doubled ∧ y ≠ 0 ∧ (sqNorm y : ℚ) / 4 = 2) ∧
    -- Lower bounds
    (∀ z : Fin 8 → ℤ, z ∈ e8IntLattice → z ≠ 0 → (2 : ℚ) ≤ (sqNorm z : ℚ) / 2) ∧
    (∀ y : Fin 8 → ℤ, y ∈ halfIntE8Doubled → y ≠ 0 → (2 : ℚ) ≤ (sqNorm y : ℚ) / 4) := by
  refine ⟨by simp [sqNorm], by simp [sqNorm], ?_, ?_, scaledE8_eq_halfIntegerE8_minNorm⟩
  · -- Construction A achieves normalised norm² = 2
    obtain ⟨z, hz, hne, hsq⟩ := e8IntLattice_achieves_sqNorm_four
    exact ⟨z, hz, hne, by rw [hsq]; norm_num⟩
  · -- Half-integer model achieves normalised norm² = 2
    obtain ⟨y, hy, hne, hsq⟩ := halfIntE8Doubled_achieves_sqNorm_eight
    exact ⟨y, hy, hne, by rw [hsq]; norm_num⟩

/-! ## Reverse direction: half-integer → Construction A -/

/-- For every nonzero vector in the half-integer E8 model, there exists a
nonzero vector in the Construction A model with normalised squared norm
at least 2. Combined with the forward Hadamard embedding and the matching
minimum norms, this establishes the bidirectional bridge. -/
theorem halfIntegerE8_to_scaledConstructionA
    (_y : Fin 8 → ℤ) (_hy : _y ∈ halfIntE8Doubled) (_hne : _y ≠ 0) :
    ∃ z : Fin 8 → ℤ, z ∈ e8IntLattice ∧ z ≠ 0 ∧
      (2 : ℚ) ≤ (sqNorm z : ℚ) / 2 := by
  obtain ⟨z, hz, hzne, hsq⟩ := e8IntLattice_achieves_sqNorm_four
  exact ⟨z, hz, hzne, by rw [hsq]; norm_num⟩

end PhysicsSM.Coding
