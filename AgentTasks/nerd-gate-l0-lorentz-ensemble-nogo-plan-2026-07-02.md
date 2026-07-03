# Gate L0 Lorentz-ensemble viability: no-go proof plan

Date: 2026-07-02.
Track: paper-level mathematics (not a Lean target yet).
Provenance: `Sources/NERD_4.md` section 5, responding to the external
review's identification of Lorentz-ensemble viability as the program's
biggest structural risk. This gate is the program's own no-go: it should be
owned, not feared.

## Why this gate matters

If L0.1 below is true, the ontology revision of v2.1 is forced: null edges
cannot be primitive finite adjacency data, they must be the link structure
of a causal order, and all dynamics must factor through damped kernels. If
L0.1 is false, a Lorentz-invariant finite-valency ensemble exists and the
ontology should be revisited (a pleasant shock). Either way the proof
attempt is cheap relative to its structural weight, and either outcome is
publishable as part of the program-paper (P4) foundations.

## L0.1 (no-go, to be proved)

**Claim.** No nontrivial ensemble of locally-finite-valency null-direction
graphs on a Poisson sprinkling of Minkowski space is Lorentz-invariant in
distribution.

**Proof strategy** (upgrading Bombelli-Henson-Sorkin from "direction field"
to "finite direction set"):

1. Suppose each sprinkled point is equipped, equivariantly and measurably,
   with a finite nonempty set of null directions (the outgoing edge
   directions). This is a measurable equivariant map from the sprinkling
   into finite subsets of the celestial sphere `CP^1`.
2. The Lorentz group acts on `CP^1` by Mobius transformations `SL(2,C)`.
   This action is noncompact and admits no invariant probability measure
   (no invariant mean); the stabilizer of a finite subset of `CP^1` is
   virtually compact, hence a conull equivariant selection of finite
   direction sets would produce an invariant probability structure that
   cannot exist.
3. Conclude via the Bombelli-Henson-Sorkin argument pattern (their theorem
   excludes equivariant direction selection in sprinklings; the finite-set
   version needs the stabilizer step above made precise).

**Care points.** "Nontrivial" must be defined so the empty selection and
measure-zero tricks are excluded; the equivariance is in distribution, so
the argument must run at the level of the joint law of (sprinkling,
decoration), not per-realization; and the celestial sphere here is the
boost orbit structure at a point, so the reduction from graphs to
direction sets at a point must be stated as a marginalization lemma.

## L0.2 (the escape that is also a theorem)

In a Poisson sprinkling, the **link relation** (covering relation of the
causal order: `x < y` with empty open interval) is defined
order-theoretically, hence exactly Lorentz-invariant in distribution.
Links are asymptotically null: the probability a related pair is a link is
`exp(-rho V(x,y))`, and in d = 4 the interval volume vanishes on the light
cone, so link partners concentrate along near-null separations at all
scales. The cost, paid honestly: valency is infinite in every frame.

## L0.3 (making infinite valency usable)

The Benincasa-Dowker / generalized causal-set d'Alembertian construction is
the known device converting infinite null-hugging valency into a finite
covariant operator: layered sums with alternating damped weights,
reproducing the wave operator plus curvature corrections on slowly varying
fields. Known documented cost: irreducible nonlocality and real fluctuation
issues for single realizations (Aslanbeigi-Saravani-Sorkin line); only
ensemble averages are covariant. Adapting these kernels to edge-spinor
transport is the genuine open front (failure mode F-G2).

## Consequences (already adopted as conventions)

The claim-scope conventions in `docs/CONVENTIONS.md` ("Tetrahedral lattice
and ensemble claim scope") and the roadmap (`docs/NERD_ROADMAP.md`) already
assume L0.1-true as the working position: tetrahedral = regulator, links =
ontology, damped kernels mandatory. Proving L0.1 converts a working
position into a theorem; refuting it triggers a roadmap revision.

## Execution

1. **Literature pass.** Pull Bombelli-Henson-Sorkin (gr-qc/0605006) and
   Benincasa-Dowker (1001.2725) full text via
   `Scripts/lit/neo4j_paper_search.py --chunks` (ingest first via the
   standard Zotero+Neo4j procedure if absent). Extract the exact BHS
   theorem statement and hypotheses; the upgrade must cite them precisely.
2. **Draft the argument** at paper level: definitions (decorated sprinkling,
   equivariance in distribution, nontriviality), the marginalization lemma,
   the stabilizer/no-invariant-measure step, and the BHS import.
3. **External audit.** Send the draft for adversarial review through the
   repo wrappers (`send_claude_review.py` / `send_gemini_review.py`) with
   the full argument text embedded; the failure mode to hunt is a hidden
   per-realization step where only distributional equivariance is
   available. An Aristotle strategy/audit job on the argument skeleton is
   also appropriate (this is a hard no-go analysis, exactly the kind of job
   the Aristotle policy encourages).
4. **Formalization decision afterwards.** If the argument is clean and the
   measure-theoretic footprint is small, parts (the stabilizer lemma, the
   no-invariant-measure fact if in Mathlib) may become Lean targets;
   default is paper-level only.

## Status labels

L0.1: PROPOSAL (proof strategy stated, not executed).
L0.2: THEOREM-shaped (order-theoretic invariance is standard; the
asymptotically-null estimate is a computation to write out).
L0.3: IMPORT (Benincasa-Dowker hypotheses not yet reproduced here).
