import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# The Higgs mechanism is exact degree-of-freedom conservation

This file formalizes the *degree-of-freedom (dof) bookkeeping* of the Higgs mechanism as a
finite counting identity. The physical statement being counted:

* **Before** symmetry breaking: a massless gauge boson (2 transverse polarizations) together with
  a complex scalar (2 real dof).
* **After** symmetry breaking: a massive gauge boson (3 polarizations — the extra *longitudinal*
  one being the eaten would-be-Goldstone) together with 1 physical Higgs scalar.

The count is conserved: `2 + 2 = 3 + 1 = 4`. The longitudinal mode of the massive vector *is* the
Goldstone dof, transferred. We prove the abelian case, the "longitudinal = Goldstone" identity, and
the general `n`-broken-generator identity `2*n + s = 3*n + (s - n)` for `n ≤ s`.

**Honest scope.** This is a finite dof-*counting* identity (the bookkeeping of the mechanism), NOT a
dynamical derivation of the vacuum expectation value or of the masses themselves.
-/

namespace HiggsDofConservation

/-- Polarizations of a vector boson: a massive vector has `3` (two transverse + one longitudinal),
a massless vector has only `2` (transverse). -/
def polV (massive : Bool) : Nat := if massive then 3 else 2

/-- Real degrees of freedom of a complex scalar field. -/
def complexScalarDof : Nat := 2

/-- Goldstone degrees of freedom eaten per broken generator. -/
def goldstoneEaten : Nat := 1

/-- The single physical Higgs scalar remaining after breaking (abelian case). -/
def physicalHiggs : Nat := 1

/-- Total dof before symmetry breaking (abelian): massless gauge boson + complex scalar. -/
def dofBefore : Nat := polV false + complexScalarDof

/-- Total dof after symmetry breaking (abelian): massive gauge boson + physical Higgs. -/
def dofAfter : Nat := polV true + physicalHiggs

/-! ## General infrastructure: `n`-broken-generator dof counting

For `n` broken generators and a scalar sector of `s` real dof:

* before: `n` massless gauge bosons (`2*n`) + scalar sector (`s`), total `2*n + s`;
* after: `n` massive gauge bosons (`3*n`) + `s - n` physical scalars, total `3*n + (s - n)`.
-/

/-- Total dof before breaking with `n` broken generators and scalar sector of `s` real dof. -/
def dofBeforeGen (n s : Nat) : Nat := 2 * n + s

/-- Total dof after breaking: `n` massive gauge bosons plus the physical scalars `s - n` that
remain once `n` Goldstones are eaten. -/
def dofAfterGen (n s : Nat) : Nat := 3 * n + (s - n)

/-- **General dof conservation.** For `n ≤ s` broken generators the dof count is conserved, and
equals `2*n + s` both before and after. The hypothesis `n ≤ s` is essential (Nat subtraction):
one cannot eat more Goldstones than the scalar sector supplies. This is Target 3. -/
theorem dof_conserved_general (n s : Nat) (h : n ≤ s) :
    dofBeforeGen n s = dofAfterGen n s ∧ dofBeforeGen n s = 2 * n + s := by
  unfold dofBeforeGen dofAfterGen
  omega

/-! ## Target 1: abelian dof conservation -/

/-- **Abelian Higgs dof conservation.** `dofBefore = dofAfter`, i.e. `2 + 2 = 3 + 1 = 4`.
This is exactly the `n = 1, s = 2` instance of `dof_conserved_general` (both `dofBefore` and
`dofBeforeGen 1 2` compute to `4`, and likewise after). -/
theorem dof_conserved_abelian : dofBefore = dofAfter :=
  (dof_conserved_general 1 2 (by omega)).1

/-- Non-degeneracy witness for the abelian count: the common value is genuinely `4`. -/
theorem dof_conserved_abelian_value : dofBefore = 4 ∧ dofAfter = 4 := by
  decide

/-! ## Target 2: the longitudinal mode is exactly the eaten Goldstone -/

/-- **Longitudinal = Goldstone.** The extra polarization gained by the vector when it becomes
massive equals the Goldstone dof eaten: `polV true - polV false = 1 = goldstoneEaten`. -/
theorem goldstone_is_longitudinal :
    polV true - polV false = 1 ∧ polV true - polV false = goldstoneEaten := by
  rw [show polV true = 3 from rfl, show polV false = 2 from rfl, show goldstoneEaten = 1 from rfl]
  omega

/-! ## Target 3: non-degeneracy witnesses and control for the general identity -/

/-- Non-degeneracy witness (abelian, `n = 1, s = 2`): recovers `2 + 2 = 3 + 1 = 4`. -/
theorem dof_conserved_general_abelian_witness :
    dofBeforeGen 1 2 = 4 ∧ dofAfterGen 1 2 = 4 := by
  decide

/-- Non-degeneracy witness (non-abelian, `n = 3, s = 4`, e.g. SU(2)): before `2*3+4 = 10`,
after `3*3+(4-3) = 10`. -/
theorem dof_conserved_general_su2_witness :
    dofBeforeGen 3 4 = 10 ∧ dofAfterGen 3 4 = 10 := by
  decide

/-- **Control: the hypothesis `n ≤ s` is real.** When `n > s` there is no scalar sector large enough
to feed all Goldstones, and the naive "after" count `3*n + (s - n)` (with truncated Nat subtraction)
does NOT equal the "before" count `2*n + s`. Concretely at `n = 3, s = 2`:
before `= 8`, after `= 9`, so conservation *fails* — exactly as it must when the hypothesis is
violated. -/
theorem dof_general_fails_without_hypothesis :
    dofBeforeGen 3 2 ≠ dofAfterGen 3 2 := by
  decide

/-! ## Target 4: the verdict -/

/-- **Higgs mechanism verdict (dof-counting).** Packages the mechanism as a dof-preserving
rearrangement:

* (abelian) `dofBefore = dofAfter`;
* (longitudinal = Goldstone) the polarization gained equals the Goldstone eaten;
* (general, for `n ≤ s`) `dofBeforeGen n s = dofAfterGen n s = 2*n + s`.

Each broken generator moves one scalar (Goldstone) dof into the longitudinal polarization of a gauge
boson that thereby becomes massive; the total dof `2*n + s` is unchanged. This is the "mass from
massless" transfer on the gauge side. Honest scope: a finite counting identity, not a dynamical
derivation of the VEV or the masses. -/
theorem higgs_mechanism_verdict :
    (dofBefore = dofAfter) ∧
    (polV true - polV false = goldstoneEaten) ∧
    (∀ n s : Nat, n ≤ s →
      dofBeforeGen n s = dofAfterGen n s ∧ dofBeforeGen n s = 2 * n + s) := by
  refine ⟨dof_conserved_abelian, ?_, ?_⟩
  · exact goldstone_is_longitudinal.2
  · intro n s h
    exact dof_conserved_general n s h

/-! ## Axiom footprint of every headline result -/

/-- info: 'HiggsDofConservation.dof_conserved_abelian' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dof_conserved_abelian

/-- info: 'HiggsDofConservation.goldstone_is_longitudinal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms goldstone_is_longitudinal

/-- info: 'HiggsDofConservation.dof_conserved_general' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dof_conserved_general

/-- info: 'HiggsDofConservation.higgs_mechanism_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms higgs_mechanism_verdict

end HiggsDofConservation
