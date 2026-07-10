# Codex proof job: concrete D4 invariant four-channel sector

Close every proof in `ConcreteD4Sector/Core.lean` without changing the explicit
coin, projector, diagonal shift, inclusion, or controls. Prove that the first
four channels form an exact invariant sector of the landed three-axis block
coin and every diagonal momentum-space shift, with an injective rank-four
inclusion and an excluded nonzero z-channel control.

This is deliberately not a claim that the sector is the 3+1 Dirac spinor: it
excludes the z pair. The result must expose that limitation while giving the
actual concrete coin-and-shift invariant-sector theorem.

The target is tiny and self-contained; no context pack is needed.

```yaml
aristotle:
  project_id: cc870ab1-4d96-4151-b733-0933d2940bf3
  target_file: ConcreteD4Sector/Core.lean
  expected_module: ConcreteD4Sector.Core
  submission_project: AgentTasks/aristotle-submit/codex-concrete-d4-invariant-sector-20260710-project
  output_dir: AgentTasks/aristotle-output/cc870ab1-4d96-4151-b733-0933d2940bf3
  status: integrated
```
