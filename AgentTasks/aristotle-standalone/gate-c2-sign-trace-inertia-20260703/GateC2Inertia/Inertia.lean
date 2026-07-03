import Mathlib

/-!
# Gate C2: the certified sign's trace is the inertia of H (Aristotle proof target)

This is a focused, self-contained PROOF target. It is the single spectral lemma
that completes the "gauge overlap index from a signature" chain in the main repo:
combined with the already-proved
`overlapIndex gamma5 (epsCFC H) = (1/2)(sig gamma5 - sig(epsCFC H))`, it makes the
gauge chiral index computable directly from the eigenvalue-sign counts of the
gauge Wilson operator `H`, with NO functional calculus in the final index formula.

## Setup

For a gapped (invertible) Hermitian complex matrix `H`, the certified overlap sign
is `epsCFC H = CFC.sqrt (H ^ 2) * H⁻¹ = |H| H⁻¹` (this is `sign(H)`; in the main
repo it is proved to be a self-adjoint involution). Its trace is (informally) the
sum of `sign(eigenvalue)` over the spectrum, i.e. the **inertia** `n_+ - n_-` of
`H` (number of positive minus number of negative eigenvalues).

## The target

Prove `epsCFC_trace_eq_inertia` (statement fixed; complete the `sorry`): for a
gapped Hermitian `H`,

    (epsCFC H).trace
      = ((Finset.univ.filter fun i => 0 < hH.eigenvalues i).card : ℂ)
        - ((Finset.univ.filter fun i => hH.eigenvalues i < 0).card : ℂ)

where `hH : H.IsHermitian` and `hH.eigenvalues : n → ℝ` are Mathlib's real
eigenvalues. (Invertibility means no eigenvalue is `0`, so the two filtered sets
partition the index set.)

## Proof strategy

Diagonalize `H` by the spectral theorem (`Matrix.IsHermitian.spectral_theorem`):
`H = U diag(eigenvalues) Uᴴ` with `U` unitary. The continuous functional calculus
`CFC.sqrt (H^2)` is `U diag(|eigenvalues|) Uᴴ` (sqrt of `H^2 = U diag(eig^2) Uᴴ`),
so `epsCFC H = |H| H⁻¹ = U diag(|eig|) Uᴴ . U diag(eig)⁻¹ Uᴴ = U diag(|eig|/eig)
Uᴴ = U diag(sign(eig)) Uᴴ`. Then `trace(epsCFC H) = trace(diag(sign eig)) =
∑ i, sign(eigenvalues i) = (#positive) - (#negative)`.

Useful Mathlib: `Matrix.IsHermitian.spectral_theorem` / `.eigenvalues` /
`.eigenvectorUnitary`; `Matrix.trace` invariance under unitary conjugation
(`Matrix.trace_mul_comm`); `CFC.sqrt` on the diagonalized form, or work
eigenvalue-wise via `RCLike`/`Real.sign`. Activate the matrix Loewner order if
`CFC.sqrt` needs it: `open scoped ComplexOrder` +
`attribute [local instance] Matrix.instPartialOrder Matrix.instStarOrderedRing
Matrix.instNonnegSpectrumClass`.

If a fully spectral proof is heavy, an acceptable alternative is to prove the
equivalent `(epsCFC H).trace = ∑ i, Real.sign (hH.eigenvalues i)` (cast to ℂ) and
then a short lemma turning that sum into the filtered-cardinality difference; or
any kernel-checked proof of the UNCHANGED `epsCFC_trace_eq_inertia` statement.

Deliver: no `sorry`, no `native_decide`, axiom footprint
`[propext, Classical.choice, Quot.sound]`. Do not change the statement.
-/

noncomputable section

namespace GateC2Inertia

open Matrix
open scoped ComplexOrder

attribute [local instance] Matrix.instPartialOrder Matrix.instStarOrderedRing
  Matrix.instNonnegSpectrumClass

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- The certified overlap sign `|H| H⁻¹` of a gapped Hermitian `H`. -/
def epsCFC (H : Matrix n n ℂ) [Invertible H] : Matrix n n ℂ :=
  CFC.sqrt (H ^ 2) * (⅟H)

/-- **The certified sign's trace is the inertia of `H`.**  For a gapped Hermitian
`H`, `trace(sign H) = (#positive eigenvalues) - (#negative eigenvalues)`. -/
theorem epsCFC_trace_eq_inertia (H : Matrix n n ℂ) [Invertible H]
    (hH : H.IsHermitian) :
    (epsCFC H).trace
      = ((Finset.univ.filter fun i => 0 < hH.eigenvalues i).card : ℂ)
        - ((Finset.univ.filter fun i => hH.eigenvalues i < 0).card : ℂ) := by
  sorry

end GateC2Inertia
