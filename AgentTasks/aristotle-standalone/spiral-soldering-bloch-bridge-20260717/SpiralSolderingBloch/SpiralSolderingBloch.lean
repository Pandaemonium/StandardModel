import Mathlib

/-!
# Spiral corner projector = soldered null edge (Bloch/celestial bridge)

Standalone Aristotle package (Mathlib-only). Null-edge foundations, 2026-07-17.
Proves that the spiral-layer spin-coherent corner projector `proj a =
(1 + a.sigma)/2` and the null-edge soldering `psi psi-dagger` are the SAME
rank-one projector for a UNIT spinor, with `a` the Bloch/celestial direction.
Consequently the spiral corner calculus is the calculus of null-edge DIRECTIONS
on the celestial sphere. Numerically verified; the Lean proof is entrywise
complex re/im reconstruction. Clean-room (standard Bloch-sphere fact).

Definitions mirror `PhysicsSM.Spinor.SpinCornerBargmann` (proj/pauli) and
`NullEdgeSpinorSoldering` (rankOne); on landing this ports to a repo bridge.

## Proof guidance

`ext i j; fin_cases i <;> fin_cases j`, then `simp` with the definitions and
`Complex.ext_iff`, `Complex.normSq_apply`, `Complex.mul_re/mul_im`,
`Complex.conj_re/conj_im`. The DIAGONAL entries need the unit hypothesis
`normSq (psi 0) + normSq (psi 1) = 1` (rewrite it into `.re^2 + .im^2` form via
`normSq_apply` so `linarith`/`nlinarith` can use it); the OFF-DIAGONAL entries
are the reconstruction `z = z.re + z.im * I` and close by `ring` after
`Complex.ext_iff`. Split the tactic per case (`first | ring | nlinarith [...]`)
rather than one uniform closer. Do not weaken the statement; no `native_decide`.
-/

noncomputable section

namespace SpiralSolderingBloch

open Matrix Complex

abbrev Spinor := Fin 2 → ℂ
abbrev Vec3 := Fin 3 → ℝ

def sigmaX : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]
def sigmaY : Matrix (Fin 2) (Fin 2) ℂ := !![0, -Complex.I; Complex.I, 0]
def sigmaZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- Spiral Pauli contraction `a.sigma`. -/
def pauli (a : Vec3) : Matrix (Fin 2) (Fin 2) ℂ :=
  (a 0 : ℂ) • sigmaX + (a 1 : ℂ) • sigmaY + (a 2 : ℂ) • sigmaZ

/-- Spiral spin-coherent corner projector `(1 + a.sigma)/2`. -/
def proj (a : Vec3) : Matrix (Fin 2) (Fin 2) ℂ := (1 / 2 : ℂ) • (1 + pauli a)

/-- Null-edge soldering rank-one Hermitian `psi psi-dagger`. -/
def rankOne (psi : Spinor) : Matrix (Fin 2) (Fin 2) ℂ :=
  fun i j => psi i * (starRingEnd ℂ) (psi j)

/-- Bloch (celestial-sphere) direction of a null edge. -/
def bloch (psi : Spinor) : Vec3 :=
  ![2 * (psi 0 * (starRingEnd ℂ) (psi 1)).re,
    -2 * (psi 0 * (starRingEnd ℂ) (psi 1)).im,
    Complex.normSq (psi 0) - Complex.normSq (psi 1)]

/-- **The spiral corner projector IS the soldered null edge.** For a unit null
edge, `psi psi-dagger` equals the spiral projector at the Bloch direction. -/
theorem rankOne_eq_proj_bloch (psi : Spinor)
    (h : Complex.normSq (psi 0) + Complex.normSq (psi 1) = 1) :
    rankOne psi = proj (bloch psi) := by
  ext i j; fin_cases i <;> fin_cases j <;> simp_all +decide [ rankOne, proj, bloch, pauli, sigmaX, sigmaY, sigmaZ, Complex.normSq_apply, Complex.mul_re, Complex.mul_im, Complex.conj_re, Complex.conj_im ] ; ring_nf at *;
  · norm_num [ Complex.ext_iff, sq ] at * ; constructor <;> linarith;
  · simp +decide [ Complex.ext_iff, mul_two, two_mul ] ; ring;
    norm_num;
  · norm_num [ Complex.ext_iff ] ; ring;
    norm_num;
  · norm_num [ Complex.ext_iff ] at * ; constructor <;> linarith!;

/-- Nonvacuity: the `+z` unit edge `(1,0)` solders to `proj (0,0,1)`. -/
theorem bloch_z_witness :
    rankOne ![1, 0] = proj ![0, 0, 1] := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ rankOne, proj, pauli, sigmaX, sigmaY, sigmaZ ] ;
  · erw [ Matrix.cons_val_succ' ] ; norm_num;
  · erw [ Matrix.cons_val_succ' ] ; norm_num

end SpiralSolderingBloch

end
