import Mathlib
import PhysicsSM.NullStrand.Conventions

/-!
# NullStrand.NullFiber.RegulatorNoGo

Finite regulator obstruction in the convex finite setting.

The theorem below encodes the finite no-go idea: a non-zero uniform component
of a bounded direction law forces a strict suppression of the mean norm unless the
whole law is supported by the non-uniform part.
-/

noncomputable section

namespace PhysicsSM.NullStrand.NullFiber

open scoped BigOperators
open Finset

/-- Finite expectation operator for an explicit weight function. -/
def expectation {Ω : Type*} [Fintype Ω] {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (μ : Ω → ℝ) (direction : Ω → E) : E :=
  ∑ ω, μ ω • direction ω

/-
If a distribution has an `ε`-uniform component, then the mean norm is bounded by `1 - ε`.

This is the finite-algebraic backbone of the regulator no-go statement.

Naming/de-duplication note (2026-06-25 G0 firewall+dedup audit):
This `expectation`-operator variant was previously also named
`uniformComponent_bounds_meanNorm`, colliding on its fully-qualified name with
the canonical KIN-010 statement
`PhysicsSM.NullStrand.NullFiber.uniformComponent_bounds_meanNorm` in
`NullStrand.NullFiber.RegulatorMeanNorm`. The two statements are genuinely
different (this one assumes `‖direction ω‖ ≤ 1`, an explicit uniform mixture
weight `μ ω = ε / card + (1 - ε) * q ω`, and `∑ direction ω = 0`; KIN-010 assumes
`‖dir ω‖ = 1` and a free mean-zero component `u`). To remove the latent
same-name clash (e.g. when both files are imported by an audit module), this
orphan variant is renamed to `expectation_uniformComponent_bounds_meanNorm`.
This file is not imported by `PhysicsSM.NullStrand`, so the rename has no external
referents. No statement, sign, or convention is changed.
-/
theorem expectation_uniformComponent_bounds_meanNorm
    {Ω : Type*} [Fintype Ω]
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (direction : Ω → E)
    (hdir_norm : ∀ ω, ‖direction ω‖ ≤ 1)
    (hUniformMean : ∑ ω, direction ω = 0)
    (q : Ω → ℝ)
    (hq_nonneg : ∀ ω, 0 ≤ q ω)
    (hq_sum : ∑ ω, q ω = 1)
    (ε : ℝ)
    (_hε : 0 ≤ ε) (hε₁ : ε ≤ 1)
    (μ : Ω → ℝ)
    (hμ : ∀ ω, μ ω = ε / (Fintype.card Ω : ℝ) + (1 - ε) * q ω) :
    ‖expectation μ direction‖ ≤ 1 - ε := by
  unfold expectation;
  simp +decide [ hμ, Finset.sum_add_distrib, add_smul ];
  simp_all +decide [ ← Finset.smul_sum ];
  refine' le_trans ( norm_sum_le _ _ ) _;
  simp +decide [ norm_smul, abs_of_nonneg ( sub_nonneg.2 hε₁ ), abs_of_nonneg ( hq_nonneg _ ) ];
  exact le_trans ( Finset.sum_le_sum fun _ _ => mul_le_mul_of_nonneg_left ( hdir_norm _ ) ( mul_nonneg ( sub_nonneg.2 hε₁ ) ( hq_nonneg _ ) ) ) ( by simp +decide [ ← Finset.mul_sum _ _ _, hq_sum ] )

end PhysicsSM.NullStrand.NullFiber
