# All-mass-from-null-edges: mission-scoped grand strategy

Date: 2026-07-06. Scope: forward-looking strategy to maximize honest,
kernel-checked coverage of "explaining ALL mass with null-edge theory," given
the current tree and the 9 in-flight jobs. Source-grounded; no lake build.

Ground-truth anchors used:
`AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md` (normative
mass doc), `AgentTasks/overnight-mass-run-2026-07-06/RUN_PLAN.md` (the 9 jobs =
A1-A9), and the proved modules under `PhysicsSM/Draft/NullEdge/GateI1/` and
`.../GateYM/`. All theorem/def names below were read directly from source.

---

## Bottom line (read this first)

The all-mass story is in far better shape than the hard-YM story, and the two
are **only loosely coupled**: the capstone `allMassFromNullEdges`
(`GateI1/AllMassFromNullEdges.lean`) already stands, and it depends on **none**
of the 9 in-flight jobs. The mass thesis's *floor* is therefore already banked.

But the capstone is a **conjunction across four disjoint mathematical
universes** with no shared carrier object; "unification" is currently a prose
label over four independent finite facts. The single most valuable next move is
NOT another disconnected row - it is a theorem that puts **two obstruction modes
on ONE object** (aperture = turn, in 3+1D), upgrading the story from conjunction
toward genuine mechanism. The single biggest hidden risk is that one bundled
conjunct - the (C) "mass without mass" pair - carries **zero mass-specific
content** in its "zero primitive mass" half (`quarkMassParameter = 0` is a
free-floating `rfl` on a constant unrelated to the Z2 model). And the cheapest
kill-test is to demand a single finite model on which the (C) closure mass and
the (A) aperture mass are the *same number*; the tree cannot currently produce
one, which is exactly the kernel-checkable evidence that "unification" = shared
SHAPE, not shared quantity.

---

## Ask 1 - The single highest-leverage NEXT theorem (beyond the 9)

**Name it:** `apertureEqualsTurn_onShell` (3+1D aperture=turn bridge).

**Statement shape.** For an on-shell 3+1D momentum `p` with
`minkowskiSq p = m^2`, its canonical two-null resolution `p = kPlus + kMinus`
(future-null `kPlus, kMinus`) satisfies
```
minkowskiSq (kPlus + kMinus) = 2 * minkDot kPlus kMinus = m^2      -- (A) aperture
                              = (the chirality-EVEN eigenvalue of the           -- (T) turn
                                 Dirac coin / massVertex at mass m)^... = m^2
```
i.e. the **aperture mass of the two-null composite equals the turn/coin
amplitude of the Dirac operator on the same momentum**, in 3+1D.

**What it builds on (all already proved):**
- `GateI1/CompositeApertureMass.lean` - `compositeMassSq_eq_sum_pairwise`,
  `compositeMassSq_eq_zero_iff_collinear` (the (A) keystone; 2-body germ
  `det (minkHerm (p+q)) = 2 minkDot p q`).
- `GateI1/MassCoinBridge.lean` - `onshell_wedge_normSq_eq_coin_sq` already
  proves *exactly this identity in 1+1D* (`wedge^2 = coin^2 = mu^2`); the new
  theorem is its 3+1D generalization.
- `GateI1/Core.lean` - `det_minkHerm_eq_minkowskiSq` (`det P = m^2`).
- `GateYM/ChiralMassStructure.lean` - `chiralEven_massVertex`,
  `chiralOdd_massVertex` (the (T) channel decomposition).

**Why it dominates.** Every other reachable rung adds one more *disconnected*
fact to the conjunction. This one attacks the capstone's structural weakness
head-on: it is the first theorem that makes two of the three obstruction modes
(T and A) **the same scalar on the same object at physical dimension**, turning
the doc's central prose claim ("one mechanism shape, three obstruction types")
into mathematics for the T/A pair. It is also low-risk: the 1+1D case is done,
the 2-body aperture germ is done, and the two-null resolution of a timelike
vector is a clean finite identity. High EV, medium effort, no dependency on the
hard YM dynamics.

Runner-up (if you want a coverage rung instead of a binding rung): a
**common-model** taxonomy separation (see Ask 4 #4), which is the honest fix for
the Ask 2 risk if A9 returns the disjoint-model version.

---

## Ask 2 - The biggest HIDDEN RISK (adversarial)

**The risk: the (C) "mass without mass" conjunct is half vacuous - its "zero
primitive mass" clause carries no mass-specific content and imports a
cancellation that the math does not contain.**

Evidence, kernel-level:
- `GateI1/MassWithoutMass.lean:106`: `noncomputable def quarkMassParameter :
  R := 0`. It is a **free-floating constant**, not the mass parameter *of* the
  Z2 transfer operator (the Z2 glueball model has no fermions and no such
  parameter).
- `MassWithoutMass.lean:125-126`: `massWithoutMass` proves
  `quarkMassParameter = 0 AND 0 < z2GlueballMass beta` by `<rfl, z2GlueballMass_pos hb>`.
  The first conjunct is literally `rfl`.
- Consequence: replace `quarkMassParameter` by *any* `= 0` constant and the
  theorem is equally true. The "zero primitive mass" half is content-free; all
  the content is `0 < z2GlueballMass beta`. The juxtaposition manufactures the
  rhetorical "mass without mass" (positive gap *despite* zeroed mass in the same
  system) that the mathematics does not assert, because the two facts live in
  **different, unconnected models**. The capstone docstring flags the zero as
  "definitional," but understates it: it is not just definitional, it is
  *detached* from the model that produces the gap.

This is the kernel-checked NEGATIVE the project rewards: the (C) conjunct's
honest content is one inequality; the "mass without mass" framing is prose.

**Close second (same family):** the (T) turn conjunct **lumps rather than
separates**. `chiralEven_massVertex` gives `chiralEven (massVertex m mu) =
(m+1) . 1` (`ChiralMassStructure.lean:124`): the physical mass `m` and the
Wilson regulator scalar `1` land in the **same** chirality-even channel. So the
bundled (T) conjunct demonstrates that mass and regulator are the *same kind of
object*, which is the OPPOSITE of the F-YM-CONFLATE row-1/row-2 *separation* the
doc claims it enforces. The separation ("physical piece survives r -> 0, the
regulator does not") is asserted in the docstring but is **not present in the
bundled conjunct**. Until A9 (or the Ask 4 #4 common-model separation) lands,
the capstone enforces F-YM-CONFLATE in prose only.

**Structural risk behind both:** `allMassFromNullEdges` conjoins facts over four
disjoint universes - a 2x2 real matrix (C), the octonion module (co-location), a
Minkowski momentum quadratic form (A), and 4x4 Euclidean gamma algebra (T). No
object carries more than one mode. "Unification" is the label on `<_,_,_,_>`.
Ask 1 is the direct remedy for the T/A pair; A9-common-model is the remedy for
row distinctness.

---

## Ask 3 - What "all mass" CAN and CANNOT mean here

**Strongest defensible CEILING (if the 9 jobs mostly succeed).**
Every *on-ladder* taxonomy row has a kernel-checked finite theorem exhibiting
its mass as a relational obstruction to null transport with no primitive-mass
input: (A) aperture as a frame-invariant kinematic identity
(`compositeMassSq_eq_zero_iff_collinear`); (T) turn at Wilson-Dirac grade
(`chiralOdd/Even_massVertex`, `gamma5_mass_diff_comm`); (C) closure upgraded
from the 2x2 toy to a **physical transfer-operator gap on a connected slab**
(A4/A5 -> NE-U4: "the lightest closed flux composite costs energy" as a
sector-restricted spectral theorem); the four mass functionals proved
**pairwise distinct** (A9); and the octonion charge proved to co-locate, not
couple. This is still an explicit **conjunction of finite identities sharing a
mechanism SHAPE** - NOT a single merged mechanism, NOT the continuum YM gap, NOT
numerical.

**Strongest defensible FLOOR (even if the Q6 crux AND the connected slab both
fail).** Essentially the entire mass thesis survives, because it does not depend
on the hard YM dynamics. `allMassFromNullEdges` already holds today; A9 (mass
taxonomy separation) and Ask-1's aperture=turn bridge are **independent of Q6
and the slab**. So the floor is: three obstruction modes each realized as a
standalone kernel-checked finite/kinematic identity, plus the co-location
negative, plus (reachable without Q6/slab) the functional-distinctness guard and
the T/A binding identity. Defensible one-paragraph floor claim:

> *Mass is not primitive. On a null-transport substrate, every on-ladder mass
> we can exhibit arises as a relational obstruction - aperture (a composite
> fails to point along one null edge), turn (a chirality flip coupling the two
> null movers), or closure (a gauge edge has no single-edge physical state, so
> mass begins at closed flux composites). Each is a kernel-checked finite or
> kinematic identity with zero primitive-mass input; the octonion charge merely
> co-locates on the same spinors without entering the mass. These are distinct
> mechanisms of one shape, kept distinct as theorems (F-YM-CONFLATE); this is
> not the continuum Yang-Mills gap and asserts no numerical value.*

**Strategic consequence.** For the MASS thesis specifically, the hard YM proofs
(Q6 crux, connected slab) buy **surprisingly little**: they gate the *physical*
gap, which is permanently off-ladder anyway. Their payoff is the NE-U4 spectral
*upgrade* of the (C) conjunct (toy -> physical transfer operator), not the
existence of the (C) row. Floor = Ceiling minus (NE-U4 upgrade + any A9
model that needed the slab).

**CANNOT (kill list, unchanged and binding):** numerical mass values/ratios;
continuum masses (QMF8 out); the real-QCD spectral gap (NE-U5/massWithoutMass is
a toy); "Higgs mechanism IS confinement" (Fradkin-Shenker is phase-diagram
connectivity, not mechanism identity); observer-conditioned entropy passed off
as frame-invariant; and - per Ask 2 - any claim that the four conjuncts are one
merged mechanism rather than a conjunction of one shape.

---

## Ask 4 - Ranked wave-2 queue (top 5), assuming the 9 return

EV = expected gain in *honest* all-mass coverage/robustness. Effort is relative
subagent cost. Ranked by EV/effort.

| Rank | Theorem (wave-2) | Trigger condition | EV | Effort | EV/Effort |
|---|---|---|---|---|---|
| 1 | `apertureEqualsTurn_onShell` - 3+1D bridge: two-null aperture mass = Dirac turn amplitude (Ask 1) | none; submit now, independent of all 9 | High (only rung that binds two modes on one object; cures Ask-2 structural risk for T/A) | Med | **Highest** |
| 2 | Q6 downstream unconditional: `kp_convergence_bound_of_selfIncompatible` + `kp_tail_bound` with `hself` threaded, crux discharged | A1 or A2 closes `pairSum_le_expBound` | High (unblocks the entire KP/clustering chain -> NE-U4 spectral path) | Low (assembly; A3 already did the conditional form) | **High** |
| 3 | NE-U4 spectral gap: feed A4 slab -> `rpBlockMatrix` -> sector-restricted `TransferGapDefinition.finiteMassGap` ("lightest closed flux composite costs energy") | A4 connected slab lands | High (upgrades (C) from 2x2 toy to physical transfer op; the one genuine ceiling-vs-floor gain) | High (rides M1/M3; hardest) | Med |
| 4 | Common-model taxonomy separation: the four mass functionals distinct **on one shared finite model family**, not four separate models | A9 returns (esp. if A9 gives the disjoint-model version) | High (converts F-YM-CONFLATE to math; directly cures the Ask-2 (T)-lump and (C)-detachment risks) | Med | High |
| 5 | Fermionic Ward-subtracted `confinementGap` (NE-U5 stretch) | A7 fermionic RP-F minimal fragment lands | Med (a genuine (C)+(T) fermionic gap with regulator SEPARATED, not the toy) | High | Med |

Just off the list (rank 6): NE-U6 smallest provable finite identity (composite
two-point positivity/decay on the Z2/U(1) gauge-Higgs toy), trigger = A8
statement freeze lands - deferred because it opens a new row rather than
hardening the three already load-bearing ones, and it carries the
"Higgs = confinement" kill-condition that must be policed.

---

## Ask 5 - The cheapest kill-test for the thesis

**The test.** Demand a **single finite model** on which two obstruction
functionals - the (C) closure mass and the (A) aperture mass, the pair the doc
claims are *causally* linked ("confinement (closure) forces permanent
non-collinearity (A)") - are the **same number**, and check whether the tree can
produce one.

**Why this is the cheapest and most decisive.** The doc's strongest unification
sentence is the C->A implication. But in the tree, `z2GlueballMass beta =
log coth beta` (`MassWithoutMass.lean:110`) is a transfer-eigenvalue ratio of a
2x2 matrix that contains **no momentum data at all**, while the (A) functional
`minkowskiSq (sum p_i)` (`CompositeApertureMass.lean`) is only defined on
`Momentum4` bundles. The aperture functional **cannot even be evaluated** on the
closure model. So the cheapest kill-test is a one-shot finite check:

> There is no `beta > 0` and no future-null bundle `p : iota -> Momentum4` in
> the Z2 glueball model for which `z2GlueballMass beta = compositeMassSq p`,
> because the Z2 model exposes no `Momentum4` object - the two functionals share
> no domain.

If (as is the case now) you cannot instantiate both functionals on one carrier,
the C->A "forcing" is **asserted, never realized**, and "unification" is a shape
analogy, not a shared mechanism. This is a kernel-checkable NEGATIVE: it costs a
single small model-inspection lemma (or even a `#check` that no `Momentum4`
occurs in the Z2 construction), and it is far cheaper than the A9 four-model
separation while exposing more: A9 shows the functionals are *distinct*; this
test shows they are **not even co-domicilable**, which is precisely what
distinguishes "shared SHAPE" from "one mechanism." Passing it is the honest
verdict; failing it (finding a genuine shared-model coincidence) would be the
first real evidence for unification-as-mechanism and would instantly promote
Ask-1's bridge to the flagship.

---

## One-line custody note

The mass thesis is robust at the floor and does not hinge on Q6 or the slab.
Spend wave-2 budget in this order: bind modes on shared objects (Ask 1, queue
#1), harden distinctness on a shared model (queue #4), and treat the NE-U4
spectral upgrade (queue #3) as the one genuine but expensive ceiling gain -
while keeping the Ask-2 (C)-detachment and (T)-lump caveats visible in the
capstone docstring until #4 lands.
