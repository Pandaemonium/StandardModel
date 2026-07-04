# Aristotle strategy/audit: Q1 actual Wilson cut-plaquette RP assembly

You are acting as a Lean 4 proof-design and semantic-audit partner for the
`PhysicsSM` draft GateYM Yang-Mills ladder. This is a Q1/T1 job: move beyond
the zero-cut doubled-lattice baseline toward the actual cut-plaquette
reflection-positivity statement.

Formatting: ASCII only, LF line endings. In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Current verified state

The live repo has already proved the following Q1/RP-KER substrate:

- `ReflectionPositivityKernel.reflectionForm_nonneg`:
  cut-kernel PSD at every cut configuration implies finite
  Osterwalder-Seiler reflection positivity.
- `ReflectionPositivityKernel.cutKernel_posSemidef_of_factorized`:
  no-cut/factorized weights have PSD cut kernels.
- `ReflectionPositivityKernel.cutKernel_posSemidef_of_mixture`:
  nonnegative mixtures of rank-one factorized kernels have PSD cut kernels.
- `ReflectionPositivityKernel.cutKernel_mul`:
  cut kernels turn pointwise products of reflected weights into Hadamard
  products of cut kernels.
- `ReflectionPositivityKernel.complex_hadamard_posSemidef`:
  complex Schur-product closure for PSD matrices.
- `ReflectionPositivityKernel.cutKernel_mul_posSemidef` and
  `reflectionForm_nonneg_of_mul_posSemidef`:
  two-factor product-weight PSD/RP closure.
- `ReflectionPositivityKernel.cutKernel_finset_prod_posSemidef` and
  `reflectionForm_nonneg_of_finset_prod_posSemidef`:
  finite-product product-weight PSD/RP closure.
- `WilsonWeightPositivity.wilsonKernel_posSemidef`:
  Route-B Wilson one-plaquette kernel PSD for a unitary representation.
- `WilsonReflectionPositivity.doubled_wilson_reflectionForm_nonneg`:
  zero-cut doubled-lattice baseline.
- `WilsonReflectionPositivity.doubledWilsonWeight_eq_ensembleWeight_mirrorConfig`:
  the zero-cut factorized weight equals the genuine two-plaquette
  `PlaquetteEnsemble.weight` at mirror-coordinate configurations.

Honest scope boundary: full RP-LINK is not closed. The remaining Q1
shocking-tier target is an actual reflection geometry with shared cut
variables and cut plaquettes, not the degenerate doubled lattice with
`C := PUnit`.

## Authoritative files to inspect

Please inspect the live files in the submitted project, especially:

```text
PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean
PhysicsSM/Draft/NullEdge/GateYM/WilsonWeightPositivity.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionCore.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionWalk.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionDouble.lean
PhysicsSM/Draft/NullEdge/GateYM/PlaquetteReflection.lean
PhysicsSM/Draft/NullEdge/GateYM/PlaquetteReflectionEnsemble.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionEnsemble.lean
PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionCompatibility.lean
PhysicsSM/Draft/NullEdge/GateYM/MirrorHolonomyResolution.lean
PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionPositivity.lean
PhysicsSM/Draft/NullEdge/GateYM.lean
AgentTasks/fourday-ym-run-2026-07-05/TASK_DIRECTIONS.md
AgentTasks/fourday-ym-run-2026-07-05/PREP_NOTES.md
AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md
AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md
Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md
```

Semantic context pack included:

```text
AgentTasks/context-packs/ym-q1-cut-plaquette-assembly-20260704-20260704-161145.md
```

The context pack is weak for this exact query; use it only as
context-selection evidence. The Lean files and run notes are authoritative.
The local doc-index refresh attempted before submission timed out after about
two minutes, so do not infer missing repo context from that pack alone.

## Task

Produce the next Q1 cut-plaquette assembly artifact. We want the strongest
semantically correct Lean plan that can be attacked next, not a weakened
claim.

Please answer these questions:

1. What is the minimal actual cut geometry that should replace the zero-cut
   doubled lattice for the next theorem? Be explicit about the types that
   should play `A`, `C`, and the mirrored negative-side `A` in
   `ReflectionPositivityKernel`.
2. Can the current `ReflectionCore`/`ReflectionWalk`/`PlaquetteReflection`
   stack express that geometry directly, or is a new finite example module
   needed first? If a new module is needed, give the exact Lean API shape.
3. What should the next public theorem statement be? Please provide Lean-syntax
   theorem signatures for the smallest useful target and the stronger target
   that would close the cut-plaquette layer.
4. How exactly should a single Wilson cut-plaquette factor be identified with
   a PSD kernel consuming `WilsonWeightPositivity.wilsonKernel_posSemidef`?
   Spell out the map from positive/mirrored-negative side variables and cut
   variables to the group elements `g`, `h` in the kernel
   `exp(beta * Re chi(g * h^-1))`.
5. Are the new connector lemmas in `ReflectionPositivityKernel` sufficient for
   finite products of cut-plaquette factors once each single factor is PSD, or
   is another abstract lemma needed?
6. Where does spectral decomposition genuinely enter now that the Schur
   product route is available? Is `cutKernel_posSemidef_of_mixture` still the
   right endpoint, or can Q1 close directly from finite-product PSD plus
   `reflectionForm_nonneg`?
7. Identify any false or convention-mismatched target that should be avoided,
   especially nonabelian mirror-holonomy/conjugation pitfalls already exposed
   by the S3 counterexample in `MirrorHolonomyConjugation.lean`.

## Output format

Return:

1. Verdict: one of `PROCEED`, `PROCEED WITH CHANGES`, or `BLOCKED BY DESIGN`.
2. The recommended next Lean file/module and exact theorem signatures.
3. A proof DAG, with each lemma tagged:
   `prove-now`, `Aristotle-proof`, `needs-new-definition`, `needs-oracle`,
   or `likely-false`.
4. A short explanation of how the new product/Hadamard/PSD connector lemmas
   should be used.
5. Any counterexample or semantic warning that would prevent a stated target.
6. A concise implementation sequence for Codex/Claude after this report.

Do not silently weaken statements. If the actual cut-plaquette RP-LINK target
is not yet expressible with the current APIs, say exactly which definition is
missing and give the smallest honest replacement target.
