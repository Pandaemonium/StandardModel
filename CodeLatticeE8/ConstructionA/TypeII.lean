import CodeLatticeE8.ConstructionA.Even
import CodeLatticeE8.Code.Dual

/-!
# Type II Construction A: self-duality and even norms

This module proves the general Type II Construction A theorem in both
integer and real coordinates:

* **Norm divisibility** (doubly-even codes): every vector in the
  Construction A integer lattice has squared norm divisible by four.
  After the conventional `1 / √2` scaling this gives even real norms.

* **Self-duality** (self-dual codes): the integer-coordinate model of the
  dual of the `1 / √2`-scaled lattice equals the Construction A lattice
  itself, and the analogous real-coordinate identity holds.

Together these properties characterise a **Type II** (even, unimodular)
lattice in the sense of Conway-Sloane.

## Normalization convention

The *unscaled* Construction A lattice lives in `ℤ^n` and is defined in
`CodeLatticeE8.ConstructionA.Basic`.  The squared norm `sqNorm z = ∑ z_i²`
is the raw integer sum of squares.

The *scaled* lattice is `(1 / √2) · Λ` in `ℝ^n`.  Its inner products are
`⟨x, y⟩_scaled = (1/2) ∑ z_i w_i`, so integral pairing in the scaled
lattice is equivalent to `2 ∣ intDot z w` in the integer model.  The
divisibility `4 ∣ sqNorm z` becomes `⟨x, x⟩_scaled ∈ 2ℤ`, i.e.
even norms in the scaled lattice.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.ConstructionA

open CodeLatticeE8.Code

/-! ## Integer dot product and mod-two reduction -/

/-- Integer dot product on coordinate vectors. -/
def intDot {n : Nat} (x y : Fin n → Int) : Int :=
  ∑ i, x i * y i

@[simp]
theorem intDot_zero_left {n : Nat} (y : Fin n → Int) :
    intDot (0 : Fin n → Int) y = 0 := by
  simp [intDot]

@[simp]
theorem intDot_zero_right {n : Nat} (x : Fin n → Int) :
    intDot x (0 : Fin n → Int) = 0 := by
  simp [intDot]

theorem intDot_add_left {n : Nat} (x y z : Fin n → Int) :
    intDot (x + y) z = intDot x z + intDot y z := by
  simp [intDot, add_mul, Finset.sum_add_distrib]

theorem intDot_neg_left {n : Nat} (x y : Fin n → Int) :
    intDot (-x) y = -intDot x y := by
  simp [intDot, Finset.sum_neg_distrib]

/--
Reducing the integer dot product modulo two gives the binary dot product
of the mod-two reductions.
-/
theorem intDot_cast_zmod_two_eq_binaryDot_reduce {n : Nat}
    (x y : Fin n → Int) :
    ((intDot x y : Int) : ZMod 2) =
      binaryDot (reduceModTwo x) (reduceModTwo y) := by
  simp [intDot, binaryDot, reduceModTwo]

/-! ## Lifting binary vectors to `0`/`1` integer vectors -/

private theorem zmod_two_eq_zero_or_one (a : ZMod 2) : a = 0 ∨ a = 1 := by
  fin_cases a <;> simp

/-- The canonical `0`/`1` integer lift of a binary vector. -/
def binaryLift {n : Nat} (v : BinaryVector n) : Fin n → Int :=
  fun i => if v i = 0 then 0 else 1

/-- Reducing the binary lift modulo two recovers the original binary vector. -/
@[simp]
theorem reduceModTwo_binaryLift {n : Nat} (v : BinaryVector n) :
    reduceModTwo (binaryLift v) = v := by
  ext i
  unfold binaryLift reduceModTwo
  by_cases h : v i = 0
  · simp [h]
  · rcases zmod_two_eq_zero_or_one (v i) with h0 | h1
    · exact False.elim (h h0)
    · simp [h1]

/-- The binary lift of a codeword belongs to the Construction A lattice. -/
theorem binaryLift_mem_lattice {n : Nat} (C : BinaryLinearCode n)
    {v : BinaryVector n} (hv : v ∈ C) :
    binaryLift v ∈ lattice C := by
  rw [mem_lattice_iff, reduceModTwo_binaryLift]
  exact hv

/-! ## Integer model of the dual scaled Construction A lattice -/

/--
The integer-coordinate model of the dual of the scaled Construction A lattice.

If the real lattice is `(1 / √2) · lattice C`, then a vector
`(1 / √2) · y` pairs integrally with every lattice vector exactly when
`2 ∣ intDot y z` for every `z ∈ lattice C`.
-/
def scaledDualInt {n : Nat}
    (C : BinaryLinearCode n) : AddSubgroup (Fin n → Int) where
  carrier := { y | ∀ z : Fin n → Int, z ∈ lattice C → 2 ∣ intDot y z }
  zero_mem' := by
    intro z _hz
    simp
  add_mem' := by
    intro x y hx hy z hz
    rw [intDot_add_left]
    exact dvd_add (hx z hz) (hy z hz)
  neg_mem' := by
    intro x hx z hz
    rcases hx z hz with ⟨k, hk⟩
    exact ⟨-k, by rw [intDot_neg_left, hk]; ring⟩

/-- Membership in `scaledDualInt` is the pairwise divisibility condition. -/
theorem mem_scaledDualInt_iff {n : Nat}
    (C : BinaryLinearCode n) (y : Fin n → Int) :
    y ∈ scaledDualInt C ↔
      ∀ z : Fin n → Int, z ∈ lattice C → 2 ∣ intDot y z := Iff.rfl

/-- The Construction A lattice is contained in its scaled dual when `C` is self-dual. -/
theorem lattice_le_scaledDualInt_of_selfDual {n : Nat}
    (C : BinaryLinearCode n) (hC : IsSelfDual C) :
    lattice C ≤ scaledDualInt C := by
  intro y hy
  rw [mem_scaledDualInt_iff]
  intro z hz
  apply (ZMod.intCast_zmod_eq_zero_iff_dvd (intDot y z) 2).mp
  rw [intDot_cast_zmod_two_eq_binaryDot_reduce]
  have hyC : reduceModTwo y ∈ C := (mem_lattice_iff C y).mp hy
  have hzC : reduceModTwo z ∈ C := (mem_lattice_iff C z).mp hz
  have hyDual : reduceModTwo y ∈ dualCode C := by
    unfold IsSelfDual at hC
    rw [hC] at hyC
    exact hyC
  exact (mem_dualCode_iff C (reduceModTwo y)).mp hyDual (reduceModTwo z) hzC

/-- The scaled dual is contained in the Construction A lattice when `C` is self-dual. -/
theorem scaledDualInt_le_lattice_of_selfDual {n : Nat}
    (C : BinaryLinearCode n) (hC : IsSelfDual C) :
    scaledDualInt C ≤ lattice C := by
  intro y hy
  rw [mem_lattice_iff]
  unfold IsSelfDual at hC
  rw [hC]
  rw [mem_dualCode_iff]
  intro w hw
  have hLift : binaryLift w ∈ lattice C :=
    binaryLift_mem_lattice C hw
  have hdiv : 2 ∣ intDot y (binaryLift w) :=
    (mem_scaledDualInt_iff C y).mp hy (binaryLift w) hLift
  have hcast : ((intDot y (binaryLift w) : Int) : ZMod 2) = 0 :=
    (ZMod.intCast_zmod_eq_zero_iff_dvd (intDot y (binaryLift w)) 2).mpr hdiv
  have hdot :
      binaryDot (reduceModTwo y) (reduceModTwo (binaryLift w)) = 0 := by
    simpa [intDot_cast_zmod_two_eq_binaryDot_reduce] using hcast
  simpa using hdot

/--
Integer-coordinate self-duality of the scaled Construction A lattice.

This is the algebraic core of the theorem that a self-dual binary code gives a
unimodular Construction A lattice after the conventional `1 / √2` scaling.
-/
theorem scaledDualInt_eq_lattice_of_selfDual {n : Nat}
    (C : BinaryLinearCode n) (hC : IsSelfDual C) :
    scaledDualInt C = lattice C :=
  le_antisymm
    (scaledDualInt_le_lattice_of_selfDual C hC)
    (lattice_le_scaledDualInt_of_selfDual C hC)

/-! ## Type II bundle in integer coordinates -/

/--
For a doubly-even code, every Construction A vector has squared norm divisible
by four, equivalently `sqNorm z = 4 * k` for some integer `k`.
-/
theorem sqNorm_eq_four_mul_of_doublyEven {n : Nat}
    (C : BinaryLinearCode n) (hC : IsDoublyEven C)
    (z : Fin n → Int) (hz : z ∈ lattice C) :
    ∃ k : Int, sqNorm z = 4 * k := by
  rcases sqNorm_dvd_four_of_doublyEven C hC z hz with ⟨k, hk⟩
  exact ⟨k, hk⟩

/--
The broad Type II Construction A theorem in the integer-coordinate model.

For a Type II (self-dual, doubly-even) binary code `C`:

1. every lattice vector has `sqNorm z = 4k`, so the `1 / √2`-scaled norm is
   even;
2. the integer dual of the scaled lattice equals the lattice itself, giving
   unimodularity.
-/
theorem typeII_integer_package {n : Nat}
    (C : BinaryLinearCode n) (hC : IsTypeII C) :
    (∀ z : Fin n → Int, z ∈ lattice C → ∃ k : Int, sqNorm z = 4 * k) ∧
      scaledDualInt C = lattice C :=
  ⟨fun z hz => sqNorm_eq_four_mul_of_doublyEven C hC.2 z hz,
    scaledDualInt_eq_lattice_of_selfDual C hC.1⟩

/-! ## Real scaled lattice -/

/-- The coordinate map `z ↦ z / √2`, realising the standard scaling. -/
noncomputable def scaledRealLinearMap (n : Nat) :
    (Fin n → Int) →ₗ[Int] (Fin n → Real) where
  toFun z := fun i => (z i : Real) / Real.sqrt 2
  map_add' := by
    intro x y
    ext i
    simp [add_div]
  map_smul' := by
    intro a x
    ext i
    simp [mul_div_assoc]

/-- The real `1 / √2` scaled Construction A lattice as a `ℤ`-submodule. -/
noncomputable def scaledReal {n : Nat}
    (C : BinaryLinearCode n) : Submodule Int (Fin n → Real) :=
  (lattice C).toIntSubmodule.map (scaledRealLinearMap n)

/-- Euclidean coordinate dot product on `ℝ^n`. -/
noncomputable def realDot {n : Nat} (x y : Fin n → Real) : Real :=
  ∑ i, x i * y i

/--
The set-theoretic real dual of the scaled Construction A lattice, stated in
plain coordinates without any particular `ZLattice` dual API.
-/
noncomputable def scaledRealDual {n : Nat}
    (C : BinaryLinearCode n) : Set (Fin n → Real) :=
  { y | ∀ x : Fin n → Real, x ∈ scaledReal C →
      ∃ k : Int, realDot y x = k }

/--
Doubly-even codes give even real scaled Construction A lattices:
`⟨x, x⟩_scaled ∈ 2ℤ` for every lattice vector `x`.
-/
theorem scaledReal_even_of_doublyEven {n : Nat}
    (C : BinaryLinearCode n) (hC : IsDoublyEven C) :
    ∀ x : Fin n → Real, x ∈ scaledReal C →
      ∃ k : Int, realDot x x = (2 * k : Real) := by
  intros x hx
  obtain ⟨z, hz⟩ :
      ∃ z : Fin n → Int, z ∈ lattice C ∧
        x = fun i => (z i : Real) / Real.sqrt 2 := by
    rcases hx with ⟨z, hz, rfl⟩
    exact ⟨z, hz, rfl⟩
  have h_realDot : realDot x x = (∑ i, (z i : Real) ^ 2) / 2 := by
    unfold realDot
    norm_num [hz.2, div_mul_div_comm, Finset.sum_div _ _ _]
    ring_nf
  obtain ⟨k, hk⟩ : ∃ k : Int, (sqNorm z : Real) = 4 * k := by
    have h := sqNorm_eq_four_mul_of_doublyEven C hC z hz.1
    exact ⟨h.choose, mod_cast h.choose_spec⟩
  rw [h_realDot]
  field_simp [hk]
  exact ⟨k, mod_cast hk⟩

/--
Self-dual binary codes give real self-dual scaled Construction A lattices:
the set-theoretic real dual equals the scaled lattice itself.
-/
theorem scaledRealDual_eq_self_of_selfDual {n : Nat}
    (C : BinaryLinearCode n) (hC : IsSelfDual C) :
    scaledRealDual C = (scaledReal C : Set (Fin n → Real)) := by
  apply Set.eq_of_subset_of_subset
  · -- dual ⊆ lattice
    intro y hy
    obtain ⟨z, hz⟩ : ∃ z : Fin n → Int, y = fun i => (z i : Real) / Real.sqrt 2 := by
      have hz : ∀ i, ∃ z_i : Int, y i * Real.sqrt 2 = z_i := by
        intro i
        have := hy (fun j => if j = i then 2 / Real.sqrt 2 else 0) ?_
        · unfold realDot at this
          simp_all +decide
        · refine ⟨twoBasisVec i, ?_, ?_⟩
          · convert twoBasisVec_mem_lattice C i using 1
          · ext j
            simp [scaledRealLinearMap, twoBasisVec]
            split_ifs <;> norm_num [div_eq_iff]
      exact ⟨fun i => Classical.choose (hz i),
        funext fun i => by
          rw [← Classical.choose_spec (hz i),
            mul_div_cancel_right₀ _ (by positivity)]⟩
    have h_dot_int : ∀ w : Fin n → Int, w ∈ lattice C → 2 ∣ intDot z w := by
      intro w hw
      have h_dot :
          realDot y (fun i => (w i : Real) / Real.sqrt 2) = (intDot z w : Real) / 2 := by
        unfold realDot intDot
        simp +decide [hz, Finset.sum_div _ _ _]
        ring_nf
        exact Finset.sum_congr rfl fun _ _ => by
          rw [inv_pow]
          field_simp
          rw [Real.sq_sqrt (show (0 : Real) ≤ 2 by norm_num)]
          ring
      obtain ⟨k, hk⟩ := hy (fun i => (w i : Real) / Real.sqrt 2) (by
        exact ⟨w, hw, rfl⟩)
      exact ⟨k, by
        rw [← @Int.cast_inj Real]
        push_cast
        linarith⟩
    have hz_in_lattice : z ∈ lattice C := by
      convert scaledDualInt_eq_lattice_of_selfDual C hC ▸
        (mem_scaledDualInt_iff C z).2 h_dot_int using 1
    exact hz.symm ▸ ⟨z, hz_in_lattice, rfl⟩
  · -- lattice ⊆ dual
    intro x hx
    obtain ⟨z, hz, rfl⟩ := hx
    rw [scaledRealDual]
    intro y hy
    obtain ⟨w, hw, rfl⟩ := hy
    have h_realDot :
        realDot (scaledRealLinearMap n z)
          (scaledRealLinearMap n w) = (intDot z w : Real) / 2 := by
      unfold realDot intDot scaledRealLinearMap
      norm_num [div_mul_div_comm, Finset.sum_div _ _ _]
    have h_div : 2 ∣ intDot z w :=
      (mem_scaledDualInt_iff C z).mp
        (lattice_le_scaledDualInt_of_selfDual C hC hz) w hw
    obtain ⟨k, hk⟩ := h_div
    refine ⟨k, ?_⟩
    rw [h_realDot, hk]
    norm_num

end CodeLatticeE8.ConstructionA
