# Aristotle job: fan induction for Bargmann polygon phases (spiral wave 5)

Date: 2026-07-16
Context: spiral-layer wave 5; packages the C1-POLYGON gate. Wave 4 landed
the cocycle law (one diagonal cut); this job does the full diagonal-fan
induction, so an n-corner polygon phase becomes the phase of the product
of its fan-triangle invariants - which are half solid angles by the
landed wave-3 triangle law plus the documented Van Oosterom-Strackee
import. The strengthening pass on wave 4 (bargmann_cocycle_general)
identified the required generality: the induction consumes the cocycle
with an arbitrary MATRIX in the X slot, not a single corner direction.

```yaml
aristotle:
  project_id: 6a413e71-997c-43ad-abe2-214dd37faa58
  task_id: TBD
  target_file: BargmannFanInduction/BargmannFanInduction.lean
  expected_module: BargmannFanInduction.BargmannFanInduction
  submission_project: AgentTasks/aristotle-submit/bargmann-fan-induction-20260716-project
  source_root: AgentTasks/aristotle-standalone/bargmann-fan-induction-20260716
  output_dir: AgentTasks/aristotle-output/<project_id>
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/BargmannFanInductionAristotle.lean
```

## Statements (6, placeholder-proof targets, do not weaken)

1. `pair_trace` - tr(P(a)P(b)) = (1 + a.b)/2, polynomial, no unit
   hypotheses (wave-1 re-derivation inside the standalone package).
2. `proj_collapse` - rank-one sandwich: unit v, ANY M:
   P(v) M P(v) = tr(P(v) M) * P(v).
3. `bargmann_cocycle_matrix` - cocycle with arbitrary matrix slots X, Y;
   unit hypotheses on the diagonal a, c only.
4. `fan_factorization` - equation form, list-indexed:
   tr(P(v0) cornerProd l) * PROD diag traces = PROD fan-triangle traces,
   for unit v0, all of l unit, 2 <= l.length. No nondegeneracy needed.
5. `fan_arg` - phase corollary under -1 < v0.w for interior diagonals.
6. `pentagon_witness` - tr for apex e_z, rim (e_x, (3/5,0,4/5),
   (0,3/5,4/5), e_y) equals exactly (9 + i)/25.

## Preflight

- Statements typechecked 2026-07-16: `lake env lean` EXIT=0 (six
  placeholder warnings only).
- Pentagon witness and the fan identity verified numerically (numpy,
  double precision, residuals < 1e-12): trace = 0.36 + 0.04i, triangles
  (3/5, (81+9i)/100, 3/5), diagonals (9/10, 9/10).
- Hand-derivation of the induction step: with l = l' ++ [z] and
  c = l'.getLast, cornerProd l' = cornerProd l'.dropLast * P(c), one
  application of the matrix cocycle (X = cornerProd l'.dropLast,
  Y = P(z)) rearranges tr(P0 X Pc Y) * tr(P0 Pc) into
  tr(P0 X Pc) * tr(P0 Pc Y); multiply by the remaining diagonal product
  and apply the induction hypothesis. Base case length 2 is
  definitional (empty diagonal product).
- Length-1 lists FALSIFY the statement (LHS = tr(P0 P1) != 1 = RHS
  empty product), hence the 2 <= l.length hypothesis; length 0 would be
  trivially true but is excluded with it.

## Semantic review checklist (for integration)

- The unit hypotheses: v0 and ALL rim directions unit. (Sharpening to
  interior-diagonals-only is possible but not requested; do not let
  Aristotle weaken or reshape the hypothesis set.)
- fan_factorization must stay in EQUATION form (no division by diagonal
  traces): it must hold at degeneracy where both sides vanish.
- Diagonal set is l.tail.dropLast (interior fan diagonals only - the
  polygon edges (v0, l.head) and (v0, l.getLast) are NOT diagonals).
- Triangle list is l.zip l.tail in that order (apex first: (v0, u, w));
  orientation must match the wave-3/wave-4 convention (a, c) diagonal
  with triangles (a,b,c), (a,c,d).
- Axiom audit per theorem; no compiled-evaluator tactic in anything
  intended for promotion.
