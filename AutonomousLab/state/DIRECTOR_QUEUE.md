# Research Director decision queue

Pending human-only decisions, newest at the bottom of each section. Agents
append entries with context and a stated default; only the Research Director
clears them (move to `DECISIONS.md` or annotate disposition inline). Silence
is never approval; a stale entry is surfaced by `labctl.py due` review
cadences, not acted on.

Entry format: ID, date, requested-by, decision needed, context, default if no
answer (default = safest inaction, never external release).

## Open

### DQ-001 Commit the 2026-07-12 run tree (2026-07-12, codex+claude)

The publication-run edits (Lambda paper + guards, T1 fermionic fork, Paper C
marks, run reports) and the new `AutonomousLab/` tree are uncommitted. Agents
do not auto-commit. Decision: commit (and whether AutonomousLab lands in the
same or a separate commit). Default: tree stays dirty; nothing ships.

### DQ-002 Dispose LAB-BOOTSTRAP-001 cross-family review (2026-07-12, claude)

Claude (Fable, interactive) performed the cross-family red-team of the AFPL
bootstrap and applied repairs (see `work/LAB-INFRA/` report and ledger).
Codex built the framework; Claude reviewed and co-edited it, so final
integration should be confirmed by you or by Codex re-review of the repairs.
Decision: accept the claude review as satisfying the independence gate and
authorize INTEGRATED after Codex confirms the repairs. Default: item stays in
RED_TEAM.

### DQ-003 Lambda paper release decisions (2026-07-12, claude)

T1 (fermionic fork) landed kernel-clean, so the review's condition for a
standalone paper is met. Decisions: named authors; standalone vs P9 section;
venue; completion of the secondary-reference primary-source pass (3
load-bearing citations verified, ~9 secondary remain). Default: internal
draft only.

### DQ-004 Named authors on all manuscripts (2026-07-12, claude)

Every manuscript carries a release-gate placeholder or single-name author
line. Decision: final author lists, affiliations, AI-use disclosure text.
Default: no external circulation.

### DQ-005 Venue selections for frozen papers (2026-07-12, claude)

Prior portfolio analysis recommends: E -> Quantum; A -> focused headline cut
to Quantum with formalization companion (math-phys fallback); FB -> arXiv +
Annals of Formalized Mathematics (AACA alternative); C -> specialist theorem
venue. Decision: confirm or redirect. Default: no submission.

### DQ-007 Re-scope DYN-MODULAR-001 (2026-07-12, claude+codex)

The work item asked for a *unique max-entropy Gibbs* state whose modular flow is
the Plücker pair evolution. The landed module `PairModularSelection.lean`
(kernel-clean, 9 theorems, cross-family audited through two rounds) achieves the
**partial** result: balanced central-shift selection + asymmetry kill +
noncommutation control + Hermiticity + a modular-Hamiltonian flow composition
(Gibbs reading conditional on partition `Z ≠ 0`). NOT achieved: S0 partition
positivity (certifies the Gibbs reading; Hermitian ⇒ true but needs a spectral
argument), S1 the `Uop = exp(-iαKop)` intertwiner, S2 max-entropy uniqueness.
Per the charter's truth-before-continuity rule, the agents will NOT silently
call the item achieved. Decision: (a) re-scope DYN-MODULAR-001 to the achieved
partial target and open S0/S1/S2 as successor work items; or (b) keep it open
until S0+S2 land. Default: item stays open (not INTEGRATED); the partial module
may still land on the draft-trust layer under its narrowed docstring pending
your call. No manuscript promotion either way.

Progress update (2026-07-12, claude): S2 (max-entropy uniqueness) is now
achieved at the DISTRIBUTION / eigenvalue level, kernel-clean:
`PhysicsSM/Draft/NullEdge/GibbsVariational.lean`
(`gibbs_maximizes_entropy`, Aristotle `5c0fa5d3`, guard [propext,
Classical.choice, Quot.sound], aggregate-built). It also supplies
`partition_pos` (bears on the S0 positivity gap). Still open: the non-commuting
OPERATOR-level S2 (in flight as codex `4ef06d09` full-Bloch qubit + claude
bridge design, operator core `643a0af0`), and S1 (`Uop = exp(-iαKop)`
intertwiner). This narrows but does not close DQ-007; the re-scope decision
remains yours.

Completion synthesis (2026-07-12, claude; nearest-work audit, scope-careful).
All three sub-targets are now substantially LANDED, kernel-clean:

- **S0 (Gibbs-reading certification).** `HermitianPartitionPositive.
  hermitian_partition_ne_zero` gives `Z != 0` for a finite Hermitian generator
  (enough to define `rho = exp(-beta H)/Z`); `GibbsVariational.partition_pos`
  gives `Z > 0` for the distribution partition. Boundary: strict matrix
  `Z > 0` (vs `!= 0`) is not separately proved; it is not needed for the Gibbs
  reading.
- **S1 (unitary intertwiner).** `CanonicalFullFockPairExponential.
  exp_mulVec_eq_canonicalUop` proves `exp(-i a Kop) . psi = Uop(...) psi` on all
  sixteen occupation coordinates for every `z` (incl. `z = 0`), over the
  canonical `PlueckerPairGenerator.Kop`/`Uop`. Boundary: this is the
  imaginary-time UNITARY exponential; the thermal Gibbs exponential is the
  separate `ThermalBzEuler` line.
- **S2 (max-entropy uniqueness).** Distribution level:
  `GibbsVariational.gibbs_maximizes_entropy` (general finite `N`, non-hollow via
  codex `GibbsVariationalControls`). Operator level (non-commuting):
  `QubitGibbsBridge.pairBloch_zero_eq_gibbsState` +
  `QubitEntropyBridge.pairEntropy_eq_vonNeumannEntropy` + codex `4ef06d09`
  strict full-Bloch maximization => the qubit fixed-energy max-entropy state IS
  the canonical Gibbs state of `Bz 1` at `beta = -artanh e`. Boundary: the
  operator-level result is the QUBIT (`Fin 2`) case; general-`N` non-commuting
  operator uniqueness would need `Matrix.log`/CFC (absent in v4.28) - it is the
  qubit witness plus the general distribution-level theorem, not one general-`N`
  operator theorem.

Remaining to make DYN-MODULAR-001 a single end-to-end claim: compose S0+S1+S2
with the landed `PairModularSelection` modular-flow theorems into ONE statement
"the pair evolution's modular flow selects the unique max-entropy Gibbs state",
and obtain codex's gpt-family skeptic review of that composite (requested
`msg-20260712-213320`). The decision (a: re-scope to the achieved multi-theorem
target and open the composite as its own item; b: keep open until the composite
lands) remains yours; no manuscript promotion either way.

### DQ-008 Upstream the CFC-free quantum Klein / matrix-log lemmas to Mathlib? (2026-07-12, claude, Impact Strategist)

The general non-commuting quantum Klein inequality
(`GeneralQuantumKlein.qKlein_nonneg`), the CFC-free spectral matrix logarithm
(`logHermitian`), and the entropy trace identity (`entropy_trace_eq_sum`) are
kernel-clean and fill a genuine gap in Mathlib v4.28 (no `Matrix.log`, no matrix
entropy, no operator convexity). The Impact Strategist audit
(`work/role-activations/role-20260712-235152-62ea3d23_deliverable.md`) grades
this a formalization contribution (impact rung 2-3), NOT a physics result, and
recommends a focused Mathlib PR as the highest-leverage grade-faithful action
(clean to Mathlib style: drop the `set_option maxHeartbeats` heavy step if a
lighter reindex exists, remove unused-simp lints). Decision: authorize preparing
a Mathlib contribution (external release + authorship + AI-use disclosure are
human-only). Default: keep internal as repo infrastructure; no external
contribution. No physics-venue submission of these results either way (they are
not a discovery).

**UPDATE 2026-07-13 (claude, lean-explore sweep - LARGELY KILLS THIS):** the
premise "fills a genuine Mathlib gap" is FALSE. PhysLean's `QuantumInfo` tree
already has the Umegaki quantum relative entropy `qRelativeEnt`
(`QuantumInfo.Entropy.Relative`, `Tr[rho(log rho - log sigma)]`, SAME object)
with `qRelativeEnt_joint_convexity` (stronger than our `qKlein_nonneg`),
sandwiched-Renyi DPI, finiteness, additivity, `qRelEntropy_self`; von Neumann
entropy `Svn`; and `HermitianMat.log` (= our CFC-free `logHermitian`) with
operator monotonicity, in a `ForMathlib` staging namespace. So our cluster
duplicates a SUBSET of mature prior work and is NOT a novel contribution.
Revised decision: do NOT prepare a Mathlib PR of the cluster. The only
plausibly-novel residual is the forward faithfulness `D(rho||sigma)=0 -> rho=sigma`
(did not surface in QuantumInfo's API); IF a repo grep confirms it is absent,
contribute that single lemma UPSTREAM to PhysLean/QuantumInfo, not Mathlib.
Broader redirect: audit the whole DYN-MODULAR info-theory lane against
`QuantumInfo.Entropy.*` before banking more rungs. See
`docs/EXTERNAL_LEAN_SOURCES.md`.

### DQ-009 Fund the rooted exponential recurrence R1 for Gate YM? (2026-07-13, claude, Lab Manager / Research Scientist)

The rooted-touch normalization bridge R0
(`GateYM.RootedTouchSum.boundedTouchSum_le_rootedTouchSum`, Aristotle
`70a0d064`, GAUGE-YM-EGF-001) is banked kernel-clean
(`[propext, Classical.choice, Quot.sound]`, no `sorryAx`; guard-pinned;
codex skeptic review requested). R0 is only the easy first rung of the repaired
rooted route after the unrooted `pairSum_le_expBound` recurrence was killed by an
audit counterexample. The pre-registered gate in the work item requires a fresh
portfolio decision before funding R1 (the hard rooted exponential recurrence /
`boundedTouchSum_le_kpPsi` route); R1 must NOT be auto-submitted. R1 is the
step that actually risks the same coefficientwise-domination failure mode that
sank the unrooted route, so it is a genuine spend-vs-expected-information
decision. Decision needed: authorize an Aristotle R1 attempt (with a stated
kill-condition and budget), OR park GAUGE-YM-EGF-001 at R0 and package the
per-fibre + unrooted-recurrence + rooted-R0-only status as the current honest
Branch-B frontier. Default (no action): park at R0; do not fund R1. Recommendation
deferred to the portfolio owner; the Skeptic notes R1 tractability is unproven and
the prior route in this family already produced a false-domination counterexample.

### DQ-010 Is an unbalanced conditioning projector an admissible null-edge primitive? (2026-07-14, claude, Research Scientist / Visionary)

The decisive Gate-1 no-go is now FULLY KERNEL-CHECKED (Aristotle `da29672d`,
`HNURealSpace/HalfSpaceHNU.lean`, standard-three, zero `sorry`): the HNU half-space
boundary window charge `Qwindow = 2(tr p - tr q) = 0`, so it DOUBLES, because the
HNU conditioning projectors are chirality-balanced. The Gate-1 formula generalizes
to `Qwindow = 2(2 tr P - d)` for a single-generator projector-conditioned shift
with conditioning projector `P` on a `d`-dim internal space: `= 0` (doubling) IFF
`tr P = d/2`; `!= 0` (single unpaired boundary defect) IFF `tr P != d/2`. The MATH
of the single-Weyl case is already confirmed (the Gate-1 report exhibits an
unbalanced rank-1-vs-3 in `d=4` giving `Qwindow = ∓4`). So single-Weyl EXISTENCE
reduces to one ontological decision, not more computation.

Decision needed: **Is a projector-conditioned null shift with an UNBALANCED
conditioning projector (`rank P != d/2` on the internal space) an admissible
null-edge primitive?** If YES -> the null-edge program CAN host a single 3+1 Weyl
at a half-space boundary via internal-dimension imbalance (Gate-1 doubling is only
the balanced `d=2` HNU choice); positive construction lane opens. If NO (only
balanced primitives admissible) -> the null-edge single-Weyl realization is
DEFINITIVELY IMPOSSIBLE (balance forced -> boundary always doubles); the
mapped-impossibility theorem is complete. This is the ontological "are
projector-conditioned null shifts admissible" fork, sharpened to the precise
rank-vs-half-dimension criterion. Ontological/mission-level (charter Sec 5), so a
Director call, not an agent one. Default (no action): the frontier stays mapped as
"balanced HNU doubles (kernel-checked); imbalanced case exists mathematically but
its null-edge admissibility is undecided". Analysis:
`AutonomousLab/work/NE-3PLUS1/CLAUDE_GATE_A_REDUCTION_2026-07-14.md`. Agent-side
cheap follow-ons (independent of the decision): kernel-check the general
`Qwindow = 2(2 tr P - d)` formula; if YES, build the smallest unbalanced (`d=3`)
half-space step and verify its single defect.

Progress update (2026-07-16, claude): the decision-independent follow-on is
DONE and banked. `Qwindow_single_generator` (= `2(2 tr P - d)`), the balance
criterion iff-pair, the unbalanced `d=3` rank-one witness (exact charge `-2`,
nonzero), and the balanced `d=2` control (charge `0`) are all kernel-checked
with build-enforced standard-three guards (Aristotle `da29672d` run
`f460ec66`), and the full package was independently rebuilt locally
(EXIT=0, 8037 jobs; `AgentTasks/aristotle-output/da29672d-.../
qwindow-general-20260716/`). The unbalanced `d=3` half-space witness the
bullet asked for is included. Nothing mathematical remains open on this
fork; the DQ-010 ontological admissibility call is the only open ingredient
of single-Weyl existence.

## Resolved

### DQ-006 Claude channel policy (resolved 2026-07-12)

Research Director disposition: do not use the Claude API or repository review
wrapper. Use only the interactive Claude Code session. The wrapper restoration
request is closed and BLK-001 is resolved by retirement of that channel.
