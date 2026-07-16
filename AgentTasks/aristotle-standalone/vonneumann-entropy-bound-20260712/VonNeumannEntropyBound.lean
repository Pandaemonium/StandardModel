import Mathlib

/-!
# Von Neumann entropy bound: S(rho) <= log d (density-matrix max-entropy)

Aristotle target (quantum lift of the classical max-entropy theorem; resource
program). For a density matrix `rho` (Hermitian, positive semidefinite, unit
trace) on a finite nonempty Hilbert space of dimension `d = card n`, the von
Neumann entropy `S(rho) = -sum_i lambda_i log lambda_i` (over the eigenvalues) is
at most `log d`, the maximum attained by the maximally-mixed state. This is the
matrix/quantum form of the finite Shannon max-entropy bound and the entropy
ceiling for the mass-as-entanglement / information-resource program. Stated
CFC-free: the entropy is the classical Shannon entropy of the eigenvalue vector,
so no matrix logarithm is needed.

Route (suggested): the eigenvalues of `rho` form a finite probability vector --
nonnegative because `rho` is PSD (`Matrix.PosSemidef.eigenvalues_nonneg` or the
`0 <= eigenvalues` API), and summing to one because the eigenvalue sum is the
trace (`Matrix.IsHermitian.sum_eigenvalues_eq_trace` / `trace_eq_sum_eigenvalues`
and `htr`). Then apply the finite Shannon max-entropy bound
`sum negMulLog p_i <= log d` for a probability vector (Gibbs against uniform /
concavity of `negMulLog` `Real.strictConcaveOn_negMulLog` with Jensen, or
`Real.sum_negMulLog_le` if available). Handle `0 * log 0 = 0` via
`Real.negMulLog`.

Run: `lake env lean VonNeumannEntropyBound.lean`. Close only the hole; keep the
definition and statement byte-identical.
-/

noncomputable section

namespace VonNeumannEntropyBound

open Matrix
open scoped ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Von Neumann entropy of a Hermitian matrix, as the Shannon entropy of its
eigenvalue vector: `S(rho) = sum_i negMulLog (lambda_i)`
(`negMulLog x = -x log x`, so `0 * log 0 = 0` is built in). -/
def vonNeumannEntropy (ρ : Matrix n n ℂ) (hρ : ρ.IsHermitian) : ℝ :=
  ∑ i, Real.negMulLog (hρ.eigenvalues i)

/-- **TARGET (the hole): von Neumann entropy bound.**  For a density matrix
(Hermitian, PSD, unit trace) on a nonempty finite space of dimension `d`, the von
Neumann entropy is at most `log d`. -/
theorem vonNeumann_le_log_card [Nonempty n] (ρ : Matrix n n ℂ)
    (hρ : ρ.IsHermitian) (hpsd : ρ.PosSemidef) (htr : ρ.trace = 1) :
    vonNeumannEntropy ρ hρ ≤ Real.log (Fintype.card n) := by
  sorry

end VonNeumannEntropyBound
