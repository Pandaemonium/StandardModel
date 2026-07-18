# Stage A3f-R4 growing-atlas benchmark

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Status: frozen run complete; independent artifact audit approved

## Decision

The preregistered development stage returned `INADMISSIBLE`. No multiplicity
cap qualified or was selected. The automatically chained held-out stage did
not execute: seed `2026071611` is archived as `retired_unconsumed` and may not
be reused.

This is neither a pass nor a scientific kill. Under the frozen taxonomy, a
shortfall of any random-priority feasible comparator makes the affected cell
inadmissible because selector superiority cannot be measured at the target
cardinality.

## Frozen provenance

The exact approved command was executed once after the plan, implementation,
experiment-test, guard, and guard-test hashes matched the independently
approved values and after the development, held-out, and sentinel paths were
confirmed absent.

- Plan SHA-256:
  `b69b038de7fdb0072036365dd2758ca4d2deeaf86901c6a5a0853d0760e4f084`
- Implementation SHA-256:
  `e88f7b1bd946ffd78632283203ce4923245a274da1728bc101b232c77ff7be59`
- Experiment-test SHA-256:
  `dbaf4099b558b4ded03bb7708eae9a1dbfac2a8a5367a0074c944f64b6a9e22a`
- Guard SHA-256:
  `d6364ee0443513254e16d0d0077f8d8b4bae360e78614049e8fa9aacd8680f16`
- Guard-test SHA-256:
  `44392e477888f43cb0a6b229c3aa548508dc286850e9bb71c4e090f63bc08c2d`
- Independent pre-run approval:
  `AutonomousLab/reviews/CLAUDE_REVIEW_A3F_R4_IMPLEMENTATION_2026-07-16.md`
- Independent post-run approval:
  `AutonomousLab/reviews/CLAUDE_REVIEW_A3F_R4_RESULT_2026-07-16.md`

The run was incident-free under the multi-output sentinel. No duplicate or
partial R4 execution occurred.

## Artifact hashes

- Development artifact:
  `AgentTasks/causal-growing-atlas-stage-a3f-r4-development-2026-07-16.json`
  - raw:
    `82206d616d9a3c289bc6a173f9f5792086f9a848d110d3b8fee6d6e771740335`
  - scientific content:
    `92b93dfb43c09dec1a8c3837930d836262c302603a80dbd09b297400122ead4d`
  - deterministic content:
    `2294292098401662e2db5e7781d1f46eeb7e11d422e72a1b58ff4ea828325043`
- Held-out retirement artifact:
  `AgentTasks/causal-growing-atlas-stage-a3f-r4-heldout-2026-07-16.json`
  - raw:
    `39b5617a2dd75e50ec2d8cb623a92b6fbc4becd7f273a716cbbbee62b225c0e7`
  - scientific and deterministic content:
    `92d60a429e2b0e8234e6f9759bde9290988d67697894625e819f6979b7aa1b12`
- Sentinel:
  `AgentTasks/causal-growing-atlas-stage-a3f-r4-run-sentinel-2026-07-16.json`
  - raw:
    `b3aac1b35ec8832be016d44cff4dec9491d21540d9da62df284c98c83084e80b`
  - status: `completed`

The sentinel archives the same raw hashes and output byte sizes. It remains in
place and permanently prevents reuse of this frozen run identity.

## Exact development accounting

The development artifact contains six sprinklings: three at `N=6000` and
three at `N=12000`. Each has two buffer rungs and three caps, giving 36 cells.

- Outcomes: 36 `INADMISSIBLE`, 0 `FAIL`, 0 `PASS`.
- Sole reason in all 36 cells: `random-feasible control shortfall`.
- All seven runtime tripwires pass in all 36 cells.
- Complete candidate counts are `193-234` at `N=6000` and `1271-1504` at
  `N=12000`, within the ceiling.
- Total development realization time is `114.615 s`; individual times are
  `6.008-32.823 s`.
- Peak working set is `209,780,736-432,066,560` bytes, below the `6 GiB`
  ceiling.
- No timeout, memory, candidate-ceiling, hash, replay, containment,
  factorization, induced-count, or sentinel failure occurs.

## Capacity and nerve observation

The target cardinalities are `K_6000=18` and `K_12000=21`. In every cell:

- the constrained greedy selector stops at exactly its cap;
- each of the five random-priority feasible controls also stops at exactly its
  cap;
- selected maximum multiplicity equals the cap;
- the selected protected cores have a full common intersection;
- overlap edge density is `1.0`;
- triangle participation is `1.0`; and
- at least one greedy step after the first has positive all-event marginal.

The same complete-nerve shape appears in every unconstrained descriptive
control: it reaches `K`, has full common intersection, edge density `1.0`,
triangle participation `1.0`, and maximum multiplicity exactly `K`.

The kernel-checked theorem
`ProtectedCoreAtlasNerve.fullCommonOverlap_card_le_bound` explains the local
cap stop: once a selected family shares an event, an eventwise cap `m` forbids
that same family from containing more than `m` charts. The artifact does not
archive the intersection of the entire candidate family, so it does not by
itself prove that every possible selector is bounded by `m`.

## Descriptive coverage

Although the cells are inadmissible and cannot support selector-superiority
ratios, their constrained greedy coverage is archived descriptively:

| cap | bulk coverage min/median/max | repeated coverage min/median/max | all-event coverage min/median/max |
|---:|---:|---:|---:|
| 5 | `0.654 / 0.718 / 0.801` | `0.582 / 0.640 / 0.759` | `0.360 / 0.457 / 0.565` |
| 8 | `0.709 / 0.783 / 0.847` | `0.682 / 0.772 / 0.848` | `0.387 / 0.493 / 0.597` |
| 12 | `0.727 / 0.811 / 0.867` | `0.793 / 0.837 / 0.906` | `0.397 / 0.512 / 0.611` |

Thirty-one of 36 constrained selections exceed the standalone `0.70` bulk
coverage threshold, but none reaches target cardinality and none breaks the
full-intersection/complete-nerve regime. These values therefore do not reopen
any topology or geometry gate.

## Interpretation boundary

The strongest current interpretation is a finite large-chart/common-apex
degeneracy of the tested construction, not a theorem that growing protected-
core atlases are impossible. The balanced schedule uses
`n_R = N^(3/4)`, and at the accessible dense-relation sizes its outer charts
still occupy a substantial fraction of the global diamond. Every sampled
selector is trapped in a complete-nerve regime, but R4 did not archive the
whole-family common intersection or solve the global capacity-constrained
packing optimum.

More precisely, the frozen normalization gives

```text
n_R / N = (2048 / 4800^(3/4)) N^(-1/4)
        approximately 3.5514 N^(-1/4).
```

The ratio is `0.4035` at `N=6000` and `0.3393` at `N=12000`. Reaching a
ten-percent outer-count fraction under the same normalization would require
approximately `N=1.59e6`, far beyond the current dense relation ceiling.
Thus R4 probes a mesoscopic scaling law in a finite regime where the charts
are not yet small relative to the ambient diamond.

The separately preregistered R4-D deterministic replay has now landed and is
independently approved. It finds a complete-family common event in all six
sprinklings at beta `0.80`, in two of six at beta `1.00`, and in none at beta
`1.25`; the four empty-intersection beta `1.00` families retain near-universal
hubs. At beta `1.25`, every family and core remains nonempty, but maximum hub
multiplicity is still approximately `87.4%` to `97.9%` of the candidate
family. The common-event obstruction is removed there; selector viability is
not established. Full results are in
`AgentTasks/null-edge-growing-atlas-stage-a3f-r4d-benchmark-2026-07-16.md`.

## Claim disposition

- `M [comp]`: exact archived finite outcome and nerve statistics after
  independent artifact audit.
- Inconclusive: existence of a growing bounded-multiplicity atlas for this
  candidate family.
- Closed: transition reconstruction from graph data, G2 metric/tetrad
  reconstruction, spin lift, curvature convergence, physical stress-energy,
  Einstein dynamics, and calibrated constants.

The post-run review request is
`AgentTasks/null-edge-growing-atlas-stage-a3f-r4-result-review-request-2026-07-16.md`
and mailbox message `msg-20260716-103255-b21f14e1`.
