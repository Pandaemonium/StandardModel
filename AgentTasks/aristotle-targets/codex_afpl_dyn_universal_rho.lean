import PhysicsSM.Draft.NullEdge.DYNModularMaxEntCapstone

/-!
# Arbitrary-density-matrix wrapper for the qubit modular-selection capstone

Focused AFPL successor target. This removes the remaining presentation-level
Bloch-coordinate quantification from `DYNModularMaxEntCapstone`: every
Hermitian positive-semidefinite trace-one `2x2` matrix with the displayed
`sigmaX` expectation is bounded by the same canonical Gibbs optimizer, and
entropy equality characterizes that matrix itself.

The theorem is still finite and qubit-only. The energy `e`, generator `Bz 1`,
and inverse temperature `-Real.artanh e` remain supplied or explicit. It does
not derive thermalization, a continuum KMS state, or a general complex phase.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DYNUniversalRhoTarget

open QubitFixedEnergyMaxEntropy
open scoped ComplexOrder

/-- The finite qubit Gibbs optimizer is the unique von Neumann entropy
maximizer among all density matrices with the displayed `sigmaX` expectation.

Proof route: use `pairBloch_surjective` on `rho`; identify its longitudinal
coordinate with `e` using `pairBloch_sigmaX_expectation`; obtain the closed-ball
hypothesis from `pairBloch_posSemidef_iff`; then apply the first two conjuncts
of `dyn_modular_operator_S2_capstone`. Proof irrelevance handles the Hermitian
witness argument of `vonNeumannEntropy` after substitution. -/
theorem arbitrary_density_vonNeumannEntropy_le_and_eq_iff
    (e : Real) (he : |e| < 1)
    (rho : Matrix (Fin 2) (Fin 2) Complex)
    (hrho : rho.IsHermitian) (hpsd : rho.PosSemidef)
    (htrace : rho.trace = 1)
    (henergy : (rho * sigmaX).trace.re = e) :
    VNEntropyPurity.vonNeumannEntropy rho hrho <=
        VNEntropyPurity.vonNeumannEntropy (pairBloch e 0 0)
          (pairBloch_isHermitian e 0 0)
      /\ (VNEntropyPurity.vonNeumannEntropy rho hrho =
            VNEntropyPurity.vonNeumannEntropy (pairBloch e 0 0)
              (pairBloch_isHermitian e 0 0) <->
          rho = pairBloch e 0 0) := by
  sorry

end PhysicsSM.Draft.NullEdge.DYNUniversalRhoTarget
