# Aristotle proof job: pairwise-disjoint Pluecker layer cone

Name this project `codex-pub-e-layer-cone-20260711`.

Run only:

```text
lake env lean AgentTasks/aristotle-targets/PlueckerLayerCone.lean
```

Prove the one-layer and depth-by-layers support theorems over the imported
sequential geometric cone.  The load-bearing fact is that pairwise-disjoint
blocks which can affect the current region may all be added within one
neighborhood expansion; gates disjoint from the region commute exactly and do
not enlarge it.

Do not replace `LayerDisjoint` by a weaker condition or count gates instead of
layers.  If the theorem is false because a later gate in the same disjoint
layer can touch support created by an earlier gate, explain why pairwise
disjointness does or does not prevent this and return the smallest corrected
hypothesis or counterexample.

Add an outside-cone graded-commutation corollary if the existing parity API is
sufficient.  Ordinary commutation is permitted only when parity justifies it.
Do not claim Hilbert-space unitarity, cone sharpness, a Hamiltonian flow,
scattering, or continuum causality.

```yaml
aristotle:
  project_id: 63b8418b-4933-4aeb-9b4e-678abd5722de
  task_id: caf5139e-00c9-4ad2-b399-70d0a33300c1
  target_file: AgentTasks/aristotle-targets/PlueckerLayerCone.lean
  expected_module: review/target
  submission_project: AgentTasks/aristotle-submit/codex-pub-e-layer-cone-20260711-project
  output_dir: AgentTasks/aristotle-output/63b8418b-4933-4aeb-9b4e-678abd5722de
  status: integrated-local-completion
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

At 07:56 PDT Codex downloaded an in-progress snapshot. Aristotle had correctly
isolated the two load-bearing combinatorial helpers but all three proof
obligations remained open. Codex sent an instruct-mode continuation with the
exact induction: pairwise disjointness plus `reachCone_subset_coneRegion`
prevents a same-layer gate from chaining off tail-created support, after which
the layer-schedule theorem follows from `ballIter` recursion. No snapshot result
was landed at that time.

At 08:34 PDT a delegated local proof pass completed both combinatorial helpers,
the one-layer theorem, and the arbitrary layer-schedule theorem without
weakening `LayerDisjoint`. The target compiled directly and was integrated as
`PhysicsSM/Draft/NullEdge/PlueckerLayerCone.lean`. The remote Aristotle project
was still running, so the landed proof provenance is local composition over
the imported sequential cone rather than a claimed remote completion.
