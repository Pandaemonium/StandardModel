import PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer
import PhysicsSM.Draft.NullEdge.FiniteTorus3Plancherel

/-!
# Finite three-torus wave-packet rate for the complex 3+1 walk

This module composes the uniform complex Pluecker-mass matrix estimate with
the exact three-axis inverse-DFT Plancherel theorem.  Every finite torus mode
is assigned real momenta `kx`, `ky`, `kz`, a complex Pluecker coordinate `z`,
and a four-component spinor coefficient.  Matrices act on the Euclidean
spinor space through Mathlib's `Matrix.toEuclideanCLM`; the matrix L2 operator
norm is exactly the continuous-linear-map operator norm.

The resulting position-space wave-packet error has coefficient
`((Dbox K M * t^2 / n)^2 / N^3)`.  This is an exact finite-volume consequence
of the landed modewise estimate and finite Plancherel normalization.  It does
not assert an infinite-volume or continuum PDE theorem.

Provenance: clean-room composition of
`ComplexPlueckerRateTransfer.complex_fixed_time_many_step_bound_on_box` and
`FiniteTorus3Plancherel.inverseDFT3_operator_wavepacket_error`, using
Mathlib's `Matrix.toEuclideanCLM` isometry for the L2 operator norm.
-/

noncomputable section

open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.FiniteTorus3WalkWavepacket

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex
abbrev Spinor := EuclideanSpace Complex (Fin 4)

/-- Package a `4 x 4` matrix as a continuous operator on Euclidean spinors. -/
def matrixOperator (A : Mat4) : Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex) A

/-- Matrix subtraction is isometric to operator subtraction in the L2
operator norm. -/
theorem norm_matrixOperator_sub (A B : Mat4) :
    ‖matrixOperator A - matrixOperator B‖ = ‖A - B‖ := by
  change ‖Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex) A -
      Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex) B‖ = ‖A - B‖
  rw [<- map_sub, Matrix.l2_opNorm_toEuclideanCLM]

variable {N : Nat} [NeZero N]

/-- The `n`-step complex split-walk operator at one finite-torus mode. -/
def approximateModeOperator
    (kx ky kz : FiniteTorus3Plancherel.Torus3 N -> Real)
    (z : FiniteTorus3Plancherel.Torus3 N -> Complex)
    (t : Real) (n : Nat)
    (k : FiniteTorus3Plancherel.Torus3 N) : Spinor →L[Complex] Spinor :=
  matrixOperator
    ((ComplexPlueckerRateTransfer.complexSplitStep
      (kx k) (ky k) (kz k) (z k) (t / (n : Real))) ^ n)

/-- The exact complex Dirac-flow operator at one finite-torus mode. -/
def exactModeOperator
    (kx ky kz : FiniteTorus3Plancherel.Torus3 N -> Real)
    (z : FiniteTorus3Plancherel.Torus3 N -> Complex)
    (t : Real) (k : FiniteTorus3Plancherel.Torus3 N) :
    Spinor →L[Complex] Spinor :=
  matrixOperator
    (ComplexPlueckerRateTransfer.complexExactFlow
      (kx k) (ky k) (kz k) (z k) t)

/-- Uniform modewise complex-walk convergence lifts to the exact normalized
finite three-torus spinor wave-packet bound. -/
theorem complex_walk_inverseDFT3_wavepacket_error_on_box
    (kx ky kz : FiniteTorus3Plancherel.Torus3 N -> Real)
    (z : FiniteTorus3Plancherel.Torus3 N -> Complex)
    (coeff : FiniteTorus3Plancherel.Torus3 N -> Spinor)
    (K M t : Real) (n : Nat)
    (hn : 0 < n) (hsmall : |t / (n : Real)| ≤ 1)
    (hK : 0 ≤ K) (hM : 0 ≤ M)
    (hx : forall k, |kx k| ≤ K) (hy : forall k, |ky k| ≤ K)
    (hz : forall k, |kz k| ≤ K) (hm : forall k, ‖z k‖ ≤ M) :
    FiniteTorus3Plancherel.energy3
        (FiniteTorus3Plancherel.invDFT3 (fun k =>
          approximateModeOperator kx ky kz z t n k (coeff k) -
            exactModeOperator kx ky kz z t k (coeff k))) ≤
      ((ComplexPlueckerRateTransfer.realDbox K M * t ^ 2 / n) ^ 2 /
          (N : Real) ^ 3) *
        FiniteTorus3Plancherel.energy3 coeff := by
  apply FiniteTorus3Plancherel.inverseDFT3_operator_wavepacket_error
  intro k
  rw [approximateModeOperator, exactModeOperator,
    norm_matrixOperator_sub]
  exact
    ComplexPlueckerRateTransfer.complex_fixed_time_many_step_bound_on_box
      (kx k) (ky k) (kz k) K M t (z k) n hn hsmall hK hM
      (hx k) (hy k) (hz k) (hm k)

end PhysicsSM.Draft.NullEdge.FiniteTorus3WalkWavepacket

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTorus3WalkWavepacket.complex_walk_inverseDFT3_wavepacket_error_on_box' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteTorus3WalkWavepacket.complex_walk_inverseDFT3_wavepacket_error_on_box
