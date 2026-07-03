import PhysicsSM.Draft.NullEdge.GateC1.TetraSymbolOverlapGW
import PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexIntegrality

/-!
# Gate C2: the free tetrahedral overlap has zero chiral index

This Draft module proves the correct free-case benchmark for the tetrahedral
overlap index: with a **traceless** chirality (`Tr gamma5 = 0`, the physical
balanced-Dirac normalization), the per-momentum lattice chiral index of the free
(no-gauge) tetrahedral overlap symbol vanishes,

    overlapIndex gamma5 (signSymbol gamma5 D a r rho k) = 0.

Physically: the free theory carries no topology, so its chiral index is zero.
This is the benchmark that a genuine gauge background (Gate C2 proper) must
DEFEAT - the eventual nonzero index is exactly the failure of this vanishing once
`sign(H)` stops being the elementary `coeff^{-1/2} H` (see the C2 scoping note in
the overnight discussion log).

## Mechanism

The index identity `OverlapIndexToy.overlapIndex_eq` gives
`overlapIndex = (1/2)(Tr gamma5 - Tr eps)`.  For the free symbol
`eps = signSymbol = coeff^{-1/2} . gamma5 . K` with
`K = a^{-1}(i.Q + mWilson.I)`, trace linearity gives

    Tr(signSymbol) = coeff^{-1/2} . a^{-1} . (i . Tr(gamma5.Q) + mWilson . Tr gamma5).

The kinetic trace `Tr(gamma5.Q)` vanishes purely from the chirality
anticommutation `{gamma5, Q} = 0` and trace cyclicity
(`trace_gamma5_mul_Q_eq_zero`), and `Tr gamma5 = 0` is the traceless-chirality
hypothesis.  Hence `Tr(signSymbol) = 0` and the index is `(1/2)(0 - 0) = 0`.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem / consistency check** (free-case index
benchmark; no gauge background).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace TetraFreeIndexZero

open PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
open PhysicsSM.Draft.NullEdge.GateC1.TetraQMatrixSquareExact
open PhysicsSM.Draft.NullEdge.GateC1.TetraScalarWilsonSymbol
open PhysicsSM.Draft.NullEdge.GateC1.TetraSymbolOverlapGW

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- **Kinetic chirality trace vanishes from anticommutation.**  If `gamma5`
anticommutes with `Q` (`gamma5 * Q + Q * gamma5 = 0`), then `Tr(gamma5 * Q) = 0`,
purely by trace cyclicity.  (No involution or Hermiticity needed.) -/
theorem trace_gamma5_mul_Q_eq_zero (gamma5 Q : Matrix Spin Spin ℂ)
    (hanti : gamma5 * Q + Q * gamma5 = (0 : Matrix Spin Spin ℂ)) :
    (gamma5 * Q).trace = 0 := by
  have hgQ : gamma5 * Q = -(Q * gamma5) := by
    rw [eq_neg_iff_add_eq_zero]; exact hanti
  have hself : (gamma5 * Q).trace = -((gamma5 * Q).trace) := by
    calc (gamma5 * Q).trace = (-(Q * gamma5)).trace := by rw [hgQ]
      _ = -((Q * gamma5).trace) := by rw [Matrix.trace_neg]
      _ = -((gamma5 * Q).trace) := by rw [Matrix.trace_mul_comm]
  linear_combination hself / 2

/-- **The free tetrahedral overlap has zero chiral index** (traceless
chirality).  With `Tr gamma5 = 0` and the chirality anticommutation
`{gamma5, Q} = 0`, the per-momentum lattice chiral index of the free overlap
symbol vanishes. -/
theorem tetraFreeOverlapIndex_eq_zero
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 → ℝ)
    (hgH : star gamma5 = gamma5)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hanti : gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs k)
        + TetraEuclideanSlashData.Q D (sinCoeffs k) * gamma5 = 0)
    (hg5tr : gamma5.trace = 0) :
    overlapIndex gamma5 (signSymbol gamma5 D a r rho k) = 0 := by
  have hg5sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ) := by
    nth_rewrite 1 [← hgH]; exact hgU
  have hgQ : (gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs k)).trace = 0 :=
    trace_gamma5_mul_Q_eq_zero _ _ hanti
  have hsig : (signSymbol gamma5 D a r rho k).trace = 0 := by
    unfold signSymbol H K
    simp only [Matrix.mul_smul, Matrix.mul_add, Matrix.mul_one, Matrix.trace_smul,
      Matrix.trace_add, smul_eq_mul, hgQ, hg5tr, mul_zero, add_zero]
  rw [overlapIndex_eq gamma5 (signSymbol gamma5 D a r rho k) hg5sq, hg5tr, hsig]
  ring

/-- **The tetrahedral overlap index is a certified integer.**  Instantiating the
general integrality result at the concrete free tetrahedral sign symbol: for a
Hermitian-unitary chirality anticommuting with the kinetic slash, throughout the
first Wilson band, the overlap index `overlapIndex gamma5 (signSymbol ...)` is an
integer.  (With traceless chirality `tetraFreeOverlapIndex_eq_zero` pins the value
to `0`; this corollary certifies integrality without the traceless hypothesis.) -/
theorem tetraOverlapIndex_isInteger
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 → ℝ)
    (hgH : star gamma5 = gamma5)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hanti : gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs k)
        + TetraEuclideanSlashData.Q D (sinCoeffs k) * gamma5 = 0)
    (hpos : 0 < sqCoeff D a r rho k) :
    ∃ nn : ℤ, overlapIndex gamma5 (signSymbol gamma5 D a r rho k) = (nn : ℂ) := by
  have hg5sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ) := by
    nth_rewrite 1 [← hgH]; exact hgU
  exact OverlapIndexIntegrality.overlapIndex_isInteger gamma5
    (signSymbol gamma5 D a r rho k) hg5sq
    (signSymbol_sq gamma5 D a r rho k hgU hgH hanti hpos)

end TetraFreeIndexZero
end GateC2
end NullEdge
end Draft
end PhysicsSM
