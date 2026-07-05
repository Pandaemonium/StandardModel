import Mathlib

/-!
# QMF3: the finite Matthews-Salam / Berezin-Gaussian identity (statement-design target)

This is a statement-DESIGN + proof target for the QCD-mass-formalism ladder
(`AgentTasks/fourday-ym-run-2026-07-05/RUN_PLAN.md`, rung QMF3). The goal is a
kernel-checked FINITE identity - no analysis, no continuum - that will later
underlie the Wilson-fermion determinant:

    Berezin integral over 2n Grassmann generators of  exp(- thetabar M theta)
        =  det M

for `M : Matrix (Fin n) (Fin n) R` over a suitable commutative ring `R`
(take `R = Complex`, or a characteristic-zero commutative ring / Q-algebra so
`exp` truncates cleanly).

## The pinned convention (from the oracle `Scripts/oracle/validate_berezin.py`)

An independent from-scratch Grassmann-algebra computation (built with signed
ascending-monomial multiplication, NOT via the determinant) was checked against
the Leibniz determinant for n = 1,2,3,4 and confirmed identical, and confirmed
convention-SENSITIVE (a global sign flip breaks it). The pinned convention:

* generators `theta_0..theta_{n-1}, thetabar_0..thetabar_{n-1}`, indexed
  `theta_i -> 2*i`, `thetabar_i -> 2*i+1` in a `Fin (2*n)` generator set;
* Grassmann monomials are `Finset (Fin (2*n))`, read as the product of their
  elements in ASCENDING index order (canonical form), with multiplication sign
  `shuffleSign s t = (-1) ^ #{(a,b) : a in s, b in t, b < a}` when `s`, `t` are
  disjoint and `0` when they overlap;
* the bilinear is `S = sum_{i,j} thetabar_i * (M i j) * theta_j`, i.e. the
  factor `thetabar_i` (generator `2i+1`) is written to the LEFT of `theta_j`
  (generator `2j`) inside each term;
* `exp(-S) = sum_{k=0}^{n} (-S)^k / k!` (truncates: any product of more than
  `2n` generators is zero);
* the Berezin integral is the coefficient of the TOP reference monomial
  `Finset.univ : Finset (Fin (2*n))` (equivalently generators in ascending
  order `0,1,...,2n-1`).

With exactly this convention, `berezinGaussian M = M.det` (Mathlib
`Matrix.det_apply` gives `det M = sum over Perm of sign * prod`, so once the
Grassmann side is shown to equal that permutation sum, the identity closes).

## YOUR TASK

1. Choose the cleanest Lean formalization of the finite Grassmann algebra and
   the Berezin integral that realizes the pinned convention above. Two routes
   are acceptable; pick whichever gives the shorter honest proof:
   (a) SELF-CONTAINED combinatorial model: `GrassmannElem n R :=
       Finset (Fin (2*n)) -> R`, with the signed multiplication above, `exp`
       as the truncated finite sum, and `berezinGaussian M := (exp (-S)) univ`.
   (b) Mathlib `ExteriorAlgebra R (Fin (2*n) -> R)` with the Berezin integral
       as extraction of the top graded piece `exteriorPower R (2*n) ...`. This
       is more canonical but the top-coefficient extraction is fiddly; only
       take this route if you find it genuinely cleaner.
2. State and PROVE the finite Matthews-Salam identity
   `berezinGaussian M = M.det`
   for all `n` and all `M : Matrix (Fin n) (Fin n) R` over your chosen `R`.
   The mathematical content is the bijection between top-monomial contributions
   of `exp(-S)` and permutations `sigma : Perm (Fin n)`, matching signs; the
   `= det` step is then `Matrix.det_apply` (or `det_apply'`).
3. Sanity: confirm your definition reproduces the oracle's fixed cases -
   `n = 1`: `berezinGaussian !![c] = c`; `n = 2`: `berezinGaussian !![a,b;c,d]
   = a*d - b*c`. A `decide`/`native_decide`-free `by norm_num`/`by simp` check
   on these small cases is a good regression guard (but the general theorem must
   NOT use `decide` - it quantifies over arbitrary `n`).

BUILD BUDGET: run `lake env lean Qmf3Berezin/MatthewsSalam.lean` first; do not
start with a broad build.

## Scaffold

The file below fixes the convention as Lean definitions (route (a)) and leaves
the main identity as the single documented `s o r r y`. You may keep this model,
replace it with route (b), or refine the definitions - but if you change the
convention you MUST justify why and confirm it still matches the oracle's pinned
sign (e.g. `n=2` gives `a*d - b*c`, not `b*c - a*d`).
-/

open scoped BigOperators

namespace Qmf3Berezin

variable {R : Type*} [CommRing R]

/-- The shuffle sign incurred by merging the ascending product of `s` with the
ascending product of `t` into ascending order: `(-1)` to the number of
"inversions" `(a, b)` with `a in s`, `b in t`, and `b < a`. -/
def shuffleSign {k : ℕ} (s t : Finset (Fin k)) : ℤ :=
  (-1) ^ (((s ×ˢ t).filter (fun p => p.2 < p.1)).card)

/-- A finite Grassmann-algebra element on `k` generators: a coefficient on each
ascending monomial (indexed by the subset of generators it contains). -/
abbrev GrassmannElem (k : ℕ) (R : Type*) := Finset (Fin k) → R

/-- Grassmann multiplication in ascending-canonical form. Disjoint monomials
merge with `shuffleSign`; overlapping monomials multiply to zero. -/
noncomputable def gmul {k : ℕ} (a b : GrassmannElem k R) : GrassmannElem k R :=
  fun u =>
    ∑ s ∈ u.powerset, ∑ t ∈ u.powerset,
      if s ∪ t = u ∧ Disjoint s t then (shuffleSign s t : R) * a s * b t else 0

/-- The Grassmann unit (scalar `1`, supported on the empty monomial). -/
noncomputable def gone {k : ℕ} : GrassmannElem k R :=
  fun u => if u = ∅ then 1 else 0

/-- `k`-fold Grassmann power. -/
noncomputable def gpow {k : ℕ} (a : GrassmannElem k R) : ℕ → GrassmannElem k R
  | 0 => gone
  | (m + 1) => gmul (gpow a m) a

/-- The generating bilinear `S = sum_{i,j} thetabar_i * M_ij * theta_j`, with
`thetabar_i` the generator `2i+1` and `theta_j` the generator `2j`, written into
the `Fin (2*n)` Grassmann algebra. Each term `(i,j)` contributes to the 2-element
monomial `{2i+1, 2j}` with coefficient `M i j` times the ascending shuffle sign
of `thetabar_i` before `theta_j`; distinct `(i,j)` give distinct monomials (odd
index fixes `i`, even index fixes `j`), so there is no cross-term collision. -/
noncomputable def bilinear {n : ℕ} (M : Matrix (Fin n) (Fin n) R) :
    GrassmannElem (2 * n) R :=
  fun u =>
    ∑ i : Fin n, ∑ j : Fin n,
      if u = ({⟨2 * (i : ℕ) + 1, by omega⟩, ⟨2 * (j : ℕ), by omega⟩} :
                Finset (Fin (2 * n)))
        then M i j * (shuffleSign
              ({⟨2 * (i : ℕ) + 1, by omega⟩} : Finset (Fin (2 * n)))
              ({⟨2 * (j : ℕ), by omega⟩} : Finset (Fin (2 * n))) : R)
        else 0

/-- `exp(a)` truncated at degree `2n` (safe: products of `> 2n` generators
vanish), as `sum_{p=0}^{bound} a^p / p!`. Needs `p!` invertible, so this
`noncomputable` form uses `Ring.inverse`; over a `Q`-algebra it is exact. -/
noncomputable def gexp {k : ℕ} (bound : ℕ) (a : GrassmannElem k R) :
    GrassmannElem k R :=
  fun u => ∑ p ∈ Finset.range (bound + 1),
    (Ring.inverse (p.factorial : R)) * (gpow a p u)

/-- The Berezin-Gaussian integral: the coefficient of the top reference monomial
`Finset.univ` in `exp(- bilinear M)`. -/
noncomputable def berezinGaussian {n : ℕ} (M : Matrix (Fin n) (Fin n) R) : R :=
  gexp (2 * n) (fun u => - bilinear M u) (Finset.univ : Finset (Fin (2 * n)))

/-- **QMF3 target - the finite Matthews-Salam identity.**
The Berezin-Gaussian integral over `2n` Grassmann generators of
`exp(- thetabar M theta)` equals `det M`, for every finite `n` and every
`M`, over a characteristic-zero commutative ring (so the factorial inverses in
`gexp` are exact). This is the finite, kernel-checkable core of the
fermionic-determinant / Matthews-Salam identity, with NO analysis or continuum
content.

Proof handoff: match top-monomial contributions of `exp(- bilinear M)` to
permutations `sigma : Perm (Fin n)` (each contributes one factor `thetabar_i
theta_{sigma i}` per `i`, using every generator exactly once), track the
`shuffleSign` product against `Equiv.Perm.sign`, and close with
`Matrix.det_apply'`. The convention is oracle-pinned
(`Scripts/oracle/validate_berezin.py`, `n = 1..4`): `n = 2` must give
`a*d - b*c`. -/
theorem berezinGaussian_eq_det {n : ℕ} [Algebra ℚ R]
    (M : Matrix (Fin n) (Fin n) R) :
    berezinGaussian M = M.det := by
  sorry

end Qmf3Berezin
