import CodeLatticeE8.ConstructionA.Norm

/-!
# One-coordinate lift counts for Construction A theta series

Construction A shell counts factor coordinate by coordinate once the binary
residue class is fixed.  This module isolates the one-dimensional arithmetic:

- even coordinates are integer lifts with residue `0 : ZMod 2`;
- odd coordinates are integer lifts with residue `1 : ZMod 2`;
- `evenLiftCoeff n` and `oddLiftCoeff n` count lifts whose square is `n`.

These coefficients are intentionally independent of the E8/Hamming code.  The
E8-specific theta files use them as the one-coordinate factors in the Hamming
weight convolution.

The small value lemmas are proved by unfolding the closed-form definitions
and evaluating with `norm_num`.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.ConstructionA

/-! ## Closed-form one-coordinate coefficients -/

/--
The number of even integers `z` with `z^2 = n`.

It is `1` for `n = 0`, `2` for nonzero even squares, and `0` otherwise.
-/
def evenLiftCoeff (n : ℕ) : ℕ :=
  if n = 0 then 1
  else
    let s := Nat.sqrt n
    if s * s = n ∧ s % 2 = 0 then 2 else 0

/--
The number of odd integers `z` with `z^2 = n`.

It is `2` for odd squares and `0` otherwise.
-/
def oddLiftCoeff (n : ℕ) : ℕ :=
  let s := Nat.sqrt n
  if s * s = n ∧ s % 2 = 1 then 2 else 0

theorem evenLiftCoeff_zero : evenLiftCoeff 0 = 1 := by
  unfold evenLiftCoeff; simp
theorem evenLiftCoeff_one : evenLiftCoeff 1 = 0 := by
  unfold evenLiftCoeff; norm_num [Nat.sqrt_eq]
theorem evenLiftCoeff_four : evenLiftCoeff 4 = 2 := by
  unfold evenLiftCoeff; norm_num [Nat.sqrt_eq]
theorem evenLiftCoeff_nine : evenLiftCoeff 9 = 0 := by
  unfold evenLiftCoeff; norm_num [Nat.sqrt_eq]
theorem evenLiftCoeff_sixteen : evenLiftCoeff 16 = 2 := by
  unfold evenLiftCoeff; norm_num [Nat.sqrt_eq]

theorem oddLiftCoeff_zero : oddLiftCoeff 0 = 0 := by
  unfold oddLiftCoeff; norm_num [Nat.sqrt_eq]
theorem oddLiftCoeff_one : oddLiftCoeff 1 = 2 := by
  unfold oddLiftCoeff; norm_num [Nat.sqrt_eq]
theorem oddLiftCoeff_four : oddLiftCoeff 4 = 0 := by
  unfold oddLiftCoeff; norm_num [Nat.sqrt_eq]
theorem oddLiftCoeff_nine : oddLiftCoeff 9 = 2 := by
  unfold oddLiftCoeff; norm_num [Nat.sqrt_eq]
theorem oddLiftCoeff_twentyfive : oddLiftCoeff 25 = 2 := by
  unfold oddLiftCoeff; norm_num [Nat.sqrt_eq]

/-! ## Finite lift sets -/

/-- The finite set of even integers with square `n`. -/
noncomputable def evenLiftFinset (n : ℕ) : Finset ℤ :=
  (Finset.Icc (-(n : ℤ)) n).filter
    (fun z => z ^ 2 = (n : ℤ) ∧ (2 : ℤ) ∣ z)

/-- The finite set of odd integers with square `n`. -/
noncomputable def oddLiftFinset (n : ℕ) : Finset ℤ :=
  (Finset.Icc (-(n : ℤ)) n).filter
    (fun z => z ^ 2 = (n : ℤ) ∧ ¬ (2 : ℤ) ∣ z)

/-- The finite set of integers with square `n` and a prescribed mod-two residue. -/
noncomputable def coordLiftFinset (ci : ZMod 2) (n : ℕ) : Finset ℤ :=
  (Finset.Icc (-(n : ℤ)) n).filter
    (fun z => z ^ 2 = (n : ℤ) ∧ (z : ZMod 2) = ci)

end CodeLatticeE8.ConstructionA
