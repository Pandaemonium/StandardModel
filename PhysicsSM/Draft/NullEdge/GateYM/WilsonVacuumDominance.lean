import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.FusionTransferSpectrum
import PhysicsSM.Draft.NullEdge.GateYM.FDRepUnitarizable

/-!
# Gate YM1/gap lane: vacuum dominance for unitary matrix models

The string-tension form of the area law
(`FusionTransferSpectrum.norm_wilson_loop_expectation_exp`) is physically
meaningful only if `sigma >= 0`, i.e. `|wilsonNormalizedGamma| <= 1`: the
vacuum eigenvalue of the fusion transfer operator dominates. This module
proves that, for observable characters admitting a UNITARY MATRIX MODEL,
by an elementary argument that needs no diagonalization:

- `norm_diag_le_one_of_unitary`: a diagonal entry of a unitary matrix has
  modulus at most 1 (its column is a unit vector).
- `norm_trace_le_of_unitary`: hence `|tr M| <= n` for unitary `n x n` `M`.
- `norm_wilsonNormalizedGamma_le_one`: if `R.character g = tr (rho' g)` for
  a unitary representation `rho'` (the "matrix model" hypothesis), then
  `|wilsonNormalizedGamma beta rho R| <= 1`. The Wilson weight positivity
  supplies the strictly positive denominator.
- `wilsonStringTension_nonneg`: hence the string tension is nonnegative.

## The explicit hypothesis (not smuggled in)

`hmodel : forall g, R.character g = Matrix.trace (rho' g)` with `rho'`
multiplicative, unital, unitary. Every complex representation of a finite
group is unitarizable, so this hypothesis is dischargeable in principle for
every simple `R`; formalizing unitarizability (Weyl averaging) is a
separate, honestly-open target for the gap lane - likely an Aristotle job
on top of Mathlib's `FDRep` machinery. Until then, every theorem here
carries the hypothesis explicitly.

Claim label: **finite identity**. Draft-trust: kernel-checked, no
`s o r r y`, no `n a t i v e _ d e c i d e`. Prerequisites:
`FusionTransferSpectrum` (string tension), `Theorem2AreaLaw` (gamma).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace WilsonVacuumDominance

open scoped Matrix

open FusionConvolution CategoryTheory

variable {G : Type} [Group G] [Fintype G]

/-- A diagonal entry of a unitary matrix has modulus at most 1: the `i`-th
column is a unit vector, and one coordinate of a unit vector has modulus at
most 1. No diagonalization needed. -/
theorem norm_diag_le_one_of_unitary {n : ℕ} (M : Matrix (Fin n) (Fin n) ℂ)
    (hM : Mᴴ * M = 1) (i : Fin n) : ‖M i i‖ ≤ 1 := by
  have hcol : ∑ k, Complex.normSq (M k i) = 1 := by
    have happ : (Mᴴ * M) i i = (1 : Matrix (Fin n) (Fin n) ℂ) i i := by
      rw [hM]
    rw [Matrix.mul_apply, Matrix.one_apply_eq] at happ
    have hterm : ∀ k, Mᴴ i k * M k i = (Complex.normSq (M k i) : ℂ) := by
      intro k
      rw [Matrix.conjTranspose_apply, Complex.star_def, ← Complex.normSq_eq_conj_mul_self]
    rw [Finset.sum_congr rfl fun k _ => hterm k] at happ
    exact_mod_cast happ
  have hle : Complex.normSq (M i i) ≤ 1 := by
    rw [← hcol]
    exact Finset.single_le_sum (fun k _ => Complex.normSq_nonneg (M k i))
      (Finset.mem_univ i)
  have hsq : ‖M i i‖ ^ 2 ≤ 1 := by
    rw [← Complex.normSq_eq_norm_sq]
    exact hle
  nlinarith [norm_nonneg (M i i)]

/-- The trace of a unitary `n x n` matrix has modulus at most `n`. -/
theorem norm_trace_le_of_unitary {n : ℕ} (M : Matrix (Fin n) (Fin n) ℂ)
    (hM : Mᴴ * M = 1) : ‖Matrix.trace M‖ ≤ n := by
  calc
    ‖Matrix.trace M‖ = ‖∑ i, M i i‖ := rfl
    _ ≤ ∑ i, ‖M i i‖ := norm_sum_le _ _
    _ ≤ ∑ _i : Fin n, (1 : ℝ) :=
        Finset.sum_le_sum fun i _ => norm_diag_le_one_of_unitary M hM i
    _ = n := by simp

/-- **Vacuum dominance.** If the observable character `R.character` admits a
unitary matrix model `rho'` (`R.character g = tr (rho' g)`, `rho'`
multiplicative, unital, unitary, of any size `n'`), then the normalized
Wilson fusion eigenvalue has modulus at most 1: the vacuum eigenvalue of the
fusion transfer operator dominates the `R` channel. -/
theorem norm_wilsonNormalizedGamma_le_one {n n' : ℕ} (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (R : FDRep ℂ G) [Simple R]
    (rho' : G → Matrix (Fin n') (Fin n') ℂ)
    (hone' : rho' 1 = 1)
    (hunit' : ∀ g : G, (rho' g)ᴴ * rho' g = 1)
    (hmodel : ∀ g : G, R.character g = Matrix.trace (rho' g)) :
    ‖Theorem2AreaLaw.wilsonNormalizedGamma beta rho R‖ ≤ 1 := by
  have hw_pos : ∀ g : G, 0 < WilsonLocalWeight.wilsonLocalWeight beta rho g :=
    fun g => WilsonLocalWeight.wilsonLocalWeight_pos beta rho g
  have hS_pos : 0 < ∑ g : G, WilsonLocalWeight.wilsonLocalWeight beta rho g :=
    Theorem2AreaLaw.wilsonPlaquetteSum_pos beta rho
  -- The character at 1 is (n' : C), and n' > 0 by simplicity.
  have hchar1 : R.character 1 = (n' : ℂ) := by
    rw [hmodel 1, hone', Matrix.trace_one]
    simp
  have hn'_pos : 0 < n' := by
    by_contra hn'
    push_neg at hn'
    interval_cases n'
    exact FusionTransferSpectrum.character_one_ne_zero R (by simp [hchar1])
  -- Numerator bound: |sum_g w(g) chi(g^-1)| <= (sum_g w(g)) * n'.
  have hnum : ‖∑ g : G, Theorem2AreaLaw.wilsonLocalWeightC beta rho g
      * R.character g⁻¹‖
      ≤ (∑ g : G, WilsonLocalWeight.wilsonLocalWeight beta rho g) * n' := by
    calc
      ‖∑ g : G, Theorem2AreaLaw.wilsonLocalWeightC beta rho g * R.character g⁻¹‖
          ≤ ∑ g : G, ‖Theorem2AreaLaw.wilsonLocalWeightC beta rho g
              * R.character g⁻¹‖ := norm_sum_le _ _
      _ ≤ ∑ g : G, WilsonLocalWeight.wilsonLocalWeight beta rho g * n' := by
          refine Finset.sum_le_sum ?_
          intro g _hg
          rw [norm_mul]
          have hw_norm : ‖Theorem2AreaLaw.wilsonLocalWeightC beta rho g‖
              = WilsonLocalWeight.wilsonLocalWeight beta rho g := by
            rw [Theorem2AreaLaw.wilsonLocalWeightC, Complex.norm_real,
              Real.norm_eq_abs, abs_of_pos (hw_pos g)]
          rw [hw_norm]
          refine mul_le_mul_of_nonneg_left ?_ (le_of_lt (hw_pos g))
          rw [hmodel g⁻¹]
          exact norm_trace_le_of_unitary (rho' g⁻¹) (hunit' g⁻¹)
      _ = (∑ g : G, WilsonLocalWeight.wilsonLocalWeight beta rho g) * n' := by
          rw [Finset.sum_mul]
  -- Assemble: |gamma| = |num| / (n' * sum w) <= 1.
  rw [Theorem2AreaLaw.wilsonNormalizedGamma, norm_div, norm_div]
  have hSC_norm : ‖Theorem2AreaLaw.wilsonPlaquetteSumC beta rho‖
      = ∑ g : G, WilsonLocalWeight.wilsonLocalWeight beta rho g := by
    have hcast : Theorem2AreaLaw.wilsonPlaquetteSumC beta rho
        = ((∑ g : G, WilsonLocalWeight.wilsonLocalWeight beta rho g : ℝ) : ℂ) := by
      simp [Theorem2AreaLaw.wilsonPlaquetteSumC, Theorem2AreaLaw.wilsonLocalWeightC]
    rw [hcast, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hS_pos]
  have hchar1_norm : ‖R.character 1‖ = (n' : ℝ) := by
    rw [hchar1]
    simp
  rw [hSC_norm, hchar1_norm]
  rw [div_div]
  rw [div_le_one (by positivity)]
  calc
    ‖∑ g : G, Theorem2AreaLaw.wilsonLocalWeightC beta rho g * R.character g⁻¹‖
        ≤ (∑ g : G, WilsonLocalWeight.wilsonLocalWeight beta rho g) * n' := hnum
    _ = (n' : ℝ) * ∑ g : G, WilsonLocalWeight.wilsonLocalWeight beta rho g := by
        ring

/-- **Nonnegative string tension.** Under the unitary matrix model
hypothesis, the finite Wilson string tension
`sigma = -log |wilsonNormalizedGamma|` is nonnegative: the area law is a
DECAY, never a growth. -/
theorem wilsonStringTension_nonneg {n n' : ℕ} (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (R : FDRep ℂ G) [Simple R]
    (rho' : G → Matrix (Fin n') (Fin n') ℂ)
    (hone' : rho' 1 = 1)
    (hunit' : ∀ g : G, (rho' g)ᴴ * rho' g = 1)
    (hmodel : ∀ g : G, R.character g = Matrix.trace (rho' g)) :
    0 ≤ FusionTransferSpectrum.wilsonStringTension beta rho R := by
  rw [FusionTransferSpectrum.wilsonStringTension, neg_nonneg]
  exact Real.log_nonpos (norm_nonneg _)
    (norm_wilsonNormalizedGamma_le_one beta rho R rho' hone' hunit' hmodel)

/-- **Vacuum dominance, UNCONDITIONAL** (queue item Q4 closed).
`FDRepUnitarizable.fdRep_exists_unitary_matrix_model` supplies a unitary
matrix model for every simple `FDRep`, discharging the explicit
`rho'`/`hone'`/`hunit'`/`hmodel` hypotheses of
`norm_wilsonNormalizedGamma_le_one`: the normalized Wilson fusion
eigenvalue has modulus at most 1 for ANY simple complex `FDRep`
observable, no matrix-model hypothesis required. -/
theorem norm_wilsonNormalizedGamma_le_one' {n : ℕ} (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G) [Simple R] :
    ‖Theorem2AreaLaw.wilsonNormalizedGamma beta rho R‖ ≤ 1 := by
  obtain ⟨n', rho', hmul', hone', hunit', hmodel⟩ :=
    FDRepUnitarizable.fdRep_exists_unitary_matrix_model R
  exact norm_wilsonNormalizedGamma_le_one beta rho R rho' hone' hunit' hmodel

/-- **Nonnegative string tension, UNCONDITIONAL** (queue item Q4 closed).
The Wilson string tension is nonnegative for ANY simple complex `FDRep`
observable, with no matrix-model hypothesis: the area law is a decay,
never a growth, unconditionally. -/
theorem wilsonStringTension_nonneg' {n : ℕ} (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G) [Simple R] :
    0 ≤ FusionTransferSpectrum.wilsonStringTension beta rho R := by
  obtain ⟨n', rho', hmul', hone', hunit', hmodel⟩ :=
    FDRepUnitarizable.fdRep_exists_unitary_matrix_model R
  exact wilsonStringTension_nonneg beta rho R rho' hone' hunit' hmodel

end WilsonVacuumDominance
end GateYM
end NullEdge
end Draft
end PhysicsSM
