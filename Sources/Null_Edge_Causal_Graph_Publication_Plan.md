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

The 2026-06-23 external review sharpens this rule into a publication contract:
do not ask one paper to be a theorem paper, an operator-physics synthesis, a
Standard-Model bridge, a quantum-gravity program, and an ontology manifesto at
the same time. P1 should be written as a tightly scoped theorem paper. P8 should
hold the broader ontology and conjectural synthesis. The higher-risk branches
can be cited as future targets only after the theorem-level contribution has
been made inspectable.

The later 2026-06-23 Pro critique adds one more non-negotiable refinement. The
normalized celestial state should be observer-conditioned, not merely written as
`P / Tr(P)` without saying whose trace/energy is being used. For a unit timelike
observer `u`, write `U = u.sigma` and use

```text
rho_{p|u} = U^{-1/2} P U^{-1/2} / Tr(U^{-1} P),
2 sqrt(det rho_{p|u}) = m / (p dot u).
```

This is now the publication-safe P1 phrasing: invariant mass is `det(P)`, while
celestial mixedness is the observer-conditioned ratio `m / E_u`. The same
critique also tightens the Higgs claim: Yukawa/Higgs coupling directly creates
left/right chirality coherence; visible mixedness appears only after an explicit
dephasing, partial trace, detector restriction, or observer channel.

The same guidance also gives the publication series a compact spine:

```text
Plucker geometry
-> observer-conditioned celestial qubit
-> chirality coherence
-> null-step dynamics
-> stable or metastable channel sectors.
```

This is the strongest non-manifesto version of the program. P1 proves the
Plucker/observer geometry, P2/P4 should build the null-step dynamics and
chirality-coherence bridge, P3 supplies the finite holonomy curvature carrier,
and P11 should wait until there is a concrete transfer channel, calibrated
momentum readout, and momentum-dependent spectral branch. The broad ontology is
useful only insofar as it helps organize these finite artifacts.

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

Every manuscript should include an early claim-status matrix with these labels:

```text
Theorem       trusted Lean or fully reviewed informal proof
Draft theorem kernel-clean Lean, pending semantic/convention review
Conjecture    precise statement with a proposed proof route or model test
Analogy       useful comparison to existing physics, not evidence by itself
Ontology      interpretive proposal supported only through lower-level results
```

This is not defensive writing; it is part of the method. It lets a referee
evaluate the finite theorem without being forced to accept the ontology.

## Overview

| ID | Working title | Readiness | Lead venue |
| --- | --- | --- | --- |
| P1 | Mass as Plucker spread of null spinors | Banked | Formalized-math / math-phys |
| P2 | A finite Dirac square root of the Plucker mass | Near | Formalized-math / math-phys |
| P3 | Causal-diamond holonomy: finite gauge curvature without plaquettes | Banked | ITP / discrete gravity |
| P4 | Luminal checkerboard dynamics, formalized | Banked | ITP / math-phys |
| P5 | Finite quantum measure on causal events | Near | Foundations / quantum info |
| P6 | Flavor as an internal Gram-overlap problem | Synthesis | Physics (flavor), framed as structural |
| P7 | Observer channels and relative-entropy monotonicity | Synthesis | Foundations / QI + gravity |
| P8 | The null-edge causal graph program (manifesto) | Synthesis | Foundations / quantum gravity |
| P11 | Stable particle sectors of finite causal quantum channels | Aspirational | Foundations / quantum information |
| P9 | Cosmological-constant source visibility from diamond closure | Aspirational | Quantum gravity |
| P10 | Generations from the exceptional Jordan / triality layer | Aspirational | Math-phys / particle |

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
rewrite expresses the same unnormalized scalar as a monopole/dipole deficit on
`CP^1`. The observer-facing state is obtained only after fixing a unit timelike
observer `u`:

```text
rho_{p|u} = U^{-1/2} P U^{-1/2} / Tr(U^{-1} P),
U = u.sigma.
```

Then `2 sqrt(det rho_{p|u}) = m / (p dot u)`. The simpler formula
`rho = P / Tr(P)` is a special-frame shorthand, not the invariant object.
Fixing `u` and the spatial momentum direction also gives a canonical
observer-relative two-null resolution of a timelike momentum:

```text
E_u = p dot u,
q = p - E_u u,
s = sqrt(E_u^2 - m^2),
n = q / s,
k_+ = ((E_u + s) / 2) (u + n),
k_- = ((E_u - s) / 2) (u - n),
k_+^2 = k_-^2 = 0,
k_+ + k_- = p.
```

This should be treated as a frame-conditioned decomposition theorem, not as an
ontology proof that those two null components are uniquely real.

Banked Lean. `PhysicsSM.Spinor.PluckerMass` (trusted): finite determinant
identity, real nonnegativity, mass-zero/common-direction criterion. Trusted
twistor-chart matching in `PhysicsSM.Spinor.TwistorPluckerMass` (promoted, no
`s o r r y`). `SL(2,C)` covariance of the determinant mass in
`PhysicsSM.Draft.NullEdgeSpinorGeometryTargets`
(`finBundleMomentum_det_sl2_invariant`, kernel-clean).

Remaining. Promote the celestial-moment wrapper (Bloch monopole/dipole form),
add the observer-conditioned normalization theorem, add the observer-relative
two-null decomposition lemma, and promote the Gram-weighted generalization (see
P6) into the trusted surface, or scope the paper to the orthonormal case and
cite the rest as extensions.

Lead venue. A formalized-mathematics venue (artifact + informal/formal
correspondence) with a math-physics secondary (the invariant-mass identity is of
independent interest to the massive spinor-helicity community).

Literature anchors. Arkani-Hamed-Huang-Huang massive spinor-helicity
(`1709.04891`); two-twistor mass models; Chin-Lee (`1407.2492`, Zotero
`3VBEK82X`) for the published mass/concurrence analogy; Peres-Scudo-Terno
(`quant-ph/0203033`, PRL 88, 230402) and Gingrich-Adami
(`quant-ph/0205179`, PRL 89, 270402) as reduced-spin/entanglement
frame-dependence guardrails; Fullwood-Vedral-
Guzman-Gonzalez (`2604.07471`) for the recent unnormalized linear-entropy /
Lorentzian-symmetry framing; the local Zotero guardrail keys are `QDUD2CDE`
for Peres-Scudo-Terno and `Z2MFSJJU` for Gingrich-Adami; Arkani-Hamed et al. positive Grassmannian
(`1212.5605`) for the `Gr(2,n)` minor-stratification angle.

Claim boundary. This is a finite linear-algebra identity and its geometric
equality condition. It is not a continuum Dirac limit and does not by itself
fix a mass spectrum. The invariant is `det(P)=m^2`; normalized mixedness is a
frame-relative `m/E` statement after choosing an observer time convention.

P1 paper contract. The first paper should make one headline contribution:

```text
Invariant Mass from Finite Null-Spinor Bundles:
A Frame-Audited Plucker Theorem with Observer-Channel Interpretation
```

Publication-safe opening claim:

```text
We study finite bundles of null spinor directions and prove that the
determinant of the associated unnormalized Hermitian momentum block is the
invariant mass squared of the resulting timelike momentum. This determinant
equals the total pairwise Plucker spread of the contributing null directions.
After fixing an observer-time normalization, the determinant of the normalized
visible state measures the frame-relative ratio m/E. This separation between
invariant and observer-normalized quantities gives a disciplined route for
interpreting massive propagation as coarse-grained null structure.
```

Required P1 sections:

1. definitions and conventions;
2. main determinant / Plucker theorem;
3. equality conditions: massless iff common projective null direction;
4. frame-audited normalization: `P` versus `rho_{p|u}`;
5. relation to prior art;
6. limited future theorem targets;
7. reproducibility appendix.

Novelty map:

| Category | Content |
| --- | --- |
| Known / close precedent | massive momentum bispinors, massive spinor-helicity, twistor/qubit geometry, Lorentz-frame warnings for reduced spin or entanglement |
| Likely new if framed carefully | finite null-edge packaging, formalized Cauchy-Binet bundle identity, explicit invariant-vs-normalized audit, theorem-status architecture |
| Conjectural extensions | Higgs-to-visible-mixedness, proper-time-as-impurity, stable particle sectors, source-visibility gravity, cosmological-constant leverage |

Reproducibility appendix checklist:

- repository URL or artifact bundle;
- commit hash;
- Lean and Mathlib/toolchain versions;
- exact build commands;
- theorem index with trusted/draft status;
- module dependency graph or import list;
- convention table for signature, Pauli matrices, spinor indices, and trace /
  energy normalization;
- statement crosswalk from paper notation to Lean declarations.

Robustness / toy-example checklist:

- boosted two-spinor or finite-bundle example showing `det(P)` invariant while
  observer-conditioned `rho_{p|u}` changes covariantly with the observer;
- alternate trace/energy normalizations and the conversion factor;
- nonorthogonal hidden-label example via the Gram-weighted theorem;
- simple qubit observer-channel example;
- at least one small causal-diamond picture only as future-facing context, not
  as part of the P1 proof burden.

### P2. A finite Dirac square root of the Plucker mass

Core claim. The program's quadratic invariants (determinant mass, squared
Plucker modulus, reduced mixedness, Laplacian seeds) are squares of a finite
first-order operator. Concretely, the chiral Dirac slash of the bundle momentum
squares to the trusted Plucker scalar, and the abstract block operator
`d + delta + Phi + Phi^dagger` squares into Laplacian, curvature, and
Higgs/Yukawa mass blocks. The Plucker determinant should be treated as the
kinetic symbol/eigenvalue of the graph Dirac block, not as an additional
additive mass block. The Higgs/Yukawa block is the internal mass block, and the
on-shell content is the constraint that the kinetic Plucker scalar equals the
Yukawa scalar.

Banked / near Lean (kernel-clean drafts). `NullEdgeDiracSlashCore`
(`(+---)` Weyl-block square), `NullEdgeBundleDiracPluckerCore`
(`chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass`),
`NullEdgeDiracTwoSheetCore` (branch projectors from `D^2 = m^2 I`),
`NullEdgeDiracMassShellProjectorsCore`, `NullEdgePluckerBargmannPhaseCore`
(complex phase companion), `NullEdgeSuperDiracBlockCore`,
`NullEdgeSuperconnectionExpansionCore`, `NullEdgeCovariantDifferentialCore`.

Remaining. Promotion + convention audit of the cluster; a single coherent
operator narrative tying the blocks together; explicit gamma-matrix and signature
conventions in one place. The Lorentzian version should be audited as a
Krein/J-self-adjoint operator rather than automatically as an ordinary
positive-definite Hilbert self-adjoint operator; otherwise the construction may
be only a Euclidean or Wick-rotated shadow.

Lead venue. Formalized-math or math-physics. The operator-factorization story is
the program's most distinctive math contribution after P1.

Literature anchors. Quillen superconnections; Chamseddine-Connes spectral
action; Ackermann-Tolksdorf generalized Lichnerowicz; Bianconi topological Dirac;
Foldy-Wouthuysen / Newton-Wigner / Thaller as branch-interpretation guardrails.

Claim boundary. The square-root identities are finite algebra. The
particle/antiparticle and localization reading of the two sheets must stay
conditional on the standard Dirac branch literature.

Higgs/Yukawa boundary. The safe theorem-level claim is that Higgs/Yukawa
insertions are gauge-legal chirality-changing mass operators, and that a scalar
off-diagonal flip can square to a mass block. The sharper physical chain is:

```text
Yukawa/Higgs coupling
-> left/right chirality coherence
-> explicit dephasing, trace, detector restriction, or observer channel
-> visible mixedness.
```

Do not double count this as an independent "Higgs mass" plus a separate
"Plucker mass." The important target is that the Higgs/Yukawa singular value and
the Plucker determinant represent the same on-shell scalar in two descriptions.
The integrated draft module `NullEdgeYukawaMassOperator` is the finite
bookkeeping bridge.

The Pro critique gives a useful finite two-level target for this bridge. For a
fixed-helicity chiral Hamiltonian

```text
H_h = [[-h |p|, m], [m, h |p|]],
E = sqrt(|p|^2 + m^2),
Pi_+ = (1 / 2) (I + H_h / E),
```

the left/right coherence of the positive-energy projector is

```text
2 |(Pi_+)_{LR}| = m / E.
```

After an explicit chiral dephasing channel `Delta_chi`, the dephased
determinant gives the same ratio. This is the publication-safe Higgs bridge:
the Yukawa/Higgs block creates coherent left/right coupling first; normalized
visible mixedness is the shadow seen after a named observer/dephasing channel.

Phase guardrail. The complex Plucker amplitude should be kept in P2, but raw
pair phases are not themselves physical spin observables. Individual
`psi_i wedge psi_j` phases change under spinor rephasings. The safe finite
targets are rephasing-invariant Bargmann/Pancharatnam products, plus the
standard massive `SU(2)` little-group representation for physical spin.

### P3. Causal-diamond holonomy: finite gauge curvature without plaquettes

Core claim. Gauge curvature on a causal graph can be measured by holonomy
defects across causal diamonds, with finite, kernel-checked invariance and
composition laws, replacing the lattice plaquette.

Banked Lean. `PhysicsSM.Gauge.CausalDiamondHolonomy` (trusted): Abelian gauge
invariance, non-Abelian endpoint covariance, gauge invariance of class functions
of the defect, and vertical and horizontal composition laws for path-pair
defects.

Remaining. The decisive structural test queued in
`PhysicsSM.Draft.NullEdgePathPairInterchange`: the vertical and horizontal
composition laws satisfy the double-category-style interchange law, and the
Abelian `2 x 2` grid defect factors as expected. The next step is no longer
"does interchange hold?" but the crossed-module / fake-flatness wrapper:
identify which finite `H`-valued 2-cell labels, endpoint actions, and
surface-transport conditions are actually forced by the trusted path-pair API.

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

New dynamics target. The Pro critique identifies a discrete null-step quantum
walk as the cleanest bridge from checkerboard kinematics to chirality coherence:

```text
U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x),
cos(omega a) = cos(k a) cos(mu a).
```

For a nondegenerate eigenstate, the `z`-chirality coherence tends in the
continuum limit to `mu / sqrt(k^2 + mu^2) = m/E`. This should become the
combined P2/P4 dynamics target: luminal conditional shifts, chirality-flip
amplitude, Dirac dispersion, and observer-visible `m/E` in one finite model.
This is the strongest proposed bridge from the kinematic Plucker theorem to a
real dynamics paper, because it puts the lightlike shift, chirality flip,
dispersion relation, and proper-time ratio in one auditable finite model.

Lead venue. ITP or math-physics.

Literature anchors. Earle checkerboard notes; Foster-Jacobson 4D checkerboard;
Strauch's discrete/continuous quantum-walk Dirac limits (`XK9ZRDNJ`,
`QSB24VR9`); Arrighi-Nesme-Forets on the Dirac equation as a quantum walk
with higher-dimensional convergence (`4F87TGCN`); D'Ariano-Mosco-Perinotti-
Tosini 3+1 Dirac quantum walk (`JZEJ4VXA`); Sato-Katori's Dirac quantum walk
with ultraviolet cutoff (`G7NXEZBU`); Arnault-Perez-Arrighi-Farrelly on
discrete-time quantum walks as fermions of lattice gauge theory (`PTHQB2RM`);
Arrighi-Facchini-Forets on discrete Lorentz covariance (`VHPN6G7D`); and
Bisio-D'Ariano-Perinotti-Tosini QCA derivations of Weyl, Dirac, and Maxwell
dynamics (`BVJBTK8J`, `KCQGEDJE`).

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

### P7. Observer channels and relative-entropy monotonicity

Core claim. Two of the program's branches that look independent are controlled
by one instruction:

```text
define the observer channel first.
```

Once the visible/internal or diamond/source observer map is named, both branches
ask for monotonicity of information under that map. The mass/time branch must
now be stated frame-relatively:

```text
gravity / source branch : averaged null energy condition (ANEC)
mass / time branch      : monotonicity of frame-relative visible m/E concurrence
```

Faulkner-Leigh-Parrikar-Wang prove the ANEC from monotonicity of relative
entropy applied to a modular Hamiltonian; the proper-time branch restricts its
`d tau / dt = 2 sqrt(det rho_vis)` monotonicity claim to LOCC and to a fixed
observer-time convention, which is the same data-processing principle plus the
frame audit. The paper argues that the allowed-dynamics question in both
branches has one answer and one guardrail.

The new useful sharpening is recoverability, with a strict caveat.
Recoverability is not the same thing as invisibility. Small data-processing loss
means the fine information can be reconstructed from the observer output.
Invisibility means distinct fine inputs have nearly indistinguishable observer
outputs. Petz recovery and the Fawzi-Renner approximate-Markov-chain theorem are
therefore diagnostics for reversible coarse-graining, not automatic erasure
claims. P7 can support P9 only after the source-visibility defect says which
notion is being measured.

Banked / near Lean. The visible concurrence side has finite footing:
`NullEdgeCelestialMixednessAristotle` reduced densities, hidden-isometry
invariance, and the trusted Plucker determinant. The ANEC side is cited, not
formalized. The next finite Lean layer should avoid full Type-III QFT and start
with matrix channels:

- `det_normalizedMomentum_eq_det_div_trace_sq`;
- `sl2_det_conj_invariant`;
- `restFrame_iff_normalizedMomentum_maximallyMixed`;
- `massRatio_eq_sqrt_one_minus_blochNormSq`;
- `relativeEntropy_partialTrace_monotone`, or a focused finite data-processing
  lemma if the mathlib API supports it;
- `massRatio_monotone_under_unital_bloch_contraction`;
- `petzRecoverable_iff_relativeEntropyLoss_zero`, if a small finite matrix
  statement can be isolated;
- `recoverabilityGap_bounds_sourceVisibilityDefect`, initially as a definition
  and conjectural inequality.

Remaining. A precise statement of which finite channels are LOCC on the
visible/internal cut; the explicit qubit-channel construction; and a finite
observer-channel API shared by P7 and P9. Ruskai-Szarek-Werner
(`quant-ph/0101003`, DOI `10.1016/s0024-3795(01)00547-x`, Zotero `M6HR9WD6`)
gives the affine Bloch-ball form and is the practical route for the celestial
qubit before we attempt a general CPTP formalization.

Lead venue. Foundations / quantum information with a gravity angle.

Literature anchors. Faulkner et al. ANEC (`1605.08072`, Zotero `B68T629C`);
Ceyhan-Faulkner QNEC/ANEC recovery (`1812.04683`, `TFGTQQTU`); Casini's
relative-entropy Bekenstein bound (`0804.2182`, `S9FTNNRU`); Fawzi-Renner
recoverability (`1410.0664`, `BHNTND4W`); Ruskai-Szarek-Werner qubit CPTP
maps (`quant-ph/0101003`, `M6HR9WD6`); Jacobson entanglement equilibrium
(`1505.04753`, Zotero `7V9FV86B`); Connes-Rovelli thermal time.

Optional extensions. The QGT/QFI and resource-theory material is promising but
should remain gated. The safe finite claim is that the celestial `CP^1` layer
already has a Fubini-Study/Berry geometry. The stronger claim that mass is an
asymmetry or coherence monotone should wait until a resource theory and its free
operations are fixed. Yamaguchi-Mitsuhashi-Shitara-Tajima (`2411.04766`,
`45FTB5VF`) is a useful source if that gate opens. The Renyi-alpha family
(`1310.7178`, `MKJFW9HM`) is likewise a theorem menu, not a physics claim: only
parameter ranges with data processing should be allowed.

Claim boundary. The unification is conceptual plus finite-algebraic. The ANEC
and QNEC themselves are imported QFT/operator-algebra theorems, not reproved
here. The finite paper proves or defines Type-I matrix analogues and uses them
as disciplined targets for later diamond-source work.

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

### P11. Stable particle sectors of finite causal quantum channels

Core claim. A particle should not be defined merely as a bundle of null edges.
The stronger finite definition is spectral: a particle species is a stable or
metastable sector of a causal transfer channel, with mass and lifetime read from
the channel's momentum-dependent branches.

The schematic target is a completely positive transfer channel `T` with
observable dynamics `T^dagger`. Particle identity should live in fixed
observable algebras, noiseless subsystems, peripheral modes `|lambda| = 1`, or
long-lived modes `|lambda| < 1` close to one. With a discrete time step
`Delta t`, a metastable eigenvalue gives

```text
tau_a = - Delta t / log |lambda_a|.
```

With momentum labels present, the desired branch form is

```text
lambda_a(k) ~= exp(-((Gamma_a(k) / 2) + i E_a(k)) Delta t),
E_a(k)^2 ~= |k|^2 + m_a^2.
```

Banked / near Lean. No direct theorem package yet. The relevant ingredients are
the finite quantum-measure core, hidden-channel invariance modules, observer-loss
bookkeeping, checkerboard transfer recurrences, and the Dirac square-root
cluster.

Remaining. Define the finite causal quantum process before proving spectral
sector statements. A normalized CPTP channel by itself erases absolute energy
scale, so the model needs a separate calibrated momentum readout
`P = M(rho)` before observer normalization. The first useful theorem is not a
broad particle-ontology statement, but a tiny matrix/channel lemma connecting a
stable branch, a momentum readout, and the mass-shell relation.

Literature anchors. Blume-Kohout, Ng, Poulin, and Viola's preserved-information
/ noiseless-subsystem theory (`arXiv:0705.4282`, PRL 100, 030501, Zotero
`RW63ZR9E`) and Hawkins, Markopoulou, and Sahlmann's quantum causal histories
(`hep-th/0302111`, Class. Quantum Grav. 20, 3839, Zotero `KDEECE8M`) are prior
art. The null-edge novelty would be the added null-spinor momentum readout,
Plucker mass invariant, gauge-diamond curvature, and observer-channel
formalization.

Claim boundary. This is not ready to be the main paper. It becomes publishable
only after a concrete finite channel, readout, spectral branch, and mass-shell
identity are all specified.

First proof gate. Aristotle's P11 strategy job
(`40413c03-ef9e-4692-be1e-7a60df4ce689`) identified the calibrated readout as
the first load-bearing formal object:

```text
readout(P) = (normalize(P), Tr(P)),
reconstruct(readout(P)) = P.
```

The first P11 proof package should prove determinant rescaling under
normalization, exact readout reconstruction when `Tr(P) != 0`, and an explicit
counterexample showing that two different unnormalized momentum blocks can have
the same normalized state but different determinant mass. This should precede
the spectral-sector package, because a normalized channel alone cannot define
invariant mass.

## Part III: aspirational targets (not yet papers)

These are listed so the program tracks them, but each is gated on a theorem that
is not yet proved. They should be promoted to Part II only when the gate clears.

### P9. Cosmological-constant source visibility from diamond closure

Gate. A finite visibility lemma that separates three notions that should not be
conflated:

```text
visible momentum closure  C = sum_i w_i n_i = 0
BF / surface closure      sum_f B_f = 0
observer invisibility     source functional vanishes or is boundary-only
```

New finite footholds. The P9 branch now has a small theorem spine, but not yet a
cosmology paper. The integrated draft modules
`PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore`,
`PhysicsSM.Draft.NullEdgeP9FluctuationScaling`, and
`PhysicsSM.Draft.NullEdgeP9WeightedFluctuation`, and
`PhysicsSM.Draft.NullEdgeP9UniformSuppression` prove two pieces that make the
branch sharper:

- boundary-exact bookkeeping is invisible to closed bulk tests;
- successive boundary maps produce no bulk source under a chain-complex law;
- antisymmetric finite source relabelings are mean-zero;
- a closed visible fan has moment mass square `E^2 / 4`, so visible closure is a
  rest-frame condition rather than source invisibility;
- independent two-sign residual sources have zero ensemble mean and exact second
  moment `N * 2^N`, giving a finite variance-`N` / RMS-`sqrt(N)` pilot;
- weighted independent residual sources have normalized variance
  `sum_i amp_i^2`, giving the finite algebra needed for nonuniform diamond
  cells, suppression factors, or residual-source weighting;
- uniformly spreading a fixed total scale `A` over `N` independent sign cells
  gives normalized second moment `A^2 / N`, the first exact finite suppression
  law for the branch.

The finite visible-fan theorem is:

```text
closed_visibleFan_mass_eq_restEnergy
closed_visibleFan_massSource_pairing_eq_restEnergy
```

Thus `C = 0` usually means a massive rest-frame fan, not no matter. The finite
fluctuation theorem is:

```text
ensembleMeanTotal_eq_zero
ensembleSecondMoment_eq_card_times_configs
weightedEnsembleSecondMoment_eq_amplitudeSqSum_times_configs
normalizedWeightedSecondMoment_eq_amplitudeSqSum
normalizedUniformSecondMoment_eq_totalSq_div_card
```

Together these results clarify the gate. Coherent / internal or BF-closed
bookkeeping should contribute only boundary-like or mean-zero diamond source,
while visible Plucker mass/energy should appear as a bulk source term. Residual
source noise can then be tested against the finite `sqrt(N)` scaling theorem,
against the weighted `sum_i amp_i^2` suppression theorem, or against the uniform
`A^2 / N` suppression law. This remains the program's highest-leverage,
highest-risk physics target because it collides directly with everpresent-Lambda
causal-set cosmology. The branch must be quantitative: either derive a
Sorkin-style `1 / sqrt(V)` law from finite counting/source data, or prove a
different residual-amplitude law from the stated observer channel. A mechanism
that merely declares vacuum bookkeeping invisible relocates the cosmological
constant problem.

Footing. Spinor-network closure as a moment-map constraint
(Dupuis-Speziale-Tambornino `1201.2120`); the trusted `SL(2,C)` invariance of the
determinant mass is the covariance half of the closure identity. The new P9
modules are kernel-clean draft Lean and should be cited as draft theorem
footholds until they receive semantic review and promotion.

Next finite definitions. Define a `DiamondSourceVisibility` API before claiming
cosmology:

- finite diamond / screen;
- visible fan and closure vector on that screen;
- BF/surface closure predicate;
- boundary-exact vs bulk source functional;
- observer/coarse-graining map;
- source pairing with a diamond holonomy or curvature defect.

First safe theorem targets:

- consolidate the `NullEdgeP9*` draft modules into one reviewed
  `DiamondSourceVisibility` API;
- `bfClosure_implies_no_bulkDivergence`;
- `visiblePluckerMass_nonzero_of_noncollinear`;
- `diamondResidualVariance_scales_with_independentCells`, now using the weighted
  theorem after a diamond screen/cell model is fixed;
- `diamondNoiseSource_core`, separating mean response from noise response and
  proving that mean-zero source bookkeeping need not be gravitationally
  invisible;
- `noiseResponse_weightedSuppression`, tying the existing weighted
  `sum_i amp_i^2` and uniform `A^2 / N` laws to an observer-visible diamond
  noise functional rather than to a bare second moment;
- `relativeEntropyDataProcessing_for_diamondObserver`, as the ANEC/QNEC
  positivity gate;
- `sjDiamondReferenceState_def`, first as a finite matrix reference object;
- `diamondRelativeEntropy_secondDifference_nonnegative`, after the observer
  channel and reference state are fixed;
- `petzRecoverabilityGap_controls_sourceVisibility`, initially as a finite
  definition and Aristotle strategy target.

Information-theoretic sharpening. The Sorkin-Johnston causal-set entropy papers
(`1311.7146`, `8TA2W3MV`; `1611.10281`, `G2JGSV9B`) give P9 a native discrete
reference-state candidate: a finite diamond can use an SJ-style correlation
state as the reference `sigma` in the relative entropy. The caveat is essential:
the SJ entropy literature needs Pauli-Jordan spectral truncation to recover an
area law in the tested causal-set diamonds. Any P9 source-visibility pilot must
state the truncation or explicitly work before the area-law claim.

Recoverability gate. Approximate source invisibility should be measured by a
relative-entropy loss or conditional-mutual-information gap, not only by a zero
source functional. If the Petz or rotated-Petz recovery map cannot approximately
reconstruct hidden bookkeeping from the observer algebra, then the hidden sector
is not really invisible; it has merely been ignored.

Thermodynamic guardrail. The branch must also be reconciled with Jacobson-style
horizon thermodynamics and holographic-screen reasoning, where entropy balance
is supposed to recover Einstein sourcing by the stress tensor. If a source is
declared invisible, the finite model must say whether it is boundary-exact,
recoverable from the screen algebra, or outside the bulk source functional.

Stochastic-gravity guardrail. Hu and Verdaguer's stochastic-gravity reviews
(`PRCWRMFC`, `TXN5JSZ5`), Hu-Matacz's Einstein-Langevin backreaction paper
(`PW8MXJ8I`), Campos-Verdaguer's weakly inhomogeneous cosmology application
(`K8SI5KZ9`), and Phillips-Hu's explicit noise-kernel construction
(`5T5BQ6PT`) are the right comparison points for the P9
mean-zero/second-moment theorems. Semiclassical gravity sources the mean stress
tensor, while stochastic gravity adds a noise-kernel source for stress-tensor
fluctuations. Therefore a finite P9 theorem that proves "mean zero but nonzero
second moment" has not made the source invisible. It has only moved the
question to the diamond response/noise-kernel layer unless the observer channel
or boundary functional kills that fluctuation source too.

Decision threshold. If coherent hidden bookkeeping sources a volume term, if
source invisibility is imposed rather than derived, or if the residual inherits
the everpresent-Lambda amplitude tension without a suppression mechanism,
demote the branch.

Hard publication gate. P9 should not be advertised as cosmological-constant
leverage until all three objects exist in one finite model:

1. an explicit source functional on a finite diamond;
2. an observer/recoverability criterion explaining why a hidden contribution is
   invisible rather than ignored;
3. a quantitative comparison against everpresent-Lambda-style scaling, or a
   derived alternative residual law with stated observational target.

Until then, P9 is a high-value research lane and a falsification-aware program
section, not a paper claiming progress on the cosmological constant problem.

Gravity guardrail. A finite source functional is not yet a theory of gravity.
Before P9 can claim gravitational content, it must also name a response law,
a conservation identity, an equivalence-principle or universality statement,
and a continuum or scaling limit. Entanglement-equilibrium and horizon-
thermodynamic derivations, including Jacobson's (`1505.04753`, Zotero
`7V9FV86B`), obtain Einstein dynamics only with substantial geometric and
field-theoretic assumptions, so P9 should cite them as guardrails rather than
as results already reproduced by the null-edge model.

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

## Recommended sequencing

1. P1 first. It is the most banked, most self-contained, and underpins the rest.
   Promote the celestial-moment wrapper, add the reproducibility appendix, and
   write the artifact paper before reopening broad ontology claims.
2. Combine P2/P4 into the next dynamics paper if the null-step quantum-walk
   target lands: luminal conditional shifts, chirality coherence, Dirac
   dispersion, and observer-visible `m/E` in one finite model.
3. P3 next or in parallel. It is trusted at the core; the decisive follow-up is
   whether the crossed-module/fake-flatness layer is forced or optional
   packaging.
4. P7 as a short, high-signal synthesis note; it captures a genuinely new
   cross-branch observation and is cheap to write.
5. P8 once P1-P4 exist to cite, so the manifesto rests on artifacts.
6. P11 after P2/P4 have a concrete transfer operator and P7 has a usable
   observer-channel API.
7. P5 and P6 opportunistically; P9 and P10 only after their gates clear.

Near-term editorial work order:

1. freeze P1 around the theorem package and frame audit;
2. build the theorem index / reproducibility appendix;
3. rewrite the P1 introduction and novelty statement using the P1 paper
   contract above;
4. add the robustness examples;
5. move ontology, Higgs-mixedness, particle-sector, and P9 material into a
   separate program note or final future-work section.

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
