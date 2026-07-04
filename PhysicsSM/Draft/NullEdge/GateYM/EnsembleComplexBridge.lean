import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.TreeGaugeBridge
import PhysicsSM.Draft.NullEdge.GateYM.WilsonLocalWeight

/-!
# Gate YM0/YM1 connector: the real Wilson link ensemble IS the complex one

The T3 stack (`LatticeEnsemble` / `PlaquetteEnsemble` / `WilsonLocalWeight`,
with its gauge-invariance, positivity, and reflection theorems) is
REAL-valued. The YM1 area-law stack (`TreeGaugeBridge.linkExpectation`,
fed by the complex fusion convolution) is COMPLEX-valued. This module pins
the connector: for the Wilson weight, the complex link partition function /
numerator / expectation are literally the casts of the real ones, and the
complex partition function is NONZERO (inherited from real positivity).

The nonzero fact is load-bearing: it makes
`TreeGaugeBridge.wilson_link_loop_expectation_area_law` non-vacuous
(its `linkExpectation` denominator is a genuine nonzero divisor for every
`beta`, `rho`, and finite lattice), independently of any coordinatization.

Claim label: **finite identity**. Draft-trust: kernel-checked, no
`s o r r y`, no `n a t i v e _ d e c i d e`. Prerequisites:
`TreeGaugeBridge`, `WilsonLocalWeight`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace EnsembleComplexBridge

open GaugeCoreGeneral PlaquetteCore

variable {G : Type} [Group G]
variable {Λ : OrientedLattice}
variable {ι : Type} [Fintype ι]
variable {n : ℕ}
variable [Fintype (Λ.LinkField (G := G))]

/-- The complex Wilson link partition function is the cast of the real one. -/
theorem linkPartition_wilson_ofReal (P : ι → Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) :
    TreeGaugeBridge.linkPartition P
        (Theorem2AreaLaw.wilsonLocalWeightC beta rho)
      = ((PlaquetteEnsemble.partition P
          (WilsonLocalWeight.wilsonLocalWeight beta rho) : ℝ) : ℂ) := by
  simp only [TreeGaugeBridge.linkPartition, PlaquetteEnsemble.partition,
    LatticeEnsemble.partition, PlaquetteEnsemble.weight,
    PlaquetteCore.productWeight, Theorem2AreaLaw.wilsonLocalWeightC,
    Complex.ofReal_sum, Complex.ofReal_prod]

/-- The complex Wilson link numerator of a cast real observable is the cast
of the real numerator. (The real convention multiplies `observable * weight`;
the complex convention multiplies `weight * observable`.) -/
theorem linkNumerator_wilson_ofReal (P : ι → Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (f : Λ.LinkField (G := G) → ℝ) :
    TreeGaugeBridge.linkNumerator P
        (Theorem2AreaLaw.wilsonLocalWeightC beta rho)
        (fun U => (f U : ℂ))
      = ((PlaquetteEnsemble.numerator P
          (WilsonLocalWeight.wilsonLocalWeight beta rho) f : ℝ) : ℂ) := by
  simp only [TreeGaugeBridge.linkNumerator, PlaquetteEnsemble.numerator,
    LatticeEnsemble.numerator, PlaquetteEnsemble.weight,
    PlaquetteCore.productWeight, Theorem2AreaLaw.wilsonLocalWeightC,
    Complex.ofReal_sum, Complex.ofReal_mul, Complex.ofReal_prod]
  refine Finset.sum_congr rfl ?_
  intro U _hU
  ring

/-- The complex Wilson link expectation of a cast real observable is the cast
of the real expectation. -/
theorem linkExpectation_wilson_ofReal (P : ι → Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (f : Λ.LinkField (G := G) → ℝ) :
    TreeGaugeBridge.linkExpectation P
        (Theorem2AreaLaw.wilsonLocalWeightC beta rho)
        (fun U => (f U : ℂ))
      = ((PlaquetteEnsemble.expectation P
          (WilsonLocalWeight.wilsonLocalWeight beta rho) f : ℝ) : ℂ) := by
  rw [TreeGaugeBridge.linkExpectation, linkPartition_wilson_ofReal,
    linkNumerator_wilson_ofReal, PlaquetteEnsemble.expectation,
    LatticeEnsemble.expectation]
  push_cast
  rfl

/-- The complex Wilson link partition function is nonzero: it is the cast of
a strictly positive real sum. This makes the complex Wilson
`linkExpectation` a genuine (nonzero-denominator) expectation for every
`beta`, `rho`, and finite lattice, independently of any coordinatization. -/
theorem linkPartition_wilson_ne_zero (P : ι → Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) :
    TreeGaugeBridge.linkPartition P
        (Theorem2AreaLaw.wilsonLocalWeightC beta rho) ≠ 0 := by
  rw [linkPartition_wilson_ofReal]
  exact_mod_cast ne_of_gt
    (WilsonLocalWeight.wilsonPartition_pos P beta rho)

end EnsembleComplexBridge
end GateYM
end NullEdge
end Draft
end PhysicsSM
