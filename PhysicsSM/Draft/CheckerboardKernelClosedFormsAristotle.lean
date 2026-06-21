import PhysicsSM.Draft.CheckerboardCornerPolynomialAristotle
import PhysicsSM.Draft.CheckerboardCornerClosedFormsAristotle

/-!
# Draft.CheckerboardKernelClosedFormsAristotle

Focused Aristotle handoff: combine the corner-count polynomial theorem with
the binomial corner-count closed forms to get endpoint-level closed forms for
the finite checkerboard path sum.

The imported draft files already prove:

- the path sum is a polynomial in the corner weight, with coefficients given
  by fixed-endpoint corner classes;
- the right-incoming corner classes have binomial closed forms.

The target here is the publication-facing kernel statement: for a path from
`0` to displacement `p - q` in `p + q` lightlike steps, starting incoming
right, the directed endpoint path sum is the corresponding finite polynomial
in `mu`.

This is still finite combinatorics.  No continuum limit or analytic
normalization is asserted here.
-/

namespace PhysicsSM.Draft.CheckerboardKernelClosedForms

open PhysicsSM.Spinor.Checkerboard
open PhysicsSM.Spinor.Checkerboard.Direction
open PhysicsSM.Draft.CheckerboardCornerClosedForms

variable {S : Type*}

/-- The two imported corner-class definitions are intentionally identical. -/
theorem turnHistories_poly_eq_closed (n : Nat) (startDir : Direction)
    (dx : Int) (finishDir : Direction) (k : Nat) :
    PhysicsSM.Draft.CheckerboardCornerPolynomial.turnHistories
        n startDir dx finishDir k =
      PhysicsSM.Draft.CheckerboardCornerClosedForms.turnHistories
        n startDir dx finishDir k := by
  rfl

/-!
## Nat-level vanishing helpers

These say the binomial run-counts vanish once the requested corner count
exceeds the path length, so the closed-form coefficient sums can be reindexed
without changing their value.
-/

/--
The even run-count vanishes once `2*r` exceeds the path length `p + q`
when `0 < q`.
-/
theorem choose_mul_choose_zero_even (p q r : Nat) (hq : 0 < q)
    (h : p + q < 2 * r) :
    p.choose r * (q - 1).choose (r - 1) = 0 := by
  by_cases hp : p < r <;> by_cases hq : q < r <;> simp_all +decide [Nat.choose_eq_zero_of_lt]
  · exact Or.inr (Nat.choose_eq_zero_of_lt (by omega))
  · omega

/--
The odd run-count vanishes once `2*r + 1` exceeds the path length `p + q`
when `0 < q`.
-/
theorem choose_mul_choose_zero_odd (p q r : Nat) (hq : 0 < q)
    (h : p + q < 2 * r + 1) :
    p.choose r * (q - 1).choose r = 0 := by
  by_cases hr : p < r
  · rw [Nat.choose_eq_zero_of_lt hr, MulZeroClass.zero_mul]
  · exact mul_eq_zero_of_right _ (Nat.choose_eq_zero_of_lt (by omega))

/-!
## Parity-zero count helper

A history starting incoming right and ending moving left must have an odd
corner count, so the even classes are empty.
-/

/--
A right-incoming, left-terminal history has an even corner count zero class:
the count vanishes for every even corner number.
-/
theorem length_turnHistories_right_left_even (n : Nat) (dx : Int) (r : Nat) :
    (turnHistories n Direction.right dx Direction.left (2 * r)).length = 0 := by
  simp [turnHistories]
  intro a ha h₁ h₂ h₃
  simp_all +decide [terminalDirection_eq_ite]

/-!
## Maximal-displacement count helpers

At the maximal right endpoint `dx = n` the only history is the all-right line,
which has zero corners and terminal direction right.
-/

/--
At the maximal right displacement, the only nonzero corner class is the
cornerless one.
-/
theorem gcount_max (n k : Nat) :
    gcount n Direction.right (n : Int) k = if k = 0 then 1 else 0 := by
  by_cases hk : k = 0 <;> simp +decide [hk, gcount_zero_corner]
  induction' n with n ih generalizing k <;> simp_all +decide [gcount_succ]
  · cases k <;> aesop
  · convert gcount_eq_zero_of_abs n left (n + 1 + 1) (k - 1) _ using 1
    all_goals grind

/--
At the maximal right displacement, the right-terminal corner classes are a
single cornerless history.
-/
theorem length_turnHistories_full_rr (p k : Nat) :
    (turnHistories p Direction.right (p : Int) Direction.right k).length =
      if k = 0 then 1 else 0 := by
  by_cases hk : Even k <;> simp_all +decide [turnHistories]
  · have h_filter : ∀ h ∈ histories p,
        turnCount right h = k → terminalDirection right h = right := by
      intros h hh hk
      rw [terminalDirection_eq_ite]
      aesop
    rw [List.filter_congr]
    convert gcount_max p k using 1
    grind
  · split_ifs <;> simp_all +decide
    intro a ha h₁ h₂ h₃
    have := terminalDirection_eq_ite right a
    simp_all +decide [parity_simps]

/-- At the maximal right displacement, no history terminates moving left. -/
theorem length_turnHistories_full_rl (p k : Nat) :
    (turnHistories p Direction.right (p : Int) Direction.left k).length = 0 := by
  unfold turnHistories
  by_cases hk : Even k <;> simp_all +decide [terminalDirection_eq_ite]
  · grind
  · obtain ⟨m, rfl⟩ := hk
    intro a ha h₁ h₂ h₃
    have := gcount_max p (2 * m + 1)
    simp_all +decide [gcount]

/-!
## Generic even/odd reindexing of a finite polynomial sum

The path-sum polynomial is supported on a single parity of corner counts.
These two glue lemmas turn the `range (n+1)` corner-count sum into the
publication-facing `mu^(2*r)` / `mu^(2*r+1)` form.
-/

/--
Reindex a `range (n+1)` sum supported on even indices into a `mu^(2*r)` sum
over `Finset.Icc 1 n`.
-/
theorem reindex_even [Semiring S] (n : Nat) (f g : Nat → S)
    (h0 : f 0 = 0)
    (hodd : ∀ r, f (2 * r + 1) = 0)
    (heven : ∀ r, 1 ≤ r → f (2 * r) = g r)
    (htail : ∀ r, n < 2 * r → g r = 0) :
    ∑ k ∈ Finset.range (n + 1), f k = ∑ r ∈ Finset.Icc 1 n, g r := by
  have h_odd : ∑ k ∈ Finset.range (n + 1), f k =
      ∑ k ∈ Finset.filter (Even ·) (Finset.range (n + 1)), f k := by
    rw [Finset.sum_filter, Finset.sum_congr rfl]
    intro k hk
    rcases Nat.even_or_odd' k with ⟨r, rfl | rfl⟩ <;> simp_all +decide
  rw [h_odd,
    show Finset.filter Even (Finset.range (n + 1)) =
        Finset.image (fun r => 2 * r) (Finset.Icc 0 (n / 2)) from ?_,
    Finset.sum_image] <;> norm_num [h0, hodd, heven]
  · erw [Finset.sum_Ico_eq_sum_range, Finset.sum_Ico_eq_sum_range]
    simp +arith +decide [Finset.sum_range_succ', h0]
    rw [← Finset.sum_subset
      (Finset.range_mono (show n / 2 ≤ n from Nat.div_le_self _ _))]
    · exact Finset.sum_congr rfl fun x hx => heven _ le_add_self
    · grind
  · ext k
    simp [Finset.mem_filter, Finset.mem_image]
    exact
      ⟨fun h =>
          ⟨k / 2, by omega, by
            rw [mul_comm, Nat.div_mul_cancel (even_iff_two_dvd.mp h.2)]⟩,
        by
          rintro ⟨a, ha, rfl⟩
          exact ⟨by omega, by simp +decide⟩⟩

/--
Reindex a `range (n+1)` sum supported on odd indices into a `mu^(2*r+1)` sum
over `Finset.range (p + 1)`.
-/
theorem reindex_odd [Semiring S] (n p : Nat) (f g : Nat → S)
    (heven : ∀ r, f (2 * r) = 0)
    (hodd : ∀ r, f (2 * r + 1) = g r)
    (htail_n : ∀ r, n < 2 * r + 1 → g r = 0)
    (htail_p : ∀ r, p < r → g r = 0) :
    ∑ k ∈ Finset.range (n + 1), f k = ∑ r ∈ Finset.range (p + 1), g r := by
  have h_split : ∑ k ∈ Finset.range (n + 1), f k =
      ∑ r ∈ Finset.range ((n + 1) / 2), g r := by
    have h_split : ∑ k ∈ Finset.range (n + 1), f k =
        ∑ k ∈ Finset.filter (fun k => k % 2 = 1) (Finset.range (n + 1)), f k := by
      rw [Finset.sum_filter, Finset.sum_congr rfl]
      intro a ha
      rcases Nat.even_or_odd' a with ⟨k, rfl | rfl⟩ <;>
        simp_all +decide [Nat.add_mod]
    rw [h_split,
      show Finset.filter (fun k => k % 2 = 1) (Finset.range (n + 1)) =
          Finset.image (fun r => 2 * r + 1) (Finset.range ((n + 1) / 2)) from ?_,
      Finset.sum_image]
    · exact Finset.sum_congr rfl fun _ _ => hodd _
    · exact fun x hx y hy hxy => by simpa using hxy
    · ext (_ | k) <;> simp +arith +decide [Nat.add_mod]
      exact
        ⟨fun h => ⟨k / 2, by omega, by omega⟩,
          fun ⟨a, ha, ha'⟩ => ⟨by omega, by omega⟩⟩
  rw [h_split]
  by_cases h_cases : (n + 1) / 2 ≤ p + 1
  · rw [← Finset.sum_subset (Finset.range_mono h_cases)]
    grind
  · rw [← Finset.sum_subset
      (Finset.range_mono (by linarith : p + 1 ≤ (n + 1) / 2))]
    aesop

/-!
## Aristotle targets

The hypotheses `0 < q` avoid the straight-line boundary case.  The separate
boundary theorem below handles `q = 0`.
-/

/--
Right-to-right endpoint kernel.  Only even corner counts contribute; the
coefficient of `mu^(2*r)` is the number of ways to split the `p` right steps
and `q` left steps into alternating runs.
-/
theorem pathSum_right_right_closed_form [Semiring S] (mu : S)
    (p q : Nat) (hq : 0 < q) :
    pathSum mu 0 Direction.right (p + q)
        ((p : Int) - (q : Int)) Direction.right
      =
        ∑ r ∈ Finset.Icc 1 (p + q),
          ((p.choose r * (q - 1).choose (r - 1) : Nat) : S) * mu ^ (2 * r) := by
  rw [PhysicsSM.Draft.CheckerboardCornerPolynomial.pathSum_eq_sum_turnHistories]
  convert reindex_even (p + q)
      (fun k =>
        (CheckerboardCornerPolynomial.turnHistories
          (p + q) right (p - q) right k |> List.length) * mu ^ k)
      (fun r => (p.choose r * (q - 1).choose (r - 1)) * mu ^ (2 * r))
      _ _ _ _ using 2 <;> norm_num
  · have := CheckerboardCornerClosedForms.length_turnHistories_zero (p + q) (p - q)
    simp_all +decide [CheckerboardCornerPolynomial.turnHistories]
    convert congr_arg ((↑) : Nat → S) this using 1
    · unfold turnHistories
      simp +decide
    · split_ifs <;> norm_num
      linarith
  · intro r
    rw [show (CheckerboardCornerPolynomial.turnHistories
      (p + q) right (p - q) right (2 * r + 1)).length = 0 from ?_]
    · simp +decide
    · convert length_turnHistories_right_right_odd (p + q) (p - q) r using 1
  · intro r hr
    have h_length :
        (CheckerboardCornerPolynomial.turnHistories
          (p + q) right (p - q) right (2 * r)).length =
          p.choose r * (q - 1).choose (r - 1) := by
      convert length_turnHistories_even p q r hq hr using 1
    rw [h_length]
    norm_cast
  · intro r hr
    have h_choose_zero : p.choose r * (q - 1).choose (r - 1) = 0 := by
      exact choose_mul_choose_zero_even p q r hq hr
    norm_cast
    aesop

/--
Right-to-left endpoint kernel.  Only odd corner counts contribute; the
coefficient of `mu^(2*r+1)` is the corresponding alternating-run count.
-/
theorem pathSum_right_left_closed_form [Semiring S] (mu : S)
    (p q : Nat) (hq : 0 < q) :
    pathSum mu 0 Direction.right (p + q)
        ((p : Int) - (q : Int)) Direction.left
      =
        ∑ r ∈ Finset.range (p + 1),
          ((p.choose r * (q - 1).choose r : Nat) : S) * mu ^ (2 * r + 1) := by
  convert reindex_odd (p + q) p
      (fun k =>
        (turnHistories (p + q) Direction.right
          ((p : Int) - q) Direction.left k |> List.length : S) * mu ^ k)
      (fun r => (p.choose r * (q - 1).choose r : Nat) * mu ^ (2 * r + 1))
      _ _ _ _ using 1
  · convert PhysicsSM.Draft.CheckerboardCornerPolynomial.pathSum_eq_sum_turnHistories
      mu 0 Direction.right (p + q) ((p : Int) - q) Direction.left using 1
    simp +decide [turnHistories_poly_eq_closed]
  · simp_all +decide [length_turnHistories_right_left_even]
  · intro r
    simp [length_turnHistories_odd p q r hq]
  · intro r hr
    simp +decide [choose_mul_choose_zero_odd p q r hq hr]
  · simp +contextual [Nat.choose_eq_zero_of_lt]

/--
Straight right-moving boundary case: if there are no left steps, the unique
right-to-right history has weight `1`.
-/
theorem pathSum_right_right_straight [Semiring S] (mu : S) (p : Nat) :
    pathSum mu 0 Direction.right p (p : Int) Direction.right = 1 := by
  rw [PhysicsSM.Draft.CheckerboardCornerPolynomial.pathSum_eq_sum_turnHistories,
    Finset.sum_eq_single 0] <;> simp +decide [*]
  · convert congr_arg ((↑) : Nat → S) (length_turnHistories_full_rr p 0) using 1
    norm_num
  · have h_length_zero :
        ∀ b ≤ p, b ≠ 0 →
          (CheckerboardCornerPolynomial.turnHistories p right (p : Int) right b).length = 0 := by
      intro b hb hb'
      have := length_turnHistories_full_rr p b
      aesop
    aesop

/--
With no left steps, no history can start incoming right and end moving left at
the maximal right endpoint.
-/
theorem pathSum_right_left_straight_zero [Semiring S] (mu : S) (p : Nat) :
    pathSum mu 0 Direction.right p (p : Int) Direction.left = 0 := by
  rw [PhysicsSM.Draft.CheckerboardCornerPolynomial.pathSum_eq_sum_turnHistories]
  convert Finset.sum_eq_zero _
  intro k hk
  erw [turnHistories_poly_eq_closed]
  simp +decide [length_turnHistories_full_rl]

end PhysicsSM.Draft.CheckerboardKernelClosedForms
