/-
# Finite Banks-Casher count identity (K5 / roadmap S4a)

DRAFT (kernel-clean; no `s o r r y`). The overnight all-mass run's K5,
per QCD-roadmap Amendment A4 and SevenChallenges finding 6: a FINITE,
fixed-background, spectral-rail-safe form of the Banks-Casher relation -
an exact matrix-trace identity with no spectral measure, no thermodynamic
limit, no positivity assumption.

## The chain

For a skew-Hermitian matrix `A` (`Aᴴ = -A`; the stereographically
transformed finite Ginsparg-Wilson operator, eigenvalues `i lambda_j`)
and a real regulator `m` with `m . 1 +- A` invertible:

* `invOf_add_invOf` (pure algebra, any ring): `⅟P + ⅟Q = ⅟P (P+Q) ⅟Q`.
* `resolvent_sum` / `resolvent_sum_trace`: with `P = m+A`, `Q = m-A`
  (so `P+Q = 2m` central), `⅟P + ⅟Q = 2m . ⅟(Q P)`, and its trace.
* `skew_prod`: `(m-A)(m+A) = m² . 1 + Aᴴ A` (positive definite; the
  "denominator" - so `⅟(Q P) = ⅟(m² + Aᴴ A)`, the smooth count operator).
* `skew_resolvent_conj`: `Tr ⅟(m-A) = conj (Tr ⅟(m+A))`, so the left side
  of the trace identity is `Tr ⅟(m+A) + conj Tr ⅟(m+A) = 2 Re Tr ⅟(m+A)`.
* `banks_casher_count` (headline): therefore
  `Tr ⅟(m+A) + conj Tr ⅟(m+A) = 2m . Tr ⅟((m-A)(m+A))`,
  i.e. `2 Re Tr ⅟(m+A) = 2m Tr ⅟(m² + Aᴴ A)` (`skew_prod`), i.e.
  `m V Sigma_m = N_m` with `Sigma_m = (1/V) Re Tr ⅟(m+A)` and
  `N_m = Tr(m² ⅟(m² + Aᴴ A)) = sum_j m²/(m²+lambda_j²)`.

Whole proof is invertible-element algebra plus `star (⅟x) = ⅟(star x)`;
no eigenvalues, no spectral theorem.

## Reading and claim boundary

`Re Tr ⅟(m+A)` is the finite regularized condensate (up to `1/V`);
`Tr(m² ⅟(m²+Aᴴ A))` is the finite smooth near-zero count (`m²+Aᴴ A` is
positive definite; each eigenvalue contributes `m²/(m²+lambda²) in (0,1]`,
`-> 1` as `lambda -> 0`). Finite, FIXED background - NOT the
infinite-volume Banks-Casher theorem, not a density of states, not a
chiral-limit statement. The GW exceptional-mode (`D = 2`) caveat is
upstream: `A` is assumed already on the nonexceptional subspace.

## Provenance

Banks-Casher (1980) for the physics relation - [import]; the finite
resolvent form was proposed in the SevenChallenges memo (2026-07-08,
finding 6) and roadmap Amendment A4 - [comp]. Sits over
`GateYM/BanksCasherShadow.lean` (the GW-circle facts).
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.GateYM.FiniteBanksCasherCount

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **Resolvent sum (pure invertible algebra).** For invertible `P, Q` in a
ring, `⅟P + ⅟Q = ⅟P * (P + Q) * ⅟Q`. No commutativity needed. -/
theorem invOf_add_invOf {R : Type*} [Ring R] (P Q : R)
    [Invertible P] [Invertible Q] :
    ⅟P + ⅟Q = ⅟P * (P + Q) * ⅟Q := by
  rw [mul_add, add_mul, invOf_mul_self, one_mul, mul_assoc (⅟P) Q (⅟Q),
    mul_invOf_self, mul_one, add_comm]

/-- **Central resolvent collapse.** If `P + Q = c` with `c` central, then
`⅟P + ⅟Q = c * ⅟(Q * P)`. -/
theorem invOf_add_eq_central_mul {R : Type*} [Ring R] (P Q c : R)
    [Invertible P] [Invertible Q] [Invertible (Q * P)]
    (hc : P + Q = c) (hcentral : ∀ x : R, c * x = x * c) :
    ⅟P + ⅟Q = c * ⅟(Q * P) := by
  rw [invOf_add_invOf P Q, hc]
  calc ⅟P * c * ⅟Q = c * ⅟P * ⅟Q := by rw [(hcentral (⅟P)).symm]
    _ = c * (⅟P * ⅟Q) := by rw [mul_assoc]
    _ = c * ⅟(Q * P) := by rw [← invOf_mul]

/-- **The resolvent identity.** With `P = m + A`, `Q = m - A`
(`P + Q = 2m` central), the resolvent sum collapses to `2m . ⅟(Q P)`. -/
theorem resolvent_sum (A : Matrix n n ℂ) (m : ℂ)
    [Invertible (m • (1 : Matrix n n ℂ) + A)]
    [Invertible (m • (1 : Matrix n n ℂ) - A)]
    [Invertible ((m • (1 : Matrix n n ℂ) - A)
        * (m • (1 : Matrix n n ℂ) + A))] :
    ⅟(m • (1 : Matrix n n ℂ) + A) + ⅟(m • (1 : Matrix n n ℂ) - A)
      = (2 * m) • ⅟((m • (1 : Matrix n n ℂ) - A)
          * (m • (1 : Matrix n n ℂ) + A)) := by
  have hc : (m • (1 : Matrix n n ℂ) + A) + (m • (1 : Matrix n n ℂ) - A)
      = (2 * m) • (1 : Matrix n n ℂ) := by
    rw [show (2 * m) = m + m by ring, add_smul]; abel
  have hcentral : ∀ X : Matrix n n ℂ,
      ((2 * m) • (1 : Matrix n n ℂ)) * X = X * ((2 * m) • (1 : Matrix n n ℂ)) := by
    intro X; rw [smul_mul_assoc, one_mul, mul_smul_comm, mul_one]
  rw [invOf_add_eq_central_mul _ _ _ hc hcentral, smul_mul_assoc, one_mul]

/-- **Trace form of the resolvent identity.** -/
theorem resolvent_sum_trace (A : Matrix n n ℂ) (m : ℂ)
    [Invertible (m • (1 : Matrix n n ℂ) + A)]
    [Invertible (m • (1 : Matrix n n ℂ) - A)]
    [Invertible ((m • (1 : Matrix n n ℂ) - A)
        * (m • (1 : Matrix n n ℂ) + A))] :
    (⅟(m • (1 : Matrix n n ℂ) + A)).trace
        + (⅟(m • (1 : Matrix n n ℂ) - A)).trace
      = (2 * m) • (⅟((m • (1 : Matrix n n ℂ) - A)
          * (m • (1 : Matrix n n ℂ) + A))).trace := by
  rw [← Matrix.trace_add, resolvent_sum, Matrix.trace_smul]

/-- **The resolvent denominator is `m² + Aᴴ A`** (positive definite for
real `m`): `(m - A)(m + A) = m² . 1 + Aᴴ A` when `Aᴴ = -A`. So the count
operator `⅟(Q P)` is `⅟(m² + Aᴴ A)`. -/
theorem skew_prod (A : Matrix n n ℂ) (m : ℂ) (hskew : Aᴴ = -A) :
    (m • (1 : Matrix n n ℂ) - A) * (m • (1 : Matrix n n ℂ) + A)
      = (m ^ 2) • (1 : Matrix n n ℂ) + Aᴴ * A := by
  have hexpand : (m • (1 : Matrix n n ℂ) - A) * (m • (1 : Matrix n n ℂ) + A)
      = (m * m) • (1 : Matrix n n ℂ) - A * A := by
    rw [sub_mul, mul_add, mul_add, smul_mul_smul_comm, mul_one,
      smul_mul_assoc, mul_smul_comm, mul_one, one_mul]
    abel
  rw [hexpand, hskew, neg_mul, ← sub_eq_add_neg, sq]

/-- For real `m`, the `m - A` resolvent trace is the conjugate of the
`m + A` resolvent trace (`Aᴴ = -A` makes `m - A = (m + A)ᴴ`), so the left
side of the trace identity is `2 Re Tr ⅟(m + A)`. -/
theorem skew_resolvent_conj (A : Matrix n n ℂ) (m : ℝ) (hskew : Aᴴ = -A)
    [Invertible ((m : ℂ) • (1 : Matrix n n ℂ) + A)]
    [Invertible ((m : ℂ) • (1 : Matrix n n ℂ) - A)] :
    (⅟((m : ℂ) • (1 : Matrix n n ℂ) - A)).trace
      = (starRingEnd ℂ) (⅟((m : ℂ) • (1 : Matrix n n ℂ) + A)).trace := by
  have hconj : ((m : ℂ) • (1 : Matrix n n ℂ) + A)ᴴ
      = (m : ℂ) • (1 : Matrix n n ℂ) - A := by
    rw [conjTranspose_add, conjTranspose_smul, conjTranspose_one, hskew,
      Complex.star_def, Complex.conj_ofReal, sub_eq_add_neg]
  -- (⅟(m+A))ᴴ is a left inverse of (m-A) = (m+A)ᴴ, hence equals ⅟(m-A)
  have hleft : (⅟((m : ℂ) • (1 : Matrix n n ℂ) + A))ᴴ
      * ((m : ℂ) • (1 : Matrix n n ℂ) - A) = 1 := by
    rw [← hconj, ← conjTranspose_mul, mul_invOf_self, conjTranspose_one]
  have hinv : ⅟((m : ℂ) • (1 : Matrix n n ℂ) - A)
      = (⅟((m : ℂ) • (1 : Matrix n n ℂ) + A))ᴴ := invOf_eq_left_inv hleft
  rw [hinv, Matrix.trace_conjTranspose, starRingEnd_apply]

/-- **Finite Banks-Casher count identity (headline).** For skew-Hermitian
`A` and real `m` with the resolvents invertible,

`Tr ⅟(m + A) + conj Tr ⅟(m + A) = 2m . Tr ⅟((m - A)(m + A))`,

whose left side is `2 Re Tr ⅟(m + A)` (the regularized condensate `Sigma_m`
up to `1/V`) and whose denominator is `m² + Aᴴ A` (`skew_prod`), giving the
smooth near-zero count `N_m`. A finite trace identity - `m V Sigma_m = N_m` -
spectral-rail safe. -/
theorem banks_casher_count (A : Matrix n n ℂ) (m : ℝ) (hskew : Aᴴ = -A)
    [Invertible ((m : ℂ) • (1 : Matrix n n ℂ) + A)]
    [Invertible ((m : ℂ) • (1 : Matrix n n ℂ) - A)]
    [Invertible (((m : ℂ) • (1 : Matrix n n ℂ) - A)
        * ((m : ℂ) • (1 : Matrix n n ℂ) + A))] :
    (⅟((m : ℂ) • (1 : Matrix n n ℂ) + A)).trace
        + (starRingEnd ℂ) (⅟((m : ℂ) • (1 : Matrix n n ℂ) + A)).trace
      = (2 * (m : ℂ)) • (⅟(((m : ℂ) • (1 : Matrix n n ℂ) - A)
          * ((m : ℂ) • (1 : Matrix n n ℂ) + A))).trace := by
  rw [← skew_resolvent_conj A m hskew]
  exact resolvent_sum_trace A (m : ℂ)

/-- Helper: the trace of the inverse of a Hermitian matrix is real. -/
theorem trace_invOf_real_of_herm {P : Matrix n n ℂ} [Invertible P]
    (hP : Pᴴ = P) : (starRingEnd ℂ) (⅟P).trace = (⅟P).trace := by
  have hleft : (⅟P)ᴴ * P = 1 := by
    have h : (P * ⅟P)ᴴ = 1 := by rw [mul_invOf_self, conjTranspose_one]
    rwa [conjTranspose_mul, hP] at h
  have hih : (⅟P)ᴴ = ⅟P := (invOf_eq_left_inv hleft).symm
  rw [starRingEnd_apply, ← Matrix.trace_conjTranspose, hih]

/-- **The count is a genuine real number.** The near-zero-count operator
`(m - A)(m + A) = m² + Aᴴ A` is Hermitian (for real `m`, skew-Hermitian
`A`), so its inverse is Hermitian and the count `Tr ⅟((m-A)(m+A)) = N_m/m²`
is real: `conj N = N`. (Non-negativity `0 ≤ N_m` additionally needs the
positive-definiteness of `m² + Aᴴ A`; recorded as a handoff. Reality alone
already licenses calling `N_m` a count rather than an algebraic
expression.) -/
theorem count_trace_real (A : Matrix n n ℂ) (m : ℝ) (hskew : Aᴴ = -A)
    [Invertible (((m : ℂ) • (1 : Matrix n n ℂ) - A)
        * ((m : ℂ) • (1 : Matrix n n ℂ) + A))] :
    (starRingEnd ℂ) (⅟(((m : ℂ) • (1 : Matrix n n ℂ) - A)
        * ((m : ℂ) • (1 : Matrix n n ℂ) + A))).trace
      = (⅟(((m : ℂ) • (1 : Matrix n n ℂ) - A)
        * ((m : ℂ) • (1 : Matrix n n ℂ) + A))).trace := by
  have h1 : ((m : ℂ) • (1 : Matrix n n ℂ) + A)ᴴ = (m : ℂ) • 1 - A := by
    rw [conjTranspose_add, conjTranspose_smul, conjTranspose_one, hskew,
      Complex.star_def, Complex.conj_ofReal, sub_eq_add_neg]
  have h2 : ((m : ℂ) • (1 : Matrix n n ℂ) - A)ᴴ = (m : ℂ) • 1 + A := by
    rw [conjTranspose_sub, conjTranspose_smul, conjTranspose_one, hskew,
      Complex.star_def, Complex.conj_ofReal, sub_neg_eq_add]
  exact trace_invOf_real_of_herm (by rw [conjTranspose_mul, h1, h2])

end PhysicsSM.Draft.NullEdge.GateYM.FiniteBanksCasherCount
