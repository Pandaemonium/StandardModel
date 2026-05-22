import Mathlib.Tactic
import CodeLatticeE8.E8.Roots

/-!
# Weyl reflections of the doubled-coordinate E8 roots

This module defines the integral Weyl reflection formula for the clean
`CodeLatticeE8.E8.Roots.rootList` model and proves that the 240 roots are
closed under those reflections.

## Coordinate convention

All roots are stored in doubled coordinates: a vector `v : Fin 8 -> Z`
represents the actual Euclidean vector `v / 2`.  Therefore:

- doubled squared norm of a root: `Roots.normSq v = 8`;
- actual squared norm of a root: `8 / 4 = 2`;
- doubled inner product: `Roots.dot v r`;
- actual inner product: `Roots.dot v r / 4`.

For an actual root `r` of squared norm `2`, the Weyl reflection is

```text
s_r(v) = v - 2 * <v,r> / <r,r> * r = v - <v,r> * r.
```

In doubled coordinates this becomes

```text
reflect r v = v - (Roots.dot v r / 4) * r.
```

The theorem `dot_mod_four_eq_zero_of_mem` records that the division by `4` is
exact for pairs of E8 roots.

## Proof strategy

The reflection theorems are proved from the semantic predicate `IsE8Root`,
rather than by checking all pairs in the explicit 240-element list.  The key
lemma is `dot_div_four_of_isE8Root`: two semantic E8 roots have doubled inner
product divisible by `4`, so the integer reflection formula is exact.  From
there, the norm, parity, and coordinate-sum conditions are preserved
algebraically.

## Sources

- Bourbaki, *Lie Groups and Lie Algebras*, Ch. 4-6.
- Humphreys, *Introduction to Lie Algebras and Representation Theory*, Ch. 10.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.E8.WeylReflections

open CodeLatticeE8.E8.Roots

/-! ## Reflection formula -/

/--
The integer coefficient appearing in the doubled-coordinate Weyl reflection.

For E8 roots `v` and `r`, `dot v r` is divisible by `4`, so this is the
ordinary integer representing the actual inner product `<v/2, r/2>`.
-/
def reflectionCoeff (r v : Fin 8 → ℤ) : ℤ :=
  dot v r / 4

/--
The Weyl reflection of `v` through the root `r`, in doubled coordinates.

This implements the formula
`v - (dot v r / 4) * r`.  The companion theorem
`dot_mod_four_eq_zero_of_mem` records exact divisibility for root pairs.
-/
def reflect (r v : Fin 8 → ℤ) : Fin 8 → ℤ :=
  fun i => v i - reflectionCoeff r v * r i

/-! ## Semantic reflection lemmas -/

/-- The doubled inner product is symmetric. -/
theorem dot_comm (v w : Fin 8 → ℤ) : dot v w = dot w v := by
  simp only [dot, mul_comm]

private lemma reflectionCoeff_of_dot_eq {r v : Fin 8 → ℤ} {c : ℤ}
    (h : dot v r = 4 * c) : reflectionCoeff r v = c := by
  simp only [reflectionCoeff, h]
  omega

/--
Reflection preserves doubled squared norm, provided both vectors have norm `8`
and the reflection coefficient is integral.
-/
theorem normSq_reflect_of_normSq {r v : Fin 8 → ℤ}
    (hnr : normSq r = 8) (hnv : normSq v = 8) (hdiv : 4 ∣ dot v r) :
    normSq (reflect r v) = 8 := by
  obtain ⟨k, hk⟩ := hdiv
  convert congr_arg
    (fun x : ℤ => x - 2 * k * dot v r + k ^ 2 * normSq r) hnv using 1
  · unfold reflect normSq dot
    unfold reflectionCoeff
    simp +decide [hk, Finset.sum_add_distrib, Finset.mul_sum _ _ _,
      mul_assoc, mul_comm, mul_left_comm, sub_sq]
    ring_nf
  · rw [hk, hnr]
    ring

/--
Reflection through a norm-`8` vector is involutive whenever the doubled inner
product is divisible by `4`.
-/
theorem reflect_reflect_of_normSq {r v : Fin 8 → ℤ}
    (hnr : normSq r = 8) (hdiv : 4 ∣ dot v r) :
    reflect r (reflect r v) = v := by
  obtain ⟨c, hc⟩ : ∃ c, dot v r = 4 * c := hdiv
  have h_second_coeff : reflectionCoeff r (reflect r v) = -c := by
    have h_dot : dot (reflect r v) r = 4 * c - c * normSq r := by
      unfold reflect dot normSq at *
      simp +decide [sub_mul, Finset.sum_sub_distrib, mul_assoc,
        Finset.mul_sum _ _ _, hc, reflectionCoeff]
      simp +decide [← sq, ← Finset.mul_sum _ _ _, hc, dot]
    exact reflectionCoeff_of_dot_eq (by rw [h_dot, hnr]; ring)
  ext i
  simp only [reflect, h_second_coeff, neg_mul, sub_neg_eq_add]
  rw [show reflectionCoeff r v = c by rw [reflectionCoeff, hc]; norm_num]
  ring

/-! ### Dot-product divisibility -/

private lemma dot_div_four_even_even {v r : Fin 8 → ℤ}
    (hv : ∀ i : Fin 8, v i % 2 = 0) (hr : ∀ i : Fin 8, r i % 2 = 0) :
    4 ∣ dot v r := by
  exact Finset.dvd_sum fun i _ => by
    obtain ⟨k, hk⟩ := Int.modEq_zero_iff_dvd.mp (hv i)
    obtain ⟨l, hl⟩ := Int.modEq_zero_iff_dvd.mp (hr i)
    exact ⟨k * l, by rw [hk, hl]; ring⟩

-- The modular-arithmetic normalization below intentionally lets `simp_all`
-- expose the finite sums before `omega` reads the resulting congruence.
set_option linter.flexible false in
set_option linter.unusedSimpArgs false in
private lemma dot_div_four_even_odd {v r : Fin 8 → ℤ}
    (hv_even : ∀ i : Fin 8, v i % 2 = 0)
    (hsv : (∑ i : Fin 8, v i) % 4 = 0)
    (hr_odd : ∀ i : Fin 8, r i % 2 = 1) :
    4 ∣ dot v r := by
  obtain ⟨w, hw⟩ : ∃ w : Fin 8 → ℤ, v = fun i => 2 * w i := by
    exact ⟨fun i => v i / 2, funext fun i => by
      rw [mul_comm, Int.ediv_mul_cancel (Int.dvd_of_emod_eq_zero (hv_even i))]⟩
  simp_all +decide [dot, Finset.mul_sum _ _ _]
  have h_congr : ∑ i, w i * r i ≡ ∑ i, w i [ZMOD 2] := by
    norm_num [Int.ModEq, Finset.sum_int_mod, Int.mul_emod, hr_odd]
  simp_all +decide [Finset.mul_sum _ _ _, mul_assoc, Int.ModEq]
  simp_all +decide [← Finset.mul_sum _ _ _, ← Finset.sum_mul]
  exact Int.dvd_of_emod_eq_zero (by omega)

private lemma dot_div_four_odd_odd {v r : Fin 8 → ℤ}
    (hv_odd : ∀ i : Fin 8, v i % 2 = 1) (hr_odd : ∀ i : Fin 8, r i % 2 = 1)
    (hsv : (∑ i : Fin 8, v i) % 4 = 0) (hsr : (∑ i : Fin 8, r i) % 4 = 0) :
    4 ∣ dot v r := by
  obtain ⟨f, hf⟩ : ∃ f : Fin 8 → ℤ, ∀ i, v i = 2 * f i + 1 := by
    exact ⟨fun i => v i / 2, fun i => by
      linarith [Int.emod_add_mul_ediv (v i) 2, hv_odd i]⟩
  obtain ⟨g, hg⟩ : ∃ g : Fin 8 → ℤ, ∀ i, r i = 2 * g i + 1 := by
    exact ⟨fun i => (r i - 1) / 2, fun i => by
      rw [Int.mul_ediv_cancel' (Int.dvd_self_sub_of_emod_eq (hr_odd i))]
      ring⟩
  simp_all +decide [Finset.sum_add_distrib, mul_add, mul_comm, mul_left_comm, dot]
  simp_all +decide [← mul_assoc, ← Finset.sum_mul _ _ _]
  grind

/--
For any two semantic E8 roots, the doubled inner product is divisible by `4`.

The proof splits on the two allowed parity types.  The mixed-parity case uses
the coordinate-sum condition modulo `4`; the odd-odd case rewrites each
coordinate as `2k + 1`.
-/
theorem dot_div_four_of_isE8Root {r v : Fin 8 → ℤ}
    (hr : IsE8Root r) (hv : IsE8Root v) :
    4 ∣ dot v r := by
  obtain ⟨_, hpr, hsr⟩ := hr
  obtain ⟨_, hpv, hsv⟩ := hv
  rcases hpv with hve | hvo <;> rcases hpr with hre | hro
  · exact dot_div_four_even_even hve hre
  · exact dot_div_four_even_odd hve hsv hro
  · rw [dot_comm]
    exact dot_div_four_even_odd hre hsr hvo
  · exact dot_div_four_odd_odd hvo hro hsv hsr

/-! ### Parity and coordinate-sum preservation -/

-- The four parity cases collapse to small modulo-2 computations.
set_option linter.flexible false in
private lemma reflect_parity_preserved (c : ℤ) {v r : Fin 8 → ℤ}
    (hpv : (∀ i : Fin 8, v i % 2 = 0) ∨ (∀ i : Fin 8, v i % 2 = 1))
    (hpr : (∀ i : Fin 8, r i % 2 = 0) ∨ (∀ i : Fin 8, r i % 2 = 1)) :
    (∀ i : Fin 8, (v i - c * r i) % 2 = 0) ∨
    (∀ i : Fin 8, (v i - c * r i) % 2 = 1) := by
  cases hpv <;> cases hpr <;> simp +decide [*, Int.sub_emod, Int.mul_emod]
  · exact Int.emod_two_eq_zero_or_one c |> Or.imp (fun h => Int.dvd_of_emod_eq_zero h) id
  · lia

private lemma reflect_sum_preserved (c : ℤ) {v r : Fin 8 → ℤ}
    (hsv : (∑ i : Fin 8, v i) % 4 = 0)
    (hsr : (∑ i : Fin 8, r i) % 4 = 0) :
    (∑ i : Fin 8, (v i - c * r i)) % 4 = 0 := by
  simp +decide [Finset.sum_sub_distrib, ← Finset.mul_sum, Int.mul_emod,
    Int.sub_emod, hsv, hsr]

/-! ### Main semantic theorems -/

/-- Weyl reflection through a semantic E8 root preserves the semantic root predicate. -/
theorem reflect_preserves_IsE8Root {r v : Fin 8 → ℤ}
    (hr : IsE8Root r) (hv : IsE8Root v) :
    IsE8Root (reflect r v) := by
  have hdiv := dot_div_four_of_isE8Root hr hv
  refine ⟨normSq_reflect_of_normSq hr.1 hv.1 hdiv, ?_, ?_⟩
  · exact reflect_parity_preserved (reflectionCoeff r v) hv.2.1 hr.2.1
  · exact reflect_sum_preserved (reflectionCoeff r v) hv.2.2 hr.2.2

/-- Weyl reflection is involutive on semantic E8 roots. -/
theorem reflect_involutive_of_isE8Root {r v : Fin 8 → ℤ}
    (hr : IsE8Root r) (hv : IsE8Root v) :
    reflect r (reflect r v) = v :=
  reflect_reflect_of_normSq hr.1 (dot_div_four_of_isE8Root hr hv)

/-- Weyl reflections preserve the doubled squared norm, from semantic hypotheses. -/
theorem normSq_reflect_of_isE8Root {r v : Fin 8 → ℤ}
    (hr : IsE8Root r) (hv : IsE8Root v) :
    normSq (reflect r v) = 8 :=
  normSq_reflect_of_normSq hr.1 hv.1 (dot_div_four_of_isE8Root hr hv)

/-- Closure restated as membership in the explicit `rootList`. -/
theorem reflect_mem_rootList_of_isE8Root {r v : Fin 8 → ℤ}
    (hr : IsE8Root r) (hv : IsE8Root v) :
    reflect r v ∈ rootList :=
  (mem_rootList_iff_isE8Root _).mpr (reflect_preserves_IsE8Root hr hv)

/-! ## Public API -/

/--
For any two roots in `rootList`, the doubled inner product is divisible by
`4`.  Equivalently, the actual inner product of the represented roots is an
integer.
-/
theorem dot_mod_four_eq_zero_of_mem {r v : Fin 8 → ℤ}
    (hr : r ∈ rootList) (hv : v ∈ rootList) : dot v r % 4 = 0 :=
  Int.emod_eq_zero_of_dvd (dot_div_four_of_isE8Root (isE8Root_of_mem hr) (isE8Root_of_mem hv))

/--
The E8 root list is closed under Weyl reflections through roots.

This is the fundamental root-system closure property, stated directly for the
clean doubled-coordinate root model.
-/
theorem reflect_mem_rootList {r v : Fin 8 → ℤ}
    (hr : r ∈ rootList) (hv : v ∈ rootList) : reflect r v ∈ rootList :=
  reflect_mem_rootList_of_isE8Root (isE8Root_of_mem hr) (isE8Root_of_mem hv)

/--
Weyl reflection through a root is involutive on the E8 root list.
-/
theorem reflect_reflect_of_mem {r v : Fin 8 → ℤ}
    (hr : r ∈ rootList) (hv : v ∈ rootList) : reflect r (reflect r v) = v :=
  reflect_involutive_of_isE8Root (isE8Root_of_mem hr) (isE8Root_of_mem hv)

/--
If `r` has doubled squared norm `8`, reflecting `r` through itself gives its
negative.

This lemma is purely algebraic: it does not unfold or enumerate `rootList`.
-/
theorem reflect_self_eq_neg_of_normSq {r : Fin 8 → ℤ}
    (hr : normSq r = 8) : reflect r r = fun i => -r i := by
  funext i
  have hdot : dot r r = 8 := by
    rw [dot_self]
    exact hr
  simp [reflect, reflectionCoeff, hdot]
  ring

/--
Reflecting a root through itself gives its negative.
-/
theorem reflect_self_eq_neg {r : Fin 8 → ℤ}
    (hr : r ∈ rootList) : reflect r r = fun i => -r i :=
  reflect_self_eq_neg_of_normSq (normSq_eq_eight_of_mem hr)

/--
Weyl reflections preserve the doubled squared norm of roots.

The proof uses root-list closure and the root-list norm theorem, rather than
expanding the reflection formula algebraically.
-/
theorem normSq_reflect_of_mem {r v : Fin 8 → ℤ}
    (hr : r ∈ rootList) (hv : v ∈ rootList) : normSq (reflect r v) = 8 :=
  normSq_reflect_of_isE8Root (isE8Root_of_mem hr) (isE8Root_of_mem hv)

end CodeLatticeE8.E8.WeylReflections
