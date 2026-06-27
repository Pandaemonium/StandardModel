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

This plan now distinguishes stable program topics from manuscript types. The
topic IDs `P1`, `P2`, ..., `P11` remain stable because many task notes, Lean
modules, and source documents already use them. Candidate manuscripts add a
suffix:

```text
-F  formalization paper: established or mostly established math/physics,
    implemented, audited, and packaged in Lean
-E  expository paper: plain-English ontology, pedagogy, and interpretation,
    status-labeled and not sold as a theorem
-R  research paper: a new theorem, model, obstruction, scaling law, or
    prediction that goes beyond formalizing known material
```

Not every topic needs all three manuscript types. Some areas are only
formalization targets; some are only research conjectures; some are best kept
expository until the theorem layer matures.

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

The observer-channel version now needs one more split. A **resolution observer**
traces out internal/chiral labels and produces the unnormalized visible block
`P_vis`; this step is the irreversible coarse-graining and commutes with visible
`SL(2,C)` boosts. A **kinematic observer** then chooses the timelike energy
normalization and produces `rho_{p|u}`; this step is an invertible
filtering/renormalization and is exactly where frame dependence enters. Thus
`det(P_vis)=m^2` is the invariant, while `det(rho_{p|u})=(m/2E_u)^2` is the
frame-relative rate.

Neutrinos are the cleanest stress-test for this split, but should be treated as
motivation rather than a solved result. Weak interactions see neutrinos almost
entirely through a left-handed, nearly null channel. Oscillation data imply that
at least two neutrino masses are nonzero; current direct KATRIN bounds constrain
the effective electron-neutrino mass below the sub-eV scale, while cosmological
mass-sum bounds are tighter but model-dependent. In this program's language, a
massive neutrino is naturally read as an almost pure weak-visible null mode with
tiny hidden chirality/sterile/Majorana bookkeeping. P1 may use this as an
edge-case illustration of observer-channel impurity, but it must not claim to
derive Dirac versus Majorana structure, PMNS mixing, mass ordering, or the
absolute mass scale.

The same guidance also gives the publication series a compact spine:

```text
Plucker geometry
-> resolution observer P_vis
-> kinematic observer rho_{p|u}
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

The 2026-06-27 lateral analysis reframes the publication posture one level up:
the program is best sold as obstruction geometry, not as a claim that every mass
is literally one Plucker-spread formula. The common target is:

```text
zero locus / moduli locus
canonical obstruction section or map
quadratic norm, determinant, Hessian, or inverse-propagator gap
```

This gives the near-term series three clean tracks:

```text
Paper A: Plucker mass as mixedness and celestial variance.
Paper B: Gate C branch obstruction taxonomy and physical-sector alternatives.
Paper C: forbidden finite operators and codimension/absence theorems.
```

Paper A is the safest theorem paper. Paper B is a branch-locus and release
contract paper until C1 is actually released. Paper C is the first plausible
prediction-grade lane because an absence theorem can be structural before any
mass values are derived.

Paper B should include a specific Gate C split:

```text
C0: anti-Hermitian plus positive scalar Wilson gap theorem;
C1: release datum with branch-line projector/classifier, true mirror gap,
    locality or controlled quasi-locality, ghost safety, anomaly accounting,
    and positive physical sector.
```

It should also test a direct-overlap obstruction before using overlap language
as a release mechanism. If an unwanted zero branch germ reaches the origin and
crosses the shifted Wilson mass shell, the unprojected overlap sign kernel is
singular. Therefore raw overlap on the full bare `D_+` should be presented as a
conditional route, not as the default C1 solution.

The 2026-06-23 conjecture review updates the priority map. The next highest
value target is not another static invariant, but a bridge between
observer-channel mass and null-step dynamics:

```text
chirality / flip dynamics
-> visible entropy or coherence rate
-> observer-conditioned proper-time ratio
-> invariant Plucker determinant after integration and normalization.
```

Relative entropy and recoverability should be treated as the shared
observer-channel infrastructure for this bridge, for P9 source visibility, and
for later stable-particle-sector work. P9 remains high-value, but its near-term
publication form is finite source visibility, noise kernels, and coarse-map
guardrails; cosmological-constant leverage is gated by a comparison with the
everpresent-Lambda `1 / sqrt(V)` amplitude and correlation structure. The
super-Dirac synthesis should wait on a one-diamond `D^2` computation showing
that its curvature block is the existing causal-diamond holonomy defect.
Generation/triality papers should wait until walk/Kahler-Dirac doublers,
chirality doubling, and internal-family multiplicities are separated.

The 2026-06-25 Aristotle wave-3 integration updates the Lean-status guard for
this publication plan. The named G1 null-strand capstones now exist and build as
first candidates: `finiteIIDNullStrand_master` and
`checkerboardBohmBell_master`. Papers may cite them as candidate assembled finite
models after quoting their exact hypotheses, but should not yet present G1 as
fully publication-closed until semantic alignment, assumption-whitelist review,
and manifest regeneration are complete.

The 2026-06-25 wave-4 semantic audit strengthens that guard. The i.i.d. capstone
now carries explicit null-step, barycenter, process-nullity, and octahedral
witness lemmas; the checkerboard capstone now names its finite-model caveat
instead of overselling it. The publication-safe phrasing is therefore:
"G1 has concrete, compiling Lean capstone candidates with semantic audit notes;
publication closure awaits generated assumption and manifest reports."

## How to read this plan

Each candidate manuscript has a type suffix and a readiness label. The suffix
says what sort of contribution the paper is trying to make; the readiness label
says how close the central claim is to being defensible.

```text
Banked       core result is trusted Lean (compiles, no proof holes)
Near         core is kernel-clean draft Lean (no proof holes) needing promotion + writeup
Synthesis    conceptual paper with partial banked algebra; needs framing, not new kernels
Aspirational gated on an unproven theorem; listed as a target, not a ready paper
```

Trusted vs draft is tracked exactly because it changes what can be claimed. A
draft module that is kernel-clean (no proof holes) is strong evidence but has not
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

Every conjectural manuscript should also split its claims into four layers:

```text
exact finite identity       -- theorem-level algebra or combinatorics
existence/naturality claim  -- whether the object is canonical
scaling/dynamical theorem   -- whether it survives evolution or limits
physical interpretation     -- what the finite result means physically
```

Do not let success in one layer silently promote the others. A paper may be
publishable if it cleanly proves the finite identity and honestly states the
remaining naturality, scaling, and interpretation gates.

## Overview

| ID | Type | Working title | Readiness | Lead venue |
| --- | --- | --- | --- | --- |
| P1-F | Formalization | Mass as Plucker spread of null spinors | Banked | Formalized-math / math-phys |
| P1-E | Expository | The origin of mass from unresolved null motion | Active draft | Broad math-physics / public-facing preprint |
| P1-R | Research | A dynamics theorem deriving Plucker mass from null-step evolution | Aspirational | Math-phys / quantum foundations |
| P2-F | Formalization | A finite Dirac square root of the Plucker mass | Near | Formalized-math / math-phys |
| P2-R | Research | One causal super-Dirac operator with Plucker, Higgs, and diamond blocks | Aspirational | Math-phys / noncommutative geometry |
| P3-F | Formalization | Causal-diamond holonomy: finite gauge curvature without plaquettes | Banked | ITP / discrete gravity |
| P3-R | Research | Higher-gauge diamond curvature and fake-flatness from causal path pairs | Near/Aspirational | Higher gauge / discrete gravity |
| P4-F | Formalization | Luminal checkerboard dynamics, formalized | Banked | ITP / math-phys |
| P4-R | Research | Null-step Dirac universality and chirality-coherence dynamics | Aspirational | Math-phys / quantum walks |
| P5-F | Formalization | Finite quantum measure on causal events | Near | Foundations / quantum info |
| P6-R | Research | Flavor as an internal Gram-overlap problem | Synthesis | Physics (flavor), framed as structural |
| P7-F | Formalization | Finite observer-channel and relative-entropy infrastructure | Near | Formalized QI / foundations |
| P7-R | Research | Proper-time, coherence, and recoverability in observer channels | Synthesis | Foundations / QI + gravity |
| P8-E | Expository | The null-edge causal graph program | Synthesis | Foundations / quantum gravity |
| P9-F | Formalization | Finite source visibility, noise kernels, and coarse-map guardrails | Near | Formalized math / discrete gravity |
| P9-R | Research | Cosmological-constant source response from diamond closure | Aspirational | Quantum gravity |
| P10-R | Research | Generations from the exceptional Jordan / triality layer | Aspirational | Math-phys / particle |
| P11-R | Research | Stable particle sectors of finite causal quantum channels | Aspirational | Foundations / quantum information |
| P12-F | Formalization | Exterior-history finite grade-2 mass capacity | Near | Formalized-math / quantum foundations |

## Part I: formalization papers (banked or near-banked)

These are the safest publications because the central object is already in the
kernel. They are best framed as formalized-mathematics artifacts: state the
informal physics claim, then exhibit the exact Lean theorem and its conventions.

### P1-F. Mass as Plucker spread of null spinors

Core claim. For a finite bundle of visible null spinors, the invariant mass
squared is the total pairwise Plucker spread of their null directions:

```text
det(sum_i psi_i psi_i^dagger) = sum_{i<j} |psi_i wedge psi_j|^2,
```

with mass zero exactly when the bundle is projectively collinear. A celestial
rewrite expresses the same unnormalized scalar as a monopole/dipole deficit on
`CP^1`. If the fine state also carries internal labels, the resolution observer
first traces those labels and produces an unnormalized visible block

```text
P_vis = V G V^dagger,
det(P_vis) = w^dagger (Lambda^2 G) w.
```

This is the coarse-graining step, not a frame choice. Under a visible boost
`A in SL(2,C)`, it transforms by congruence and preserves the determinant:

```text
P_vis |-> A P_vis A^dagger,
det(A P_vis A^dagger) = det(P_vis).
```

The observer-facing normalized state is obtained only after fixing a unit
timelike observer `u`:

```text
rho_{p|u} = U^{-1/2} P_vis U^{-1/2} / Tr(U^{-1} P_vis),
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
proof holes). `SL(2,C)` covariance of the determinant mass in
`PhysicsSM.Draft.NullEdgeSpinorGeometryTargets`
(`finBundleMomentum_det_sl2_invariant`, kernel-clean). The draft
`PhysicsSM.Draft.NullEdgeObserverChannelCore` now packages the sharpened
observer-channel layer: unnormalized boost congruence, determinant invariance,
scalar normalization/filtering, the two-label Gram factorization, dephasing
monotonicity, and the unital-versus-entangling monotonicity boundary.
`PhysicsSM.Draft.NullEdgeSchmidtDeterminantCore` adds the finite pure-state
Schmidt determinant bridge equating visible and chirality reduced determinants.

Remaining. Promote the celestial-moment wrapper (Bloch monopole/dipole form),
add the unnormalized boost-congruence theorem, add the frame-conditioned
normalization/filtering theorem, add the observer-relative two-null
decomposition lemma, and promote the Gram-weighted generalization (see P6) into
the trusted surface, or scope the paper to the orthonormal case and cite the
rest as extensions.

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
(`1212.5605`) for the `Gr(2,n)` minor-stratification angle. For the neutrino
stress-test, cite KATRIN's direct sub-eV bound and Planck-style cosmological
mass-sum constraints only as current experimental guardrails, not as theorem
inputs.

Claim boundary. This is a finite linear-algebra identity and its geometric
equality condition. It is not a continuum Dirac limit and does not by itself
fix a mass spectrum. The invariant is `det(P)=m^2`; normalized mixedness is a
frame-relative `m/E` statement after choosing an observer time convention.
Neutrinos are an instructive nearly-null example, but P1 does not solve the
neutrino mass mechanism, flavor mixing, or absolute mass scale.

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
  observer-conditioned `rho_{p|u}` changes by filtering/renormalization with
  the observer;
- alternate trace/energy normalizations and the conversion factor;
- nonorthogonal hidden-label example via the Gram-weighted theorem, including
  the two-label product `det(P_vis)=|v_1 wedge v_2|^2 det(G)`;
- simple qubit observer-channel example;
- at least one small causal-diamond picture only as future-facing context, not
  as part of the P1 proof burden.

### P2-F. A finite Dirac square root of the Plucker mass

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

The newest super-Dirac critique sharpens this: the missing theorem is not
another abstract block expansion. It is the symbol/soldering theorem proving
that the causal order-complex operator has first-order symbol equal to the
Dirac slash of the weighted null-edge momentum bundle. In finite target form:

```text
[D, M_f] near x
-> sum_y a_xy (f(y)-f(x)) gamma.p_xy
-> Plucker mass after squaring.
```

Without this, the static `gamma.P` theorem and the order-complex `d+delta`
theorem remain adjacent square roots rather than one operator.

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

The grading also needs to be fixed before the broad operator story is promoted.
There are two distinct `Z2` gradings: cochain/form degree on the order complex
and left/right chirality on the internal finite space. The product operator
should be written as

```text
D_total = D_U + Gamma_K M_Phi,
Gamma_total = Gamma_K Gamma_F,
```

so that the external piece is odd in form degree, the Higgs/Yukawa block is odd
in chirality but degree-zero on the complex, and the cross term is the gauged
Higgs derivative rather than an arbitrary degree-mixing artifact.

Lead venue. Formalized-math or math-physics. The operator-factorization story is
the program's most distinctive math contribution after P1.

Literature anchors. Quillen superconnections; Chamseddine-Connes spectral
action; Ackermann-Tolksdorf generalized Lichnerowicz; Bianconi topological Dirac;
Marcolli-van Suijlekom gauge networks (arXiv:1301.3480) as the closest graph /
finite-spectral-triple prior art; and Perez-Sanchez's comment on gauge networks
(arXiv:2508.17338) as a warning that a naive lattice spectral action may lose
the Higgs scalar in the continuum limit. Foldy-Wouthuysen / Newton-Wigner /
Thaller remain branch-interpretation guardrails.
For the Lorentzian/Krein audit, cite van den Dungen (`5DURW8DU`),
Bizi-Brouder-Besnard (`PM83B8QI`), Besnard-Bizi (`5VWPZ8BP`),
Devastato-Farnsworth-Lizzi-Martinetti (`5RJUDATF`), and Martinetti-Singh
(`Q6R3PCGJ`), with Strohmaier (`math-ph/0110001`), Franco (`arXiv:1210.6575`),
and Besnard/Bizi (`arXiv:1611.07830`, `1611.07842`) as additional Lorentzian
spectral-spacetime guardrails.

Claim boundary. The square-root identities are finite algebra. The
particle/antiparticle and localization reading of the two sheets must stay
conditional on the standard Dirac branch literature.

#### 2026-06-25 super-Dirac refinement (concrete gate)

A new concrete proposal is the **null-diamond super-Dirac operator**:

```text
D_N = Σ_i c(ℓ_i) (T_i - P_i),   D = i D_N + Γ_5 Φ
```

`c(ℓ_i)` is the null Clifford symbol for direction `i`, `T_i` is the pullback
shift, `P_i` is the existence projector, and `Φ` is the odd self-adjoint Yukawa
operator on the internal finite space.

This proposal enforces the key refinement: **Plücker mass is the square of the
kinetic symbol, not an extra zero-order addend in `D_N^2`.** `Φ^2` is the only
mass block. The finite square should split as

```text
D^2 = -□_null - 𝒞_diamond - 𝒯_frame + Φ^2
      - i Γ_5 Σ_i c(ℓ_i)[∇_i, Φ]
```

where `□_null` is the null-direction second-order propagation, `𝒞_diamond` is the
causal-diamond holonomy curvature term, and `𝒯_frame` is the frame-variation term
that vanishes under a finite tetrad postulate.

In a flat, frame-covariantly constant regime, the shell condition is:

```text
-□_null + Φ^2 = 0  on shell
```

equivalently, on a local mode with symbol momentum `P(ξ)` and a `Φ`-eigenvector
`Φ^2 ψ = m^2 ψ`:

```text
P(ξ)^2 = m^2.
```

This is exactly the non-double-counting message.

Notation guardrail. The Krein/spectral-triple layer should reserve `eta` for
the linear fundamental symmetry defining the Krein product, `JReal` or `C` for
the antilinear real structure, and `Sigma_m = D / m` for the mass-shell sheet
involution. The existing two-sheet projector theorem concerns `Sigma_m`, not
the real structure or the fundamental symmetry.

Finite spectral-action target. On a finite complex, the low-order spectral
action is finite linear algebra rather than asymptotic heat-kernel analysis.
The first useful target is:

```text
Tr(D_total^2) = graph kinetic trace + Yukawa trace + diamond-curvature trace
```

This should be attempted before any continuum spectral-action claim.

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

### P3-F. Causal-diamond holonomy: finite gauge curvature without plaquettes

Core claim. Gauge curvature on a causal graph can be measured by holonomy
defects across causal diamonds, with finite, kernel-checked invariance and
composition laws, replacing the lattice plaquette.

Banked Lean. `PhysicsSM.Gauge.CausalDiamondHolonomy` (trusted): Abelian gauge
invariance, non-Abelian endpoint covariance, gauge invariance of class functions
of the defect, and vertical and horizontal composition laws for path-pair
defects. `PhysicsSM.Draft.NullEdgeP3CrossedModule` (draft, kernel-checked)
adds the first higher-gauge wrapper: fake-flatness is preserved by vertical and
horizontal 2-cell composition, and the crossed-module 2-cell labels satisfy the
double-category interchange law.

Remaining. The decisive structural test is no longer "does interchange hold?"
at the abstract 2-cell level; that is now banked. The next step is semantic and
geometric: identify which finite `H`-valued 2-cell labels, endpoint actions,
surface-transport rules, and fake-flatness constraints are actually forced by
the trusted path-pair API and by physically meaningful causal diamonds. This is
finite higher-gauge algebra, not a continuum Stokes theorem.

Lead venue. An interactive-theorem-proving venue or a discrete-gravity /
classical-and-quantum-gravity venue.

Literature anchors. Sverdlov causal-set gauge fields; Baez-Schreiber higher
gauge theory; Wilson lattice gauge theory as the contrast object.

Claim boundary. These are finite gauge-invariant defects and their composition
algebra, not a continuum Stokes theorem.

### P4-F. Luminal checkerboard dynamics, formalized

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

Sharpened P4 split. The publishable near-term claim should be the homogeneous
fixed-point theorem, not the full causal-set frontier. In the homogeneous
quantum-walk setting, the finite target is:

```text
null-step unitary symbol
-> L plus R doubling forced by no 2 x 2 mass term
-> scalar off-diagonal flip is the Dirac mass
-> small-momentum Dirac dispersion
-> unnormalized visible determinant det(P_vis) = m^2
-> normalized det(P_vis / Tr(P_vis)) gives the frame-relative m/E readout
```

The hard frontier is separate: a Lorentz-invariant spinor hop-stop propagator on
a Poisson-sprinkled causal set, extending Johnston's scalar propagator. That is
where the ontology would become genuinely new dynamics, but it should not be
folded into the banked P4 paper until the homogeneous fixed-point package and
single-cone/doubler accounting are under control.

New finite anchors. Two of the fixed-point package guardrails are now
kernel-checked draft modules. `PhysicsSM.Draft.NullEdgeP4PauliNo2x2Mass`
proves that a single `2 x 2` Weyl space cannot contain an invertible matrix
anticommuting with all Pauli matrices; the mass term therefore requires the
doubled `L plus R` Dirac space. `PhysicsSM.Draft.NullEdgeP4VisibleDetInvariant`
proves that determinant-one visible congruence preserves the unnormalized
visible determinant and records the trace-normalized determinant formulas that
turn it into the observer-conditioned readout.
`PhysicsSM.Draft.NullEdgeP4ScalarFlipIsotropy` proves that Pauli isotropy forces the flip
generator to be scalar, making vector flip components anisotropic couplings
rather than mass.

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
dynamics (`BVJBTK8J`, `KCQGEDJE`). Farrelly's QCA review (`964TN6X7`)
is now the broad prior-art guardrail, and Eon-Di Molfetta-Magnifico-Arrighi's
3+1 discrete QED construction (`VIAIBSRI`) is especially relevant because it
uses lightlike circuit wires, starts from a Dirac quantum walk, and extends it
to gauge-invariant multi-particle dynamics.

Claim boundary. A finite path-sum / recurrence result in `1+1`, plus a
homogeneous null-step quantum-walk fixed-point package if the new targets land.
It is not yet a proof of generic higher-dimensional Dirac universality or a
causal-set spinor propagator. It also is not yet the G1
`checkerboardBohmBell_master`: that capstone still requires a trajectory measure
and concrete assembly of null steps with Born equivariance from the banked
checkerboard lemmas.

### P5-F. Finite quantum measure on causal events

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

## Part II: expository and physics-facing papers

These papers carry partial banked algebra inside a conceptual frame, or explain
the ontology in plain English. They are higher-risk than Part I and must be
written so the finite content is separable from the interpretation. Expository
papers are allowed to be vivid and pedagogical, but they must status-label the
theorems, conjectures, analogies, and ontology.

### P1-E. The origin of mass from unresolved null motion

Core claim. The expository P1 paper explains the intuitive null-edge picture:
each microscopic visible step is lightlike and individually massless, while a
stable coarse-grained particle can be timelike because the observer sees a
bundle of lightlike directions rather than one perfectly collinear ray. The
Higgs/Yukawa story is presented carefully: Higgs coupling permits and weights
left/right chirality coherence; visible mixedness appears only after a named
observer channel, detector restriction, dephasing, or partial trace.

Audience. This is the right home for the high-school-accessible opening,
electron/neutrino examples, the gyroscope analogy with caveats, and the broader
interaction ontology.

Claim boundary. This paper teaches the worldview. It should cite P1-F for the
actual theorem and should not claim that the ontology is proved.

### P6-R. Flavor as an internal Gram-overlap problem

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

### P7-F/P7-R. Observer channels and relative-entropy monotonicity

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
`d tau / dt = 2 sqrt(det rho_vis)` monotonicity claim to named channel classes
and to a fixed observer-time convention, which is the same data-processing
principle plus the frame audit. The safest positive class is a unital CPTP
channel on the normalized visible celestial qubit: it fixes the rest state
`I/2`, contracts the Bloch vector, and makes `m/E` non-decreasing. Entangling
hidden dynamics are not channels on `rho_vis` alone and should be treated as
the named counterexample class, not hidden under a broad LOCC slogan. The paper
argues that the allowed-dynamics question in both branches has one answer and
one guardrail.

Updated priority. P7 should no longer be treated as merely a short analogy note.
It is the common infrastructure for several publication targets:

```text
P1/P2: coherent vs dephased internal labels and visible determinant mass
P4: proper-time/purity rate along a null-step chirality-flip walk
P9: source visibility versus recoverability under diamond observer channels
P11: stable sectors as information preserved by finite transfer channels
```

The strongest new finite target is a relative-entropy or recoverability
deficit that distinguishes coherent from dephased internal labels without being
determined by `m` alone. This is the operational content missing from a bare
Gram factorization: if every coherence-distinguishing functional is only a
function of `det(P_vis)`, the observer-channel mass story should be demoted to
an invariant reformulation.

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

- `visibleReduced_boost_eq_congruence`;
- `det_visibleReduced_boost_invariant`;
- `normalizedVisible_boost_is_filtering`;
- `normalizedVisible_det_eq_massRatio_sq`;
- `det_visibleReduced_eq_gramWeighted_plucker`;
- `det_visibleReduced_twoLabel_eq_wedge_times_detGram` (banked in
  `NullEdgeObserverChannelCore`);
- `dephasing_internalGram_mass_monotone` (banked in
  `NullEdgeObserverChannelCore`);
- `restFrame_iff_normalizedMomentum_maximallyMixed`;
- `massRatio_eq_sqrt_one_minus_blochNormSq`;
- `relativeEntropy_partialTrace_monotone`, or a focused finite data-processing
  lemma if the mathlib API supports it;
- `unital_visibleChannel_massRatioSq_monotone` (banked in
  `NullEdgeObserverChannelCore`);
- `entangling_hiddenChannel_massRatioSq_can_decrease` (banked toy
  counterexample in `NullEdgeObserverChannelCore`);
- `petzRecoverable_iff_relativeEntropyLoss_zero`, if a small finite matrix
  statement can be isolated;
- `recoverabilityGap_bounds_sourceVisibilityDefect`, initially as a definition
  and conjectural inequality.
- `internalCoherenceLoss_eq_relativeEntropyDeficit`;
- `coherenceDeficit_not_determined_by_mass_alone` (finite same-det,
  different-coherence density-class guardrail banked in
  `NullEdgeP7CoherenceNotDeterminedByDet`);
- `sameDet_different_operationalReadout` (banked in the same module via an
  explicit off-diagonal trace-pairing observable);
- `sameDet_different_positiveEffectReadout` (banked via an X-basis-style
  bounded positive-effect proxy in the finite real-symmetric model);
- `sameDet_different_twoOutcomeReadout` (banked with the positive effect and
  its complement summing to the trace-one total);
- `properTimeRatioSq_eq_two_linearEntropy` (banked in
  `NullEdgeP7ProperTimePurityBridge`, making the normalized static bridge
  explicit);
- `blochContraction_properTimeRatioSq_monotone` and strict variant (banked in
  the same module, giving the unital-channel monotonicity form);
- `partialDephasing_massRatioSq_gap`,
  `iteratedPartialDephasing_massRatioSq_gap`, and related determinant/purity
  gap identities (banked in `NullEdgeP2PartialDephasingRateBridge`, giving
  one-step and `n`-step dephasing-channel laws for the loss of off-diagonal
  coherence);
- `linearEntropyRate_visible_eq_flipFrequency`, shared with the null-step
  dynamics paper.

Remaining. A precise statement of the resolution observer, the kinematic
observer, the explicit unital visible-channel construction, and a finite
observer-channel API shared by P7 and P9. Ruskai-Szarek-Werner
(`quant-ph/0101003`, DOI `10.1016/s0024-3795(01)00547-x`, Zotero `M6HR9WD6`)
gives the affine Bloch-ball form and is the practical route for the celestial
qubit before we attempt a general CPTP formalization.

The newest audit boundary is important: the proper-time/purity bridge is no
longer only a static scalar rewrite, because the partial-dephasing module now
records exact finite one-step and `n`-step channel increments. It is still not a
continuum rate law or a Higgs/Yukawa dynamics theorem. The next
publication-grade strengthening is to connect the finite iterated formula to a
named null-step transfer channel.

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

### P8-E. The null-edge causal graph program

Core claim. A single theorem-first statement of the program: fundamental
histories are amplitudes over causal incidence structures; visible edges carry
null spinor/twistor data; mass is Plucker spread; gauge curvature is diamond
holonomy; the internal transition algebra (octonionic / Jordan) is separate from
visible spacetime. Includes the program's own corrections: drop the octonionic
equality-gap selection principle, treat finite valency as effective, and accept
generation-blindness of the visible geometry.

Banked Lean. This paper cites the whole trusted spine (P1, P3, P4) and the
kernel-clean clusters (P2, P5, P6) as evidence that the program is a finite
theorem spine, not a slogan. It may cite the G1 master theorem pair as candidate
assembled finite artifacts now that `finiteIIDNullStrand_master` and
`checkerboardBohmBell_master` exist as concrete Lean declarations with wave-4
semantic audit notes, while still marking generated assumption and manifest
reports as pending.

Remaining. Mostly writing and honest scoping. The value is the falsification-aware
priority map and the two-layer architecture, not a new kernel.

Lead venue. A foundations or quantum-gravity venue, or a long, well-sourced
preprint that anchors the program and cites the formalization papers.

Claim boundary. The manifesto must not claim a replacement for quantum field
theory or general relativity. Its defensible novelty is the finite, Lean-verified
package plus the graph-native synthesis.

### P11-R. Stable particle sectors of finite causal quantum channels

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

## Part III: research targets (not yet papers)

These are listed so the program tracks them, but each is gated on a theorem that
is not yet proved. They become `-R` manuscripts only when the gate clears. Their
supporting finite theorem packages may still become `-F` papers first.

### P9-F/P9-R. Source visibility, noise, and cosmological response

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
`PhysicsSM.Draft.NullEdgeP9UniformSuppression` prove several pieces that make
the branch sharper:

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

A second P9 batch adds the first abstract Hodge/projector and noise-kernel
guardrails:

- `PhysicsSM.Draft.NullEdgeP9ClosedWitness` proves that a closed bulk test with
  nonzero source pairing certifies visible source content and rules out
  boundary-exact bookkeeping;
- `PhysicsSM.Draft.NullEdgeP9BoundaryVisibleDecomp` proves that closed tests
  see the residual/visible component and ignore boundary-exact perturbations;
- `PhysicsSM.Draft.NullEdgeP9WeightedNoiseBound` bounds weighted diagonal noise
  response by the observer-test bound times the weighted amplitude square;
- `PhysicsSM.Draft.NullEdgeP9HarmonicProjectorResponse` proves that harmonic
  tests see only the projected source when the finite projector is self-adjoint
  and annihilates boundary sources;
- `PhysicsSM.Draft.NullEdgeP9ProjectedNoiseKernel` proves that projecting a
  noise kernel preserves positive-semidefinite response.

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

New physics guardrail. A different residual-amplitude law can cut two ways. If
P9 pushes local vacuum residuals from a volume law to a screen law, then in four
spacetime dimensions the residual may scale like `sqrt(A) / V ~ L^(-3)` for a
codimension-two screen, or like `L^(-5/2)` for a null-hypersurface support. That
is strong local vacuum filtering, but probably too suppressed to be the observed
dark-energy scale by itself. The P9 paper should therefore separate two claims:

```text
local UV vacuum filtering: exact/projected/screen-supported source noise is small
observed Lambda-scale residual: surviving global/harmonic/unimodular mode
```

The first is a finite source-visibility result. The second requires an explicit
harmonic/global quotient and a quantitative comparison with the
everpresent-Lambda `L^(-2)` scale.

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
- `hodgeProjector_annihilates_boundaryExact`, upgrading the current abstract
  projector algebra to an explicit finite Gram-matrix projector rather than an
  appeal to Hodge theory;
- `harmonicNoiseKernel_positiveDefinite_iff_no_hidden_null_modes`, separating
  true harmonic-source visibility from generic positive-semidefinite noise;
- `harmonicNoiseKernel_conditionNumber_refinement_bound`, not as a demand for
  fine-grained continuum behavior, but as a diagnostic of whether a stable
  coarse-grained or renormalized harmonic channel survives refinement.

Adversarial finite gate. The current boundary and noise lemmas are necessary
plumbing, but they are not yet cosmological-constant leverage. The next P9
result must use some causal-diamond-specific input: a chosen SJ/correlation
metric, an explicit harmonic projector, Betti-number or harmonic-dimension
scaling, a noise spectrum/condition-number bound, or a response law. If the
same theorem remains unchanged on an arbitrary finite complex with no causal
data, treat it as support infrastructure rather than a physics result.

Numerical pilots:

- compute the finite Hodge projector on small sprinkled or hand-built causal
  diamonds and report harmonic dimension and noise-kernel spectrum;
- prioritize the coarse-grained noise-kernel variance
  `Var(k) = tr(R K R^T)` as the first publishable P9 pilot, with the
  coarse-graining map `R` fixed before seeing the statistic and reused for flat
  and de Sitter-like diamonds;
- compare flat and de Sitter-like finite diamonds to test whether the harmonic
  residual channel distinguishes geometry beyond triangulation noise;
- add a boundary-exact perturbation regression test that verifies closed-test
  responses are unchanged at floating-point tolerance;
- construct an explicit visible Plucker/closure-defect source and verify the
  selected source observable drops to zero when the defect is removed.

Geometry-discriminating pilot gate. The flat-vs-de Sitter comparison should not
count as evidence merely because two hand-tuned metric choices give different
numbers. A publishable pilot needs a named metric statistic, such as harmonic
dimension, the smallest positive eigenvalue of the projected noise kernel, the
projected condition number, or a normalized projected trace, and that statistic
should differ between the flat and de Sitter-like diamond by more than the
sprinkling spread. A useful working threshold is: the flat/de Sitter separation
should exceed ten times the within-family spread and should vary monotonically
as the de Sitter scale or expansion parameter is changed. The same statistic
must survive boundary-exact perturbations and either refinement checks or an
explicit coarse-graining/renormalization prescription. Fine-scale
ill-conditioning is not by itself a failure in a fundamentally discrete model;
it is a failure only if no stable large-scale readout remains.

Ordering. Build the coarse-grained noise-kernel variance route first: positive
kernels, Cauchy-Schwarz bounds, and projected-response modules already provide
most of the finite well-definedness layer. Treat Green-function
source-response susceptibility as the stronger follow-up, because it requires a
stable inverse or regulated Green operator on the visible/projected subspace.
New formal support: `PhysicsSM.Draft.NullEdgeP9CoarseResidualVariance` proves
the block-sum variance identity, `NullEdgeP9CoarseKernelPSD` proves that a
fixed coarse map sends PSD kernels to PSD coarse kernels and gives a
nonnegative coarse trace, `NullEdgeP9RankOneHarmonicTrace` proves the
rank-one harmonic trace-density toy theorem,
`NullEdgeP9WeightedAdjointCore` fixes the weighted codifferential convention,
`NullEdgeP9WeightedLaplacianEnergy` proves the weighted sum-of-squares energy
identity and nonnegativity, and `NullEdgeP9HarmonicKernelCore` proves the
weighted finite Hodge kernel identity `harmonic iff closed and coclosed`.
`NullEdgeP9WeightedLap1SelfAdjoint` adds the missing bilinear operator fact:
the explicit weighted 1-Laplacian is self-adjoint for the weighted degree-1
pairing, which is the finite algebra needed before using spectral subspaces as
coarse observer channels.
`NullEdgeP9HodgeProjectorInstantiation` then proves the finite
source-visibility bridge: a self-adjoint idempotent projector into that
harmonic sector annihilates exact boundary bookkeeping and preserves projected
responses/pairings under exact boundary perturbations.
`NullEdgeP9WeightedProjectorResidualOrthogonal` adds the weighted
observer-channel decomposition law: projected tests see only the projected
source, and the residual source is weighted-orthogonal to every projected test.
`NullEdgeP9WeightedProjectorPythagorean` adds the matching energy split:
weighted source energy is exactly projected/coarse energy plus residual energy.
`NullEdgeP9CoarseBoundaryInvariance` adds the boundary-artifact guardrail for a
fixed coarse-graining map, and `NullEdgeP9TwoCellTraceSeparation` adds a
minimal non-vacuity check showing that a two-cell coarse trace can detect
movement in diagonal kernel weights. `NullEdgeP9CausalSupportBound` adds the
first causal-support guardrail: a finite response kernel supported inside a
chosen causal relation cannot propagate a localized source outside its discrete
causal reach, and causally separated source/target tests have zero response.
`NullEdgeP9RetardedNilpotentReach` adds the finite acyclic-retarded horizon:
when the response support relation strictly decreases a rank on a finite
diamond, exact reach is empty beyond the rank height and the iterated response
kernel vanishes. `NullEdgeP9EdgeNeighborReach` adds the effective-locality
wrapper: `edgeNeighbor_N` is a subrelation stable under induced subdiamonds,
neighborhood-supported kernels are causally supported, and step-supported
kernels keep responses inside exact finite step reach.
`NullEdgeP9RetardedGreenSeries` adds the finite response-law scaffold: under
nilpotence on a vector, the terminating retarded series
`sum_{m < H} K^m x` solves `(I - K) y = x` exactly. This is the clean finite
substitute for a formal Green function in the current P9 toy layer.
This prevents the P9 response layer from being purely arbitrary matrix algebra,
but it still must be paired with a source functional and response law before it
counts as cosmological-constant leverage.

New numerical guardrail: `Scripts/p9/pilot_ensemble.py` now runs a matched
flat-diamond versus deformed/de-Sitter-style diamond ensemble over several
sizes and seeds, reporting projected-noise trace density, coarse block trace
density, seed spread, and a `10 * within-family spread` separation threshold.
The first aggregate output
`AgentTasks/p9-pilot-matched-diamond-ensemble-2026-06-23.json` is useful mainly
because it is discriminating. Boundary perturbation and projected-PSD checks
passed, but the main fine projected-noise trace-density signal failed the
`10x` spread threshold for sizes `4..8`; the block-size `4` coarse statistic
passed but is plausibly a coarse-map alignment artifact. This should be treated
as a guardrail and target generator, not as evidence for cosmological-constant
leverage.
The offset sweep
`AgentTasks/p9-pilot-matched-diamond-offset-sweep-2026-06-23.json` confirms the
artifact concern. Shifting the block-size `4` coarse grid away from offset `0`
makes the flat trace density nonzero, and offset `2` makes the flat/deformed
separation fail. The next numerical milestone is therefore not "larger
block-size `4` evidence"; it is an offset-invariant or geometry-intrinsic
coarse map, preferably defined by causal intervals or another pre-specified
diamond construction.

P9 demotion tests are now explicit. Demote the cosmological-constant claim if:

- all harmonic/projected statistics are geometry-blind between flat and
  de Sitter-like diamonds;
- the apparent separation vanishes or fails to stabilize under refinement after
  any stated coarse-graining or renormalization step;
- the discriminating statistic changes under boundary-exact perturbations or
  admissible regraduations of the diamond;
- the effect disappears once the metric blocks are constrained to come from the
  chosen geometry rather than arbitrary weights;
- the statistic has no response law linking it to vacuum energy, curvature,
  expansion, or a unimodular conjugate variable.

Positive finite scaffold: `PhysicsSM.Draft.NullEdgeP9SelectedSectorTraceDensity`
now proves that a Boolean-selected sector with `k` visible coordinate modes in
an `n`-cell readout has trace density `k/n`, and that a boundary-size bound on
`k` gives a boundary-over-volume density bound. This is only algebra until the
selected sector is geometrically forced, but it is the exact finite statement
the P9 area-vs-volume route needs.
Negative/guardrail scaffold:
`PhysicsSM.Draft.NullEdgeP9BlockAliasingGuardrail` proves that a size-4 block
average annihilates any rank-one mode with zero within-block sum. This is the
formal version of the offset-sweep warning: a zero coarse trace can be an
alignment artifact unless the coarse map is intrinsic or the statistic is
offset-invariant.
`PhysicsSM.Draft.NullEdgeP9OffsetWindowGuardrail` strengthens this warning:
one block-window zero need not survive a shift, and all shifted four-cell
window traces can still annihilate a nonzero high-frequency mode. Thus
offset-sweeping is a necessary negative control, not a sufficient proof of
source invisibility.
`PhysicsSM.Draft.NullEdgeP9BoundaryVolumeScaling` supplies the finite
area-vs-volume arithmetic behind the selected-sector route: in the toy
four-dimensional scaling model, boundary-over-volume density is `C / L`, drops
below a chosen threshold after a scale bound, and halves when the linear scale
doubles.
`PhysicsSM.Draft.NullEdgeP9DefectSensitivityBenchmark` supplies the first
minimal defect-sensitivity benchmark: common-mode two-triangle curvature
bookkeeping is invisible to the linearized diamond-defect readout, while
differential curvature perturbations are visible and create nonzero defect from
a flat baseline.

First scaffold: `Scripts/p9/pilot.py` now implements the hand-built part of
this pilot for `cycle4`, `filled_triangle`, and `two_triangle_disk`, with output
schema `Scripts/p9/p9_schema.json`. Initial smoke runs correctly separate a
one-cycle harmonic sector from filled-disk examples with no harmonic sector.
The pilot now also has a toy metric-profile hook: on the same `cycle4`
combinatorics, a flat edge metric gives projected harmonic-noise trace `1.0`,
while a normalized expanded edge-weight profile gives trace about `1.113` and a
different Laplacian spectrum, with boundary perturbations still invisible and
the projected covariance kept positive by using the covariance convention
`P K P^T`. This is only a metric-sensitivity diagnostic; the
publication-relevant test still requires a causal-diamond family with recorded
metric conventions. A parameterized cycle-size hook now gives a preliminary size
sweep: for normalized expanded cycles of size `4, 6, 8`, the harmonic dimension
stays `1`, projected covariance remains positive, and projected trace is roughly
`1.03-1.04`. That is a useful harness sanity check, not a causal-diamond result.

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
(`PW8MXJ8I`), the Martin-Verdaguer Einstein-Langevin derivation
(`4KXZ8IJE`), Campos-Verdaguer's weakly inhomogeneous cosmology application
(`K8SI5KZ9`), and Phillips-Hu's explicit noise-kernel construction
(`5T5BQ6PT`) are the right comparison points for the P9
mean-zero/second-moment theorems. Semiclassical gravity sources the mean stress
tensor, while stochastic gravity adds a noise-kernel source for stress-tensor
fluctuations. Therefore a finite P9 theorem that proves "mean zero but nonzero
second moment" has not made the source invisible. It has only moved the
question to the diamond response/noise-kernel layer unless the observer channel
or boundary functional kills that fluctuation source too.

Hodge/conservation sharpening. The best current route is to define P9
bookkeeping as a finite cochain on a diamond order complex, with the inner
product supplied by the chosen Sorkin-Johnston correlation metric. Once that
metric is fixed, the source-visibility problem should be split by a finite
Hodge-Helmholtz decomposition:

```text
im d                   boundary/gauge bookkeeping
closure or codifferential defect  visible matter source
ker d cap ker delta    candidate harmonic Lambda-channel
harmonic covariance    stochastic noise kernel
```

This is useful because it makes the cosmological-constant branch falsifiable by
finite topology and scaling, not by prose. Boundary-exact invisibility becomes a
discrete Stokes/adjointness statement, closure defects become the visible source
channel, and the entire residual cosmological risk is localized in the harmonic
sector. The high-value pilot is therefore not another broad source slogan, but
Betti-number and harmonic-noise scaling for sprinkled diamond order complexes
under the same SJ truncation/window that is used for screen entropy.

This Hodge/projector route now has more precise source anchors. FEEC
(`DM6NREPA`) and the Arnold-Falk-Winther stability review (`8JFSI9CS`) are the
stability and commuting-complex guardrails; Hansen-Ghrist cellular sheaf
Laplacians (`CWXAFIF4`) supply the spectral/cohomological language on cell data;
Dodziuk finite Hodge approximation (`TSAQXS9N`) is the finite harmonic-form
precedent; Edelsbrunner-Olsbock tri-partitions (`D7352JCI`) give constructive
cell decompositions and harmonic bases; and Ribando-Gros et al. (`9RE64BCV`)
warn that combinatorial graph Laplacians and metric-compatible Hodge Laplacians
are not interchangeable. The corrected discrete-first gate should also cite
Laplacian renormalization / coarse-graining sources: higher-order Laplacian
renormalization (`RA8QNNKW`), heterogeneous Laplacian RG (`AN5RZGJZ`), and
Laplacian coarse graining in complex networks (`UR5ADCBP`), plus Loukas'
spectral/cut-guaranteed graph reduction (`PTU4XM4U`) as the guardrail for using
a pre-specified coarse-graining operator `R`. The DEC/FEEC stability bridge
`WB8WBSBX` strengthens the same point on the finite-Hodge side: stability needs
stated geometric conditions, not arbitrary projector algebra. These sources
make the right demand explicit: P9 does not need microscopic continuum
behavior, but it does need a stable coarse-grained or renormalized
harmonic/source observable. A discrete model can be accepted on its own terms;
continuum language should enter as an optional scaling or universality target,
not as a fine-grained admission criterion.
Eichhorn-Mack-Le-Wagner's causal-set configuration-space survey (`RC5XF8RD`)
adds a current intrinsic-observable guardrail: link-degree distributions,
symmetrized-Hasse graph Laplacian spectra, and causal-interval abundance
distinguish causal-set classes with relatively small fluctuations. The next P9
pilot should therefore test these intrinsic observables, or a coarse map derived
from them, before treating block averages as physically meaningful.
`NullEdgeP9IntrinsicOrderObservables` formalizes the first Lean bridge to this
literature: interval abundance and out-degree histograms are invariant under
finite relabeling, so they are genuinely order-intrinsic diagnostics rather
than label/grid artifacts.
These sources should constrain the next theorem statements before P9 is
advertised as more than abstract finite linear algebra.
The latest Aristotle strategy job turns this into a concrete gate:
P9 should seek an iso-histogram separation theorem. The target is a pair of
finite causal sets with identical out-degree and interval-abundance histograms,
but different values of a frozen projected observer readout, with the
separation invariant under order isomorphism and stable under a pre-specified
Alexandrov or spectral coarse map with an explicit scale-uniform bound. This
would show that the observer channel is seeing causal-order geometry not
already captured by current graph-observable histograms. Failure to find such a
pair, or failure under offset sweeps, weight scrambles, or boundary-stripped
controls, is a demotion signal.
Claude's critique adds an important publication boundary. The global
marginals-vs-joint witness is now formalized in
`PhysicsSM.Draft.NullEdgeP9IsohistogramSeparation`, but it is too cheap to
carry the P9 claim by itself: it mainly proves that separate marginal
histograms do not determine a frozen joint readout. The stronger T1 witness is
now formalized in `PhysicsSM.Draft.NullEdgeP9DiamondLocalSeparation`: it
matches joint in/out-degree and global interval-abundance signatures, keeps the
chosen diamond the same size, and separates by the diamond's local interval-size
signature. T2 should be a paired coarse-map program: the erasure side is now
banked in `PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail`, where a
natural critical-collapse map erases the T1 separator; preservation should be
claimed only for a pre-specified admissible class. T3 is now banked in
`PhysicsSM.Draft.NullEdgeP9DiamondLocalityNoiseInvariance`: if the closed
diamond and all relation entries internal to it agree, external relation noise
does not change the local interval-size signature. The positive T2 Class A
route is now banked in
`PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout`: under a
transitive causal relation, a closed subdiamond is convex and the local
interval-size readout restricted to that subdiamond agrees with direct
measurement in the subdiamond. The finite operational refinement is now banked
in `PhysicsSM.Draft.NullEdgeP9OperationalGap`: the T1 readout difference is
packaged as an explicit observer-channel gap. The next refinement is no longer
another qualitative witness, but a quantitative T2 theorem stating when that
gap survives, shrinks, or is erased under a pre-specified coarse map.
`PhysicsSM.Draft.NullEdgeP9ExactRecoveryAdmissibleCoarseMap` adds the first
information-theoretic positive class: if a common exact recovery map restores
both fine source signals, then every fine distinguishing test pulls back to a
coarse observer test. This should be cited as a sufficient admissibility
certificate only; it does not characterize all physical coarse maps or prove
approximate recovery.
`PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback` upgrades
this certificate to normalized finite distributions, column-stochastic observer
channels, and observable expectations: under common exact stochastic recovery,
each fine observable that distinguishes the source distributions has a coarse
pulled-back observable that distinguishes the observer outputs.
`PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryGap` sharpens this to exact
gap preservation: the pulled-back coarse observable has the same expectation
gap as the original fine observable on the selected source pair.
`PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryComposition` proves that this
exact stochastic recovery certificate composes on the selected source pair, so
it is a structurally usable sufficient class of observer channels rather than a
single-stage witness.
`PhysicsSM.Draft.NullEdgeP9StochasticErasureNotRecoverable` gives the matching
no-go: a channel that sends two genuinely distinct source distributions to the
same observer output cannot be exactly recoverable for that pair.
The right prior-art frame is classical comparison of experiments and Markov
kernel sufficiency: Le Cam's review `QAQA2SRN`, Torgersen's stochastic-order
comparison source `QJGJ6KA7`, and the Markov-category formulation of statistical
experiment comparison `9SN4VCVJ` now serve as guardrails for how strongly to
interpret exact recovery.
For the causal-support side, Aslanbeigi-Saravani-Sorkin's generalized causal-set
d'Alembertians (`DQ9CF6I2`) are now the key comparison source: they are retarded
and Lorentz-invariant but nonlocal, include infrared recovery conditions, and
carry explicit stability caveats. P9 kernels should therefore not merely be
finite-support matrices; they should say which relation or neighborhood plays
the retarded-support role, what large-scale operator they approximate, and
whether the induced evolution is stable.
Boguna-Krioukov's local causal-set d'Alembertian (`I72KXVQA`) gives the other
side of the guardrail: locality may be recoverable from intrinsic causal-set
distance data. The `edgeNeighbor_N` line should therefore be tested as a finite
effective-locality relation, not dismissed as naive bounded valency and not
promoted without comparing its scaling behavior to known causal-set
d'Alembertian constructions.

The claim boundary is strict. Identifying the continuum cosmological constant
with the harmonic projection is conjectural. Area-law source noise is not yet an
area-law Lambda fluctuation; that implication needs a separate response law
from finite source/noise data to curvature, expansion, or a unimodular
conjugate variable. If the harmonic Betti numbers or harmonic-noise trace scale
with volume, or if the response law imports the everpresent-Lambda CMB-era
amplitude tension unchanged, P9 should be demoted.

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

The topology gate now comes before the harmonic-channel claim. The full order
complex of a closed finite causal interval may be contractible, so an exact
positive-degree harmonic Lambda channel may be trivial. P9 must specify whether
it uses a proper interval, relative cohomology, the constant `H^0` mode, a top
relative mode, or near-harmonic spectral bands. The harmonic projector should be
written using the pseudoinverse form `Pi_H = I - Delta^+ Delta` in the chosen
weighted metric.

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

Next P9 work packages:

- finite `DiamondHodgeMetric` / `DiamondBookkeepingCochain` definitions;
- adjoint/codifferential convention tied to the chosen SJ metric;
- exact/coexact/harmonic projection API in finite dimension;
- topology audit for closed interval contractibility and the chosen alternative
  harmonic channel;
- pseudoinverse-based Hodge projector theorem;
- pilot scripts for Betti-number scaling of sprinkled diamond order complexes;
- pilot scripts for harmonic-noise trace scaling under independent versus
  cell-local paired residuals;
- propagated-noise estimate for `G_N K_N G_N^*`, not merely `tr(K_N)`;
- a response-law strategy note before any cosmological-constant amplitude claim.

### P10-R. Generations from the exceptional Jordan / triality layer

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
- Null-step Dirac universality (the dynamics theorem behind P4); gated first
  on the homogeneous fixed-point package, invariant `det(P_vis)=m^2` bridge,
  and single-cone/doubler accounting, then on a causal-set spinor propagator.

## Recommended sequencing

1. P1-F remains the first theorem paper. It is the most banked, most
   self-contained, and underpins the rest. Frame it as Plucker mass as finite
   mixedness / celestial variance, promote the celestial-moment wrapper, add the
   reproducibility appendix, and write the artifact paper before reopening broad
   ontology claims.
2. P1-E can proceed in parallel as the accessible explanation, but it should cite
   P1-F for the theorem and label the ontology as interpretation.
3. Develop P2-R/P4-R/P7-R together around the proper-time/purity rate target:
   luminal conditional shifts, chirality coherence, scalar off-diagonal mass,
   Dirac dispersion, invariant `det(P_vis)=m^2`, observer-visible `m/E`, and a
   finite relative-entropy/recoverability diagnostic in one auditable lane.
4. P9-F should continue as a finite source-visibility/noise-channel paper. Its
   cosmological-constant claim stays gated on a response law and comparison with
   the everpresent-Lambda `1 / sqrt(V)` amplitude/correlation benchmark. P9-R
   should wait for that response law.
5. P3-F can run in parallel, but the super-Dirac synthesis should be gated by the
   one-diamond `D^2` computation before broad operator formalization continues.
6. P8-E should wait until P1-F plus at least one dynamics/observer-channel artifact
   exists to cite, so the manifesto rests on artifacts.
7. Gate C branch-taxonomy work should be separated from C0 regulator success:
   publish branch-locus, kernel-sheaf, projection, gap, and ghost-safety
   alternatives as a taxonomy/contract unless a concrete C1 release is proved.
8. Gate H/Gate F forbidden-operator work should be treated as the first
   prediction-grade lane: prove absences and codimensions before claiming mass
   values, and use neutrinos as the explicit Dirac/Majorana/seesaw stress test.
9. P11-R after P2/P4 have a concrete transfer operator and P7 has a usable
   observer-channel API.
10. P5-F and P6-R opportunistically; P10-R only after doubler, chirality, and
   internal-family multiplicities are proven disjoint or explicitly identified.

The most useful theorem/counterexample sequence after P1 is:

1. `localNullSymbol_sq_eq_weightedPluckerMass`;
2. `nullDirac_commutator_mul_eq_edgeDifferences`;
3. `superDirac_isOdd`;
4. `flatSuperDiracSymbol_has_lorentzianMassShell`;
5. `productGradedSuperDirac_sq`;
6. `diamondAdditiveDefect_eq_holonomyMinusId`;
7. `oneDiamond_naturalOperator_classification`;
8. `superDirac_sq_eq_finiteLichnerowicz`;
9. `observerSpinFrame_wellDefined_up_to_SU2`;
10. `gramWeightedPlucker_eq_exteriorSquare`;
11. `massless_iff_rank_VGsqrt_le_one`;
12. `threeLabel_dephasing_not_monotone`;
13. `twoLevelYukawa_coherence_to_dephasedDet`;
14. `closedIntervalOrderComplex_contractible`;
15. `weightedHodgeProjector_eq_pseudoinverseProjector`;
16. `bandLimitedNullWalk_convergesToDirac` plus
    `brillouinZone_coneCensus`.

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


### P12-F. Plucker-Sorkin exterior-history target

#### Candidate publication target: Relational mass as a finite grade-2 history capacity

This lane is now concrete and self-contained:

- Input data: finite edge alternatives `E` with Weyl spinors `\psi_e : \mathbb C^2`.
- Bundle momentum: `P_A = \sum_{e \in A} \psi_e \psi_e^\dagger` on finite edge events `A \subseteq E`.
- Observable:

\[
M(A) = \det P_A.
\]

Cauchy\u2013Binet gives

\[
M(A)=\sum_{\{e,f\}\subseteq A}|\psi_e\wedge\psi_f|^2.
\]

Immediate consequences:

- `M(\varnothing)=0`, `M(A) \ge 0`, and monotonicity on finite set inclusion.
- `M({e})=0` for singleton edges.
- Finite Mobius transform is exactly supported on two-element subsets.
- `I_2(A,B)=M(A\cup B)-M(A)-M(B)=\sum_{e\in A}\sum_{f\in B}|\psi_e\wedge\psi_f|^2 \ge 0`.
- `I_3(A,B,C)=0` for disjoint `A,B,C`; pure grade-2 capacity.

### Strong-positivity interpretation (key interpretive move)

- If a standard strongly positive decoherence functional had diagonal `D(A,A)=M(A)` on singleton-edge histories, singleton diagonals force `D({e},B)=0` for all `e,B`, hence all of `D` is zero.
- Therefore nonzero Plucker mass cannot be the singleton-edge decoherence diagonal.
- Suggested ontology split: `M` is an observable on unordered edge pairs/relational histories, not elementary edge histories.

### Canonical pair-history lift

- Pair-history space: `\Pi_2(E)=\{{e,f\}:e\neq f\}`.
- Additive measure `\nu` on `\Pi_2(E)` with `\nu({\{e,f\}})=|\psi_e\wedge\psi_f|^2`.
- Edge lift: `M(A)=\nu(C_2(A))`, where `C_2(A)` are pairs contained in `A`.
- Uniqueness by set-additivity.

### Coherent pair-history pullback

- For PSD Hermitian `K` on pairs, pullback via pair incidence gives edge set function with Mobius support only at cardinalities `2,3,4`.
- This yields controlled third/fourth-order edge interference from ordinary pair-level quantum coherence.
- Off-diagonal coherence phases (e.g. Abelian holonomy on diamonds) are invisible to diagonal `M` but visible in coherent interference terms.

### Lean integration status

- Add two modules:
  - `PhysicsSM/NullStrand/Histories/ExteriorMassMeasure.lean`
  - `PhysicsSM/NullStrand/Histories/ExteriorRankMeasure.lean`
- Primary dependencies already in-tree:
  - `PhysicsSM/Spinor/PluckerMass`
  - `PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle`
- This is immediately consistent with current ontology:
  - trusted Plucker determinant identity
  - finite grade-2 quantum-measure machinery
  - ready insertion point for publication-facing formalization artifacts.

### Source reference

- `Sources/Plucker_Sorkin_Exterior_History_Theorem.md`

### Integration status

- Added as a planned publication lane in this roadmap, aligned with
  `Sources/NullStrand_Lean_Roadmap_Improved.md`.
- This lane is covered by the completed 2026-06-25 Aristotle batch entries in
  `AgentTasks/null-strand-overnight-ledger-2026-06-25.md`.

## 16. Lateral extension notes (2026-06-27)

- Use a strict 4-layer contract in each paper entry: finite identity -> existence/naturality -> scaling/dynamics -> physical interpretation.
- For P1 and descendants, keep the strongest split explicit:
  - `det(P)` is an invariant finite kinematic object,
  - `det(rho_{p|u})` is observer-conditioned mixedness (`m/E_u` rate),
  - Higgs/chirality channels enter through the same obstruction schema but are separate entries.

- For publication sequencing, elevate the near-term structural-output target:
  - a formal finite forbidden-operator/codimension theorem (including SM-block exclusivity and null off-diagonal exclusions) can be publication-safe before numerical mass fitting.
- A secondary research direction from this analysis is a P1.5/observational bridge: finite Plucker hierarchy (`k>2`) as a canonical obstruction ladder and possible event-shape analogue.
- Treat Gate C as a branch-locus paper before treating it as a release paper:
  `Z = {q | det D_+(q) = 0}`, kernel/projector data, inverse-propagator gaps,
  ghost-zero safety, and branch involutions are first-class publication objects.
- Keep neutrinos as the named Gate H stress test: every legal finite-Dirac
  proposal should state whether `nu_R`, Dirac masses, Majorana masses, and
  seesaw reduction are allowed, optional, or forbidden.
