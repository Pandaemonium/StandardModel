import Mathlib

/-!
# Trace of a product of positive semidefinite matrices is nonnegative

Aristotle target. Prove `trace_mul_nonneg`: for positive semidefinite matrices
`A, B`, `0 ≤ re tr(A * B)`. This is a foundational, everywhere-used
quantum-information / gravity-resource lemma (expectation values, purity,
overlap bounds), and it is pure linear algebra -- no matrix exponential or
logarithm -- so it avoids the functional-calculus instance friction.

Route (suggested): write `B = C^H C` (`B` PSD has a Hermitian/`PosSemidef` square
root, or `B = Bᴴ B'` via `Matrix.PosSemidef.sqrt` / a factorization), so
`tr(A B) = tr(A Cᴴ C) = tr(C A Cᴴ)` by cyclicity; `C A Cᴴ` is PSD when `A` is
(`Matrix.PosSemidef.conjTranspose_mul_mul_same` or `mul_mul_conjTranspose_same`),
and a PSD matrix has real nonnegative trace (`Matrix.PosSemidef.trace_nonneg`).
Handle the `re` since the trace of a PSD matrix is a nonnegative real.

Run: `lake env lean PSDTraceNonneg.lean`. Close only the hole; keep the statement
byte-identical.
-/

noncomputable section

namespace PSDTraceNonneg

open Matrix
open scoped ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **TARGET (the hole).**  The real part of the trace of a product of positive
semidefinite matrices is nonnegative. -/
theorem trace_mul_nonneg (A B : Matrix n n ℂ)
    (hA : A.PosSemidef) (hB : B.PosSemidef) :
    0 ≤ (A * B).trace.re := by
  sorry

end PSDTraceNonneg
