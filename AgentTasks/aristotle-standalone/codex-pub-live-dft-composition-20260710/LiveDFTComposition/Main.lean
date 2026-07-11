import PhysicsSM.Draft.NullEdge.Finite3Plus1ProductDFTCore
import PhysicsSM.Draft.NullEdge.GateC1.FiniteFourierParseval

/-!
# Complete normalized DFT and live-walk conjugacy

The exact product-character orthogonality and normalization are already proved
in `Finite3Plus1ProductDFTCore`.  This target performs only the finite-linear
composition: transform round trips, Parseval, complete mode expansion, and
operator-level conjugacy of the live local 3+1 walk.
-/

noncomputable section

open Matrix Complex
open scoped BigOperators ZMod

namespace PhysicsSM.Draft.NullEdge.LiveDFTComposition

open Finite3Plus1FourierBridge
open Finite3Plus1ProductDFTCore

abbrev Axis := Finite3Plus1FourierBridge.Axis
abbrev Internal := Finite3Plus1FourierBridge.Internal
abbrev Position (L : Nat) := Finite3Plus1FourierBridge.Position L
abbrev State (L : Nat) := Finite3Plus1FourierBridge.State L
abbrev Vec4 := Finite3Plus1FourierBridge.Vec4

def rawFourier {L : Nat} [NeZero L] (psi : State L) : Position L -> Vec4 :=
  fun k a => ∑ p : Position L, star (planeWave k p) * psi p a

def fourier {L : Nat} [NeZero L] (psi : State L) : Position L -> Vec4 :=
  fun k a => (fourierNormFactor L : Complex) * rawFourier psi k a

def inverseFourier {L : Nat} [NeZero L]
    (phi : Position L -> Vec4) : State L :=
  fun p a => (fourierNormFactor L : Complex) *
    ∑ k : Position L, planeWave k p * phi k a

def positionNormSq {L : Nat} [NeZero L] (psi : State L) : Real :=
  ∑ p : Position L, ∑ a : Internal, Complex.normSq (psi p a)

def momentumNormSq {L : Nat} [NeZero L]
    (phi : Position L -> Vec4) : Real :=
  ∑ k : Position L, ∑ a : Internal, Complex.normSq (phi k a)

theorem inverseFourier_fourier {L : Nat} [NeZero L] (psi : State L) :
    inverseFourier (fourier psi) = psi := by
  sorry

theorem fourier_inverseFourier {L : Nat} [NeZero L]
    (phi : Position L -> Vec4) :
    fourier (inverseFourier phi) = phi := by
  sorry

theorem fourier_parseval {L : Nat} [NeZero L] (psi : State L) :
    momentumNormSq (fourier psi) = positionNormSq psi := by
  sorry

theorem fourier_sum {L : Nat} [NeZero L] {ι : Type*}
    (s : Finset ι) (f : ι -> State L) (k : Position L) :
    fourier (∑ i ∈ s, f i) k = ∑ i ∈ s, fourier (f i) k := by
  sorry

theorem localStep_sum {L : Nat} {ι : Type*}
    (m eps : Real) (s : Finset ι) (f : ι -> State L) :
    Local3Plus1RateBridge.localStep m eps (∑ i ∈ s, f i) =
      ∑ i ∈ s, Local3Plus1RateBridge.localStep m eps (f i) := by
  sorry

theorem fourier_modeState {L : Nat} [NeZero L]
    (k ell : Position L) (v : Vec4) :
    fourier (modeState k v) ell =
      ((fourierNormFactor L : Complex) *
        (if k = ell then (siteCard L : Complex) else 0)) • v := by
  sorry

theorem state_eq_sum_modeState {L : Nat} [NeZero L] (psi : State L) :
    psi = ∑ q : Position L,
      modeState q (fun a =>
        (fourierNormFactor L : Complex) * fourier psi q a) := by
  sorry

theorem fourier_localStep {L : Nat} [NeZero L]
    (m eps : Real) (psi : State L) (k : Position L) :
    fourier (Local3Plus1RateBridge.localStep m eps psi) k =
      (finiteLocalSymbol m eps k).mulVec (fourier psi k) := by
  sorry

theorem constant_field_zero_mode_nonzero {L : Nat} [NeZero L]
    (v : Vec4) (hv : v != 0) :
    fourier (fun _ => v) (0 : Position L) != 0 := by
  sorry

theorem delta_field_transform_nonzero {L : Nat} [NeZero L]
    (p0 : Position L) (a0 : Internal) :
    fourier (fun p a => if p = p0 ∧ a = a0 then 1 else 0) != 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.LiveDFTComposition
