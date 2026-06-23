# Aristotle focused job: P9 causal support bound

```yaml
job_name: null-edge-p9-causal-support-bound-20260623
status: integrated
project_id: 1dc86a62-8505-45d2-80b5-cffbb4a6b82c
task_id: 54127700-6d2b-4e9f-a187-3c582b93b070
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-causal-support-bound-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-causal-support-bound-20260623-project
output_dir: AgentTasks/aristotle-output/1dc86a62-8505-45d2-80b5-cffbb4a6b82c
target_module: PhysicsSM.Draft.NullEdgeP9CausalSupportBound
target_file: PhysicsSM/Draft/NullEdgeP9CausalSupportBound.lean
expected_check: lake env lean PhysicsSM/Draft/NullEdgeP9CausalSupportBound.lean
```

## Task

Fill the three proof holes in `NullEdgeP9CausalSupportBound/Core.lean` without
changing definitions or theorem statements.

This is a finite causal-support guardrail for P9. It responds to Gemini's
critique that the current C4/Hodge theorem spine is still generic finite linear
algebra unless the response object knows about causal reach. The target is
deliberately modest: a kernel supported inside a finite causal relation cannot
send a localized source outside that source's discrete causal reach.

## Targets

```lean
applyKernel_vanishes_off_reach
response_zero_of_causally_separated_supports
response_eq_zero_of_target_outside_reach
```

## Constraints

- Do not weaken, rename, or restate the theorems.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9CausalSupportBound/Core.lean
```

## Proof sketch

For the first theorem, expand `applyKernel` and use `Finset.sum_eq_zero`.
For each summand at `i`, either the source predicate fails at `j`, so `x j = 0`,
or the source predicate holds, and the hypothesis that `i` is outside the
causal reach gives `Not (rel i j)`, so the kernel entry is zero.

The response theorems then expand `response` and `dot`, use
`Finset.sum_eq_zero`, and reduce each target component either by `hy` or by the
first theorem.

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Submission note

Submitted on 2026-06-23 as Aristotle project
`1dc86a62-8505-45d2-80b5-cffbb4a6b82c`, task
`54127700-6d2b-4e9f-a187-3c582b93b070`.

Local preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-causal-support-bound-20260623/NullEdgeP9CausalSupportBound/Core.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" AgentTasks/aristotle-standalone/null-edge-p9-causal-support-bound-20260623/NullEdgeP9CausalSupportBound/Core.lean AgentTasks/null-edge-p9-causal-support-bound-aristotle-2026-06-23.md
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-causal-support-bound-20260623/NullEdgeP9CausalSupportBound/Core.lean AgentTasks/null-edge-p9-causal-support-bound-aristotle-2026-06-23.md
```

The Lean preflight found exactly the three intended proof-hole warnings and no
other errors. Non-ASCII scan was clean.

## Integration note

Aristotle completed on 2026-06-23 and reported all three targets solved with no
statement or definition changes:

- `applyKernel_vanishes_off_reach`;
- `response_zero_of_causally_separated_supports`;
- `response_eq_zero_of_target_outside_reach`.

The extracted file was clean for proof holes and escape hatches, but used
Unicode-heavy proof syntax and lacked a final newline. The integrated module
`PhysicsSM.Draft.NullEdgeP9CausalSupportBound` rewrites the proof bodies in
plain ASCII Lean style while preserving the theorem statements.

Verification run:

```text
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-p9-causal-support-bound-aristotle-2026-06-23.md 1dc86a62-8505-45d2-80b5-cffbb4a6b82c
lake env lean PhysicsSM/Draft/NullEdgeP9CausalSupportBound.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9CausalSupportBound.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9CausalSupportBound.lean
lake build PhysicsSM.Draft.NullEdgeP9CausalSupportBound
lake env lean PhysicsSMDraft.lean
```

The targeted Lean check, targeted module build, placeholder scan, non-ASCII
scan, and rerun draft-root import check passed. The first draft-root check raced
the targeted build before the `.olean` existed and was rerun successfully.

Scientific role: this is a finite domain-of-dependence guardrail for P9. A
kernel supported inside the chosen causal relation cannot move a localized
source outside its discrete causal reach, and causally separated source/target
supports have zero response. It keeps the source-response layer from being
pure arbitrary matrix algebra, while still falling short of a cosmological
response or scaling law.
