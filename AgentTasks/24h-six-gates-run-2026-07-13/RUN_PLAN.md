# 24-hour Section 7 six-gate run: RUN PLAN

Start: 2026-07-12 10:30 PDT.
End: 2026-07-13 10:30 PDT.
Landing freeze: 2026-07-13 08:30 PDT.
Final adversarial audit: 2026-07-13 08:30-10:30 PDT.

Executors: Codex and the user-started interactive Claude Code session,
co-equal when both are available. Coordinate through the AFPL mailbox and keep
this run's append-only `LEDGER.md` as its historical record. Aristotle is the
proof, strategy, and audit fleet. `AGENTS.md`, repository conventions, source
provenance, and the Lean kernel are binding.

Do not invoke Claude through an API or repository review wrapper. If the
interactive Claude Code session is unavailable, Codex and Aristotle continue
useful work and leave Claude-family review explicitly pending.

## 0. Mission

Attack all six open challenges in Section 7.1-7.6 of the program overview:

1. changing-lattice continuum convergence;
2. Lorentz invariance in distribution and the fixed-regulator no-go;
3. dynamics derived from a state or variational principle rather than merely
   supplied;
4. absolute scales, gravity, and the cosmological constant;
5. chirality and anomalies in the presence of gauge fields;
6. genuine bridge theorems between program threads.

The run is extremely ambitious but has a hard output discipline. Every gate
must end with a theorem, an exact no-go/counterexample, or a sharpened missing
hypothesis. A literature memo or simulation is supporting evidence, never the
gate result.

## 1. Starting state

Read the previous run's `FINAL_REPORT.md`, `HONEST_SCORECARD.md`, and
`MANUSCRIPT_CLAIM_DELTA.md` before claiming a lane.

Build state at handoff:

- aggregate axiom guard passed;
- full `lake build` passed;
- deterministic publication verifier passed twice with byte-identical output;
- source tree is intentionally dirty and not archival-ready;
- no user-owned release decision may be invented.

The inherited Aristotle project
`b7405f03-7bf4-47c2-9b3a-71ce9040df3f` targets the final changing-cell
projection convergence theorem. Inspect and download its newest snapshot
before submitting a duplicate.

The exact gate frontier is in `SECTION7_GATE_MATRIX.md`. That matrix is
binding whenever older task notes use broader language.

## 2. Startup procedure

1. Read `AGENTS.md`, `docs/NULLSTRAND.md`, `docs/CONVENTIONS.md`,
   `docs/BUILD.md`, and `docs/ARISTOTLE.md`.
2. Read `PACKET_REVIEW_2026-07-12.md` and `SECTION7_GATE_MATRIX.md`.
3. Run `aristotle list --limit 40` and record inherited verdicts.
4. Claim lanes in `LEDGER.md` before editing or submitting.
5. Inspect the exact Lean declarations and guards used as premises.
6. Generate a semantic context pack for every nontrivial submission.
7. Submit one grand-strategy Aristotle job and one hostile audit job.
8. Check the AFPL mailbox for interactive Claude Code handoffs and reviews.

## 3. Gate 7.1: continuum commuting square

### Flagship ladder

```text
arbitrary L2 density
-> explicit finite cell-average projection
-> projection tends strongly to identity
-> compose with the scaled live multiplier estimate
-> strong convergence on compact time intervals
-> R3 inverse-Fourier identification
-> position-space Dirac PDE commuting square
```

Priority order:

1. harvest `b7405f03`;
2. close `projectAt_tendsto_strong_L2` without changing representatives or
   weakening to a bounded box;
3. prove the walk/projection composition first on compactly supported smooth
   data and then by density;
4. formalize the inverse-Fourier and sign/normalization bridge only after the
   momentum-space theorem is complete.

Required controls: nonzero packet, nonzero time, moving ultraviolet boundary,
and a bounded-radius schedule that fails to exhaust momentum space.

Kill condition: if pointwise representatives or cell-boundary behavior block
the proposed projection, publish the exact obstruction and switch to a
representative-safe conditional expectation or Fourier-cell formulation.

## 4. Gate 7.2: Lorentz invariance

Split the debt into deterministic and distributional statements.

### L0-N: fixed finite support no-go

Formalize the rational boost

```text
B = [[5/3, 4/3], [4/3, 5/3]]
```

over a suitable exact scalar field. Prove it preserves the 1+1 Minkowski form
and that the orbit of an explicit nonzero future vector is infinite. Conclude
that no finite nonempty support containing that vector is invariant under
`B`. Generalize only if the exact proof remains legible.

### L0-D: distributional finite shadow

Prove invariance of an independent count law under a finite
measure-preserving relabeling/permutation. State exactly which part resembles a
Poisson sprinkling and which continuum measure-theoretic theorem is still
external.

Source work must verify the actual hypotheses and conclusion of the
Bombelli-Henson-Sorkin no-preferred-frame result and distinguish it from
"a realized sprinkling is invariant."

Required controls: zero-vector invariant support, identity boost, and a
non-measure-preserving relabeling that changes the law.

Kill condition: if the finite probability API obscures rather than clarifies
the continuum claim, land only the deterministic no-go and a source-audited L0
interface theorem statement with no fake assumption.

## 5. Gate 7.3: state-selected dynamics

Build on `ModularSelection`, `GateD/FiniteFirstLaw`,
`GateD/FiniteBernoulliMaxEntropy`, `SelfConsistentDecoder`,
`PlueckerPairGenerator`, and the free-plus-pair causal-cone theorem.

Flagship target:

1. define the Gibbs state for the actual two-level active pair generator;
2. prove it is the unique finite maximum-entropy state at the displayed
   normalization and expected-generator constraint;
3. prove its modular flow equals the pair-generated Heisenberg evolution up to
   the explicit beta rescaling;
4. prove covariance under the already-classified chiral phase action;
5. exhibit a phase-sensitive observable with nonzero evolution and a commuting
   control.

Fallback: specialize the existing generic modular-flow identity to the pair
sector and prove the operational witness, while recording maximum-entropy
uniqueness as the exact blocker.

The theorem may say "the declared equilibrium state selects the flow." It may
not say that the state, constraint, temperature, or free/interacting
alternation has been selected by nature.

## 6. Gate 7.4: scales, gravity, and Lambda

Treat this as three linked but separately graded lanes.

### 7.4a Absolute scale

Compose `DiscreteDimensionalTransmutation` with the Pluecker rest operator in a
new theorem that exposes the dimensionless initial coupling, beta coefficient,
and reference scale. Prove RG-step invariance and nonperturbative flatness of
the induced gap. Include the existing homogeneous-action collapse as the
negative control.

No measured mass value is predicted unless no laboratory datum or hidden scale
is used.

### 7.4b Gravity

Generalize the two-coordinate `JacobsonClausius.equation_of_state` to a finite
vector space with a separating/spanning family of variations:

```text
Clausius holds for every allowed variation
iff
the heat gradient equals temperature times the entropy gradient.
```

Then instantiate a nonzero finite soldering/source model. This isolates the
universality content of the finite first law. It is not Einstein's equation;
the continuum geometric identification remains a named hypothesis.

### 7.4c Cosmological constant

Build an exact finite response bridge:

```text
d log Z / d lambda = expected count
d2 log Z / d lambda2 = count variance
```

with a fixed sign convention, then compare the extensive independent-count
and subextensive fermionic-projection branches. Determine whether the response
identity narrows the candidate conjugate count; if not, prove the
non-identifiability explicitly.

Required controls: nonzero scale, nonzero variation, failed Clausius witness,
Poisson/extensive variance, and projection/subextensive variance.

## 7. Gate 7.5: gauge chirality and anomalies

Do not start from anomaly arithmetic. Start from the gauge-coupled operator.

Flagship ladder:

```text
gapped Hermitian Wilson/overlap kernel H(U)
-> exact gauge conjugation H(U^g) = G H(U) G^-1
-> sign/overlap covariance
-> Ginsparg-Wilson relation
-> trace index invariance
-> nonzero winding/index witness
-> finite integrated anomaly identity
```

The first 24-hour target is the abstract gauge-conjugation covariance and index
invariance theorem instantiated on the smallest nontrivial link-field witness.
Use `GateC2/GaugeOverlapInterface`, `GaugeIndexInertiaForm`, and existing
winding/index modules. Check PhysLean conventions before introducing a new
gauge API.

Required controls: nonidentity gauge transform with unchanged index, trivial
field with zero index, and a gap-closing path where invariance is not claimed.

Never infer an interacting chiral gauge theory or continuum anomaly from the
finite trace identity. The `StandardModelAnomalyAudit` rational sums are a
representation-level consistency control, not the gauge-field theorem.

## 8. Gate 7.6: bridge rather than rhyme

### A/E operator bridge

Construct an explicit canonical active-sector map between the generalized
Pluecker rest operator and the two-particle pair generator. Prove, at exact
scope:

- the intertwining/equality of the active `2 x 2` operators;
- transport of the cube law, spectral projectors, and generated evolution;
- a nonzero `z=3+4i` witness and `z=0` degeneration;
- a dimension/rank or representation obstruction to a naive full-sector
  equivalence.

This may establish a common active-sector operator. It does not establish that
the interaction is derived from the rest operator.

### Jordan-Clifford/null bridge

Only attempt a Pluecker bridge from a subspace and action actually derived from
the Jordan flag. A coordinate space named `Wweak = C^2` is insufficient. Build
on the landed Furey-Fock and exact `Z6` modules, but preserve every arbitrary
choice and external stabilizer theorem in the statement.

Kill condition: if every bridge requires a chosen basis or manually supplied
weak action, land the noncanonicity theorem and narrow the unification claim.

## 9. Fleet policy

Keep approximately 6-8 useful Aristotle projects across the active executor
lanes when capacity permits:

- 3-4 proof/composition jobs;
- 1 strategy job;
- 1-2 adversarial audit jobs;
- no filler.

Prefix jobs:

- Codex: `codex-6gate-`;
- Claude Code: `claude-6gate-`.

Submit a grand-strategy job at startup and every 90 minutes. Keep at least one
audit project running. Apply the two-hour stall rule, but download useful
snapshots before canceling or splitting.

Every proof submission must include:

- a typechecking target statement;
- exact seed imports and a semantic context pack;
- prohibited weakening;
- nonzero witness and wrong-shape control;
- expected axiom footprint;
- manuscript consequence and kill condition.

## 10. Claude Code and literature cadence

Interactive Claude Code responsibilities when available:

- hostile strategy and semantic review for all six gates;
- primary-source audits for Lorentz sprinklings, modular selection/Jacobson,
  overlap anomalies, and Jordan-Clifford bridges;
- independent review of Codex Lean statements using verbatim source;
- manuscript and overview wording only after theorem grades are settled.

Claude-family work occurs only in the user-started interactive Claude Code
session. Use the AFPL mailbox for durable requests, artifacts, and verdicts;
do not invoke a Claude API or repository review wrapper.

Run a literature/public-Lean pass at least every 30 minutes. Use Spark when
available, direct search otherwise. For theorem content, inspect primary full
text, not abstracts. Consult Mathlib and PhysLean before inventing physics APIs.

Priority literature topics:

- changing-lattice quantum-walk convergence and sampling/interpolation;
- Lorentz-invariant Poisson sprinklings and noncompact-group no-go theorems;
- finite maximum entropy, modular flow, and half-sided-inclusion limits;
- dimensional transmutation, entanglement equilibrium, and everpresent Lambda;
- overlap/Ginsparg-Wilson gauge covariance, index stability, and anomalies;
- operator intertwiners, tripotents, Jordan flags, and Furey exterior modules.

## 11. Schedule

| PDT window | Phase | Required output |
| --- | --- | --- |
| 10:30-11:30 | Reset | inherited-job verdicts, lane claims, context packs, first fleet |
| 11:30-15:30 | Wave I | continuum capstone; Lorentz no-go; gauge covariance statements |
| 15:30-19:30 | Wave II | modular pair selection; scale/gravity/Lambda targets |
| 19:30-23:30 | Wave III | A/E bridge; gauge index composition; continuum composition |
| 23:30-03:30 | Deep proof/counterexample | split stalled jobs, exact controls, hostile audits |
| 03:30-06:30 | Composition | integrate winners, guards, root imports, claim matrices |
| 06:30-08:30 | Manuscript/artifact | earned packet/manuscript changes, source audits, verifier |
| 08:30-10:30 | Hard audit | no broad new work; semantic audit, full build, scorecard, report |

Every cycle: harvest, inspect, integrate, verify, refill, ledger.

## 12. Division of labor

Codex defaults:

- 7.1 continuum analysis and Lean integration;
- 7.2 deterministic Lorentz no-go and finite ensemble theorem;
- 7.5 overlap gauge covariance/index composition;
- guards, root imports, exact fixtures, publication verifier, final build;
- independent audit of Claude Code prose and source claims.

Claude Code defaults when available:

- 7.3 maximum-entropy/modular derivation architecture and source audit;
- 7.4 gravity/Lambda primary-source and physical-meaning audit;
- 7.6 bridge semantics, Jordan-Clifford source work, hostile unification audit;
- independent audit of Codex theorem statements and manuscript promotions.

Shared:

- Aristotle harvest and hard blockers;
- 7.4 absolute-scale theorem design;
- A/E active-sector bridge;
- final scorecard and report.

## 13. Landing rule

A result is landed only after:

1. direct Lean check;
2. semantic and convention audit;
3. nonzero witness and negative/boundary control;
4. axiom footprint scan and guard pin;
5. root import where appropriate;
6. provenance/task note and ledger update;
7. manuscript wording at exact grade;
8. targeted build, aggregate guard build, and final full build.

Reject vacuity, hollow telescoping, docstring/kernel mismatch, false shape,
finite-to-continuum slippage, and source laundering even when the proof checks.

## 14. Completion criteria

At 10:30 PDT on July 13, the run succeeds only if:

1. every gate 7.1-7.6 has a recorded theorem, no-go/counterexample, or exact
   blocker;
2. at least two gates gain a new guarded kernel theorem of manuscript value;
3. 7.1 either closes arbitrary-`L2` projection convergence or records the
   precise remaining analytic lemma;
4. 7.2 has both a deterministic finite-support verdict and a source-audited
   distributional L0 statement;
5. 7.3 explicitly separates state-selected flow from selection of the state;
6. 7.4 reports scales, gravity, and Lambda separately;
7. 7.5 starts from a gauge-coupled operator, not only anomaly arithmetic;
8. 7.6 contains an actual map/intertwiner or a noncanonicity theorem, not a
   shared-slogan composition;
9. all landings pass guards and the full build;
10. the final verifier runs twice identically;
11. `HONEST_SCORECARD.md` and `FINAL_REPORT.md` report failures as prominently
    as successes;
12. Interactive Claude Code participation or unavailability is disclosed
    exactly.

The run does not succeed by making the overview sound more complete.
