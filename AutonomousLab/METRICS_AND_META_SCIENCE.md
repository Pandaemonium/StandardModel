# Metrics and metascience

## 1. Purpose

Metrics help the Lab Manager detect drift, bottlenecks, and unreliable
procedures. They do not determine scientific truth or individual worth. AFPL
follows the spirit of DORA and the Leiden Manifesto: evaluate research on its
content, use quantitative indicators in context, and do not substitute venue
prestige for quality.

## 2. Lab health dashboard

### Epistemic quality

- percentage of headline claims with exact anchors;
- percentage with independent semantic review;
- source-audit completeness;
- forecast Brier score and confidence calibration;
- reopened/retracted claim rate;
- ratio of controls and counterexamples to positive headline results;
- external reproduction rate.

### Reproducibility

- clean-checkout build success;
- deterministic artifact rate;
- time for an independent agent to reproduce a result;
- percentage of simulations with pinned inputs, versions, and hashes;
- percentage of formal flagships with axiom guards.

### Throughput and flow

- median time from `SPECIFIED` to verified verdict;
- blocker age and recurrence;
- Aristotle proof success, split, and stall rates;
- review latency;
- work-in-progress and abandoned-work rates;
- fraction of time spent on dependency-critical work.

### Scientific value

- annual hard exams passed without weakening;
- recognized external obstruction resolved or sharpened;
- assumptions or free parameters eliminated;
- benchmark domains recovered;
- held-out predictions produced;
- negative results that close live branches;
- independent expert questions answered.

### Operational cost

- model and external-tool cost per verified result;
- build and proof compute consumption;
- duplicate-job rate;
- time lost to state, permission, or authentication failures;
- maintenance burden of new abstractions and dependencies.

## 3. Anti-Goodhart rules

- Theorem count, paper count, tokens, citations, and journal impact factor are
  never primary targets.
- Every metric is reviewed with representative artifacts.
- A metric that changes behavior adversely is suspended and investigated.
- Negative and replication results receive the same flow credit as positive
  results at equal rigor.
- Complexity added is charged against progress until it removes a blocker or
  supports reuse.
- Metrics are never used to claim a scientific result.

## 4. Forecasting

Every work item records probabilities for:

- theorem true as stated;
- proof landing within the estimate;
- semantic audit passing;
- manuscript consequence surviving external review.

The Lab Manager scores resolved forecasts monthly. Persistent overconfidence
changes planning buffers and review intensity; it does not lead to retroactive
probability edits.

## 5. Procedure experiments

Run at most one major procedure experiment per month. Use
`templates/PROCESS_EXPERIMENT.md` and preregister:

- proposed change;
- causal mechanism;
- primary and guardrail metrics;
- comparison period or A/B allocation;
- stop condition;
- review date.

Examples:

- focused versus full-repo Aristotle packages;
- builder-first versus skeptic-first theorem design;
- one versus two independent literature passes;
- different work-in-progress limits;
- role rotation frequency;
- mandatory prediction calibration before proof search.

Adopt only improvements that preserve epistemic guardrails.

## 6. Monthly manager report

The report answers:

1. What scientific uncertainty was reduced?
2. Which result was reproduced independently?
3. Which blocker consumed the most time, and why?
4. Where did forecasts fail?
5. Which process change helped or hurt?
6. Is the portfolio overinvested in one ontology, technique, or publication?
7. Which project should stop?
8. What is the single highest-leverage next institutional improvement?
9. What was the process-document maintenance burden per landed result this
   month (the P0 kill-condition input: if the framework costs more upkeep
   than it recovers in coordination for two consecutive months, simplify it)?
