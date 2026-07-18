# Stage A3f-R4-D complete-family diagnostic

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Status: diagnostic completed; independent post-run audit approved

## Decision boundary

R4-D is a deterministic, selector-free replay of the six consumed R4
development sprinklings. It is not an independent trial and cannot alter the
R4 `INADMISSIBLE` decision. It archives complete-family intersection, hub, and
chart-scale data at beta `0.80`, `1.00`, and diagnostic-only `1.25`.

The result removes one obstruction at beta `1.25`: no complete candidate
family has a global common event there. This is one-directional. An empty
global intersection does not prove that a bounded-multiplicity selector can
reach the target atlas size.

## Frozen provenance

- Plan SHA-256:
  `a6ec0873d838b5140e356b34f3d4a99b522555292ff12e417585fcc34a517ed6`
- Implementation SHA-256:
  `b73b367073e4dbf38eac16f216e946fb6d3f67a8c1765760779ba9b2983ef553`
- Tests SHA-256:
  `2b55afe7151578dd1cca960c2a4ee99a5c5de4f94a891fc2083584bedf5e3505`
- Imported R4 source SHA-256:
  `e88f7b1bd946ffd78632283203ce4923245a274da1728bc101b232c77ff7be59`
- Set-reservation guard SHA-256:
  `d6364ee0443513254e16d0d0077f8d8b4bae360e78614049e8fa9aacd8680f16`
- Reviewed R4 development artifact SHA-256:
  `82206d616d9a3c289bc6a173f9f5792086f9a848d110d3b8fee6d6e771740335`

Independent pre-run approval is in
`AutonomousLab/reviews/CLAUDE_REVIEW_A3F_R4D_IMPLEMENTATION_2026-07-16.md`.
Independent post-run approval is in
`AutonomousLab/reviews/CLAUDE_REVIEW_A3F_R4D_RESULT_2026-07-16.md`.

The diagnostic executed once, from
`2026-07-16T18:11:01.329682+00:00` through
`2026-07-16T18:11:46.962277+00:00`. It used consumed development seed
`2026071610`; held-out seed `2026071611` remains retired-unconsumed.

## Artifact hashes

- Result:
  `AgentTasks/causal-growing-atlas-stage-a3f-r4d-diagnostic-2026-07-16.json`
  - raw:
    `e39c7886908555317db8c5fddca4eb15f402c6731a331517be20523ea690a13c`
  - scientific content:
    `63a90eb769d150e472f1407b48c41b46521efab7ef6a93d62e85f19a6fd19096`
  - deterministic content:
    `9d30a30839d3d401292de9bf5fa87fd661d9b57ce2f6bf7109017bbf8a6926df`
- Sentinel:
  `AgentTasks/causal-growing-atlas-stage-a3f-r4d-run-sentinel-2026-07-16.json`
  - raw:
    `ffa2dbd76041843c24dd21d42d968218697b74f9f0737c9df1c5e4080da47b2c`
  - status: `completed`

A scoped pre-commit invocation after the run briefly normalized only the
generated sentinel's CRLF bytes to LF. The exact serializer representation was
immediately restored and the original raw hash above reverified; no experiment,
seed, or RNG replay occurred, and the scientific result artifact was untouched.
This was disclosed to the independent reviewer in mailbox message
`msg-20260716-112135-d74b0406` before integration.

The earlier R3 duplicate-run incident remains part of the lane provenance:
`INC-2026-07-16-A3F-R3-DUPLICATE-RUN`, deterministic fingerprint
`2bddbd2e26a24598a04252d68b776bd8685a8cfeaca1303e9eb45f27348b8085`.

## Exact family-level result

All candidate families and every individual core are nonempty.

| `N` | realization | candidate count | intersection at `0.80` | intersection at `1.00` | intersection at `1.25` | max multiplicity at `1.25` |
|---:|---:|---:|---:|---:|---:|---:|
| 6000 | 0 | 198 | 10 | 0 | 0 | 173 |
| 6000 | 1 | 234 | 41 | 8 | 0 | 229 |
| 6000 | 2 | 193 | 47 | 14 | 0 | 188 |
| 12000 | 0 | 1318 | 4 | 0 | 0 | 1233 |
| 12000 | 1 | 1271 | 9 | 0 | 0 | 1218 |
| 12000 | 2 | 1504 | 2 | 0 | 0 | 1405 |

At beta `1.25`, the minimum individual core sizes are respectively
`289, 300, 293, 605, 593, 563`. The empty family-wide intersections are
therefore not caused by vanishing charts.

The exact beta `1.25` hub fractions are
`173/198`, `229/234`, `188/193`, `1233/1318`, `1218/1271`, and
`1405/1504`, a range of approximately `87.4%` to `97.9%`. At beta `1.00`,
the four families without a true apex still have near-apex maxima
`197/198`, `1309/1318`, `1270/1271`, and `1500/1504`. Thus an apex and a
near-apex hub produced the same selector trapping in R4; the complete-family
diagnostic is what distinguishes them.

## Interpretation

- At beta `0.80`, every complete family is certificate-dead for an atlas
  larger than the eventwise cap: all six have a genuine common event.
- At beta `1.00`, two complete families retain a genuine apex and four replace
  it with near-universal hubs. The R4 blocking mechanism is therefore
  heterogeneous at family level despite uniform selector output.
- At beta `1.25`, the global common-event obstruction disappears in all six
  consumed sprinklings while cores remain substantial. Strong hubs remain, so
  selector viability is unresolved.

These are finite `M [comp]` facts on manifold-generated controls. They do not
derive a growing graph atlas, rank four, Lorentzian signature, a tetrad, scale,
curvature convergence, stress-energy, or Einstein dynamics. G2 and every
downstream gate remain closed.

## Formal certificate interface

`PhysicsSM/Draft/NullEdge/AtlasFractionalPackingDual.lean` now proves the
weighted chart-event incidence identity and the resulting fractional dual
capacity bound. A nonnegative weight certificate checked on the complete
candidate family bounds every capacity-respecting selected subfamily. The
common-event theorem is its unit point-mass boundary case.

This theorem permits a future optimizer to propose concrete rational weights;
Lean checks the universal implication. It neither constructs such a
certificate nor proves one exists for any R4-D family.

## Approved successor

The smallest next result-bearing stage is R5:

1. Use fresh development and held-out seeds; never reuse `2026071610` or
   `2026071611`.
2. Freeze beta `1.25` as the sole result-bearing test rung. Recompute beta
   `1.00` on the same fresh sprinklings as a known-hostile diagnostic control,
   explicitly excluded from cap selection, outcome aggregation, and drift
   gates.
3. Keep the R4 caps `5, 8, 12`, target
   `K_N = ceil(2 N^(1/4))`, primary-rung gates, taxonomy, and resource
   envelopes unchanged.
4. Archive the complete-family intersection and hub profile before selection
   on every realization.
5. Keep the apex/dead, hub-blocked, and feasible descriptions separate from
   the frozen `PASS`/`FAIL`/`INADMISSIBLE` outcome taxonomy.

Only the rung choice is motivated by R4-D. No selector, cap, threshold, or
target-cardinality tuning from consumed outcomes is authorized.
