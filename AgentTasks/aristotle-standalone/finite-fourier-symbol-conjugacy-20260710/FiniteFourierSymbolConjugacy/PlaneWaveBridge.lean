import Mathlib.Analysis.Fourier.ZMod
import Mathlib.LinearAlgebra.Matrix.Hermitian

/-!
# Exact finite Fourier sectors for a local three-axis walk

This focused package attacks the missing bridge between a finite periodic
position-space walk and its ordered matrix symbol.  Instead of assuming a
Fourier dictionary, it constructs every plane-wave sector explicitly and
proves that conditional shifts, basis conjugations, and the full ordered
three-axis step act on that sector by the advertised internal matrices.

The result is finite and exact.  It is the algebraic conjugacy rung needed
before a vector-valued Plancherel estimate can turn compact modewise bounds
into normalized position-space wave-packet bounds.  It does not assert an
infinite-volume or PDE limit.
-/

noncomputable section

open Matrix Complex
open scoped BigOperators ZMod

namespace FiniteFourierSymbolConjugacy

abbrev Axis := Fin 3
abbrev Internal := Fin 4
abbrev Position (L : Nat) := Axis -> ZMod L
abbrev State (L : Nat) := Position L -> Internal -> Complex
abbrev Vec4 := Internal -> Complex
abbrev Mat4 := Matrix Internal Internal Complex

/-- Source position for a channel-dependent nearest-neighbor shift. -/
def sourcePosition {L : Nat} (velocity : Axis -> Internal -> Bool)
    (axis : Axis) (a : Internal) (p : Position L) : Position L :=
  fun j => if j = axis then
    p j + if velocity axis a then -1 else 1
  else p j

/-- The corresponding local conditional shift. -/
def conditionalShift {L : Nat} (velocity : Axis -> Internal -> Bool)
    (axis : Axis) (psi : State L) : State L :=
  fun p a => psi (sourcePosition velocity axis a p) a

/-- Pointwise action of an internal matrix. -/
def pointwiseCoin {L : Nat} (U : Mat4) (psi : State L) : State L :=
  fun p => U.mulVec (psi p)

/-- Product plane wave on the finite three-torus. -/
def planeWave {L : Nat} [NeZero L]
    (k p : Position L) : Complex :=
  ∏ j : Axis, ZMod.stdAddChar (p j * k j)

/-- A plane wave with internal polarization `v`. -/
def modeState {L : Nat} [NeZero L]
    (k : Position L) (v : Vec4) : State L :=
  fun p a => planeWave k p * v a

/-- The exact phase acquired by one conditional source shift. -/
def shiftPhase {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (k : Position L) (a : Internal) : Complex :=
  if velocity axis a then
    ZMod.stdAddChar (-(k axis))
  else
    ZMod.stdAddChar (k axis)

/-- Diagonal internal symbol of the conditional shift. -/
def phaseDiag {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (k : Position L) : Mat4 :=
  diagonal (shiftPhase velocity axis k)

/-- Target 1: translating a product plane wave extracts exactly one channel
phase and leaves the base-point plane wave unchanged. -/
theorem planeWave_source {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (k p : Position L) (a : Internal) :
    planeWave k (sourcePosition velocity axis a p) =
      shiftPhase velocity axis k a * planeWave k p := by
  sorry

/-- Target 2: the conditional shift preserves each Fourier sector and acts
there by the diagonal phase symbol. -/
theorem conditionalShift_mode {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (k : Position L) (v : Vec4) :
    conditionalShift velocity axis (modeState k v) =
      modeState k ((phaseDiag velocity axis k).mulVec v) := by
  sorry

/-- Target 3: a pointwise coin acts only on the internal polarization. -/
theorem pointwiseCoin_mode {L : Nat} [NeZero L]
    (U : Mat4) (k : Position L) (v : Vec4) :
    pointwiseCoin U (modeState k v) = modeState k (U.mulVec v) := by
  sorry

/-- A conditional shift conjugated into an arbitrary internal basis. -/
def conjugatedShift {L : Nat} (velocity : Axis -> Internal -> Bool)
    (axis : Axis) (U : Mat4) (psi : State L) : State L :=
  pointwiseCoin U
    (conditionalShift velocity axis (pointwiseCoin U.conjTranspose psi))

/-- Exact internal symbol of a basis-conjugated conditional shift. -/
def axisModeSymbol {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (U : Mat4) (k : Position L) : Mat4 :=
  U * phaseDiag velocity axis k * U.conjTranspose

/-- Target 4: exact Fourier-sector action after the load-bearing basis
conjugation. -/
theorem conjugatedShift_mode {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (U : Mat4) (k : Position L) (v : Vec4) :
    conjugatedShift velocity axis U (modeState k v) =
      modeState k ((axisModeSymbol velocity axis U k).mulVec v) := by
  sorry

/-- Ordered finite local step: mass coin first, then axes 2, 1, and 0 on
states, so its matrix symbol is the displayed 0/1/2/mass product. -/
def localStep {L : Nat} (velocity : Axis -> Internal -> Bool)
    (U0 U1 U2 mass : Mat4) (psi : State L) : State L :=
  conjugatedShift velocity 0 U0
    (conjugatedShift velocity 1 U1
      (conjugatedShift velocity 2 U2 (pointwiseCoin mass psi)))

/-- Ordered internal symbol of `localStep`. -/
def localSymbol {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool)
    (U0 U1 U2 mass : Mat4) (k : Position L) : Mat4 :=
  axisModeSymbol velocity 0 U0 k *
    axisModeSymbol velocity 1 U1 k *
      axisModeSymbol velocity 2 U2 k * mass

/-- Target 5: the full finite position operator is exactly block diagonal on
plane waves, with each block equal to the ordered local symbol. -/
theorem localStep_mode {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool)
    (U0 U1 U2 mass : Mat4) (k : Position L) (v : Vec4) :
    localStep velocity U0 U1 U2 mass (modeState k v) =
      modeState k ((localSymbol velocity U0 U1 U2 mass k).mulVec v) := by
  sorry

/-- Target 6: the standard additive character has its exact lattice-momentum
exponential, fixing the sign and normalization convention. -/
theorem stdAddChar_val_formula {L : Nat} [NeZero L] (q : ZMod L) :
    ZMod.stdAddChar q =
      Complex.exp (2 * Real.pi * Complex.I * q.val / L) := by
  sorry

/-- Target 7: every conditional-shift phase has unit modulus. -/
theorem shiftPhase_norm {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (k : Position L) (a : Internal) :
    norm (shiftPhase velocity axis k a) = 1 := by
  sorry

/-- Target 8: if the basis is unitary, its exact mode symbol is unitary. -/
theorem axisModeSymbol_unitary {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (U : Mat4) (k : Position L)
    (hU : U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1) :
    (axisModeSymbol velocity axis U k).conjTranspose *
          axisModeSymbol velocity axis U k = 1 ∧
      axisModeSymbol velocity axis U k *
          (axisModeSymbol velocity axis U k).conjTranspose = 1 := by
  sorry

/-- Target 9: zero momentum is a concrete normalization control. -/
theorem zero_mode_control {L : Nat} [NeZero L] (v : Vec4) :
    modeState (L := L) (fun _ => 0) v = fun _ => v := by
  sorry

/-- Target 10: a nonzero polarization gives a genuinely nonzero Fourier mode,
so the sector theorem is not vacuous. -/
theorem modeState_nonzero {L : Nat} [NeZero L]
    (k : Position L) (v : Vec4) (hv : v != 0) :
    modeState k v != 0 := by
  sorry

end FiniteFourierSymbolConjugacy
