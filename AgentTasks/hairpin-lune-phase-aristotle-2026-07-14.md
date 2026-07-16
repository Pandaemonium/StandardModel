# Aristotle job: hairpin lune phase witnesses (spiral-layer wave 1, job C)

Date: 2026-07-14
Requested by: user ("submit a round of Aristotle jobs" for the spiral-layer
targets from the 2026-07-14 zigzag-vs-spiral analysis session).

```yaml
aristotle:
  project_id: 0e4a3f50-4bad-4d01-ae49-32c6cef117b5
  task_id: 5310038f-a2ce-4794-af13-ada77fa5dccf
  target_file: AgentTasks/aristotle-standalone/hairpin-lune-phase-20260714/HairpinLuneCore/HairpinLunePhase.lean
  expected_module: HairpinLuneCore.HairpinLunePhase
  submission_project: AgentTasks/aristotle-submit/hairpin-lune-phase-20260714-project
  source_root: AgentTasks/aristotle-standalone/hairpin-lune-phase-20260714
  output_dir: AgentTasks/aristotle-output/0e4a3f50-4bad-4d01-ae49-32c6cef117b5
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/HairpinLunePhaseAristotle.lean
```

## Goal

Rational (2x2 over Q) witnesses that the 1+1 checkerboard's corner factor i
is the fossil of a handed spiral regularization of the hairpin: the
four-corner Bargmann invariant for a hairpin pair resolved through antipodal
meridians (z -> x -> -z -> -x, closed great circle, solid angle 2 pi) is
-1/4 (sign = geometric phase, matching i^2 = -1 for two corners), while the
zero-lune same-meridian backtrack gives +1/4, and the magnitude 1/4
factorizes into the two free-bend factors (1/2)*(1/2). The general law
phase = exp(-i Omega/2) is deliberately NOT stated; it stays a C-grade
conjecture in the program docs.

## Statements (8, all placeholder-proof targets, do not weaken)

`Pz_idem`, `Px_idem`, `hairpin_annihilation`, `bend_trace`,
`bend_trace_return`, `hairpin_pair_trace`, `backtrack_pair_trace`,
`hairpin_magnitude`.

## Preflight

- Statements typechecked 2026-07-14 via
  `lake env lean AgentTasks/aristotle-standalone/hairpin-lune-phase-20260714/HairpinLuneCore/HairpinLunePhase.lean`
  (only placeholder warnings).
- Hand-computed twice: (Pz Px)(Pmz Pmx) = (1/4)!![-1,1;0,0] (trace -1/4);
  same-meridian control gives (1/4)!![1,1;0,0] (trace +1/4).
- Kernel `decide` should work over Q; plain norm_num/simp preferred.

## Semantic review checklist (for integration)

- Matrix entries must remain exactly the four axis projectors in the
  standard Pauli convention; the -1/4 vs +1/4 contrast is the whole content.
- Product order is left-multiplication composition of the ordered history;
  these two four-cycles are reversal-symmetric (real), which is why Q
  suffices - do not let the statement migrate to C silently.
- Axiom audit per theorem; no compiled-evaluator decision tactic (kernel
  `decide` is fine).

## Integration plan

Copy proved file to `PhysicsSM/Draft/NullEdge/HairpinLunePhaseAristotle.lean`,
cross-reference the exact 1+1 checkerboard corner-sum module and
`TetrahedralSpinProjectorPath.lean`, run targeted `lake env lean`,
placeholder scan, axiom audit.

## Integration result

The unchanged returned statements were copied first to the standalone target
and then promoted, with project namespace and provenance docstring, to
`PhysicsSM/Draft/NullEdge/HairpinLunePhaseAristotle.lean`.  Both `lake env
lean` and `lake build PhysicsSM.Draft.NullEdge.HairpinLunePhaseAristotle`
pass.  The placeholder scan is clean, and every theorem has only the standard
`propext`, `Classical.choice`, and `Quot.sound` dependencies.
