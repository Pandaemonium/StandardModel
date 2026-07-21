import PhysicsSM.Draft.NullEdge.GlobalPhaseWindingNoGo

/-!
# Discrete winding derived from a local Pluecker field

DRAFT (kernel-clean).  Paper C pillar 1 of the 2026-07-11 overnight
publication run.

`GlobalPhaseWindingNoGo` proves that a globally lifted real phase has zero
winding and exhibits a *supplied* winding-one link field with no global
lift.  This module closes the derivation gap flagged in the flagship
manuscript (open problem 5): the patched link data is now DERIVED from a
local site field alone.  For a site-dependent Pluecker field
`z : ZMod L -> Complex`, the link increment across an edge is the principal
argument of the neighbor ratio, `linkIncrement z p = arg (z (p+1) / z p)` -
no gauge field, branch choice, or link variable is supplied by hand.

Results (all kernel-checked, axioms pinned below):

* `totalTurning_int_multiple` - for a nowhere-zero field the total turning
  around the cycle is an exact `2 * pi * Int` multiple (integrality of the
  derived winding);
* `totalTurning_const` - constant-field zero-turning control;
* `linkIncrement_global_phase` - a global unit phase changes no derived
  increment: the derived data is invariant under the walk's global chiral
  conjugation;
* `windingOneField_totalTurning` - the explicit four-site field
  `z p = I ^ p.val` has total turning exactly `2 * pi` (winding one);
* `totalTurning_eq_zero_of_global_lift` - derived increments matching a
  global real lift force zero turning (the derived-data form of the no-go);
* `windingOneSpinors_pluecker` - the winding-one field is the Pluecker
  coordinate of an explicit primitive spinor pair field, so the patched
  data originates in null spinors;
* `rawPhaseIncrement_eq_noGo` - the local copy of the raw-increment
  definition agrees definitionally with `GlobalPhaseWindingNoGo`.

Claim label: finite identity (derived link data + integrality + witnesses).
The index-to-localized-mode bridge remains open (Paper C pillars 2-3).

Provenance: seed statements by Fable (typecheck-verified before
submission); proofs by Aristotle project
`e64d0d5d-cf00-481e-b548-017d9769e318` (run `1cfa634c`), statements
unchanged; integrated with local kernel re-check.  Lean 4.28.0.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.PlueckerWindingDerived

/-- Site-dependent primitive spinor pair on a finite cycle. -/
structure SpinorPairField (L : Nat) [NeZero L] where
  psi : ZMod L -> (Fin 2 -> Complex)
  phi : ZMod L -> (Fin 2 -> Complex)

/-- The local Pluecker coordinate (oriented spinor area) of the pair field. -/
def plueckerField {L : Nat} [NeZero L] (F : SpinorPairField L)
    (p : ZMod L) : Complex :=
  F.psi p 0 * F.phi p 1 - F.psi p 1 * F.phi p 0

/-- Link increment DERIVED from a site field: the principal argument of the
ratio across the edge `p -> p + 1`.  This is the object that was previously
supplied by hand as abstract link data. -/
def linkIncrement {L : Nat} [NeZero L] (z : ZMod L -> Complex)
    (p : ZMod L) : Real :=
  Complex.arg (z (p + 1) / z p)

/-- Total turning of the field around the finite cycle. -/
def totalTurning {L : Nat} [NeZero L] (z : ZMod L -> Complex) : Real :=
  ∑ p : ZMod L, linkIncrement z p

/-- Raw one-edge difference of a globally defined real phase lift (local
copy; agreement with `GlobalPhaseWindingNoGo` is proved below). -/
def rawPhaseIncrement {L : Nat} (theta : ZMod L -> Real) (p : ZMod L) : Real :=
  theta (p + 1) - theta p

/-- The local raw-increment copy agrees definitionally with the project
no-go module. -/
theorem rawPhaseIncrement_eq_noGo {L : Nat} (theta : ZMod L -> Real)
    (p : ZMod L) :
    rawPhaseIncrement theta p =
      PhysicsSM.Draft.NullEdge.GlobalPhaseWindingNoGo.rawPhaseIncrement
        theta p := rfl

/-- **T1 (integrality).**  For a nowhere-zero field, the total turning is an
exact integer multiple of `2 * pi`. -/
theorem totalTurning_int_multiple {L : Nat} [NeZero L]
    (z : ZMod L -> Complex) (hz : ∀ p, z p ≠ 0) :
    ∃ w : Int, totalTurning z = 2 * Real.pi * (w : Real) := by
  have h_totalTurning : totalTurning z = ∑ p : ZMod L, Complex.arg (z (p + 1) / z p) := by
    rfl;
  have h_log : ∃ w : ℤ, ∑ p : ZMod L, Complex.log (z (p + 1) / z p) = 2 * Real.pi * Complex.I * w := by
    have h_log : ∏ p : ZMod L, (z (p + 1) / z p) = 1 := by
      simp +decide [ Finset.prod_div_distrib ];
      erw [ div_eq_iff ( Finset.prod_ne_zero_iff.mpr fun _ _ => hz _ ) ] ; erw [ Equiv.prod_comp ( Equiv.addRight 1 ) ] ; aesop;
    have h_log : Complex.exp (∑ p : ZMod L, Complex.log (z (p + 1) / z p)) = 1 := by
      rw [ Complex.exp_sum, Finset.prod_congr rfl fun _ _ => Complex.exp_log ( div_ne_zero ( hz _ ) ( hz _ ) ), h_log ];
    rw [ Complex.exp_eq_one_iff ] at h_log; obtain ⟨ w, hw ⟩ := h_log; exact ⟨ w, by linear_combination hw ⟩ ;
  simp_all +decide [ Complex.ext_iff, Complex.log_re, Complex.log_im ]

/-- **T2 (constant control).**  A constant nonzero field has zero total
turning. -/
theorem totalTurning_const {L : Nat} [NeZero L] (c : Complex) (hc : c ≠ 0) :
    totalTurning (fun _ : ZMod L => c) = 0 := by
  unfold totalTurning linkIncrement; simp +decide [ hc, Complex.arg_one ] ;

/-- **T3 (global chiral covariance).**  Multiplying the whole field by one
fixed unit phase does not change any derived link increment, hence not the
total turning. -/
theorem linkIncrement_global_phase {L : Nat} [NeZero L]
    (z : ZMod L -> Complex) (u : Complex) (hu : u ≠ 0) (p : ZMod L) :
    linkIncrement (fun q => u * z q) p = linkIncrement z p := by
  unfold linkIncrement; simp +decide [ mul_div_mul_left, hu ] ;

/-- The winding-one witness field on the four-cycle: `z p = I ^ p.val`.
Every ratio equals `I`, whose principal argument is `pi / 2`. -/
def windingOneField (p : ZMod 4) : Complex :=
  Complex.I ^ (p.val)

/-- **T4 (winding-one witness).**  The derived total turning of the explicit
four-site field is exactly `2 * pi`: the previously supplied patched link
data is now generated by a local field. -/
theorem windingOneField_totalTurning :
    totalTurning windingOneField = 2 * Real.pi := by
  unfold totalTurning windingOneField
  simp +decide [linkIncrement];
  erw [ Fin.sum_univ_four ] ; norm_num [ ZMod.val ] ; ring;

/-- **T5 (derived no-go bridge).**  If the derived link increments of a
nowhere-zero field all agree with the raw increments of some globally
defined real phase, the total turning is zero.  Combined with T4, the
winding-one field provably carries patched data with no global lift. -/
theorem totalTurning_eq_zero_of_global_lift {L : Nat} [NeZero L]
    (z : ZMod L -> Complex) (theta : ZMod L -> Real)
    (h : ∀ p, linkIncrement z p = rawPhaseIncrement theta p) :
    totalTurning z = 0 := by
  unfold totalTurning; simp +decide [ * ] ;
  unfold rawPhaseIncrement; rw [ Finset.sum_sub_distrib ] ;
  erw [ sub_eq_zero, Equiv.sum_comp ( Equiv.addRight 1 ) ]

/-- Primitive-spinor generator for the winding-one field:
`psi = (1, 0)` and `phi p = (0, I ^ p.val)` give
`plueckerField = windingOneField`.  The patched data therefore comes from
null spinors, not from a supplied gauge field. -/
def windingOneSpinors : SpinorPairField 4 where
  psi := fun _ => ![1, 0]
  phi := fun p => ![0, Complex.I ^ (p.val)]

/-- **T6 (spinor derivation).**  The winding-one field is the Pluecker
coordinate of an explicit primitive spinor pair field. -/
theorem windingOneSpinors_pluecker :
    plueckerField windingOneSpinors = windingOneField := by
  funext p; simp [plueckerField, windingOneSpinors, windingOneField]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerWindingDerived.totalTurning_int_multiple' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms totalTurning_int_multiple

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerWindingDerived.totalTurning_const' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms totalTurning_const

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerWindingDerived.linkIncrement_global_phase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linkIncrement_global_phase

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerWindingDerived.windingOneField_totalTurning' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms windingOneField_totalTurning

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerWindingDerived.totalTurning_eq_zero_of_global_lift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms totalTurning_eq_zero_of_global_lift

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerWindingDerived.windingOneSpinors_pluecker' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms windingOneSpinors_pluecker

end PhysicsSM.Draft.NullEdge.PlueckerWindingDerived
