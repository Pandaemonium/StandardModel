# Hostile semantic audit — Ward graded-frame decoration (2026-07-11)

Scope of audit: the three verbatim files
`WardAutomorphismQuotient.lean`, `WardQuotientFactorization.lean`,
`WardGradedFrameDecoration.lean`. No new proofs were added; this is a read-only
semantic + build audit.

## VERDICT: FAIL (recoverable to PASS WITH REQUIRED EDITS)

The delivered artifact does **not** verify the intended claim. Two of the three
files do not compile, and the "physical compression is complete" premise on
which the whole narrative rests depends on a module that is not present in the
repository. The mathematical narrative is *true* where it is checked, but only
one of the three files (`WardAutomorphismQuotient`) is actually machine-checked;
the frame-decoration theorem and its supporting completeness theorem are
unverified as delivered.

---

## S0 — BLOCKER: two of three files do not build; a key dependency is absent

- `lake build` fails: `WardGradedFrameDecoration.lean:1` and
  `WardQuotientFactorization.lean:1` both error `unknown module prefix
  'PhysicsSM'`. Only `WardAutomorphismQuotient.olean` exists; the other two carry
  `.trace.nobuild` (never successfully built).
- Cause 1 (superficial): imports use the logical path
  `PhysicsSM.Draft.NullEdge.Carrier.Ward…`, but the lake libs expose the modules
  as bare `WardAutomorphismQuotient` / `WardQuotientFactorization`.
- Cause 2 (substantive): `WardQuotientFactorization.lean` imports
  `…Carrier.WardPhysicalCohomology` and uses `KugoOjima.Qmat` and
  `WardPhysicalCohomology.ward_zero_physical_iff_nullHomotopic`. **No such file
  exists anywhere in the project.** The core lemma turning "zero physical action"
  into "constraint null-homotopy" is an un-included, un-audited black box.

Consequence: the sentence in `WardGradedFrameDecoration`'s header — "Physical-line
compression completely classifies charge-commuting maps modulo constraint
homotopy in `WardQuotientFactorization`" — is **not substantiated inside the
delivered files**. Everything the decoration is claimed to *refine* is unproved
here.

Aggravating: every file ends with `#print axioms` / `#guard_msgs` "build-enforced
pins." These pass only if the file builds. For the two non-building files the
pins are inert, so a casual reader sees "axioms: [propext, Classical.choice,
Quot.sound]" advertised for theorems that were never checked. This is misleading
provenance decoration.

## S1 — MAJOR: the frame result is largely hollow coordinate repackaging

The mathematics, where checkable, is correct and non-vacuous, but the *scientific
content* of the decoration is thin:

- `nullI`/`nullP` are the literal coordinate selectors for slots 0,1;
  `nullFrameAction U = nullP·U·nullI` is just "the top-left 2×2 block."
- On the graded charge-commuting family the matrix is forced to
  `!![a,b,0; 0,a,0; 0,0,e]` (via `wardFamily_preservesGrading_iff`), i.e. three
  free scalars `a,b,e`. `decoratedAction` records `(e, !![a,b;0,a])` — literally
  every nonzero entry, with `a` recorded twice. So
  `eq_iff_same_decoratedAction_of_graded_chain` ("complete literal invariant") is
  true, but true *because the decoration re-reads the whole matrix*. The word
  "literal" in the docstring is honest; the completeness is close to tautological.
- The "obstruction," `exact_shear_changes_nullFrame`, says the shear parameter
  `b = i` lives in the retained block and is therefore visible once you retain
  that block. Physical compression keeps only slot 2 (`e`) and discards slots
  0,1 (the constraint block); the decoration keeps them back. "Retaining the
  coordinates you just discarded distinguishes maps that differed only in those
  coordinates" is not a substantive refinement.
- The null frame is **supplied, not derived** — the files say so explicitly
  ("The null frame is supplied, not derived from graph locality or continuum
  soldering"). Nothing forces the ordering (0 before 1) or the choice of slots;
  they are put in by hand. There is no locality, soldering, gauge, or graph
  datum pinning the frame.

Net: as stated this is a correct but near-trivial coordinate bookkeeping result,
not a structural discovery. It should not be presented as more.

## What is actually sound (PASS component)

`WardAutomorphismQuotient.lean` builds and is clean (no `sorry`, no extra
axioms). Within it:
- `commutes_Q_iff_family`, `wardFamily_kreinUnitary_iff`,
  `wardAutomorphism_classification` — correct classification of the concrete
  3×3 witness. The docstring/scope honestly restricts to the 3-dim witness and
  disclaims graph/locality/soldering/gauge/grading/Clifford structure.
- The Krein correction is handled honestly: the original `U†GU = 1` is documented
  as false and replaced by the standard `U†GU = G`.
- `nontrivial_exact_shear_witness` (shear is a Ward automorphism, ≠1, physically
  identity, constraint-exact) and `physical_phase_not_exact_control` (a genuine
  phase is *not* constraint-exact) are both verified. The negative control is the
  strongest content here: it shows constraint-exactness is a non-trivial
  equivalence, so the witness narrative is non-vacuous.

The intended claim is therefore mathematically true; the failure is that its two
load-bearing files are unverified and one leans on an absent lemma, plus the
frame refinement is oversold.

## Hidden assumptions / overclaim summary

- Hidden dependency: `WardPhysicalCohomology.ward_zero_physical_iff_nullHomotopic`
  and `KugoOjima.Qmat` (absent) — the completeness half of the story.
- Supplied (not derived) data: `grading`, `nullI`, `nullP`, and their ordering.
- No overclaim of "full decorated-carrier classification" — the files correctly
  disclaim it. Good. (This audit likewise does **not** call it one.)

---

## REQUIRED EDITS (to reach PASS WITH REQUIRED EDITS)

1. **Make it build.** Either add the lake libs/module paths so
   `PhysicsSM.Draft.NullEdge.Carrier.*` resolves, or change the imports to the
   bare module names. **Include `WardPhysicalCohomology.lean` (with
   `ward_zero_physical_iff_nullHomotopic` and `KugoOjima.Qmat`)**, or the two
   dependent files remain unverified. Do not rely on the `#print axioms` pins
   until the files compile.

2. **Replace the completeness-premise prose** in `WardGradedFrameDecoration.lean`
   header. Current: "Physical-line compression completely classifies
   charge-commuting maps modulo constraint homotopy in
   `WardQuotientFactorization`."
   Replacement:
   > "In `WardQuotientFactorization` (which depends on the separate
   > `WardPhysicalCohomology` module, not included in this three-file bundle),
   > equality of physical-line action is shown equivalent to constraint
   > null-homotopy for charge-commuting maps. That completeness result is *not*
   > re-verified here and is assumed as an external input."

3. **Down-rate the refinement prose** so it is not read as structural. Current
   title "A graded null-frame decoration refines the finite Ward quotient" and
   "complete literal invariant."
   Replacement docstring sentence for
   `eq_iff_same_decoratedAction_of_graded_chain`:
   > "On the graded charge-commuting family the map is determined by three
   > scalars `a,b,e`; `decoratedAction` records all three (the physical scalar
   > `e` plus the 2×2 constraint block `!![a,b;0,a]`). Completeness here is
   > literal coordinate read-off, not an intrinsic invariant: the null frame and
   > its ordering are supplied by hand, not derived from any locality, soldering,
   > or graph datum."

4. Add an explicit `variable`/hypothesis or comment marking the absent
   completeness lemma as an assumption if the module is kept as a stub, rather
   than importing a non-existent file.

---

## Smallest graph-derived / locality / soldering successor

The one small step that converts "hollow repackaging" into genuine content is to
**derive the null frame from `Q` instead of supplying it, and pin its ordering by
a soldering condition.** Concretely, `Q = !![0,1,0;0,0,0;0,0,0]` gives
`im Q = span e₀`, and `e₁` is a `Q`-section (`Q e₁ = e₀`). So slots 0,1 are not
arbitrary — they are the `Q`-soldering flag `im Q ⊂ ker(physical projection)`.

Minimal successor lemma (provable, tiny — no new theory):

> For charge-commuting `U`, `nullFrameAction U` commutes with the restricted
> charge `nullP·Q·nullI = !![0,1;0,0]`; equivalently every attainable
> `nullFrameAction` is a `Q`-intertwiner `!![a,b;0,a]`. Pin the frame ordering by
> the soldering requirement `nullP·Q·nullI = !![0,1;0,0]` (frame-vector 1 ↦
> frame-vector 0 under `Q`). Then the decoration is the pair (physical scalar,
> `Q`-equivariant block) with the block derived from `Q`'s own action rather than
> from a coordinate choice, and `b` becomes the soldering pairing between the
> `Q`-section and `im Q` rather than "entry (0,1)."

Check (by hand): `!![a,b;0,a]·!![0,1;0,0] = !![0,a;0,0] = !![0,1;0,0]·!![a,b;0,a]`
— commutes; and any 2×2 commuting with the nilpotent Jordan block is exactly
`!![a,b;0,a]`. So the retained block is precisely the space of `Q`-intertwiners on
the flag, which is a `Q`-derived (hence graph/soldering-motivated) object rather
than an arbitrary slice. This is the smallest edit that makes the frame decoration
non-tautological; a full graph-locality/continuum-soldering derivation of the
frame remains future work and is **not** claimed here.

## Codex integration response

The S0 build failure is specific to the incomplete standalone audit bundle:
the live repository contains `WardPhysicalCohomology.lean`, and both the
targeted module and aggregate guard built before submission. The bundle should
have included that transitive dependency. The semantic criticism remains
valid. The live module was therefore down-rated from structural completeness
to literal coordinate read-off, and the proposed successor was implemented as
`restrictedCharge_eq`,
`nullFrameAction_commutes_restrictedCharge_of_chain`, and
`commutes_restrictedCharge_iff`. These prove in the live kernel that the
retained block is exactly an intertwiner of the nilpotent charge on its
two-step flag. No graph-locality or continuum-soldering claim was added.
