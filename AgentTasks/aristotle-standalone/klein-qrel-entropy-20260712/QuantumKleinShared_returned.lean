import Mathlib

/-!
# Quantum Klein inequality, commuting / shared-eigenbasis case

Aristotle target (the matrix lift of the landed classical Gibbs inequality, and
the true quantum Q1 gate for the gravity-DPI program). Mathlib v4.28 has no
`Matrix.log`, and the CFC route hits `NormedRing (Matrix n n C)` instance
friction; this module sidesteps both by treating the tractable commuting case,
where the two density matrices share an eigenbasis `V` and the logarithm is given
by construction `log rho = V diag(log p) Vᴴ`.

For a unitary `V` (`Vᴴ V = 1`) and probability-vector eigenvalues `p, q`
(`q` strictly positive), the co-diagonalizable density matrices
`rho = V diag(p) Vᴴ`, `sigma = V diag(q) Vᴴ` have nonnegative quantum relative
entropy `S(rho‖sigma) = Tr(rho (log rho - log sigma)) >= 0`.

Route (suggested): expand the trace with `Vᴴ V = 1` and `V Vᴴ = 1`
(`mul_eq_one_comm` for square matrices), telescoping the conjugations exactly as
in `OverlapGaugeCovarianceCapstone.Dov_conj`, plus `diagonal` multiplication
(`Matrix.diagonal_mul_diagonal`) and `Matrix.trace_diagonal`/cyclicity, to reduce
`qRelEntropy V p q` to the scalar `sum_i p_i * (log p_i - log q_i)
= sum_i p_i * log (p_i / q_i)`. That scalar is the finite relative entropy, which
is nonnegative by Gibbs' inequality (`Real.log_le_sub_one_of_pos` applied to
`q_i / p_i`, giving `sum p_i log(p_i/q_i) >= sum (p_i - q_i) = 0`; handle
`p_i = 0` via the `0 * log 0 = 0` convention). Do NOT use native_decide.

Run: `lake env lean QuantumKleinShared.lean`. Close only the hole; keep the
definitions and statement byte-identical.
-/

noncomputable section

namespace QuantumKleinShared

open Matrix
open scoped BigOperators

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Density matrix in the fixed eigenbasis `V`: `rho = V diag(p) Vᴴ`. -/
def rhoOf (V : Matrix n n ℂ) (p : n → ℝ) : Matrix n n ℂ :=
  V * diagonal (fun i => (p i : ℂ)) * Vᴴ

/-- The by-construction logarithm in the shared basis:
`log rho = V diag(log p) Vᴴ`. For `rho = rhoOf V p` with `V` unitary this is the
genuine matrix logarithm on the support. -/
def logOf (V : Matrix n n ℂ) (p : n → ℝ) : Matrix n n ℂ :=
  V * diagonal (fun i => (Real.log (p i) : ℂ)) * Vᴴ

/-- Quantum relative entropy for co-diagonalizable (commuting) density matrices
sharing eigenbasis `V`: `S(rho‖sigma) = Tr(rho (log rho - log sigma))`. -/
def qRelEntropy (V : Matrix n n ℂ) (p q : n → ℝ) : ℝ :=
  (rhoOf V p * (logOf V p - logOf V q)).trace.re

/-
Reduction of the trace to the scalar (finite) relative entropy.
-/
lemma qRelEntropy_eq_sum (V : Matrix n n ℂ) (hV : Vᴴ * V = 1) (p q : n → ℝ) :
    qRelEntropy V p q = ∑ i, p i * (Real.log (p i) - Real.log (q i)) := by
  convert congr_arg Complex.re ( congrArg Matrix.trace ( show rhoOf V p * ( logOf V p - logOf V q ) = V * diagonal ( fun i => ( p i : ℂ ) * ( Real.log ( p i ) - Real.log ( q i ) ) ) * Vᴴ from ?_ ) ) using 1;
  · have h_trace : Matrix.trace (V * diagonal (fun i => (p i : ℂ) * (Real.log (p i) - Real.log (q i))) * Vᴴ) = Matrix.trace (diagonal (fun i => (p i : ℂ) * (Real.log (p i) - Real.log (q i)))) := by
      rw [ Matrix.trace_mul_comm ];
      rw [ ← Matrix.mul_assoc, hV, Matrix.one_mul ];
    aesop;
  · simp +decide [ rhoOf, logOf, mul_sub, ← Matrix.mul_assoc ];
    simp +decide [ Matrix.mul_assoc, hV ];
    simp +decide [ ← mul_sub, ← Matrix.sub_mul ]

/-
Gibbs' inequality: the finite relative entropy is nonnegative.
-/
omit [DecidableEq n] in
lemma gibbs_sum (p q : n → ℝ) (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i)
    (hps : ∑ i, p i = 1) (hqs : ∑ i, q i = 1) :
    0 ≤ ∑ i, p i * (Real.log (p i) - Real.log (q i)) := by
  -- By Gibbs' inequality, we know that for each $i$, $p_i \log(p_i / q_i) \geq p_i - q_i$.
  have h_gibbs : ∀ i, p i * (Real.log (p i) - Real.log (q i)) ≥ p i - q i := by
    intro i
    by_cases hpi : p i = 0;
    · simpa [ hpi ] using hq i |> le_of_lt;
    · have := Real.log_le_sub_one_of_pos ( div_pos ( hq i ) ( lt_of_le_of_ne ( hp i ) ( Ne.symm hpi ) ) );
      rw [ Real.log_div ( ne_of_gt ( hq i ) ) hpi ] at this ; nlinarith [ hp i, hq i, mul_div_cancel₀ ( q i ) hpi ];
  exact le_trans ( by simp +decide [ hps, hqs ] ) ( Finset.sum_le_sum fun i _ => h_gibbs i )

/-- **TARGET (the hole): quantum Klein inequality (commuting case).**  The
quantum relative entropy of two co-diagonalizable density matrices is
nonnegative. -/
theorem qKlein_nonneg (V : Matrix n n ℂ) (hV : Vᴴ * V = 1)
    (p q : n → ℝ) (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i)
    (hps : ∑ i, p i = 1) (hqs : ∑ i, q i = 1) :
    0 ≤ qRelEntropy V p q := by
  rw [qRelEntropy_eq_sum V hV p q]
  exact gibbs_sum p q hp hq hps hqs

end QuantumKleinShared
