import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionDouble
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteReflection
import PhysicsSM.Draft.NullEdge.GateYM.WilsonReflectionCompatibility
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel
import PhysicsSM.Draft.NullEdge.GateYM.Theorem2AreaLaw

/-!
# Gate YM3 Q1: RP-LINK for the Wilson weight on a doubled lattice

This module reaches the BASELINE tier of queue item Q1
(`Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` section 14, and
`AgentTasks/fourday-ym-run-2026-07-05/TASK_DIRECTIONS.md`'s T1 baseline:
"mirror coordinates + factorized (no-cut-plaquette) RP on a concrete
lattice"): a concrete mirror-coordinate change of variables
(`ReflectionDouble.doubleLinkFieldEquiv`) and a genuine Wilson local
weight FUNCTION (not a per-link toy substitute - built from an actual
plaquette holonomy) instantiating `ReflectionPositivityKernel`'s
factorized reflection-positivity theorem. What remains open for the
strong tier - whether the genuine two-plaquette mirror ENSEMBLE weight
(not just the weight function's algebraic shape) equals this factorized
form - is stated precisely in "What this does NOT prove" below.

**CLAIM-FRAMING CORRECTION (from an Aristotle day-1 whole-ladder audit,
`AgentTasks/aristotle-output/fourday-ym-day1-grand-strategy-20260704/`,
cross-checked against Osterwalder-Seiler 1978 Ann. Phys. 110 Sec. 2 and
Seiler LNP 159 Ch. II): the `doubleLattice` substrate this module builds
on has ZERO cut links (the two copies of `L0` share no edges), which
makes it a DEGENERATE instance of reflection positivity - the Gram form
factorizes trivially (an outer product of a vector with itself) and is
PSD for a vacuous reason. Reflection positivity is only mathematically
nontrivial when the reflection plane CUTS links/plaquettes, so the
reflected and original configurations share boundary degrees of freedom
through the cut variables; that is the actual content Osterwalder-Seiler
prove. THIS MODULE THEREFORE ESTABLISHES A WELL-DEFINEDNESS/CONSISTENCY
WITNESS FOR THE REFLECTION STRUCTURE, NOT THE NONTRIVIAL RP-LINK THEOREM.
The genuine RP-LINK content is queue item Q1's node N3 (the cut-plaquette
conjugation: identifying the raw mirror-plaquette holonomy word, which is
differently ordered from the target for nonabelian `G`, with the correct
conjugate via an explicit conjugating element and a trace/character
invariance argument) - separately tracked, NOT closed by this module.
Any report or claim-language document citing this file MUST use language
of the form "RP-LINK baseline (zero-cut well-definedness); nontrivial
cut-plaquette positivity OPEN (N3)", never "RP-LINK closed" or
equivalent - this is the single most load-bearing claim-discipline point
the audit raised.

## The construction

Given a base lattice `L0` and a single plaquette `p0 : Plaquette L0`, lift
`p0` to the `true` (positive) copy of `doubleLattice L0` as
`liftPlaquettePos p0` - straightforward, since the `true` copy's `src`/`tgt`
match `L0`'s own exactly. The NEGATIVE-side plaquette is NOT an ad hoc
"lift with swapped steps" (that computes a non-conjugate holonomy word in
general, as the design note in this run's `DISCUSSION.md`
`design:q1-reflection-orientation` thread records) - it is the GENUINE
mirror image `PlaquetteReflection.mirrorPlaquette (doubleReflection L0)
(liftPlaquettePos p0)`, whose Wilson weight is related to the positive
side by the ALREADY-PROVEN `WilsonReflectionCompatibility` bridge
(`rhoOppositeInv`, the inverse-pulled `MulOpposite G` representation).

For a UNITARY representation, `wilsonLocalWeight_inv_of_unitary` (already
proved in `WilsonLocalWeight.lean`) closes the loop: the opposite-inverse
weight of the mirrored plaquette equals the ORIGINAL Wilson weight of the
negative-side link-field restriction, giving exactly the factorized shape
`h(a) * h(b)` (real weight, so `conj` is trivial) that
`ReflectionPositivityKernel.cutKernel_posSemidef_of_factorized` consumes.

## What is proved

- `liftPlaquettePos`: lift a base-lattice plaquette to the positive copy.
- `hol_liftPlaquettePos`: its holonomy against a doubled-lattice link field
  equals the base plaquette's holonomy against the positive-side
  restriction (`(doubleLinkFieldEquiv L0 U).1`).
- `mirrorPlaquette_liftPlaquettePos_hol` (the genuine geometric bridge fact):
  for a unitary representation, the OPPOSITE-INVERSE Wilson weight of the
  GENUINE mirror plaquette's holonomy against the opposite-group pullback
  `opLinkField U` equals the ORIGINAL Wilson weight of the base plaquette
  against the negative-side restriction `(doubleLinkFieldEquiv L0 U).2` -
  the twist-resolution step flagged open in the design note, now closed
  for REFLECTED configurations specifically.
- `doubledWilsonWeight`: the Wilson-SHAPED weight family
  `h(a) * h(b)` with `h x := wilsonLocalWeight(beta, rho, p0.hol x)`, in
  independent mirror coordinates `a, b : L0.LinkField G`.
- **`doubled_wilson_reflectionForm_nonneg`** (the headline theorem): this
  Wilson-shaped weight family is reflection positive - the
  Osterwalder-Seiler form is nonnegative on every positive-side
  observable, for ANY finite group `G`, ANY base lattice `L0`, ANY
  plaquette `p0`, and ANY unitary representation `rho`. This is an honest
  instance of RP-KER's factorized class built from genuine Wilson local
  weights (not an abstract placeholder function), which is real progress:
  it shows the Wilson weight FUNCTION is exactly the right shape for RP-KER
  to bite on.

## What this does NOT prove (explicit - read before citing this module)

`doubledWilsonWeight a b` uses the SAME function `h := wilsonLocalWeight
composed with p0.hol` on BOTH independent coordinates `a` and `b`. This is
NOT (yet) shown to equal the GENUINE total `PlaquetteEnsemble.weight` of
the actual two-plaquette family `{liftPlaquettePos p0, mirrorPlaquette
(doubleReflection L0) (liftPlaquettePos p0)}` evaluated at a single
configuration `U` with `a = (doubleLinkFieldEquiv L0 U).1`,
`b = (doubleLinkFieldEquiv L0 U).2`. `mirrorPlaquette_liftPlaquettePos_hol`
only relates the mirror plaquette's weight to `p0.hol b` for REFLECTED
configurations (`U` in the image of `reflectLinkField`, via the opposite-
group route); by hand computation (recorded in this run's `DISCUSSION.md`),
the GENUINE mirror plaquette's RAW holonomy at an INDEPENDENT (non-reflected)
`U` is a differently-ordered/inverted word in `b`'s link values that is NOT
evidently conjugate to `p0.hol b` for nonabelian `G` - so whether the
genuine two-plaquette ensemble weight actually reduces to the factorized
shape used here is a SEPARATE, currently OPEN question, not resolved by
this module. `doubled_wilson_reflectionForm_nonneg` should be read as
"the natural Wilson-weight-shaped factorized family is RP" (real, useful,
and a genuine instance of Wilson local weights meeting RP-KER), NOT as
"the actual doubled-lattice Wilson ensemble is RP" (open). Closing that
gap - or finding it needs a different pairing than the naive same-`h`
product - is the concrete next step for Q1's strong tier.

Separately: this module's `C := PUnit` case has NO cut links at all
(the two copies of `L0` share no edges), so even once the ensemble
question above is resolved, a lattice with actual cut PLAQUETTES
(straddling the reflection, coupling the two sides through the ensemble
weight) is a genuinely different, harder construction needing
`ReflectionPositivityKernel.cutKernel_posSemidef_of_mixture` - the
shocking tier of Q1, not attempted in this module.

Claim label: **finite identity**. Draft-trust: kernel-checked, no
`s o r r y`, no `n a t i v e _ d e c i d e`. Prerequisites:
`ReflectionDouble`, `PlaquetteReflection`, `WilsonReflectionCompatibility`,
`ReflectionPositivityKernel`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace WilsonReflectionPositivity

open scoped Matrix ComplexOrder

open GaugeCoreGeneral ReflectionCore PlaquetteCore PlaquetteReflection
open ReflectionDouble WilsonReflectionCompatibility

variable {L0 : OrientedLattice} {G : Type} [Group G] [Fintype G] {n : ℕ}

/-- Lift a step of the base lattice to the positive (`true`) copy of the
doubled lattice: the `true` side's `src`/`tgt` match `L0`'s own exactly. -/
def liftStepPos : {x y : L0.V} → OrientedLattice.Step L0 x y →
    OrientedLattice.Step (doubleLattice L0) (true, x) (true, y)
  | _, _, OrientedLattice.Step.fwd e =>
      OrientedLattice.Step.castEndpoints (Λ := doubleLattice L0)
        (by simp [doubleLattice]) (by simp [doubleLattice])
        (OrientedLattice.Step.fwd (true, e))
  | _, _, OrientedLattice.Step.rev e =>
      OrientedLattice.Step.castEndpoints (Λ := doubleLattice L0)
        (by simp [doubleLattice]) (by simp [doubleLattice])
        (OrientedLattice.Step.rev (true, e))

/-- Lift a base-lattice plaquette to the positive copy of the doubled
lattice. -/
def liftPlaquettePos (p0 : Plaquette L0) : Plaquette (doubleLattice L0) where
  base := (true, p0.base)
  v1 := (true, p0.v1)
  v2 := (true, p0.v2)
  v3 := (true, p0.v3)
  step0 := liftStepPos p0.step0
  step1 := liftStepPos p0.step1
  step2 := liftStepPos p0.step2
  step3 := liftStepPos p0.step3

omit [Fintype G] in
/-- Step-level holonomy compatibility for the positive lift: no twist,
since the `true` side copies `L0`'s own orientation exactly. -/
theorem stepHol_liftStepPos {x y : L0.V} (s : OrientedLattice.Step L0 x y)
    (U : (doubleLattice L0).LinkField (G := G)) :
    OrientedLattice.stepHol U (liftStepPos s)
      = OrientedLattice.stepHol (doubleLinkFieldEquiv L0 U).1 s := by
  cases s with
  | fwd e =>
      simp only [liftStepPos, OrientedLattice.stepHol_castEndpoints]
      rfl
  | rev e =>
      simp only [liftStepPos, OrientedLattice.stepHol_castEndpoints]
      rfl

omit [Fintype G] in
/-- The positive lift's holonomy equals the base plaquette's holonomy
against the positive-side restriction of `U`. -/
theorem hol_liftPlaquettePos (p0 : Plaquette L0)
    (U : (doubleLattice L0).LinkField (G := G)) :
    (liftPlaquettePos p0).hol U = p0.hol (doubleLinkFieldEquiv L0 U).1 := by
  unfold Plaquette.hol liftPlaquettePos Plaquette.walk
  simp only [OrientedLattice.hol, stepHol_liftStepPos]

variable (beta : ℝ) (rho : G → Matrix (Fin n) (Fin n) ℂ)

omit [Fintype G] in
/-- **Twist resolution.** For a unitary representation, the opposite-inverse
Wilson weight of the GENUINE mirror plaquette's holonomy (against the
opposite-group pullback of `U`) equals the ORIGINAL Wilson weight of the
base plaquette against the negative-side restriction of `U`. This is the
step flagged open in `design:q1-reflection-orientation`: the naive per-side
lift fails, but the proven `mirrorPlaquette` + `rhoOppositeInv` +
`op_hol`/`reflectLinkField_doubleReflection_eq` chain closes it. -/
theorem mirrorPlaquette_liftPlaquettePos_hol (p0 : Plaquette L0)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (U : (doubleLattice L0).LinkField (G := G)) :
    WilsonLocalWeight.wilsonLocalWeight beta (rhoOppositeInv rho)
        ((mirrorPlaquette (doubleReflection L0) (liftPlaquettePos p0)).hol
          (ReflectionCore.Reflection.opLinkField U))
      = WilsonLocalWeight.wilsonLocalWeight beta rho
          (p0.hol (doubleLinkFieldEquiv L0 U).2) := by
  have h := localWeight_hol_reflectLinkField_mirrorPlaquette_wilson (doubleReflection L0)
    (liftPlaquettePos p0) beta rho hmul hone hunit U
  rw [hol_liftPlaquettePos, reflectLinkField_doubleReflection_eq] at h
  exact h.symm

/-- The Wilson-shaped factorized weight family: the SAME local weight
function `h x := wilsonLocalWeight(beta, rho, p0.hol x)` applied
independently to both mirror coordinates. NOT (yet) shown to be the
genuine `PlaquetteEnsemble.weight` of the actual mirror-plaquette pair -
see the module docstring's "What this does NOT prove" section. -/
def doubledWilsonWeight (p0 : Plaquette L0)
    (a b : L0.LinkField (G := G)) : ℂ :=
  (Theorem2AreaLaw.wilsonLocalWeightC beta rho (p0.hol a) : ℂ)
    * (Theorem2AreaLaw.wilsonLocalWeightC beta rho (p0.hol b) : ℂ)

omit [Fintype G] in
/-- **RP-KER meets Wilson, baseline instance.** The Wilson-shaped
factorized weight family `doubledWilsonWeight` is reflection positive: the
Osterwalder-Seiler form is nonnegative on every positive-side observable,
for any finite group `G`, base lattice `L0`, plaquette `p0`, and
representation `rho`. See the module docstring for the precise, honest
scope: this is RP-KER instantiated at a genuine Wilson local weight
FUNCTION, not (yet) a proof that the actual two-plaquette mirror ensemble
weight equals this factorized form. Note: unlike
`mirrorPlaquette_liftPlaquettePos_hol`, this theorem needs NO
multiplicativity/unitarity hypothesis on `rho` - `doubledWilsonWeight` is a
self-contained factorized weight family, not (yet) tied to the genuine
mirror-plaquette ensemble where those hypotheses would enter. -/
theorem doubled_wilson_reflectionForm_nonneg [Fintype (L0.LinkField (G := G))]
    (p0 : Plaquette L0)
    (f : L0.LinkField (G := G) → PUnit → ℂ) :
    0 ≤ ReflectionPositivityKernel.reflectionForm
      (fun a (_ : PUnit) b => doubledWilsonWeight beta rho p0 a b) f := by
  have heq : (fun a (_ : PUnit) b => doubledWilsonWeight beta rho p0 a b)
      = (fun a (_ : PUnit) b =>
          Theorem2AreaLaw.wilsonLocalWeightC beta rho (p0.hol a) *
            (starRingEnd ℂ) (Theorem2AreaLaw.wilsonLocalWeightC beta rho (p0.hol b))) := by
    funext a _c b
    unfold doubledWilsonWeight Theorem2AreaLaw.wilsonLocalWeightC
    rw [Complex.conj_ofReal]
  rw [heq]
  exact ReflectionPositivityKernel.reflectionForm_nonneg_of_factorized
    (fun a (_ : PUnit) => Theorem2AreaLaw.wilsonLocalWeightC beta rho (p0.hol a)) f

end WilsonReflectionPositivity
end GateYM
end NullEdge
end Draft
end PhysicsSM
