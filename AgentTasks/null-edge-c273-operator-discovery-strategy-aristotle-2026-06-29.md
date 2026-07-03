# Gate C1 C273: find the physical operator, not more scaffolding

Date: 2026-06-29
Status: prepared for Aristotle submission.

## Purpose

This job asks Aristotle for blunt recommendations and, where useful, focused theorem targets for Gate C1. It is intentionally not a broad full-repo build job.

## Submission packet

- Submission project: `AgentTasks\aristotle-submit\gate-c1-c273-operator-discovery-strategy-20260629`
- Prompt: `AgentTasks\aristotle-submit\gate-c1-c273-operator-discovery-strategy-20260629\PROMPT.md`
- Context pack: `AgentTasks\context-packs\gate-c1-next-operator-strategy-20260629-20260629-061718.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: 31c3a07d-5341-4cd0-a677-def6a0d975c1
  task_id: 133577de-03a2-427e-b7eb-0edf26479b11
  target_file: strategy/recommendation packet
  expected_module: none
  submission_project: AgentTasks\aristotle-submit\gate-c1-c273-operator-discovery-strategy-20260629
  output_dir: AgentTasks/aristotle-output/31c3a07d-5341-4cd0-a677-def6a0d975c1
  status: integrated
```

## Prompt

````text
You are Aristotle working on the PhysicsSM null-edge Standard Model project.

Blunt request: we are not asking for more generic scaffolding. We need the next concrete operator architecture for Gate C1.

Project goal: build a model reproducing the Standard Model in terms of discrete lightlike/null-edge steps, inspired by the Feynman checkerboard. Gate C1 is the hard chiral-fermion release problem: obtain one physical Weyl branch with the correct chiral behavior, while mirrors/unwanted branches get a real inverse-propagator gap and do not reappear as gauge-charged ghosts.

Current state, compressed:
- Bare retarded null-edge symbol does not release a physical chiral operator.
- Each nonzero null branch has a chirality-balanced kernel.
- Scalar Wilson lifting was treated as a no-go for selecting chirality at the origin when scalar on the balanced origin kernel and quadratically vanishing.
- We shifted to non-ultralocal/overlap/Ginsparg-Wilson architecture.
- Current Lean scaffolds include `Kfree`, `Hfree`, finite overlap-index certificates, locality certificates, physical C1 certificate predicates, and a `TetraBranchWilsonSymbol.lean` scaffold for matrix-valued branch Wilson data.
- We are considering a null-edge-native matrix-valued branch Wilson mass/projector, possibly inside a known Wilson/Neuberger overlap architecture.

Included files:
- `gate-c1-next-operator-strategy-20260629-20260629-061718.md` context pack.
- Current C1 plan and key Lean files listed in this project directory.

What we need from you:
1. State the most promising concrete physical operator architecture in one or two formulas. Do not hide behind broad categories.
2. Say exactly what data must be chosen: branch selector, mass matrix, kernel, sign convention, projector, gauge coupling, and any anomaly input.
3. Say exactly which existing assumptions should be kept, weakened, or discarded. Be blunt if an assumption is blocking the solution.
4. Give the top 3 candidate routes, ranked by probability of success, including why each could fail.
5. Explain how to find the operator if it is not already determined. What computational searches, finite matrix scans, spectral/island tests, or representation-theoretic constraints should we run?
6. Translate the best route into Lean targets: theorem names, statements, needed hypotheses, and which current modules should change.
7. Identify the smallest decisive test that would tell us whether the route is viable.
8. Comment on whether the repo's anomaly-cancellation work is enough for physical C1, or what extra anomaly bridge is needed.

Do not spend your budget on a full repo build. This is a strategy and operator-discovery job. If you do prove a small lemma, great, but recommendations are the primary output.

Completion report format:
- Recommended operator:
- Assumptions to keep/drop:
- Highest-value next tests:
- Lean targets:
- Risks/no-go warnings:
- Exact next action for Codex:

````


## Submission result

Submitted on 2026-06-29.

```text
WARNING: Your project contains .lean files but no lean-toolchain is present.
Aristotle works best with Lean Toolchain leanprover/lean4:v4.28.0

WARNING: Your project contains .lean files but no .lake folder.
Aristotle works better with access to your project's dependencies.
Did you forget to run `lake build`?

Project created: 31c3a07d-5341-4cd0-a677-def6a0d975c1

```


## Task status check

2026-06-29: `aristotle tasks 31c3a07d-5341-4cd0-a677-def6a0d975c1 --limit 5` reported task `133577de-03a2-427e-b7eb-0edf26479b11` as `QUEUED`.


## Integration note

2026-06-29: Integrated into plan section 91. Key result: concrete flavored-overlap operator search target and branch-mass window test.
