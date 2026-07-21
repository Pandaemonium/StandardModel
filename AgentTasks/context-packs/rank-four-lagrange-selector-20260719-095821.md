# Aristotle semantic context pack

Generated: 2026-07-19T09:58:30
Query: `equivariant polynomial spectral projector Lagrange interpolation rank four isolated eigenvalues causal operator selected sector`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `docs/DOCUMENT_MAP.md` [The null-edge program: core documents]

Score: `0.857`

```text
inside a subspace up to basis change. The rank-four
  control is cardinality-driven and does not establish causal dimension,
  Lorentzian signature, or continuum probe convergence. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/RankFourCarrierProbeSector.lean`,
  `PhysicsSM/Draft/NullEdge/EquivariantProbeSectorSelector.lean`, and
  `PhysicsSM/Draft/NullEdge/EquivariantInvolutionProbeProjector.lean` - the
  corrected local target is a supplied rank-four subspace of the full carrier
  probe space, selected basis-free as a kernel, range, projector, or positive
  eigenspace. Intertwining maps transport each sector exactly. Projectors and
  involutions are polynomially equivalent, so the involution interface removes
  eigenvector ordering but does not derive graph structure, a four-mode gap,
  or Lorentzian inertia. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/EquivariantPolynomialProbeProjector.lean` - exact
  basis-free functional-calculus naturality. Intertwining carrier operators
  transport every common real-polynomial filter and its range; source
  idempotence and rank-four certificates transport to the target, and the
  selected range packages as the existing carrier projector. The module does
  not derive the operator, polynomial, spectral gap, source rank, Lorentzian
  inertia, overlap compatibility, or continuum tetrad. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/RetardedPolynomialProjectorNoGo.lean` - exact
  algebraic obstruction to selecting a proper sector from a one-spectrum
  operator: every idempotent real-polynomial filter of `a I + N` with
  nilpotent `N` is zero or identity. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/FiniteStrictPastNilpotence.lean` - exact finite
  causal-combinatorial bridge: every arbitrarily weighted strict-past operator
  on a nonempty finite trans
```

### 2. `Sources/Null_Edge_Spectral_Question_Prior_Work_Note_2026-07-16.md` [What appears to be original ([orig] candidates, pending full-text checks)]

Score: `0.833`

```text
## What appears to be original ([orig] candidates, pending full-text checks)

- **The corrected pairing as the spectral object.** The
  diagonal-cancelled polarization form - kernel-proved equal to a
  symmetric weighted finite-difference operator with zero-sum range -
  is not, to our current knowledge, studied spectrally anywhere in the
  causal-set literature (the literature spectrally analyzes i*Delta,
  retarded d'Alembertians, and propagators). [orig] candidate.
- **The four-mode question itself.** Seeking a STABLE FOUR-DIMENSIONAL
  isolated eigensector of an order-native operator on protected-core
  carriers, as a candidate frame/tetrad germ, has no visible
  antecedent in the spectral causal-set line (which targets vacua,
  entropy, dimension, or geometry-fingerprinting, not a rank-four
  frame sector). [orig] candidate.
- **The kernel-checked receiving interface.** Polynomial spectral
  filters with transported certificates, the projector/involution
  equivalences, the permutation and hidden-rescaling no-gos - the
  formal infrastructure is program-original ([orig], with standard
  linear algebra tagged [import] in the modules themselves).
```

### 3. `AutonomousLab/reviews/CLAUDE_REVIEW_POLYNOMIAL_PROBE_PROJECTOR_2026-07-16.md` [The audited declarations - all exact]

Score: `0.829`

```text
## The audited declarations - all exact

- `polynomialFilter_intertwines`: pointwise intertwining lifts to the
  conjugation algebra equivalence (proved by ext + the hypothesis at
  `E.symm y`), and `aeval_algHom_apply` then gives naturality of the
  ENTIRE polynomial functional calculus in one step. This is the right
  basis-free mechanism - no eigenvector, ordering, or spectral
  decomposition anywhere.
- `map_range_polynomialFilter_eq`: exact range transport through the
  existing selector-interface lemma. Correct.
- `rankFourProbeProjectorOfPolynomial`: packages
  `aeval A p` into the existing interface with idempotence and rank
  four as SUPPLIED hypotheses - exactly the requested reading;
  certificate obligations stay displayed, nothing is derived from
  spectral assumptions that do not exist here.
- `polynomialProjectorSector_mapOrderIso_space_eq`: ONE common
  polynomial applied to intertwining carrier operators yields equal
  selected sectors after exact order relabeling, via the polynomial
  naturality plus the existing sector-transport lemma. Certificate
  hypotheses displayed at BOTH carriers.
- `identity_polynomial_filter_rank_four_witness`: the identity on four
  scalar coordinates with p = X - idempotent, range rank four -
  discharges the certificate's satisfiability "without claiming graph
  origin" (its own docstring says so). Nonvacuity done right.
```

### 4. `AgentTasks/null-edge-graph-involution-projector-gate-2026-07-16.md` [Preferred theorem ladder]

Score: `0.824`

```text
## Preferred theorem ladder

1. **Projector/involution equivalence: complete.** The integrated module proves
   (J_P^2=I), (P_{J_P}=P), and (J_{P_J}=J), plus exact range and
   intertwining transport for the forward positive projector.
2. **Symmetry obstruction: complete.** The fully permutation-equivariant
   rank-four no-go for scalar vertex probes at (n\ge6) is kernel-checked with a
   build-enforced axiom guard and independently approved without revision.
3. **Polynomial-filter naturality: complete.** Intertwining carrier operators
   transport every common real-polynomial filter, its range, idempotence, and
   range finrank exactly. A certified rank-four filter packages into the
   carrier projector without eigenvector choices. The graph still owes the
   operator and the spectral certificate.
4. **Four-mode isolation.** State a displayed fourth/fifth spectral-gap gate
   and prove rank four only from that gate. Do not infer rank from a numerical
   eigensolver without a certified gap.
5. **Lorentzian inertia.** Restrict the independently defined probe pairing to
   the selected sector and prove inertia `(1,3,0)`. A positive spectral sector
   alone does not provide a Lorentzian form.
6. **Overlap/refinement transport.** Feed the selected projector into
   `ProtectedCoreProbeProjectorTransition.lean`; separately prove shared
   projector, liftability, restricted injectivity, triple compatibility, and
   gap persistence along refinement.
```

### 5. `AgentTasks/null-edge-graph-involution-projector-gate-2026-07-16.md` [Operator-selection decision]

Score: `0.823`

```text
nterface is now landed in
`PhysicsSM/Draft/NullEdge/EquivariantPolynomialProbeProjector.lean`. This
removes functional-calculus covariance as a possible hidden obstacle but does
not make a numerical threshold canonical. The admissible next theorem must
derive an order-native operator and certify a four-mode polynomial projector
or an equivalent separated spectral sector before any held-out metric test.
```

### 6. `AgentTasks/null-edge-graph-involution-projector-gate-2026-07-16.md` [Operator-selection decision]

Score: `0.822`

```text
## Operator-selection decision

No new numerical selector should be opened merely by writing
`sign(A - tau I)`. First require a candidate (A) to satisfy all four
pre-data conditions:

1. constructed from the finite order and admitted carrier decorations only;
2. exactly equivariant under order isomorphisms;
3. accompanied by an intrinsic threshold or a threshold-free kernel target;
4. linked to an analytic continuum symbol or a sourced field-theoretic role.

The current causal retarded operator is a possible input only after its
protected-germ support and adjoint structure are fixed. Its raw lowest modes
and normal-operator filters have already failed the earlier intrinsic-probe
benchmark, so low spectral cost alone is a killed selection principle.

There is now a sharper preregistered audit of the direct polynomial route. The
finite retarded operator appears to be a scalar diagonal plus a weighted
strict-past operator. Focused Aristotle projects
`cdb53c37-a5ad-4c72-9714-27136ce91f62` and
`1c4479b1-3215-4d68-a5f1-6bfd9fb13aae` prove, respectively, strict-past
nilpotence and the theorem that scalar-plus-nilpotent operators have only
trivial idempotent polynomial filters. Both are integrated and composed with
the production layered and active smeared operators in
`LayeredOperatorPolynomialNoGo.lean`. Independent review approved both
Aristotle statement chains and the graph-facing bridge without revision. The
direct retarded polynomial-filter family is therefore closed; corrected
symmetric, normal, Hermitian, and richer constraint operators remain open.

The exact polynomial interface is now landed in
`PhysicsSM/Draft/NullEdge/EquivariantPolynomialProbeProjector.lean`. This
removes functional-calculus covariance as a possible hidden obstacle but does
not make a numerical t
```

### 7. `PhysicsSM/Draft/NullEdge/EquivariantProbeSectorSelector.lean` [RankFourProbeProjector.sector]

Score: `0.819`

```text
def RankFourProbeProjector.sector
    {C : FiniteCausalOrder V} {A : MarkedDiamond C}
    (P : RankFourProbeProjector A) : RankFourCarrierProbeSector A :=
  rangeSector A P.project P.range_finrank_eq_four

/-- Intertwining rank-four projectors select the same sector after order
transport.  This is the finite naturality target for a spectral projector
constructed from order-native operator data. -/
```

### 8. `AgentTasks/null-edge-causal-mesoscopic-algebra-stage-a39-benchmark-2026-07-15.md` [Objective]

Score: `0.814`

```text
## Objective

Test whether the degree-two envelope of a rank-four generator subspace can act
as a basis-independent mesoscopic function algebra for the count-normalized
causal operator.

The candidate was

\[
  \mathcal A_L^{(2)}=\operatorname{span}
  \{1,V_L,\operatorname{Sym}^2V_L\}.
\]

The order-derived sector used the simultaneous Johnston interval embedding.
Dimension four, density, endpoints, duration, spatial rank three, and the
four-dimensional operator family remained supplied.

The protocol was frozen in
`AgentTasks/null-edge-causal-mesoscopic-algebra-stage-a39-plan-2026-07-15.md`.
```

## Scoped paper hits

### 1. The Spectral Action Principle

Score: `0.752`
Zotero key: `6WURA7MF`
DOI: `10.1007/s002200050126`
URL: https://doi.org/10.1007/s002200050126

### 2. Combinatorial and Hodge Laplacians: Similarities and Differences

Score: `0.733`
Zotero key: `9RE64BCV`
DOI: `10.1137/22M1482299`
URL: https://doi.org/10.1137/22M1482299

### 3. The Exceptional Jordan Eigenvalue Problem

Score: `0.733`
Zotero key: `WEZ86AZW`
arXiv: `math-ph/9910004`
URL: http://arxiv.org/abs/math-ph/9910004

Abstract:

We discuss the eigenvalue problem for 3x3 octonionic Hermitian matrices which is relevant to the Jordan formulation of quantum mechanics. In contrast to the eigenvalue problems considered in our previous work, all eigenvalues are real and solve the usual characteristic equation. We give an elementary construction of the corresponding eigenmatrices, and we further speculate on a possible application to particle physics.

### 4. Laplace and Dirac Operators on Graphs

Score: `0.729`
Zotero key: `WW6TKVH8`
arXiv: `2203.02782`
URL: https://www.zotero.org/19894138/items/WW6TKVH8

Abstract:

Discrete versions of the Laplace and Dirac operators studied in the context of combinatorial models of statistical mechanics and quantum field theory. Introduces several variations of the Laplace and Dirac operators on graphs and investigates graph-theoretic versions of the Schroedinger and Dirac equation, with a combinatorial interpretation for solutions, and proves gluing identities for the Dirac operator on lattice graphs as well as for graph Clifford algebras.

### 5. Higher-order Laplacian renormalization

Score: `0.727`
Zotero key: `RA8QNNKW`
arXiv: `2401.11298`
DOI: `10.1038/s41567-025-02784-1`
URL: https://doi.org/10.1038/s41567-025-02784-1
