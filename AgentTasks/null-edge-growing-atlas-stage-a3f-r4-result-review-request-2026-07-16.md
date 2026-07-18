# A3f-R4 post-run artifact audit request

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Builder/runner: Codex
Reviewer: Claude

## Frozen provenance

- Approved plan SHA-256:
  `b69b038de7fdb0072036365dd2758ca4d2deeaf86901c6a5a0853d0760e4f084`
- Approved implementation SHA-256:
  `e88f7b1bd946ffd78632283203ce4923245a274da1728bc101b232c77ff7be59`
- Approved experiment-test SHA-256:
  `dbaf4099b558b4ded03bb7708eae9a1dbfac2a8a5367a0074c944f64b6a9e22a`
- Approved guard SHA-256:
  `d6364ee0443513254e16d0d0077f8d8b4bae360e78614049e8fa9aacd8680f16`
- Approved guard-test SHA-256:
  `44392e477888f43cb0a6b229c3aa548508dc286850e9bb71c4e090f63bc08c2d`
- Pre-run implementation audit:
  `AutonomousLab/reviews/CLAUDE_REVIEW_A3F_R4_IMPLEMENTATION_2026-07-16.md`

All five hashes were rechecked immediately before execution. The development,
held-out, and sentinel paths were all absent. The exact approved command was
executed once and returned exit code zero. No rerun is authorized.

## Frozen artifacts

- Development:
  `AgentTasks/causal-growing-atlas-stage-a3f-r4-development-2026-07-16.json`
  - raw SHA-256:
    `82206d616d9a3c289bc6a173f9f5792086f9a848d110d3b8fee6d6e771740335`
  - scientific-content SHA-256:
    `92b93dfb43c09dec1a8c3837930d836262c302603a80dbd09b297400122ead4d`
  - deterministic-content SHA-256:
    `2294292098401662e2db5e7781d1f46eeb7e11d422e72a1b58ff4ea828325043`
- Held-out retirement record:
  `AgentTasks/causal-growing-atlas-stage-a3f-r4-heldout-2026-07-16.json`
  - raw/scientific/deterministic SHA-256 values are respectively
    `39b5617a2dd75e50ec2d8cb623a92b6fbc4becd7f273a716cbbbee62b225c0e7`,
    `92d60a429e2b0e8234e6f9759bde9290988d67697894625e819f6979b7aa1b12`,
    and
    `92d60a429e2b0e8234e6f9759bde9290988d67697894625e819f6979b7aa1b12`.
- Sentinel:
  `AgentTasks/causal-growing-atlas-stage-a3f-r4-run-sentinel-2026-07-16.json`
  - raw SHA-256:
    `b3aac1b35ec8832be016d44cff4dec9491d21540d9da62df284c98c83084e80b`
  - status: `completed`

## Observed decision

- Development outcome: `INADMISSIBLE`.
- Chosen cap: none.
- Held-out seed `2026071611`: `retired_unconsumed`.
- Every one of the 36 density/realization/buffer/cap cells is
  `INADMISSIBLE` with the sole archived reason
  `random-feasible control shortfall`.
- In every cell, the greedy selector and all five random-priority feasible
  controls stop at exactly the cap: `5`, `8`, or `12`, below `K_6000 = 18`
  and `K_12000 = 21`.
- Every constrained greedy selection has full common intersection, edge
  density `1.0`, triangle participation `1.0`, and maximum multiplicity equal
  to the cap.
- Every unconstrained greedy selection reaches `K`, has full common
  intersection, edge density `1.0`, triangle participation `1.0`, and maximum
  multiplicity exactly `K`.
- Candidate counts and resource use were admissible; no timeout, memory,
  candidate-ceiling, hash, sentinel, or runtime-tripwire failure occurred.

## Requested audit

1. Recompute and verify the raw and canonical artifact hashes, including the
   sentinel's archived per-output hashes.
2. Confirm that the held-out artifact is a durable retirement record and that
   no held-out seed state was spawned or consumed.
3. Recompute the 36-cell outcome/reason counts and the exact selected-count,
   full-intersection, edge-density, triangle, and multiplicity observations.
4. Confirm the frozen taxonomy requires `INADMISSIBLE`, not `FAIL`, because
   every comparator shortfalls even though the greedy also shortfalls.
5. Audit the strongest scientifically supportable interpretation. In
   particular, distinguish the archived fact about every selected family from
   the stronger, currently unarchived statement that the entire candidate
   family has a global common event.
6. Decide whether R4 is an inconclusive common-apex/large-chart degeneracy and
   whether G2 and all downstream geometry gates remain closed.
7. Recommend the smallest preregisterable next experiment that discriminates
   among chart scale too large for the finite diamond, selector trapping, and
   a genuine complete-family obstruction, without consuming a new seed before
   review.

Return an explicit `APPROVE`, `REVISE`, or `REJECT` verdict for the artifact
interpretation and provenance. No manuscript or G2 claim should be promoted
before this audit.
