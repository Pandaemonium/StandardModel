import PhysicsSM.Draft.NullEdge.DixonWeakCARTau3
import Mathlib

/-!
# The RIGHT-action weak ladder tower (the quark-isospin half)

**Status: DRAFT probe module.** Per the paper (1806.00612 p. 8, sec 5.1) the
isospin `Cl(2)` on `Su + Sd` is the RIGHT action of the omega-mode; the landed
LEFT-composition tower (`CompositionWeakLadders`) grades the leptonic plane
but ANNIHILATES the colour triplet states, so the Jbar `T_+ = TPlusEnd`
closure (quark `d_i -> u_i` transitions = `Su <-> Sd` moves) needs this
mirror. Design note: S2b CORRECTION 7 refinement.

Two candidate composition orders for the right ladder (the nesting order is
KERNEL-PROBED, not assumed - the left tower's lesson):

  (a) `hatOmegaRa z = ((z * a_1) * a_2) * a_3`   (apply `a_1` first)
  (b) `hatOmegaRb z = ((z * a_3) * a_2) * a_1`   (apply `a_3` first)

The discriminating probes: operator nilpotency (`hatOmegaR^2 = 0` as a global
free-variable identity) and the mode action on the idempotent literals. The
surviving candidate gets the full Fock-core treatment (mirror of the landed
left tower).

**STRUCTURE THEOREM (2026-07-18, see `CompositionSuSdBridge`):** the surviving
candidate (b) nests are RANK-ONE and coincide GLOBALLY with the left tower
(`hatOmegaRbDag = hatOmega`, `hatOmegaRb = hatOmegaDag`,
`hatTau3R = -hatTau3`) - the "mirror" is literally the same operator pair,
and the `Su <-> Sd` isospin it carries is confined to the idempotent plane.
`TPlusEnd` realization via these nests is impossible on any packaging (rank
one vs three independent images); the quark-doublet route goes through the
colour-supported eq-37 `B_j` operators instead (`CompositionCl10Probe`).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionWeakLaddersRight

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem vIdemStar)

set_option maxHeartbeats 64000000
set_option maxRecDepth 20000

/-- Candidate (a): right ladder applying `a_1` first. -/
def hatOmegaRa (z : ComplexOctonion) : ComplexOctonion :=
  ((z * alpha1) * alpha2) * alpha3

/-- Candidate (b): right ladder applying `a_3` first. -/
def hatOmegaRb (z : ComplexOctonion) : ComplexOctonion :=
  ((z * alpha3) * alpha2) * alpha1

/-- Daggered candidate (a) (order-reversed, daggered units). -/
def hatOmegaRaDag (z : ComplexOctonion) : ComplexOctonion :=
  ((z * alpha3_dag) * alpha2_dag) * alpha1_dag

/-- Daggered candidate (b). -/
def hatOmegaRbDag (z : ComplexOctonion) : ComplexOctonion :=
  ((z * alpha1_dag) * alpha2_dag) * alpha3_dag

/-- **Probe: candidate (a) nilpotency** (global). -/
theorem hatOmegaRa_sq_zero (z : ComplexOctonion) :
    hatOmegaRa (hatOmegaRa z) = 0 := by
  unfold hatOmegaRa
  ext <;>
    simp [alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- **Probe: candidate (b) nilpotency** (global). -/
theorem hatOmegaRb_sq_zero (z : ComplexOctonion) :
    hatOmegaRb (hatOmegaRb z) = 0 := by
  unfold hatOmegaRb
  ext <;>
    simp [alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-! ## Mode-action atoms (kernel-corrected values)

KERNEL DISCRIMINATION RESULT: both orderings are nilpotent AND both daggers
annihilate `v*` while mapping `v -> -+ i v*` (phases differ) - so the RIGHT
action's mode plane is **`span{v, v*}` - the two idempotents themselves**,
matching the paper's "transitions on the space of idempotents" (`Su <-> Sd` =
the quark doublet). CANDIDATE (b) is SELECTED (its dagger applies `a_1‡`
first, mirroring the left tower's dagger convention); phase `+i`. -/

/-- **Atom (kernel):** candidate (a)'s dagger maps `v` to `-i v*` (recorded
for the ordering comparison; (a) is not the selected candidate). -/
theorem RaDag_on_vIdem : hatOmegaRaDag vIdem = -(Complex.I • vIdemStar) := by
  unfold hatOmegaRaDag
  ext <;>
    simp [PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
      PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdemStar, alpha1_dag,
      alpha2_dag, alpha3_dag, ComplexOctonion.mul_re, ComplexOctonion.mul_im,
      ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;>
    ring

/-- **Atom (kernel, SELECTED candidate):** `hatOmegaRbDag v = +i v*` - the
isospin lowering `Su -> Sd` move with phase `+i`. -/
theorem RbDag_on_vIdem : hatOmegaRbDag vIdem = Complex.I • vIdemStar := by
  unfold hatOmegaRbDag
  ext <;>
    simp [PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
      PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdemStar, alpha1_dag,
      alpha2_dag, alpha3_dag, ComplexOctonion.mul_re, ComplexOctonion.mul_im,
      ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;>
    ring

/-- **Atom (kernel):** candidate (a)'s dagger annihilates `v*`. -/
theorem RaDag_on_vIdemStar : hatOmegaRaDag vIdemStar = 0 := by
  unfold hatOmegaRaDag
  ext <;>
    simp [PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdemStar, alpha1_dag,
      alpha2_dag, alpha3_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- **Atom (kernel, SELECTED):** `hatOmegaRbDag v* = 0` - `v*` is the
right-action vacuum (`Sd` bottom). -/
theorem RbDag_on_vIdemStar : hatOmegaRbDag vIdemStar = 0 := by
  unfold hatOmegaRbDag
  ext <;>
    simp [PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdemStar, alpha1_dag,
      alpha2_dag, alpha3_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- **Atom (kernel):** the selected raising `hatOmegaRb v*` (expected
`-+ i v` mirror; kernel pins the phase). -/
theorem Rb_on_vIdemStar : hatOmegaRb vIdemStar = -(Complex.I • vIdem) := by
  unfold hatOmegaRb
  ext <;>
    simp [PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
      PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdemStar, alpha1, alpha2,
      alpha3, ComplexOctonion.mul_re, ComplexOctonion.mul_im,
      ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;>
    ring

/-- **Atom (kernel):** `hatOmegaRb v = 0` - `v` is the right-action top
(`Su` top). -/
theorem Rb_on_vIdem : hatOmegaRb vIdem = 0 := by
  unfold hatOmegaRb
  ext <;>
    simp [PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, alpha1, alpha2,
      alpha3, ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-! ## The right `tau_3` and the idempotent-plane grading (algebraic) -/

/-- The right-action isospin generator
`tau_3R = hatOmegaRb o hatOmegaRbDag - hatOmegaRbDag o hatOmegaRb`. -/
def hatTau3R (z : ComplexOctonion) : ComplexOctonion :=
  hatOmegaRb (hatOmegaRbDag z) + (-(hatOmegaRbDag (hatOmegaRb z)))

set_option maxHeartbeats 16000000 in
/-- General `C`-bilinearity of the `C(x)O` product in the left slot (free
variables - no literals, so no fragile constant-driven simp splits). -/
private theorem co_smul_mul (c : ℂ) (z w : ComplexOctonion) :
    (c • z) * w = c • (z * w) := by
  ext <;>
    simp [ComplexOctonion.mul_re, ComplexOctonion.mul_im,
      ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;>
    ring

/-- `hatOmegaRb` respects `C`-scalars (algebraic from bilinearity). -/
theorem hatOmegaRb_smul (c : ℂ) (z : ComplexOctonion) :
    hatOmegaRb (c • z) = c • hatOmegaRb z := by
  unfold hatOmegaRb
  rw [co_smul_mul, co_smul_mul, co_smul_mul]

/-- `hatOmegaRbDag` respects `C`-scalars (algebraic from bilinearity). -/
theorem hatOmegaRbDag_smul (c : ℂ) (z : ComplexOctonion) :
    hatOmegaRbDag (c • z) = c • hatOmegaRbDag z := by
  unfold hatOmegaRbDag
  rw [co_smul_mul, co_smul_mul, co_smul_mul]

set_option maxHeartbeats 8000000 in
/-- `hatOmegaRb 0 = 0`. -/theorem hatOmegaRb_zero : hatOmegaRb 0 = 0 := by
  unfold hatOmegaRb
  ext <;>
    simp [alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im]

set_option maxHeartbeats 8000000 in
/-- `hatOmegaRbDag 0 = 0`. -/theorem hatOmegaRbDag_zero : hatOmegaRbDag 0 = 0 := by
  unfold hatOmegaRbDag
  ext <;>
    simp [alpha1_dag, alpha2_dag, alpha3_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im]

/-- **`tau_3R` grades the idempotent plane: `tau_3R v = v`** (algebraic from
the atoms: `RbDag v = i v*`, `Rb (i v*) = i(-i v) = v`, `Rb v = 0`). -/
theorem hatTau3R_on_vIdem : hatTau3R vIdem = vIdem := by
  unfold hatTau3R
  rw [RbDag_on_vIdem, hatOmegaRb_smul, Rb_on_vIdemStar, Rb_on_vIdem,
    hatOmegaRbDag_zero]
  match_scalars <;> (ring_nf; try simp [Complex.I_sq])

/-- **`tau_3R v* = -v*`** (algebraic: `Rb v* = -i v`, `RbDag (-i v) = -i(i v*)
= v*`, sign from the difference). -/
theorem hatTau3R_on_vIdemStar : hatTau3R vIdemStar = -vIdemStar := by
  unfold hatTau3R
  rw [RbDag_on_vIdemStar, hatOmegaRb_zero, Rb_on_vIdemStar]
  rw [show hatOmegaRbDag (-(Complex.I • vIdem)) =
      -(Complex.I • hatOmegaRbDag vIdem) from by
    rw [show (-(Complex.I • vIdem)) = ((-Complex.I : ℂ) • vIdem) from by
          match_scalars <;> ring,
      hatOmegaRbDag_smul]
    match_scalars <;> ring]
  rw [RbDag_on_vIdem]
  match_scalars <;> (ring_nf; try simp [Complex.I_sq])

end PhysicsSM.Draft.NullEdge.CompositionWeakLaddersRight

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionWeakLaddersRight.RbDag_on_vIdem' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionWeakLaddersRight.RbDag_on_vIdem

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionWeakLaddersRight.hatOmegaRb_sq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionWeakLaddersRight.hatOmegaRb_sq_zero
