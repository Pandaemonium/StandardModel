# Aristotle job: cap-square Berry factor (spiral wave 7, C3 target T1)

Date: 2026-07-16
Context: spiral-layer wave 7; the T1 target of the C3 gate ("closure
channel = circulation cost", design
`AutonomousLab/work/SPIRAL-LAYER/CLAUDE_C3_CLOSURE_AREA_DESIGN_2026-07-16.md`).
The exact finite statement that smooth closure costs PHASE (Berry/solid
angle) while kinks cost MAGNITUDE (per-corner factors): the latitude-cap
square family has invariant exactly z^4 with z the single corner
amplitude; the equatorial value -1/4 is the hemisphere Berry sign as a
kernel fact (cross-checks the wave-1 hairpin -1/4, same enclosed
hemisphere); a rewalked edge multiplies by exactly the corner factor 1/2.

```yaml
aristotle:
  project_id: 8eb64e1f-b986-451e-b7b3-fa1d228f4a80
  task_id: TBD
  target_file: CapSquareBerry/CapSquareBerry.lean
  expected_module: CapSquareBerry.CapSquareBerry
  submission_project: AgentTasks/aristotle-submit/cap-square-berry-20260716-project
  source_root: AgentTasks/aristotle-standalone/cap-square-berry-20260716
  output_dir: AgentTasks/aristotle-output/<project_id>
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/CapSquareBerryAristotle.lean
```

## Statements (5, placeholder-proof targets, do not weaken)

1. `cap_square_invariant` - tr of the latitude square = cornerAmp(t)^4,
   cornerAmp t = (1+t)/2 + i(1-t)/2, under u^2 + t^2 = 1.
2. `cap_square_normSq` - normSq = ((1+t^2)/2)^4 (poles 1, equator 1/16 =
   the C3-T2 four-right-angle constant).
3. `equator_square_invariant` - exactly -1/4 (hemisphere Berry sign).
4. `pole_square_invariant` - exactly 1 (degenerate control).
5. `kink_insertion_penalty` - rewalked edge: exactly -1/8 = (1/2)(-1/4);
   kink costs magnitude only.

## Preflight

- Statements typechecked 2026-07-16: `lake env lean` EXIT=0 (five
  placeholder warnings only).
- All five closed forms verified numerically (numpy, residuals < 1e-12)
  at t in {0, 0.3, -0.6, 1} plus the kink insertion.
- Derivation: coherent-state telescoping - each corner overlap
  <v_k|v_{k+1}> = cos^2(theta/2) + sin^2(theta/2) e^{i pi/2} = z equal
  by symmetry, closed product = z^4. Berry limit is exact in this
  family: arg z^4 -> half the cap solid angle as the polygon refines
  (not stated in this package; the n = 4 exact form is).

## Semantic review checklist (for integration)

- The single hypothesis is u^2 + t^2 = 1; no square roots anywhere. Odd
  powers of u must cancel between antipodal pairs; if Aristotle's proof
  substitutes u^2 = 1 - t^2 that is fine, but the STATEMENT must keep u
  symbolic.
- cornerAmp is (1+t)/2 + i(1-t)/2 with real casts; do not let it become
  a different parametrization (the phase convention matches the
  wave-1/2/3 orientation: E -> N -> W -> S is the positive orientation
  seen from the north pole).
- Statement 5's loop is E N E N W S (rewalk of the first edge), trace
  -1/8; the ratio-1/2 reading (vs statement 3) is prose, not a
  hypothesis.
- The -1/4 cross-check against HairpinLunePhaseAristotle.hairpin_pair_trace
  is a documentation link, not a dependency (packages are standalone).
- Axiom audit per theorem; no compiled-evaluator tactic in anything
  intended for promotion.
