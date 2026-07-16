import Mathlib

/-!
# Quantum Klein inequality, commuting / shared-eigenbasis case

Draft module. The matrix lift of the landed classical Gibbs inequality
(`FiniteGibbsInequality`): a commuting / shared-eigenbasis quantum nonnegativity
rung for the gravity-DPI program (`GRAV-DPI-001`). It is NOT the general quantum
Q1 / data-processing gate -- no quantum channel or coarse-graining map appears
(see Scope). Mathlib v4.28 has no `Matrix.log`, and the CFC route hits
`NormedRing (Matrix n n C)` instance friction; this module sidesteps both by
treating the tractable commuting case, where the two density matrices share an
eigenbasis `V` and the logarithm is given by construction
`log rho = V diag(log p) Vᴴ`.

For a unitary `V` (`Vᴴ V = 1`) and probability-vector eigenvalues `p, q` (`p`
nonnegative, `q` strictly positive, both summing to 1), the co-diagonalizable
density matrices `rho = V diag(p) Vᴴ`, `sigma = V diag(q) Vᴴ` have nonnegative
quantum relative entropy `S(rho||sigma) = Tr(rho (log rho - log sigma)) >= 0`.

## Scope (anti-overclaim)

This is the commuting / shared-eigenbasis special case only: `rho` and `sigma`
are co-diagonalized by the same unitary `V`. It is NOT the general
non-commuting quantum Klein inequality (which needs the matrix functional
calculus this module deliberately avoids). `logOf V p` is the genuine matrix
logarithm only because `V` is unitary and the eigenvalues are supplied. No
gravity channel, data-processing map, or physical Hilbert-space interpretation
is claimed here; this is the finite algebraic nonnegativity result that a later
gravity-DPI item may compose with a physically derived coarse-graining channel.

## Trust status

Draft-trust by kernel: `qKlein_nonneg` is `sorry`-free and depends only on
`[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard block at the end.

## Provenance

Statement authored in-project (AFPL run 2026-07-12, DYN-MODULAR/GRAV-DPI
information-theory line). Proof search by Aristotle (project
`71655acc-3b69-4601-91b2-75e9e671836a`), then independently re-checked in this
repo (`lake env lean`; axiom footprint confirmed kernel-only). Route: expand the
trace with `Vᴴ V = 1` and trace cyclicity to reduce `qRelEntropy V p q` to the
scalar `∑ i, p i * (log p i - log q i)`, which is nonnegative by Gibbs'
inequality (`Real.log_le_sub_one_of_pos` applied to `q i / p i`; the `p i = 0`
terms are handled by the `0 * log 0 = 0` convention). Clean-room formalization
from the mathematical statement.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.QuantumKleinShared

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
sharing eigenbasis `V`: `S(rho||sigma) = Tr(rho (log rho - log sigma))`. -/
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

/-- **Quantum Klein inequality (commuting case).**  The quantum relative entropy
of two co-diagonalizable density matrices is nonnegative. -/
theorem qKlein_nonneg (V : Matrix n n ℂ) (hV : Vᴴ * V = 1)
    (p q : n → ℝ) (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i)
    (hps : ∑ i, p i = 1) (hqs : ∑ i, q i = 1) :
    0 ≤ qRelEntropy V p q := by
  rw [qRelEntropy_eq_sum V hV p q]
  exact gibbs_sum p q hp hq hps hqs

end PhysicsSM.Draft.NullEdge.QuantumKleinShared

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.QuantumKleinShared.qKlein_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QuantumKleinShared.qKlein_nonneg
