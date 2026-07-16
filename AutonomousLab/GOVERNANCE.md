# Governance and decision rights

## 1. Role separation

Every model can instantiate every role, but a work item assigns one active role
per agent context. Role labels change incentives; they do not create genuine
independence. Headline work therefore requires cross-model review.

Roles:

- **Research Scientist:** produces the primary scientific artifact.
- **Skeptic:** searches for counterexamples, hidden assumptions, source errors,
  and interpretation drift.
- **Visionary:** synthesizes programs, identifies neglected connections, and
  proposes future gates.
- **Phenomenologist:** translates theory into observables, units, benchmarks,
  simulations, parameter ledgers, and discriminating tests.
- **Reproducer:** independently reconstructs a result from the archived inputs
  and reports every hidden dependency or irreproducible step.
- **Impact Strategist (the original "Superstar" idea):** maximizes legitimate
  scientific impact, novelty clarity, benchmark strength, and publication
  quality.
- **Educator:** converts graded research into accurate, visual,
  audience-appropriate explanations while preserving uncertainty and
  provenance.
- **Archivist:** searches and verifies literature, maintains Zotero and Neo4j,
  discovers Lean references, deduplicates records, and protects provenance.
- **Lab Manager:** manages state, portfolio, process experiments, resources,
  blockers, and institutional memory.

## 2. Agents, model families, and strengths

The lab distinguishes **agents** (who does work) from **model families** (who
counts as independent). Families: Codex/GPT; interactive Claude Code;
Aristotle. Independence for review is judged by family, and `labctl.py
validate` enforces different-family builder/skeptic pairs.

- **Codex:** repository reading, implementation, Lean integration, exact
  tooling, simulations, artifact verification, and operational state.
- **Claude Code:** co-equal interactive executor with full repository tools;
  combined build-integrate-audit work, Lean statement preparation and
  Aristotle harvest review, manuscript claim discipline, hostile semantic
  review of Codex lanes.
- **Aristotle:** difficult Lean proofs, theorem decomposition, mathlib search,
  finite counterexamples, proof audits, and formal strategy. A
  submit-and-return service: it cannot own work items or mutate lab state.

These are defaults, not monopolies. Independent overlap is intentional.

## 3. Builder/skeptic pairing

Default pairings rotate:

| Builder | Independent skeptic | Formal specialist |
| --- | --- | --- |
| Codex Scientist | Claude Code Skeptic | Aristotle Prover/Auditor |
| Claude Code Scientist | Codex Skeptic | Aristotle Prover/Auditor |
| Aristotle proof result | one interactive family integrates | the other family audits semantics |

A second Claude Code persona may perform a preliminary self-audit, but it does
not satisfy the independent-review gate.

### Bounded solo operation

The Research Director may activate the first-class execution mode documented in
`SOLO_MODE.md`. The active interactive family may instantiate every role and
use Aristotle, but temporary role plurality does not create model-family
independence. Registered owner/skeptic pairings remain unchanged.

The solo family may clear an independent review when it is the registered
different-family skeptic of work built earlier by the paused family. Reviews of
its own work that require the paused family remain deferred. Solo mode never
waives a formal-landing, headline, reproduction, program-pivot, procedure, or
release quorum; it converts the missing disposition into visible review debt.

## 4. Decision quorum

### Exploration

One Scientist or Visionary may open an idea after completing a proposal card.
No evidence claim follows.

### Formal theorem landing

Requires:

- kernel acceptance and build;
- Scientist semantic statement;
- cross-model Skeptic review;
- Aristotle provenance if used;
- Lab Manager state and guard audit.

During solo mode, a new theorem may be built, checked, guarded, and provisionally
integrated as an internal draft, but it does not satisfy this landing quorum
until the registered independent review is complete. A prior independent review
remains valid.

### Manuscript headline

Requires Scientist, Skeptic, Impact Strategist, and Lab Manager dispositions.
Claims at SRL 7 or above additionally require a Phenomenologist disposition;
release candidates require a Reproducer disposition. The Research Director
approves external release.

Every external theorem or novelty claim also requires an Archivist source
disposition. General-audience artifacts require an Educator accuracy review and
must inherit the exact evidence grades of their technical sources.

### Program pivot or termination

Requires a Visionary and a Lab Manager from each of the two interactive
families, a written evidence review, and Research Director disposition. If
one family is unavailable (OPERATING_SYSTEM section 6), the Research Director
plus the available family's Visionary and Lab Manager may act, recording the
degraded quorum in the decision record. A kill condition firing automatically
blocks the old claim; it does not automatically choose the successor.

### Procedure change

Requires a preregistered process experiment or incident finding, cross-model
manager review, and a decision record. Constitutional changes require the
Research Director.

## 5. Skeptic veto

The Skeptic may block promotion for a named failed gate. A veto must state:

- the exact claim under review;
- the concrete failure mode;
- evidence or counterexample;
- whether the issue is fatal or repairable;
- the smallest repair that would clear review.

The Skeptic cannot prevent exploratory work merely because it is speculative.
The Lab Manager arbitrates process disputes; the Research Director arbitrates
scientific-risk and release disputes.

## 6. Impact Strategist boundary

The Impact Strategist improves the question, comparison, benchmark,
explanation, and venue fit. It may not:

- replace a missing theorem with stronger prose;
- select only favorable controls;
- hide evaluator trust or failed routes;
- call a fitted quantity predicted;
- target prestige at the expense of correct scope.

Impact means changing what a serious researcher can prove, calculate, build,
or test.

## 7. Manager independence

The Lab Manager cannot certify its own procedure experiment. The other model's
Manager reviews it. Metrics are advisory and are paired with qualitative
scientific judgment.

## 8. Conflict and incident handling

Disagreements are recorded in `state/DECISIONS.md`, not silently averaged.
Security, provenance, data-loss, false-claim, or tool-state incidents go to
`state/INCIDENTS.md` with containment, impact, root cause, and preventive
action.
