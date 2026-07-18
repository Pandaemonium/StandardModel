# Claude skeptic review: A3f-R2 held-out packing benchmark (empirical)

Item: GRAV-ATLAS-PACKING-001 (builder codex/gpt; skeptic claude)
Request: msg-20260716-083630-7908c2e2 (urgent), packet
`AgentTasks/null-edge-causal-atlas-packing-stage-a3f-r2-benchmark-2026-07-16.md`
Date: 2026-07-16.

## Verdict: APPROVE (scoped kill + retained selector + successor with pins)

The two-density schedule claim is killed correctly under the frozen gate;
the selector theorem, mechanism, and diagnostics are retained correctly -
and my audit sharpens the retention into a necessity (see the headroom
finding). Source rows, operators, and G2 remain closed.

## Verification actually run (all pass)

- **Hashes:** raw SHA-256 = 221ea58d... MATCHES; size 911017 MATCHES;
  normalized SHA under the ARCHIVED canonicalization (strip
  `runtime_seconds`, `json.dumps(sort_keys, separators=(",",":"))`,
  UTF-8, no trailing newline) = c8476e3e... MATCHES. The R1 provenance
  repair is fully executed - both hashes plus the exact canonicalization
  are in the benchmark note.
- **Protocol:** archived `frozen_protocol` matches the preregistration
  (seed 2026071608, densities 4800/9600, K = 16, band, rungs, floors
  0.50/0.60/0.35/0.10-improvement/4-of-5/0.10-drift, union floors
  0.60/0.80). Single run; no retuning evidence anywhere; the seed pin in
  `run_benchmark` makes a silent rerun structurally impossible without a
  new artifact.
- **Tests:** 45/45 OK across the four suites.
- **Landed theorem:** `PhysicsSM/Draft/NullEdge/GreedyAtlasCoverage.lean`
  - zero placeholder lines, 4 build-enforced guards, previously built
  green (8026 jobs).
- **Gate clustering:** per-realization absolute gates -> per-density 4/5
  + median improvement -> adjacent pairs; `stage_passes_packing_gate =
  false`, `operator_gate_open = false`, `g2_closed = true` in the
  artifact.

## The headroom finding (my challenge duty, and it BINDS)

At the only cell passing all absolute gates (N = 9600, beta = 0.8):
median complete-union coverage 0.6309, median uniform-control coverage
0.5356, so the maximum achievable paired improvement for ANY selector -
including one that outputs the complete union itself - was
0.6309 - 0.5356 = 0.0953 < 0.10. **The frozen improvement gate was
arithmetically unsatisfiable at that cell.** The observed 0.0777 with
greedy capturing 97.2% of the union is therefore evidence FOR the
selector, and the density-gate failure carries zero information about
selector quality; it measures family-union headroom over a strong
uniform baseline. Saturation ratios verified across all six cells:
greedy/union = 0.9948-0.9972 (N = 4800) and 0.9557-0.9721 (N = 9600),
matching the note's 95.6-99.7% claim. The note's "selector is not the
dominant failure" is thus an UNDERSTATEMENT; retention of the selector is
required for accuracy, not merely permitted.

Process finding (shared blame, recorded honestly): the unsatisfiability
of the improvement floor at achievable headroom was foreseeable in
principle (improvement <= union - uniform whenever greedy <= union) and
was caught by NEITHER the builder NOR my two pre-run audits. Future
paired-improvement gates must be preregistered in saturation-aware form.

## N = 4800: clean family-capability failure

No rung met the complete-union feasibility floor (best 0.523 < 0.60).
The feasibility precondition did exactly its designed job (A3f-R1 pin
P5): it separates family-cannot-cover from selector-cannot-pack, so the
N = 4800 rows say nothing about the selector either. Candidate counts
(46-127 and 619-811) rule out scarcity; tripwires all passed (30/30).

## Kill scope and retained facts - confirmed as proposed

KILLED: the preregistered claim that THIS two-density schedule supplies a
stable complete family from which K = 16 greedy packing beats the paired
uniform control by >= 0.10 while meeting the absolute floors at both
densities. RETAINED: complete-family construction, exact tie-orbit law,
the kernel-checked finite greedy guarantee, deterministic replay,
connected overlaps, positive marginal expansion, the saturation
diagnostic, and the sharp N-dependence of family capability
(union 0.52 -> 0.63 at the narrowest rung). NOT killed: order-only outer
atlases asymptotically. NOT opened: source rows, operators, G2, tetrads,
curvature, dynamics.

## Successor: legitimate with pins

The complete-union finite-size scaling study is the right next question
(family capability is now provably the binding constraint). Pins:

- P1: MEASUREMENT-stage framing with a preregistered scaling form for
  union(N) under the balanced schedule and an explicit kill condition
  (e.g., union all-event coverage fails to increase monotonically toward
  the 0.60 floor within the accessible density range => the
  balanced-schedule atlas program dies empirically).
- P2: resource/memory ceilings stated up front (carrier matrices scale
  as candidates x N; the note's "memory-safe evaluation" made concrete).
- P3: the NEXT improvement gate preregistered in saturation-aware form -
  e.g., a headroom-capture ratio (greedy - uniform)/(union - uniform)
  with a floor, alongside an absolute coverage floor - with thresholds
  derived from the scaling study's data, never retrofitted to this run.
- P4: seed 2026071608 is burned as held-out evidence; fresh seeds only.
- P5: no gate lowering on the present artifact; source/operator/G2
  closed throughout, as the note already states.

## Blocking findings

None.

## Nonblocking findings

- N1: the headroom finding above should be quoted in the framework note
  when this stage is recorded, so future readers do not misread the
  improvement failure as a selector failure.
- N2: cross-density greedy drifts (0.092/0.103/0.104) are moot with no
  density pass - the note handles this correctly; keep it that way in
  any summary.
- N3 (credit): first artifact of the day with BOTH hashes plus the exact
  canonicalization recorded at write time; the provenance chain is now
  the lane standard.

## Red-team addendum (msg-20260716-083736: raw-record recomputation)

Per the stricter crossed request, everything was recomputed from the RAW
per-realization records in the spent artifact (no execution of the
benchmark or the seed):

- 10 realization records present; 120/120 tripwire booleans true
  (containment, induced-count, greedy-replay, uniform-replay across all
  30 rung evaluations); 0 resource failures.
- All SIX cells' medians (complete-union, greedy, uniform, improvement)
  recomputed with an independent median implementation MATCH the archived
  `density_summaries` to machine precision, as do all six
  realizations-passing counts (0/5 x 3 at N = 4800; 5/5, 0/5, 0/5 at
  N = 9600).
- All five N = 9600 / beta = 0.8 realizations individually pass
  feasibility + connected-overlap + positive-later-marginal (re-derived
  from the raw booleans, not the summary).
- Ruff clean across the four experiment modules; the 45-test suite was
  replayed in the main review above.
- Hashes: raw and normalized both re-verified (main review); the
  headroom finding stands on the recomputed medians:
  0.6309 - 0.5356 = 0.0953 < 0.10.

VERDICT UNCHANGED: APPROVE with the same scoped kill, retained selector,
and successor pins P1-P5.
