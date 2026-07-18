# Post-run audit request: A3f-R5 smaller-core atlas

Date: 2026-07-16  
Work item: `GRAV-GROWING-ATLAS-001`  
Required verdict: `RESULT-APPROVED` or `RESULT-REJECTED`

## Immutable run artifacts

| Artifact | Bytes | Raw SHA-256 |
|---|---:|---|
| `AgentTasks/causal-growing-atlas-stage-a3f-r5-development-2026-07-16.json` | 6,459,101 | `056ce9484520a937e9afd2cd2f22d4b5566df3905ec5afe9bce4d432a7889752` |
| `AgentTasks/causal-growing-atlas-stage-a3f-r5-heldout-2026-07-16.json` | 210 | `9c8e5308e5f942a5a14e4ad9113add0894d53fd9658efde986c1e4bfe1ee818d` |
| `AgentTasks/causal-growing-atlas-stage-a3f-r5-run-sentinel-2026-07-16.json` | 3,257 | `b4aa332b8965fbb83f52b2b7ad7cb8d74b69a541ad4090743f4463884ba019b9` |

The sentinel records `status: completed`, PID `41584`, acquisition at
`2026-07-16T19:51:41.120826+00:00`, and completion at
`2026-07-16T19:53:48.561872+00:00`. Its two `output_raw_sha256` values match
the table above. The exact frozen command was launched once. The shell wrapper
timed out after launch, but the recorded process remained active and completed
under the same PID; no command was rerun.

## Mechanical result, pending audit

- Development decision: `INADMISSIBLE`.
- Chosen capacity: `null`.
- At each capacity `5`, `8`, and `12`, both result-bearing densities `6000`
  and `12000` report `INADMISSIBLE: 3`, `PASS: 0`, `FAIL: 0`.
- Held-out artifact: `retired_unconsumed`, because development selected no
  capacity; held-out seed `2026071613` was not run.
- Primary result-bearing rung: beta `1.25`.
- Diagnostic negative-control rung: beta `1.00`, excluded from decisions.

## Requested audit

1. Recompute all three raw hashes and confirm the sentinel's recorded output
   hashes and byte lengths.
2. Confirm the completed sentinel belongs to the exact reviewed source, plan,
   tests, imported R4/R4-D, guard, theorem module, seeds, and protocol pins.
3. Confirm all 18 beta-1.25 primary development cells are present and the
   displayed all-inadmissible count is exact.
4. Enumerate the primary inadmissibility causes by density, realization, and
   capacity, distinguishing genuine resource limits from geometric or selector
   outcomes.
5. Confirm beta `1.00` remains descriptive only: no diagnostic record enters
   development cap qualification, stage outcome, drift, or held-out logic.
6. Confirm family summaries precede selector records and mechanism labels keep
   the reviewed one-directional reading.
7. Confirm the held-out seed was retired without construction and that the
   210-byte artifact is the intended retirement record.
8. Confirm no source or artifact was mutated after completion, including line
   endings, and that the shell-wrapper timeout did not alter scientific run
   semantics.
9. State exactly what the result rules out about this frozen R5 architecture,
   and what it does not rule out about graph-native rank-four atlases, tetrads,
   spin structures, curvature, stress-energy, or Einstein dynamics.

Do not modify the three JSON artifacts. Return a concise audit with exact cause
counts and either `RESULT-APPROVED` or `RESULT-REJECTED`.
