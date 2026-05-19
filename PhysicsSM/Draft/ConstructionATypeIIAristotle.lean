import PhysicsSM.Coding.ConstructionALatticeProperties
import PhysicsSM.Coding.HammingSelfDual

/-!
# Generic Type II Construction A scaffolding

This draft module starts the general theorem behind the rank-eight Hamming/E8
case:

* a doubly-even binary code makes the unscaled Construction A norm divisible by
  four;
* a self-dual binary code makes the standard `1 / sqrt 2` scaling self-dual.

The first point is already proved in
`PhysicsSM.Coding.ConstructionALatticeProperties`.  The main contribution here
is the coordinate-level duality theorem
`scaledConstructionADualInt_eq_constructionA_of_selfDual`, which avoids real
analysis and captures the algebraic content of unimodularity.

The final two theorems package these integer-coordinate facts as statements
about the real `1 / sqrt 2` scaled Construction A lattice.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Coding

/-! ## Integer dot product and mod-two reduction -/

/-- Integer dot product on coordinate vectors. -/
def intDot {n : Nat} (x y : Fin n -> Int) : Int :=
  ∑ i, x i * y i

@[simp]
theorem intDot_zero_left {n : Nat} (y : Fin n -> Int) :
    intDot (0 : Fin n -> Int) y = 0 := by
  simp [intDot]

@[simp]
theorem intDot_zero_right {n : Nat} (x : Fin n -> Int) :
    intDot x (0 : Fin n -> Int) = 0 := by
  simp [intDot]

theorem intDot_add_left {n : Nat} (x y z : Fin n -> Int) :
    intDot (x + y) z = intDot x z + intDot y z := by
  simp [intDot, add_mul, Finset.sum_add_distrib]

theorem intDot_neg_left {n : Nat} (x y : Fin n -> Int) :
    intDot (-x) y = -intDot x y := by
  simp [intDot, Finset.sum_neg_distrib]

/-- Reducing the integer dot product modulo two gives the binary dot product. -/
theorem intDot_cast_zmod_two_eq_binaryDot_reduce {n : Nat}
    (x y : Fin n -> Int) :
    ((intDot x y : Int) : ZMod 2) =
      binaryDot (reduceModTwo x) (reduceModTwo y) := by
  simp [intDot, binaryDot, reduceModTwo]

/-! ## Lifting binary vectors to `0`/`1` integer vectors -/

theorem zmod_two_eq_zero_or_one (a : ZMod 2) : a = 0 \/ a = 1 := by
  fin_cases a <;> simp

/-- The canonical `0`/`1` integer lift of a binary vector. -/
def binaryLift {n : Nat} (v : BinaryVector n) : Fin n -> Int :=
  fun i => if v i = 0 then 0 else 1

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

theorem binaryLift_mem_constructionA {n : Nat} (C : BinaryLinearCode n)
    {v : BinaryVector n} (hv : v ∈ C) :
    binaryLift v ∈ constructionA C := by
  rw [mem_constructionA_iff, reduceModTwo_binaryLift]
  exact hv

/-! ## Integer model of the dual scaled Construction A lattice -/

/--
The integer-coordinate model of the dual of the scaled Construction A lattice.

If the real lattice is `(1 / sqrt 2) * constructionA C`, then a vector
`(1 / sqrt 2) * y` pairs integrally with every lattice vector exactly when
`2` divides `intDot y z` for every `z` in `constructionA C`.
-/
def scaledConstructionADualInt {n : Nat}
    (C : BinaryLinearCode n) : AddSubgroup (Fin n -> Int) where
  carrier := { y | forall z : Fin n -> Int, z ∈ constructionA C -> 2 ∣ intDot y z }
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
    refine ⟨-k, ?_⟩
    rw [intDot_neg_left, hk]
    ring

theorem mem_scaledConstructionADualInt_iff {n : Nat}
    (C : BinaryLinearCode n) (y : Fin n -> Int) :
    y ∈ scaledConstructionADualInt C <->
      forall z : Fin n -> Int, z ∈ constructionA C -> 2 ∣ intDot y z := Iff.rfl

theorem constructionA_le_scaledConstructionADualInt_of_selfDual {n : Nat}
    (C : BinaryLinearCode n) (hC : IsSelfDual C) :
    constructionA C ≤ scaledConstructionADualInt C := by
  intro y hy
  rw [mem_scaledConstructionADualInt_iff]
  intro z hz
  apply (ZMod.intCast_zmod_eq_zero_iff_dvd (intDot y z) 2).mp
  rw [intDot_cast_zmod_two_eq_binaryDot_reduce]
  have hyC : reduceModTwo y ∈ C := (mem_constructionA_iff C y).mp hy
  have hzC : reduceModTwo z ∈ C := (mem_constructionA_iff C z).mp hz
  have hyDual : reduceModTwo y ∈ dualCode C := by
    unfold IsSelfDual at hC
    rw [hC] at hyC
    exact hyC
  exact (mem_dualCode_iff C (reduceModTwo y)).mp hyDual (reduceModTwo z) hzC

theorem scaledConstructionADualInt_le_constructionA_of_selfDual {n : Nat}
    (C : BinaryLinearCode n) (hC : IsSelfDual C) :
    scaledConstructionADualInt C ≤ constructionA C := by
  intro y hy
  rw [mem_constructionA_iff]
  unfold IsSelfDual at hC
  rw [hC]
  rw [mem_dualCode_iff]
  intro w hw
  have hLift : binaryLift w ∈ constructionA C :=
    binaryLift_mem_constructionA C hw
  have hdiv : 2 ∣ intDot y (binaryLift w) := by
    exact (mem_scaledConstructionADualInt_iff C y).mp hy (binaryLift w) hLift
  have hcast : ((intDot y (binaryLift w) : Int) : ZMod 2) = 0 :=
    (ZMod.intCast_zmod_eq_zero_iff_dvd (intDot y (binaryLift w)) 2).mpr hdiv
  have hdot :
      binaryDot (reduceModTwo y) (reduceModTwo (binaryLift w)) = 0 := by
    simpa [intDot_cast_zmod_two_eq_binaryDot_reduce] using hcast
  simpa using hdot

/--
Integer-coordinate self-duality of scaled Construction A.

This is the algebraic core of the theorem that a self-dual binary code gives a
unimodular Construction A lattice after the conventional `1 / sqrt 2` scaling.
-/
theorem scaledConstructionADualInt_eq_constructionA_of_selfDual {n : Nat}
    (C : BinaryLinearCode n) (hC : IsSelfDual C) :
    scaledConstructionADualInt C = constructionA C := by
  exact le_antisymm
    (scaledConstructionADualInt_le_constructionA_of_selfDual C hC)
    (constructionA_le_scaledConstructionADualInt_of_selfDual C hC)

/-! ## Type II bundle in integer coordinates -/

theorem constructionA_sqNorm_eq_four_mul_of_doublyEven {n : Nat}
    (C : BinaryLinearCode n) (hC : IsDoublyEven C)
    (z : Fin n -> Int) (hz : z ∈ constructionA C) :
    exists k : Int, sqNorm z = 4 * k := by
  rcases constructionA_sqNorm_dvd_four_of_doublyEven C hC z hz with ⟨k, hk⟩
  exact ⟨k, hk⟩

/--
The broad Type II Construction A theorem in the integer-coordinate model.

The first component says that the scaled squared norm is even, since
`sqNorm z = 4 * k` is equivalent to `(sqNorm z) / 2 = 2 * k` after scaling.
The second component is the coordinate duality theorem above.
-/
theorem constructionA_typeII_integer_package {n : Nat}
    (C : BinaryLinearCode n) (hC : IsTypeII C) :
    (forall z : Fin n -> Int, z ∈ constructionA C -> exists k : Int, sqNorm z = 4 * k) /\
      scaledConstructionADualInt C = constructionA C := by
  exact ⟨fun z hz => constructionA_sqNorm_eq_four_mul_of_doublyEven C hC.2 z hz,
    scaledConstructionADualInt_eq_constructionA_of_selfDual C hC.1⟩

/-! ## Real scaled lattice handoff -/

/-- The coordinate map `z |-> z / sqrt 2`. -/
noncomputable def scaledConstructionARealLinearMap (n : Nat) :
    (Fin n -> Int) →ₗ[Int] (Fin n -> Real) where
  toFun z := fun i => (z i : Real) / Real.sqrt 2
  map_add' := by
    intro x y
    ext i
    simp [add_div]
  map_smul' := by
    intro a x
    ext i
    simp [mul_div_assoc]

/-- The real `1 / sqrt 2` scaled Construction A lattice as a `Z`-submodule. -/
noncomputable def scaledConstructionAReal {n : Nat}
    (C : BinaryLinearCode n) : Submodule Int (Fin n -> Real) :=
  (constructionA C).toIntSubmodule.map (scaledConstructionARealLinearMap n)

/-- Euclidean coordinate dot product on `Fin n -> Real`. -/
noncomputable def realDot {n : Nat} (x y : Fin n -> Real) : Real :=
  ∑ i, x i * y i

/--
The set-theoretic real dual of the scaled Construction A lattice, stated in
plain coordinates to keep the handoff independent of any particular `ZLattice`
dual API.
-/
noncomputable def scaledConstructionARealDual {n : Nat}
    (C : BinaryLinearCode n) : Set (Fin n -> Real) :=
  { y | forall x : Fin n -> Real, x ∈ scaledConstructionAReal C ->
      exists k : Int, realDot y x = k }

/-- Doubly-even codes give even real scaled Construction A lattices. -/
theorem scaledConstructionAReal_even_of_doublyEven {n : Nat}
    (C : BinaryLinearCode n) (hC : IsDoublyEven C) :
    forall x : Fin n -> Real, x ∈ scaledConstructionAReal C ->
      exists k : Int, realDot x x = (2 * k : Real) := by
  intros x hx
  obtain ⟨z, hz⟩ :
      ∃ z : Fin n -> Int, z ∈ constructionA C ∧
        x = fun i => (z i : Real) / Real.sqrt 2 := by
    rcases hx with ⟨z, hz, rfl⟩
    exact ⟨z, hz, rfl⟩
  have h_realDot : realDot x x = (∑ i, (z i : Real) ^ 2) / 2 := by
    unfold realDot
    norm_num [hz.2, div_mul_div_comm, Finset.sum_div _ _ _]
    ring_nf
  obtain ⟨k, hk⟩ : ∃ k : Int, (sqNorm z : Real) = 4 * k := by
    have h := constructionA_sqNorm_eq_four_mul_of_doublyEven C hC z hz.1
    exact ⟨h.choose, mod_cast h.choose_spec⟩
  rw [h_realDot]
  field_simp [hk]
  exact ⟨k, mod_cast hk⟩

/--
Self-dual binary codes give real self-dual scaled Construction A lattices.

This is intentionally stated without SPL dependencies.  It is a direct bridge
from the integer-coordinate theorem
`scaledConstructionADualInt_eq_constructionA_of_selfDual` to the plain
coordinate set `scaledConstructionARealDual`.
-/
theorem scaledConstructionARealDual_eq_self_of_selfDual {n : Nat}
    (C : BinaryLinearCode n) (hC : IsSelfDual C) :
    scaledConstructionARealDual C = (scaledConstructionAReal C : Set (Fin n -> Real)) := by
  apply Set.eq_of_subset_of_subset
  · intro y hy
    obtain ⟨z, hz⟩ : ∃ z : Fin n -> Int, y = fun i => (z i : Real) / Real.sqrt 2 := by
      have hz : ∀ i, ∃ z_i : Int, y i * Real.sqrt 2 = z_i := by
        intro i
        have := hy (fun j => if j = i then 2 / Real.sqrt 2 else 0) ?_
        · unfold realDot at this
          simp_all +decide
        · refine ⟨twoBasisVec i, ?_, ?_⟩
          · convert constructionA_contains_twoBasisVec C i using 1
          · ext j
            simp [scaledConstructionARealLinearMap, twoBasisVec]
            split_ifs <;> norm_num [div_eq_iff]
      exact ⟨fun i => Classical.choose (hz i),
        funext fun i => by
          rw [← Classical.choose_spec (hz i),
            mul_div_cancel_right₀ _ (by positivity)]⟩
    have h_dot_int : ∀ w : Fin n -> Int, w ∈ constructionA C -> 2 ∣ intDot z w := by
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
    have hz_in_constructionA : z ∈ constructionA C := by
      convert scaledConstructionADualInt_eq_constructionA_of_selfDual C hC ▸
        (mem_scaledConstructionADualInt_iff C z).2 h_dot_int using 1
    exact hz.symm ▸ ⟨z, hz_in_constructionA, rfl⟩
  · intro x hx
    obtain ⟨z, hz, rfl⟩ := hx
    rw [scaledConstructionARealDual]
    intro y hy
    obtain ⟨w, hw, rfl⟩ := hy
    have h_realDot :
        realDot (scaledConstructionARealLinearMap n z)
          (scaledConstructionARealLinearMap n w) = (intDot z w : Real) / 2 := by
      unfold realDot intDot scaledConstructionARealLinearMap
      norm_num [div_mul_div_comm, Finset.sum_div _ _ _]
    have h_div : 2 ∣ intDot z w :=
      (mem_scaledConstructionADualInt_iff C z).mp
        (constructionA_le_scaledConstructionADualInt_of_selfDual C hC hz) w hw
    obtain ⟨k, hk⟩ := h_div
    refine ⟨k, ?_⟩
    rw [h_realDot, hk]
    norm_num

end PhysicsSM.Coding
