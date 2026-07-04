# Aristotle formalization-design job: redesign the mirror/reflection convention to fix N3

You are acting as both a formalization designer and prover for a Lean 4
project (PhysicsSM, a Standard-Model-physics formalization repo). This is
an ambitious, multi-file redesign task, not a single focused lemma - please
treat it accordingly: think about architecture first, then implement.

Formatting: ASCII only, LF line endings. Spaced escape-hatch tokens in
prose (`s o r r y`, `a x i o m`).

IMPORTANT ON BUILD BUDGET: do NOT start with a full `lake build` of the
whole `PhysicsSM` tree - that will burn the budget before proof search
starts. Instead run targeted checks first:

```
lake env lean PhysicsSM/Draft/NullEdge/GateYM/ReflectionCore.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.ReflectionCore
lake env lean PhysicsSM/Draft/NullEdge/GateYM/ReflectionWalk.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.ReflectionWalk
lake env lean PhysicsSM/Draft/NullEdge/GateYM/ReflectionDouble.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.ReflectionDouble
lake env lean PhysicsSM/Draft/NullEdge/GateYM/PlaquetteReflection.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.PlaquetteReflection
lake env lean PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionCompatibility.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.WilsonReflectionCompatibility
lake env lean PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionPositivity.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.WilsonReflectionPositivity
```

Only run the full aggregate build
(`lake build PhysicsSM.Draft.NullEdge.GateYM`) once your redesign
typechecks at the targeted level above.

## Background: what N3 just refuted

We are formalizing Osterwalder-Seiler link-reflection positivity for the
Wilson lattice gauge action. The relevant files (all in
`PhysicsSM/Draft/NullEdge/GateYM/`) build a "reflection" abstraction: an
oriented lattice `Lambda`, an involutive vertex/edge reflection map
`Reflection Lambda`, a pullback action on link fields `reflectLinkField`,
a step-level and walk-level "mirror" operation (`reflectStep`,
`mirrorWalk`), and a "mirror plaquette" operation
(`PlaquetteReflection.mirrorPlaquette`) used to build a genuine two-copy
"doubled lattice" reflection-positivity instance
(`WilsonReflectionPositivity.lean`).

We just ran a focused Aristotle strategy job (project `0a46d515`,
integrated as `MirrorHolonomyConjugation.lean`, attached below) that
PROVED, via an explicit `S3` counterexample, that the current
`mirrorPlaquette` construction's raw holonomy word is, in general, NEITHER
conjugate to the original plaquette holonomy NOR to its inverse, for
nonabelian gauge groups. Root cause (from that job's analysis, confirmed
by reading the actual Lean source): `ReflectionWalk.reflectStep` reverses
step ORDER but does NOT swap the `fwd`/`rev` step tags, so
`mirrorPlaquette`'s holonomy is a pure WORD REVERSAL of the original
(same letters, reversed order, none inverted) - not the group INVERSE
(which would invert AND reverse). Pure word reversal is not a
conjugacy-class invariant for words of length >= 3 in a nonabelian group,
so the Wilson-weight identity `w(mirror holonomy) = w(original holonomy)`
that the reflection-positivity argument needs is FALSE for the current
construction, except in special degenerate cases (abelian `G`, or the
already-proved "zero-cut" doubled-lattice baseline, where the relevant
group action happens to be abelian/trivial and the issue never surfaces).

`ReflectionCore.lean`'s own module docstring already flags the relevant
design choice as provisional: `reflectLinkField U e := U (reflectE e)` is
a "direct pullback, NO extra group-inverse twist," explicitly called out
as "a design CHOICE, not a derived necessity - a future presentation with
a different `reflectE` convention might need the inverse variant
instead." The fix needs exactly that inverse variant, or an equivalent
fwd/rev tag swap in `reflectStep`.

## The task

Redesign the reflection/mirror convention so that the GENUINE mirror
plaquette's holonomy, evaluated at an INDEPENDENT (not necessarily
reflection-derived) link-field configuration `b`, is the GROUP INVERSE of
the original plaquette's holonomy at `b` (or at least always CONJUGATE to
it, or otherwise trace-equal for unitary representations) - not merely a
reversed, uninverted word. Concretely, pick exactly ONE of these two
routes (do not apply both; combining them double-inverts and reintroduces
a bug):

**Route A (recommended first attempt): swap `fwd`/`rev` in `reflectStep`.**
Change `ReflectionWalk.reflectStep` so it sends `Step.fwd e` to
`Step.rev (reflectE e)` and `Step.rev e` to `Step.fwd (reflectE e)`
(currently it preserves the tag). CONFIRMED: `GaugeCoreGeneral.lean`
ALREADY has exactly this tag-swapping operation built and proved -
`Step.reverse`/`Walk.reverse`, with `stepHol_reverse : stepHol U
(Step.reverse s) = (stepHol U s)^-1` and `hol_reverse : hol U
(Walk.reverse w) = (hol U w)^-1` already kernel-checked (see the attached
`GaugeCoreGeneral.lean`). Route A should therefore most naturally be
phrased as: redefine `reflectStep` to be (up to the endpoint-cast
bookkeeping) `reflectE` composed with `Step.reverse`, i.e. the mirror
operation becomes "reflect the edge label AND apply the ordinary
tag-reversal", and `mirrorWalk` should become (up to reversing the
overall step order it already does) closely related to
`Walk.reverse` composed with a per-step `reflectE` relabeling. Use the
already-proved `stepHol_reverse`/`hol_reverse` identities directly rather
than re-deriving the `(stepHol U s)^-1` fact from scratch. Work through
the consequences:
- `ReflectionCore.stepHol_reflectLinkField_fwd`/`_rev` (single-step
  compatibility) will need their RHS `fwd`/`rev` swapped, OR
  `reflectLinkField` itself may need to change instead (see Route B) -
  determine which single change makes the existing proofs (`rfl` in the
  current file) still go through, or closest to going through.
- `ReflectionWalk.stepHol_reflectLinkField_reflectStep`,
  `stepHol_opLinkField_reflectStep`, `mirrorWalk`,
  `op_hol_reflectLinkField_mirrorWalk` all reference `reflectStep` and
  will need to be re-checked/re-proved against the new definition.
- `PlaquetteReflection.mirrorPlaquette` is DEFINED in terms of
  `reflectStep`, so it updates automatically; its downstream lemmas
  (`mirrorPlaquette_walk`, `op_hol_reflectLinkField_mirrorPlaquette`,
  `localWeight_hol_reflectLinkField_mirrorPlaquette`,
  `productWeight_reflectLinkField_mirrorPlaquette`, and the
  mirror-stable/paired-family theorems) need to be re-verified.
- `WilsonReflectionCompatibility.rhoOppositeInv` and its lemmas may or may
  not still be the right bridge - re-derive as needed.
- `WilsonReflectionPositivity.mirrorPlaquette_liftPlaquettePos_hol` is the
  specific lemma the T1 baseline construction depends on; after the
  redesign, this lemma (or its replacement) should ALSO hold for
  INDEPENDENT (non-reflection-derived) configurations `a, b`, which is the
  actual open gap - not just for reflection-derived `U`, which is all the
  CURRENT proof covers (see "What this does NOT prove" in that file's
  docstring, attached below).

**Route B (alternative): keep `reflectStep` tag-preserving, but change
`ReflectionCore.reflectLinkField` to include an inverse:**
`reflectLinkField U e := (U (reflectE e))^-1`. Work through the same
downstream consequences as Route A, but starting from this single-point
change instead.

Pick whichever route requires the smaller, cleaner set of downstream
changes; if both are comparably invasive, prefer whichever produces
lemma statements that read more naturally (e.g. if Route A makes
`mirrorPlaquette`'s holonomy come out to LITERALLY the syntactic inverse
of the original in the cleanest cases, prefer it).

## Success criteria

1. All the listed files above still typecheck (targeted `lake env
   lean`/`lake build` commands, not a full build first).
2. The key new or corrected lemma: for an INDEPENDENT
   `a b : L0.LinkField G` (using `WilsonReflectionPositivity.lean`'s own
   notation), the genuine mirror plaquette's Wilson weight (for a unitary
   representation `rho`) at `b` equals the original plaquette's Wilson
   weight at `b` - i.e. the twist is resolved for the GENERAL case, not
   just reflection-derived configurations. State this precisely as a new
   theorem (name it something like `mirrorPlaquette_wilsonWeight_eq` or
   similar) and either prove it or, if it remains open for a specific
   documented reason, explain exactly why and what is still missing.
3. Do NOT weaken any existing theorem statement to make this easier. If a
   currently-proved lemma becomes FALSE under the new convention, say so
   explicitly and propose the corrected replacement statement rather than
   silently deleting or watering it down.
4. If, after genuine effort, the full redesign is not achievable in this
   session, prioritize: (a) the corrected `reflectStep`/`reflectLinkField`
   definition and single-step compatibility lemmas (smallest, most
   valuable layer), with the walk/plaquette/Wilson layers left as
   documented `s o r r y` handoffs with a clear note of exactly what
   changed and what remains; over (b) a fully working proof of only some
   of the layers with the others silently unexamined.

## Output format

1. Which route (A or B) you chose and why.
2. The full corrected Lean source for each changed file (or a unified
   diff against the attached originals), with all downstream lemmas
   either proved or left as documented `s o r r y` handoffs.
3. The new key theorem (item 2 of "Success criteria") - proved, or an
   honest report of exactly what blocks it.
4. A short list of every theorem statement whose meaning changed
   (not just its proof), so the parent project can review for semantic
   drift before integrating anything.
5. Verification commands actually run and their results.

## Attached source files (verbatim, current state)

The following files are copied into this submission's project directory
under the SAME relative paths as the live repo
(`PhysicsSM/Draft/NullEdge/GateYM/...`), so you can edit them in place and
run the exact `lake env lean`/`lake build` commands above:

- `PhysicsSM/Draft/NullEdge/GateYM/GaugeCoreGeneral.lean` (base oriented-lattice/Step/Walk API)
- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionCore.lean` (the `Reflection` structure, `reflectLinkField`, single-step compatibility)
- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionWalk.lean` (`reflectStep`, `mirrorWalk`, `opLinkField`, walk-level compatibility)
- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionDouble.lean` (the doubled-lattice concrete `Reflection` instance used by T1's baseline)
- `PhysicsSM/Draft/NullEdge/GateYM/PlaquetteCore.lean` (the `Plaquette` structure and `productWeight`)
- `PhysicsSM/Draft/NullEdge/GateYM/PlaquetteReflection.lean` (`mirrorPlaquette` and its product-weight lemmas)
- `PhysicsSM/Draft/NullEdge/GateYM/PlaquetteReflectionEnsemble.lean` (ensemble-level wrappers)
- `PhysicsSM/Draft/NullEdge/GateYM/WilsonLocalWeight.lean` (the Wilson local weight function and its symmetries)
- `PhysicsSM/Draft/NullEdge/GateYM/WilsonWeightPositivity.lean` (Wilson kernel PSD, character reality facts)
- `PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionCompatibility.lean` (`rhoOppositeInv`, the current Wilson/opposite-group bridge)
- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean` (the abstract RP-KER master lemma this all feeds into)
- `PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionPositivity.lean` (the T1 baseline construction that needs the general-case fix)
- `PhysicsSM/Draft/NullEdge/GateYM/MirrorHolonomyConjugation.lean` (the N3 negative result: the counterexample this redesign must fix)
- `PhysicsSM/Draft/NullEdge/GateYM/Theorem2AreaLaw.lean` (dependency of `WilsonReflectionPositivity.lean`; only needed for typechecking, not part of the redesign)

## Guardrails

This is finite lattice-gauge-theory formalization ("finite identity"
scope); nothing about physical mass gaps, continuum limits, or infinite
volume. Do not introduce `a x i o m`, `o p a q u e`, or
`n a t i v e _ d e c i d e`. `s o r r y` is fine for a genuinely
remaining gap IF documented with a clear handoff note (current goal,
what was tried, suspected missing lemma). Do not silently change
Fano-plane-style sign/orientation conventions elsewhere in the project;
this task is scoped strictly to the reflection/mirror machinery listed
above. If you determine partway through that NEITHER route A nor B
actually closes the general (independent-configuration) case - i.e. the
gap is deeper than a tag-swap - report that plainly with your best
diagnosis of what IS needed, rather than forcing a redesign that doesn't
actually fix the problem.
