import PhysicsSM.Draft.NullEdge.GateC1.TetraFreeOperator

/-!
# Gate C1: the equal-side tetrahedral finite/free operator gap (assembled)

This Draft module assembles the unconditional finite/free operator spectral
gap for the real-space Hermitian overlap-seed kernel `Hfree` on the equal-side
tetrahedral torus.  It discharges the two abstract obligations recorded in
`TetraFreeOperatorGap.lean` (`FourierBlockDiagonalizationBridge` and
`UniformTetraSymbolSquareGap`) by instantiating the generic
`FiniteBlockDiagonalGap.UnitaryBlockDiagonalization` interface with concrete,
already kernel-checked components:

* `parseval`      := `TetraCharactersEqual.fourierUnitary_l2NormSq_siteN`
  (the normalized finite Fourier transform preserves the finite field L2 norm
  square);
* `diagonalizes`  := `TetraFreeOperator.fourierUnitary_Hfree_trig`
  (Fourier transform intertwines `Hfree` with the per-momentum Hermitian
  Wilson symbol `H`);
* pointwise gap   := `TetraScalarWilsonSymbol.H_symbol_l2NormSq_gap`
  (a uniform positive lower bound on the symbol square throughout the first
  Wilson band).

Every hard step lives in the imported modules; this file adds only the finite
linear-algebra glue, so there is no remaining analysis.

## Status and claim scope

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.

Claim label: **structural theorem** (a uniform spectral gap is *forced* once
the finite first-Wilson-band inputs `0 < rho < 2 r`, `0 < a`, and a unitary
chirality `gamma5` are assumed).

This is a **regulator-level** statement in the sense of `docs/NERD_ROADMAP.md`:
it is a property of the fixed equal-side tetrahedral regulator operator, not a
Lorentz-invariant ontology claim.  The gap is on the `gamma5`-Hermitian seed
`Hfree` (an inverse-propagator / `H^2`-level statement), which is exactly the
overlap branch-selection condition (doublers lifted by inverse-propagator
gaps, not by propagator zeros); it is **not** by itself a bare-propagator
no-doubling theorem.

Prerequisite modules: `TetraFreeOperator` (real-space `Hfree` and its Fourier
symbol theorem), `TetraCharactersEqual` (normalized Fourier transform and
Parseval), `TetraScalarWilsonSymbol` (the symbol `H` and its uniform gap),
`FiniteBlockDiagonalGap` (the generic block-diagonalization gap theorem).
Successor: the overlap `sign(H)` / Ginsparg-Wilson release layer, which
consumes a self-adjoint gapped `Hfree`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraFreeOperatorGapEqualN

open TetraFiniteTorusEqual
open TetraCharactersEqual
open TetraScalarWilsonSymbol
open TetraQMatrixSquareExact
open TetraPhaseTrigEqual
open TetraFreeOperator
open FiniteBlockDiagonalGap

variable (N : ℕ) [NeZero N]
variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- The concrete unitary block diagonalization of the equal-side tetrahedral
`Hfree` operator.

The normalized finite Fourier transform `fourierUnitary` intertwines the
real-space operator `Hfree` with the per-momentum Hermitian Wilson symbol `H`
(field `diagonalizes`) and preserves the finite field L2 norm square (field
`parseval`).  Both fields are supplied by already kernel-checked theorems. -/
def hfreeBlockDiagonalization
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) :
    UnitaryBlockDiagonalization (SiteN N -> Spin -> ℂ) (MomN N) Spin where
  fieldL2NormSq := fun Psi => TetraFiniteTorusEqual.fieldL2NormSq N Psi
  F := fun Psi => fourierUnitary N Psi
  Hfree := fun Psi => TetraFreeOperator.Hfree N gamma5 D a r rho Psi
  Hsym := fun m => TetraScalarWilsonSymbol.H gamma5 D a r rho (kOfMom N m)
  parseval := fun Psi => (fourierUnitary_l2NormSq_siteN N Psi).symm
  diagonalizes := fun Psi m =>
    fourierUnitary_Hfree_trig N gamma5 D a r rho Psi m

/-- **Gate C1 finite/free operator gap (equal-side tetrahedral torus).**

For the first Wilson band `0 < rho < 2 r`, positive lattice spacing `a`, and a
unitary chirality operator `gamma5`, the real-space Hermitian overlap-seed
operator `Hfree` on the equal-side tetrahedral torus has a strictly positive
uniform finite-L2 spectral gap:

`gamma * fieldL2NormSq Psi <= fieldL2NormSq (Hfree Psi)`  for every field `Psi`.

This is the unconditional finite/free operator-gap milestone
(`TetraFreeOperatorGap_equalN`): the abstract Fourier-bridge and uniform
symbol-gap obligations of `TetraFreeOperatorGap.lean` are discharged here by
the concrete normalized Fourier transform and the checked scalar Wilson symbol
gap.  See the module docstring for the regulator-level claim scope. -/
theorem tetraFreeOperator_gap_equalN
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hgamma5 : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (ha : 0 < a) (hband : FirstWilsonBand r rho) :
    ∃ gamma : ℝ, 0 < gamma ∧
      ∀ Psi : SiteN N -> Spin -> ℂ,
        gamma * TetraFiniteTorusEqual.fieldL2NormSq N Psi ≤
          TetraFiniteTorusEqual.fieldL2NormSq N
            (TetraFreeOperator.Hfree N gamma5 D a r rho Psi) := by
  rcases H_symbol_l2NormSq_gap gamma5 D a r rho hgamma5 ha hband with
    ⟨gamma, hgamma, hpoint⟩
  exact operator_gap_exists_of_unitary_block_diagonalization
    (hfreeBlockDiagonalization N gamma5 D a r rho)
    ⟨gamma, hgamma, fun m psi => hpoint (kOfMom N m) psi⟩

end TetraFreeOperatorGapEqualN
end GateC1
end NullEdge
end Draft
end PhysicsSM
