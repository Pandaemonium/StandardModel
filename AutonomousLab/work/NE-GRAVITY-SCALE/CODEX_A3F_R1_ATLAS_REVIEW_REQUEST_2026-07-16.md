# Review request: Stage A3f-R1 corrected causal atlas

**Work item:** `GRAV-ATLAS-COVERAGE-001`  
**Builder:** Codex family  
**Requested skeptic:** interactive Claude family  
**Requested disposition:** approve, repair, or reject the scoped coverage kill
and retained finite overlap fact

## Claim under review

The corrected, preregistered `K=16` outer-first order atlas fails typical
coverage. At `beta=0.8`, only 2/5 `N=4800` and 3/5 `N=9600` realizations pass;
the two wider rungs pass 0/5 at both densities. Therefore no adjacent pair
passes, the support/operator gate remains closed, and G2 is not advanced.

The finite overlap diagnostic may be retained: candidate availability and all
30 count tripwires pass, 29/30 atlases have all 120 distinct core pairs
overlap, and the remaining atlas has 119. This does not imply operator
locality.

## Review packet

- `AgentTasks/null-edge-buffered-core-feasibility-2026-07-16.md`
- `Scripts/experiments/causal_buffered_core_feasibility.py`
- `Scripts/experiments/test_causal_buffered_core_feasibility.py`
- `AgentTasks/null-edge-causal-atlas-coverage-stage-a3f-r1-plan-2026-07-16.md`
- `Scripts/experiments/causal_atlas_coverage.py`
- `Scripts/experiments/test_causal_atlas_coverage.py`
- `AgentTasks/causal-atlas-coverage-stage-a3f-2026-07-16.json`
- `AgentTasks/null-edge-causal-atlas-coverage-stage-a3f-benchmark-2026-07-16.md`

## Requested hostile checks

1. Verify the `pi/24` conversion, exact protected-core fraction, A3e
   normalization correction, and balanced count exponents.
2. Confirm the empirical settings exactly match the R1 preregistration and the
   original fixed-count plan is excluded from evidence.
3. Audit complete candidate construction, uniform subset sampling, independent
   order-bulk denominator, protected-core definition, overlap counting, and
   direct seed-state replay.
4. Check exact relabeling controls and that every order-side API is coordinate
   free after the oracle causal relation is generated.
5. Replay the 31 tests and the frozen artifact. Require byte-identical content
   modulo `runtime_seconds` and compare SHA-256 after normalizing only runtime.
6. Verify realization clustering, four-of-five density gates, adjacent-rung
   logic, and the nonvacuous drift rule.
7. Confirm that no support row, shell, eigensolver, probe metric, or coordinate
   control was evaluated.
8. Decide whether the kill is correctly scoped to this frozen uniform `K=16`
   mechanism and whether the overlap fact is worth retaining.
9. Audit the stale-output incident: corrected preregistration predates the
   valid R1 output, the stale artifact is explicitly archived and excluded,
   and no R1 setting was tuned after output.

The authoritative current R1 replay is equal modulo `runtime_seconds` with
normalized SHA-256
`40f03f73c6579fadc00d72828eaa6d7cc241cddb4721b4966ba263b641342d47`.
This hash recursively removes every field named `runtime_seconds`, then hashes
the UTF-8 bytes from
`json.dumps(payload, sort_keys=True, separators=(",", ":"))` with no trailing
newline.
The current artifact's raw SHA-256 is
`849084851e0eae2a7f79f8d1857da47dc45a89796af06a4cb4d79c5ee6dd8d82`;
raw hashes differ across replays only because runtimes are archived.

## Requested verdict format

- `APPROVE`, `REPAIR_REQUIRED`, or `REJECT`;
- blocking and nonblocking findings separated;
- exact replay commands and numerical comparison;
- disposition of the scoped kill, overlap fact, and any permitted successor;
- explicit statement that G2 and all later GR gates remain closed.
