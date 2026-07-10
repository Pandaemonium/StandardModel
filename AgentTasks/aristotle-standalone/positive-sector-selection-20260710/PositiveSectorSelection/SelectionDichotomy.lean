import Mathlib

/-!
# Positive-sector selection: the Pontryagin dichotomy in signature (1,1)

The program's positive-sector witnesses show that a physical Hilbert space
requires CHOOSING a maximal positive decoder-invariant subspace, and the
matched sign no-go shows the choice is genuinely model data.  This package
proves the SELECTION PRINCIPLE in the smallest indefinite case, signature
`(1,1)` (`J = diag(1,-1)` on `ℂ²`): for a Krein-self-adjoint decoder, a
positive invariant direction exists precisely when the decoder's spectrum is
real with a genuine gap — and when the spectrum is nonreal, EVERY invariant
direction is Krein-neutral, so positive selection is impossible.  Spectral
reality is the selection criterion.

## The computation (hand-verified before submission)

`J`-self-adjoint means `J * D = Dᴴ * J`, forcing `D = !![a, b; -conj b, d]`
with `a, d` real.  The eigenvalue discriminant is
`Δ = ((a - d)/2)^2 - |b|^2`.  For an eigenvector `v = (b, λ - a)` the Krein
norm is `N(λ) = |b|^2 - (λ - a)^2`, and using
`(λ₊ - a)(λ₋ - a) = |b|^2` one computes
`N(λ₊) * N(λ₋) = |b|^2 * (4|b|^2 - (a - d)^2) < 0` when `Δ > 0`, `b ≠ 0`:
the two eigendirections have OPPOSITE Krein signs — exactly one positive
invariant line.  When the spectrum is nonreal, eigendirections are
`J`-neutral (the standard Krein argument: `(λ - conj λ) <v, v>_J = 0`).

## Targets

1. `jsa_normal_form` — the two-way characterization of
   `J`-self-adjointness: `J * D = Dᴴ * J` iff `D = !![a, b; -conj b, d]`
   with `a, d` real.
2. `positive_selection_exists` — when `4 |b|^2 < (a - d)^2` and `b ≠ 0`, an
   eigenvector with strictly positive Krein norm exists: selection
   SUCCEEDS above the gap.
3. `nonreal_forces_neutral` — for `J`-self-adjoint `D`, any eigenvector
   with nonreal eigenvalue has vanishing Krein norm: selection FAILS off
   the real axis.
4. `witness_positive` — the exact rational witness `Dnf 2 0 (3/5)`:
   eigenpairs `(9/5, (3/5, -1/5))` with Krein norm `8/25 > 0` and
   `(1/5, (3/5, -9/5))` with Krein norm `-72/25 < 0` — opposite signs,
   one positive line (all clauses hand-checked entrywise).
5. `witness_neutral` — the rotation `!![0, 1; -1, 0]` is `J`-self-adjoint
   with eigenvalue `i` and its eigenvector `(1, i)` is exactly
   Krein-neutral.

Honest scope: the `(1,1)` two-dimensional case — the first rung of finite
Pontryagin-space selection theory, not the general theorem; composing with
the carrier's physical quotient is follow-up work.  Do not weaken the
statements.  Helper lemmas welcome.  Run
`lake env lean PositiveSectorSelection/SelectionDichotomy.lean` first.
-/

namespace PositiveSectorSelection

open Matrix

/-- The signature-(1,1) Krein involution. -/
def Jm : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- Krein norm of a vector. -/
noncomputable def kreinNorm (v : Fin 2 → ℂ) : ℂ := star v ⬝ᵥ Jm.mulVec v

/-- Target 1: the normal form of `J`-self-adjoint operators. -/
theorem jsa_normal_form (D : Matrix (Fin 2) (Fin 2) ℂ) :
    Jm * D = Dᴴ * Jm ↔
      ∃ (a d : ℝ) (b : ℂ),
        D = !![(a : ℂ), b; -(starRingEnd ℂ) b, (d : ℂ)] := by
  sorry

/-- The normal-form operator. -/
noncomputable def Dnf (a d : ℝ) (b : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(a : ℂ), b; -(starRingEnd ℂ) b, (d : ℂ)]

/-- Target 2: above the spectral gap, a strictly positive invariant
eigendirection exists (selection succeeds). -/
theorem positive_selection_exists (a d : ℝ) (b : ℂ) (hb : b ≠ 0)
    (hgap : 4 * Complex.normSq b < (a - d) ^ 2) :
    ∃ (lam : ℝ) (v : Fin 2 → ℂ), v ≠ 0 ∧
      (Dnf a d b).mulVec v = (lam : ℂ) • v ∧
      0 < (kreinNorm v).re ∧ (kreinNorm v).im = 0 := by
  sorry

/-- Target 3: nonreal spectrum forces neutrality — every eigendirection of
a `J`-self-adjoint operator with nonreal eigenvalue has vanishing Krein
norm: positive selection is impossible. -/
theorem nonreal_forces_neutral (D : Matrix (Fin 2) (Fin 2) ℂ)
    (hD : Jm * D = Dᴴ * Jm) (lam : ℂ) (hlam : lam.im ≠ 0)
    (v : Fin 2 → ℂ) (hv : D.mulVec v = lam • v) :
    kreinNorm v = 0 := by
  sorry

/-- Target 4: the exact rational witness (the 3-4-5 scale).  For
`Dnf 2 0 (3/5)` the eigenvalues are `9/5` and `1/5` with eigenvectors
`(3/5, -1/5)` and `(3/5, -9/5)`; their Krein norms are `8/25 > 0` and
`-72/25 < 0`: opposite signs, exactly one positive invariant line. -/
theorem witness_positive :
    (Dnf 2 0 (3 / 5)).mulVec ![3 / 5, -(1 / 5)] =
      ((9 / 5 : ℝ) : ℂ) • ![3 / 5, -(1 / 5)] ∧
    kreinNorm ![3 / 5, -(1 / 5)] = 8 / 25 ∧
    (Dnf 2 0 (3 / 5)).mulVec ![3 / 5, -(9 / 5)] =
      ((1 / 5 : ℝ) : ℂ) • ![3 / 5, -(9 / 5)] ∧
    kreinNorm ![3 / 5, -(9 / 5)] = -(72 / 25) := by
  sorry

/-- Target 5: the neutral witness — the rotation has nonreal spectrum and
its eigenvector `(1, i)` is exactly Krein-neutral. -/
theorem witness_neutral :
    Jm * !![0, 1; -1, 0] =
      (!![0, 1; -1, 0] : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * Jm ∧
    (!![0, 1; -1, 0] : Matrix (Fin 2) (Fin 2) ℂ).mulVec ![1, Complex.I] =
      Complex.I • ![1, Complex.I] ∧
    kreinNorm ![1, Complex.I] = 0 := by
  sorry

end PositiveSectorSelection
