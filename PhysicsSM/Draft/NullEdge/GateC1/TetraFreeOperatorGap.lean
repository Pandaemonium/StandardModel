import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.TetraQSquareExact

/-!
# Gate C1: tetrahedral free operator-gap bridge

This Draft module starts the `TetraFreeOperatorGap` lane recommended by the
2026-06-28 Pro feedback.

The preceding scalar scaffold in `TetrahedralGlobalGap.lean` proves that the
tetrahedral free lower-bound expression

`K(k) + (r * sum_A (1 - cos k_A) - rho)^2`

is strictly positive throughout the rank-4 tetrahedral Brillouin branch window.
This file packages the next bridge obligation: an actual finite spin/operator
symbol must be shown to have square norm bounded below by that scalar proxy.

What is proved here:

* the checked scalar lower-bound expression gives a positive pointwise
  square-gap coefficient after dividing by `a^2`;
* any candidate symbol satisfying the square-lower-bound certificate has a
  positive pointwise square gap;
* a separate Fourier/block-diagonalization bridge is isolated as the exact
  remaining finite/free operator-gap obligation.

What is not proved here:

* the concrete Clifford matrix identity for the proposed `H_tet(k)`;
* a uniform explicit torus minimum;
* finite Fourier block diagonalization;
* overlap no-mirror-pole release.

Those are the next milestones in the `TetraFreeOperatorGap` to
`TetraFreeOverlapNoMirror` path.
-/

open scoped BigOperators
open scoped Real

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraFreeOperatorGap

open TetrahedralGlobalGap

/-- The active tetrahedral Brillouin branch window:
each edge-coordinate angle lies in `[0, 2*pi)`. -/
def FundamentalTetraBZ (k : Fin 4 -> ℝ) : Prop :=
  ∀ A, k A ∈ Set.Ico 0 (2 * Real.pi)

/-- The scalar square-gap coefficient supplied by the checked tetrahedral
finite/free scaffold, including the lattice-spacing factor `1/a^2`. -/
noncomputable def tetraFreeGapSq (a r rho : ℝ) (k : Fin 4 -> ℝ) : ℝ :=
  freeGapScalar tetraKineticCoeffNormSq r rho k / a ^ 2

/-- The lower-bound square-gap coefficient exported to symbol-gap work:
`qLower + M(k)^2`, divided by `a^2`. -/
noncomputable def tetraFreeGapSqLower (a r rho : ℝ) (k : Fin 4 -> ℝ) : ℝ :=
  (TetraQSquareExact.qLower (fun A : Fin 4 => Real.sin (k A))
    + (wilsonScalar r rho k) ^ 2) / a ^ 2

/-- The exported lower-bound coefficient is bounded by the checked scalar
free-gap coefficient. -/
theorem tetraFreeGapSqLower_le_tetraFreeGapSq {a r rho : ℝ} {k : Fin 4 -> ℝ}
    (ha : a ≠ 0) :
    tetraFreeGapSqLower a r rho k ≤ tetraFreeGapSq a r rho k := by
  unfold tetraFreeGapSqLower tetraFreeGapSq freeGapScalar
  have ha2 : 0 < a ^ 2 := sq_pos_of_ne_zero ha
  have hnum :
      TetraQSquareExact.qLower (fun A : Fin 4 => Real.sin (k A))
          + (wilsonScalar r rho k) ^ 2
        ≤ tetraKineticCoeffNormSq k + (wilsonScalar r rho k) ^ 2 := by
    simpa [add_comm, add_left_comm, add_assoc] using
      add_le_add_left (TetraQSquareExact.qLower_le_tetraKineticCoeffNormSq k)
        ((wilsonScalar r rho k) ^ 2)
  exact div_le_div_of_nonneg_right hnum (le_of_lt ha2)

/-- The checked scalar scaffold gives a positive pointwise square-gap
coefficient throughout the branch window. -/
theorem tetraFreeGapSq_pos {a r rho : ℝ} {k : Fin 4 -> ℝ}
    (ha : 0 < a) (hrho : 0 < rho) (hwin : rho < 2 * r)
    (hk : FundamentalTetraBZ k) :
    0 < tetraFreeGapSq a r rho k := by
  unfold tetraFreeGapSq
  have hscalar :
      0 < freeGapScalar tetraKineticCoeffNormSq r rho k :=
    tetrahedral_freeGapScalar_pos r rho k hk hrho hwin
  have ha2 : 0 < a ^ 2 := sq_pos_of_ne_zero (ne_of_gt ha)
  exact div_pos hscalar ha2

section Symbol

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℂ E]

/-- A tetrahedral free symbol is certified by proving that its squared norm is
bounded below by the scalar proxy from `TetrahedralGlobalGap.lean`. -/
def TetraSymbolSquareLowerBound
    (H : (Fin 4 -> ℝ) -> E →L[ℂ] E) (a r rho : ℝ) : Prop :=
  ∀ k, FundamentalTetraBZ k ->
    ∀ psi : E,
      tetraFreeGapSq a r rho k * ‖psi‖ ^ 2 ≤ ‖H k psi‖ ^ 2

/-- Pointwise positive square-gap package for a tetrahedral free symbol. -/
structure TetraPointwiseSquareGap
    (H : (Fin 4 -> ℝ) -> E →L[ℂ] E) (a r rho : ℝ) : Prop where
  /-- The scalar square-gap coefficient is positive at each branch-window
  momentum. -/
  pos : ∀ k, FundamentalTetraBZ k -> 0 < tetraFreeGapSq a r rho k
  /-- The operator symbol satisfies the corresponding pointwise square lower
  bound. -/
  bound : TetraSymbolSquareLowerBound H a r rho

/-- Any concrete symbol satisfying the scalar-proxy lower-bound certificate has
a positive pointwise square gap throughout the branch window. -/
theorem tetraPointwiseSquareGap_of_squareLowerBound
    {H : (Fin 4 -> ℝ) -> E →L[ℂ] E} {a r rho : ℝ}
    (ha : 0 < a) (hrho : 0 < rho) (hwin : rho < 2 * r)
    (hH : TetraSymbolSquareLowerBound H a r rho) :
    TetraPointwiseSquareGap H a r rho where
  pos := fun _ hk => tetraFreeGapSq_pos ha hrho hwin hk
  bound := hH

/-- A uniform square-gap certificate for a tetrahedral symbol.  This is the
form consumed by Fourier/block-diagonalization. -/
structure UniformTetraSymbolSquareGap
    (H : (Fin 4 -> ℝ) -> E →L[ℂ] E) (mu : ℝ) : Prop where
  /-- The uniform gap coefficient is positive. -/
  pos : 0 < mu
  /-- Every branch-window symbol block has square norm at least `mu`. -/
  bound : ∀ k, FundamentalTetraBZ k ->
    ∀ psi : E, mu * ‖psi‖ ^ 2 ≤ ‖H k psi‖ ^ 2

variable {F : Type*} [NormedAddCommGroup F] [NormedSpace ℂ F]

/-- Abstract finite Fourier/block-diagonalization bridge.

For a finite translation-invariant free operator, this bridge is supplied by
the finite Fourier transform: a uniform square gap on every momentum block
transfers to a square gap for the full free operator. -/
structure FourierBlockDiagonalizationBridge
    (Hsymbol : (Fin 4 -> ℝ) -> E →L[ℂ] E) (Hfree : F →L[ℂ] F) : Prop where
  /-- Uniform symbol square gaps transfer to the full free operator. -/
  transfers_uniform_square_gap :
    ∀ mu, UniformTetraSymbolSquareGap Hsymbol mu ->
      ∀ Psi : F, mu * ‖Psi‖ ^ 2 ≤ ‖Hfree Psi‖ ^ 2

/-- The finite/free operator square gap follows once the Fourier bridge and a
uniform symbol square gap are supplied. -/
theorem tetraFreeOperatorSquareGap_of_fourierBridge
    {Hsymbol : (Fin 4 -> ℝ) -> E →L[ℂ] E} {Hfree : F →L[ℂ] F}
    {mu : ℝ}
    (hbridge : FourierBlockDiagonalizationBridge Hsymbol Hfree)
    (hgap : UniformTetraSymbolSquareGap Hsymbol mu) :
    0 < mu ∧ ∀ Psi : F, mu * ‖Psi‖ ^ 2 ≤ ‖Hfree Psi‖ ^ 2 :=
  ⟨hgap.pos, hbridge.transfers_uniform_square_gap mu hgap⟩

end Symbol

end TetraFreeOperatorGap
end GateC1
end NullEdge
end Draft
end PhysicsSM
