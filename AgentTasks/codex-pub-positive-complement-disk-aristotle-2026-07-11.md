# Aristotle: rational disk of positive complements in the live carrier

## Objective

Close every proof hole in
`PhysicsSM/Draft/NullEdge/ChannelPositiveComplementDisk.lean` without changing
definitions or theorem statements. Run the narrow target first:

```text
lake env lean PhysicsSM/Draft/NullEdge/ChannelPositiveComplementDisk.lean
```

This is an ambitious Paper F classification target. It must prove:

1. the exact bilinear six-coordinate Krein Gram formula;
2. the exact metric on the four-coordinate family indexed by `(u,v)`;
3. strict positivity for every rational point of the open unit disk;
4. uniqueness of all four coordinates in a fixed family;
5. containment of the three live named even channels in every family;
6. distinct disk points define distinct represented families;
7. every positive even Krein-self-adjoint vector orthogonal to the three named
   channels has a unique disk coordinate and nonzero scale;
8. an interior positive witness and a null unit-circle boundary control.

The statements typecheck locally under the pinned project. Do not replace the
unique normal form by mere existence, drop the named-channel containment, or
remove the boundary control. No compiled-evaluator proof, new assumptions,
unsafe declarations, or opaque placeholders. If any statement is false, return
an exact counterexample and the smallest corrected theorem.

Semantic boundary: this classifies a rational disk of represented positive
complements inside one supplied `(4,2)` carrier. Positive-subspace orbit
geometry is standard Krein theory. The result does not select a physical disk
point, prove the boost fixes the complete carrier datum, or define the final
gauge/carrier equivalence quotient.

```yaml
aristotle:
  project_id: ef95daca-28e5-4385-80f3-86b34163295b
  target_file: PhysicsSM/Draft/NullEdge/ChannelPositiveComplementDisk.lean
  expected_module: PhysicsSM.Draft.NullEdge.ChannelPositiveComplementDisk
  submission_project: AgentTasks/aristotle-submit/codex-pub-positive-complement-disk-20260711-project
  output_dir: AgentTasks/aristotle-output/ef95daca-28e5-4385-80f3-86b34163295b
  status: locally-landed-remote-running
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

Submission note: the slim-package helper prepared the target but returned its
known nonfatal Sphere-Packing patch check because this checkout has no active
Sphere-Packing dependency. The target itself typechecked locally with the
twelve declared proof holes and no statement errors before submission.

At 06:02 PDT the live target was landed. The pre-freeze Aristotle snapshot
supplied eleven proof components; Codex completed the unchanged unique
normal-form theorem locally, then added per-module and aggregate standard-three
guards. Direct and aggregate builds pass (8,177 jobs). The remote task remains
only an independent route; the locally audited source is canonical.
