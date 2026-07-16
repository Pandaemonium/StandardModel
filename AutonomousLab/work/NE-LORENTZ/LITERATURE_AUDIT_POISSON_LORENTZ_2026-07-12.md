# Literature audit: Poisson sprinkling and Lorentz symmetry

Date: 2026-07-12  
Work item: `L0-DIST-001`  
Role: Codex Archivist  
Status: source-audited theorem map; Lean target not yet implemented

## Executive correction

The active program notes have repeatedly described Bombelli-Henson-Sorkin
(BHS) as proving that a Poisson sprinkling is the unique Lorentz-invariant
discrete point process. That is not the theorem in the cited paper.

BHS prove a no-equivariant-extraction theorem: there is no measurable
Lorentz-equivariant map from a Poisson sprinkling of Minkowski space to a
spacetime direction, even if the construction is local. Their corollaries rule
out an intrinsically selected finite frame, a finite set of timelike or
spacelike directions, and a finite-valency graph obtained equivariantly from
the sprinkling. The paper does not classify all Lorentz-invariant point-process
laws and does not prove that every non-Poisson or hyperuniform process breaks
Lorentz invariance.

The corrected positive statement is still strong and useful:

1. The homogeneous Poisson law is Poincare invariant because it is defined from
   the invariant spacetime volume measure.
2. A typical sprinkling cannot be used by a measurable equivariant rule to
   select a preferred spacetime direction or finite frame.
3. An equivariant finite-valency nearest-neighbor graph cannot be extracted
   from the sprinkling without additional structure.
4. These statements do not supply the null-edge direction register, tetrad,
   scale, or finite valency. Those remain decoration debts.

## Primary sources

### Bombelli, Henson, and Sorkin (2006/2009)

- Title: *Discreteness without symmetry breaking: a theorem*
- arXiv: `gr-qc/0605006`
- Journal: *Modern Physics Letters A* 24 (2009), 2579-2587
- URL: https://arxiv.org/abs/gr-qc/0605006
- Local graph key: `HG5ZI36W`
- Local method: full-text `--chunks` search, not abstract-only triage

Exact source-supported payload:

- No equivariant measurable map from Poisson sprinklings to timelike
  directions.
- The same obstruction extends to spacelike directions.
- No finite set of timelike and/or spacelike directions, including a reference
  frame, can be assigned equivariantly.
- No finite-valency graph can be associated to the sprinkling consistently
  with Lorentz invariance.
- Countably infinite direction sets are not excluded; finiteness is
  load-bearing.
- The theorem concerns full Minkowski space. A bounded region has boundary
  structure and therefore does not have the same symmetry group.

### Dowker and Sorkin (2019/2020)

- Title: *Symmetry-breaking and zero-one laws*
- arXiv: `1909.06070`
- URL: https://arxiv.org/abs/1909.06070
- Local graph key: `342HA4DS`
- Local method: full text ingested and chunk-indexed on 2026-07-12

Source-supported payload:

- A Poisson sprinkling cannot intrinsically select a spatial or temporal
  orientation.
- It cannot select a distinguished lattice of spacetime points.
- It cannot select a distinguished lattice of timelike directions.
- The proofs use a zero-one law for invariant events and strengthen the
  separation between distributional symmetry and structure extracted from an
  individual realization.

The paper explicitly says that BHS assumed only Lorentz invariance of the
sprinkling process, while its own zero-one-law arguments specialize to the
Poisson process. It also states that the loss of generality is unclear because
the authors knew no non-Poisson Poincare-invariant sprinkling example. This is
evidence about the state of knowledge, not a uniqueness theorem.

## What may be claimed

Safe imported claim:

> The homogeneous Poisson sprinkling law is Poincare invariant, and BHS prove
> that no measurable equivariant rule can extract a preferred finite spacetime
> direction set or finite-valency graph from a sprinkling.

Unsafe claim:

> Poisson sprinkling is the unique Lorentz-invariant discrete point process.

Also unsafe without an additional theorem:

> Every hyperuniform point process breaks Lorentz invariance.

The finite `LambdaFrameConstraint` theorem remains a separate result about
permutation-invariant covariance matrices. It is not a finite proof of the BHS
theorem and not a classification of Poincare-invariant point processes.

## Lean-ready decomposition

The full BHS theorem is measure-theoretic and uses a noncompact group action.
It should not be collapsed into a finite orbit-counting surrogate. A useful
formalization ladder is:

1. **Distributional invariance wrapper.** Define a point-process law on a
   measurable configuration space and prove that pushforward by a
   volume-preserving Poincare transformation leaves the Poisson law unchanged.
   This requires an existing Poisson random-measure API or a carefully scoped
   imported theorem wrapper.
2. **Equivariant observable zero-one lemma.** For an ergodic invariant law,
   prove that invariant measurable events have probability zero or one.
3. **No finite-direction extraction.** Assume a measurable equivariant map from
   configurations to a finite nonempty direction set and derive an invariant
   probability measure on a noncompact Lorentz orbit, contradicting the needed
   finite invariant measure theorem.
4. **Finite-valency corollary.** Show that a finite-valency equivariant graph
   construction yields a forbidden finite direction set at a selected vertex.

Likely blockers:

- a usable configuration-space and Poisson random-measure API in the pinned
  Mathlib version. The local Mathlib tree has only the one-variable
  `poissonMeasure` on natural-number counts, not a point-process API;
- measurable actions and pushforward laws for the Poincare group;
- the theorem that the relevant noncompact Lorentz homogeneous space admits no
  invariant probability measure;
- rooting or Palm conditioning without silently introducing a preferred point.

## Program consequences

- `L0FiniteSupportBoostNoGo` remains a valid finite no-go, but it is an analogy
  to the noncompact-orbit obstruction rather than a formalization of BHS.
- The positive L0 lane should target law-level covariance and explicitly keep
  realization-level finite decorations separate.
- A distributionally invariant sprinkling does not canonically provide the
  finite null directions needed by the null-edge carrier. Any direction
  register must be decorated, relational, or derived by a construction whose
  covariance and valency are separately proved.
- The cosmological-count fork cannot use BHS alone to conclude that a
  hyperuniform branch violates Lorentz invariance. That implication needs its
  own classification or no-go theorem.

## Required repository repairs

The following live claims were identified for correction:

- `Sources/Null_Edge_References.md`
- `PhysicsSM/Draft/NullEdge/LambdaFrameConstraint.lean` module documentation
- `Sources/Null_Edge_Cosmological_Constant_Manuscript_Draft_2026-07-12.tex`
- `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`

Historical task logs and Aristotle snapshots should remain unchanged as
provenance records; they are not current source-of-truth prose.
