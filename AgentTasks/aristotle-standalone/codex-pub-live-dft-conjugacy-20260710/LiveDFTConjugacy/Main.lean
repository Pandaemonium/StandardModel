import PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge
import PhysicsSM.Draft.NullEdge.GateC1.FiniteFourierParseval

/-!
# Complete product DFT conjugacy for the live finite 3+1 walk

This focused proof target upgrades the existing plane-wave sector theorem to a
complete normalized Fourier transform for arbitrary finite-torus fields.  The
target includes character orthogonality, both round trips, Parseval, and exact
operator-level block diagonalization of the live local walk.

The positive-exponential `planeWave` convention is fixed by
`Finite3Plus1FourierBridge.localStep_mode`; the forward transform therefore
uses its complex conjugate.
-/

noncomputable section

open Matrix Complex
open scoped BigOperators ZMod

namespace PhysicsSM.Draft.NullEdge.LiveDFTConjugacy

open Finite3Plus1FourierBridge

abbrev Axis := Finite3Plus1FourierBridge.Axis
abbrev Internal := Finite3Plus1FourierBridge.Internal
abbrev Position (L : Nat) := Finite3Plus1FourierBridge.Position L
abbrev State (L : Nat) := Finite3Plus1FourierBridge.State L
abbrev Vec4 := Finite3Plus1FourierBridge.Vec4

/-- Number of sites on the live cubic three-torus. -/
def siteCard (L : Nat) [NeZero L] : Nat := Fintype.card (Position L)

/-- Unitary DFT normalization. -/
def fourierNormFactor (L : Nat) [NeZero L] : Real :=
  1 / Real.sqrt (siteCard L : Real)

/-- Forward product DFT in the convention dual to the positive plane wave. -/
def rawFourier {L : Nat} [NeZero L] (psi : State L) : Position L -> Vec4 :=
  fun k a => ∑ p : Position L, star (planeWave k p) * psi p a

/-- Normalized forward product DFT. -/
def fourier {L : Nat} [NeZero L] (psi : State L) : Position L -> Vec4 :=
  fun k a => (fourierNormFactor L : Complex) * rawFourier psi k a

/-- Inverse product DFT. -/
def inverseFourier {L : Nat} [NeZero L]
    (phi : Position L -> Vec4) : State L :=
  fun p a => (fourierNormFactor L : Complex) *
    ∑ k : Position L, planeWave k p * phi k a

/-- Finite position-space squared norm. -/
def positionNormSq {L : Nat} [NeZero L] (psi : State L) : Real :=
  ∑ p : Position L, ∑ a : Internal, Complex.normSq (psi p a)

/-- Finite momentum-space squared norm. -/
def momentumNormSq {L : Nat} [NeZero L] (phi : Position L -> Vec4) : Real :=
  ∑ k : Position L, ∑ a : Internal, Complex.normSq (phi k a)

/-- Product-character column orthogonality. -/
theorem planeWave_column_orthogonality {L : Nat} [NeZero L]
    (p q : Position L) :
    ∑ k : Position L, star (planeWave k p) * planeWave k q =
      if p = q then (siteCard L : Complex) else 0 := by
  sorry

/-- Product-character row orthogonality. -/
theorem planeWave_row_orthogonality {L : Nat} [NeZero L]
    (k ell : Position L) :
    ∑ p : Position L, planeWave k p * star (planeWave ell p) =
      if k = ell then (siteCard L : Complex) else 0 := by
  sorry

/-- The normalization cancels the finite site count exactly. -/
theorem fourierNormFactor_sq_mul_card (L : Nat) [NeZero L] :
    fourierNormFactor L * fourierNormFactor L * (siteCard L : Real) = 1 := by
  sorry

/-- Inverse after forward is the identity on every finite field. -/
theorem inverseFourier_fourier {L : Nat} [NeZero L] (psi : State L) :
    inverseFourier (fourier psi) = psi := by
  sorry

/-- Forward after inverse is the identity on every momentum field. -/
theorem fourier_inverseFourier {L : Nat} [NeZero L]
    (phi : Position L -> Vec4) :
    fourier (inverseFourier phi) = phi := by
  sorry

/-- The normalized product DFT obeys exact Parseval. -/
theorem fourier_parseval {L : Nat} [NeZero L] (psi : State L) :
    momentumNormSq (fourier psi) = positionNormSq psi := by
  sorry

/-- Exact operator-level Fourier conjugacy for the live local 3+1 walk. -/
theorem fourier_localStep {L : Nat} [NeZero L]
    (m eps : Real) (psi : State L) (k : Position L) :
    fourier (Local3Plus1RateBridge.localStep m eps psi) k =
      (finiteLocalSymbol m eps k).mulVec (fourier psi k) := by
  sorry

/-- Zero momentum of a constant nonzero polarization is nonzero. -/
theorem constant_field_zero_mode_nonzero {L : Nat} [NeZero L]
    (v : Vec4) (hv : v != 0) :
    fourier (fun _ => v) (0 : Position L) ≠ 0 := by
  sorry

/-- A one-site impulse has a nonzero flat transform, ruling out a vacuous DFT. -/
theorem delta_field_transform_nonzero {L : Nat} [NeZero L]
    (p0 : Position L) (a0 : Internal) :
    fourier (fun p a => if p = p0 ∧ a = a0 then 1 else 0) ≠ 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.LiveDFTConjugacy
