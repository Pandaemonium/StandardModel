import Mathlib.Analysis.Fourier.ZMod
import PhysicsSM.Draft.NullEdge.Local3Plus1RateBridge

/-!
# Exact Fourier sectors of the finite local 3+1 walk

This module proves directly that every product plane-wave sector of the live
finite-torus walk is invariant.  Conditional shifts act by exact roots of
unity, the Clifford basis changes conjugate those diagonal phases, and the
full local update acts by the ordered axis-0/axis-1/axis-2/mass matrix block.

The plane wave here uses the positive exponential convention.  Accordingly,
its finite character block corresponds to the analytic walk symbol after a
momentum-sign conversion.  That final convention bridge is stated as a
separate obligation; it is not hidden in the phrase "Fourier symbol."

Provenance: theorem design follows the live successive-axis walk.  Proofs are
clean-room integrations of Aristotle project
`1d093252-36d7-4326-af4c-f48ffb2ec72a`, specialized to the actual project
definitions and checked under Lean 4.28.0.
-/

noncomputable section

open Matrix Complex
open scoped BigOperators ZMod

namespace PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge

abbrev Axis := SuccessiveAxisPositionWalk.Axis
abbrev Internal := SuccessiveAxisPositionWalk.Internal
abbrev Position (L : Nat) := SuccessiveAxisPositionWalk.Position L
abbrev State (L : Nat) := SuccessiveAxisPositionWalk.State L
abbrev Vec4 := Internal -> Complex
abbrev Mat4 := SuccessiveAxisDiracWalk.Mat4

/-- Product plane wave on the finite three-torus, in the positive exponential
convention. -/
def planeWave {L : Nat} [NeZero L]
    (k p : Position L) : Complex :=
  ∏ j : Axis, ZMod.stdAddChar (p j * k j)

/-- Plane wave with an internal four-component polarization. -/
def modeState {L : Nat} [NeZero L]
    (k : Position L) (v : Vec4) : State L :=
  fun p a => planeWave k p * v a

/-- Exact phase acquired by the live channel-dependent source shift. -/
def shiftPhase {L : Nat} [NeZero L]
    (axis : Axis) (k : Position L) (a : Internal) : Complex :=
  if SuccessiveAxisPositionWalk.tetraVelocity axis a then
    ZMod.stdAddChar (-(k axis))
  else
    ZMod.stdAddChar (k axis)

/-- Diagonal finite-character symbol of one conditional shift. -/
def phaseDiag {L : Nat} [NeZero L]
    (axis : Axis) (k : Position L) : Mat4 :=
  diagonal (shiftPhase axis k)

/-- A live source translation extracts exactly one channel phase. -/
theorem planeWave_source {L : Nat} [NeZero L]
    (axis : Axis) (k p : Position L) (a : Internal) :
    planeWave k
        (SuccessiveAxisPositionWalk.sourcePosition
          SuccessiveAxisPositionWalk.tetraVelocity axis a p) =
      shiftPhase axis k a * planeWave k p := by
  unfold planeWave
  have key : forall j : Axis,
      ZMod.stdAddChar
          ((SuccessiveAxisPositionWalk.sourcePosition
            SuccessiveAxisPositionWalk.tetraVelocity axis a p) j * k j) =
        (if j = axis then shiftPhase axis k a else 1) *
          ZMod.stdAddChar (p j * k j) := by
    intro j
    rcases eq_or_ne j axis with hj | hj
    · subst hj
      simp only [SuccessiveAxisPositionWalk.sourcePosition, if_true, shiftPhase]
      rw [add_mul, AddChar.map_add_eq_mul, mul_comm]
      congr 1
      split <;> simp [neg_mul, one_mul]
    · simp only [SuccessiveAxisPositionWalk.sourcePosition, if_neg hj, one_mul]
  rw [Finset.prod_congr rfl (fun j _ => key j),
    Finset.prod_mul_distrib,
    Finset.prod_ite_eq' Finset.univ axis (fun _ => shiftPhase axis k a)]
  simp

/-- The live conditional shift preserves each finite Fourier sector. -/
theorem conditionalShift_mode {L : Nat} [NeZero L]
    (axis : Axis) (k : Position L) (v : Vec4) :
    SuccessiveAxisPositionWalk.conditionalShift
        SuccessiveAxisPositionWalk.tetraVelocity axis
        (modeState k v) =
      modeState k ((phaseDiag axis k).mulVec v) := by
  funext p a
  simp only [SuccessiveAxisPositionWalk.conditionalShift, modeState, phaseDiag,
    mulVec_diagonal]
  rw [planeWave_source]
  ring

/-- A live pointwise coin acts only on the internal polarization. -/
theorem pointwiseCoin_mode {L : Nat} [NeZero L]
    (U : Mat4) (k : Position L) (v : Vec4) :
    SuccessiveAxisPositionWalk.pointwiseCoin U (modeState k v) =
      modeState k (U.mulVec v) := by
  funext p a
  change (U.mulVec (modeState k v p)) a =
    planeWave k p * (U.mulVec v) a
  have h : modeState k v p = planeWave k p • v := by
    funext b
    simp [modeState, smul_eq_mul]
  rw [h, Matrix.mulVec_smul]
  simp [smul_eq_mul]

/-- Exact finite-character block of a Clifford-basis conditional shift. -/
def finiteAxisSymbol {L : Nat} [NeZero L]
    (axis : Axis) (k : Position L) : Mat4 :=
  CliffordDiagonalPositionBridge.axisBasis axis * phaseDiag axis k *
    (CliffordDiagonalPositionBridge.axisBasis axis)ᴴ

/-- The actual Clifford-basis shift acts by `finiteAxisSymbol` on every
plane-wave sector. -/
theorem cliffordAxisShift_mode {L : Nat} [NeZero L]
    (axis : Axis) (k : Position L) (v : Vec4) :
    CliffordDiagonalPositionBridge.cliffordAxisShift axis (modeState k v) =
      modeState k ((finiteAxisSymbol axis k).mulVec v) := by
  unfold CliffordDiagonalPositionBridge.cliffordAxisShift finiteAxisSymbol
  rw [pointwiseCoin_mode, conditionalShift_mode, pointwiseCoin_mode]
  rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec]

/-- Ordered exact finite-character block of the complete live local step. -/
def finiteLocalSymbol {L : Nat} [NeZero L]
    (m eps : Real) (k : Position L) : Mat4 :=
  finiteAxisSymbol 0 k * finiteAxisSymbol 1 k *
    finiteAxisSymbol 2 k * Local3Plus1RateBridge.massFactor m eps

/-- The full live local position operator is exactly block diagonal on product
plane waves, in axis-0/axis-1/axis-2/mass order. -/
theorem localStep_mode {L : Nat} [NeZero L]
    (m eps : Real) (k : Position L) (v : Vec4) :
    Local3Plus1RateBridge.localStep m eps (modeState k v) =
      modeState k ((finiteLocalSymbol m eps k).mulVec v) := by
  unfold Local3Plus1RateBridge.localStep finiteLocalSymbol
  rw [pointwiseCoin_mode, cliffordAxisShift_mode,
    cliffordAxisShift_mode, cliffordAxisShift_mode]
  rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec]

/-- Exact lattice-momentum exponential of the standard additive character. -/
theorem stdAddChar_val_formula {L : Nat} [NeZero L] (q : ZMod L) :
    ZMod.stdAddChar q =
      Complex.exp (2 * Real.pi * Complex.I * q.val / L) := by
  rw [ZMod.stdAddChar_apply, ZMod.toCircle_apply]

/-- Every finite conditional-shift phase has unit modulus. -/
theorem shiftPhase_norm {L : Nat} [NeZero L]
    (axis : Axis) (k : Position L) (a : Internal) :
    norm (shiftPhase axis k a) = 1 := by
  rw [shiftPhase]
  split <;> rw [ZMod.stdAddChar_apply] <;> exact Circle.norm_coe _

/-- Zero lattice momentum is an exact normalization control. -/
theorem zero_mode_control {L : Nat} [NeZero L] (v : Vec4) :
    modeState (L := L) (fun _ => 0) v = fun _ => v := by
  funext p a
  change planeWave (fun _ => 0) p * v a = v a
  have hOne : planeWave (fun _ => (0 : ZMod L)) p = 1 := by
    unfold planeWave
    apply Finset.prod_eq_one
    intro j _
    simp [AddChar.map_zero_eq_one]
  rw [hOne, one_mul]

/-- A nonzero polarization gives a nonzero Fourier mode. -/
theorem modeState_nonzero {L : Nat} [NeZero L]
    (k : Position L) (v : Vec4) (hv : v ≠ 0) :
    modeState k v ≠ 0 := by
  intro h
  apply hv
  funext a
  have hp := congrFun (congrFun h (fun _ => 0)) a
  simp only [modeState, Pi.zero_apply] at hp
  have hpw : planeWave k (fun _ => (0 : ZMod L)) = 1 := by
    unfold planeWave
    apply Finset.prod_eq_one
    intro j _
    simp [AddChar.map_zero_eq_one]
  rw [hpw, one_mul] at hp
  exact hp

end PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.localStep_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.localStep_mode

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.stdAddChar_val_formula' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.stdAddChar_val_formula

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.shiftPhase_norm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.shiftPhase_norm

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.modeState_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.modeState_nonzero
