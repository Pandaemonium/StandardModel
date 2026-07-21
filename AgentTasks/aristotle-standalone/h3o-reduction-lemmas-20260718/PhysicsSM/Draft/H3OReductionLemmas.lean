import PhysicsSM.Algebra.Octonion.Norm
import Mathlib

/-!
# The two reduction lemmas for the h3(O) unconditional real-spectrum theorem

**Goal (context).** The parent repo has kernel-checked: (i) the characteristic
cubic of a 3x3 octonionic Hermitian matrix `X` (entries: reals
`alpha, beta, gamma` on the diagonal, octonions `x, y, z` off-diagonal) has
coefficients `trace = alpha + beta + gamma`,
`sigma = alpha*beta + beta*gamma + gamma*alpha - |x|^2 - |y|^2 - |z|^2`,
`det = alpha*beta*gamma - alpha*|x|^2 - beta*|y|^2 - gamma*|z|^2
       + 2*(x*(y*z)).c0`
(`|.|^2 = Octonion.normSq`, `.c0` = real part); (ii) a monic real cubic with
nonnegative discriminant has three real roots (Vieta form). The MISSING link
is: the octonionic data can be replaced by COMPLEX data with the same four
invariants, and the resulting complex Hermitian matrix has real eigenvalues.
These two lemmas close that link. They are INDEPENDENT of each other.

## Lemma 1 (`exists_complex_witness`): the complex witness

For any octonions `x y z` there are complex numbers `x' y' z'` with the same
three norms and the same real triple product:
`(x' * (y' * z')).re = (x * (y * z)).c0`.

Proof plan: take `y' = Real.sqrt (normSq y)`, `z' = Real.sqrt (normSq z)`
(real), and `x' = a + b*I` with `a = (x*(y*z)).c0 / (y'*z')` and
`b = Real.sqrt (normSq x - a^2)`. The key inequality `a^2 <= normSq x` follows
from `((x*(y*z)).c0)^2 <= normSq (x*(y*z)) = normSq x * normSq y * normSq z`
(the composition law `PhysicsSM.Algebra.Octonion.normSq_mul`, available in
this package, applied twice; the real part is one of eight squares in
`normSq`). Degenerate cases `normSq y = 0` or `normSq z = 0` force
`(x*(y*z)).c0 = 0` (`normSq_eq_zero` then `mul_zero`/`zero_mul`), and the
witness `x' = Real.sqrt (normSq x)` works.

## Lemma 2 (`hermitian_cubic_real_rooted`): the Mathlib Hermitian reduction

For real `alpha beta gamma` and complex `x' y' z'` there exist three REAL
numbers `r s t` whose elementary symmetric functions are exactly the
invariant triple above (with `Complex.normSq` and `(x'*(y'*z')).re`).

Proof plan: form the complex Hermitian matrix
`M = !![alpha, z', conj y'; conj z', beta, x'; y', conj x', gamma]`
(this layout makes the (2,3) entry `x'`, the (3,1) entry `y'`, the (1,2)
entry `z'`; verify Hermitian-ness by `ext`/`decide`-style entry checks). Use
Mathlib's `Matrix.IsHermitian.eigenvalues` (real eigenvalues, spectral
theorem) and identify the elementary symmetric functions of the eigenvalues
with `Matrix.trace M`, the second coefficient, and `Matrix.det M` via the
characteristic polynomial (`Matrix.det_fin_three`, `Matrix.trace_fin_three`,
charpoly coefficient extraction). If the determinant expansion produces
`2*(z' * (conj y') * ...).re` or another conjugation pattern instead of the
stated `2*(x' * (y' * z')).re`, DO NOT force it: adjust the matrix layout
(transpose / relabel entries / conjugate an entry) until the stated target
combination appears - the free layout choice is exactly why the lemma is
stated with this specific expression. If NO layout produces it, prove the
version with the true expression and REPORT the discrepancy prominently
(honest outcome; the parent repo's phase-freedom in Lemma 1 can absorb a
conjugation).

## Constraints

- No `a x i o m` / `o p a q u e` / `u n s a f e` / `n a t i v e _ d e c i d e`;
  standard axioms only (`propext`, `Classical.choice`, `Quot.sound`).
- Do not change the statements except as licensed above for Lemma 2's
  conjugation pattern (with a report).
- The two lemmas are independent: prove both; if one resists, complete the
  other fully.
-/

noncomputable section

namespace PhysicsSM.Draft.H3OReductionLemmas

open PhysicsSM.Algebra.Octonion

/-- **Lemma 1: the complex witness.** Any octonion triple can be replaced by
a complex triple with the same three norms and the same real triple product. -/
theorem exists_complex_witness (x y z : Octonion) :
    ∃ x' y' z' : ℂ,
      Complex.normSq x' = normSq x ∧
      Complex.normSq y' = normSq y ∧
      Complex.normSq z' = normSq z ∧
      (x' * (y' * z')).re = (x * (y * z)).c0 := by
  sorry

/-- **Lemma 2: the Hermitian reduction.** The invariant triple of a complex
Hermitian `3x3` matrix is realized by three REAL numbers (its eigenvalues):
there exist `r s t : ℝ` whose elementary symmetric functions equal the
trace, sigma, and determinant combinations of the Hermitian data. -/
theorem hermitian_cubic_real_rooted (alpha beta gamma : ℝ) (x' y' z' : ℂ) :
    ∃ r s t : ℝ,
      r + s + t = alpha + beta + gamma ∧
      r * s + r * t + s * t
        = alpha * beta + beta * gamma + gamma * alpha
          - Complex.normSq x' - Complex.normSq y' - Complex.normSq z' ∧
      r * s * t
        = alpha * beta * gamma - alpha * Complex.normSq x'
          - beta * Complex.normSq y' - gamma * Complex.normSq z'
          + 2 * (x' * (y' * z')).re := by
  sorry

end PhysicsSM.Draft.H3OReductionLemmas
