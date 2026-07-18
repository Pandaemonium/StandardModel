import Mathlib

/-!
# Spin-corner Bargmann calculus

This draft module gives the polynomial two-by-two Pauli calculus underlying
the proposed spiral refinement.  It proves the pair bend factor, the ordered
three-projector Bargmann invariant, orientation reversal by conjugation,
planar phase-inertness, antipodal annihilation for unit directions, the
two-channel corner sum, and explicit opposite-handed coordinate witnesses.

The matrix identities are exact.  Interpreting the Bargmann phase as a
physical microscopic spiral, or identifying that phase as the origin of a
mass eigenvalue, requires additional reconstruction not provided here.

## Conventions and provenance

Real directions use `Fin 3 -> Real`, the Pauli matrices are standard, and
`triple a b c` is the right-handed scalar triple product `a.(b x c)`.
Aristotle project `48ee063f-9478-4817-beae-1eb531c5f520` supplied the proof
bodies.  Every submitted signature was preserved and the result was checked
with the pinned Lean toolchain on 2026-07-14.
Standard-three axiom guards backfilled 2026-07-16 to match the wave-2
integration pattern.
Promoted from `PhysicsSM/Draft/NullEdge/SpinCornerBargmannAristotle.lean`
to the trusted tree on 2026-07-16 after: kernel-checked proofs with no
placeholders, standard-three axiom pins on all ten public theorems
(build-enforced below), integration-time semantic review, and
cross-family (codex) anchor confirmation of the registry rows citing
this module. Statement semantics unchanged; namespace renamed from the
draft path; downstream draft modules updated.
-/

noncomputable section

namespace PhysicsSM.Spinor.SpinCornerBargmann

open Matrix

/-- Two-by-two complex matrices for the spin-coherent corner algebra. -/
abbrev SpinMat := Matrix (Fin 2) (Fin 2) ℂ

/-- Raw real direction triples, with no normalization built in. -/
abbrev Vec3 := Fin 3 → ℝ

/-- Standard Pauli `sigma_x`. -/
def sigmaX : SpinMat := !![0, 1; 1, 0]

/-- Standard Pauli `sigma_y`. -/
def sigmaY : SpinMat := !![0, -Complex.I; Complex.I, 0]

/-- Standard Pauli `sigma_z`. -/
def sigmaZ : SpinMat := !![1, 0; 0, -1]

/-- Pauli contraction `a.sigma`. -/
def pauli (a : Vec3) : SpinMat :=
  (a 0 : ℂ) • sigmaX + (a 1 : ℂ) • sigmaY + (a 2 : ℂ) • sigmaZ

/-- Spin-coherent corner matrix `(1 + a.sigma)/2`. -/
def proj (a : Vec3) : SpinMat := (1 / 2 : ℂ) • (1 + pauli a)

/-- Euclidean dot product of raw direction triples. -/
def dot (a b : Vec3) : ℝ := a 0 * b 0 + a 1 * b 1 + a 2 * b 2

/-- Right-handed oriented scalar triple product `a.(b x c)`. -/
def triple (a b c : Vec3) : ℝ :=
  a 0 * (b 1 * c 2 - b 2 * c 1) + a 1 * (b 2 * c 0 - b 0 * c 2)
    + a 2 * (b 0 * c 1 - b 1 * c 0)

/-- Pauli-vector square, polynomial in the direction components. -/
theorem pauli_sq (a : Vec3) :
    pauli a * pauli a = ((dot a a : ℝ) : ℂ) • (1 : SpinMat) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
      simp +decide [Matrix.mul_apply] <;> ring
  · unfold pauli dot
    norm_num [sigmaX, sigmaY, sigmaZ]
    ring
    norm_num
    ring
  · unfold pauli
    norm_num [sigmaX, sigmaY, sigmaZ]
    ring
  · unfold pauli
    simp +decide [sigmaX, sigmaY, sigmaZ]
  · unfold pauli
    norm_num [dot]
    ring
    unfold sigmaX sigmaY sigmaZ
    norm_num
    ring
    norm_num

/-- Pair trace, or parity-even free-bend factor. -/
theorem pair_trace (a b : Vec3) :
    (proj a * proj b).trace = ((1 + dot a b : ℝ) : ℂ) / 2 := by
  unfold proj dot
  norm_num [Matrix.trace, Matrix.mul_apply, pauli, sigmaX, sigmaY, sigmaZ]
  ring
  norm_num

/-- Ordered three-projector Bargmann invariant. -/
theorem bargmann_three_cycle (a b c : Vec3) :
    (proj a * proj b * proj c).trace =
      (((1 + dot a b + dot b c + dot c a : ℝ) : ℂ)
          + Complex.I * ((triple a b c : ℝ) : ℂ)) / 4 := by
  unfold proj
  unfold pauli
  simp +decide [Matrix.trace_fin_two, Matrix.mul_apply]
  unfold sigmaX sigmaY sigmaZ dot triple
  norm_num [Complex.ext_iff]
  ring
  norm_num

/-- The imaginary Bargmann component is one quarter of the orientation. -/
theorem bargmann_im (a b c : Vec3) :
    ((proj a * proj b * proj c).trace).im = triple a b c / 4 := by
  rw [bargmann_three_cycle]
  norm_num [div_eq_mul_inv]

/-- Coplanar direction triples have real Bargmann invariant. -/
theorem planar_cp_inert (a b c : Vec3) (h : triple a b c = 0) :
    ((proj a * proj b * proj c).trace).im = 0 := by
  rw [bargmann_im, h, zero_div]

/-- Orientation reversal conjugates the Bargmann invariant. -/
theorem reversal_conj (a b c : Vec3) :
    (proj c * proj b * proj a).trace =
      star ((proj a * proj b * proj c).trace) := by
  convert bargmann_three_cycle c b a using 1
  convert congr_arg Star.star (bargmann_three_cycle a b c) using 1 <;>
    norm_num [Complex.ext_iff] <;> ring
  unfold dot triple
  ring
  aesop

/-- Unit antipodal corner matrices annihilate. -/
theorem antipodal_annihilation (a : Vec3) (h : dot a a = 1) :
    proj a * proj (-a) = 0 := by
  unfold proj
  have h_pauli_neg : pauli (-a) = -pauli a := by
    unfold pauli
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [sigmaX, sigmaY, sigmaZ] <;> ring
  simp_all +decide [Matrix.mul_add, add_mul, smul_smul]
  rw [pauli_sq]
  norm_num [h]
  abel_nf

/-- Same and flipped corner-channel traces sum to one. -/
theorem corner_channel_sum (a b : Vec3) :
    (proj a * proj b).trace + (proj a * proj (-b)).trace = 1 := by
  rw [pair_trace, pair_trace]
  norm_num
  ring
  unfold dot
  norm_num
  ring

/-- Unit coordinate direction `x`. -/
def ex : Vec3 := ![1, 0, 0]

/-- Unit coordinate direction `y`. -/
def ey : Vec3 := ![0, 1, 0]

/-- Unit coordinate direction `z`. -/
def ez : Vec3 := ![0, 0, 1]

/-- The ordered coordinate triple has Bargmann value `(1 + i)/4`. -/
theorem witness_handed :
    (proj ex * proj ey * proj ez).trace = (1 + Complex.I) / 4 := by
  convert bargmann_three_cycle ex ey ez using 1
  unfold ex ey ez dot triple
  norm_num [Complex.ext_iff]
  aesop

/-- The reversed coordinate triple has Bargmann value `(1 - i)/4`. -/
theorem witness_mirror :
    (proj ez * proj ey * proj ex).trace = (1 - Complex.I) / 4 := by
  convert reversal_conj _ _ _ using 1
  rw [witness_handed]
  norm_num [Complex.ext_iff]

end PhysicsSM.Spinor.SpinCornerBargmann

/-! ## Build-enforced assumption-footprint guards (backfilled 2026-07-16) -/

/-- info: 'PhysicsSM.Spinor.SpinCornerBargmann.pauli_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Spinor.SpinCornerBargmann.pauli_sq

/-- info: 'PhysicsSM.Spinor.SpinCornerBargmann.pair_trace' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Spinor.SpinCornerBargmann.pair_trace

/-- info: 'PhysicsSM.Spinor.SpinCornerBargmann.bargmann_three_cycle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Spinor.SpinCornerBargmann.bargmann_three_cycle

/-- info: 'PhysicsSM.Spinor.SpinCornerBargmann.bargmann_im' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Spinor.SpinCornerBargmann.bargmann_im

/-- info: 'PhysicsSM.Spinor.SpinCornerBargmann.planar_cp_inert' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Spinor.SpinCornerBargmann.planar_cp_inert

/-- info: 'PhysicsSM.Spinor.SpinCornerBargmann.reversal_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Spinor.SpinCornerBargmann.reversal_conj

/-- info: 'PhysicsSM.Spinor.SpinCornerBargmann.antipodal_annihilation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Spinor.SpinCornerBargmann.antipodal_annihilation

/-- info: 'PhysicsSM.Spinor.SpinCornerBargmann.corner_channel_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Spinor.SpinCornerBargmann.corner_channel_sum

/-- info: 'PhysicsSM.Spinor.SpinCornerBargmann.witness_handed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Spinor.SpinCornerBargmann.witness_handed

/-- info: 'PhysicsSM.Spinor.SpinCornerBargmann.witness_mirror' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Spinor.SpinCornerBargmann.witness_mirror

end
