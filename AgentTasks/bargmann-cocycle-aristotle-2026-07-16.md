# Aristotle job: Bargmann cocycle law - polygon phases decompose (spiral wave 4, job A)

Date: 2026-07-16
Context: spiral-layer wave 4; closes the C1-POLYGON gate given the landed
wave-3 triangle law (BargmannSolidAngleAristotle) - cutting along a
diagonal factorizes the invariant with a positive-real diagonal pair
trace, so polygon phases are sums of triangle phases by induction.

```yaml
aristotle:
  project_id: 74a06ae4-2d52-4ab2-a400-a865083da653
  task_id: TBD
  target_file: BargmannCocycle/BargmannCocycle.lean
  expected_module: BargmannCocycle.BargmannCocycle
  submission_project: AgentTasks/aristotle-submit/bargmann-cocycle-20260716-project
  source_root: AgentTasks/aristotle-standalone/bargmann-cocycle-20260716
  output_dir: AgentTasks/aristotle-output/74a06ae4-2d52-4ab2-a400-a865083da653
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/BargmannCocycleAristotle.lean
```

## Statements (4, placeholder-proof targets, do not weaken)

`bargmann_cocycle` (tr(PaPbPc) * tr(PaPcPd) = tr(PaPbPcPd) * tr(PaPc),
unit hypotheses), `bargmann_cocycle_arg` (phase form, -1 < a.c),
`bargmann_cocycle_degenerate` (antipodal diagonal control),
`quadrilateral_witness` (rational Pythagorean witness, diagonal trace 1/2,
four-cycle nonzero).

## Preflight

- Statements typechecked 2026-07-16: `lake env lean` EXIT=0 (placeholder
  warnings only).
- Hand-derivation (bra-ket): with unit vectors P(v) rank-one,
  tr(PaPbPc) tr(PaPcPd) = <a|b><b|c><c|a><a|c><c|d><d|a>
  = <a|b><b|c><c|d><d|a> |<a|c>|^2 = tr(PaPbPcPd) tr(PaPc). Checked
  degenerate at the hairpin (0 = 0).
- Unit hypotheses are ESSENTIAL (idempotence collapses the middle
  projectors); the wave-2 polynomial identities do not need them, this
  one does.

## Semantic review checklist (for integration)

- The four unit hypotheses must remain; do not let the statement migrate
  to the polynomial form (false there).
- The arg form must keep -1 < a.c (the diagonal pair trace must be
  strictly positive for exact arg preservation).
- Orientation: the diagonal is (a, c) with the two triangles (a,b,c) and
  (a,c,d) in that order; swapping breaks the intended fan-induction
  packaging.
- Axiom audit per theorem; no compiled-evaluator tactic.

## Post-integration strengthening pass (2026-07-16, claude)

- The Aristotle linter reported `hb`/`hd` unused by the returned proof of
  `bargmann_cocycle`. Kernel-confirmed by adding `bargmann_cocycle_general`
  and `bargmann_cocycle_arg_general` (unit hypotheses on the DIAGONAL
  `a`, `c` only; `b`, `d` arbitrary raw triples), reusing the returned
  proof bodies; build green with two new standard-three guards (module
  total now 6).
- Mathematical reason: in the bra-ket factoring only `P(a)`, `P(c)` need
  rank-one collapse; `P(b)`, `P(d)` sit in arbitrary matrix slots:
  tr(PaXPc) tr(PaPcY) = <a|X|c><c|a> <a|c><c|Y|a>
  = <a|X|c><c|Y|a> <a|c><c|a> = tr(PaXPcY) tr(PaPc).
- The checklist line "the four unit hypotheses must remain" is hereby
  refined: the DIAGONAL unit hypotheses (`a`, `c`) are essential (fully
  polynomial form remains false); the off-diagonal ones are proven
  droppable. Original four numbered statements kept verbatim per
  integration provenance; the general forms live in a separate marked
  section of the module.
