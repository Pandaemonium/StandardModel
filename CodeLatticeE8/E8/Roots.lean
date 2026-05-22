import Mathlib.Tactic

/-!
# The E8 root list in doubled integer coordinates

This module defines the 240-element E8 root system in a convenient integer
coordinate model, and proves that the semantic root predicate exactly
characterises the explicit list.

## Coordinate conventions

Throughout this module, **doubled coordinates** are used.  A vector
`v : Fin 8 → ℤ` represents the actual lattice vector `v / 2 ∈ ℝ⁸`.

Under this convention:

- The actual E8 root squared norm is `2`.  In doubled coordinates the
  squared norm `∑ i, (v i)^2` equals `8`.
- The actual inner product is an integer for any two roots, lying in
  `{-2, -1, 0, 1, 2}`.  In doubled coordinates the inner product `∑ i, v i * w i`
  lies in `{-8, -4, 0, 4, 8}`.

The two root families are:

- **Type 1** (112 roots): exactly two coordinates equal to `±2`, the rest `0`.
  In undoubled coordinates these are `±eᵢ ± eⱼ` for `i < j`.

- **Type 2** (128 roots): all eight coordinates equal to `±1`, with the
  further condition that the number of coordinates equal to `-1` is even.
  In undoubled coordinates these are the half-integer vectors
  `(±½, ±½, …, ±½)` with an even number of minus signs.

## Semantic characterisation

The predicate `IsE8Root v` captures exactly these conditions algebraically:
1. `∑ (v i)^2 = 8` (doubled squared norm);
2. all coordinates share the same parity (all even or all odd);
3. the coordinate sum is divisible by 4.

The theorem `mem_rootList_iff_isE8Root` proves that `v ∈ rootList ↔ IsE8Root v`.

## Proof methodology

The forward direction (`rootList_all_isE8Root`) is proved by **structural
algebraic reasoning**: for type-1 roots, two squares of `±2` contribute `4+4=8`
to the norm, all coordinates are even, and the sum `±2 ± 2 ∈ {−4, 0, 4}` is
divisible by 4.  For type-2 roots, eight squares of `±1` sum to 8, all
coordinates are odd, and the sum `8 − 2k` (with `k` even) is divisible by 4.

The reverse direction (`rootList_complete`) uses a **classification argument**:
the coordinate bound `|v i| ≤ 2` and parity split into all-even / all-odd
forces the two root families, and explicit list membership follows from the
comprehension structure.

The length and no-duplicate theorems use `decide`, so they are kernel-verified
finite reductions rather than compiler-trusted native evaluation.

## Sources

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 4–8.
- Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002) 145–205, §4.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.E8.Roots

/-! ## Quadratic form in doubled coordinates -/

/-- The doubled squared norm: `∑ i, (v i)^2`. -/
def normSq (v : Fin 8 → ℤ) : ℤ := ∑ i : Fin 8, v i ^ 2

/-- The doubled inner product: `∑ i, v i * w i`. -/
def dot (v w : Fin 8 → ℤ) : ℤ := ∑ i : Fin 8, v i * w i

theorem dot_self (v : Fin 8 → ℤ) : dot v v = normSq v := by
  simp [dot, normSq, sq]

theorem normSq_nonneg (v : Fin 8 → ℤ) : 0 ≤ normSq v :=
  Finset.sum_nonneg fun _ _ => sq_nonneg _

/-! ## The E8 root predicate -/

/-- Semantic predicate for an E8 root in doubled integer coordinates.

A vector `v : Fin 8 → ℤ` is an E8 root (doubled) when:

1. Its doubled squared norm is `8` (actual squared norm `2`).
2. All coordinates have the same parity: all even, or all odd.
3. The coordinate sum is divisible by 4. -/
def IsE8Root (v : Fin 8 → ℤ) : Prop :=
  normSq v = 8 ∧
  ((∀ i : Fin 8, v i % 2 = 0) ∨ (∀ i : Fin 8, v i % 2 = 1)) ∧
  (∑ i : Fin 8, v i) % 4 = 0

instance : DecidablePred IsE8Root := fun v => by
  unfold IsE8Root; exact inferInstance

/-! ## Coordinate bound -/

/-- Any E8 root `v` (in doubled coordinates) satisfies `|v i| ≤ 2` for every
coordinate `i`. -/
theorem coordinate_abs_le_two_of_normSq8 {v : Fin 8 → ℤ}
    (hv : normSq v = 8) (i : Fin 8) : |v i| ≤ 2 := by
  have hsingle : v i ^ 2 ≤ normSq v :=
    Finset.single_le_sum (fun j _ => sq_nonneg (v j)) (Finset.mem_univ i)
  have h8 : v i ^ 2 ≤ 8 := hsingle.trans hv.le
  nlinarith [sq_abs (v i), sq_nonneg (v i)]

/-! ## Explicit root enumeration -/

/-- The 112 type-1 roots in doubled coordinates. -/
def type1Roots : List (Fin 8 → ℤ) :=
  do
    let i ← List.finRange 8
    let j ← List.finRange 8
    guard (i < j)
    let si ← [(2 : ℤ), -2]
    let sj ← [(2 : ℤ), -2]
    return fun k : Fin 8 => if k = i then si else if k = j then sj else 0

/-- The 128 type-2 roots in doubled coordinates. -/
def type2Roots : List (Fin 8 → ℤ) :=
  do
    let n ← List.finRange 256
    guard (((List.finRange 8).countP fun i => n.val.testBit i.val) % 2 == 0)
    return fun i : Fin 8 => if n.val.testBit i.val then (-1 : ℤ) else 1

/-- The complete list of 240 E8 roots in doubled coordinates. -/
def rootList : List (Fin 8 → ℤ) := type1Roots ++ type2Roots

/-! ## Structural algebra helpers -/

/-
When `i ≠ j` in `Fin n`, a function that is `a` at `i`, `b` at `j`, and `0`
elsewhere sums to `a + b`.
-/
private theorem sum_ite_pair {n : ℕ} {i j : Fin n} (hij : i ≠ j) (a b : ℤ) :
    ∑ k : Fin n, (if k = i then a else if k = j then b else (0 : ℤ)) = a + b := by
  simp +decide [ Finset.sum_ite, Finset.filter_eq', Finset.filter_ne', * ];
  aesop

/-
When `i ≠ j` in `Fin n`, sum of squares of the same indicator equals `a² + b²`.
-/
private theorem sum_sq_ite_pair {n : ℕ} {i j : Fin n} (hij : i ≠ j) (a b : ℤ) :
    ∑ k : Fin n, (if k = i then a else if k = j then b else (0 : ℤ)) ^ 2 =
    a ^ 2 + b ^ 2 := by
  rw [ Finset.sum_eq_add ( i ) ( j ) ] <;> aesop

/-
For a `{+1, -1}`-valued function on `Fin 8`, the sum of squares is 8.
-/
private theorem sum_sq_pm1 {v : Fin 8 → ℤ} (hv : ∀ i, v i = 1 ∨ v i = -1) :
    ∑ i : Fin 8, v i ^ 2 = 8 := by
  exact Eq.symm ( by rw [ Finset.sum_congr rfl fun i hi => by rcases hv i with ( H | H ) <;> rw [ H ] ; norm_num ] ; norm_cast )

/-
For a `{+1, -1}`-valued function on `Fin 8`, the sum is `8 − 2 * #(−1 entries)`.
-/
private theorem sum_pm1_eq {v : Fin 8 → ℤ}
    (hv : ∀ i, v i = 1 ∨ v i = -1) :
    ∑ i : Fin 8, v i =
    8 - 2 * ((Finset.univ.filter fun i : Fin 8 => v i = -1).card : ℤ) := by
  convert Finset.sum_congr rfl fun i _ => show v i = 1 - 2 * ( if v i = -1 then 1 else 0 ) by rcases hv i with ( H | H ) <;> norm_num [ H ] using 1 ; simp +decide [ Finset.sum_ite ] ; ring;

/-! ## Type-1 algebraic verification -/

/-- **Structural**: any type-1 form vector satisfies `IsE8Root`. -/
private theorem isE8Root_type1_form {i j : Fin 8} (hij : i < j)
    {si sj : ℤ} (hsi : si = 2 ∨ si = -2) (hsj : sj = 2 ∨ sj = -2) :
    IsE8Root (fun k => if k = i then si else if k = j then sj else 0) := by
  have hne : i ≠ j := Fin.ne_of_lt hij
  refine ⟨?_, ?_, ?_⟩
  · -- normSq = si² + sj² = 4 + 4 = 8
    change ∑ k : Fin 8, (if k = i then si else if k = j then sj else (0 : ℤ)) ^ 2 = 8
    rw [sum_sq_ite_pair hne]
    rcases hsi with rfl | rfl <;> rcases hsj with rfl | rfl <;> norm_num
  · -- All coordinates are even
    left; intro k; simp only
    split_ifs with h1 h2
    · rcases hsi with rfl | rfl <;> omega
    · rcases hsj with rfl | rfl <;> omega
    · omega
  · -- Sum = si + sj, divisible by 4
    rw [sum_ite_pair hne]
    rcases hsi with rfl | rfl <;> rcases hsj with rfl | rfl <;> omega

/-! ## Type-2 algebraic verification -/

/-- **Structural**: any `{±1}`-valued vector with even count of `−1` entries
satisfies `IsE8Root`. -/
private theorem isE8Root_type2_form {v : Fin 8 → ℤ}
    (hpm : ∀ i, v i = 1 ∨ v i = -1)
    (heven : (Finset.univ.filter fun i : Fin 8 => v i = -1).card % 2 = 0) :
    IsE8Root v := by
  refine ⟨?_, ?_, ?_⟩
  · exact sum_sq_pm1 hpm
  · right; intro k; rcases hpm k with h | h <;> simp [h]
  · rw [sum_pm1_eq hpm]
    set c := (Finset.univ.filter fun i : Fin 8 => v i = -1).card with hc_def
    have hle : c ≤ 8 := by
      calc c ≤ Finset.univ.card := Finset.card_filter_le _ _
        _ = 8 := by decide
    obtain ⟨m, hm⟩ := Nat.even_iff.mpr heven
    rw [hm]; push_cast; omega

/-! ## Predicate satisfaction — structural proof -/

/-- Relates `countP` on `List.finRange` to `Finset.card` of a filter. -/
private theorem countP_finRange_eq_card (n : ℕ) (p : Fin n → Bool) :
    (List.finRange n).countP p =
    (Finset.univ.filter (fun i : Fin n => p i = true)).card := by
  rw [List.countP_eq_length_filter,
    show (List.filter p (List.finRange n)).length =
      (List.filter p (List.finRange n)).toFinset.card from
      (List.toFinset_card_of_nodup (List.Nodup.filter _ (List.nodup_finRange n))).symm,
    List.toFinset_filter, List.toFinset_finRange]

/-- Every type-1 root satisfies `IsE8Root`.

The proof unfolds the list comprehension through `flatMap`, extracts the
parameters `(i, j, si, sj)`, and delegates to `isE8Root_type1_form`. -/
private theorem type1Roots_forall_isE8Root : ∀ v ∈ type1Roots, IsE8Root v := by
  intro v hv
  change v ∈ (List.finRange 8).flatMap (fun i =>
    (List.finRange 8).flatMap (fun j =>
      (guard (i < j) : List Unit).flatMap (fun _ =>
        [(2 : ℤ), -2].flatMap (fun si =>
          [(2 : ℤ), -2].flatMap (fun sj =>
            [fun k : Fin 8 => if k = i then si else if k = j then sj else 0]))))) at hv
  rw [List.mem_flatMap] at hv; obtain ⟨i, _, hv⟩ := hv
  rw [List.mem_flatMap] at hv; obtain ⟨j, _, hv⟩ := hv
  by_cases hij : i < j
  · simp only [guard, if_pos hij, pure, List.flatMap_cons, List.flatMap_nil,
      List.append_nil, List.mem_append, List.mem_cons, List.mem_nil_iff, or_false] at hv
    rcases hv with ((rfl | rfl) | (rfl | rfl)) <;>
      exact isE8Root_type1_form hij (by tauto) (by tauto)
  · simp only [guard, if_neg hij, failure, List.flatMap_nil, List.not_mem_nil] at hv

/-- Every type-2 root satisfies `IsE8Root`.

The proof unfolds the list comprehension, extracts the bitmask `n` and its
guard condition, and delegates to `isE8Root_type2_form`. -/
private theorem type2Roots_forall_isE8Root : ∀ v ∈ type2Roots, IsE8Root v := by
  intro v hv
  change v ∈ (List.finRange 256).flatMap (fun n =>
    (guard (((List.finRange 8).countP fun i => n.val.testBit i.val) % 2 == 0) :
      List Unit).flatMap
      (fun _ => [fun i : Fin 8 =>
        if n.val.testBit i.val then (-1 : ℤ) else 1])) at hv
  rw [List.mem_flatMap] at hv; obtain ⟨n, _, hv⟩ := hv
  set cond := ((List.finRange 8).countP fun i => n.val.testBit i.val) % 2 == 0 with hcond_def
  by_cases hc : cond
  · simp only [guard, if_pos hc, pure, List.flatMap_cons, List.flatMap_nil,
      List.append_nil, List.mem_cons, List.mem_nil_iff, or_false] at hv
    subst hv
    apply isE8Root_type2_form
    · -- Each coordinate is ±1
      intro i; by_cases h : n.val.testBit i.val <;> simp [h]
    · -- Even count of −1 entries
      have hbool : cond = true := hc
      simp only [hcond_def, beq_iff_eq] at hbool
      rw [countP_finRange_eq_card] at hbool
      -- Need: filter (v = -1) matches filter (testBit = true)
      suffices h : (Finset.univ.filter fun i : Fin 8 =>
          (if n.val.testBit i.val then (-1 : ℤ) else 1) = -1) =
        Finset.univ.filter (fun i : Fin 8 => n.val.testBit i.val = true) by
        rw [h]; exact hbool
      congr 1; ext i
      by_cases h : n.val.testBit i.val <;> simp [h]
  · simp only [guard, if_neg hc, failure, List.flatMap_nil, List.not_mem_nil] at hv

/-- **Every element of `rootList` satisfies `IsE8Root`.**

Proved by structural algebraic reasoning about the two root families, without
compiler-trusted native evaluation. -/
theorem rootList_all_isE8Root :
    rootList.Forall (fun v => IsE8Root v) := by
  rw [List.forall_iff_forall_mem]
  intro v hv
  simp only [rootList, List.mem_append] at hv
  exact hv.elim (type1Roots_forall_isE8Root v) (type2Roots_forall_isE8Root v)

/-- Every element of `rootList` is an E8 root. -/
theorem isE8Root_of_mem {v : Fin 8 → ℤ} (hv : v ∈ rootList) : IsE8Root v :=
  List.forall_iff_forall_mem.mp rootList_all_isE8Root v hv

/-- Every element of `rootList` has `normSq = 8`. -/
theorem normSq_eq_eight_of_mem {v : Fin 8 → ℤ} (hv : v ∈ rootList) :
    normSq v = 8 :=
  (isE8Root_of_mem hv).1

/-! ## List cardinalities and no-duplicate — kernel `decide` -/

set_option maxRecDepth 2048 in
set_option maxHeartbeats 800000 in
-- Kernel-verified finite computation.
theorem type1Roots_length : type1Roots.length = 112 := by decide

set_option maxRecDepth 2048 in
set_option maxHeartbeats 8000000 in
-- Kernel-verified finite computation.
theorem type2Roots_length : type2Roots.length = 128 := by decide

set_option maxRecDepth 2048 in
set_option maxHeartbeats 12000000 in
-- Kernel-verified finite computation.
theorem rootList_length : rootList.length = 240 := by decide

set_option maxRecDepth 2048 in
set_option maxHeartbeats 80000000 in
-- Kernel-verified finite computation.
theorem rootList_nodup : rootList.Nodup := by decide

/-! ## Completeness — structural classification -/

private theorem even_bounded_values {z : ℤ} (hz : |z| ≤ 2) (hev : z % 2 = 0) :
    z = -2 ∨ z = 0 ∨ z = 2 := by
  rcases abs_le.mp hz with ⟨h1, h2⟩; omega

private theorem odd_bounded_values {z : ℤ} (hz : |z| ≤ 2) (hod : z % 2 = 1) :
    z = -1 ∨ z = 1 := by
  rcases abs_le.mp hz with ⟨h1, h2⟩; omega

/-- Type-1 membership: a type-1 form vector belongs to `type1Roots`. -/
private theorem mem_type1Roots_of_form {i j : Fin 8} (hij : i < j)
    {si sj : ℤ} (hsi : si = 2 ∨ si = -2) (hsj : sj = 2 ∨ sj = -2) :
    (fun k => if k = i then si else if k = j then sj else (0 : ℤ)) ∈ type1Roots := by
  change (fun k => if k = i then si else if k = j then sj else (0 : ℤ)) ∈
    (List.finRange 8).flatMap (fun i' =>
      (List.finRange 8).flatMap (fun j' =>
        (guard (i' < j') : List Unit).flatMap (fun _ =>
          [(2 : ℤ), -2].flatMap (fun si' =>
            [(2 : ℤ), -2].flatMap (fun sj' =>
              [fun k : Fin 8 => if k = i' then si' else if k = j' then sj' else 0])))))
  rw [List.mem_flatMap]
  exact ⟨i, List.mem_finRange i, by
    rw [List.mem_flatMap]
    exact ⟨j, List.mem_finRange j, by
      simp only [guard, if_pos hij, pure, List.flatMap_cons, List.flatMap_nil,
        List.append_nil, List.mem_append, List.mem_cons, List.mem_nil_iff, or_false]
      rcases hsi with rfl | rfl <;> rcases hsj with rfl | rfl <;> simp⟩⟩

/-! ### Binary encoding for type-2 completeness -/

/-- Binary encoding of a boolean function on `Fin 8`. -/
private def boolsToNat (b : Fin 8 → Bool) : ℕ :=
  ∑ i : Fin 8, if b i then 2 ^ i.val else 0

private theorem boolsToNat_lt (b : Fin 8 → Bool) : boolsToNat b < 256 := by
  unfold boolsToNat
  calc ∑ i : Fin 8, (if b i then 2 ^ i.val else 0 : ℕ)
      ≤ ∑ i : Fin 8, (2 ^ i.val : ℕ) := by
        apply Finset.sum_le_sum; intro i _; split <;> [exact le_refl _; exact Nat.zero_le _]
    _ = 255 := by decide
    _ < 256 := by omega

set_option maxRecDepth 2048 in
set_option maxHeartbeats 40000000 in
-- This finite bit-test expands the `Fin 8 -> Bool` domain; the bound keeps the
-- proof kernel-checked while avoiding compiler-trusted native evaluation.
/-- `testBit` on a sum of distinct powers of 2 is faithful.
Kernel-verified finite computation over `Fin 8 → Bool`. -/
private theorem boolsToNat_testBit (b : Fin 8 → Bool) (k : Fin 8) :
    (boolsToNat b).testBit k.val = b k := by
  decide +revert

/-- Type-2 membership: a `{±1}`-vector with even `−1`-count belongs to `type2Roots`. -/
private theorem mem_type2Roots_of_form {v : Fin 8 → ℤ}
    (hpm : ∀ i, v i = 1 ∨ v i = -1)
    (heven : (Finset.univ.filter fun i : Fin 8 => v i = -1).card % 2 = 0) :
    v ∈ type2Roots := by
  set b : Fin 8 → Bool := fun i => decide (v i = -1) with hb_def
  set n : ℕ := boolsToNat b with hn_def
  have hv_eq : v = fun i : Fin 8 => if n.testBit i.val then (-1 : ℤ) else 1 := by
    ext i
    rw [hn_def, boolsToNat_testBit, hb_def]
    simp only
    rcases hpm i with h | h <;> simp [h]
  have hguard : (((List.finRange 8).countP fun i => n.testBit i.val) % 2 == 0) = true := by
    rw [beq_iff_eq, countP_finRange_eq_card]
    suffices h : (Finset.univ.filter fun i : Fin 8 => n.testBit i.val = true) =
        Finset.univ.filter (fun i : Fin 8 => v i = -1) by
      rw [h]; exact heven
    congr 1; ext i
    rw [hn_def, boolsToNat_testBit, hb_def]
    simp
  change v ∈ (List.finRange 256).flatMap (fun n' =>
    (guard (((List.finRange 8).countP fun i => n'.val.testBit i.val) % 2 == 0) :
      List Unit).flatMap
      (fun _ => [fun i : Fin 8 => if n'.val.testBit i.val then (-1 : ℤ) else 1]))
  rw [List.mem_flatMap]
  have hn_lt : n < 256 := boolsToNat_lt b
  refine ⟨⟨n, hn_lt⟩, List.mem_finRange _, ?_⟩
  simp only [guard, if_pos hguard, pure, List.flatMap_cons, List.flatMap_nil,
    List.append_nil, List.mem_cons, List.mem_nil_iff, or_false]
  exact hv_eq

/-! ### The all-even classification (type 1) -/

/-
In the all-even case with normSq = 8, exactly two coordinates are nonzero and
the vector has type-1 form.
-/
set_option linter.flexible false in
private theorem type1_classification {v : Fin 8 → ℤ}
    (hnorm : normSq v = 8)
    (heven : ∀ i : Fin 8, v i % 2 = 0)
    (hbd : ∀ i : Fin 8, |v i| ≤ 2) :
    ∃ i j : Fin 8, i < j ∧
      (v i = 2 ∨ v i = -2) ∧ (v j = 2 ∨ v j = -2) ∧
      ∀ k, k ≠ i → k ≠ j → v k = 0 := by
  -- Since there are exactly two non-zero coordinates, let's denote their indices by `i` and `j`.
  obtain ⟨i, j, hij, h_nonzero⟩ : ∃ i j : Fin 8, i ≠ j ∧ (v i ≠ 0) ∧ (v j ≠ 0) ∧ ∀ k : Fin 8, k ≠ i ∧ k ≠ j → v k = 0 := by
    have h_two_nonzero : Finset.card (Finset.filter (fun i => v i ≠ 0) Finset.univ) = 2 := by
      have h_two_nonzero : (∑ i, (if v i = 0 then 0 else (v i)^2)) = 8 := by
        exact Eq.trans ( Finset.sum_congr rfl fun _ _ => by aesop ) hnorm;
      have h_two_nonzero : ∀ i, (if v i = 0 then 0 else (v i)^2) = if v i = 0 then 0 else 4 := by
        intro i; specialize heven i; specialize hbd i; rcases abs_le.mp hbd with ⟨ hi₁, hi₂ ⟩ ; interval_cases v i <;> trivial;
      simp_all +decide [ Finset.sum_ite ];
      grind +extAll;
    obtain ⟨ i, j, hij ⟩ := Finset.card_eq_two.mp h_two_nonzero;
    simp_all +decide [Finset.ext_iff];
    exact ⟨i, j, hij.1, Or.inl rfl, Or.inr rfl, fun k hk₁ hk₂ =>
      Classical.not_not.1 fun hk₃ => hk₁ <| by have := hij.2 k; tauto⟩;
  grind +splitImp

/-
The even count of −1 entries follows from the sum being divisible by 4.
-/
private theorem even_neg1_count_of_sum_mod4 {v : Fin 8 → ℤ}
    (hpm : ∀ i, v i = 1 ∨ v i = -1)
    (hsum : (∑ i : Fin 8, v i) % 4 = 0) :
    (Finset.univ.filter fun i : Fin 8 => v i = -1).card % 2 = 0 := by
  -- Let $c$ be the number of $-1$ entries. Then the sum is $8 - 2c$.
  set c := (Finset.univ.filter fun i => v i = -1).card with hc
  have hsum_eq : ∑ i, v i = 8 - 2 * c := by
    convert sum_pm1_eq hpm using 1;
  omega

/-- **Structural completeness**: every `IsE8Root v` appears in `rootList`. -/
theorem rootList_complete {v : Fin 8 → ℤ} (hv : IsE8Root v) : v ∈ rootList := by
  obtain ⟨hnorm, hpar, hsum⟩ := hv
  have hbd := coordinate_abs_le_two_of_normSq8 hnorm
  rcases hpar with heven | hodd
  · -- All even → type 1
    obtain ⟨i, j, hij, hvi, hvj, hrest⟩ := type1_classification hnorm heven hbd
    have hvform : v = fun k => if k = i then v i else if k = j then v j else 0 := by
      funext k
      by_cases hki : k = i
      · subst hki; simp
      · by_cases hkj : k = j
        · subst hkj; simp [hki]
        · simp [hki, hkj, hrest k hki hkj]
    rw [hvform]
    exact List.mem_append_left _ (mem_type1Roots_of_form hij hvi hvj)
  · -- All odd → type 2
    have hpm : ∀ i, v i = 1 ∨ v i = -1 :=
      fun i => (odd_bounded_values (hbd i) (hodd i)).symm
    have hcard_even := even_neg1_count_of_sum_mod4 hpm hsum
    exact List.mem_append_right _ (mem_type2Roots_of_form hpm hcard_even)

/-! ## Bounded completeness (derived) -/

/-- Bounded completeness: derived from the structural `rootList_complete`. -/
theorem rootList_complete_bounded :
    ∀ f : Fin 8 → Fin 5,
      IsE8Root (fun i => (![-2, -1, 0, 1, 2] : Fin 5 → ℤ) (f i)) →
      (fun i => (![-2, -1, 0, 1, 2] : Fin 5 → ℤ) (f i)) ∈ rootList :=
  fun _ h => rootList_complete h

/-! ## Encode-decode (kept for backward compatibility) -/

private def encodeCoordRoot (z : ℤ) : Fin 5 :=
  if z = -2 then 0 else if z = -1 then 1 else if z = 0 then 2
  else if z = 1 then 3 else 4

private abbrev rootCoordVals : Fin 5 → ℤ := ![-2, -1, 0, 1, 2]

private theorem rootCoordVals_encode {z : ℤ} (hz : |z| ≤ 2) :
    rootCoordVals (encodeCoordRoot z) = z := by
  rcases abs_le.mp hz with ⟨h₁, h₂⟩
  interval_cases z <;> rfl

private theorem encode_decode_root {v : Fin 8 → ℤ} (hv : normSq v = 8) :
    (fun i => rootCoordVals (encodeCoordRoot (v i))) = v :=
  funext fun i => rootCoordVals_encode (coordinate_abs_le_two_of_normSq8 hv i)

/-! ## Biconditional -/

/-- **`rootList` exactly characterises `IsE8Root`.** -/
theorem mem_rootList_iff_isE8Root (v : Fin 8 → ℤ) :
    v ∈ rootList ↔ IsE8Root v :=
  ⟨isE8Root_of_mem, rootList_complete⟩

/-! ## Additional root-system properties -/

/-- The pointwise negation of every root is again a root. -/
theorem neg_mem_rootList {v : Fin 8 → ℤ} (hv : v ∈ rootList) :
    (fun i => -v i) ∈ rootList := by
  rw [mem_rootList_iff_isE8Root] at hv ⊢
  obtain ⟨hnorm, hpar, hsum⟩ := hv
  refine ⟨?_, ?_, ?_⟩
  · simp only [normSq, neg_sq]; exact hnorm
  · have neg_mod2 : ∀ a : ℤ, (-a) % 2 = a % 2 := fun a => by omega
    rcases hpar with hall | hall
    · exact Or.inl fun i => by rw [neg_mod2]; exact hall i
    · exact Or.inr fun i => by rw [neg_mod2]; exact hall i
  · have : ∑ i : Fin 8, -v i = -(∑ i : Fin 8, v i) := by
      simp [Finset.sum_neg_distrib]
    rw [this]; omega

/-- The root list has cardinality 240 as a `Finset`. -/
theorem rootListFinset_card :
    rootList.toFinset.card = 240 := by
  rw [List.toFinset_card_of_nodup rootList_nodup, rootList_length]

end CodeLatticeE8.E8.Roots
