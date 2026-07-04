import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionDouble
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteReflection
import PhysicsSM.Draft.NullEdge.GateYM.WilsonReflectionCompatibility
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel
import PhysicsSM.Draft.NullEdge.GateYM.Theorem2AreaLaw
import PhysicsSM.Draft.NullEdge.GateYM.MirrorHolonomyResolution

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
WITNESS FOR THE REFLECTION STRUCTURE, NOT THE FULL RP-LINK THEOREM WITH
CUT PLAQUETTES. Any report or claim-language document citing this file
MUST use language of the form "RP-LINK baseline (zero-cut
well-definedness, genuine ensemble weight); cut-plaquette positivity
(shocking tier) OPEN", never "RP-LINK closed" or equivalent.

**N3 UPDATE:** node N3 (the cut-plaquette conjugation question - does the
raw mirror-plaquette holonomy land in the right conjugacy class for
nonabelian `G`) has been RESOLVED via a convention correction, not a
conjugacy proof: the original claim (raw word reversal is conjugate to the
original holonomy or its inverse) was FALSE in general
(`MirrorHolonomyConjugation.lean`, S3 counterexample). The fix
(`ReflectionCore.reflectLinkField`, Route B) bakes a group inverse into the
reflection pullback, making the mirror-plaquette holonomy the honest GROUP
INVERSE of the original at the reflected configuration - a
conjugacy-class invariant. `MirrorHolonomyResolution.lean` proves the
resulting Wilson-weight identity for GENERAL (independent) configurations.
This module now uses that general result directly (see
`mirrorPlaquette_liftPlaquettePos_hol` below), closing the ensemble
identification gap for the zero-cut construction (see the new "What is now
also proved" section). The remaining open item is the SHOCKING tier: a
lattice with actual cut PLAQUETTES (not the degenerate zero-cut case).

## The construction

Given a base lattice `L0` and a single plaquette `p0 : Plaquette L0`, lift
`p0` to the `true` (positive) copy of `doubleLattice L0` as
`liftPlaquettePos p0` (reused from `MirrorHolonomyResolution`) -
straightforward, since the `true` copy's `src`/`tgt` match `L0`'s own
exactly. The NEGATIVE-side plaquette is NOT an ad hoc "lift with swapped
steps" (that computes a non-conjugate holonomy word in general, exactly
the bug N3 diagnosed) - it is the GENUINE mirror image
`PlaquetteReflection.mirrorPlaquette (doubleReflection L0)
(liftPlaquettePos p0)`, whose Wilson weight is related to the positive
side by the N3-corrected `reflectLinkField` (group inverse baked in) via
`MirrorHolonomyResolution.mirrorPlaquette_wilsonWeight_eq`.

For a UNITARY representation, that theorem gives the genuine mirror
plaquette's Wilson weight at the mirror-coordinate configuration
`MirrorHolonomyResolution.mirrorConfig a b` (positive side `a`, negative
side the time-reflection inverse `b^{-1}`) equal to the ORIGINAL plaquette's
Wilson weight at `b` - for ANY independent `a, b`, not just
reflection-derived configurations. This gives exactly the factorized shape
`h(a) * h(b)` (real weight, so `conj` is trivial) that
`ReflectionPositivityKernel.cutKernel_posSemidef_of_factorized` consumes,
AND (new) identifies it with the genuine two-plaquette ensemble weight -
see `doubledWilsonWeight_eq_ensembleWeight_mirrorConfig` below.

## What is proved

- `liftPlaquettePos`, `hol_liftPlaquettePos` (from `MirrorHolonomyResolution`,
  reused rather than duplicated): lift a base-lattice plaquette to the
  positive copy, and its holonomy against the positive-side restriction.
- `mirrorPlaquette_liftPlaquettePos_hol` (the genuine geometric bridge
  fact, N3-corrected): for a unitary representation, the GENUINE mirror
  plaquette's Wilson weight at the mirror-coordinate configuration
  `mirrorConfig a b` equals the ORIGINAL Wilson weight of the base
  plaquette at `b` - for GENERAL independent `a, b`, not just
  reflection-derived configurations (this closes the gap the previous,
  `rhoOppositeInv`-based version of this lemma left open; see
  `MirrorHolonomyResolution.lean` for the proof).
- `doubledWilsonWeight`: the Wilson-SHAPED weight family
  `h(a) * h(b)` with `h x := wilsonLocalWeight(beta, rho, p0.hol x)`, in
  independent mirror coordinates `a, b : L0.LinkField G`.
- **`doubled_wilson_reflectionForm_nonneg`** (headline RP-KER instance):
  this Wilson-shaped weight family is reflection positive - the
  Osterwalder-Seiler form is nonnegative on every positive-side
  observable, for ANY finite group `G`, ANY base lattice `L0`, ANY
  plaquette `p0`, and ANY unitary representation `rho`.
- **`doubledWilsonWeight_eq_ensembleWeight_mirrorConfig`** (NEW, closes the
  previously-open ensemble-identification gap): for a unitary `rho`,
  `doubledWilsonWeight beta rho p0 a b` equals the GENUINE
  `PlaquetteEnsemble.weight` of the two-plaquette family
  `{liftPlaquettePos p0, mirrorPlaquette (doubleReflection L0)
  (liftPlaquettePos p0)}`, evaluated at the single shared configuration
  `mirrorConfig a b` (cast to `C`). Combined with
  `doubled_wilson_reflectionForm_nonneg`, this shows the ACTUAL
  doubled-lattice Wilson ensemble (not just an abstractly-shaped
  substitute) is reflection positive, at the specific mirror-coordinate
  configurations `mirrorConfig a b`.

## What this does NOT prove (explicit - read before citing this module)

This module's `C := PUnit` case has NO cut links at all (the two copies of
`L0` share no edges). A lattice with actual cut PLAQUETTES (straddling the
reflection, coupling the two sides through the ensemble weight) is a
genuinely different, harder construction needing
`ReflectionPositivityKernel.cutKernel_posSemidef_of_mixture` - the
SHOCKING tier of Q1, not attempted in this module. The ensemble
identification above is specific to the `mirrorConfig a b` parametrization,
in which the negative side is the pointwise time-reflection inverse `b^{-1}`
of `b` (the physically correct OS convention: the negative-side field is
the time-reflected image of the corresponding positive-side data) - it does
NOT claim anything about an UNRESTRICTED, non-mirror-coordinate doubled
configuration.

Claim label: **finite identity**. Draft-trust: kernel-checked, no
`s o r r y`, no `n a t i v e _ d e c i d e`. Prerequisites:
`ReflectionDouble`, `PlaquetteReflection`, `WilsonReflectionCompatibility`,
`ReflectionPositivityKernel`, `MirrorHolonomyResolution`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace WilsonReflectionPositivity

open scoped Matrix ComplexOrder

open GaugeCoreGeneral ReflectionCore PlaquetteCore PlaquetteReflection
open ReflectionDouble WilsonReflectionCompatibility MirrorHolonomyResolution

variable {L0 : OrientedLattice} {G : Type} [Group G] [Fintype G] {n : ℕ}

variable (beta : ℝ) (rho : G → Matrix (Fin n) (Fin n) ℂ)

omit [Fintype G] in
/-- **Twist resolution (N3-corrected, general case).** For a unitary
representation, the GENUINE mirror plaquette's Wilson weight at the
mirror-coordinate configuration `mirrorConfig a b` equals the ORIGINAL
Wilson weight of the base plaquette at `b` - for GENERAL independent
`a, b`, not just reflection-derived configurations. This is
`MirrorHolonomyResolution.mirrorPlaquette_wilsonWeight_eq`, specialized to
this module's `liftPlaquettePos`/`doubleReflection` naming; the previous
`rhoOppositeInv`-based version of this lemma only closed the reflected-
configuration case. -/
theorem mirrorPlaquette_liftPlaquettePos_hol (p0 : Plaquette L0)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (a b : L0.LinkField (G := G)) :
    WilsonLocalWeight.wilsonLocalWeight beta rho
        ((mirrorPlaquette (doubleReflection L0) (liftPlaquettePos p0)).hol
          (mirrorConfig a b))
      = WilsonLocalWeight.wilsonLocalWeight beta rho (p0.hol b) :=
  mirrorPlaquette_wilsonWeight_eq beta rho hmul hone hunit p0 a b

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

/-- The two-plaquette family: the positive lift of `p0` and its genuine
mirror image. -/
def mirrorPair (p0 : Plaquette L0) : Bool → Plaquette (doubleLattice L0) :=
  fun s => if s then liftPlaquettePos p0
    else mirrorPlaquette (doubleReflection L0) (liftPlaquettePos p0)

omit [Fintype G] in
/-- **Ensemble identification (closes the previously-open gap).** For a
unitary representation, `doubledWilsonWeight beta rho p0 a b` equals the
GENUINE `PlaquetteEnsemble.weight` of the two-plaquette family `mirrorPair
p0` (the positive lift of `p0` together with its genuine mirror image),
evaluated at the single shared configuration `mirrorConfig a b` - not just
an abstractly-shaped substitute. Combined with
`doubled_wilson_reflectionForm_nonneg`, this shows the ACTUAL
doubled-lattice Wilson ensemble is reflection positive at these
mirror-coordinate configurations. -/
theorem doubledWilsonWeight_eq_ensembleWeight_mirrorConfig (p0 : Plaquette L0)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (a b : L0.LinkField (G := G)) :
    doubledWilsonWeight beta rho p0 a b
      = (PlaquetteEnsemble.weight (mirrorPair p0)
          (WilsonLocalWeight.wilsonLocalWeight beta rho) (mirrorConfig a b) : ℂ) := by
  have hpos : (liftPlaquettePos p0).hol (mirrorConfig a b) = p0.hol a := by
    rw [hol_liftPlaquettePos]; rfl
  have hneg := mirrorPlaquette_liftPlaquettePos_hol beta rho p0 hmul hone hunit a b
  unfold doubledWilsonWeight Theorem2AreaLaw.wilsonLocalWeightC PlaquetteEnsemble.weight
    PlaquetteCore.productWeight mirrorPair
  rw [Fintype.prod_bool]
  simp only [Bool.false_eq_true, if_false, if_pos]
  rw [hpos, hneg]
  push_cast
  ring

end WilsonReflectionPositivity
end GateYM
end NullEdge
end Draft
end PhysicsSM
