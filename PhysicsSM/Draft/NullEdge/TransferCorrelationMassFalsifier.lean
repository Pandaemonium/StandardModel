import Mathlib

/-!
# Equal transfer spectrum can produce different raw correlations

The Euclidean/transfer-matrix branch of the origin-of-mass gap-to-pole
obstruction (AFPL gate A3/A4), companion to the landed resolvent-branch fact
`GapPoleResponseObstruction.gap_does_not_fix_pole` (Opus, 2026-07-20).

A composite/binding mass can be read from the exponential content of a
gauge-invariant two-point function `C(n) = ⟨v, Tⁿ v⟩` for a positive transfer
operator `T` and a physical observable `v`. Here one
fixed transfer operator `Tgap = diag(2,1)` (spectral gap `log 2`) produces
`C(n) = 2ⁿ + 1` for the observable `vBright = (1,1)` (which reveals the gap) but
`C(n) = 1` for `vDark = (0,1)` (which is orthogonal to the `λ = 2` mode and sees
none of that mode). Thus the transfer spectrum alone does not fix the RAW
correlation seen by a chosen observable; overlap data are indispensable.

Claim grade `M`, `[orig]` framing.  Finite linear-algebra fact; makes the A3/A4
obligation exact and complements the spectral-weight obstruction.

SCOPE CORRECTION (docstring audit `364a29ac`, refined by meta-audit `a21c13e4`): all
NORMALIZED correlators of the two observables AGREE and all effective masses equal
`log 2`, so this witness does NOT distinguish a ratio/effective-mass readout. But
"raw values only" UNDERSTATES it: AMPLITUDE-SENSITIVE standard readouts DO distinguish
the witnesses (a finite integrated readout gives `3` versus `6`). Precise scope: it
separates amplitude-sensitive readouts and fails exactly for ratio/effective-mass
readouts. Any unqualified observable-dependence-of-MASS phrasing remains an overclaim.

Scope caveat (from the self-audit `01de0e45`, docstring-outruns-kernel guard):
the statement is exactly about the RAW two-point values.  It is NOT a
normalization-independent "mass" claim - under dominant-eigenvalue normalization
the dark sequence is `(1/2)^n`, and after disconnected subtraction the dark
connected correlation is identically zero, so `vDark` determines no mass rather
than "the same mass as the transfer gap".  The example is not normalized as a
Euclidean vacuum transfer matrix and does not by itself define an asymptotic
correlation mass. Sources:
symmetric-mass-generation / propagator-zero literature (arXiv:2412.19691,
2101.01026, 2311.12790), logged in the dated origin-of-mass memo
`AutonomousLab/work/NE-DYNAMICS/OPUS_LITERATURE_ORIGIN_OF_MASS_CLASSIFICATION_2026-07-20.md`.
-/

namespace PhysicsSM.Draft.NullEdge.TransferCorrelationMassFalsifier

open Matrix

/-- Two-point correlation of observable `v` under `n` steps of transfer `T`. -/
noncomputable def corr (T : Matrix (Fin 2) (Fin 2) ℝ) (v : Fin 2 → ℝ) (n : ℕ) : ℝ :=
  v ⬝ᵥ (T ^ n).mulVec v

/-- Fixed transfer operator, spectrum `{2, 1}`, spectral gap `log 2`. -/
def Tgap : Matrix (Fin 2) (Fin 2) ℝ := !![(2 : ℝ), 0; 0, 1]

/-- Observable overlapping the fast mode. -/
def vBright : Fin 2 → ℝ := ![1, 1]

/-- Observable orthogonal to the `λ = 2` mode. -/
def vDark : Fin 2 → ℝ := ![0, 1]

/-- Powers of the diagonal transfer operator. -/
theorem Tgap_pow (n : ℕ) : Tgap ^ n = !![(2 : ℝ) ^ n, 0; 0, 1] := by
  induction n with
  | zero =>
      ext i j; fin_cases i <;> fin_cases j <;>
        simp [Tgap, Matrix.one_apply]
  | succ k ih =>
      rw [pow_succ, ih]
      ext i j; fin_cases i <;> fin_cases j <;>
        simp [Tgap, Matrix.mul_apply, Fin.sum_univ_two, pow_succ]

/-- **The transfer-spectrum raw-correlation obstruction.**  One transfer operator of
spectral gap `log 2` gives a correlation that reveals the gap for `vBright`
(`C(n) = 2ⁿ + 1`) but is constant for `vDark` (`C(n) = 1`): the correlation is
observable dependent and is not fixed by the transfer spectrum alone. The
legacy theorem name is retained for downstream compatibility; this statement
does not prove different connected correlation masses. -/
theorem transfer_gap_does_not_fix_correlation_mass :
    (∀ n : ℕ, corr Tgap vBright n = 2 ^ n + 1) ∧
      (∀ n : ℕ, corr Tgap vDark n = 1) ∧
      corr Tgap vBright 1 ≠ corr Tgap vDark 1 := by
  have hbright : ∀ n : ℕ, corr Tgap vBright n = 2 ^ n + 1 := by
    intro n
    simp [corr, Tgap_pow, vBright, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  have hdark : ∀ n : ℕ, corr Tgap vDark n = 1 := by
    intro n
    simp [corr, Tgap_pow, vDark, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  refine ⟨hbright, hdark, ?_⟩
  rw [hbright 1, hdark 1]
  norm_num

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.TransferCorrelationMassFalsifier.transfer_gap_does_not_fix_correlation_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms transfer_gap_does_not_fix_correlation_mass

end PhysicsSM.Draft.NullEdge.TransferCorrelationMassFalsifier
