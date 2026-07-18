import Mathlib

/-!
# Planar corner histories are real at every order (all-orders CP-inertness)

Standalone Aristotle package (Mathlib-only imports). Spiral-layer wave 2,
job C, 2026-07-16.
Integrated 2026-07-16 from Aristotle project 058a9901-a302-4726-8962-588fa33eb1cc (run 15313c61); statements verbatim from the submitted package; namespace renamed for the draft tree; axiom guards added at integration.

## What this file states

Wave 1 proved that THREE-corner planar histories have a real Bargmann
invariant, and wave 2 job A extends that to four corners. This file proves
the all-orders statement by exhibiting the closed real subalgebra of the
planar corner calculus:

1. `RealForm`: the real span of {1, sigmaX, sigmaY, sigmaX*sigmaY} inside
   the 2x2 complex matrices (a copy of the real 2x2 matrix algebra /
   split-quaternions).
2. `realForm_one`, `realForm_mul`: RealForm contains 1 and is closed under
   multiplication.
3. `realForm_projP`: every planar spin-coherent corner
   projP u v = (1 + u sigmaX + v sigmaY)/2 lies in RealForm (u v : R raw,
   no normalization).
4. `realForm_trace_im`: every RealForm matrix has real trace.
5. `planar_history_trace_real`: for EVERY finite list of planar directions,
   the trace of the ordered product of the corner matrices is real
   (imaginary part zero). This is the all-orders theorem: planar (zigzag)
   direction content cannot generate an orientation-odd phase at ANY number
   of corners.
6. `nonplanar_escape_witness`: the nonplanar control - the wave-1 handed
   triple x -> y -> z in the full 3D corner calculus has invariant with
   imaginary part 1/4, which is nonzero. (This uses the general 3D corner
   matrices defined below only for the witness; the planar theorem needs
   only the planar ones.)

## Conventions

- Pauli matrices sigmaX = !![0,1;1,0], sigmaY = !![0,-i;i,0],
  sigmaZ = !![1,0;0,-1] (standard).
- Planar corner: projP u v = (1/2)(1 + u sigmaX + v sigmaY), raw u v : R.
- 3D corner (witness only): proj3 a = (1/2)(1 + a.sigma) for a : Fin 3 -> R.
- The history product is the ordered list product
  (l.map (fun p => projP p.1 p.2)).prod, matching the corner-composition
  convention of the wave-1 packages.

## Intended reading (spiral layer)

In the null-edge corner calculus, T-odd / CP-odd phases are carried by
oriented volume (wave 1: the three-cycle imaginary part IS the triple
product). This file closes the loop at every order: a history whose
direction content stays in one plane composes inside a REAL subalgebra, so
its invariant can never acquire an orientation-odd imaginary part - zigzags
are CP-inert to all orders, and leaving the plane (spiraling) is NECESSARY
for any CP-odd phase in this calculus. M-grade finite identities once
proved; the continuum-CP reading is interpretation and is NOT claimed.

## Provenance

Clean-room from standard Pauli algebra: span_R{1, sX, sY, sX*sY} is closed
because sX*sY = i*sZ, sX*(sX*sY) = sY, (sX*sY)*sX = -sY,
(sX*sY)^2 = -1, etc., all with REAL coefficients; the trace of sX, sY,
and sX*sY vanish. Wave-1 parent-repo companions:
SpinCornerBargmannAristotle (three-cycle + planar CP-inert at n = 3),
HairpinLunePhaseAristotle (rational four-corner witnesses).

## Proof guidance

`realForm_mul`: destructure both membership witnesses, multiply out the
16 basis products using entrywise computation or algebraic identities
(sigmaX*sigmaX = 1, sigmaY*sigmaY = 1, sigmaX*sigmaY = -(sigmaY*sigmaX),
(sigmaX*sigmaY)*(sigmaX*sigmaY) = -1, sigmaX*(sigmaX*sigmaY) = sigmaY,
(sigmaX*sigmaY)*sigmaX = -sigmaY, sigmaY*(sigmaX*sigmaY) = -sigmaX,
(sigmaX*sigmaY)*sigmaY = sigmaX), and provide the new real coefficients
explicitly with ring. `planar_history_trace_real`: induction on the list
using realForm_one, realForm_projP, realForm_mul, then realForm_trace_im.
The witness is a finite 2x2 computation. Helper lemmas welcome; the
numbered statements must stay verbatim.

Do not weaken or modify any statement or definition; the placeholder proofs
are the only intended gaps.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PlanarCornerReality

open Matrix

/-- 2x2 complex matrices: the spin-coherent corner algebra. -/
abbrev SpinMat := Matrix (Fin 2) (Fin 2) ℂ

/-- Standard Pauli sigma_x. -/
def sigmaX : SpinMat := !![0, 1; 1, 0]

/-- Standard Pauli sigma_y. -/
def sigmaY : SpinMat := !![0, -Complex.I; Complex.I, 0]

/-- Standard Pauli sigma_z. -/
def sigmaZ : SpinMat := !![1, 0; 0, -1]

/-- The real subalgebra carrier: real spans of 1, sigmaX, sigmaY, and
sigmaX*sigmaY. -/
def RealForm (M : SpinMat) : Prop :=
  ∃ x y u v : ℝ,
    M = (x : ℂ) • (1 : SpinMat) + (y : ℂ) • (sigmaX * sigmaY)
      + (u : ℂ) • sigmaX + (v : ℂ) • sigmaY

/-- Planar spin-coherent corner matrix (1 + u sigmaX + v sigmaY)/2; raw
coefficients, no normalization. -/
def projP (u v : ℝ) : SpinMat :=
  (1 / 2 : ℂ) • ((1 : SpinMat) + (u : ℂ) • sigmaX + (v : ℂ) • sigmaY)

/-- 3D spin-coherent corner matrix, used only for the nonplanar witness. -/
def proj3 (a : Fin 3 → ℝ) : SpinMat :=
  (1 / 2 : ℂ) • ((1 : SpinMat) + (a 0 : ℂ) • sigmaX + (a 1 : ℂ) • sigmaY
    + (a 2 : ℂ) • sigmaZ)

/-- The identity lies in the real subalgebra. -/
theorem realForm_one : RealForm (1 : SpinMat) := by
  exact ⟨1, 0, 0, 0, by norm_num⟩

/-- The real span of {1, sigmaX, sigmaY, sigmaX*sigmaY} is closed under
multiplication. -/
theorem realForm_mul {M N : SpinMat} (hM : RealForm M) (hN : RealForm N) :
    RealForm (M * N) := by
  obtain ⟨x, y, u, v, rfl⟩ := hM
  obtain ⟨a, b, c, d, rfl⟩ := hN
  use x * a - y * b + u * c + v * d
  use x * b + y * a + u * d - v * c
  use x * c + y * d + u * a - v * b
  use x * d - y * c + u * b + v * a
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, sigmaX, sigmaY] <;> ring
  all_goals norm_num
  all_goals ring

/-- Every planar corner matrix lies in the real subalgebra. -/
theorem realForm_projP (u v : ℝ) : RealForm (projP u v) := by
  unfold projP
  exact ⟨1 / 2, 0, u / 2, v / 2, by
    ext i j
    fin_cases i <;> fin_cases j <;> norm_num <;> ring⟩

/-- Real-subalgebra matrices have real trace. -/
theorem realForm_trace_im {M : SpinMat} (hM : RealForm M) :
    (M.trace).im = 0 := by
  obtain ⟨x, y, u, v, rfl⟩ := hM
  norm_num [Matrix.trace, sigmaX, sigmaY]

private lemma planar_history_realForm (l : List (ℝ × ℝ)) :
    RealForm ((l.map (fun p => projP p.1 p.2)).prod) := by
  induction l with
  | nil => simpa using realForm_one
  | cons p l ih =>
      simpa using realForm_mul (realForm_projP p.1 p.2) ih

/-- **All-orders planar CP-inertness.** The ordered product of ANY finite
planar corner history has a real trace: zigzag (planar) direction content
cannot generate an orientation-odd phase at any order. -/
theorem planar_history_trace_real (l : List (ℝ × ℝ)) :
    (((l.map (fun p => projP p.1 p.2)).prod).trace).im = 0 := by
  exact realForm_trace_im (planar_history_realForm l)

/-- Nonplanar control: the handed triple x -> y -> z escapes - its
invariant has imaginary part 1/4. -/
theorem nonplanar_escape_witness :
    ((proj3 ![1, 0, 0] * proj3 ![0, 1, 0] * proj3 ![0, 0, 1]).trace).im
      = 1 / 4 := by
  unfold proj3
  norm_num [Matrix.trace, Matrix.mul_apply, sigmaX, sigmaY, sigmaZ]
  erw [Matrix.cons_val_succ']
  norm_num

/-- The escape is genuinely nonzero (the planar theorem is not vacuous as a
dichotomy). -/
theorem nonplanar_escape_ne_zero :
    ((proj3 ![1, 0, 0] * proj3 ![0, 1, 0] * proj3 ![0, 0, 1]).trace).im
      ≠ 0 := by
  rw [nonplanar_escape_witness]
  norm_num

end PhysicsSM.Draft.NullEdge.PlanarCornerReality

/-! ## Build-enforced assumption-footprint guards (added at integration) -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlanarCornerReality.realForm_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlanarCornerReality.realForm_one

/-- info: 'PhysicsSM.Draft.NullEdge.PlanarCornerReality.realForm_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlanarCornerReality.realForm_mul

/-- info: 'PhysicsSM.Draft.NullEdge.PlanarCornerReality.realForm_projP' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlanarCornerReality.realForm_projP

/-- info: 'PhysicsSM.Draft.NullEdge.PlanarCornerReality.realForm_trace_im' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlanarCornerReality.realForm_trace_im

/-- info: 'PhysicsSM.Draft.NullEdge.PlanarCornerReality.planar_history_trace_real' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlanarCornerReality.planar_history_trace_real

/-- info: 'PhysicsSM.Draft.NullEdge.PlanarCornerReality.nonplanar_escape_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlanarCornerReality.nonplanar_escape_witness

/-- info: 'PhysicsSM.Draft.NullEdge.PlanarCornerReality.nonplanar_escape_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlanarCornerReality.nonplanar_escape_ne_zero


end
