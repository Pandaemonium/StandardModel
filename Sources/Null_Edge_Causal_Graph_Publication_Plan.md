# Null-edge causal graph program: candidate publications

Compiled: 2026-06-21.

Companion to
[`Null_Edge_Causal_Graph_Strengthened_Program.md`](Null_Edge_Causal_Graph_Strengthened_Program.md),
[`Null_Edge_Causal_Graph_Research_Plan.md`](Null_Edge_Causal_Graph_Research_Plan.md),
[`Null_Edge_Causal_Graph_Theorem_Roadmap_2026-06-21.md`](Null_Edge_Causal_Graph_Theorem_Roadmap_2026-06-21.md),
and the bibliography
[`Null_Edge_Causal_Graph_Bibliography.md`](Null_Edge_Causal_Graph_Bibliography.md).

## Purpose

This document lists the publications the null-edge program could write, grounded
in the current theorem inventory rather than in aspiration. For each candidate it
records: the defensible core claim, what is already kernel-checked, what remains,
the lead venue, and the claim boundary that keeps the paper honest.

The program's house rule applies to every entry: lead with the finite,
kernel-checked algebra and combinatorics; keep continuum physics in an explicitly
conjectural layer. A small theorem with exact provenance and a kernel-checked
proof is a publishable artifact; a large speculative synthesis is not.

## How to read this plan

Each candidate has a readiness label:

```text
Banked       core result is trusted Lean (compiles, no s o r r y)
Near         core is kernel-clean draft Lean (no s o r r y) needing promotion + writeup
Synthesis    conceptual paper with partial banked algebra; needs framing, not new kernels
Aspirational gated on an unproven theorem; listed as a target, not a ready paper
```

Trusted vs draft is tracked exactly because it changes what can be claimed. A
draft module that is kernel-clean (no `s o r r y`) is strong evidence but has not
passed the semantic/convention review required to be a trusted public surface.

## Overview

| ID | Working title | Readiness | Lead venue |
| --- | --- | --- | --- |
| P1 | Mass as Plucker spread of null spinors | Banked | Formalized-math / math-phys |
| P2 | A finite Dirac square root of the Plucker mass | Near | Formalized-math / math-phys |
| P3 | Causal-diamond holonomy: finite gauge curvature without plaquettes | Banked | ITP / discrete gravity |
| P4 | Luminal checkerboard dynamics, formalized | Banked | ITP / math-phys |
| P5 | Finite quantum measure on causal events | Near | Foundations / quantum info |
| P6 | Flavor as an internal Gram-overlap problem | Synthesis | Physics (flavor), framed as structural |
| P7 | Relative-entropy monotonicity as a shared spine | Synthesis | Foundations / QI + gravity |
| P8 | The null-edge causal graph program (manifesto) | Synthesis | Foundations / quantum gravity |
| P9 | Cosmological-constant source visibility from diamond closure | Aspirational | Quantum gravity |
| P10 | Generations from the exceptional Jordan / triality layer | Aspirational | Math-phys / particle |
| P11 | A semantic proof-and-literature pipeline for a physics formalization | Synthesis | ITP / tools track |

## Part I: formalization papers (banked or near-banked)

These are the safest publications because the central object is already in the
kernel. They are best framed as formalized-mathematics artifacts: state the
informal physics claim, then exhibit the exact Lean theorem and its conventions.

### P1. Mass as Plucker spread of null spinors

Core claim. For a finite bundle of visible null spinors, the invariant mass
squared is the total pairwise Plucker spread of their null directions:

```text
det(sum_i psi_i psi_i^dagger) = sum_{i<j} |psi_i wedge psi_j|^2,
```

with mass zero exactly when the bundle is projectively collinear. A celestial
rewrite expresses the same scalar as a monopole/dipole deficit on `CP^1`.

Banked Lean. `PhysicsSM.Spinor.PluckerMass` (trusted): finite determinant
identity, real nonnegativity, mass-zero/common-direction criterion. Trusted
twistor-chart matching in `PhysicsSM.Spinor.TwistorPluckerMass` (promoted, no
`s o r r y`). `SL(2,C)` covariance of the determinant mass in
`PhysicsSM.Draft.NullEdgeSpinorGeometryTargets`
(`finBundleMomentum_det_sl2_invariant`, kernel-clean).

Remaining. Promote the celestial-moment wrapper (Bloch monopole/dipole form) and
the Gram-weighted generalization (see P6) into the trusted surface, or scope the
paper to the orthonormal case and cite the rest as extensions.

Lead venue. A formalized-mathematics venue (artifact + informal/formal
correspondence) with a math-physics secondary (the invariant-mass identity is of
independent interest to the massive spinor-helicity community).

Literature anchors. Arkani-Hamed-Huang-Huang massive spinor-helicity
(`1709.04891`); two-twistor mass models; Arkani-Hamed et al. positive
Grassmannian (`1212.5605`) for the `Gr(2,n)` minor-stratification angle.

Claim boundary. This is a finite linear-algebra identity and its geometric
equality condition. It is not a continuum Dirac limit and does not by itself
fix a mass spectrum.

### P2. A finite Dirac square root of the Plucker mass

Core claim. The program's quadratic invariants (determinant mass, squared
Plucker modulus, reduced mixedness, Laplacian seeds) are squares of a finite
first-order operator. Concretely, the chiral Dirac slash of the bundle momentum
squares to the trusted Plucker scalar, and the abstract block operator
`d + delta + Phi + Phi^dagger` squares into Laplacian, curvature, and
Higgs/Yukawa mass blocks.

Banked / near Lean (kernel-clean drafts). `NullEdgeDiracSlashCore`
(`(+---)` Weyl-block square), `NullEdgeBundleDiracPluckerCore`
(`chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass`),
`NullEdgeDiracTwoSheetCore` (branch projectors from `D^2 = m^2 I`),
`NullEdgeDiracMassShellProjectorsCore`, `NullEdgePluckerBargmannPhaseCore`
(complex phase companion), `NullEdgeSuperDiracBlockCore`,
`NullEdgeSuperconnectionExpansionCore`, `NullEdgeCovariantDifferentialCore`.

Remaining. Promotion + convention audit of the cluster; a single coherent
operator narrative tying the blocks together; explicit gamma-matrix and signature
conventions in one place.

Lead venue. Formalized-math or math-physics. The operator-factorization story is
the program's most distinctive math contribution after P1.

Literature anchors. Quillen superconnections; Chamseddine-Connes spectral
action; Ackermann-Tolksdorf generalized Lichnerowicz; Bianconi topological Dirac;
Foldy-Wouthuysen / Newton-Wigner / Thaller as branch-interpretation guardrails.

Claim boundary. The square-root identities are finite algebra. The
particle/antiparticle and localization reading of the two sheets must stay
conditional on the standard Dirac branch literature.

### P3. Causal-diamond holonomy: finite gauge curvature without plaquettes

Core claim. Gauge curvature on a causal graph can be measured by holonomy
defects across causal diamonds, with finite, kernel-checked invariance and
composition laws, replacing the lattice plaquette.

Banked Lean. `PhysicsSM.Gauge.CausalDiamondHolonomy` (trusted): Abelian gauge
invariance, non-Abelian endpoint covariance, gauge invariance of class functions
of the defect, and vertical and horizontal composition laws for path-pair
defects.

Remaining. The decisive structural test queued in
`PhysicsSM.Draft.CausalDiamondHigherGaugeAristotle`: whether the vertical and
horizontal composition laws satisfy the double-category / crossed-module
interchange law. A positive result upgrades the paper to a 2-categorical
discrete-gauge statement; a negative result is a publishable obstruction.

Lead venue. An interactive-theorem-proving venue or a discrete-gravity /
classical-and-quantum-gravity venue.

Literature anchors. Sverdlov causal-set gauge fields; Baez-Schreiber higher
gauge theory; Wilson lattice gauge theory as the contrast object.

Claim boundary. These are finite gauge-invariant defects and their composition
algebra, not a continuum Stokes theorem.

### P4. Luminal checkerboard dynamics, formalized

Core claim. Relativistic `1+1` propagation has an exact finite description by
lightlike microscopic steps with a corner chirality-flip amplitude, with the
Klein-Gordon-style recurrence appearing after squaring the first-order transfer.

Banked Lean. `PhysicsSM.Spinor.Checkerboard` and
`PhysicsSM.Spinor.CheckerboardDynamics` (trusted): history counts, corner-weight
powers, last-step recursion, iterated transfer-operator evolution, finite
Klein-Gordon-style recurrence. Kernel-clean closed forms in
`PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle`.

Remaining. This candidate can either stand alone or merge with the existing
`Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md` advance note.
The higher-dimensional universality statement is explicitly out of scope here
(it belongs to the dynamics program, not a banked paper).

Lead venue. ITP or math-physics.

Literature anchors. Earle checkerboard notes; Foster-Jacobson 4D checkerboard;
D'Ariano-Perinotti Dirac quantum cellular automata.

Claim boundary. A finite path-sum / recurrence result in `1+1`. It is not a
proof of higher-dimensional Dirac universality.

### P5. Finite quantum measure on causal events

Core claim. A finite, kernel-checked core of Sorkin's quantum-measure /
decoherence-functional framework: event-amplitude additivity, the grade-2 sum
rule, strong positivity of the rank-one decoherence Gram form, and tensor
closure on rectangular events.

Near Lean. `PhysicsSM.Draft.NullEdgeQuantumMeasureFiniteAristotle`
(kernel-clean): the listed finite measure-theory facts.

Remaining. Promotion and a convention note relating the finite core to the
strong-positivity and measure-extension literature; a clear statement of what is
and is not assumed (no continuum measure-extension claim).

Lead venue. A foundations-of-physics or quantum-information venue; possibly a
formalized-math venue if framed as a finite measure-theory artifact.

Literature anchors. Strong positivity of the decoherence functional
(`2011.06120`); quantum-measure extension (`1007.2725`); Tsirelson-bound
context for the Bell layer.

Claim boundary. Finite-state results only; the known failure of measure
extension in finite and causal-set examples must be stated, not hidden.

## Part II: synthesis and physics-facing papers

These papers carry partial banked algebra inside a conceptual frame. They are
higher-risk than Part I and must be written so the finite content is separable
from the interpretation.

### P6. Flavor as an internal Gram-overlap problem

Core claim. If visible mass is the Plucker determinant of a reduced visible
density, then flavor hierarchy and mixing are controlled by one internal
quantum-geometric object: the internal Gram overlap matrix `G`, via
`det(M G M^dagger) = w^dagger (Lambda^2 G) w`. Light fermions are internal
labels that stay nearly indistinct to the visible celestial qubit; heavy fermions
are nearly orthogonal.

Banked / near Lean. `PhysicsSM.Draft.NullEdgeGramWeightedMassAristotle`
(kernel-clean Cauchy-Binet exterior-square formula, orthonormal reduction to the
trusted Plucker theorem, rank-one massless limit, two-state partial-coherence
bridge); reduced-density definitions in
`PhysicsSM.Draft.NullEdgeCelestialMixednessAristotle`; hidden-isometry invariance
in `PhysicsSM.Draft.NullEdgeTwoTwistorHiddenChannelAristotle`; the exceptional
Jordan substrate `PhysicsSM.Algebra.Jordan.H3O` (trusted).

Remaining. The hard, honest part: show that a natural internal state space (the
Albert / `H_3(O)` side) produces non-generic overlaps. Use the quantum-marginal /
entanglement-polytope route (Klyachko `quant-ph/0511102`) to turn mass ratios
into allowed-spectrum data rather than free prose.

Lead venue. A particle-physics or math-physics venue, but only with the claim
boundary front and center: this is a structural hypothesis, not a derived mass
spectrum.

Literature anchors. Froggatt-Nielsen and split-fermion overlap suppression as
comparisons; Jarlskog invariant as the CP guardrail; Klyachko quantum marginals;
Dubois-Violette-Todorov and Boyle for the internal algebra.

Claim boundary. The Plucker / Gram identities are finite algebra. No claim of
predicted Yukawa couplings or mixing angles is made unless the internal overlaps
are derived, not assigned.

### P7. Relative-entropy monotonicity as a shared spine

Core claim (new, from the 2026-06-21 semantic cross-search). Two of the
program's branches that look independent are corollaries of one principle,
monotonicity of relative entropy:

```text
gravity / source branch : averaged null energy condition (ANEC)
mass / time branch      : monotonicity of visible proper-time concurrence
```

Faulkner-Leigh-Parrikar-Wang prove the ANEC from monotonicity of relative
entropy applied to a modular Hamiltonian; the proper-time branch restricts its
`d tau / dt = 2 sqrt(det rho_vis)` monotonicity claim to LOCC, which is the same
data-processing principle. The paper argues that the allowed-dynamics question in
both branches has one answer and one guardrail.

Banked / near Lean. The visible concurrence side has finite footing:
`NullEdgeCelestialMixednessAristotle` reduced densities, hidden-isometry
invariance, and the trusted Plucker determinant. The ANEC side is cited, not
formalized.

Remaining. A precise statement of which finite channels are LOCC on the
visible/internal cut; the explicit qubit-channel construction (see Ruskai
`quant-ph/0101003`, which gives the affine Bloch-ball action and extreme points
without needing general CPTP theory).

Lead venue. Foundations / quantum information with a gravity angle.

Literature anchors. Faulkner et al. ANEC (`1605.08072`); Jacobson
entanglement equilibrium; Connes-Rovelli thermal time; Ruskai-Szarek-Werner
qubit CPTP maps.

Claim boundary. The unification is conceptual plus finite-algebraic. The ANEC
itself is imported QFT, not reproved here.

### P8. The null-edge causal graph program (manifesto)

Core claim. A single theorem-first statement of the program: fundamental
histories are amplitudes over causal incidence structures; visible edges carry
null spinor/twistor data; mass is Plucker spread; gauge curvature is diamond
holonomy; the internal transition algebra (octonionic / Jordan) is separate from
visible spacetime. Includes the program's own corrections: drop the octonionic
equality-gap selection principle, treat finite valency as effective, and accept
generation-blindness of the visible geometry.

Banked Lean. This paper cites the whole trusted spine (P1, P3, P4) and the
kernel-clean clusters (P2, P5, P6) as evidence that the program is a finite
theorem spine, not a slogan.

Remaining. Mostly writing and honest scoping. The value is the falsification-aware
priority map and the two-layer architecture, not a new kernel.

Lead venue. A foundations or quantum-gravity venue, or a long, well-sourced
preprint that anchors the program and cites the formalization papers.

Claim boundary. The manifesto must not claim a replacement for quantum field
theory or general relativity. Its defensible novelty is the finite, Lean-verified
package plus the graph-native synthesis.

## Part III: aspirational targets (not yet papers)

These are listed so the program tracks them, but each is gated on a theorem that
is not yet proved. They should be promoted to Part II only when the gate clears.

### P9. Cosmological-constant source visibility from diamond closure

Gate. A finite visibility lemma: coherent / internal vacuum bookkeeping that
satisfies closure (`sum_f B_f = 0`) contributes only boundary-like or mean-zero
diamond source, while a visible Plucker excitation appears as a local closure
violation / diamond defect. This is the program's highest-leverage,
highest-risk physics target; it collides directly with everpresent-Lambda
causal-set cosmology.

Footing. Spinor-network closure as a moment-map constraint
(Dupuis-Speziale-Tambornino `1201.2120`); the trusted `SL(2,C)` invariance of the
determinant mass is the covariance half of the closure identity.

Decision threshold. If coherent hidden bookkeeping sources a volume term, or the
residual inherits the everpresent-Lambda amplitude tension without a suppression
mechanism, demote the branch.

### P10. Generations from the exceptional Jordan / triality layer

Gate. The Albert / `H_3(O)` internal layer must house the required Standard Model
family representation and mixing data, with three appearing structurally (broken
Spin(8) triality orbit) rather than by hand.

Footing. The exceptional Jordan algebra is already trusted Lean
(`PhysicsSM.Algebra.Jordan.H3O`, `H3OJordan*`); Boyle triality (`2006.16265`) and
Dubois-Violette-Todorov (`1806.09450`, `1808.08110`) are the sources; the
Barnum-Graydon-Wilce composite obstruction (`1606.09331`) is the rigidity
guardrail.

Decision threshold. A fourth generation, generation dependence forced by the
visible null geometry, or failure of the Albert layer to carry the family /
mixing data would weaken or kill the branch.

### Other aspirational targets

- A finite causal super-Dirac operator audited as an almost-commutative spectral
  triple (the master synthesis behind P2); gated on a natural odd self-adjoint
  first-order operator whose square simultaneously yields the Plucker, diamond,
  and Higgs/Yukawa blocks.
- Bivector / BF simplicity defect as the Klein-quadric pairwise mass criterion,
  with linear-simplicity and closure constraints; gated on the finite `B`-cochain
  interface compatible with the diamond composition laws.
- Higher-dimensional checkerboard universality (the dynamics theorem behind P4);
  gated on a scaling/renewal statement, not yet finite.

## P11. Methods: a semantic proof-and-literature pipeline

Core claim. A reproducible tooling contribution: a local, offline-capable
pipeline that fuses live Lean LSP goals/diagnostics, semantic search over Mathlib
and PhysLean, and vector search over a project's own papers and Lean source in a
Neo4j knowledge graph, accelerated on consumer Intel Arc (XPU) hardware, used to
drive a proof-specialist agent (Aristotle) for a physics formalization.

Footing. The pipeline exists and is wired in this repository (see
[`../Scripts/MCP_SERVERS.md`](../Scripts/MCP_SERVERS.md)): `lean-lsp` and
`lean-explore` MCP servers, the paper and document vector-search helpers
(`Scripts/lit/neo4j_paper_search.py`, `Scripts/lit/neo4j_doc_search.py`), and the
context-pack workflow for Aristotle submissions.

Lead venue. An interactive-theorem-proving tools track, or a physics-software /
formalization venue. The sound-use-of-AI-in-proof-discovery framing is explicitly
in scope at several such venues.

Claim boundary. The contribution is methodology and reproducibility, not new
mathematics. Any theorem found with the pipeline still stands or falls on the
Lean kernel.

## Recommended sequencing

1. P1 first. It is the most banked, most self-contained, and underpins the rest.
   Promote the celestial-moment wrapper, then write the artifact paper.
2. P3 and P4 in parallel. Both are trusted; P3 needs only the interchange-law
   decision to know whether it is a 2-categorical paper or an obstruction note.
3. P2 after a convention audit of the Dirac square-root cluster, since it is the
   program's most distinctive operator-level contribution.
4. P7 as a short, high-signal synthesis note; it captures a genuinely new
   cross-branch observation and is cheap to write.
5. P8 once P1-P4 exist to cite, so the manifesto rests on artifacts.
6. P5, P6, P11 opportunistically; P9 and P10 only after their gates clear.

## Honesty rules for every candidate

- State the informal physics claim and the exact Lean theorem side by side.
- Mark trusted vs draft (kernel-clean) status explicitly; never present a draft
  module as a trusted result.
- Record every convention: signature, gamma-matrix signs, chirality, Fano
  orientation, octonion basis order, root and hypercharge normalizations.
- Keep continuum interpretation in a separately labeled layer from the finite
  theorems.
- Cite a source only after its statement and conventions have been checked
  against ours.
