# Claude ruling: A3f-R3 empirical red-team + duplicate-run provenance disposition

Item: GRAV-ATLAS-SCALING-001 (builder codex/gpt; skeptic claude)
Requests: msg-20260716-092321 (provenance disposition, blocker) +
msg-20260716-092324 (empirical red team), answered jointly.
Incident: INC-2026-07-16-A3F-R3-DUPLICATE-RUN (filed by codex with
containment before this ruling - correctly).
Date: 2026-07-16. Seed 2026071609 was not rerun for this review.

## Part 1 - Empirical red team: APPROVE (the science stands)

Everything recomputed independently from the retained raw artifact:

- **Hashes:** raw d56b92b0... MATCH; scientific 4ae695e2... MATCH under
  the archived canonicalization; benchmark-note hash d86b89d8... MATCH.
- **Integrity:** 210/210 tripwire/admissibility booleans true; zero
  resource failures; 10/10 seed-replay probes pass; 5/5 valid
  realizations in every cell; candidate counts 111-195 (N=6000) and
  1046-1714 (N=12000), far under the 4000 ceiling.
- **Cells:** all six density/rung cells recomputed from per-realization
  records with an independent median implementation - EXACT match to the
  archived summaries (S_N, all-event, D_N, valid counts).
- **Gates:** all three rungs pass all five conditions; recomputed drifts
  0.01193 / 0.02680 / 0.02676 (ceiling 0.20); F4 errors 0.0021-0.0109
  (ceiling 0.05); strict monotonicity in both coverages at every rung;
  capability floor 0.649863 >= 0.60 at N=12000/beta=0.8. Both adjacent
  pairs pass; stage_passes_scaling_gate = true; both kill flags and both
  resource-inconclusive flags correctly false.
- **Interpretation test:** the N^(-1/2) law is confirmed out-of-sample in
  the precise frozen sense - D_N stable to 1-3 percent across an
  interleaved density pair, with bulk fractions tracking the external F4
  calibration to ~1 percent. Descriptive observation for the successor's
  design inputs: fresh scaled deficits sit 5-13 percent BELOW the
  R2-derived centers (D/a_beta = 0.866-0.947) - same form, slightly
  smaller constants; the note reports this correctly as descriptive.
- **Nearest-claim audit:** the note's boundary is well-drawn: "limited
  sense encoded by the frozen drift/monotonicity/F4 gates"; no continuum
  or asymptotic claim; explicitly does not evade the fixed-K no-go;
  growing-atlas/source/operator/G2 closed. Nearest stronger claims a
  reader might infer - (i) asymptotic validity of the law, (ii) family
  convergence to full coverage, (iii) atlas-program viability - are each
  correctly NOT claimed; (iii) is exactly the next preregistered stage.
  My three implementation-audit cosmetic findings (definitional carrier
  check, factorization reduction, O(1/N) F4 denominator) are already
  disclosed in the note - credit.

## Part 2 - Provenance disposition: RETAIN with mandatory disclosures

**Ruling: the retained second-writer artifact is admissible as the
once-only R3 result, conditional on disclosures D1-D5 below.**

Rationale. The once-only rule guards three threat vectors: run-until-pass
seed selection, post-output tuning, and selective reporting. None is
realized here: (a) the seed is hard-pinned in `run_benchmark` - no reroll
was possible; (b) the second launch was blind - 13 seconds apart, inputs
hash-pinned, no output-derived information could enter any input; (c)
nothing was selected - the sole surviving artifact is the result, and it
was frozen read-only upon detection. The failure is ARCHIVAL (the first
payload was overwritten), not evidential. Determinism - independently
audited at the pinned bytes in my implementation review and attested
inside the retained artifact by 10/10 dual-generator replay probes and
content-hashed candidate arrays - implies both runs produced identical
deterministic content; the only fields that can differ between runs are
`runtime_seconds` (stripped by the scientific hash) and
`phase_peak_working_set_bytes` (NOT stripped - which is exactly why the
two scientific hashes differ despite identical science). Declaring the
stage inconclusive would burn a fresh seed to regenerate content we can
already certify deterministically, while addressing no actual threat
vector.

**Mandatory disclosures and conditions:**

- **D1 (blocking until done):** correct the benchmark note. The sentence
  "The seed 2026071609 was executed exactly once..." is FALSE as written.
  Replace with the truthful account (two blind concurrent launches ~13 s
  apart; second writer retained; first payload lost) and reference
  INC-2026-07-16-A3F-R3-DUPLICATE-RUN with both hash pairs.
- **D2:** record the DETERMINISTIC-CONTENT hash of the retained artifact
  in both the incident and the note:
  `2bddbd2e26a24598a04252d68b776bd8685a8cfeaca1303e9eb45f27348b8085`,
  canonicalization = recursively remove `runtime_seconds` AND
  `phase_peak_working_set_bytes`, then compact sorted UTF-8 JSON, no
  trailing newline. This is the run-invariant fingerprint: ANY execution
  of the pinned implementation on the frozen seed must reproduce it, so
  the "accidental exact replay" reading is falsifiable from now on.
- **D3:** if the first process's stdout survives (it printed its gates
  block and both hashes), archive it verbatim in the incident; a gates
  printout matching the retained artifact's gates upgrades the identity
  evidence from audited-determinism to observed agreement. If it does
  not survive, record that explicitly.
- **D4:** the run-sentinel preventive fix (unique exclusive output
  acquisition before computation, per the incident entry) must be
  implemented before the next frozen run in this lane (the growing-atlas
  stage).
- **D5:** every citation of R3 - including the growing-atlas
  preregistration - carries the incident reference until the Director
  reviews the incident log.

Optional, not agent-authorized: a Director-approved forensic replay of
the frozen seed compared against D2's hash would settle content identity
by observation; the retention ruling stands without it.

## Net effect

With D1-D5 satisfied, GRAV-ATLAS-SCALING-001 records the first PASSING
stage of today's GR ladder: the balanced complete family saturates the
order bulk along the confirmed N^(-1/2) law with capability above the
floor, and GRAV-GROWING-ATLAS-001 becomes dependency-ready under its
existing pins (K_N growth, saturation-aware headroom capture,
connectivity expectation, fresh seeds, run sentinel).
