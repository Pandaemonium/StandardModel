import PhysicsSM.Draft.CheckerboardContinuumNext

/-!
# Checkerboard-to-Dirac scaling scaffold

This module is a design layer for a future topology-explicit 1+1D
checkerboard-to-Dirac limit theorem. It fixes the Lean-facing objects that a
future theorem should compare, without asserting that any continuum limit holds.
Everything here is a definition, a record, or a statement-free helper API.

## Objects fixed here

* `CheckerboardDiracScalingData` collects the explicit scaling parameters:
  lattice spacing `eps`, number of steps `N`, mass `m`, and a momentum
  observation half-width `pMax`.
* The finite evolution object is the momentum-space single-step symbol
  `momentumStepSymbol`, raised to the `N`th power in `momentumEvolution`.
  It combines the existing `isotropicStep` mass mixing with an explicit
  null-transport phase.
* The continuum comparison object is `diracEvolutionSymbol`, the matrix
  exponential of the 1+1D Dirac Hamiltonian symbol `diracHamiltonianSymbol`.
* The observation API records pointwise momentum windows and a later
  position-space sampling map.
* `CheckerboardDiracRefinement` packages the scaling hypotheses `eps -> 0`,
  `totalTime -> T`, and fixed mass/window data.

The intended theorem boundary is recorded only in the comment at the bottom of
this module. Proving it requires a momentum-space per-step expansion, a
matrix-power/Trotter stability estimate, and matrix-exponential continuity
lemmas.

## Convention note

To first order in `eps`, with `theta = eps * m`,
`nullShiftSymbol eps p` has leading term `1 - i * eps * p * directionGrade`,
while `isotropicStep theta` has leading term
`1 + i * eps * m * reversal`. The chosen finite step therefore matches the
continuum generator `H(p) = p * directionGrade - m * reversal`. The mass-term
sign is convention-dependent; this module records the convention that matches
the finite step as defined here.
-/

noncomputable section

namespace PhysicsSM.Draft.CheckerboardDiracScaling

open Matrix
open scoped BigOperators

open PhysicsSM.Draft.Checkerboard1D
open PhysicsSM.Draft.CheckerboardContinuumScaffold

/-! ## Scaling data -/

/-- Explicit scaling parameters for one checkerboard-to-Dirac comparison.

Units are chosen with `c = 1` and `hbar = 1`. Derived quantities such as
`timeStep`, `totalTime`, `massAngle`, and `accumulatedAngle` are definitions
below rather than stored fields, so their conventions remain single-sourced. -/
structure CheckerboardDiracScalingData where
  /-- Lattice spacing, also the light-cone time step in units with `c = 1`. -/
  eps : Real
  /-- Number of checkerboard time steps. -/
  N : Nat
  /-- Continuum mass parameter. -/
  m : Real
  /-- Momentum observation half-width. The first theorem should compare
  momenta with `|p| <= pMax`. -/
  pMax : Real
  /-- The lattice spacing is strictly positive. -/
  eps_pos : 0 < eps
  /-- The observation window is nonempty. -/
  pMax_nonneg : 0 ≤ pMax

namespace CheckerboardDiracScalingData

variable (D : CheckerboardDiracScalingData)

/-- Light-cone time step, equal to `eps` in units with `c = 1`. -/
def timeStep : Real := D.eps

/-- Total elapsed time `N * eps`. -/
def totalTime : Real := (D.N : Real) * D.eps

/-- Mass angle rule `theta = eps * m`. -/
def massAngle : Real := D.eps * D.m

/-- Accumulated mass angle `N * theta`. -/
def accumulatedAngle : Real := (D.N : Real) * D.massAngle

@[simp] theorem timeStep_eq : D.timeStep = D.eps := rfl

@[simp] theorem massAngle_eq : D.massAngle = D.eps * D.m := rfl

/-- The accumulated mass angle is total time times mass. -/
theorem accumulatedAngle_eq_totalTime_mul_mass :
    D.accumulatedAngle = D.totalTime * D.m := by
  unfold accumulatedAngle massAngle totalTime
  ring_nf

end CheckerboardDiracScalingData

/-! ## Continuum Dirac objects -/

/-- The 1+1D Dirac Hamiltonian symbol in the right/left null basis:
`H(p) = p * directionGrade - m * reversal`. -/
def diracHamiltonianSymbol (m p : Real) : Matrix Direction Direction Complex :=
  (p : Complex) • directionGrade - (m : Complex) • reversal

/-- Continuum Dirac time-evolution symbol `exp(-i * t * H(p))`. -/
def diracEvolutionSymbol (m p t : Real) : Matrix Direction Direction Complex :=
  NormedSpace.exp ((-Complex.I * (t : Complex)) •
    diracHamiltonianSymbol m p)

/-! ## Finite momentum-space evolution objects -/

/-- Diagonal null-transport phase in momentum space. The right mover (`0`) gets
`exp(-i * p * eps)` and the left mover (`1`) gets `exp(i * p * eps)`. -/
def nullShiftSymbol (eps p : Real) : Matrix Direction Direction Complex :=
  Matrix.diagonal (fun d : Direction =>
    if d = 0 then Complex.exp (-(Complex.I * ((p * eps : Real) : Complex)))
    else Complex.exp (Complex.I * ((p * eps : Real) : Complex)))

/-- Momentum-space single-step checkerboard symbol: mass mixing followed by
null transport. In matrix multiplication order, the right factor
`isotropicStep D.massAngle` acts first. -/
def momentumStepSymbol (D : CheckerboardDiracScalingData) (p : Real) :
    Matrix Direction Direction Complex :=
  nullShiftSymbol D.eps p * isotropicStep D.massAngle

/-- Raw-parameter form of the momentum-space single-step symbol. This is the
convenient API for per-step Taylor estimates in the lattice spacing `eps`. -/
def momentumStepSymbolRaw (eps m p : Real) :
    Matrix Direction Direction Complex :=
  nullShiftSymbol eps p * isotropicStep (eps * m)

/-- The scaling-record step is the raw step at the record's spacing and mass. -/
theorem momentumStepSymbol_eq_raw
    (D : CheckerboardDiracScalingData) (p : Real) :
    momentumStepSymbol D p = momentumStepSymbolRaw D.eps D.m p := by
  rfl

/-- First-order Dirac model for one momentum-space step:
`1 - i * eps * H(p)`. -/
def momentumStepFirstOrderModel (eps m p : Real) :
    Matrix Direction Direction Complex :=
  (1 : Matrix Direction Direction Complex) +
    ((-Complex.I * (eps : Complex)) • diracHamiltonianSymbol m p)

/-- Continuum one-step exponential symbol `exp(-i * eps * H(p))`. This is the
one-step factor that eventually replaces the first-order model in the
matrix-power comparison. -/
def continuumStepSymbol (eps m p : Real) :
    Matrix Direction Direction Complex :=
  NormedSpace.exp ((-Complex.I * (eps : Complex)) • diracHamiltonianSymbol m p)

/-- Difference between the first-order one-step model and the continuum
one-step exponential factor. -/
def continuumStepBridgeRemainder (eps m p : Real) :
    Matrix Direction Direction Complex :=
  momentumStepFirstOrderModel eps m p - continuumStepSymbol eps m p

/-- Local L1 size of the first-order-model to exponential one-step bridge. -/
def continuumStepBridgeDiscrepancy (eps m p : Real) : Real :=
  matrixL1Norm (continuumStepBridgeRemainder eps m p)

/-- The first-order-model to exponential bridge discrepancy is nonnegative. -/
theorem continuumStepBridgeDiscrepancy_nonneg (eps m p : Real) :
    0 ≤ continuumStepBridgeDiscrepancy eps m p :=
  matrixL1Norm_nonneg _

/-- Per-step first-order remainder for the finite momentum-space symbol. -/
def momentumStepFirstOrderRemainder (eps m p : Real) :
    Matrix Direction Direction Complex :=
  momentumStepSymbolRaw eps m p - momentumStepFirstOrderModel eps m p

/-- Scalar L1 size of the per-step first-order remainder. -/
def momentumStepFirstOrderDiscrepancy (eps m p : Real) : Real :=
  matrixL1Norm (momentumStepFirstOrderRemainder eps m p)

/-- The per-step first-order discrepancy is nonnegative. -/
theorem momentumStepFirstOrderDiscrepancy_nonneg (eps m p : Real) :
    0 ≤ momentumStepFirstOrderDiscrepancy eps m p :=
  matrixL1Norm_nonneg _

/-- In this local entrywise L1 norm, the identity matrix has size `2`.
This is why the norm is useful for finite error estimates but is not, by
itself, the final stability norm for an `N ~ 1 / eps` Trotter product. -/
theorem matrixL1Norm_one :
    matrixL1Norm (1 : Matrix Direction Direction Complex) = 2 := by
  unfold matrixL1Norm
  norm_num [Fin.sum_univ_two]

/-! ## Scoped stable norm candidate -/

section LinftyOperatorNorm

open scoped Matrix.Norms.Operator

/-- Mathlib's scoped `L_infinity` operator norm has identity size `1` on these
matrices. This is the likely norm for the final long-product stability theorem. -/
theorem linftyOpNorm_one :
    ‖(1 : Matrix Direction Direction Complex)‖ = 1 := by
  simp

/-- Mathlib's scoped `L_infinity` operator norm is submultiplicative. -/
theorem linftyOpNorm_mul_le
    (A B : Matrix Direction Direction Complex) :
    ‖A * B‖ ≤ ‖A‖ * ‖B‖ :=
  Matrix.linfty_opNorm_mul A B

/-- The scoped `L_infinity` operator norm is bounded by the local entrywise L1
norm. This gives a one-way bridge from existing error estimates to the stable
operator norm. -/
theorem linftyOpNorm_le_matrixL1Norm
    (A : Matrix Direction Direction Complex) :
    ‖A‖ ≤ matrixL1Norm A := by
  rw [Matrix.linfty_opNorm_def]
  unfold matrixL1Norm
  simp only [Fin.sum_univ_two]
  change ↑((Finset.univ.sup fun i : Direction => ‖A i 0‖₊ + ‖A i 1‖₊)) ≤
    ↑(‖A 0 0‖₊ + ‖A 0 1‖₊ + (‖A 1 0‖₊ + ‖A 1 1‖₊))
  exact_mod_cast (by
    refine Finset.sup_le fun i _ => ?_
    fin_cases i
    · exact le_add_of_nonneg_right (zero_le _)
    · calc
        ‖A 1 0‖₊ + ‖A 1 1‖₊
            ≤ (‖A 0 0‖₊ + ‖A 0 1‖₊) + (‖A 1 0‖₊ + ‖A 1 1‖₊) :=
              le_add_of_nonneg_left (zero_le _)
        _ = ‖A 0 0‖₊ + ‖A 0 1‖₊ + (‖A 1 0‖₊ + ‖A 1 1‖₊) := by
              rw [add_assoc])

/-- In the two-direction checkerboard fiber, the entrywise L1 norm is at most
twice the scoped `L_infinity` operator norm.  This finite bridge turns a
stable-operator-norm convergence statement into the entrywise norm used by the
original boundary statement. -/
theorem matrixL1Norm_le_two_mul_linftyOpNorm
    (A : Matrix Direction Direction Complex) :
    matrixL1Norm A ≤ 2 * ‖A‖ := by
  rw [Matrix.linfty_opNorm_def]
  unfold matrixL1Norm
  simp only [Fin.sum_univ_two]
  let r0 : NNReal := ‖A 0 0‖₊ + ‖A 0 1‖₊
  let r1 : NNReal := ‖A 1 0‖₊ + ‖A 1 1‖₊
  let s : NNReal :=
    Finset.univ.sup fun i : Direction => ‖A i 0‖₊ + ‖A i 1‖₊
  have h0 : (r0 : ℝ) ≤ (s : ℝ) := by
    have h0nn : r0 ≤ s := by
      simpa [r0, s] using Finset.le_sup (s := (Finset.univ : Finset Direction))
        (f := fun i : Direction => ‖A i 0‖₊ + ‖A i 1‖₊) (Finset.mem_univ 0)
    exact_mod_cast h0nn
  have h1 : (r1 : ℝ) ≤ (s : ℝ) := by
    have h1nn : r1 ≤ s := by
      simpa [r1, s] using Finset.le_sup (s := (Finset.univ : Finset Direction))
        (f := fun i : Direction => ‖A i 0‖₊ + ‖A i 1‖₊) (Finset.mem_univ 1)
    exact_mod_cast h1nn
  change (r0 : ℝ) + (r1 : ℝ) ≤ 2 * (s : ℝ)
  linarith

end LinftyOperatorNorm

/-! ## Scoped `L2` operator-norm bridge and unitary stability

This section explores Mathlib's scoped `L2` operator norm from
`Mathlib.Analysis.CStarAlgebra.Matrix`, which transports the Hilbert-space
operator norm to finite matrices. Under this scoped norm,
`Matrix Direction Direction Complex` is a `CStarRing`, so a unitary one-step
symbol has operator norm exactly `1`. This is the natural norm for unitary
quantum-walk evolution: every finite product of unitary steps then has operator
norm `1`, without any accumulating constant.

All facts stay inside this scoped section and add no global matrix-norm
instance. -/
section L2OperatorNorm

open scoped Matrix.Norms.L2Operator

/-- Under the scoped `L2` operator norm the identity matrix has norm `1`. -/
theorem l2OpNorm_one :
    ‖(1 : Matrix Direction Direction Complex)‖ = 1 :=
  CStarRing.norm_one

/-- The scoped `L2` operator norm is submultiplicative. This is the norm's
`NormedRing` structure; it is also available directly as `Matrix.l2_opNorm_mul`. -/
theorem l2OpNorm_mul_le (A B : Matrix Direction Direction Complex) :
    ‖A * B‖ ≤ ‖A‖ * ‖B‖ :=
  norm_mul_le A B

/-- The scoped `L2` operator norm of any unitary matrix is exactly `1`. This is
the C*-algebra fact `CStarRing.norm_of_mem_unitary`, transported through the
identification `Matrix.unitaryGroup Direction Complex = unitary (Matrix ...)`. -/
theorem l2OpNorm_of_mem_unitaryGroup
    {A : Matrix Direction Direction Complex}
    (hA : A ∈ Matrix.unitaryGroup Direction Complex) : ‖A‖ = 1 :=
  CStarRing.norm_of_mem_unitary hA

/-! ### Unitarity of the finite one-step symbol

These membership facts are norm-independent. They only use the standard
conjugate-transpose `StarRing` structure on matrices, but they are collected
here because they feed the operator-norm stability result below. -/

/-- The diagonal null-transport phase is unitary: its diagonal entries are
complex exponentials of purely imaginary arguments, hence have unit modulus. -/
theorem nullShiftSymbol_mem_unitaryGroup (eps p : Real) :
    nullShiftSymbol eps p ∈ Matrix.unitaryGroup Direction Complex := by
  unfold nullShiftSymbol
  rw [Matrix.mem_unitaryGroup_iff, Matrix.star_eq_conjTranspose,
    Matrix.diagonal_conjTranspose, Matrix.diagonal_mul_diagonal,
    ← Matrix.diagonal_one]
  congr 1
  ext d
  simp only [Pi.star_apply, RCLike.star_def]
  rw [Complex.mul_conj, Complex.normSq_eq_norm_sq]
  have hnorm :
      ‖(if d = 0 then Complex.exp (-(Complex.I * ((p * eps : Real) : Complex)))
        else Complex.exp (Complex.I * ((p * eps : Real) : Complex)))‖ = 1 := by
    by_cases h : d = 0 <;> simp [h, Complex.norm_exp]
  rw [hnorm]
  norm_num

/-- The isotropic mass-mixing step is unitary. This repackages the existing
exact identity `checkerStep_isotropic_unitary` as unitary-group membership. -/
theorem isotropicStep_mem_unitaryGroup (theta : Real) :
    isotropicStep theta ∈ Matrix.unitaryGroup Direction Complex := by
  rw [Matrix.mem_unitaryGroup_iff', Matrix.star_eq_conjTranspose]
  unfold isotropicStep
  exact checkerStep_isotropic_unitary theta

/-- The finite one-step momentum symbol is unitary, as a product of the unitary
null-transport phase and the unitary mass-mixing step. -/
theorem momentumStepSymbolRaw_mem_unitaryGroup (eps m p : Real) :
    momentumStepSymbolRaw eps m p ∈ Matrix.unitaryGroup Direction Complex := by
  unfold momentumStepSymbolRaw
  exact mul_mem (nullShiftSymbol_mem_unitaryGroup eps p)
    (isotropicStep_mem_unitaryGroup (eps * m))

/-- The record-parameter one-step symbol is unitary. -/
theorem momentumStepSymbol_mem_unitaryGroup
    (D : CheckerboardDiracScalingData) (p : Real) :
    momentumStepSymbol D p ∈ Matrix.unitaryGroup Direction Complex := by
  rw [momentumStepSymbol_eq_raw]
  exact momentumStepSymbolRaw_mem_unitaryGroup D.eps D.m p

/-- **Operator-norm stability of the one-step symbol.** In the scoped `L2`
operator norm the finite one-step checkerboard symbol has norm exactly `1`. This
is the norm-stability property that makes the `L2` operator norm the natural
choice for unitary quantum-walk evolution: unlike the entrywise `matrixL1Norm`
for which `matrixL1Norm 1 = 2`, it assigns norm `1` to every unitary step and
hence to every finite product of steps. -/
theorem l2OpNorm_momentumStepSymbolRaw (eps m p : Real) :
    ‖momentumStepSymbolRaw eps m p‖ = 1 :=
  l2OpNorm_of_mem_unitaryGroup (momentumStepSymbolRaw_mem_unitaryGroup eps m p)

/-- Operator-norm stability for the record-parameter one-step symbol. -/
theorem l2OpNorm_momentumStepSymbol
    (D : CheckerboardDiracScalingData) (p : Real) :
    ‖momentumStepSymbol D p‖ = 1 :=
  l2OpNorm_of_mem_unitaryGroup (momentumStepSymbol_mem_unitaryGroup D p)

end L2OperatorNorm

/-! ## Scoped `L∞` operator-norm factor bounds

These are the finite per-factor norm bounds feeding the accumulated Trotter
estimate. They live in the scoped `L_infinity` operator norm and add no global
instance. -/

section LinftyFactorBounds

open scoped Matrix.Norms.Operator

/-
The null-transport phase is an isometry in the scoped `L∞` operator norm:
it is a diagonal matrix all of whose entries are unit-modulus phases.
-/
theorem linftyOpNorm_nullShiftSymbol_eq_one (eps p : Real) :
    ‖nullShiftSymbol eps p‖ = 1 := by
  convert Matrix.linfty_opNorm_diagonal _ using 1;
  refine' le_antisymm _ _ <;> norm_num [ Pi.norm_def ]; all_goals norm_num [ ← NNReal.coe_le_coe, Complex.norm_exp ]

/-- L∞ operator-norm bound for the null phase. -/
theorem linftyOpNorm_nullShiftSymbol_le_one (eps p : Real) :
    ‖nullShiftSymbol eps p‖ ≤ 1 :=
  (linftyOpNorm_nullShiftSymbol_eq_one eps p).le

/-- Exact `L∞` operator-norm (maximum absolute row sum) of the isotropic
mass-mixing step. Both rows of `isotropicStep theta = !![cos, i sin; i sin, cos]`
have the same absolute row sum `|cos theta| + |sin theta|`. -/
theorem linftyOpNorm_isotropicStep_eq (theta : Real) :
    ‖isotropicStep theta‖ = |Real.cos theta| + |Real.sin theta| := by
  rw [Matrix.linfty_opNorm_def, isotropicStep, checkerStep_eq,
    show (Finset.univ : Finset Direction) = {0, 1} by decide,
    Finset.sup_insert, Finset.sup_singleton]
  simp [add_comm]
  norm_cast

/-- `L∞` operator-norm bound for the isotropic mass-mixing step. -/
theorem linftyOpNorm_isotropicStep_le_one_add_abs (theta : Real) :
    ‖isotropicStep theta‖ ≤ 1 + |theta| := by
  rw [linftyOpNorm_isotropicStep_eq]
  exact add_le_add (Real.abs_cos_le_one _) Real.abs_sin_le_abs

/-- Finite per-step raw factor bound in the scoped `L∞` operator norm. -/
theorem linftyOpNorm_momentumStepSymbolRaw_le_one_add_abs
    (eps m p : Real) :
    ‖momentumStepSymbolRaw eps m p‖ ≤ 1 + |eps * m| := by
  refine le_trans (linftyOpNorm_mul_le _ _) ?_
  refine le_trans (mul_le_mul_of_nonneg_left
    (linftyOpNorm_isotropicStep_le_one_add_abs _) (norm_nonneg _)) ?_
  exact mul_le_of_le_one_left (by positivity)
    (linftyOpNorm_nullShiftSymbol_le_one _ _)

end LinftyFactorBounds

/-! ## Zero-step sanity checks -/

/-- At zero spacing, the raw momentum step is the identity. -/
theorem momentumStepSymbolRaw_zero (m p : Real) :
    momentumStepSymbolRaw 0 m p =
      (1 : Matrix Direction Direction Complex) := by
  unfold momentumStepSymbolRaw nullShiftSymbol
  rw [show 0 * m = 0 by ring_nf, isotropicStep_zero]
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply]

/-- At zero spacing, the first-order model is the identity. -/
theorem momentumStepFirstOrderModel_zero (m p : Real) :
    momentumStepFirstOrderModel 0 m p =
      (1 : Matrix Direction Direction Complex) := by
  unfold momentumStepFirstOrderModel
  simp

/-- At zero spacing, the continuum one-step exponential is the identity. -/
theorem continuumStepSymbol_zero (m p : Real) :
    continuumStepSymbol 0 m p =
      (1 : Matrix Direction Direction Complex) := by
  unfold continuumStepSymbol
  simp

/-- At zero spacing, the first-order-to-exponential bridge vanishes. -/
theorem continuumStepBridgeRemainder_zero (m p : Real) :
    continuumStepBridgeRemainder 0 m p =
      (0 : Matrix Direction Direction Complex) := by
  rw [continuumStepBridgeRemainder, momentumStepFirstOrderModel_zero,
    continuumStepSymbol_zero]
  simp

/-- At zero spacing, the first-order-to-exponential bridge discrepancy
vanishes. -/
theorem continuumStepBridgeDiscrepancy_zero (m p : Real) :
    continuumStepBridgeDiscrepancy 0 m p = 0 := by
  simp [continuumStepBridgeDiscrepancy, continuumStepBridgeRemainder_zero,
    matrixL1Norm_zero]

/-- At zero spacing, the per-step first-order remainder vanishes. -/
theorem momentumStepFirstOrderRemainder_zero (m p : Real) :
    momentumStepFirstOrderRemainder 0 m p =
      (0 : Matrix Direction Direction Complex) := by
  rw [momentumStepFirstOrderRemainder, momentumStepSymbolRaw_zero,
    momentumStepFirstOrderModel_zero]
  simp

/-- At zero spacing, the per-step first-order discrepancy vanishes. -/
theorem momentumStepFirstOrderDiscrepancy_zero (m p : Real) :
    momentumStepFirstOrderDiscrepancy 0 m p = 0 := by
  simp [momentumStepFirstOrderDiscrepancy, momentumStepFirstOrderRemainder_zero,
    matrixL1Norm_zero]

/-! ## Per-step second-order estimate

The results below establish the pointwise-in-momentum per-step second-order
Taylor estimate for the finite momentum-space checkerboard symbol: the one-step
symbol `momentumStepSymbolRaw eps m p` agrees with the first-order Dirac model
`1 - i * eps * diracHamiltonianSymbol m p` up to a remainder whose local
`matrixL1Norm` is `O(eps ^ 2)` as `eps -> 0`.

The proof is entrywise and elementary. It expands the `2 x 2` remainder into
four explicit complex entries, bounds each entry norm with scalar Taylor
estimates for `cos`, `sin`, and the complex exponential
(`Complex.norm_exp_sub_one_le`, `Complex.norm_exp_sub_one_sub_id_le`, and the
scaffold's `abs_cos_sub_one_le_half_sq`, `abs_sin_sub_le_sixth_cube`), then sums
the entrywise bounds through `matrixL1Norm`.

This is a pointwise momentum statement only; it makes no `L2` or position-space
claim, and it does not on its own establish any continuum limit. -/

/-- The complex exponential of a purely imaginary argument has unit norm. -/
private theorem norm_exp_I_mul_ofReal (a : Real) :
    ‖Complex.exp (Complex.I * (a : Complex))‖ = 1 := by
  rw [Complex.norm_exp]; simp

/-- Explicit entrywise form of the per-step first-order remainder as a `2 x 2`
complex matrix. The diagonal entries carry the null-transport phase times the
mass-mixing cosine minus the linear model; the off-diagonal entries carry the
phase times the mass-mixing sine minus the linear mass term. -/
theorem momentumStepFirstOrderRemainder_apply (eps m p : Real) :
    momentumStepFirstOrderRemainder eps m p =
      !![ Complex.exp (-(Complex.I * ((p * eps : Real) : Complex))) *
            (Real.cos (eps * m) : Complex) -
            (1 - Complex.I * (eps : Complex) * (p : Complex)),
          Complex.exp (-(Complex.I * ((p * eps : Real) : Complex))) *
            (Complex.I * (Real.sin (eps * m) : Complex)) -
            Complex.I * (eps : Complex) * (m : Complex);
          Complex.exp (Complex.I * ((p * eps : Real) : Complex)) *
            (Complex.I * (Real.sin (eps * m) : Complex)) -
            Complex.I * (eps : Complex) * (m : Complex),
          Complex.exp (Complex.I * ((p * eps : Real) : Complex)) *
            (Real.cos (eps * m) : Complex) -
            (1 + Complex.I * (eps : Complex) * (p : Complex)) ] := by
  unfold momentumStepFirstOrderRemainder momentumStepSymbolRaw
    momentumStepFirstOrderModel nullShiftSymbol diracHamiltonianSymbol isotropicStep
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, checkerStep, nullTransport, massFlip, reversal,
      directionGrade, Matrix.sub_apply, Matrix.add_apply, Matrix.diagonal_apply]
  all_goals ring_nf

/-- Diagonal-entry bound: for a real phase parameter `a` with `|a| ≤ 1`, the
diagonal remainder entry `exp(i a) cos θ - (1 + i a)` has norm at most
`a ^ 2 + θ ^ 2 / 2`. -/
private theorem momentumStep_entry_diag_bound (a θ : Real) (ha : |a| ≤ 1) :
    ‖Complex.exp (Complex.I * (a : Complex)) * (Real.cos θ : Complex) -
        (1 + Complex.I * (a : Complex))‖ ≤ a ^ 2 + θ ^ 2 / 2 := by
  have hz : ‖Complex.I * (a : Complex)‖ ≤ 1 := by
    rw [norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Real.norm_eq_abs]
    exact ha
  have key : Complex.exp (Complex.I * (a : Complex)) * (Real.cos θ : Complex) -
        (1 + Complex.I * (a : Complex))
      = (Complex.exp (Complex.I * (a : Complex)) - 1 - Complex.I * (a : Complex))
        + Complex.exp (Complex.I * (a : Complex)) * ((Real.cos θ : Complex) - 1) := by
    ring_nf
  rw [key]
  have h1 := Complex.norm_exp_sub_one_sub_id_le hz
  have h2 : ‖Complex.exp (Complex.I * (a : Complex)) *
      ((Real.cos θ : Complex) - 1)‖ ≤ θ ^ 2 / 2 := by
    rw [norm_mul, norm_exp_I_mul_ofReal, one_mul]
    have hc : ‖((Real.cos θ : Complex) - 1)‖ = |Real.cos θ - 1| := by
      rw [show ((Real.cos θ : Complex) - 1) = ((Real.cos θ - 1 : Real) : Complex) by
            push_cast; ring_nf, Complex.norm_real, Real.norm_eq_abs]
    rw [hc]; exact abs_cos_sub_one_le_half_sq θ
  calc ‖(Complex.exp (Complex.I * (a : Complex)) - 1 - Complex.I * (a : Complex))
        + Complex.exp (Complex.I * (a : Complex)) * ((Real.cos θ : Complex) - 1)‖
      ≤ ‖Complex.exp (Complex.I * (a : Complex)) - 1 - Complex.I * (a : Complex)‖
        + ‖Complex.exp (Complex.I * (a : Complex)) * ((Real.cos θ : Complex) - 1)‖ :=
        norm_add_le _ _
    _ ≤ ‖Complex.I * (a : Complex)‖ ^ 2 + θ ^ 2 / 2 := add_le_add h1 h2
    _ = a ^ 2 + θ ^ 2 / 2 := by
        rw [norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Real.norm_eq_abs,
          sq_abs]

/-- Off-diagonal-entry bound: for a real phase parameter `a` with `|a| ≤ 1`,
the off-diagonal remainder entry `exp(i a) (i sin θ) - i θ` has norm at most
`2 |a| |θ| + |θ| ^ 3 / 6`. -/
private theorem momentumStep_entry_offdiag_bound (a θ : Real) (ha : |a| ≤ 1) :
    ‖Complex.exp (Complex.I * (a : Complex)) * (Complex.I * (Real.sin θ : Complex)) -
        Complex.I * (θ : Complex)‖ ≤ 2 * |a| * |θ| + |θ| ^ 3 / 6 := by
  have hz : ‖Complex.I * (a : Complex)‖ ≤ 1 := by
    rw [norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Real.norm_eq_abs]
    exact ha
  have key : Complex.exp (Complex.I * (a : Complex)) *
        (Complex.I * (Real.sin θ : Complex)) - Complex.I * (θ : Complex)
      = Complex.I * (((Complex.exp (Complex.I * (a : Complex)) - 1) *
          (Real.sin θ : Complex)) + ((Real.sin θ : Complex) - (θ : Complex))) := by
    ring_nf
  rw [key, norm_mul, Complex.norm_I, one_mul]
  have h1 : ‖(Complex.exp (Complex.I * (a : Complex)) - 1) *
      (Real.sin θ : Complex)‖ ≤ 2 * |a| * |θ| := by
    rw [norm_mul]
    have hb1 : ‖Complex.exp (Complex.I * (a : Complex)) - 1‖ ≤ 2 * |a| := by
      have hbase := Complex.norm_exp_sub_one_le hz
      rwa [show ‖Complex.I * (a : Complex)‖ = |a| by
        rw [norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Real.norm_eq_abs]]
        at hbase
    have hb2 : ‖(Real.sin θ : Complex)‖ = |Real.sin θ| := by
      rw [Complex.norm_real, Real.norm_eq_abs]
    rw [hb2]
    calc ‖Complex.exp (Complex.I * (a : Complex)) - 1‖ * |Real.sin θ|
        ≤ (2 * |a|) * |θ| :=
          mul_le_mul hb1 Real.abs_sin_le_abs (abs_nonneg _) (by positivity)
      _ = 2 * |a| * |θ| := by ring_nf
  have h2 : ‖((Real.sin θ : Complex) - (θ : Complex))‖ ≤ |θ| ^ 3 / 6 := by
    have hcast : ((Real.sin θ : Complex) - (θ : Complex)) =
        ((Real.sin θ - θ : Real) : Complex) := by push_cast; ring_nf
    rw [hcast, Complex.norm_real, Real.norm_eq_abs]
    exact abs_sin_sub_le_sixth_cube θ
  calc ‖(Complex.exp (Complex.I * (a : Complex)) - 1) * (Real.sin θ : Complex)
        + ((Real.sin θ : Complex) - (θ : Complex))‖
      ≤ ‖(Complex.exp (Complex.I * (a : Complex)) - 1) * (Real.sin θ : Complex)‖
        + ‖((Real.sin θ : Complex) - (θ : Complex))‖ := norm_add_le _ _
    _ ≤ 2 * |a| * |θ| + |θ| ^ 3 / 6 := add_le_add h1 h2

/-- Explicit per-step quantitative bound: when `|p * eps| ≤ 1`, the per-step
first-order discrepancy is bounded by an explicit polynomial in `eps` whose
leading terms are quadratic. -/
theorem momentumStepFirstOrderDiscrepancy_le (eps m p : Real)
    (hpe : |p * eps| ≤ 1) :
    momentumStepFirstOrderDiscrepancy eps m p ≤
      2 * (p * eps) ^ 2 + (eps * m) ^ 2 + 4 * |p * eps| * |eps * m| +
        |eps * m| ^ 3 / 3 := by
  unfold momentumStepFirstOrderDiscrepancy matrixL1Norm
  rw [momentumStepFirstOrderRemainder_apply]
  simp only [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val', Matrix.of_apply, Matrix.empty_val', Matrix.cons_val_fin_one]
  have e00 : ‖Complex.exp (-(Complex.I * ((p * eps : Real) : Complex))) *
        (Real.cos (eps * m) : Complex) -
        (1 - Complex.I * (eps : Complex) * (p : Complex))‖
      ≤ (p * eps) ^ 2 + (eps * m) ^ 2 / 2 := by
    have heq : Complex.exp (-(Complex.I * ((p * eps : Real) : Complex))) *
          (Real.cos (eps * m) : Complex) -
          (1 - Complex.I * (eps : Complex) * (p : Complex))
        = Complex.exp (Complex.I * ((-(p * eps) : Real) : Complex)) *
            (Real.cos (eps * m) : Complex) -
            (1 + Complex.I * ((-(p * eps) : Real) : Complex)) := by push_cast; ring_nf
    rw [heq]
    calc _ ≤ (-(p * eps)) ^ 2 + (eps * m) ^ 2 / 2 :=
          momentumStep_entry_diag_bound (-(p * eps)) (eps * m) (by rwa [abs_neg])
      _ = (p * eps) ^ 2 + (eps * m) ^ 2 / 2 := by ring_nf
  have e11 : ‖Complex.exp (Complex.I * ((p * eps : Real) : Complex)) *
        (Real.cos (eps * m) : Complex) -
        (1 + Complex.I * (eps : Complex) * (p : Complex))‖
      ≤ (p * eps) ^ 2 + (eps * m) ^ 2 / 2 := by
    have heq : Complex.exp (Complex.I * ((p * eps : Real) : Complex)) *
          (Real.cos (eps * m) : Complex) -
          (1 + Complex.I * (eps : Complex) * (p : Complex))
        = Complex.exp (Complex.I * ((p * eps : Real) : Complex)) *
            (Real.cos (eps * m) : Complex) -
            (1 + Complex.I * ((p * eps : Real) : Complex)) := by push_cast; ring_nf
    rw [heq]; exact momentumStep_entry_diag_bound (p * eps) (eps * m) hpe
  have e01 : ‖Complex.exp (-(Complex.I * ((p * eps : Real) : Complex))) *
        (Complex.I * (Real.sin (eps * m) : Complex)) -
        Complex.I * (eps : Complex) * (m : Complex)‖
      ≤ 2 * |p * eps| * |eps * m| + |eps * m| ^ 3 / 6 := by
    have heq : Complex.exp (-(Complex.I * ((p * eps : Real) : Complex))) *
          (Complex.I * (Real.sin (eps * m) : Complex)) -
          Complex.I * (eps : Complex) * (m : Complex)
        = Complex.exp (Complex.I * ((-(p * eps) : Real) : Complex)) *
            (Complex.I * (Real.sin (eps * m) : Complex)) -
            Complex.I * ((eps * m : Real) : Complex) := by push_cast; ring_nf
    rw [heq]
    have hb := momentumStep_entry_offdiag_bound (-(p * eps)) (eps * m) (by rwa [abs_neg])
    rwa [abs_neg] at hb
  have e10 : ‖Complex.exp (Complex.I * ((p * eps : Real) : Complex)) *
        (Complex.I * (Real.sin (eps * m) : Complex)) -
        Complex.I * (eps : Complex) * (m : Complex)‖
      ≤ 2 * |p * eps| * |eps * m| + |eps * m| ^ 3 / 6 := by
    have heq : Complex.exp (Complex.I * ((p * eps : Real) : Complex)) *
          (Complex.I * (Real.sin (eps * m) : Complex)) -
          Complex.I * (eps : Complex) * (m : Complex)
        = Complex.exp (Complex.I * ((p * eps : Real) : Complex)) *
            (Complex.I * (Real.sin (eps * m) : Complex)) -
            Complex.I * ((eps * m : Real) : Complex) := by push_cast; ring_nf
    rw [heq]; exact momentumStep_entry_offdiag_bound (p * eps) (eps * m) hpe
  calc _ ≤ ((p * eps) ^ 2 + (eps * m) ^ 2 / 2) +
            (2 * |p * eps| * |eps * m| + |eps * m| ^ 3 / 6) +
            ((2 * |p * eps| * |eps * m| + |eps * m| ^ 3 / 6) +
              ((p * eps) ^ 2 + (eps * m) ^ 2 / 2)) :=
        add_le_add (add_le_add e00 e01) (add_le_add e10 e11)
    _ = 2 * (p * eps) ^ 2 + (eps * m) ^ 2 + 4 * |p * eps| * |eps * m| +
          |eps * m| ^ 3 / 3 := by ring_nf

/-- The key per-step second-order estimate: the local `matrixL1Norm` of the
per-step first-order remainder is `O(eps ^ 2)` as `eps -> 0`. -/
theorem momentumStepFirstOrderDiscrepancy_isBigO_sq (m p : Real) :
    (fun eps : Real => momentumStepFirstOrderDiscrepancy eps m p)
      =O[nhds (0 : Real)] (fun eps : Real => eps ^ 2) := by
  rw [Asymptotics.isBigO_iff]
  refine ⟨2 * p ^ 2 + m ^ 2 + 4 * |p| * |m| + |m| ^ 3 / 3, ?_⟩
  have hrpos : 0 < min 1 (1 / (|p| + 1)) := by
    apply lt_min one_pos; positivity
  filter_upwards [Icc_mem_nhds (show -min 1 (1 / (|p| + 1)) < 0 by linarith)
      (show (0 : Real) < min 1 (1 / (|p| + 1)) by linarith)] with eps heps
  have habs : |eps| ≤ min 1 (1 / (|p| + 1)) := by rw [abs_le]; exact heps
  have heps1 : |eps| ≤ 1 := le_trans habs (min_le_left _ _)
  have heps2 : |eps| ≤ 1 / (|p| + 1) := le_trans habs (min_le_right _ _)
  have hpe : |p * eps| ≤ 1 := by
    rw [abs_mul]
    calc |p| * |eps| ≤ |p| * (1 / (|p| + 1)) :=
          mul_le_mul_of_nonneg_left heps2 (abs_nonneg p)
      _ = |p| / (|p| + 1) := by ring_nf
      _ ≤ 1 := by rw [div_le_one (by positivity)]; linarith
  have hb := momentumStepFirstOrderDiscrepancy_le eps m p hpe
  have hee : |eps| * |eps| = eps ^ 2 := by rw [← sq, sq_abs]
  have hcube : |eps| ^ 3 ≤ eps ^ 2 := by
    calc |eps| ^ 3 = |eps| ^ 2 * |eps| := by ring_nf
      _ ≤ |eps| ^ 2 * 1 := mul_le_mul_of_nonneg_left heps1 (by positivity)
      _ = eps ^ 2 := by rw [mul_one, sq_abs]
  have t1 : 2 * (p * eps) ^ 2 ≤ 2 * p ^ 2 * eps ^ 2 := le_of_eq (by ring_nf)
  have t2 : (eps * m) ^ 2 ≤ m ^ 2 * eps ^ 2 := le_of_eq (by ring_nf)
  have t3 : 4 * |p * eps| * |eps * m| ≤ 4 * |p| * |m| * eps ^ 2 := le_of_eq (by
    rw [abs_mul, abs_mul,
      show (4 : Real) * (|p| * |eps|) * (|eps| * |m|) =
        4 * |p| * |m| * (|eps| * |eps|) from by ring_nf, hee])
  have t4 : |eps * m| ^ 3 / 3 ≤ |m| ^ 3 * eps ^ 2 / 3 := by
    rw [abs_mul, show (|eps| * |m|) ^ 3 = |eps| ^ 3 * |m| ^ 3 from by ring_nf]
    have hstep : |eps| ^ 3 * |m| ^ 3 ≤ eps ^ 2 * |m| ^ 3 := by
      nlinarith [hcube, pow_nonneg (abs_nonneg m) 3]
    linarith
  rw [Real.norm_eq_abs, Real.norm_eq_abs,
    abs_of_nonneg (momentumStepFirstOrderDiscrepancy_nonneg eps m p),
    abs_of_nonneg (sq_nonneg eps)]
  calc momentumStepFirstOrderDiscrepancy eps m p
      ≤ 2 * (p * eps) ^ 2 + (eps * m) ^ 2 + 4 * |p * eps| * |eps * m| +
          |eps * m| ^ 3 / 3 := hb
    _ ≤ 2 * p ^ 2 * eps ^ 2 + m ^ 2 * eps ^ 2 + 4 * |p| * |m| * eps ^ 2 +
          |m| ^ 3 * eps ^ 2 / 3 :=
        add_le_add (add_le_add (add_le_add t1 t2) t3) t4
    _ = (2 * p ^ 2 + m ^ 2 + 4 * |p| * |m| + |m| ^ 3 / 3) * eps ^ 2 := by ring_nf

/-- Fallback explicit-constant form of the per-step second-order estimate:
there is a nonnegative constant `C` (depending on `m` and `p`) such that the
per-step first-order discrepancy is eventually bounded by `C * eps ^ 2` near
`eps = 0`. -/
theorem momentumStepFirstOrderDiscrepancy_tendsto_zero_div_sq_bound
    (m p : Real) :
    ∃ C : Real, 0 ≤ C ∧
      ∀ᶠ eps in nhds (0 : Real),
        momentumStepFirstOrderDiscrepancy eps m p ≤ C * eps ^ 2 := by
  refine ⟨2 * p ^ 2 + m ^ 2 + 4 * |p| * |m| + |m| ^ 3 / 3, by positivity, ?_⟩
  have hrpos : 0 < min 1 (1 / (|p| + 1)) := by
    apply lt_min one_pos; positivity
  filter_upwards [Icc_mem_nhds (show -min 1 (1 / (|p| + 1)) < 0 by linarith)
      (show (0 : Real) < min 1 (1 / (|p| + 1)) by linarith)] with eps heps
  have habs : |eps| ≤ min 1 (1 / (|p| + 1)) := by rw [abs_le]; exact heps
  have heps1 : |eps| ≤ 1 := le_trans habs (min_le_left _ _)
  have heps2 : |eps| ≤ 1 / (|p| + 1) := le_trans habs (min_le_right _ _)
  have hpe : |p * eps| ≤ 1 := by
    rw [abs_mul]
    calc |p| * |eps| ≤ |p| * (1 / (|p| + 1)) :=
          mul_le_mul_of_nonneg_left heps2 (abs_nonneg p)
      _ = |p| / (|p| + 1) := by ring_nf
      _ ≤ 1 := by rw [div_le_one (by positivity)]; linarith
  have hb := momentumStepFirstOrderDiscrepancy_le eps m p hpe
  have hee : |eps| * |eps| = eps ^ 2 := by rw [← sq, sq_abs]
  have hcube : |eps| ^ 3 ≤ eps ^ 2 := by
    calc |eps| ^ 3 = |eps| ^ 2 * |eps| := by ring_nf
      _ ≤ |eps| ^ 2 * 1 := mul_le_mul_of_nonneg_left heps1 (by positivity)
      _ = eps ^ 2 := by rw [mul_one, sq_abs]
  have t1 : 2 * (p * eps) ^ 2 ≤ 2 * p ^ 2 * eps ^ 2 := le_of_eq (by ring_nf)
  have t2 : (eps * m) ^ 2 ≤ m ^ 2 * eps ^ 2 := le_of_eq (by ring_nf)
  have t3 : 4 * |p * eps| * |eps * m| ≤ 4 * |p| * |m| * eps ^ 2 := le_of_eq (by
    rw [abs_mul, abs_mul,
      show (4 : Real) * (|p| * |eps|) * (|eps| * |m|) =
        4 * |p| * |m| * (|eps| * |eps|) from by ring_nf, hee])
  have t4 : |eps * m| ^ 3 / 3 ≤ |m| ^ 3 * eps ^ 2 / 3 := by
    rw [abs_mul, show (|eps| * |m|) ^ 3 = |eps| ^ 3 * |m| ^ 3 from by ring_nf]
    have hstep : |eps| ^ 3 * |m| ^ 3 ≤ eps ^ 2 * |m| ^ 3 := by
      nlinarith [hcube, pow_nonneg (abs_nonneg m) 3]
    linarith
  calc momentumStepFirstOrderDiscrepancy eps m p
      ≤ 2 * (p * eps) ^ 2 + (eps * m) ^ 2 + 4 * |p * eps| * |eps * m| +
          |eps * m| ^ 3 / 3 := hb
    _ ≤ 2 * p ^ 2 * eps ^ 2 + m ^ 2 * eps ^ 2 + 4 * |p| * |m| * eps ^ 2 +
          |m| ^ 3 * eps ^ 2 / 3 :=
        add_le_add (add_le_add (add_le_add t1 t2) t3) t4
    _ = (2 * p ^ 2 + m ^ 2 + 4 * |p| * |m| + |m| ^ 3 / 3) * eps ^ 2 := by ring_nf

section LinftyOperatorNormEstimates

open scoped Matrix.Norms.Operator

/-- Operator-norm version of the per-step second-order estimate, obtained by
comparing Mathlib's scoped `L_infinity` operator norm to `matrixL1Norm`. -/
theorem linftyOpNorm_momentumStepFirstOrderRemainder_isBigO_sq
    (m p : Real) :
    (fun eps : Real => ‖momentumStepFirstOrderRemainder eps m p‖)
      =O[nhds (0 : Real)] (fun eps : Real => eps ^ 2) := by
  rcases momentumStepFirstOrderDiscrepancy_tendsto_zero_div_sq_bound m p with
    ⟨C, _hC, hC⟩
  rw [Asymptotics.isBigO_iff]
  refine ⟨C, ?_⟩
  filter_upwards [hC] with eps heps
  rw [Real.norm_eq_abs, abs_of_nonneg (norm_nonneg _), Real.norm_eq_abs,
    abs_of_nonneg (sq_nonneg eps)]
  exact le_trans (linftyOpNorm_le_matrixL1Norm _) heps

end LinftyOperatorNormEstimates

/-! ## Scoped operator-norm continuum bridge and power stability -/

section ContinuumBridgeOpNorm

open scoped Matrix.Norms.Operator

/--
Second-order remainder bound for the matrix exponential in the scoped
`L_infinity` operator norm: for `‖x‖ ≤ 1`, `NormedSpace.exp x` agrees with its
first-order Taylor polynomial `1 + x` up to `‖x‖ ^ 2`. This is the abstract
Banach-algebra estimate that drives the one-step exponential bridge.
-/
theorem norm_expMat_sub_one_sub_self_le
    (x : Matrix Direction Direction Complex) (hx : ‖x‖ ≤ 1) :
    ‖NormedSpace.exp x - 1 - x‖ ≤ ‖x‖ ^ 2 := by
  have h_sum : NormedSpace.exp x - 1 - x =
      ∑' n : ℕ, (1 / (n + 2).factorial : ℂ) • x ^ (n + 2) := by
    have h_exp : NormedSpace.exp x =
        ∑' n : ℕ, (1 / (n.factorial : ℂ) : ℂ) • x ^ n := by
      convert NormedSpace.exp_eq_tsum using 1
      constructor <;> intro h
      · convert NormedSpace.exp_eq_tsum
      · convert congr_fun (h ℂ) x using 1
        norm_num
    rw [h_exp, ← Summable.sum_add_tsum_nat_add 2]
    · norm_num [Finset.sum_range_succ]
      abel1
    · have := @NormedSpace.expSeries_summable' ℂ (Matrix Direction Direction ℂ)
      simpa using this x
  have h_term_bound :
      ∀ n : ℕ, ‖(1 / (n + 2).factorial : ℂ) • x ^ (n + 2)‖
        ≤ ‖x‖ ^ (n + 2) / (n + 2).factorial := by
    intro n
    have h_term_bound : ‖x ^ (n + 2)‖ ≤ ‖x‖ ^ (n + 2) := by
      induction' n + 2 with n ih <;> simp_all +decide [pow_succ']
      exact le_trans (linftyOpNorm_mul_le _ _)
        (mul_le_mul_of_nonneg_left ih (norm_nonneg _))
    convert mul_le_mul_of_nonneg_left h_term_bound
        (by positivity : 0 ≤ (1 : ℝ) / (n + 2).factorial) using 1
    · norm_num [div_eq_inv_mul, norm_smul]
    · ring
  have h_sum_bound :
      ‖∑' n : ℕ, (1 / (n + 2).factorial : ℂ) • x ^ (n + 2)‖
        ≤ ∑' n : ℕ, ‖x‖ ^ (n + 2) / (n + 2).factorial := by
    have hs_bound :
        Summable (fun n : ℕ => ‖x‖ ^ (n + 2) / (n + 2).factorial) := by
      simpa using (summable_nat_add_iff 2).2 <| Real.summable_pow_div_factorial ‖x‖
    have hs_norm :
        Summable (fun n : ℕ =>
          ‖(1 / (n + 2).factorial : ℂ) • x ^ (n + 2)‖) :=
      Summable.of_nonneg_of_le (fun n => norm_nonneg _) (fun n => h_term_bound n)
        hs_bound
    exact le_trans (norm_tsum_le_tsum_norm hs_norm)
      (Summable.tsum_le_tsum h_term_bound hs_norm hs_bound)
  have h_sum_bound' :
      ∑' n : ℕ, ‖x‖ ^ (n + 2) / (n + 2).factorial
        ≤ ‖x‖ ^ 2 * ∑' n : ℕ, (1 : ℝ) / (n + 2).factorial := by
    rw [← tsum_mul_left]
    have hs_left :
        Summable (fun n : ℕ => ‖x‖ ^ (n + 2) / (n + 2).factorial) := by
      simpa using (summable_nat_add_iff 2).2 <| Real.summable_pow_div_factorial ‖x‖
    have hs_right :
        Summable (fun n : ℕ => ‖x‖ ^ 2 * ((1 : ℝ) / (n + 2).factorial)) :=
      Summable.mul_left _ <|
        by simpa using (summable_nat_add_iff 2).2 <| Real.summable_pow_div_factorial 1
    refine Summable.tsum_le_tsum ?_ hs_left hs_right
    intro n
    rw [pow_add, mul_one_div]
    ring_nf
    exact mul_le_mul_of_nonneg_right
      (mul_le_of_le_one_right (sq_nonneg _) (pow_le_one₀ (norm_nonneg _) hx))
      (by positivity)
  have h_sum_bound'' : ∑' n : ℕ, (1 : ℝ) / (n + 2).factorial ≤ 1 := by
    have h_sum_bound'' :
        ∑' n : ℕ, (1 : ℝ) / (n + 2).factorial
          ≤ ∑' n : ℕ, (1 : ℝ) / (2 ^ (n + 1)) := by
      have hs_fact : Summable (fun n : ℕ => (1 : ℝ) / (n + 2).factorial) := by
        simpa using (summable_nat_add_iff 2).2 <| Real.summable_pow_div_factorial 1
      have hs_geo : Summable (fun n : ℕ => (1 : ℝ) / (2 ^ (n + 1))) := by
        simpa using (summable_nat_add_iff 1).2 <| summable_geometric_two
      refine Summable.tsum_le_tsum ?_ hs_fact hs_geo
      intro n
      gcongr
      norm_cast
      induction' n with n ih <;> norm_num [Nat.factorial_succ, pow_succ'] at *
      nlinarith [Nat.zero_le (2 ^ n)]
    exact h_sum_bound''.trans
      (by ring_nf; rw [tsum_mul_right, tsum_geometric_of_lt_one] <;> norm_num)
  exact h_sum.symm ▸ h_sum_bound.trans
    (h_sum_bound'.trans (mul_le_of_le_one_right (sq_nonneg _) h_sum_bound''))

/--
The one-step exponential bridge remainder
`continuumStepBridgeRemainder eps m p = (1 - i eps H) - exp(-i eps H)` is second
order in `eps` in the scoped `L_infinity` operator norm.
-/
theorem linftyOpNorm_continuumStepBridgeRemainder_isBigO_sq
    (m p : Real) :
    (fun eps : Real => ‖continuumStepBridgeRemainder eps m p‖)
      =O[nhds (0 : Real)] (fun eps : Real => eps ^ 2) := by
  have h_norm_smul :
      ∀ x : ℝ, ‖(-Complex.I * (x : ℂ)) • diracHamiltonianSymbol m p‖ =
        |x| * ‖diracHamiltonianSymbol m p‖ := by
    norm_num [norm_smul, Complex.norm_I]
  refine Asymptotics.isBigO_iff.mpr ?_
  refine ⟨‖diracHamiltonianSymbol m p‖ ^ 2, ?_⟩
  filter_upwards [Metric.ball_mem_nhds _
    (show 0 < (‖diracHamiltonianSymbol m p‖ + 1)⁻¹ from inv_pos.mpr <|
      add_pos_of_nonneg_of_pos (norm_nonneg _) zero_lt_one)] with x hx
  convert norm_expMat_sub_one_sub_self_le
    ((-Complex.I * (x : ℂ)) • diracHamiltonianSymbol m p) _ using 1
  · unfold continuumStepBridgeRemainder
    norm_num [continuumStepSymbol, momentumStepFirstOrderModel]
    rw [← norm_neg]
    abel_nf
  · simp_all +decide [mul_pow]
    ring
  · simp_all +decide
    nlinarith [abs_nonneg x, norm_nonneg (diracHamiltonianSymbol m p),
      mul_inv_cancel₀ (by
        linarith [norm_nonneg (diracHamiltonianSymbol m p)] :
        (‖diracHamiltonianSymbol m p‖ + 1) ≠ 0)]

/--
Reusable scoped-operator-norm power-difference stability. If two matrices `A`,
`B` have operator norm at most `M` and differ by at most `delta`, then their
`n`-th powers differ by at most `n * M ^ (n - 1) * delta`.

Because the scoped operator norm satisfies `‖1‖ = 1`, this holds for every `n`,
including `n = 0`.
-/
theorem linftyOpNorm_pow_sub_pow_le
    (A B : Matrix Direction Direction Complex)
    (M delta : Real) (n : Nat)
    (hA : ‖A‖ ≤ M) (hB : ‖B‖ ≤ M)
    (hAB : ‖A - B‖ ≤ delta) :
    ‖A ^ n - B ^ n‖ ≤ (n : Real) * M ^ (n - 1) * delta := by
  induction' n with k ih
  · norm_num
  · have h_telescope : A ^ (k + 1) - B ^ (k + 1) =
        A * (A ^ k - B ^ k) + (A - B) * B ^ k := by
      simp +decide [pow_succ', mul_sub, sub_mul]
    have h_ind : ‖A * (A ^ k - B ^ k) + (A - B) * B ^ k‖
        ≤ ‖A‖ * ‖A ^ k - B ^ k‖ + ‖A - B‖ * ‖B ^ k‖ := by
      exact le_trans (norm_add_le _ _)
        (add_le_add (norm_mul_le _ _) (norm_mul_le _ _))
    have h_bound : ‖A‖ * ‖A ^ k - B ^ k‖ + ‖A - B‖ * ‖B ^ k‖
        ≤ M * (k * M ^ (k - 1) * delta) + delta * M ^ k := by
      gcongr
      · exact le_trans (norm_nonneg _) hA
      · exact le_trans (norm_nonneg _) hAB
      · refine Nat.recOn k ?_ ?_ <;> simp_all +decide [pow_succ']
        exact fun n hn => le_trans (linftyOpNorm_mul_le _ _)
          (mul_le_mul hB hn (by positivity)
            (by linarith [norm_nonneg A, norm_nonneg B]))
    cases k <;> simp_all +decide [pow_succ']
    ring_nf at *
    nlinarith

/-- The matrix exponential is bounded in the scoped L-infinity operator norm by
the scalar exponential of the norm. -/
theorem linftyOpNorm_exp_le (X : Matrix Direction Direction Complex) :
    ‖NormedSpace.exp X‖ ≤ Real.exp ‖X‖ := by
  rw [NormedSpace.exp_eq_tsum (𝕂 := Complex)]
  have hsum :
      Summable (fun n : ℕ => ‖((n.factorial : Complex)⁻¹) • X ^ n‖) := by
    simpa using NormedSpace.norm_expSeries_summable' (𝕂 := Complex) (x := X)
  refine le_trans (norm_tsum_le_tsum_norm hsum) ?_
  have hexpr : Real.exp ‖X‖ = ∑' n : ℕ, ‖X‖ ^ n / n.factorial := by
    rw [Real.exp_eq_exp_ℝ, NormedSpace.exp_eq_tsum_div]
  rw [hexpr]
  refine Summable.tsum_mono hsum (Real.summable_pow_div_factorial ‖X‖) (fun n => ?_)
  rw [norm_smul, norm_inv]
  simp only [Complex.norm_natCast]
  rw [div_eq_inv_mul]
  gcongr
  exact norm_pow_le X n

/-- The continuum one-step factor has the standard exponential operator-norm
bound in the scoped L-infinity norm. -/
theorem linftyOpNorm_continuumStepSymbol_le_exp (eps m p : Real) :
    ‖continuumStepSymbol eps m p‖
      ≤ Real.exp (|eps| * ‖diracHamiltonianSymbol m p‖) := by
  unfold continuumStepSymbol
  refine le_trans (linftyOpNorm_exp_le
    ((-Complex.I * (eps : Complex)) • diracHamiltonianSymbol m p)) ?_
  gcongr
  rw [norm_smul, norm_mul, norm_neg, Complex.norm_I, one_mul, Complex.norm_real,
    Real.norm_eq_abs]

/--
The combined per-step estimate. The finite raw momentum step and the continuum
one-step exponential differ to second order in `eps`, in the scoped
`L_infinity` operator norm. This is the triangle combination of the finite-step
first-order remainder and the exponential bridge remainder.
-/
theorem linftyOpNorm_momentumStep_sub_continuumStep_isBigO_sq
    (m p : Real) :
    (fun eps : Real =>
        ‖momentumStepSymbolRaw eps m p - continuumStepSymbol eps m p‖)
      =O[nhds (0 : Real)] (fun eps : Real => eps ^ 2) := by
  have h_diff : ∀ eps : ℝ,
      momentumStepSymbolRaw eps m p - continuumStepSymbol eps m p =
        momentumStepFirstOrderRemainder eps m p + continuumStepBridgeRemainder eps m p := by
    intro eps
    simp +decide [momentumStepFirstOrderRemainder, continuumStepBridgeRemainder]
  have h_sum :
      (fun eps => ‖momentumStepFirstOrderRemainder eps m p‖ +
        ‖continuumStepBridgeRemainder eps m p‖)
        =O[nhds 0] (fun eps => eps ^ 2) := by
    exact Asymptotics.IsBigO.add
      (linftyOpNorm_momentumStepFirstOrderRemainder_isBigO_sq m p)
      (linftyOpNorm_continuumStepBridgeRemainder_isBigO_sq m p)
  simp_all +decide [Asymptotics.IsBigO, Asymptotics.IsBigOWith]
  exact ⟨h_sum.choose, h_sum.choose_spec.mono fun x hx =>
    le_trans (norm_add_le _ _) (le_trans (le_abs_self _) hx)⟩

end ContinuumBridgeOpNorm

/-- The finite momentum-space `N`-step evolution symbol. -/
def momentumEvolution (D : CheckerboardDiracScalingData) (p : Real) :
    Matrix Direction Direction Complex :=
  momentumStepSymbol D p ^ D.N

section L2MomentumEvolution

open scoped Matrix.Norms.L2Operator

/-- The finite `N`-step momentum evolution is unitary, as a power of the unitary
one-step checkerboard symbol. -/
theorem momentumEvolution_mem_unitaryGroup
    (D : CheckerboardDiracScalingData) (p : Real) :
    momentumEvolution D p ∈ Matrix.unitaryGroup Direction Complex := by
  unfold momentumEvolution
  exact pow_mem (momentumStepSymbol_mem_unitaryGroup D p) D.N

/-- In the scoped `L2` operator norm, every finite momentum evolution has norm
exactly `1`. This is the finite-product normalization needed before any
long-time Trotter accumulation theorem. -/
theorem l2OpNorm_momentumEvolution
    (D : CheckerboardDiracScalingData) (p : Real) :
    ‖momentumEvolution D p‖ = 1 :=
  l2OpNorm_of_mem_unitaryGroup (momentumEvolution_mem_unitaryGroup D p)

end L2MomentumEvolution

open scoped Matrix.Norms.Operator in
/-- Powers of the continuum one-step symbol compose to the continuum Dirac
evolution at the corresponding total time. -/
theorem continuumStepSymbol_pow_eq_diracEvolutionSymbol
    (eps m p : Real) (N : Nat) :
    continuumStepSymbol eps m p ^ N =
      diracEvolutionSymbol m p ((N : Real) * eps) := by
  unfold continuumStepSymbol diracEvolutionSymbol
  rw [← NormedSpace.exp_nsmul N
    ((-Complex.I * (eps : Complex)) • diracHamiltonianSymbol m p)]
  congr 1
  ext i j
  simp [Matrix.smul_apply]
  ring

open scoped Matrix.Norms.Operator in
/-- Finite `N`-step stability bound comparing the checkerboard evolution with
the corresponding power of the continuum one-step symbol. This is the direct
application of `linftyOpNorm_pow_sub_pow_le` to the concrete symbols. -/
theorem linftyOpNorm_momentumEvolution_sub_continuumPow_le
    (D : CheckerboardDiracScalingData) (p M delta : Real)
    (hA : ‖momentumStepSymbolRaw D.eps D.m p‖ ≤ M)
    (hB : ‖continuumStepSymbol D.eps D.m p‖ ≤ M)
    (hAB : ‖momentumStepSymbolRaw D.eps D.m p -
      continuumStepSymbol D.eps D.m p‖ ≤ delta) :
    ‖momentumEvolution D p - continuumStepSymbol D.eps D.m p ^ D.N‖
      ≤ (D.N : Real) * M ^ (D.N - 1) * delta := by
  unfold momentumEvolution
  rw [momentumStepSymbol_eq_raw]
  exact linftyOpNorm_pow_sub_pow_le
    (momentumStepSymbolRaw D.eps D.m p)
    (continuumStepSymbol D.eps D.m p) M delta D.N hA hB hAB

open scoped Matrix.Norms.Operator in
/-- Finite `N`-step stability bound against the continuum Dirac evolution at
the matching total time. This packages the concrete power-stability bound with
`continuumStepSymbol_pow_eq_diracEvolutionSymbol`. -/
theorem linftyOpNorm_momentumEvolution_sub_diracEvolution_le
    (D : CheckerboardDiracScalingData) (p M delta : Real)
    (hA : ‖momentumStepSymbolRaw D.eps D.m p‖ ≤ M)
    (hB : ‖continuumStepSymbol D.eps D.m p‖ ≤ M)
    (hAB : ‖momentumStepSymbolRaw D.eps D.m p -
      continuumStepSymbol D.eps D.m p‖ ≤ delta) :
    ‖momentumEvolution D p - diracEvolutionSymbol D.m p D.totalTime‖
      ≤ (D.N : Real) * M ^ (D.N - 1) * delta := by
  rw [CheckerboardDiracScalingData.totalTime]
  rw [← continuumStepSymbol_pow_eq_diracEvolutionSymbol D.eps D.m p D.N]
  exact linftyOpNorm_momentumEvolution_sub_continuumPow_le D p M delta hA hB hAB

/-! ## Accumulated Trotter bound with explicit exponential stability factor

These results specialize the abstract power-stability wrapper
`linftyOpNorm_momentumEvolution_sub_diracEvolution_le` to the concrete
checkerboard step. The stability factor is chosen as `exp(|eps| * ‖H(p)‖)`,
which simultaneously dominates the raw finite step (`≤ 1 + |eps*m|`) and the
continuum one-step exponential factor. Everything is pointwise in momentum `p`
and stays in the scoped `L_infinity` operator norm. -/

section AccumulatedTrotter

open scoped Matrix.Norms.Operator

/-
The `L∞` operator norm (maximum absolute row sum) of the Dirac Hamiltonian
symbol `H(p) = !![p, -m; -m, -p]` is `|p| + |m|`.
-/
theorem linftyOpNorm_diracHamiltonianSymbol_eq (m p : Real) :
    ‖diracHamiltonianSymbol m p‖ = |p| + |m| := by
  unfold diracHamiltonianSymbol;
  norm_num [ Matrix.linfty_opNorm_def, directionGrade, reversal ];
  erw [ show ( Finset.univ : Finset ( Fin 2 ) ) = { 0, 1 } by decide, Finset.sup_insert, Finset.sup_singleton ] ; norm_num;
  linarith

/-
The finite raw checkerboard step is dominated by the exponential stability
factor `exp(|eps| * ‖H(p)‖)`.
-/
theorem linftyOpNorm_momentumStepSymbolRaw_le_exp
    (eps m p : Real) :
    ‖momentumStepSymbolRaw eps m p‖
      ≤ Real.exp (|eps| * ‖diracHamiltonianSymbol m p‖) := by
  refine' le_trans ( linftyOpNorm_momentumStepSymbolRaw_le_one_add_abs _ _ _ ) _;
  rw [ linftyOpNorm_diracHamiltonianSymbol_eq ];
  rw [ abs_mul ];
  exact le_trans ( by nlinarith [ abs_nonneg eps, abs_nonneg m, abs_nonneg p ] ) ( Real.add_one_le_exp _ )

/-
Accumulated finite `N`-step bound comparing the checkerboard evolution with
the continuum Dirac evolution at the matching total time, using the explicit
exponential stability factor. The per-step second-order discrepancy `delta`
is supplied as a hypothesis (e.g. from
`linftyOpNorm_momentumStep_sub_continuumStep_isBigO_sq`).
-/
theorem linftyOpNorm_momentumEvolution_sub_diracEvolution_exp_bound
    (D : CheckerboardDiracScalingData) (p delta : Real)
    (hAB : ‖momentumStepSymbolRaw D.eps D.m p
      - continuumStepSymbol D.eps D.m p‖ ≤ delta) :
    ‖momentumEvolution D p - diracEvolutionSymbol D.m p D.totalTime‖
      ≤ (D.N : Real)
        * Real.exp (|D.eps| * ‖diracHamiltonianSymbol D.m p‖) ^ (D.N - 1)
        * delta := by
  apply linftyOpNorm_momentumEvolution_sub_diracEvolution_le
  · exact linftyOpNorm_momentumStepSymbolRaw_le_exp D.eps D.m p
  · exact linftyOpNorm_continuumStepSymbol_le_exp D.eps D.m p
  · exact hAB

end AccumulatedTrotter

/-! ## Observation / interpolation API -/

/-- Spatial position of lattice site `j` at spacing `eps`. -/
def latticeSite (D : CheckerboardDiracScalingData) (j : Int) : Real :=
  (j : Real) * D.eps

/-- Sample a continuum spinor field at lattice site `j`. This is only the
restriction map; interpolation back to the continuum is a later object. -/
def sampleContinuum (D : CheckerboardDiracScalingData)
    (psi : Real → (Direction → Complex)) (j : Int) : Direction → Complex :=
  psi (latticeSite D j)

/-- Momentum observation window for the pointwise first comparison theorem. -/
def MomentumWindow (D : CheckerboardDiracScalingData) (p : Real) : Prop :=
  |p| ≤ D.pMax

/-- Pointwise finite-dimensional discrepancy between the finite momentum
evolution and the continuum Dirac evolution, measured with the local scalar
`matrixL1Norm`. This definition asserts no convergence. -/
def momentumEvolutionDiscrepancy (D : CheckerboardDiracScalingData)
    (p : Real) : Real :=
  matrixL1Norm (momentumEvolution D p -
    diracEvolutionSymbol D.m p D.totalTime)

/-- The pointwise momentum discrepancy is nonnegative. -/
theorem momentumEvolutionDiscrepancy_nonneg
    (D : CheckerboardDiracScalingData) (p : Real) :
    0 ≤ momentumEvolutionDiscrepancy D p :=
  matrixL1Norm_nonneg _


/-! ## Matrix-power / Trotter stability toolkit

These are general, reusable finite-dimensional estimates in the local scalar
`matrixL1Norm`, aimed at the next step after the per-step second-order estimate:
turning a per-step bound `matrixL1Norm (A - B) ≤ δ` and per-power stability
bounds `matrixL1Norm (A ^ k), matrixL1Norm (B ^ k) ≤ M` into an accumulated
bound on `matrixL1Norm (A ^ n - B ^ n)`.

`matrixL1Norm` is submultiplicative (`matrixL1Norm_mul_le`), so it behaves like
a genuine matrix norm for these telescoping arguments, even though it is kept as
a plain scalar function rather than a global `Norm` instance. -/

/-- The local `matrixL1Norm` is submultiplicative: the norm of a product is at
most the product of the norms. -/
theorem matrixL1Norm_mul_le (A B : Matrix Direction Direction Complex) :
    matrixL1Norm (A * B) ≤ matrixL1Norm A * matrixL1Norm B := by
  unfold matrixL1Norm
  have hentry : ∀ i j, ‖(A * B) i j‖ ≤ ∑ k, ‖A i k‖ * ‖B k j‖ := by
    intro i j
    rw [Matrix.mul_apply]
    refine le_trans (norm_sum_le _ _) ?_
    exact Finset.sum_le_sum (fun k _ => by rw [norm_mul])
  calc ∑ i, ∑ j, ‖(A * B) i j‖
      ≤ ∑ i, ∑ j, ∑ k, ‖A i k‖ * ‖B k j‖ :=
        Finset.sum_le_sum (fun i _ => Finset.sum_le_sum (fun j _ => hentry i j))
    _ ≤ (∑ i, ∑ j, ‖A i j‖) * (∑ i, ∑ j, ‖B i j‖) := by
        simp only [Fin.sum_univ_two]
        nlinarith [mul_nonneg (norm_nonneg (A 0 0)) (norm_nonneg (B 1 0)),
          mul_nonneg (norm_nonneg (A 0 0)) (norm_nonneg (B 1 1)),
          mul_nonneg (norm_nonneg (A 0 1)) (norm_nonneg (B 0 0)),
          mul_nonneg (norm_nonneg (A 0 1)) (norm_nonneg (B 0 1)),
          mul_nonneg (norm_nonneg (A 1 0)) (norm_nonneg (B 1 0)),
          mul_nonneg (norm_nonneg (A 1 0)) (norm_nonneg (B 1 1)),
          mul_nonneg (norm_nonneg (A 1 1)) (norm_nonneg (B 0 0)),
          mul_nonneg (norm_nonneg (A 1 1)) (norm_nonneg (B 0 1))]

/-- Submultiplicative power bound (for a positive exponent): the norm of a power
is at most the power of the norm. The `1 ≤ n` hypothesis is needed because
`matrixL1Norm 1 = 2 ≠ 1`, so the `n = 0` case is genuinely different. -/
theorem matrixL1Norm_pow_le (A : Matrix Direction Direction Complex) {n : ℕ}
    (hn : 1 ≤ n) : matrixL1Norm (A ^ n) ≤ (matrixL1Norm A) ^ n := by
  induction n, hn using Nat.le_induction with
  | base => simp
  | succ n hn ih =>
      calc matrixL1Norm (A ^ (n + 1))
          = matrixL1Norm (A ^ n * A) := by rw [pow_succ]
        _ ≤ matrixL1Norm (A ^ n) * matrixL1Norm A := matrixL1Norm_mul_le _ _
        _ ≤ (matrixL1Norm A) ^ n * matrixL1Norm A :=
            mul_le_mul_of_nonneg_right ih (matrixL1Norm_nonneg _)
        _ = (matrixL1Norm A) ^ (n + 1) := by rw [pow_succ]

/-- Telescoping identity for a difference of powers in a (noncommutative) matrix
ring: `A ^ (n+1) - B ^ (n+1) = A * (A ^ n - B ^ n) + (A - B) * B ^ n`. -/
theorem pow_succ_sub (A B : Matrix Direction Direction Complex) (n : ℕ) :
    A ^ (n + 1) - B ^ (n + 1) = A * (A ^ n - B ^ n) + (A - B) * B ^ n := by
  rw [pow_succ' A n, pow_succ' B n]; noncomm_ring

/-- Matrix-power stability estimate. If two matrices `A`, `B` have local
`matrixL1Norm` at most `M` and differ by at most `δ` in `matrixL1Norm`, then
their `n`-th powers differ by at most `n * M ^ (n - 1) * δ`.

This is the Trotter-bridge lemma: it converts a per-step bound (`hAB`) plus
per-step stability (`hA`, `hB`) into an accumulated bound over `n` steps. Applied
with `A = momentumStepSymbolRaw eps m p`, `B = momentumStepFirstOrderModel eps m p`
(or the continuum exponential factor), and `δ` the per-step second-order
discrepancy, it is the first-order-in-`eps` accumulation input to a continuum
limit. -/
theorem matrixL1Norm_pow_sub_pow_le (A B : Matrix Direction Direction Complex)
    (M δ : ℝ) (n : ℕ) (hA : matrixL1Norm A ≤ M) (hB : matrixL1Norm B ≤ M)
    (hAB : matrixL1Norm (A - B) ≤ δ) :
    matrixL1Norm (A ^ n - B ^ n) ≤ (n : ℝ) * M ^ (n - 1) * δ := by
  have hM0 : 0 ≤ M := le_trans (matrixL1Norm_nonneg A) hA
  have hδ0 : 0 ≤ δ := le_trans (matrixL1Norm_nonneg _) hAB
  rcases Nat.eq_zero_or_pos n with hn | hn
  · subst hn; simp [matrixL1Norm_zero]
  · induction n, hn using Nat.le_induction with
    | base => simpa using hAB
    | succ n hn ih =>
        have hBn : matrixL1Norm (B ^ n) ≤ M ^ n :=
          le_trans (matrixL1Norm_pow_le B hn)
            (pow_le_pow_left₀ (matrixL1Norm_nonneg _) hB n)
        have hpowM : M ^ n = M ^ (n - 1) * M := by
          rw [← pow_succ]; congr 1; omega
        have hstep : matrixL1Norm (A ^ (n + 1) - B ^ (n + 1)) ≤
            M * ((n : ℝ) * M ^ (n - 1) * δ) + δ * M ^ n := by
          rw [pow_succ_sub]
          refine le_trans (matrixL1Norm_add_le _ _) ?_
          apply add_le_add
          · refine le_trans (matrixL1Norm_mul_le _ _) ?_
            exact mul_le_mul hA ih (matrixL1Norm_nonneg _) hM0
          · refine le_trans (matrixL1Norm_mul_le _ _) ?_
            exact mul_le_mul hAB hBn (matrixL1Norm_nonneg _) hδ0
        have hgoal : M * ((n : ℝ) * M ^ (n - 1) * δ) + δ * M ^ n
            = ((n : ℝ) + 1) * M ^ n * δ := by rw [hpowM]; ring_nf
        have hn1 : (n + 1 : ℕ) - 1 = n := by omega
        rw [hn1]
        push_cast
        calc matrixL1Norm (A ^ (n + 1) - B ^ (n + 1))
            ≤ M * ((n : ℝ) * M ^ (n - 1) * δ) + δ * M ^ n := hstep
          _ = ((n : ℝ) + 1) * M ^ n * δ := hgoal

/-! ## Entrywise exponential bridge

The next block proves that the first-order model and the one-step continuum
exponential differ by `O(eps ^ 2)` pointwise in momentum.

The argument uses only the entrywise triangle inequality across a convergent
series and submultiplicativity of `matrixL1Norm`; it does not rely on
`matrixL1Norm 1 = 2`, so it is immune to the identity-size blowup that would
affect a naive long-product estimate. -/

/-- The entrywise L1 norm is invariant under negation. -/
theorem matrixL1Norm_neg (M : Matrix Direction Direction Complex) :
    matrixL1Norm (-M) = matrixL1Norm M := by
  unfold matrixL1Norm
  simp

/-- Complex-scalar homogeneity of the entrywise L1 norm. -/
theorem matrixL1Norm_smul_complex (c : Complex)
    (M : Matrix Direction Direction Complex) :
    matrixL1Norm (c • M) = ‖c‖ * matrixL1Norm M := by
  unfold matrixL1Norm
  simp only [Matrix.smul_apply, smul_eq_mul, norm_mul, Finset.mul_sum]

/-- Entrywise L1 norm of the Dirac Hamiltonian symbol `p sigma_z - m sigma_x`. -/
theorem matrixL1Norm_diracHamiltonianSymbol (m p : Real) :
    matrixL1Norm (diracHamiltonianSymbol m p) = 2 * |p| + 2 * |m| := by
  unfold matrixL1Norm diracHamiltonianSymbol directionGrade reversal
  simp [Fin.sum_univ_two, Matrix.sub_apply]
  ring

/-- Triangle inequality of the entrywise L1 norm across a convergent series:
the norm of a tsum is at most the tsum of the norms. -/
theorem matrixL1Norm_tsum_le
    {f : ℕ → Matrix Direction Direction Complex} (hf : Summable f)
    (hn : Summable (fun n => matrixL1Norm (f n))) :
    matrixL1Norm (∑' n, f n) ≤ ∑' n, matrixL1Norm (f n) := by
  have hentry : ∀ i j, Summable (fun n => ‖(f n) i j‖) := by
    intro i j
    refine Summable.of_nonneg_of_le (fun n => norm_nonneg _) (fun n => ?_) hn
    unfold matrixL1Norm
    calc ‖f n i j‖ ≤ ∑ j', ‖f n i j'‖ :=
          Finset.single_le_sum (fun _ _ => norm_nonneg _) (Finset.mem_univ j)
      _ ≤ ∑ i', ∑ j', ‖f n i' j'‖ :=
          Finset.single_le_sum (f := fun i' => ∑ j', ‖f n i' j'‖)
            (fun _ _ => Finset.sum_nonneg (fun _ _ => norm_nonneg _)) (Finset.mem_univ i)
  unfold matrixL1Norm
  have hstep : ∀ i j, ‖(∑' n, f n) i j‖ ≤ ∑' n, ‖(f n) i j‖ := by
    intro i j
    have h1 : Summable (fun n => f n i) := (Pi.summable.mp hf) i
    rw [tsum_apply hf, tsum_apply h1]
    exact norm_tsum_le_tsum_norm (hentry i j)
  calc ∑ i, ∑ j, ‖(∑' n, f n) i j‖
      ≤ ∑ i, ∑ j, ∑' n, ‖(f n) i j‖ :=
        Finset.sum_le_sum (fun i _ => Finset.sum_le_sum (fun j _ => hstep i j))
    _ = ∑' n, ∑ i, ∑ j, ‖(f n) i j‖ := by
        rw [Finset.sum_congr rfl
          (fun i _ => (Summable.tsum_finsetSum (fun j _ => hentry i j)).symm)]
        exact (Summable.tsum_finsetSum
          (fun i _ => summable_sum (fun j _ => hentry i j))).symm

open scoped Matrix.Norms.Operator in
/-- The matrix exponential series is summable in the ambient matrix topology.
Proved through the local `linftyOp` normed-ring instance, whose topology agrees
with the ambient product topology used by `NormedSpace.exp`. -/
theorem matrixExpSeries_summable (X : Matrix Direction Direction Complex) :
    Summable (fun n : ℕ => ((n.factorial : Complex)⁻¹) • X ^ n) := by
  simpa using NormedSpace.expSeries_summable' (𝕂 := Complex) (x := X)

open scoped Matrix.Norms.Operator in
/-- The matrix exponential as the sum of its power series. -/
theorem matrixExp_eq_tsum (X : Matrix Direction Direction Complex) :
    NormedSpace.exp X = ∑' n : ℕ, ((n.factorial : Complex)⁻¹) • X ^ n := by
  rw [NormedSpace.exp_eq_tsum (𝕂 := Complex)]

set_option maxHeartbeats 1000000 in
/-- Split off the constant and linear terms of the matrix exponential series. -/
theorem matrixExp_sub_one_sub_self_eq_tsum
    (X : Matrix Direction Direction Complex) :
    NormedSpace.exp X - 1 - X
      = ∑' n : ℕ, ((((n + 2).factorial : Complex)⁻¹) • X ^ (n + 2)) := by
  have hF := matrixExpSeries_summable X
  have hF1 :
      Summable (fun n => ((((n + 1).factorial : Complex)⁻¹) • X ^ (n + 1))) :=
    (summable_nat_add_iff 1).mpr hF
  rw [matrixExp_eq_tsum X, Summable.tsum_eq_zero_add hF,
    Summable.tsum_eq_zero_add hF1]
  simp

set_option maxHeartbeats 400000 in
/-- Entrywise-L1 bound of the exponential tail by the scalar exponential tail. -/
theorem matrixL1Norm_tsum_expTail_le (X : Matrix Direction Direction Complex)
    (hF2 : Summable (fun n => ((((n + 2).factorial : Complex)⁻¹) • X ^ (n + 2)))) :
    matrixL1Norm (∑' n : ℕ, ((((n + 2).factorial : Complex)⁻¹) • X ^ (n + 2)))
      ≤ ∑' n : ℕ, ((n + 2).factorial : Real)⁻¹ * (matrixL1Norm X) ^ (n + 2) := by
  have hbound :
      ∀ n : ℕ, matrixL1Norm ((((n + 2).factorial : Complex)⁻¹) • X ^ (n + 2))
        ≤ ((n + 2).factorial : Real)⁻¹ * (matrixL1Norm X) ^ (n + 2) := by
    intro n
    rw [matrixL1Norm_smul_complex]
    have hpow := matrixL1Norm_pow_le X (show (1 : ℕ) ≤ n + 2 by omega)
    have hc : ‖(((n + 2).factorial : Complex)⁻¹)‖ =
        ((n + 2).factorial : Real)⁻¹ := by
      simp [norm_inv]
    rw [hc]
    exact mul_le_mul_of_nonneg_left hpow (by positivity)
  have hbsum :
      Summable (fun n : ℕ =>
        ((n + 2).factorial : Real)⁻¹ * (matrixL1Norm X) ^ (n + 2)) := by
    have hs : Summable (fun n : ℕ => (matrixL1Norm X) ^ n / n.factorial) :=
      Real.summable_pow_div_factorial _
    refine ((summable_nat_add_iff 2).mpr hs).congr (fun n => ?_)
    rw [div_eq_inv_mul]
  have hmL1sum :
      Summable (fun n : ℕ =>
        matrixL1Norm ((((n + 2).factorial : Complex)⁻¹) • X ^ (n + 2))) :=
    Summable.of_nonneg_of_le (fun n => matrixL1Norm_nonneg _) hbound hbsum
  refine le_trans (matrixL1Norm_tsum_le (f := fun n : ℕ =>
    (((n + 2).factorial : Complex)⁻¹) • X ^ (n + 2)) hF2 hmL1sum) ?_
  exact Summable.tsum_mono hmL1sum hbsum hbound

/-- Closed form of the scalar exponential tail `sum a^(n+2)/(n+2)!`. -/
theorem real_exp_sub_one_sub_self_eq_tsum (a : Real) :
    ∑' n : ℕ, ((n + 2).factorial : Real)⁻¹ * a ^ (n + 2) = Real.exp a - 1 - a := by
  have hexpr : Real.exp a = ∑' n : ℕ, a ^ n / n.factorial := by
    rw [Real.exp_eq_exp_ℝ, NormedSpace.exp_eq_tsum_div]
  have hs : Summable (fun n : ℕ => a ^ n / n.factorial) :=
    Real.summable_pow_div_factorial _
  have h1 : Summable (fun n : ℕ => a ^ (n + 1) / (n + 1).factorial) :=
    (summable_nat_add_iff 1).mpr hs
  rw [hexpr, Summable.tsum_eq_zero_add hs, Summable.tsum_eq_zero_add h1]
  have hcong : ∀ n : ℕ, ((n + 2).factorial : Real)⁻¹ * a ^ (n + 2)
      = a ^ (n + 2) / (n + 2).factorial := by
    intro n
    rw [div_eq_inv_mul]
  simp only [hcong]
  simp [Nat.factorial]

/-- Abstract exponential remainder bound in the entrywise L1 norm:
`matrixL1Norm (exp X - 1 - X) <= Real.exp a - 1 - a` with
`a = matrixL1Norm X`. -/
theorem matrixL1Norm_exp_sub_one_sub_self_le
    (X : Matrix Direction Direction Complex) :
    matrixL1Norm (NormedSpace.exp X - 1 - X)
      ≤ Real.exp (matrixL1Norm X) - 1 - matrixL1Norm X := by
  rw [matrixExp_sub_one_sub_self_eq_tsum X]
  refine le_trans (matrixL1Norm_tsum_expTail_le X ?_)
    (le_of_eq (real_exp_sub_one_sub_self_eq_tsum (matrixL1Norm X)))
  exact (summable_nat_add_iff 2).mpr (matrixExpSeries_summable X)

/-- Scalar second-order tail bound:
`Real.exp a - 1 - a <= a ^ 2` for `0 <= a <= 1`. -/
theorem real_exp_sub_one_sub_self_le_sq (a : Real) (ha : 0 ≤ a) (ha1 : a ≤ 1) :
    Real.exp a - 1 - a ≤ a ^ 2 := by
  have h := Real.exp_bound (x := a) (by rw [abs_of_nonneg ha]; exact ha1)
    (n := 2) (by norm_num)
  simp [Finset.sum_range_succ] at h
  rw [abs_le] at h
  nlinarith [h.2, sq_nonneg a]

/-- Explicit finite bound for the one-step exponential bridge discrepancy:
it is at most `Real.exp a - 1 - a` with `a = |eps| * (2|p| + 2|m|)`. -/
theorem continuumStepBridgeDiscrepancy_le (eps m p : Real) :
    continuumStepBridgeDiscrepancy eps m p ≤
      Real.exp (|eps| * (2 * |p| + 2 * |m|)) - 1
        - |eps| * (2 * |p| + 2 * |m|) := by
  have hrem : continuumStepBridgeRemainder eps m p
      = -(NormedSpace.exp ((-Complex.I * (eps : Complex)) • diracHamiltonianSymbol m p)
          - 1 - ((-Complex.I * (eps : Complex)) • diracHamiltonianSymbol m p)) := by
    unfold continuumStepBridgeRemainder momentumStepFirstOrderModel continuumStepSymbol
    abel
  unfold continuumStepBridgeDiscrepancy
  rw [hrem, matrixL1Norm_neg]
  set X := (-Complex.I * (eps : Complex)) • diracHamiltonianSymbol m p with hXdef
  have hX : matrixL1Norm X = |eps| * (2 * |p| + 2 * |m|) := by
    rw [hXdef, matrixL1Norm_smul_complex, matrixL1Norm_diracHamiltonianSymbol]
    congr 1
    rw [norm_mul, norm_neg, Complex.norm_I, one_mul, Complex.norm_real,
      Real.norm_eq_abs]
  calc matrixL1Norm (NormedSpace.exp X - 1 - X)
      ≤ Real.exp (matrixL1Norm X) - 1 - matrixL1Norm X :=
        matrixL1Norm_exp_sub_one_sub_self_le X
    _ = _ := by rw [hX]

/-- The one-step exponential bridge: the first-order model
`1 - i eps H(p)` and the one-step exponential `exp(-i eps H(p))` differ by
second order in the local `matrixL1Norm`. -/
theorem continuumStepBridgeDiscrepancy_isBigO_sq (m p : Real) :
    (fun eps : Real => continuumStepBridgeDiscrepancy eps m p)
      =O[nhds (0 : Real)] (fun eps : Real => eps ^ 2) := by
  rw [Asymptotics.isBigO_iff]
  refine ⟨(2 * |p| + 2 * |m|) ^ 2, ?_⟩
  set K := 2 * |p| + 2 * |m| with hK
  have hK0 : 0 ≤ K := by positivity
  have hpos : (0 : Real) < 1 / (K + 1) := by positivity
  filter_upwards [Icc_mem_nhds (show -(1 / (K + 1)) < 0 by linarith)
      (show (0 : Real) < 1 / (K + 1) from hpos)] with eps heps
  have habs : |eps| ≤ 1 / (K + 1) := by
    rw [abs_le]
    exact heps
  have haK : |eps| * K ≤ 1 := by
    calc |eps| * K ≤ (1 / (K + 1)) * K :=
          mul_le_mul_of_nonneg_right habs hK0
      _ = K / (K + 1) := by ring
      _ ≤ 1 := by rw [div_le_one (by linarith)]; linarith
  have hb := continuumStepBridgeDiscrepancy_le eps m p
  have hsq := real_exp_sub_one_sub_self_le_sq (|eps| * K) (by positivity) haK
  rw [Real.norm_eq_abs, Real.norm_eq_abs,
    abs_of_nonneg (continuumStepBridgeDiscrepancy_nonneg eps m p),
    abs_of_nonneg (sq_nonneg eps)]
  calc continuumStepBridgeDiscrepancy eps m p
      ≤ Real.exp (|eps| * K) - 1 - |eps| * K := hb
    _ ≤ (|eps| * K) ^ 2 := hsq
    _ = K ^ 2 * eps ^ 2 := by rw [mul_pow, sq_abs]; ring

/-- Fallback explicit-constant form of the one-step exponential bridge:
there is a nonnegative constant `C` depending on `m` and `p` such that the
bridge discrepancy is eventually bounded by `C * eps ^ 2` near `eps = 0`. -/
theorem continuumStepBridgeDiscrepancy_tendsto_zero_div_sq_bound
    (m p : Real) :
    ∃ C : Real, 0 ≤ C ∧
      ∀ᶠ eps in nhds (0 : Real),
        continuumStepBridgeDiscrepancy eps m p ≤ C * eps ^ 2 := by
  refine ⟨(2 * |p| + 2 * |m|) ^ 2, by positivity, ?_⟩
  set K := 2 * |p| + 2 * |m| with hK
  have hK0 : 0 ≤ K := by positivity
  have hpos : (0 : Real) < 1 / (K + 1) := by positivity
  filter_upwards [Icc_mem_nhds (show -(1 / (K + 1)) < 0 by linarith)
      (show (0 : Real) < 1 / (K + 1) from hpos)] with eps heps
  have habs : |eps| ≤ 1 / (K + 1) := by
    rw [abs_le]
    exact heps
  have haK : |eps| * K ≤ 1 := by
    calc |eps| * K ≤ (1 / (K + 1)) * K :=
          mul_le_mul_of_nonneg_right habs hK0
      _ = K / (K + 1) := by ring
      _ ≤ 1 := by rw [div_le_one (by linarith)]; linarith
  have hb := continuumStepBridgeDiscrepancy_le eps m p
  have hsq := real_exp_sub_one_sub_self_le_sq (|eps| * K) (by positivity) haK
  calc continuumStepBridgeDiscrepancy eps m p
      ≤ Real.exp (|eps| * K) - 1 - |eps| * K := hb
    _ ≤ (|eps| * K) ^ 2 := hsq
    _ = K ^ 2 * eps ^ 2 := by rw [mul_pow, sq_abs]; ring

/-! ## Refinement family and intended limit boundary -/

/-- A refinement family at fixed mass and fixed momentum observation window,
with lattice spacing tending to zero and total time tending to `T`. -/
structure CheckerboardDiracRefinement where
  /-- Scaling data at each refinement level. -/
  data : Nat → CheckerboardDiracScalingData
  /-- Target total time. -/
  T : Real
  /-- Fixed continuum mass across the family. -/
  mass_const : ∀ k, (data k).m = (data 0).m
  /-- Fixed observation window across the family. -/
  window_const : ∀ k, (data k).pMax = (data 0).pMax
  /-- Lattice spacing tends to zero. -/
  eps_tendsto_zero :
    Filter.Tendsto (fun k => (data k).eps) Filter.atTop (nhds 0)
  /-- Total time tends to the target `T`. -/
  totalTime_tendsto :
    Filter.Tendsto (fun k => (data k).totalTime) Filter.atTop (nhds T)

namespace CheckerboardDiracRefinement

variable (R : CheckerboardDiracRefinement)

/-- Along a refinement family, the derived time step tends to zero. -/
theorem timeStep_tendsto_zero :
    Filter.Tendsto (fun k => (R.data k).timeStep) Filter.atTop (nhds 0) := by
  simpa [CheckerboardDiracScalingData.timeStep] using R.eps_tendsto_zero

/-- Along a refinement family with fixed mass, the mass angle tends to zero. -/
theorem massAngle_tendsto_zero :
    Filter.Tendsto (fun k => (R.data k).massAngle) Filter.atTop (nhds 0) := by
  simpa [CheckerboardDiracScalingData.massAngle, R.mass_const] using
    R.eps_tendsto_zero.mul_const ((R.data 0).m)

/-- Along a refinement family, the accumulated mass angle tends to target time
times the fixed mass. -/
theorem accumulatedAngle_tendsto :
    Filter.Tendsto (fun k => (R.data k).accumulatedAngle)
      Filter.atTop (nhds (R.T * (R.data 0).m)) := by
  have h := R.totalTime_tendsto.mul_const ((R.data 0).m)
  simpa [CheckerboardDiracScalingData.accumulatedAngle_eq_totalTime_mul_mass,
    R.mass_const] using h

end CheckerboardDiracRefinement

/-! ## Pointwise-in-momentum continuum limit along a refinement family

This is the accumulated fixed-time Trotter assembly. Its hypotheses are the
explicit refinement-family assumptions (`eps -> 0`, `totalTime -> T`, fixed
mass), so it is a genuine continuum-limit statement rather than a scaffold. It
stays pointwise in momentum `p` and in the scoped `L_infinity` operator norm. -/

section RefinementLimit

open scoped Matrix.Norms.Operator

/-- The continuum Dirac evolution symbol is continuous in the time parameter.

This is the analytic bridge needed to replace the matching discrete total time
`(R.data k).totalTime` by the fixed target time `R.T` in refinement limits. -/
theorem diracEvolutionSymbol_continuous_time (m p : Real) :
    Continuous (fun t : Real => diracEvolutionSymbol m p t) := by
  unfold diracEvolutionSymbol
  have hcoef : Continuous (fun t : Real => (-Complex.I * (t : Complex))) := by
    exact continuous_const.mul Complex.continuous_ofReal
  have hinner : Continuous (fun t : Real => (-Complex.I * (t : Complex)) •
      diracHamiltonianSymbol m p) := by
    exact hcoef.smul continuous_const
  simpa [Function.comp_def] using
    (NormedSpace.exp_continuous
      (𝔸 := Matrix Direction Direction Complex)).comp hinner

/-- Along a refinement family, the continuum comparison at the matching
discrete total time converges to the continuum comparison at the fixed target
time `R.T`. -/
theorem diracEvolutionSymbol_tendsto_refinement_time
    (R : CheckerboardDiracRefinement) (p : Real) :
    Filter.Tendsto
      (fun k => diracEvolutionSymbol (R.data k).m p (R.data k).totalTime)
      Filter.atTop (nhds (diracEvolutionSymbol (R.data 0).m p R.T)) := by
  have ht := (diracEvolutionSymbol_continuous_time (R.data 0).m p).tendsto R.T
  simpa [R.mass_const] using ht.comp R.totalTime_tendsto

/-
Eventual per-step second-order discrepancy bound along a refinement family:
there is a nonnegative constant `C` with `‖raw - cont‖ ≤ C * eps ^ 2` for all
large `k`. This transports the pointwise-in-`eps` `O(eps^2)` bound
`linftyOpNorm_momentumStep_sub_continuumStep_isBigO_sq` along `eps_k -> 0`.
-/
theorem exists_eventually_stepDiscrepancy_le
    (R : CheckerboardDiracRefinement) (p : Real) :
    ∃ C : Real, 0 ≤ C ∧ ∀ᶠ k in Filter.atTop,
      ‖momentumStepSymbolRaw (R.data k).eps (R.data k).m p
        - continuumStepSymbol (R.data k).eps (R.data k).m p‖
        ≤ C * (R.data k).eps ^ 2 := by
  obtain ⟨C, hC⟩ : ∃ C : ℝ, ∀ᶠ k in Filter.atTop, ‖momentumStepSymbolRaw (R.data k).eps (R.data 0).m p - continuumStepSymbol (R.data k).eps (R.data 0).m p‖ ≤ C * (R.data k).eps ^ 2 := by
    have := linftyOpNorm_momentumStep_sub_continuumStep_isBigO_sq ( R.data 0 |> CheckerboardDiracScalingData.m ) p;
    rw [ Asymptotics.isBigO_iff ] at this;
    obtain ⟨ C, hC ⟩ := this; use C; filter_upwards [ hC.filter_mono ( R.eps_tendsto_zero ) ] with k hk; simpa [ abs_mul, abs_pow ] using hk;
  refine' ⟨ Max.max C 0, le_max_right _ _, hC.mono fun k hk => _ ⟩ ; simp_all +decide [ R.mass_const ];
  exact le_trans hk ( mul_le_mul_of_nonneg_right ( le_max_left _ _ ) ( sq_nonneg _ ) )

/-
Pointwise-in-momentum continuum limit: along any refinement family the
finite `N`-step checkerboard momentum evolution converges in the scoped `L∞`
operator norm to the continuum Dirac evolution at the matching total time.
-/
theorem linftyOpNorm_momentumEvolution_sub_diracEvolution_tendsto_zero
    (R : CheckerboardDiracRefinement) (p : Real) :
    Filter.Tendsto
      (fun k => ‖momentumEvolution (R.data k) p
        - diracEvolutionSymbol (R.data k).m p (R.data k).totalTime‖)
      Filter.atTop (nhds 0) := by
  obtain ⟨C, hC_nonneg, hC_bound⟩ := exists_eventually_stepDiscrepancy_le R p;
  refine' squeeze_zero_norm' _ _;
  use fun k => Real.exp ( ( |p| + |( R.data 0 ).m| ) * |( R.data k ).totalTime| ) * ( C * ( ( R.data k ).totalTime * ( R.data k ).eps ) );
  · filter_upwards [ hC_bound, Filter.eventually_gt_atTop 0 ] with k hk₁ hk₂;
    convert le_trans ( linftyOpNorm_momentumEvolution_sub_diracEvolution_exp_bound ( R.data k ) p _ hk₁ ) _ using 1;
    · norm_num;
    · rw [ ← Real.exp_nat_mul ] ; norm_num [ CheckerboardDiracScalingData.totalTime ] ; ring_nf;
      rw [ linftyOpNorm_diracHamiltonianSymbol_eq ] ; norm_num [ R.mass_const k ] ; ring_nf;
      rcases n : ( R.data k |> CheckerboardDiracScalingData.N ) with ( _ | n ) <;> simp_all +decide [ Nat.cast_succ, mul_assoc, mul_comm, mul_left_comm ];
      exact mul_le_mul_of_nonneg_left ( mul_le_mul_of_nonneg_left ( mul_le_mul_of_nonneg_left ( Real.exp_le_exp.mpr <| by nlinarith [ abs_nonneg p, abs_nonneg ( R.data k |> CheckerboardDiracScalingData.eps ), abs_nonneg ( R.data 0 |> CheckerboardDiracScalingData.m ) ] ) <| by positivity ) <| by positivity ) <| by positivity;
  · simpa using Filter.Tendsto.mul ( Real.continuous_exp.continuousAt.tendsto.comp ( tendsto_const_nhds.mul ( R.totalTime_tendsto.abs ) ) ) ( tendsto_const_nhds.mul ( R.totalTime_tendsto.mul R.eps_tendsto_zero ) )

/-- Pointwise-in-momentum continuum limit in the original entrywise
`matrixL1Norm`.  This promotes the boundary statement recorded below from a
comment to a theorem, using only the finite two-row bridge from `matrixL1Norm`
to the scoped stable `L_infinity` operator norm. -/
theorem checkerboard_dirac_limit_statement
    (R : CheckerboardDiracRefinement) (p : Real) :
    Filter.Tendsto
      (fun k => momentumEvolutionDiscrepancy (R.data k) p)
      Filter.atTop (nhds 0) := by
  refine squeeze_zero (fun k => momentumEvolutionDiscrepancy_nonneg (R.data k) p)
    (g := fun k => 2 * ‖momentumEvolution (R.data k) p
        - diracEvolutionSymbol (R.data k).m p (R.data k).totalTime‖)
    (fun k => ?_) ?_
  · simpa [momentumEvolutionDiscrepancy] using
      matrixL1Norm_le_two_mul_linftyOpNorm
      (momentumEvolution (R.data k) p -
        diracEvolutionSymbol (R.data k).m p (R.data k).totalTime)
  · simpa [mul_zero] using
      (tendsto_const_nhds.mul
        (linftyOpNorm_momentumEvolution_sub_diracEvolution_tendsto_zero R p))

/-- Pointwise-in-momentum checkerboard-to-Dirac limit at the fixed target time.

This upgrades `checkerboard_dirac_limit_statement`, which compares against the
continuum symbol at the matching discrete total time, by using continuity of the
continuum Dirac evolution in the time parameter and the refinement hypothesis
`(R.data k).totalTime -> R.T`. -/
theorem checkerboard_dirac_limit_statement_fixed_time
    (R : CheckerboardDiracRefinement) (p : Real) :
    Filter.Tendsto
      (fun k => matrixL1Norm (momentumEvolution (R.data k) p -
        diracEvolutionSymbol (R.data 0).m p R.T))
      Filter.atTop (nhds 0) := by
  let C := diracEvolutionSymbol (R.data 0).m p R.T
  have hmatch : Filter.Tendsto
      (fun k => diracEvolutionSymbol (R.data k).m p (R.data k).totalTime)
      Filter.atTop (nhds C) := by
    simpa [C] using diracEvolutionSymbol_tendsto_refinement_time R p
  have htail : Filter.Tendsto
      (fun k => matrixL1Norm (diracEvolutionSymbol (R.data k).m p
        (R.data k).totalTime - C))
      Filter.atTop (nhds 0) := by
    refine matrixL1Norm_tendsto_zero ?_
    simpa [C] using hmatch.sub (tendsto_const_nhds (x := C))
  refine squeeze_zero
    (fun k => matrixL1Norm_nonneg (momentumEvolution (R.data k) p - C))
    (g := fun k => momentumEvolutionDiscrepancy (R.data k) p +
      matrixL1Norm (diracEvolutionSymbol (R.data k).m p
        (R.data k).totalTime - C))
    (fun k => ?_) ?_
  · have hsplit : momentumEvolution (R.data k) p - C =
        (momentumEvolution (R.data k) p -
          diracEvolutionSymbol (R.data k).m p (R.data k).totalTime) +
        (diracEvolutionSymbol (R.data k).m p (R.data k).totalTime - C) := by
      abel
    calc
      matrixL1Norm (momentumEvolution (R.data k) p - C)
          = matrixL1Norm ((momentumEvolution (R.data k) p -
              diracEvolutionSymbol (R.data k).m p (R.data k).totalTime) +
            (diracEvolutionSymbol (R.data k).m p
              (R.data k).totalTime - C)) := by
              rw [hsplit]
      _ ≤ matrixL1Norm (momentumEvolution (R.data k) p -
              diracEvolutionSymbol (R.data k).m p (R.data k).totalTime) +
            matrixL1Norm (diracEvolutionSymbol (R.data k).m p
              (R.data k).totalTime - C) :=
          matrixL1Norm_add_le _ _
      _ = momentumEvolutionDiscrepancy (R.data k) p +
            matrixL1Norm (diracEvolutionSymbol (R.data k).m p
              (R.data k).totalTime - C) := by
          rfl
  · simpa using (checkerboard_dirac_limit_statement R p).add htail

end RefinementLimit

/-!
## Proven theorem boundary

The pointwise-in-momentum finite-dimensional checkerboard-to-Dirac limit is now
proved in `matrixL1Norm` above. The theorem
`checkerboard_dirac_limit_statement` compares the finite `N`-step
momentum-space checkerboard symbol with the continuum Dirac evolution at
matching discrete total time `(R.data k).totalTime`. The theorem
`checkerboard_dirac_limit_statement_fixed_time` upgrades this to the fixed
target time `R.T`, under the explicit refinement-family assumptions
`eps -> 0`, fixed mass, and matched total time.

Remaining refinements for the next checkerboard layer:

1. Add a uniform-on-window version for `MomentumWindow`, rather than the current
   pointwise-in-momentum theorem.
2. Connect this momentum-space limit to the intended position-space sampling and
   interpolation API.
-/

end PhysicsSM.Draft.CheckerboardDiracScaling
