# Aristotle semantic context pack

Generated: 2026-06-29T06:17:51
Query: `Gate C1 null-edge Standard Model physical chiral fermion release operator matrix-valued branch Wilson overlap Ginsparg Wilson anomaly positivity locality D4 stay move`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `NULL_EDGE_RESULTS.md` [5. The sharply isolated blocker: Gate C]

Score: `0.848`

```text
## 5. The sharply isolated blocker: Gate C

The honest hard problem. The bare retarded null-edge symbol `D_+` does **not**
release as a physical chiral operator. What is now *proved* (not merely
suspected):

- **Bare alignment fails** (C21): the four-component symbol does not force
  aligned chirality. Each nonzero null branch carries a two-dimensional,
  chirality-balanced kernel (one left + one right Weyl line).
- **The determinant-zero locus is larger than the modeled branches**: there are
  off-branch zeros (e.g. `q_star`) and a cyclotomic/S4 orbit of extra zeros
  (C43/C44, C64, C66). A naive `g5` split does not control them.
- **Scalar Wilson lifting cannot release Gate C** (C88, taste no-go): a term
  that is scalar on the origin corner and vanishes quadratically at the origin
  cannot turn the balanced origin kernel into a single chirality, and cannot
  separate an unwanted branch germ reaching the origin.

This produced a clean **C0 / C1 split**:

- **Gate C0 (external species health)** -- plausibly reachable. An
  anti-Hermitian operator plus a positive scalar Wilson mass has a quantitative
  norm lower bound and no kernel (C85/C86, abstract linear algebra, kernel-clean
  draft). On the real torus `W(q) = sum_a (1 - cos q_a)` vanishes only at the
  origin, so it gaps every non-origin determinant zero -- including unknown ones
  -- *without* classifying the full locus.
- **Gate C1 (physical chiral release)** -- still open, and **mandatory** for the
  Standard-Model-facing claim. Because the total chiral index factorizes over
  `H_N tensor H_F`, a chiral internal sector cannot rescue a balanced external
  origin (C87). Origin polarization needs a genuine spinor-line construction
  (projected Weyl / domain-wall / overlap / branch involution `T_br`), not a
  taste
```

### 2. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [26. Literature spine update: null-edge overlap should track proven overlap/flavored-mass/domain-wall models]

Score: `0.842`

```text
## 26. Literature spine update: null-edge overlap should track proven overlap/flavored-mass/domain-wall models

Date: 2026-06-27
Source: `AgentTasks/null-edge-gate-c1-literature-spine-2026-06-27.md`; Zotero collection `9WIG8WGR`; Neo4j collection `Null Edge Gate C1 overlap references`.

The literature search reinforces the reference-model-first policy. The Gate C1 operator should be developed as a null-edge overlap/Ginsparg-Wilson operator with a flavored/species-splitting branch Wilson term:

```text
H_ne = Gamma_K (D_ne + W_branch - m0 R)
T_br = sign(H_ne)
D_ov,ne = rho (1 + Gamma_K T_br)
```

The core references are Neuberger/Luscher/Ginsparg-Wilson for the overlap/GW algebra; Hernandez-Jansen-Luscher for locality/admissibility; Hasenfratz-Laliena-Niedermayer and Kikukawa-Yamada for index/anomaly import; Adams/Hoelbling/Misumi for flavored-mass and staggered-overlap analogues; Kaplan/Kikukawa for domain-wall import mode; and Golterman-Shamir/Poppitz-Shang for mirror/propagator-zero warnings.

The most important modeling consequence is that `W_branch` should not be treated as an arbitrary new correction. It should be developed as a null-edge analogue of an Adams-style flavored mass or species-splitting Wilson term. This matches the finite branch-Pauli/qutrit seed better than a scalar Wilson term and gives us known lattice constructions to compare against.

The locality target should be expressed in two compatible languages:

1. Standard overlap admissibility/locality, following Hernandez-Jansen-Luscher.
2. Null-edge combinatorial path-sum control, following the C122/C143 line.

The anomaly/index target should be imported through a gapped homotopy to a standard overlap/domain-wall model whenever possible, rather than reproved from scratch.

The ghost rule is now litera
```

### 3. `AgentTasks/null-edge-wave27-c106-release-audit-bridge-held-aristotle-2026-06-27.md` [Repository context]

Score: `0.839`

```text
## Repository context

This is a Lean 4 / Mathlib project for Standard Model-adjacent algebra and the null-edge program. Gate C is the current hard external-branch problem. Current discipline:

- C0 means external species health, such as scalar Wilson gapping of non-origin branches.
- C1 means physical chiral release and remains open.
- A C1 release requires explicit physical-sector data: retained Weyl line, mirror inverse-propagator gap, anomaly accounting, ghost-zero safety, Krein/spectral health, and locality or controlled quasi-locality.
- Route labels such as overlap/Ginsparg-Wilson/domain-wall/projection do not themselves prove release.

Relevant local modules now available:

- `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`: recovered C90 API hardening for `ProjectedWilsonGateCRelease D_phys`, with residue positivity, no ghost-zero safety, BRST/Krein, and regulator-moduli clauses separated.
- `PhysicsSM/Draft/NullEdgeBranchLocusPhysicalSectorAPI.lean`: C100 branch-locus/physical-sector API.
- `PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean`: C104 branch classifier / `T_br` scaffold.
- `PhysicsSM/Draft/NullEdgeReleaseAuditToyGuardrails.lean`: finite toy counterexamples showing route label, projection, and localization do not imply full release audits.
- `PhysicsSM/Draft/NullEdgeLocalityCertificateToy.lean`: finite toy counterexamples showing a formal projector does not imply locality, and quasi-local decay is not finite-range ultralocality.
```

### 4. `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [13.6 Gate C staging: C0 species health before C1 chiral release]

Score: `0.835`

```text
### 13.6 Gate C staging: C0 species health before C1 chiral release

The next working split is:

```text
Gate C0: external species health.
  Keep the origin branch.
  Gap every non-origin real-torus branch by an inverse-propagator mass gap.
  Preserve the leading null-edge continuum symbol.
  Exclude free propagator-zero ghosts.

Gate C1: physical chiral release.
  Choose the physical chirality grading and positive physical sector.
  Prove the retained origin branch is chiral in that grading.
  Prove the gauge/Krein/ghost/counterterm clauses needed for the physical
  Standard-Model-facing release.
```

This split matters because a scalar Wilson term can plausibly solve C0 without
solving C1. In the retarded/advanced double, the pure finite linear algebra
lemma is:

```text
If A^dagger = -A and m > 0, then A + m I is invertible, with singular value
bounded below by m.
```

Therefore, for:

```text
A = D_RA(q)
m = r W(q)
```

and real `q != 0`, the Wilson positivity `W(q)>0` should imply:

```text
D_RA(q) + r W(q) I is invertible.
```

This would gap every non-origin real-torus determinant zero, including unknown
off-branch or cyclotomic zeros, without first classifying the full zero locus.
It would not make the origin branch chiral. Therefore it is a C0 theorem, not a
Gate C release.

Immediate C0 theorem targets:

```text
antiHermitian_add_posScalar_invertible;
antiHermitian_add_posScalar_singularValue_bound;
DRA_antiHermitian;
DRA_wilson_invertible_away_origin;
DRA_wilson_gap_not_projector_zero;
GateC0SpeciesHealthy_from_RAWilson.
nullWilson_positiveSemidefinite;
nullWilson_kernel_covariantlyConstant.
```

Immediate C1 theorem targets:

```text
PhysicalSectorData;
Tbr_exists_or_noGo;
modifiedChirality_after_Tbr;
positivePhysicalSector;
GateC1ChiralPhysicalRelease;
Stag
```

### 5. `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [32.5 Updated near-term work]

Score: `0.835`

```text
### 32.5 Updated near-term work

Replace broad abstract C1 searching with this concrete stack:

```text
1. Define the gamma5-Hermitian null-edge kernel H_ne.
2. Prove its continuum branch expansion.
3. Classify free branch zeros and branch masses.
4. Prove a scalar Wilson branch window or show that a flavored/matrix Wilson
   mass is required.
5. Prove the free overlap gap and no mirror pole.
6. Prove the Ginsparg-Wilson relation for D_ov,ne.
7. Prove gapped homotopy to the Wilson/Neuberger+CKM reference, or compute the
   index directly.
8. Add admissible-gauge/locality or controlled path-sum hypotheses.
9. Only after that, address determinant-line/anomaly/Krein/ghost audits for the
   Standard Model multiplet.
```

Current status:

```text
The program now has a sharper candidate C1 operator architecture.
It still does not have the explicit H_ne branch-mass window, overlap gap, or
full Standard Model determinant/anomaly construction.
```
```

### 6. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [19. Null-edge flavored-overlap / matrix-valued Wilson kernel]

Score: `0.828`

```text
## 19. Null-edge flavored-overlap / matrix-valued Wilson kernel

The next concrete Gate C1 reference-model test is:

```text
Null-edge flavored overlap.
```

The goal is not to invent a new chiral regulator. The goal is to adapt the
known overlap/Ginsparg-Wilson architecture and ask whether the kernel can be
made null-edge-native.

Baseline form:

```text
D_kernel(U) = D_ne(U) + W_branch(U) - m0 R;
H_ne(U) = Gamma_K D_kernel(U);
T_br(U) = sign(H_ne(U));
P_phys(U) = (1 + T_br(U)) / 2;
P_bad(U) = (1 - T_br(U)) / 2.
```

Here `W_branch` is not a scalar Wilson term. It is a matrix-valued
branch/taste/flavor Wilson term, analogous in role to flavored-mass or
staggered-Wilson terms in the lattice literature.
```

### 7. `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [32. Pro architecture update: Gate C should use a Null-Edge Overlap release]

Score: `0.828`

```text
## 32. Pro architecture update: Gate C should use a Null-Edge Overlap release

Date: 2026-06-28
Source: Pro analysis in
`C:\Users\Owner\.codex\attachments\5230e00c-8f61-493e-b9e2-b467d63d70a6\pasted-text.txt`.

This is the clearest current Gate C architectural rule:

```text
The finite null-edge seed should not be the complete chiral-release operator.

The finite null-edge seed should define the null-edge/path-combinatorial kernel
inside a Wilson/flavored-Wilson Hermitian overlap construction.

The overlap sign function or equivalent domain-wall transfer construction
should supply the C1 chiral release.
```

The preferred operator pipeline is:

```text
null-edge finite kernel
  -> gamma5-Hermitian Wilson/flavored-Wilson Hermitian kernel H_ne
  -> Neuberger overlap sign operator sign(H_ne)
  -> Ginsparg-Wilson chiral projectors
  -> Weyl determinant / anomaly-free multiplet construction
```

Domain-wall form is an equivalent implementation:

```text
null-edge-derived four-dimensional kernel
  -> five-dimensional domain-wall transfer/sign engine
  -> boundary overlap operator in the infinite-wall limit.
```

Do not make the fifth/domain-wall direction a physical null direction in the
first theorem. Treat it as the spectral-flow/sign-function direction.
```

### 8. `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [13.3 Scalar Wilson no-go for Gate C release]

Score: `0.826`

```text
### 13.3 Scalar Wilson no-go for Gate C release

Scalar Wilson positivity is a branch-lifting lemma, not a chiral release
theorem.

Reason:

```text
D_+(0) = 0
W(0) = 0
```

So a plain scalar Wilson lift still leaves the origin fiber untouched. Unless a
separate physical projection or flavored grading is supplied, the origin kernel
remains Gamma_s-balanced and has zero ordinary Gamma_s index.

More strongly, if an unwanted determinant-zero curve `q(t)` reaches the origin
and the lift is only `r W + lambda (I - F_tet)`, then near the origin:

```text
W(q(t)) = O(|q(t)|^2)
I - F_tet(q(t)) = O(|q(t)|^2)
```

while the overlap branch mass satisfies:

```text
b(0;m_0) = -m_0 < 0.
```

By continuity, the unwanted branch remains retained near the origin. Therefore
Gate C needs either:

```text
a principled B_phys excluding that branch germ;
a local/gauge-covariant T_br separating it;
or a different physical-sector construction.
```
```

### 9. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [56. Pro architecture update: Null-Edge Overlap as the primary C1 operator]

Score: `0.824`

```text
## 56. Pro architecture update: Null-Edge Overlap as the primary C1 operator

Date: 2026-06-28
Source: Pro analysis in
`C:\Users\Owner\.codex\attachments\5230e00c-8f61-493e-b9e2-b467d63d70a6\pasted-text.txt`.

This update sharpens the operator choice:

```text
null-edge finite kernel
  -> gamma5-Hermitian Wilson/flavored-Wilson Hermitian kernel H_ne
  -> Neuberger overlap sign operator sign(H_ne)
  -> Ginsparg-Wilson chiral projectors
  -> Weyl determinant / anomaly-free multiplet construction
```

Equivalently, the same architecture can be implemented as a domain-wall fermion
whose four-dimensional kernel is null-edge-derived. The fifth/domain-wall
direction should be treated as the spectral-flow/sign-function engine, not as a
physical null direction in the first pass.

The architectural correction is:

```text
The null-edge seed supplies the local/path-combinatorial kernel and
branch-mass geometry.

The overlap sign function supplies the chiral release.
```

Therefore:

```text
Do not try to make the finite retarded seed itself be the C1 release operator.
Treat it as a kernel, deformation, or path-combinatorial input to an
index-carrying overlap/Ginsparg-Wilson/domain-wall construction.
```
```

### 10. `AgentTasks/model-calls/claude/2026-06-27-124149-cycle14-c103-c105-review.md` [Project context]

Score: `0.821`

```text
## Project context

This repository formalizes mathematical structures for Standard Model physics in
Lean 4. The null-edge program currently separates:

- Gate C0: external species health / gap control.
- Gate C1: physical chiral release.
- Gate H: internal finite Dirac legality and anomaly/spectrum constraints.
- Gate F: prediction/codimension, with absence theorems preferred over mass
  magnitudes.

Recent Gate C evidence says:

- scalar Wilson / scalar-on-origin terms can help C0 but do not select a
  physical Weyl line;
- propagator-zero removal of gauge-charged mirrors is not acceptable without an
  explicit ghost-safety theorem;
- C1 likely requires a branch-line projector, projected overlap construction,
  spinor-line/matrix Wilson term, domain-wall/boundary construction, or
  controlled quasi-local projector.
```

### 11. `AgentTasks/null-edge-claude-adversarial-review-cycle14-c103-c105-2026-06-27.md` [Project context]

Score: `0.821`

```text
## Project context

This repository formalizes mathematical structures for Standard Model physics in
Lean 4. The null-edge program currently separates:

- Gate C0: external species health / gap control.
- Gate C1: physical chiral release.
- Gate H: internal finite Dirac legality and anomaly/spectrum constraints.
- Gate F: prediction/codimension, with absence theorems preferred over mass
  magnitudes.

Recent Gate C evidence says:

- scalar Wilson / scalar-on-origin terms can help C0 but do not select a
  physical Weyl line;
- propagator-zero removal of gauge-charged mirrors is not acceptable without an
  explicit ghost-safety theorem;
- C1 likely requires a branch-line projector, projected overlap construction,
  spinor-line/matrix Wilson term, domain-wall/boundary construction, or
  controlled quasi-local projector.
```

### 12. `AgentTasks/null-edge-pro-c1-resolution-package-2026-06-27.md` [`NullEdgeProjectedGateCWilsonRelease`]

Score: `0.818`

```text
### `NullEdgeProjectedGateCWilsonRelease`

Recovered C90 Aristotle payload.

Current role:

- Main projected Wilson-release API spine for `D_phys`.
- Public verdict is `ProjectedWilsonGateCRelease D_phys`.
- Legacy `GateCReleased` is only a deprecated shim.
- Separates:
  - residue/Krein positivity,
  - no gauge-coupled ghost zeros,
  - explicit BRST/Krein obligation,
  - Wilson-regulator moduli clauses.

What it does not do:

- Does not construct `D_phys`.
- Does not release bare `D_+`.
- Does not solve C1.
```

## Scoped paper hits

### 1. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.757`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 2. Extension of the Nielsen-Ninomiya theorem

Score: `0.747`
Zotero key: `arxiv:hep-lat/9803002`
arXiv: `hep-lat/9803002`
DOI: `10.1103/PhysRevD.58.057505`
URL: http://arxiv.org/abs/hep-lat/9803002

Abstract:

Extends the Nielsen-Ninomiya no-go theorem for lattice chiral Dirac fermions using the index theorem, including translation non-invariant and non-local formulations.

### 3. Locality properties of Neuberger's lattice Dirac operator

Score: `0.746`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 4. Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation

Score: `0.745`
Zotero key: `N68MN4ET`
arXiv: `hep-lat/9802011`
DOI: `10.1016/S0370-2693(98)00423-7`
URL: https://arxiv.org/abs/hep-lat/9802011

Abstract:

It is shown that the Ginsparg-Wilson relation implies an exact symmetry of the fermion action, which may be regarded as a lattice form of an infinitesimal chiral rotation. Using this result it is straightforward to construct lattice Yukawa models with unbroken flavour and chiral symmetries and no doubling of the fermion spectrum. A contradiction with the Nielsen-Ninomiya theorem is avoided, because the chiral symmetry is realized in a different way than has been assumed when proving the theorem.

### 5. Four-dimensional graphene and chiral fermions

Score: `0.744`
Zotero key: `7AWX5A4Z`
arXiv: `0712.1201`
URL: https://www.zotero.org/19894138/items/7AWX5A4Z

Abstract:

Motivated by the graphene electronic structure in terms of the relativistic Dirac equation, a generalization to four dimensions yields a strictly local fermion action describing two species and possessing an exact chiral symmetry. This is the minimum number of species required by the no-go theorems. Uses a hyperdiamond direction set with tetrahedral symmetry and cos theta = -1/4 angles between bond vectors.

### 6. Spin on a 4D Feynman Checkerboard

Score: `0.741`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 7. Anomalies and symmetric mass generation for Kaehler-Dirac fermions

Score: `0.732`
Zotero key: `RRXM9WFC`
arXiv: `2101.01026`
DOI: `10.1103/PhysRevD.104.094504`
URL: http://arxiv.org/abs/2101.01026

Abstract:

We show that massless Kaehler-Dirac (KD) fermions exhibit a mixed gravitational anomaly involving an exact U(1) symmetry which is unique to KD fields. Under this U(1) symmetry the partition function transforms by a phase depending only on the Euler character of the background space. Compactifying flat space to a sphere we learn that the anomaly vanishes in odd dimensions but breaks the symmetry down to Z_4 in even dimensions. This Z_4 is sufficient to prohibit bilinear terms from arising in the fermionic effective action. Four fermion terms are allowed but require multiples of two flavors of KD field. In four dimensional flat space each KD field can be decomposed into four Dirac spinors and hence these anomaly constraints ensure that eight Dirac fermions or, for real representations, sixteen Majorana fermions are needed for a consistent interacting theory. These constraints on fermion number agree with known results for topological insulators and recent work on discrete anomalies rooted in the Dai-Freed theorem. Our work suggests that KD fermions may offer an independent path to understanding these constraints. Finally we point out that this anomaly survives intact under discretization and hence is relevant in understanding recent numerical results on lattice models possessing massive symmetric phases.

### 8. Quantum Many-Body Lattice C-R-T Symmetry: Fractionalization, Anomaly, and Symmetric Mass Generation

Score: `0.731`
Zotero key: `9FFS4GFC`
arXiv: `2412.19691`
URL: http://arxiv.org/abs/2412.19691

Abstract:

Charge conjugation (C), mirror reflection (R), and time reversal (T) symmetries, along with internal symmetries, are essential for massless Majorana and Dirac fermions. These symmetries are sufficient to rule out potential fermion bilinear mass terms, thereby establishing a gapless free fermion fixed point phase, pivotal for symmetric mass generation (SMG) transition. In this work, we systematically study the anomaly of C-R-T-internal symmetry in all spacetime dimensions by analyzing the projective representation (i.e. the fractionalization) of the C-R-T-internal symmetry group in the quantum many-body Hilbert space on the lattice. By discovering the fermion-flavor-number-dependent C-R-T-internal symmetry's anomaly structure, we demonstrate an alternative way to derive the minimal flavor number for SMG, which shows consistency with known results from Kahler-Dirac fermion or cobordism classification. Our findings reveal that, in general spatial dimensions, either 8 copies of staggered Majorana fermions or 4 copies of staggered Dirac fermions admit SMG.
