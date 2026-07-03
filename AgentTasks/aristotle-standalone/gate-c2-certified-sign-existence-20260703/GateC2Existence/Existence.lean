import Mathlib

/-!
# Gate C2: EXISTENCE of a certified overlap sign (Aristotle proof target)

This is a focused, self-contained PROOF target for Aristotle. It closes the
"existence" half of the finite overlap sign-certificate story (the uniqueness
half is already proved in the main repo as `certifiedSign_unique`).

## Definitions and the target

For complex `n x n` matrices, a **sign certificate** for a matrix `H` is a matrix
`eps` that is an involution, commutes with `H`, and has `eps * H` positive
semidefinite (these are the finite, functional-calculus-free defining properties
of `sign(H) = H |H|^{-1}`).

The goal is to prove that a certificate EXISTS for every gapped (invertible)
Hermitian `H`, by exhibiting the explicit candidate

    epsCFC H := CFC.sqrt (H ^ 2) * (⅟H)              -- i.e. |H| * H⁻¹

and proving `SignCertificate H (epsCFC H)`.

## Proof strategy (please complete `certifiedSign_exists`)

Let `A := CFC.sqrt (H ^ 2)` (this is `|H|`). Key facts, all in Mathlib under the
matrix Loewner order (activate the local instances as done below):

* `H ^ 2` is positive semidefinite: `H^2 = Hᴴ * H` since `H` is Hermitian
  (`Matrix.posSemidef_conjTranspose_mul_self`), so `((H^2)).PosSemidef`.
* `A ^ 2 = H ^ 2`  (`Matrix.PosSemidef.sq_sqrt` / `CFC.sq_sqrt` on `H^2`).
* `A` is positive semidefinite (`Matrix.PosSemidef.posSemidef_sqrt`).
* `A` COMMUTES with `H`: `A = CFC.sqrt (H^2)` is a continuous-functional-calculus
  function of `H^2`, and `H` commutes with `H^2`, so `Commute A H`
  (look for `Commute` + `cfc` / `CFC.sqrt` commutation lemmas, e.g. a
  `Commute.cfc`-style result, or derive it from `A` being a polynomial/limit in
  `H^2`). This is the one genuinely nontrivial step.

Then for `epsCFC H = A * ⅟H`:

* **commute** `epsCFC H * H = H * epsCFC H`: both equal `A`. Indeed
  `A * ⅟H * H = A` (`mul_invOf_cancel_right`-style), and
  `H * (A * ⅟H) = A * (H * ⅟H) = A` using `Commute A H` and `mul_invOf_self`.
* **posSemidef** `(epsCFC H * H).PosSemidef`: `epsCFC H * H = A`, which is PSD.
* **involution** `epsCFC H * epsCFC H = 1`: `A * ⅟H * (A * ⅟H) = A * A * ⅟H * ⅟H`
  (using `Commute A (⅟H)`, which follows from `Commute A H`) `= (A^2) * (⅟H)^2 =
  H^2 * (⅟(H^2)) = 1`. Use `A^2 = H^2`, `(⅟H)^2 = ⅟(H^2)` (`invOf_pow` or
  `Invertible` API), and `mul_invOf_self`.

You will likely need, near the top of the proof section:

```
open scoped ComplexOrder
attribute [local instance] Matrix.instPartialOrder Matrix.instStarOrderedRing
  Matrix.instNonnegSpectrumClass
```

If the `Commute (CFC.sqrt (H^2)) H` step is hard, an acceptable alternative is to
prove existence via any explicit self-adjoint involutive square root construction
you can certify, as long as the final theorem `certifiedSign_exists` (statement
unchanged) is proved with no `sorry`, no `native_decide`, and axiom footprint
`[propext, Classical.choice, Quot.sound]`.

Do NOT change the statement of `SignCertificate` or of `certifiedSign_exists`.
-/

noncomputable section

namespace GateC2Existence

open Matrix
open scoped ComplexOrder

attribute [local instance] Matrix.instPartialOrder Matrix.instStarOrderedRing
  Matrix.instNonnegSpectrumClass

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- A finite sign certificate for a Hermitian operator `H`: an involution
commuting with `H` whose product `eps * H` is positive semidefinite. -/
structure SignCertificate (H eps : Matrix n n ℂ) : Prop where
  involution : eps * eps = 1
  commute : eps * H = H * eps
  posSemidef : (eps * H).PosSemidef

/-- The explicit candidate certified sign `|H| * H⁻¹`. -/
def epsCFC (H : Matrix n n ℂ) [Invertible H] : Matrix n n ℂ :=
  CFC.sqrt (H ^ 2) * (⅟H)

/-- **EXISTENCE of a certified sign.**  For a gapped (invertible) Hermitian `H`,
the explicit candidate `epsCFC H = |H| H⁻¹` is a sign certificate for `H`.
Together with the repo's `certifiedSign_unique` this shows the overlap sign is
well-defined for every gapped Hermitian `H`. -/
theorem certifiedSign_exists (H : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) :
    SignCertificate H (epsCFC H) := by
  sorry

end GateC2Existence
