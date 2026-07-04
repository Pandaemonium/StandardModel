# Aristotle semantic red-team: T1 zero-cut Wilson RP strong tier

You are acting as a semantic red-team reviewer for a Lean 4 mathematical
physics formalization.  This is not primarily a proof-search job.  The goal is
to audit whether the recently integrated Q1/T1 claim language matches the
kernel-checked statements.

Formatting: ASCII only, LF line endings.  In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Context

Project: `PhysicsSM`, draft GateYM Yang-Mills ladder.

Recent commit `1acf4f2` integrated Aristotle project `e6e46e9f` and changed the
T1 reflection convention:

- `ReflectionCore.reflectLinkField` now uses Route B:
  `(theta U) e = (U (reflectE e))^{-1}`.
- `PlaquetteReflection.hol_mirrorPlaquette_eq_inv` is now a same-group
  identity, not a `MulOpposite` workaround.
- `MirrorHolonomyResolution.lean` proves the general
  independent-configuration Wilson mirror-weight identity.
- `WilsonReflectionPositivity.lean` proves
  `doubledWilsonWeight_eq_ensembleWeight_mirrorConfig`, identifying the
  factorized `doubledWilsonWeight` with the genuine two-plaquette
  `PlaquetteEnsemble.weight` at `mirrorConfig a b`.

The current intended claim is:

```text
T1 zero-cut tier is closed: baseline factorized RP-KER instance plus genuine
two-plaquette ensemble-weight identification at mirror-coordinate
configurations.

T1 full RP-LINK is NOT closed: the nontrivial cut-plaquette/shocking tier
still needs an actual reflection geometry with shared cut variables and a
mixture/PSD kernel proof, likely through
ReflectionPositivityKernel.cutKernel_posSemidef_of_mixture.
```

## Files to Inspect

Please inspect at least:

```text
PhysicsSM/Draft/NullEdge/GateYM/ReflectionCore.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionWalk.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionDouble.lean
PhysicsSM/Draft/NullEdge/GateYM/PlaquetteReflection.lean
PhysicsSM/Draft/NullEdge/GateYM/PlaquetteReflectionEnsemble.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionEnsemble.lean
PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionCompatibility.lean
PhysicsSM/Draft/NullEdge/GateYM/MirrorHolonomyConjugation.lean
PhysicsSM/Draft/NullEdge/GateYM/MirrorHolonomyResolution.lean
PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionPositivity.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean
PhysicsSM/Draft/NullEdge/GateYM.lean
AgentTasks/paper-units/reflection-positivity-outline.md
AgentTasks/fourday-ym-run-2026-07-05/DAY_1_REPORT.md
AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md
```

Semantic preflight context pack included in the submission:

```text
AgentTasks/context-packs/ym-t1-strong-redteam-20260704-142346.md
```

Use that pack only as context-selection evidence; the Lean files and run notes
are authoritative.

## Questions

1. Does the theorem
   `doubledWilsonWeight_eq_ensembleWeight_mirrorConfig` actually identify the
   factorized weight used in `doubled_wilson_reflectionForm_nonneg` with the
   genuine two-plaquette `PlaquetteEnsemble.weight` at
   `mirrorConfig a b`, under the stated unitary-representation hypotheses?
   Check for hidden restrictions such as `PUnit`, `Bool` family order,
   casts from real to complex, or the negative side being pre-inverted.
2. Does the Route-B convention in `reflectLinkField` remain an involutive
   reflection of configuration space and does it correctly support the
   same-group holonomy identities in `ReflectionWalk`, `PlaquetteReflection`,
   and `MirrorHolonomyResolution`?
3. Is the updated claim boundary honest?  In particular, is it correct to say
   "zero-cut baseline plus ensemble-identification tier closed" while still
   refusing to claim full RP-LINK / cut-plaquette reflection positivity?
4. Are any docs still stale or over-claiming after the local claim-language
   sync, especially `GateYM.lean`, `DAY_1_REPORT.md`, and
   `reflection-positivity-outline.md`?
5. Are there any semantic mismatches caused by the migration away from
   `MulOpposite`/`rhoOppositeInv`, for example in
   `WilsonReflectionCompatibility.lean` or ensemble reflection wrappers?

## Output Format

Return a concise audit report with:

1. Verdict: ACCEPT, ACCEPT WITH CHANGES, or REJECT.
2. Findings ordered by severity, with file/theorem references.
3. Any exact claim-language corrections needed.
4. Any Lean-level theorem statement that should be added next to prevent
   future over-claiming.
5. Recommended next Q1 step: cut-plaquette geometry design, kernel-mixture PSD
   proof package, documentation cleanup, or park.

Do not weaken Lean theorem statements silently.  If you find a semantic
counterexample or a hidden restriction, state it plainly.  If the result is
only a zero-cut well-definedness/consistency witness, say exactly that; if the
new ensemble-identification theorem justifies a stronger zero-cut claim than
the older docs allowed, say that too.
