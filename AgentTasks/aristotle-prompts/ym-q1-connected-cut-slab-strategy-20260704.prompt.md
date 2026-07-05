# Aristotle strategy/audit: Q1 connected cut-slab geometry after finite family bridge

You are acting as a Lean 4 proof-design and semantic-audit partner for the
`PhysicsSM` draft GateYM Yang-Mills ladder. This is a Q1/T1 job: move from the
now-verified finite disconnected cut-plaquette family toward the connected
Wilson reflection slab / full RP-LINK theorem.

Formatting: ASCII only, LF line endings. In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Current verified state

The live repo has already proved the following Q1/RP-KER substrate:

- `ReflectionPositivityKernel.reflectionForm_nonneg`: cut-kernel PSD at every
  cut configuration implies finite Osterwalder-Seiler reflection positivity.
- `ReflectionPositivityKernel.cutKernel_posSemidef_of_factorized`: no-cut /
  factorized weights have PSD cut kernels.
- `ReflectionPositivityKernel.cutKernel_mul_posSemidef`,
  `reflectionForm_nonneg_of_mul_posSemidef`,
  `cutKernel_finset_prod_posSemidef`, and
  `reflectionForm_nonneg_of_finset_prod_posSemidef`: Schur-product and finite
  product closure for cut kernels.
- `WilsonWeightPositivity.wilsonKernel_posSemidef`: Wilson one-plaquette
  kernel PSD for a unitary representation and `beta >= 0`.
- `WilsonCutPlaquettePositivity.cutKernel_posSemidef_of_wilsonFactor`,
  `reflectionForm_nonneg_of_wilsonFactor_prod`, and
  `reflectionForm_nonneg_of_factorized_mul_wilsonFactor_prod`: any finite
  product of Wilson cut factors, optionally times a factorized positive/mirror
  side contribution, is reflection positive.
- `ReflectionCutPlaquetteExample.lean`: a single concrete four-edge
  cut plaquette with mirror-coordinate holonomy factorization and genuine
  `PlaquetteEnsemble.weight` RP.
- `WilsonCutPlaquetteEnsemble.lean`: the abstract geometry-to-ensemble bridge.
  If a finite plaquette family has mirror-coordinate holonomies
  `(P k).hol (config a c b) = e k c a * (e k c b)^-1`, then the genuine
  Wilson `PlaquetteEnsemble.weight` equals the finite product of Wilson cut
  kernels and is reflection positive, optionally with factorized side weights.
- `ReflectionCutPlaquetteFamily.lean`: a concrete finite disjoint `K`-indexed
  family of geometrically distinct cut plaquettes. It proves:
  `indexedCutPlaqLattice`, `indexedCutPlaqReflection`, `cutPlaquetteAt`,
  `familyMirrorConfig`, `cutPlaquetteAt_hol_familyMirrorConfig`,
  `family_weight_mirrorConfig_eq_wilsonKernel_prod`,
  `family_ensemble_reflectionPositive`, and
  `factorized_mul_family_ensemble_reflectionPositive`.

Honest scope boundary: full RP-LINK is still not closed. The new finite-family
module is disconnected; it does not model a connected Wilson slab where
positive-side, cut, and negative-side links are shared among neighboring
plaquettes.

## Authoritative files to inspect

Please inspect the submitted project files, especially:

```text
PhysicsSM/Draft/NullEdge/GateYM/ReflectionCore.lean
PhysicsSM/Draft/NullEdge/GateYM/PlaquetteCore.lean
PhysicsSM/Draft/NullEdge/GateYM/PlaquetteEnsemble.lean
PhysicsSM/Draft/NullEdge/GateYM/WilsonWeightPositivity.lean
PhysicsSM/Draft/NullEdge/GateYM/WilsonLocalWeight.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean
PhysicsSM/Draft/NullEdge/GateYM/WilsonCutPlaquettePositivity.lean
PhysicsSM/Draft/NullEdge/GateYM/WilsonCutPlaquetteEnsemble.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionCutPlaquetteExample.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionCutPlaquetteFamily.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionDouble.lean
PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionPositivity.lean
PhysicsSM/Draft/NullEdge/GateYM/MirrorHolonomyConjugation.lean
PhysicsSM/Draft/NullEdge/GateYM.lean
AgentTasks/fourday-ym-run-2026-07-05/RUN_PLAN.md
AgentTasks/fourday-ym-run-2026-07-05/TASK_DIRECTIONS.md
AgentTasks/fourday-ym-run-2026-07-05/PREP_NOTES.md
AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md
AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md
Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md
```

## Task

Produce the next semantically correct Q1 construction plan beyond
`ReflectionCutPlaquetteFamily.lean`. Do not weaken RP-LINK by treating the
disconnected family as the final Wilson slab. We want either a concrete Lean
module plan that should be implemented next, or a precise reason the current
interfaces cannot yet express the target.

Please answer:

1. What is the smallest CONNECTED cut-bearing reflection lattice that should
   replace the disconnected `K`-indexed family? Give explicit vertex/edge
   types, reflection map, positive/cut/negative link classification, and
   plaquette family.
2. What should `A`, `C`, and mirrored negative-side `A` be in
   `ReflectionPositivityKernel` for that connected geometry?
3. Can the connected geometry's mirror-coordinate map be a full equivalence
   `LinkField ≃ A × C × A`, or should it initially be a parametrizing map
   `config : A -> C -> A -> LinkField` plus a later bijectivity theorem?
   Explain the minimum honest theorem.
4. For each cut plaquette in the connected geometry, can its holonomy be put in
   the symmetric read-off form required by
   `WilsonCutPlaquetteEnsemble.reflectionPositive_of_hol_factorization`:
   `e k c a * (e k c b)^-1`? Provide the exact proposed `e`.
5. Which same-side / no-cut plaquette factors are genuinely factorized as
   `h a c * star (h b c)`, and what theorem should combine them with the cut
   plaquette factors?
6. Provide Lean-syntax theorem signatures for:
   - the smallest connected-geometry holonomy-factorization theorem;
   - the connected Wilson `PlaquetteEnsemble.weight` RP theorem;
   - the stronger RP-LINK theorem, if distinct.
7. Identify any likely false target or convention mismatch, especially
   nonabelian mirror-order mistakes. The S3 counterexample in
   `MirrorHolonomyConjugation.lean` is authoritative: do not rely on raw
   mirror holonomy being conjugate to the original plaquette.

## Output format

Return:

1. Verdict: `PROCEED`, `PROCEED WITH CHANGES`, or `BLOCKED BY DESIGN`.
2. Recommended next Lean file/module and exact theorem signatures.
3. Definition DAG, including each new type/def/lemma and whether it is
   `prove-now`, `Aristotle-proof`, `needs-new-definition`, `needs-oracle`, or
   `likely-false`.
4. Proof strategy for the connected holonomy factorization and the RP theorem.
5. Semantic warnings and claim-language boundaries.
6. A concise implementation sequence for Codex/Claude.

If you can prove a small standalone connected example within the submitted
project, include Lean code in the response. If a full proof is too large, prefer
an exact typechecking theorem skeleton with a detailed proof DAG over vague
advice.
