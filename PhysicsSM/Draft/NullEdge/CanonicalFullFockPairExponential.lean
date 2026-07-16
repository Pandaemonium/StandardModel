import PhysicsSM.Draft.NullEdge.FullFockPairExponential
import PhysicsSM.Draft.NullEdge.PlueckerPairGenerator

/-!
# Canonical full-Fock pair exponential

This module bridges the standalone matrix calculation in
`FullFockPairExponential` to the canonical finite-CAR pair generator and
evolution in `PlueckerPairGenerator`.

The matrix representative is deliberately defined by reusing the checked local
matrix. The substantive bridge proves that its action on every occupation
coordinate is exactly the canonical `Kop`. A second bridge identifies the local
closed form with the canonical `Uop`. Their composition upgrades the full
sixteen-coordinate exponential theorem from a parallel model to a theorem about
an explicit matrix representative of the live finite-CAR generator.

The zero-coupling boundary is proved separately, removing the nonzero hypothesis
from the final theorem.

## Scope

This remains a finite occupation-basis identity for a supplied coupling and
time. It does not derive the generator, construct an interacting continuum
field theory, or select a thermal state.

## Provenance

In-project composition of Aristotle project `508eafd0` with the canonical
`PlueckerPairGenerator.Kop_apply` and `Uop` APIs. The original project used
local duplicate declarations; this file is the semantic API bridge required by
the cross-family audit.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CanonicalFullFockPairExponential

open Matrix
open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic

namespace Local

abbrev KopMatrix :=
  PhysicsSM.Draft.NullEdge.FullFockPairExponential.KopMatrix
abbrev Uop := PhysicsSM.Draft.NullEdge.FullFockPairExponential.Uop
abbrev lowPair := PhysicsSM.Draft.NullEdge.FullFockPairExponential.lowPair
abbrev highPair := PhysicsSM.Draft.NullEdge.FullFockPairExponential.highPair

end Local

namespace Canonical

abbrev Kop := PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.Kop
abbrev Uop := PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.Uop

end Canonical

private theorem lowPair_bridge :
    PhysicsSM.Draft.NullEdge.FullFockPairExponential.lowPair =
      PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction.lowPair := rfl

private theorem highPair_bridge :
    PhysicsSM.Draft.NullEdge.FullFockPairExponential.highPair =
      PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction.highPair := rfl

/-- The explicit full occupation-basis matrix representing the canonical
quartic pair-transfer generator. -/
def canonicalKopMatrix (z : Complex) :
    Matrix (Finset (Fin 4)) (Finset (Fin 4)) Complex :=
  Local.KopMatrix z

/-- The explicit matrix acts exactly as the canonical finite-CAR generator on
every one of the sixteen occupation coordinates. -/
theorem canonicalKopMatrix_mulVec (z : Complex) (psi : Fock (Fin 4)) :
    (canonicalKopMatrix z).mulVec psi = Canonical.Kop z psi := by
  funext S
  change (canonicalKopMatrix z).mulVec psi S =
    PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.Kop z psi S
  rw [PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.Kop_apply]
  simp [canonicalKopMatrix,
    PhysicsSM.Draft.NullEdge.FullFockPairExponential.KopMatrix,
    lowPair_bridge, highPair_bridge, Matrix.mulVec]
  split_ifs <;> simp_all +decide [dotProduct]

/-- The standalone closed form is definitionally the canonical finite-CAR
closed form after the occupation labels are identified. -/
theorem localUop_eq_canonicalUop (c s : Real) (z : Complex) (m : Real)
    (psi : Fock (Fin 4)) :
    Local.Uop c s z m psi = Canonical.Uop c s z m psi := by
  funext S
  simp only [Local.Uop, Canonical.Uop]
  rfl

/-- At zero coupling, both the matrix exponential and the canonical closed form
are the identity on every occupation coordinate. -/
theorem zero_exp_mulVec_eq_canonicalUop (a : Real) (psi : Fock (Fin 4)) :
    (NormedSpace.exp
        ((-(a : Complex) * Complex.I) • canonicalKopMatrix 0)).mulVec psi =
      Canonical.Uop (Real.cos (a * ‖(0 : Complex)‖))
        (Real.sin (a * ‖(0 : Complex)‖)) 0 ‖(0 : Complex)‖ psi := by
  have hmatrix : canonicalKopMatrix 0 = 0 := by
    ext S T
    simp +decide [canonicalKopMatrix,
      PhysicsSM.Draft.NullEdge.FullFockPairExponential.KopMatrix]
  rw [hmatrix, smul_zero, NormedSpace.exp_zero, one_mulVec]
  funext S
  simp only [PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.Uop]
  split_ifs <;> simp_all

/-- **Canonical full-Fock exponential theorem.** The genuine matrix
exponential of the explicit full occupation-basis representative of `Kop z`
equals the canonical `Uop` on all sixteen occupation coordinates, for every
complex coupling including `z = 0`. -/
theorem exp_mulVec_eq_canonicalUop (z : Complex) (a : Real)
    (psi : Fock (Fin 4)) :
    (NormedSpace.exp
        ((-(a : Complex) * Complex.I) • canonicalKopMatrix z)).mulVec psi =
      Canonical.Uop (Real.cos (a * ‖z‖)) (Real.sin (a * ‖z‖)) z ‖z‖ psi := by
  by_cases hz : z = 0
  · subst z
    exact zero_exp_mulVec_eq_canonicalUop a psi
  · rw [canonicalKopMatrix,
      PhysicsSM.Draft.NullEdge.FullFockPairExponential.exp_mulVec_eq_Uop z a hz psi]
    exact localUop_eq_canonicalUop _ _ _ _ _

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CanonicalFullFockPairExponential.canonicalKopMatrix_mulVec' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalKopMatrix_mulVec

/-- info: 'PhysicsSM.Draft.NullEdge.CanonicalFullFockPairExponential.exp_mulVec_eq_canonicalUop' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exp_mulVec_eq_canonicalUop

end PhysicsSM.Draft.NullEdge.CanonicalFullFockPairExponential
