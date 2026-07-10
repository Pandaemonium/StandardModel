/-
# The signed mass-budget theorem, with a witness (K4 / roadmap S6)

DRAFT (kernel-clean; no `s o r r y`). The overnight all-mass run's K4 -
the flagship S6 deliverable, in its Amendment-A3 SIGNED form: the finite
mass budget of a state splits EXACTLY into aperture / closure / turn
shares that sum to one, with the shares SIGNED (not asserted positive
until the physical-sector positivity crux closes).

## The two parts

* `signed_budget_sum_one` (abstract): given the guard-pinned Weitzenboeck
  identity `4 . D² = Q_A + Q_C + 4 . Q_T` and ANY linear functional `ev`
  (the expectation `<psi, . psi>`) with `ev (D²) != 0`, the shares
  `b_A = ev Q_A / M²`, `b_C = ev Q_C / M²`, `b_T = 4 ev Q_T / M²`
  (`M² = 4 ev(D²)`) satisfy `b_A + b_C + b_T = 1`.
* `witness_budget_*` (vacuity guard): a concrete `2x2` single-edge
  carrier - `gamma = sigma_x`, `Gamma = sigma_z`, `nabla = 1`, `phi = 1`,
  `g = 2` - discharges every hypothesis of `carrier_square_assembly`, so
  the identity holds by construction; with `ev = trace` the closure share
  is exactly `0` (one edge -> no closure) and the budget is
  `b_A = 1/2, b_C = 0, b_T = 1/2` - a non-vacuous witness.

This is the 3-slot `D²` budget (matching the pinned assembly); the 4-slot
`D^#D` budget with the soldering-gradient share `E` awaits the `D^#D`
assembly. No positivity is claimed: the shares are signed (Amendment A3);
`b_C` is the CHROMOMAGNETIC (hyperfine) share, NOT a gluon-energy share
(Amendment B wording rail).

## Claim boundary

`b_A + b_C + b_T = 1` is proved (abstract + witness). The physical reading
(non-turn dominance, hadron budget) is prose. The witness is Euclidean
(shares happen to be positive); the SIGNED generality is the theorem's,
realized once an indefinite `ev` / larger carrier is used. No continuum,
no hadron-mass claim.

## Provenance

S6 shape from the QCD roadmap (Amendment A3, SevenChallenges finding 7) -
[comp]; built on the guard-pinned `carrier_square_assembly`
(`CarrierSquareAssembly.lean`) - [orig].
-/

import PhysicsSM.Draft.NullEdge.Carrier.CarrierSquareAssembly

namespace PhysicsSM.Draft.NullEdge.Carrier.MassBudget

open Matrix

/-! ## The abstract signed budget -/

/-- **Signed mass-budget decomposition of unity.** From the Weitzenboeck
identity `4 . D² = Q_A + Q_C + 4 . Q_T` and a linear expectation `ev` with
`ev (D * D) != 0`, the aperture/closure/turn shares of `M² = 4 ev(D²)` sum
to one. Shares are signed - no positivity assumed. -/
theorem signed_budget_sum_one {B : Type*} [Ring B] [Algebra ℂ B]
    (ev : B →ₗ[ℂ] ℂ) (D QA QC QT : B)
    (hid : (4 : ℂ) • (D * D) = QA + QC + (4 : ℂ) • QT)
    (hM : ev (D * D) ≠ 0) :
    ev QA / (4 * ev (D * D)) + ev QC / (4 * ev (D * D))
        + (4 * ev QT) / (4 * ev (D * D)) = 1 := by
  have hev : (4 : ℂ) * ev (D * D) = ev QA + ev QC + 4 * ev QT := by
    have h := congrArg ev hid
    rw [map_smul, map_add, map_add, map_smul, smul_eq_mul, smul_eq_mul] at h
    exact h
  have hs : (4 : ℂ) * ev (D * D) ≠ 0 := mul_ne_zero (by norm_num) hM
  rw [← add_div, ← add_div, ← hev, div_self hs]

/-! ## A concrete non-vacuous witness: the 2x2 single-edge carrier -/

/-- Single Clifford generator `sigma_x`. -/
def gammaW : Fin 1 → Matrix (Fin 2) (Fin 2) ℂ := fun _ => !![0, 1; 1, 0]

/-- Constant unit transport `nabla = 1`. -/
def nablaW : Fin 1 → Matrix (Fin 2) (Fin 2) ℂ := fun _ => 1

/-- Chirality grading `sigma_z`. -/
def GammaW : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- Unit turn field `phi = 1`. -/
def phiW : Matrix (Fin 2) (Fin 2) ℂ := 1

/-- Edge metric `g = 2` (from `{sigma_x, sigma_x} = 2`). -/
def gW : Fin 1 → Fin 1 → ℂ := fun _ _ => 2

/-- The witness carrier `D = sigma_x + sigma_z` and its blocks satisfy the
Weitzenboeck identity `4 D² = Q_A + Q_C + 4 Q_T` (all hypotheses of
`carrier_square_assembly` discharged for the single-edge `2x2` model). -/
theorem witness_assembly :
    (4 : ℂ) • (solderedNC gammaW nablaW + GammaW * phiW) ^ 2
      = (∑ e, ∑ f, gW e f • (nablaW e * nablaW f + nablaW f * nablaW e))
        + (∑ e, ∑ f, (gammaW e * gammaW f - gammaW f * gammaW e)
            * (nablaW e * nablaW f - nablaW f * nablaW e))
        + (4 : ℂ) • phiW ^ 2 := by
  apply carrier_square_assembly (R := ℂ) gammaW nablaW GammaW phiW gW
  · intro e f
    fin_cases e; fin_cases f
    ext i j; fin_cases i <;> fin_cases j <;>
      norm_num [gammaW, gW, Matrix.mul_apply, Fin.sum_univ_two,
        Algebra.algebraMap_eq_smul_one, Matrix.one_apply, Matrix.smul_apply]
  · intro e f; fin_cases e; fin_cases f; simp [gammaW, nablaW]
  · ext i j; fin_cases i <;> fin_cases j <;>
      norm_num [GammaW, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]
  · intro e; fin_cases e
    ext i j; fin_cases i <;> fin_cases j <;>
      norm_num [GammaW, gammaW, Matrix.mul_apply, Fin.sum_univ_two,
        Matrix.neg_apply]
  · intro e; fin_cases e; simp [GammaW, nablaW]
  · intro e; fin_cases e; simp [phiW, gammaW]
  · simp [GammaW, phiW]
  · intro e; fin_cases e; simp [nablaW, phiW]

/-- The witness closure share is exactly `0` (single edge -> no closure). -/
theorem witness_QC_zero :
    (∑ e, ∑ f, (gammaW e * gammaW f - gammaW f * gammaW e)
        * (nablaW e * nablaW f - nablaW f * nablaW e))
      = (0 : Matrix (Fin 2) (Fin 2) ℂ) := by
  simp

/-- **The witness mass budget.** With `ev = trace`, the aperture/closure/
turn shares of the single-edge `2x2` carrier are `1/2, 0, 1/2` and sum to
one - a non-vacuous instance of `signed_budget_sum_one`. -/
theorem witness_budget_sum_one :
    (Matrix.traceLinearMap (Fin 2) ℂ ℂ)
          (∑ e, ∑ f, gW e f • (nablaW e * nablaW f + nablaW f * nablaW e))
        / (4 * (Matrix.traceLinearMap (Fin 2) ℂ ℂ)
            ((solderedNC gammaW nablaW + GammaW * phiW)
              * (solderedNC gammaW nablaW + GammaW * phiW)))
      + (Matrix.traceLinearMap (Fin 2) ℂ ℂ)
          (∑ e, ∑ f, (gammaW e * gammaW f - gammaW f * gammaW e)
            * (nablaW e * nablaW f - nablaW f * nablaW e))
        / (4 * (Matrix.traceLinearMap (Fin 2) ℂ ℂ)
            ((solderedNC gammaW nablaW + GammaW * phiW)
              * (solderedNC gammaW nablaW + GammaW * phiW)))
      + (4 * (Matrix.traceLinearMap (Fin 2) ℂ ℂ) (phiW ^ 2))
        / (4 * (Matrix.traceLinearMap (Fin 2) ℂ ℂ)
            ((solderedNC gammaW nablaW + GammaW * phiW)
              * (solderedNC gammaW nablaW + GammaW * phiW))) = 1 := by
  have hDD : ((solderedNC gammaW nablaW + GammaW * phiW)
      * (solderedNC gammaW nablaW + GammaW * phiW))
      = (2 : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
    ext i j; fin_cases i <;> fin_cases j <;>
      norm_num [solderedNC, gammaW, nablaW, GammaW, phiW,
        Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply,
        Matrix.smul_apply]
  have hM : (Matrix.traceLinearMap (Fin 2) ℂ ℂ)
      ((solderedNC gammaW nablaW + GammaW * phiW)
        * (solderedNC gammaW nablaW + GammaW * phiW)) ≠ 0 := by
    rw [hDD]; norm_num [Matrix.traceLinearMap, Matrix.trace_fin_two,
      Matrix.one_apply, Matrix.smul_apply]
  have hsq : (solderedNC gammaW nablaW + GammaW * phiW) ^ 2
      = (solderedNC gammaW nablaW + GammaW * phiW)
        * (solderedNC gammaW nablaW + GammaW * phiW) := sq _
  have := signed_budget_sum_one (Matrix.traceLinearMap (Fin 2) ℂ ℂ)
    (solderedNC gammaW nablaW + GammaW * phiW)
    (∑ e, ∑ f, gW e f • (nablaW e * nablaW f + nablaW f * nablaW e))
    (∑ e, ∑ f, (gammaW e * gammaW f - gammaW f * gammaW e)
      * (nablaW e * nablaW f - nablaW f * nablaW e))
    (phiW ^ 2) (by rw [← hsq]; exact witness_assembly) hM
  exact this

end PhysicsSM.Draft.NullEdge.Carrier.MassBudget
