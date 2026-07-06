import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core
import PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
import PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass
import PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomySeparation

/-!
# Gate I1 / NE-U: mass-taxonomy COMMON CARRIER (the documented negative)

This module answers the OPEN question left by `MassTaxonomySeparation`
(`massTaxonomy_functionals_pairwise_separated`) and `MassTaxonomyNonDegeneracy`
(`massTaxonomy_nondegenerate`):

> Is there a SINGLE model family — one structure carrying ONE shared set of
> parameters — on which ALL FOUR null-edge masses can be simultaneously turned
> ON (strictly positive)?

The four functionals are:

| leg | functional | parameter |
| --- | ---------- | --------- |
| regulator | `wilsonRegulatorMass r = log (1 + 4 r)` | `r : ℝ` |
| closure   | `z2GlueballMass β = log coth β`          | `β : ℝ` |
| turn/bare | `quarkMassParameter`                     | (none; pinned `= 0`) |
| aperture  | `compositeApertureMassSq p q = minkowskiSq (p+q)` | null `p, q` |

We bundle ALL of these parameters into ONE structure `CarrierParams` (including a
free `turn` slot for the bare axis), define the four masses OF a carrier, and ask
whether any carrier makes all four strictly positive.

## The verdict: option (b), the documented NEGATIVE

There is **no non-artificial common carrier**, and the obstruction is a single,
identifiable leg: the **turn/bare** mass `quarkMassParameter`. It is a *detached
input constant, definitionally `0`* (`CarrierParams.bareMass_eq_zero`,
downstream of `MassWithoutMass.quarkMassParameter = 0`): it carries no parameter
to vary and therefore admits **no ON witness whatsoever** — no choice of
`r, β, p, q`, or of the free `turn` slot, can make it positive. Consequently no
carrier can have all four masses positive at once
(`no_common_carrier_via_turn`).

Crucially this is **NOT** a contradiction with independent realizability. The
other three legs *are* simultaneously realizable in one carrier
(`three_masses_common_carrier`: at `r = 1`, `β = 1`, and a non-collinear
future-null pair, regulator, closure and aperture are all strictly positive at
once). The *only* thing blocking a four-way common carrier is that the bare axis
is switched off by construction.

## "Independently realizable" ≠ "simultaneously realizable in one model"

`massTaxonomy_nondegenerate` shows each leg can be turned ON *on its own
parameter domain* while the others sit at OFF witnesses. That is a statement
about the FOUR SEPARATE domains. A common carrier is a strictly stronger demand:
ONE shared parameter set producing all four masses at once. The gap between the
two is exactly the content of `independent_realizable_not_common_carrier` below:
the four legs are pairwise independently realizable, **yet** no single carrier
turns all four ON — because the bare leg has no ON state.

## Why a "product of the four domains" is NOT a physical common carrier

One could try to *manufacture* a carrier by taking the naive Cartesian product of
the four parameter domains and declaring the four masses positive by fiat. That
is exactly the artificial move the task warns against, and it does **not** help
here: even the full product carrier `CarrierParams` (which literally bundles
`r, β, p, q, turn`) cannot make `quarkMassParameter` positive, because that
functional ignores every field of the carrier and evaluates to the constant `0`.
The obstruction is intrinsic to the functional, not a matter of bundling.

## Claim discipline

Draft-trust, kernel-checked, `sorry`-free, no new axioms, no `native_decide`.
Reuses the functionals from `MassTaxonomySeparation` / `MassWithoutMass`
verbatim. This is a statement about the FUNCTIONALS, not a physical claim about
QCD.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace MassCommonCarrier

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass
open PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
open PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomySeparation

/-! ## The candidate common carrier: one structure, one shared parameter set -/

/-- **Candidate common carrier.** A single structure bundling *all* the
parameters the four null-edge masses could possibly use: the Wilson parameter
`r`, the inverse temperature `beta`, a pair of four-momenta `p, q` for the
aperture, and a free `turn` slot standing in for whatever knob the bare/turn
mass might have wanted. If a genuine four-way common carrier existed, it would be
(a subfamily of) this structure. -/
structure CarrierParams where
  /-- Wilson regulator parameter (regulator leg). -/
  r : ℝ
  /-- Inverse temperature (closure leg). -/
  beta : ℝ
  /-- First null constituent (aperture leg). -/
  p : Momentum4
  /-- Second null constituent (aperture leg). -/
  q : Momentum4
  /-- Free "turn" slot for the bare/turn axis. The bare mass functional ignores
  it — that is precisely the obstruction. -/
  turn : ℝ

/-! ## The four masses OF a carrier -/

/-- Regulator mass of a carrier. -/
noncomputable def CarrierParams.regulatorMass (c : CarrierParams) : ℝ :=
  wilsonRegulatorMass c.r

/-- Closure / glueball mass of a carrier. -/
noncomputable def CarrierParams.closureMass (c : CarrierParams) : ℝ :=
  z2GlueballMass c.beta

/-- Bare / turn mass of a carrier. It ignores every field (including `turn`): it
is the detached constant `quarkMassParameter`. -/
noncomputable def CarrierParams.bareMass (_c : CarrierParams) : ℝ :=
  quarkMassParameter

/-- Aperture mass-squared of a carrier. -/
noncomputable def CarrierParams.apertureMassSq (c : CarrierParams) : ℝ :=
  compositeApertureMassSq c.p c.q

/-- **The bare mass is identically zero on every carrier.** No field of the
carrier — not `r`, `beta`, `p`, `q`, nor the free `turn` slot — can influence it:
it is definitionally `quarkMassParameter = 0`. This is the single obstruction to
a common carrier. -/
theorem CarrierParams.bareMass_eq_zero (c : CarrierParams) : c.bareMass = 0 := rfl

/-- **The bare mass has no ON witness.** There is no carrier whose bare mass is
strictly positive. -/
theorem bare_has_no_on_witness : ¬ ∃ c : CarrierParams, 0 < c.bareMass := by
  rintro ⟨c, hc⟩
  rw [c.bareMass_eq_zero] at hc
  exact lt_irrefl 0 hc

/-! ## The four-way "all ON" predicate -/

/-- **All four masses simultaneously ON.** The property a genuine common carrier
would have to satisfy: regulator, closure, bare, and aperture masses all strictly
positive at the *same* parameter set. -/
def AllFourPositive (c : CarrierParams) : Prop :=
  0 < c.regulatorMass ∧ 0 < c.closureMass ∧ 0 < c.bareMass ∧ 0 < c.apertureMassSq

/-! ## The documented NEGATIVE -/

/-- **No common carrier (obstructed by the turn/bare leg).** No carrier — hence
no single model family with one shared parameter set — makes all four null-edge
masses strictly positive at once. The obstruction is exactly the turn/bare leg:
`quarkMassParameter` is a detached constant pinned to `0`
(`CarrierParams.bareMass_eq_zero`), so the `0 < c.bareMass` conjunct of
`AllFourPositive` is unsatisfiable, no matter what `r, β, p, q`, or `turn` are
chosen. -/
theorem no_common_carrier_via_turn : ¬ ∃ c : CarrierParams, AllFourPositive c := by
  rintro ⟨c, -, -, hbare, -⟩
  rw [c.bareMass_eq_zero] at hbare
  exact lt_irrefl 0 hbare

/-- Pointwise form: for every carrier, `AllFourPositive` fails. -/
theorem not_allFourPositive (c : CarrierParams) : ¬ AllFourPositive c := by
  rintro ⟨-, -, hbare, -⟩
  rw [c.bareMass_eq_zero] at hbare
  exact lt_irrefl 0 hbare

/-! ## The positive counterpart: the three non-bare masses DO share a carrier -/

/-- The three non-bare masses of a carrier all ON at once. -/
def ThreeNonBarePositive (c : CarrierParams) : Prop :=
  0 < c.regulatorMass ∧ 0 < c.closureMass ∧ 0 < c.apertureMassSq

/-- A concrete carrier: `r = 1`, `β = 1`, and the non-collinear future-null pair
`nullX, nullY` (with an arbitrary `turn = 0`). -/
def witness : CarrierParams where
  r := 1
  beta := 1
  p := nullX
  q := nullY
  turn := 0

/-- **Three-mass common carrier (the richest genuine carrier).** The regulator,
closure, and aperture masses ARE simultaneously realizable in ONE carrier: at
`r = 1`, `β = 1`, and the non-collinear future-null pair `(nullX, nullY)`, all
three are strictly positive at once. Only the bare leg is missing — and it is
missing not for lack of a shared parameter set but because it has no ON state at
all. -/
theorem three_masses_common_carrier : ThreeNonBarePositive witness := by
  refine ⟨?_, ?_, ?_⟩
  · exact wilsonRegulatorMass_pos (by norm_num [witness])
  · exact z2GlueballMass_pos (by norm_num [witness])
  · exact compositeApertureMassSq_noncollinear_pos

/-- **Independently realizable ⇏ common carrier.** The precise gap between the
already-proved non-degeneracy result and a common carrier: the four legs are
pairwise independently realizable (each ON on its own domain — witnessed here for
the three non-bare legs simultaneously, and separately for the bare leg being
pinned OFF), and YET no single carrier turns all four ON at once. The bare leg is
the sole obstruction. -/
theorem independent_realizable_not_common_carrier :
    ThreeNonBarePositive witness ∧
    (∀ c : CarrierParams, c.bareMass = 0) ∧
    (¬ ∃ c : CarrierParams, AllFourPositive c) :=
  ⟨three_masses_common_carrier,
   fun c => c.bareMass_eq_zero,
   no_common_carrier_via_turn⟩

/-! ## Build-enforced axiom-footprint guard

These blocks FAIL TO BUILD if the transitive axiom surface of the headline
theorems changes — e.g. if a `sorry` leaks in, a `native_decide`
(`Lean.ofReduceBool` / `Lean.trustCompiler`) is introduced underneath, or a new
`axiom` appears. -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassCommonCarrier.no_common_carrier_via_turn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_common_carrier_via_turn

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassCommonCarrier.three_masses_common_carrier' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms three_masses_common_carrier

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassCommonCarrier.independent_realizable_not_common_carrier' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms independent_realizable_not_common_carrier

end MassCommonCarrier
end PhysicsSM.Draft.NullEdge.GateI1
