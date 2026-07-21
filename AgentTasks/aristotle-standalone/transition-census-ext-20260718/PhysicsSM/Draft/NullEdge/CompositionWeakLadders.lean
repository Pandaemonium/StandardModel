import PhysicsSM.Draft.NullEdge.DixonWeakCARTau3

/-!
# The weak sector as COMPOSITION operators (the faithful eq-29/31 realization)

**Status: DRAFT probe module for the item-2 endgame.**

**STRUCTURE THEOREM (2026-07-18, see `CompositionSuSdBridge`):** the nests
defined here are RANK-ONE operators - `hatOmega z = phi(z) . vIdemStar`,
`hatOmegaDag z = psi(z) . vIdem` for explicit head-plane functionals - and
coincide GLOBALLY with the right-tower nests (`hatOmega = hatOmegaRbDag`,
`hatOmegaDag = hatOmegaRb`, `hatTau3 = -hatTau3R`). Every theorem below
remains true; the su(2)/CAR layer built on these operators is exactly a
head-plane (2-complex-dimensional) theory.

`DixonWeakCARTau3` proved the element dictionary is anti-Fock (`tau_3 = 0`
identically at element level), forcing Furey's reading: the Cl(6)/Cl(2) ladder
algebra is the algebra of COMPOSITION operators - nested left multiplications,
which compose ASSOCIATIVELY - exactly her "the left action of C(x)O on itself
gives a faithful representation of Cl(6)" (1806.00612 sec 4.2).

This module defines the composition operators

  `hatOmega  z = a_1 (a_2 (a_3 z))`,   `hatOmegaDag z = a_3‡ (a_2‡ (a_1‡ z))`,
  `hatTau3   z = hatOmega (hatOmegaDag z) - hatOmegaDag (hatOmega z)`,

and kernel-checks the OPERATOR Fock dictionary. Structure of the expected
results (abstract Fock computation, mode `omega-hat = |000><111|`):

* GLOBAL free-variable identities (hold on ALL of `C(x)O`):
  `hatOmega^2 = 0`, `hatOmegaDag^2 = 0`, `{hatTau3, hatOmega} = 0`,
  `{hatTau3, hatOmegaDag} = 0`. These four make the eq-31 like- and
  cross-CARs `{beta_1,beta_2} = {beta_1,beta_2‡} = 0` GLOBAL operator
  identities (the `H`-unit parts cancel by `{i_1,i_2} = 0`, landed in
  `DixonAlgebra`).
* IDEAL-RESTRICTED: `hatTau3^2 = P_000 + P_111` is the identity only on the
  omega-mode plane `span{v, nu}` - the idempotent `v` and the full state
  `nu = hatOmega v` (kernel lesson: NOT the conjugate idempotent `v*`, on
  which `hatTau3^2` genuinely fails - refuted first guess). That plane is
  exactly where eq 32 builds the leptonic ideal, so the diagonal
  `{beta_i, beta_i‡} = 1` holds ON the ideal, not globally - matching Furey's
  `L = v_w Cl(4)` construction.

Convention: XOR octonions, repo `alpha_i`; nesting is right-to-left
application (`a_1 (a_2 (a_3 z))`), the operator-composition order of
`L_{a_1} o L_{a_2} o L_{a_3}`; the dagger reverses the composition order.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionWeakLadders

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem vIdemStar)

set_option maxRecDepth 20000
set_option maxHeartbeats 64000000

/-- The colour ladder as a composition operator:
`hatOmega z = a_1 (a_2 (a_3 z))`. -/
def hatOmega (z : ComplexOctonion) : ComplexOctonion :=
  alpha1 * (alpha2 * (alpha3 * z))

/-- The daggered ladder (composition order reversed):
`hatOmegaDag z = a_3‡ (a_2‡ (a_1‡ z))`. -/
def hatOmegaDag (z : ComplexOctonion) : ComplexOctonion :=
  alpha3_dag * (alpha2_dag * (alpha1_dag * z))

/-- The isospin generator `tau_3` as an operator:
`hatTau3 = hatOmega hatOmegaDag - hatOmegaDag hatOmega` (eq 29). -/
def hatTau3 (z : ComplexOctonion) : ComplexOctonion :=
  hatOmega (hatOmegaDag z) + (-(hatOmegaDag (hatOmega z)))

/-- **Operator Fock 1 (global):** `hatOmega^2 = 0` on all of `C(x)O` - the
composition operator IS nilpotent (the element `omega^2 = -v` is not; the
kernel separates the two semantics). -/
theorem hatOmega_sq_zero (z : ComplexOctonion) : hatOmega (hatOmega z) = 0 := by
  unfold hatOmega
  ext <;>
    simp [alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- **Operator Fock 2 (global):** `hatOmegaDag^2 = 0`. -/
theorem hatOmegaDag_sq_zero (z : ComplexOctonion) :
    hatOmegaDag (hatOmegaDag z) = 0 := by
  unfold hatOmegaDag
  ext <;>
    simp [alpha1_dag, alpha2_dag, alpha3_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- **Operator Fock 3 (global):** `{hatTau3, hatOmegaDag} = 0` - the colour
core of the eq-31 cross-CAR `{beta_1, beta_2} = 0`. -/
theorem tau3_omegaDag_anticomm_zero (z : ComplexOctonion) :
    hatTau3 (hatOmegaDag z) + hatOmegaDag (hatTau3 z) = 0 := by
  unfold hatTau3 hatOmega hatOmegaDag
  ext <;>
    simp [alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- **Operator Fock 4 (global):** `{hatTau3, hatOmega} = 0` - the colour core
of the eq-31 cross-CAR `{beta_1, beta_2‡} = 0`. -/
theorem tau3_omega_anticomm_zero (z : ComplexOctonion) :
    hatTau3 (hatOmega z) + hatOmega (hatTau3 z) = 0 := by
  unfold hatTau3 hatOmega hatOmegaDag
  ext <;>
    simp [alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- **Ideal-restricted Fock 5 (kernel):** `hatTau3^2` is the identity on the
idempotent line: `hatTau3 (hatTau3 v) = v` - one leg of the omega-mode plane
where the diagonal CAR `{beta_1, beta_1‡} = 1` lives. -/
theorem tau3_sq_on_vIdem : hatTau3 (hatTau3 vIdem) = vIdem := by
  unfold hatTau3 hatOmega hatOmegaDag
  ext <;>
    simp [vIdem, alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- **Nonvacuity witness + grading (kernel):** `hatTau3 v = -v` - the
idempotent is the LOWER mode-plane leg (`hatOmegaDag` annihilates it, so
`P_0 v = 0`, `P_1 v = v`, `tau_3 v = -v`). Contrast the element collapse
`tau3 = 0` (`DixonWeakCARTau3.tau3_eq_zero`). NOTE: an earlier draft recorded
`+v` from a truncated build log; the kernel value is `-v`. -/
theorem hatTau3_on_vIdem : hatTau3 vIdem = -vIdem := by
  unfold hatTau3 hatOmega hatOmegaDag
  ext <;>
    simp [vIdem, alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- The full (`|111>`-type) state over the idempotent: `nu = a_1(a_2(a_3 v)) =
hatOmega v` (nested application form, matching `MinimalLeftIdeal.nu_eq`). NOTE
(kernel lessons): the second mode-plane leg is THIS state - it is NOT the
conjugate idempotent `v* = (1 + i e_111)/2`, on which `hatTau3^2` genuinely
fails to be the identity (kernel-refuted first guess). -/
def nuState : ComplexOctonion := alpha1 * (alpha2 * (alpha3 * vIdem))

/-- `nuState` is `hatOmega` applied to the idempotent (definitional). -/
theorem nuState_eq_hatOmega_vIdem : nuState = hatOmega vIdem := rfl

/-- `hatTau3` respects negation (shallow kernel; needed for the algebraic
mode-plane proofs). -/
theorem hatTau3_neg' (x : ComplexOctonion) : hatTau3 (-x) = -hatTau3 x := by
  unfold hatTau3 hatOmega hatOmegaDag
  ext <;>
    simp [alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- `hatOmega` respects negation (shallow kernel; for the algebraic
mode-plane proofs). -/
theorem hatOmega_neg' (x : ComplexOctonion) : hatOmega (-x) = -hatOmega x := by
  unfold hatOmega
  ext <;>
    simp [alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- **`hatTau3` grades the mode plane:** `hatTau3 nu = +nu` (the upper leg;
with `hatTau3 v = -v` the plane carries the full `+-1` grading - on the basis
`(v, nu)` the operators `hatTau1, hatTau2, hatTau3` are literally the Pauli
matrices `sigma_1, sigma_2, -sigma_3`). Proof is PURELY ALGEBRAIC from the
landed global core `{hatTau3, hatOmega} = 0` at `v` - no coordinate expansion
(the depth-13 brute-force route defeats `ring` even on true statements). -/
theorem hatTau3_on_nuState : hatTau3 nuState = nuState := by
  have h := tau3_omega_anticomm_zero vIdem
  rw [hatTau3_on_vIdem, hatOmega_neg'] at h
  rw [nuState_eq_hatOmega_vIdem]
  have h2 : hatTau3 (hatOmega vIdem) - hatOmega vIdem = 0 := by
    simpa [sub_eq_add_neg] using h
  exact sub_eq_zero.mp h2

/-- **Ideal-restricted Fock 6:** `hatTau3 (hatTau3 nu) = nu` - immediate from
the grading. -/
theorem tau3_sq_on_nuState : hatTau3 (hatTau3 nuState) = nuState := by
  rw [hatTau3_on_nuState, hatTau3_on_nuState]


end PhysicsSM.Draft.NullEdge.CompositionWeakLadders

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionWeakLadders.hatOmega_sq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionWeakLadders.hatOmega_sq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionWeakLadders.tau3_omegaDag_anticomm_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionWeakLadders.tau3_omegaDag_anticomm_zero

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionWeakLadders.hatTau3_on_vIdem' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionWeakLadders.hatTau3_on_vIdem
