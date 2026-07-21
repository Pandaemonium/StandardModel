import Mathlib

/-!
# Exact two-component Weyl generator under Fourier transform

This module proves the exact continuum Weyl generator identity on the Schwartz
domain used by the HNU changing-lattice continuum endpoint. Mathlib's forward
Fourier kernel contains `-2 * pi * I`, so the position-space derivative is
normalized by `-I / (2 * pi)`.

The result identifies the displayed position differential expression with
the momentum multiplier `q dot sigma`. It complements, but does not imply, the
changing-lattice strong evolution theorem in
`HNUChangingLatticeContinuumCapstone.lean`.

Claim boundary: no unbounded self-adjoint operator closure, interacting field,
massive Dirac equation, primitive-null microscopic realization, or physical
particle pole is claimed.

Provenance: theorem statements prepared from Mathlib's
`SchwartzMap.fourier_lineDerivOp_eq` convention and the repository's earlier
Fourier derivative proof patterns. Proofs were returned by Aristotle project
`f1971541-94f0-4450-b62e-872fd583badd`, task
`179b191d-dca8-4cf0-b772-1308f52fdefb`, and replayed locally under Lean 4.28
on July 20, 2026.
-/

noncomputable section

open MeasureTheory Complex Real Matrix
open FourierTransform
open scoped RealInnerProductSpace

namespace PhysicsSM.Draft.NullEdge.HNUWeylSchwartzPDE

abbrev Momentum3 := EuclideanSpace Real (Fin 3)
abbrev WeylSpinor := EuclideanSpace Complex (Fin 2)
abbrev Mat2 := Matrix (Fin 2) (Fin 2) Complex

def sigma1 : Mat2 := !![0, 1; 1, 0]
def sigma2 : Mat2 := !![0, -Complex.I; Complex.I, 0]
def sigma3 : Mat2 := !![1, 0; 0, -1]

def weylSymbol (q : Momentum3) : Mat2 :=
  (q 0 : Complex) • sigma1 +
    (q 1 : Complex) • sigma2 +
    (q 2 : Complex) • sigma3

def matrixAction (A : Mat2) : WeylSpinor →L[Complex] WeylSpinor :=
  Matrix.toEuclideanCLM (𝕜 := Complex) A

def coordinateDerivative (g : SchwartzMap Momentum3 WeylSpinor) (j : Fin 3)
    (x : Momentum3) : WeylSpinor :=
  fderiv Real (fun y => g y) x (EuclideanSpace.single j (1 : Real))

/-- The position-space Weyl differential expression in Mathlib's Fourier
normalization. -/
def positionWeyl (g : SchwartzMap Momentum3 WeylSpinor)
    (x : Momentum3) : WeylSpinor :=
  (-Complex.I / (2 * (Real.pi : Complex))) •
    (matrixAction sigma1 (coordinateDerivative g 0 x) +
      matrixAction sigma2 (coordinateDerivative g 1 x) +
      matrixAction sigma3 (coordinateDerivative g 2 x))

/-- The Fourier transform of a coordinate derivative has the exact positive
`2*pi*I*w_j` multiplier under Mathlib's convention. -/
theorem fourier_partial_correspondence
    (g : SchwartzMap Momentum3 WeylSpinor) (j : Fin 3) :
    (𝓕 fun x => coordinateDerivative g j x) =
      fun w =>
        (2 * (Real.pi : Complex) * Complex.I * (w j : Complex)) •
          𝓕 (fun x => g x) w := by
  let dg : SchwartzMap Momentum3 WeylSpinor :=
    LineDeriv.lineDerivOp (EuclideanSpace.single j (1 : Real)) g
  have hcoord : (fun x => coordinateDerivative g j x) =
      (dg : Momentum3 -> WeylSpinor) := by
    funext x
    rfl
  rw [hcoord, ← SchwartzMap.fourier_coe,
    show dg = LineDeriv.lineDerivOp (EuclideanSpace.single j (1 : Real)) g from rfl,
    SchwartzMap.fourier_lineDerivOp_eq, ← SchwartzMap.fourier_coe]
  ext w i
  simp only [SchwartzMap.smul_apply]
  rw [SchwartzMap.smulLeftCLM_apply_apply (by fun_prop)]
  simp [EuclideanSpace.inner_single_right, mul_assoc]

/-- Fourier transform commutes with a fixed bounded `2 x 2` matrix action. -/
theorem fourier_matrixAction
    (A : Mat2) (f : Momentum3 -> WeylSpinor) (hf : Integrable f) :
    𝓕 (fun x => matrixAction A (f x)) =
      fun w => matrixAction A (𝓕 f w) := by
  funext w
  rw [fourier_eq, fourier_eq]
  rw [← (matrixAction A).integral_comp_comm
    ((fourierIntegral_convergent_iff w).2 hf)]
  congr 1
  funext x
  exact ((matrixAction A).map_smul_of_tower _ _).symm

/-- The displayed Weyl differential expression is integrable for every
Schwartz two-spinor. -/
theorem positionWeyl_integrable (g : SchwartzMap Momentum3 WeylSpinor) :
    Integrable (positionWeyl g) := by
  have hderiv (j : Fin 3) : Integrable (coordinateDerivative g j) := by
    let dg : SchwartzMap Momentum3 WeylSpinor :=
      LineDeriv.lineDerivOp (EuclideanSpace.single j (1 : Real)) g
    have hcoord : coordinateDerivative g j =
        (dg : Momentum3 -> WeylSpinor) := by
      funext x
      rfl
    rw [hcoord]
    exact dg.integrable
  have hmatrix (A : Mat2) (j : Fin 3) :
      Integrable (fun x => matrixAction A (coordinateDerivative g j x)) :=
    (matrixAction A).integrable_comp (hderiv j)
  unfold positionWeyl
  simpa only [Pi.smul_apply, Pi.add_apply, add_assoc] using
    (((hmatrix sigma1 0).add
      ((hmatrix sigma2 1).add (hmatrix sigma3 2))).smul
        (-Complex.I / (2 * (Real.pi : Complex))))

/-- Exact position-to-momentum Weyl generator identity. -/
theorem fourier_positionWeyl (g : SchwartzMap Momentum3 WeylSpinor) :
    𝓕 (positionWeyl g) =
      fun w => matrixAction (weylSymbol w)
        (𝓕 (fun x => g x) w) := by
  have hderiv (j : Fin 3) : Integrable (coordinateDerivative g j) := by
    let dg : SchwartzMap Momentum3 WeylSpinor :=
      LineDeriv.lineDerivOp (EuclideanSpace.single j (1 : Real)) g
    have hcoord : coordinateDerivative g j =
        (dg : Momentum3 -> WeylSpinor) := by
      funext x
      rfl
    rw [hcoord]
    exact dg.integrable
  have hm (A : Mat2) (j : Fin 3) :
      𝓕 (fun x => matrixAction A (coordinateDerivative g j x)) =
        fun w => matrixAction A
          ((2 * (Real.pi : Complex) * Complex.I * (w j : Complex)) •
            𝓕 (fun x => g x) w) := by
    rw [fourier_matrixAction A _ (hderiv j), fourier_partial_correspondence]
  have hmatrix (A : Mat2) (j : Fin 3) :
      Integrable (fun x => matrixAction A (coordinateDerivative g j x)) :=
    (matrixAction A).integrable_comp (hderiv j)
  funext w
  rw [fourier_eq]
  unfold positionWeyl
  change (∫ v, (𝐞 (-⟪v, w⟫) : Complex) •
      ((-Complex.I / (2 * (Real.pi : Complex))) •
        (matrixAction sigma1 (coordinateDerivative g 0 v) +
         matrixAction sigma2 (coordinateDerivative g 1 v) +
         matrixAction sigma3 (coordinateDerivative g 2 v)))) = _
  simp_rw [smul_smul]
  conv_lhs =>
    enter [2, v]
    rw [mul_comm]
  simp_rw [← smul_smul]
  rw [integral_smul]
  have hi1 := (fourierIntegral_convergent_iff w).2 (hmatrix sigma1 0)
  have hi2 := (fourierIntegral_convergent_iff w).2 (hmatrix sigma2 1)
  have hi3 := (fourierIntegral_convergent_iff w).2 (hmatrix sigma3 2)
  have hint :
      (∫ v, (𝐞 (-⟪v, w⟫) : Complex) •
        (matrixAction sigma1 (coordinateDerivative g 0 v) +
         matrixAction sigma2 (coordinateDerivative g 1 v) +
         matrixAction sigma3 (coordinateDerivative g 2 v))) =
      (∫ v, (𝐞 (-⟪v, w⟫) : Complex) •
        matrixAction sigma1 (coordinateDerivative g 0 v)) +
      ((∫ v, (𝐞 (-⟪v, w⟫) : Complex) •
        matrixAction sigma2 (coordinateDerivative g 1 v)) +
      (∫ v, (𝐞 (-⟪v, w⟫) : Complex) •
        matrixAction sigma3 (coordinateDerivative g 2 v))) := by
    rw [show (fun v => (𝐞 (-⟪v, w⟫) : Complex) •
        (matrixAction sigma1 (coordinateDerivative g 0 v) +
         matrixAction sigma2 (coordinateDerivative g 1 v) +
         matrixAction sigma3 (coordinateDerivative g 2 v))) =
      fun v => (𝐞 (-⟪v, w⟫) : Complex) •
        matrixAction sigma1 (coordinateDerivative g 0 v) +
        ((𝐞 (-⟪v, w⟫) : Complex) •
        matrixAction sigma2 (coordinateDerivative g 1 v) +
        (𝐞 (-⟪v, w⟫) : Complex) •
        matrixAction sigma3 (coordinateDerivative g 2 v)) by
          funext v
          rw [smul_add, smul_add, add_assoc]]
    calc
      _ = (∫ v, (𝐞 (-⟪v, w⟫) : Complex) •
          matrixAction sigma1 (coordinateDerivative g 0 v)) +
          ∫ v, ((𝐞 (-⟪v, w⟫) : Complex) •
            matrixAction sigma2 (coordinateDerivative g 1 v) +
            (𝐞 (-⟪v, w⟫) : Complex) •
            matrixAction sigma3 (coordinateDerivative g 2 v)) :=
        integral_add hi1 (hi2.add hi3)
      _ = _ := by
        congr 1
        exact integral_add hi2 hi3
  rw [hint]
  change (-Complex.I / (2 * (Real.pi : Complex))) •
      (𝓕 (fun x => matrixAction sigma1 (coordinateDerivative g 0 x)) w +
       (𝓕 (fun x => matrixAction sigma2 (coordinateDerivative g 1 x)) w +
       𝓕 (fun x => matrixAction sigma3 (coordinateDerivative g 2 x)) w)) = _
  rw [congr_fun (hm sigma1 0) w, congr_fun (hm sigma2 1) w,
    congr_fun (hm sigma3 2) w]
  unfold weylSymbol matrixAction
  ext i
  simp [Matrix.ofLp_toEuclideanCLM, Matrix.mulVec]
  field_simp [Real.pi_ne_zero]
  simp [Complex.I_sq]
  ring

/-- The Weyl symbol is genuinely nonzero on a coordinate-axis momentum. -/
theorem weylSymbol_axis_nonzero :
    weylSymbol (EuclideanSpace.single (0 : Fin 3) (1 : Real)) ≠ 0 := by
  intro h
  have hentry := congrFun (congrFun h 0) 1
  norm_num at hentry
  unfold weylSymbol at hentry
  norm_num [sigma1, sigma2, sigma3] at hentry

/-- Zero-state boundary control for the full Fourier/Weyl identity. -/
theorem fourier_positionWeyl_zero :
    𝓕 (positionWeyl (0 : SchwartzMap Momentum3 WeylSpinor)) =
      fun w => matrixAction (weylSymbol w)
        (𝓕 (fun x => (0 : SchwartzMap Momentum3 WeylSpinor) x) w) := by
  convert fourier_positionWeyl 0 using 1

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUWeylSchwartzPDE.fourier_partial_correspondence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_partial_correspondence

/-- info: 'PhysicsSM.Draft.NullEdge.HNUWeylSchwartzPDE.fourier_positionWeyl' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_positionWeyl

/-- info: 'PhysicsSM.Draft.NullEdge.HNUWeylSchwartzPDE.weylSymbol_axis_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weylSymbol_axis_nonzero

end PhysicsSM.Draft.NullEdge.HNUWeylSchwartzPDE
