import PhysicsSM.Draft.NullEdge.LaurentFlowIndex
import PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo

/-!
# Fourier evaluation of the Laurent determinant flow

This module fixes the positive Fourier convention `T n -> exp(i n q)` and
proves that the algebraic determinant exponent of a strict finite-range
one-particle walk is exactly the exponent seen in its Fourier determinant.
Pointwise unitarity additionally forces the constant determinant factor to
have norm one.

Scope: one Laurent variable, finite Laurent inverse, and pointwise unitary
complex Fourier symbols. This is a one-particle determinant phase law. It is
not the positive-rational many-body GNVW cellular-automaton index, a
three-dimensional invariant, or a no-doubling theorem.

Provenance: Aristotle project `3fdb1077-8420-427b-9cbf-9dbee2ed55b3`,
independently reviewed and compiled against the pinned repository toolchain on
2026-07-11. The convention/scope comparison uses Gross--Nesme--Vogts--Werner,
arXiv:0910.3675, Proposition 5; no external source code was copied.

Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.LaurentFourierWalkBridge

open LaurentFlowIndex
open Matrix

/-- Positive Fourier convention: the Laurent generator evaluates to
`exp(i q)`. -/
def phaseUnit (q : Real) : Units Complex :=
  Units.mk0
    (Complex.exp (Complex.I * (q : Complex)))
    (Complex.exp_ne_zero _)

/-- Evaluation of finite Laurent symbols at positive Fourier angle `q`. -/
def fourierEval (q : Real) : LaurentPolynomial Complex →+* Complex :=
  LaurentPolynomial.eval₂ (RingHom.id Complex) (phaseUnit q)

/-- Entrywise Fourier evaluation of a finite Laurent matrix. -/
def fourierSymbol {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial Complex))
    (q : Real) : Matrix (Fin r) (Fin r) Complex :=
  (fourierEval q).mapMatrix M

/-- A strict translation-invariant one-particle walk: its finite Laurent
matrix has a Laurent inverse and every circle evaluation is unitary. -/
def IsStrictTIUnitaryWalk {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial Complex)) : Prop :=
  IsUnit M /\
    forall q : Real,
      fourierSymbol M q ∈ Matrix.unitaryGroup (Fin r) Complex

/-- The algebraic determinant exponent becomes the exact Fourier phase
exponent, with a unit-modulus constant. -/
theorem strictTIUnitaryWalk_det_phase {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial Complex))
    (hW : IsStrictTIUnitaryWalk M) :
    exists c : Complex, norm c = 1 /\
      forall q : Real,
        (fourierSymbol M q).det =
          c * Complex.exp
            ((flowExponent M hW.1 : Complex) *
              (Complex.I * (q : Complex))) := by
  obtain ⟨c, hc, hdet⟩ := flowExponent_spec M hW.1
  have hforall : forall q : Real,
      (fourierSymbol M q).det =
        c * Complex.exp
          ((flowExponent M hW.1 : Complex) * (Complex.I * (q : Complex))) := by
    intro q
    have hkey : (fourierSymbol M q).det = fourierEval q M.det :=
      (RingHom.map_det (fourierEval q) M).symm
    rw [hkey, hdet, map_mul, fourierEval, LaurentPolynomial.eval₂_C,
      LaurentPolynomial.eval₂_T, Units.val_zpow_eq_zpow_val]
    show (RingHom.id Complex) c *
        (Complex.exp (Complex.I * (q : Complex))) ^ (flowExponent M hW.1) = _
    rw [RingHom.id_apply, ← Complex.exp_int_mul]
  refine ⟨c, ?_, hforall⟩
  have hu : fourierSymbol M 0 ∈ Matrix.unitaryGroup (Fin r) Complex := hW.2 0
  have hdet0 : (fourierSymbol M 0).det = c := by
    rw [hforall 0]
    simp
  have hnorm : norm (fourierSymbol M 0).det = 1 := by
    rw [Matrix.mem_unitaryGroup_iff'] at hu
    have h : star ((fourierSymbol M 0).det) * (fourierSymbol M 0).det = 1 := by
      rw [← Matrix.det_conjTranspose, ← Matrix.det_mul,
        show (fourierSymbol M 0)ᴴ = star (fourierSymbol M 0) from rfl, hu,
        Matrix.det_one]
    have hn : norm (fourierSymbol M 0).det * norm (fourierSymbol M 0).det = 1 := by
      have hnormed := congrArg norm h
      simpa [norm_mul, norm_star] using hnormed
    nlinarith [norm_nonneg (fourierSymbol M 0).det]
  rwa [hdet0] at hnorm

/-- Pure translation is the nonzero witness and fixes both Fourier signs:
positive `n` shifts have positive exponent and negative `n` shifts have
negative exponent. The case `n = 0` is the onsite zero-flow control. -/
theorem scalarShift_fourier_witness (n : Int) (q : Real) :
    (fourierSymbol (scalarShift (K := Complex) n) q).det =
      Complex.exp ((n : Complex) * (Complex.I * (q : Complex))) := by
  have hkey : (fourierSymbol (scalarShift (K := Complex) n) q).det =
      fourierEval q (scalarShift (K := Complex) n).det :=
    (RingHom.map_det (fourierEval q) _).symm
  rw [hkey, scalarShift, Matrix.det_fin_one_of, fourierEval,
    LaurentPolynomial.eval₂_T, Units.val_zpow_eq_zpow_val]
  show (Complex.exp (Complex.I * (q : Complex))) ^ n = _
  rw [← Complex.exp_int_mul]

/-- Two opposite one-channel shifts. This is a nontrivial walk with zero net
determinant flow. -/
def balancedShift (n : Int) :
    Matrix (Fin 2) (Fin 2) (LaurentPolynomial Complex) :=
  !![LaurentPolynomial.T n, 0;
     0, LaurentPolynomial.T (-n)]

theorem balancedShift_det (n : Int) : (balancedShift n).det = 1 := by
  rw [balancedShift, Matrix.det_fin_two]
  change LaurentPolynomial.T n * LaurentPolynomial.T (-n) - 0 * 0 = 1
  rw [zero_mul, sub_zero, ← LaurentPolynomial.T_add]
  simp

theorem balancedShift_isUnit (n : Int) : IsUnit (balancedShift n) := by
  rw [Matrix.isUnit_iff_isUnit_det, balancedShift_det]
  exact isUnit_one

/-- Opposite channel shifts have zero net determinant exponent. -/
theorem flowExponent_balancedShift (n : Int) :
    flowExponent (balancedShift n) (balancedShift_isUnit n) = 0 := by
  apply flowExponent_eq_of_spec
  refine ⟨1, one_ne_zero, ?_⟩
  rw [balancedShift_det]
  simp [LaurentPolynomial.T_zero]

/-- The unit balanced shift is not the onsite identity, despite its zero net
flow exponent. -/
theorem balancedShift_one_ne_identity : balancedShift 1 ≠ 1 := by
  intro h
  have h00 := congrFun (congrFun h (0 : Fin 2)) (0 : Fin 2)
  change LaurentPolynomial.T 1 = 1 at h00
  have hdegree := congrArg LaurentPolynomial.degree h00
  rw [LaurentPolynomial.degree_T] at hdegree
  rw [show (1 : LaurentPolynomial Complex) = LaurentPolynomial.C 1 by simp,
    LaurentPolynomial.degree_C one_ne_zero] at hdegree
  norm_num at hdegree

/-! ## Bridge to the live degree-one analytic symbol -/

/-- Laurent-matrix encoding of the live degree-one analytic symbol. -/
def degreeOneSymbol
    (A B C : StationaryAmplitudeNoGo.Mat4) :
    Matrix (Fin 4) (Fin 4) (LaurentPolynomial Complex) :=
  fun i j =>
    LaurentPolynomial.C (A i j) * LaurentPolynomial.T 1 +
      LaurentPolynomial.C (B i j) +
      LaurentPolynomial.C (C i j) * LaurentPolynomial.T (-1)

/-- At the positive Fourier convention, the Laurent encoding evaluates
exactly to the repository's analytic degree-one walk symbol. -/
theorem fourierSymbol_degreeOneSymbol
    (A B C : StationaryAmplitudeNoGo.Mat4) (q : Real) :
    fourierSymbol (degreeOneSymbol A B C) q =
      StationaryAmplitudeNoGo.laurentStep A B C q := by
  ext i j
  simp [fourierSymbol, fourierEval, degreeOneSymbol,
    StationaryAmplitudeNoGo.laurentStep, phaseUnit,
    Complex.exp_neg]
  ring

set_option maxHeartbeats 2000000 in
/-- The live relaxed stationary-amplitude witness has determinant exactly one
as a Laurent polynomial. This is stronger than checking its determinant on the
unit circle and supplies the finite-inverse hypothesis needed by the flow
classifier. -/
theorem relaxedWitness_degreeOneSymbol_det :
    (degreeOneSymbol StationaryAmplitudeNoGo.wA StationaryAmplitudeNoGo.wB
      StationaryAmplitudeNoGo.wC).det = 1 := by
  classical
  rw [Matrix.det_succ_row_zero]
  rw [Fin.sum_univ_four]
  simp [degreeOneSymbol, StationaryAmplitudeNoGo.wA,
    StationaryAmplitudeNoGo.wB, StationaryAmplitudeNoGo.wC,
    Matrix.det_fin_three, Matrix.submatrix_apply, Fin.succAbove]
  norm_num
  ring_nf
  have hC :
      (LaurentPolynomial.C (1 / 2 : Complex) : LaurentPolynomial Complex) ^ 2 * 4 = 1 := by
    rw [show (4 : LaurentPolynomial Complex) = LaurentPolynomial.C 4 by rfl,
      ← map_pow, ← map_mul]
    norm_num
  calc
    (LaurentPolynomial.C (1 / 2 : Complex) : LaurentPolynomial Complex) ^ 2 *
          LaurentPolynomial.T 1 * LaurentPolynomial.T (-1) * 4 =
        ((LaurentPolynomial.C (1 / 2 : Complex) : LaurentPolynomial Complex) ^ 2 * 4) *
          (LaurentPolynomial.T 1 * LaurentPolynomial.T (-1)) := by ring
    _ = LaurentPolynomial.T 1 * LaurentPolynomial.T (-1) := by rw [hC, one_mul]
    _ = LaurentPolynomial.T (1 + (-1)) := by rw [LaurentPolynomial.T_add]
    _ = 1 := by norm_num

/-- The live relaxed witness is a strict finite Laurent walk. -/
theorem relaxedWitness_degreeOneSymbol_isUnit :
    IsUnit (degreeOneSymbol StationaryAmplitudeNoGo.wA
      StationaryAmplitudeNoGo.wB StationaryAmplitudeNoGo.wC) := by
  rw [Matrix.isUnit_iff_isUnit_det, relaxedWitness_degreeOneSymbol_det]
  exact isUnit_one

/-- The Laurent determinant flow assigns zero to the live relaxed witness. -/
theorem relaxedWitness_flowExponent_zero :
    flowExponent
      (degreeOneSymbol StationaryAmplitudeNoGo.wA StationaryAmplitudeNoGo.wB
        StationaryAmplitudeNoGo.wC)
      relaxedWitness_degreeOneSymbol_isUnit = 0 := by
  apply flowExponent_eq_of_spec
  refine ⟨1, one_ne_zero, ?_⟩
  rw [relaxedWitness_degreeOneSymbol_det]
  simp [LaurentPolynomial.T_zero]

/-- The live relaxed witness is not the onsite identity despite having zero
Laurent determinant flow. Thus determinant flow is not a complete classifier
of strict one-particle walks. -/
theorem relaxedWitness_degreeOneSymbol_ne_identity :
    degreeOneSymbol StationaryAmplitudeNoGo.wA StationaryAmplitudeNoGo.wB
      StationaryAmplitudeNoGo.wC ≠ 1 := by
  intro h
  have hpi := congrArg (fun M => fourierSymbol M Real.pi) h
  dsimp only at hpi
  rw [fourierSymbol_degreeOneSymbol] at hpi
  have hOne : fourierSymbol (1 : Matrix (Fin 4) (Fin 4)
      (LaurentPolynomial Complex)) Real.pi = 1 := by
    ext i j
    by_cases hij : i = j <;>
      simp [fourierSymbol, fourierEval, Matrix.one_apply, hij]
  rw [hOne] at hpi
  exact StationaryAmplitudeNoGo.witness_separates.1 hpi

/-- A live degree-one symbol with a finite Laurent inverse and exact
all-momentum unitarity has the determinant phase law of the algebraic flow
exponent. The finite-inverse hypothesis remains separate and load-bearing. -/
theorem degreeOneSymbol_det_phase
    (A B C : StationaryAmplitudeNoGo.Mat4)
    (hInv : IsUnit (degreeOneSymbol A B C))
    (hUnit : StationaryAmplitudeNoGo.UnitaryAllMomenta
      (StationaryAmplitudeNoGo.laurentStep A B C)) :
    exists c : Complex, norm c = 1 /\
      forall q : Real,
        (StationaryAmplitudeNoGo.laurentStep A B C q).det =
          c * Complex.exp
            ((flowExponent (degreeOneSymbol A B C) hInv : Complex) *
              (Complex.I * (q : Complex))) := by
  have hStrict : IsStrictTIUnitaryWalk (degreeOneSymbol A B C) := by
    refine ⟨hInv, ?_⟩
    intro q
    rw [fourierSymbol_degreeOneSymbol]
    exact hUnit q
  obtain ⟨c, hc, hphase⟩ :=
    strictTIUnitaryWalk_det_phase (degreeOneSymbol A B C) hStrict
  refine ⟨c, hc, ?_⟩
  intro q
  rw [← fourierSymbol_degreeOneSymbol]
  exact hphase q

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentFourierWalkBridge.strictTIUnitaryWalk_det_phase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms strictTIUnitaryWalk_det_phase

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentFourierWalkBridge.scalarShift_fourier_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scalarShift_fourier_witness

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentFourierWalkBridge.flowExponent_balancedShift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms flowExponent_balancedShift

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentFourierWalkBridge.balancedShift_one_ne_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms balancedShift_one_ne_identity

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentFourierWalkBridge.degreeOneSymbol_det_phase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms degreeOneSymbol_det_phase

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentFourierWalkBridge.relaxedWitness_degreeOneSymbol_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms relaxedWitness_degreeOneSymbol_det

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentFourierWalkBridge.relaxedWitness_flowExponent_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms relaxedWitness_flowExponent_zero

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentFourierWalkBridge.relaxedWitness_degreeOneSymbol_ne_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms relaxedWitness_degreeOneSymbol_ne_identity

end PhysicsSM.Draft.NullEdge.LaurentFourierWalkBridge
