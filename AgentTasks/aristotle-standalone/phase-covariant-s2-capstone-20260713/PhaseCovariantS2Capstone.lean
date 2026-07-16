import PhysicsSM.Draft.NullEdge.DYNModularMaxEntCapstone
import PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection

/-!
# Arbitrary-phase qubit max-entropy and modular-selection capstone

This focused draft transports the accepted `z = 1` noncommuting qubit
max-entropy theorem to every nonzero complex Pluecker coupling.  The transported
state is defined by the same explicit diagonal unitary that removes the phase
from `Bz z`.  The target keeps the modulus rescaling and all supplied inputs
visible.

The result is finite `2 x 2` algebra.  It does not claim that a constant
single-site phase is observable, that a spatial connection has been built, or
that the state has been derived from continuum dynamics.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PhaseCovariantS2Capstone

open Matrix
open QubitFixedEnergyMaxEntropy
open PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection

/-- Pull a canonical Bloch state back through the phase-removing unitary. -/
def gaugedBloch (z : Complex) (e u v : Real) : Matrix (Fin 2) (Fin 2) Complex :=
  (phaseGauge z)ᴴ * pairBloch e u v * phaseGauge z

/-- The inverse temperature whose product with `norm z` is the canonical
`-artanh e` inverse temperature. -/
def betaZ (z : Complex) (e : Real) : Real := -Real.artanh e / ‖z‖

/-- Conjugation by the phase gauge preserves Hermiticity of the Bloch family. -/
theorem gaugedBloch_isHermitian (z : Complex) (e u v : Real) :
    (gaugedBloch z e u v).IsHermitian := by
  sorry

/-- The phase transport does not change the spectral von Neumann entropy. -/
theorem gaugedBloch_entropy_eq (z : Complex) (hz : z ≠ 0) (e u v : Real) :
    VNEntropyPurity.vonNeumannEntropy
        (gaugedBloch z e u v) (gaugedBloch_isHermitian z e u v) =
      VNEntropyPurity.vonNeumannEntropy
        (pairBloch e u v) (pairBloch_isHermitian e u v) := by
  sorry

/-- **Arbitrary-phase operator S2 capstone.**  For every nonzero complex
coupling and every interior fixed normalized energy, the transported full
Bloch family has the same strict entropy maximizer as the canonical real
family.  The maximizer is exactly the Gibbs state of `Bz z` at the displayed
rescaled inverse temperature.  The normalized energy and modular-flow
covariance are included to prevent a merely decorative phase wrapper. -/
theorem phase_covariant_operator_S2_capstone (z : Complex) (hz : z ≠ 0)
    (e u v : Real) (he : |e| < 1)
    (hball : e ^ 2 + u ^ 2 + v ^ 2 ≤ 1) :
    VNEntropyPurity.vonNeumannEntropy
        (gaugedBloch z e u v) (gaugedBloch_isHermitian z e u v) ≤
      VNEntropyPurity.vonNeumannEntropy
        (gaugedBloch z e 0 0) (gaugedBloch_isHermitian z e 0 0)
      ∧ (VNEntropyPurity.vonNeumannEntropy
            (gaugedBloch z e u v) (gaugedBloch_isHermitian z e u v) =
          VNEntropyPurity.vonNeumannEntropy
            (gaugedBloch z e 0 0) (gaugedBloch_isHermitian z e 0 0)
          ↔ u = 0 ∧ v = 0)
      ∧ gaugedBloch z e 0 0 =
          ModularSelection.gibbsState
            (PairModularSelection.Bz z) (betaZ z e)
      ∧ (((gaugedBloch z e u v) *
            ((‖z‖ : Complex)⁻¹ • PairModularSelection.Bz z)).trace.re = e)
      ∧ (∀ (t : Real) (X : Matrix (Fin 2) (Fin 2) Complex),
          phaseGauge z *
                ModularSelection.modFlow
                  (PairModularSelection.Bz z) (betaZ z e) t X *
              (phaseGauge z)ᴴ =
            ModularSelection.modFlow
              (PairModularSelection.Bz 1) (-Real.artanh e) t
              (phaseGauge z * X * (phaseGauge z)ᴴ)) := by
  sorry

end PhysicsSM.Draft.NullEdge.PhaseCovariantS2Capstone
