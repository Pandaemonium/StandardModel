# Current objective

Run the null-edge / Furey / Standard Model autonomous loop as TWO CO-EQUAL
TRACKS. Every cycle must make real progress on both tracks, or state explicitly
in `meta-review.md` why one track produced no action this cycle. Durable state,
friction logging, Aristotle integration, mandatory literature review, local
Lean/docs work, Claude adversarial review, and Pro hard-question packaging all
still apply (see `AGENTS.md`).

Framing for both tracks: the program may be a finite obstruction calculus, with
invariant mass (`det P = m^2`) as its `d = 2` case. Track A hardens the
gate/theorem spine; Track B develops the obstruction-geometry / qubit-information
reframe. Neither track may overclaim past the `docs/NULLSTRAND.md` claim-boundary
labels.

## Track A - Convergent gate work (Gate C0 / C1 / H / F)

```text
Gate C0: external species health via RA-Wilson / regulator legality.
Gate C1: physical chiral release, requiring shared-operator-lineage release
         package, nonzero chiral/index witness, anti-vectorialization, and
         regulator-removal stability.
Gate H:  internal Furey/Baez/DVT legality, anomaly, and finite Dirac operator
         constraints.
Gate F:  prediction/codimension (absence theorems first, not mass magnitudes).
```

Current bounded actions:

1. Monitor and integrate returned jobs with the hardened integration helper:
   - C99b `309944d6-800a-4399-a2fc-3d294883ce28`
   - C99-v2 `b97de9d7-3661-4feb-a8b6-0e138bb597b5`
   - C89 `f481d8f1-4995-4b05-bfbc-398ca9b6810b`
   - C92 `03c6e63f-3a39-420e-81d3-173f2611b362`
   - C93 `6ff32d74-0779-424b-b8a2-9d767251c3ea`
   - C82 `893fe869-0e3c-40c5-b0cd-aa302f1a21ea`
   - C70 `e3986d7f-4928-4296-a7c8-cb4fb87eefae`
2. Treat C99 as integrated fallback/planning substrate only (no grading
   involution; no D/Gamma compatibility; basis-label sectors only;
   coordinate-basis kernel only; headline examples use native_decide).
3. If C99-v2 returns, audit for explicit Gamma, Gamma^2, D/Gamma compatibility,
   and no trusted native_decide index examples.
4. If C93 returns, audit and consider launching C94.
5. If both C92 and C89 return, revive C96 with concrete dependencies.
6. Prioritize the Gate H forbidden-operator / absence theorem
   (`LegalFiniteDiracForbiddenOperator`) as the near-term prediction-grade target.

## Track B - Exploration: qubit/information + generalization

References: `Sources/Null_Edge_Interaction_Ontology.md` (obstruction geometry),
`Sources/Null_Edge_Key_Conjectures.md` (conjecture 5 Plucker hierarchy,
conjecture 6 obstruction-stiffness unification),
`Sources/Null_Edge_P1_Plucker_Mass_Manuscript_Skeleton.md` (mixedness + measure
section), and `docs/NULLSTRAND.md` (mixedness/observer guardrail).

Two lanes, both active:

- Qubit / information: the mixedness reading `rho = P / Tr(P)`, observer-conditioned
  `det rho = (m / E_u)^2`; concurrence; Petz recovery and relative-entropy observer
  channels; "mass as impurity / entanglement between spinor direction and bundle
  label." Reuse the existing context packs (`null-edge-qubit-concurrence`,
  `null-edge-p6-mass-concurrence`, `null-edge-p7-petz-recovery`,
  `null-edge-relative-entropy-observer-channel`).
- Generalization: the Plucker hierarchy `e_k(Psi Psi^dagger)` for `k > 2`
  (Cauchy-Binet ladder; the Plucker-Sorkin section 8 already has the spine); the
  obstruction-stiffness unification (collapse two dictionary faces, e.g. the
  Plucker section and the Yukawa map, into one `(M, s)` construction); measure-valued
  null dust (continuum P1.5).

Track B may spawn Aristotle jobs once a target is sharp and self-contained
(for example: the finite mixedness identity `det rho = (m / E_u)^2`; the `k = 3`
Cauchy-Binet / minor identity; the two-face `(M, s)` collapse). Classify each as
independent / soft-dependent / hard-dependent like any other job.

Track B discipline (required). A Track B result counts as progress ONLY if it
produces at least one of:

```text
- a sharper conjecture with a NAMED failure mode;
- a finite theorem target stated precisely enough to hand to Aristotle; or
- a falsifiable prediction or absence theorem.
```

A "nice analogy" with no failure mode is not progress: record it briefly and move
on. Keep the claim-boundary labels; do not let mixedness/observer language leak
into the invariant `det P` statement (see `docs/NULLSTRAND.md`). If a Track B
generalization matures into a candidate change to the program's headline framing,
stop and surface it to the user (`questions-for-user.md`) rather than silently
reframing.

## Scheduling / policy

- Running Aristotle jobs do not automatically block new submissions.
- About 6-8 simultaneous jobs is acceptable when jobs are independent.
- Submit ready jobs from either track when concurrency is acceptable unless a
  running job's output is an explicit import, theorem prerequisite, or semantic
  dependency for the new target.
- Classify each candidate job as independent, soft-dependent, or hard-dependent
  before launch.
- Every autonomous-loop cycle must still perform literature search and
  meta-review, and the meta-review must check both tracks.
