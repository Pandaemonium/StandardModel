# Aristotle semantic context pack

Generated: 2026-07-17T02:54:28
Query: `finite causal-set massive retarded Green function with local vertex measure insertion, strict-past nilpotence, Higgs radial mass`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AutonomousLab/work/role-activations/role-20260716-201927-f0636405_deliverable.md` [4. Scalar propagation supports a path-sum Higgs architecture, not a literal path]

Score: `0.823`

```text
### 4. Scalar propagation supports a path-sum Higgs architecture, not a literal path

**Primary sources:**

- Steven Johnston, *Particle propagators on discrete spacetime*,
  arXiv:0806.3083, DOI:10.1088/0264-9381/25/20/202001. New key:
  `3FEVHQJA`.
- Nomaan X, Fay Dowker, and Sumati Surya, *Scalar Field Green Functions on
  Causal Sets*, arXiv:1701.07212, DOI:10.1088/1361-6382/aa6bc7. New key:
  `4IHIDDGX`.

**Full-text verification:** Johnston's stored chunks 140, 151, and 155-157, and
the later paper's chunks 2, 6-7, and 11-15. The massive retarded scalar Green
function is represented as a mass-scattering series built from the massless
one; on the causal set this becomes a sum over chains or paths with hop and
stop weights. Stated continuum agreements are dimension- and background-
dependent. The curved paper proves or proposes extensions in Riemann normal
neighborhoods and selected conformally flat constant-curvature spacetimes.

**Consequence for the Higgs question:** this literature supports treating a
massive Higgs excitation as aggregate causal-set propagation assembled from a
massless causal kernel plus local mass insertions. It does not show that a Higgs
quantum follows one unique null edge, that every hop is a Hasse link in every
dimension, or that the interacting Standard Model Higgs sector is recovered.
The null-edge model's safest ontology remains: Higgs values on vertices,
covariant changes on causal edges, local Yukawa flips, and an emergent massive
propagator after summing histories.
```

### 2. `PhysicsSM/Draft/NullEdge/GeometryWeightedHiggsFunctional.lean` [weightedHiggsFunctional_nonneg]

Score: `0.785`

```text
theorem weightedHiggsFunctional_nonneg
    (s t : E -> V) (edgeWeight : E -> Real) (vertexWeight : V -> Real)
    (lam vacuum : Real) (phi : V -> Complex) (U : E -> Circle)
    (hEdge : ∀ e, 0 <= edgeWeight e)
    (hVertex : ∀ x, 0 <= vertexWeight x)
    (hLam : 0 <= lam) :
    0 <= weightedHiggsFunctional s t edgeWeight vertexWeight lam vacuum phi U := by
  exact add_nonneg
    (Finset.sum_nonneg fun e _ =>
      mul_nonneg (hEdge e) (Complex.normSq_nonneg _))
    (Finset.sum_nonneg fun x _ =>
      mul_nonneg (hVertex x) (mul_nonneg hLam (sq_nonneg _)))

/-- With frozen modulus, the radial potential vanishes and the finite
functional reduces exactly to the weighted gauge-invariant link mismatch. -/
```

### 3. `AgentTasks/finite-strict-past-nilpotence-aristotle-2026-07-16.md` [Objective]

Score: `0.779`

```text
## Objective

Prove that every weighted strict-past incidence operator on a nonempty finite
transitive irreflexive relation is nilpotent at the event-cardinality power.
Also prove a nonzero two-event chain witness whose operator squares to zero.

This is the causal-combinatorial half of the proposed retarded polynomial-
projector no-go. Combined with the separate scalar-plus-nilpotent Aristotle
job, it would show that direct polynomial idempotents of the finite retarded
operator are trivial.
```

### 4. `PhysicsSM/Draft/NullEdge/GeometryWeightedHiggsFunctional.lean` [radialPotentialDensity]

Score: `0.778`

```text
def radialPotentialDensity (lam vacuum : Real) (z : Complex) : Real :=
  lam * (Complex.normSq z - vacuum ^ 2) ^ 2

/-- Finite Higgs functional with supplied edge and vertex weights. The edge
weights may be signed; nonnegativity is a separate theorem with explicit
hypotheses. -/
```

### 5. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [7.1 The Higgs is an internal zero-form with edge-supported variation]

Score: `0.776`

```text
### 7.1 The Higgs is an internal zero-form with edge-supported variation

The Higgs should not be pictured as another constituent moving down one null
edge. In the current finite architecture the scalar value is vertex-local
internal data, while its gauge-covariant variation is measured across edges.
It is therefore special by mathematical degree, not exempt from causal
propagation. The clean residence/transport split is:

| Object | Finite residence | What propagates or varies | Present status |
|---|---|---|---|
| Vacuum section \(H_0\) | Internal scalar data at vertices | Nothing when it is covariantly constant; unbroken holonomies preserve it | Exact finite interpretation of the link-stiffness zero set |
| Higgs excitation \(h\) in \(H=H_0+h\) | Vertex zero-form | Gauge-covariant edge differences, and only after composition the associated discrete wave propagation | Kinetic route identified; no continuum Higgs pole theorem |
| Yukawa/Higgs map \(\Phi_H\) | Internal endomorphism on the left-right carrier | Local chirality conversion coupled to the null-edge kinetic operator | Exact finite oddness, covariance, and square identities |
| Fermion mass | Eigenvalue/singular-value data of \(\Phi_H\) | Massive propagation emerges from repeated null transport plus local left-right conversion | Finite mass block exact; physical Yukawa spectrum supplied |
| Gauge-boson mass | Orbit stiffness of edge holonomy relative to \(H_0\) | Holonomy directions that fail to preserve \(H_0\) pay quadratic edge cost | Exact stiffness identity; mass reading requires vacuum and small-holonomy expansion |
| Composite/carrier mass | Spectrum of the full interacting carrier | Null transport, gauge/closure/binding channels, and local Higgs turns can all contribute | Finite channel budgets and toy
```

### 6. `PhysicsSM/Draft/NullEdge/HiggsRadialCurvature.lean`

Score: `0.775`

```text
import PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional

/-!
# Radial Higgs potential curvature

This module isolates the mass normalization of the radial excitation in the
one-component Higgs control model. Along the real radial line

`phi(h) = vacuum + h`,

the quartic potential has an exact polynomial expansion. Its quadratic term is
`(1 / 2) * radialMassSquared * h^2`, with

`radialMassSquared = 8 * lam * vacuum^2`.

The factor eight belongs to the potential convention used by
`GeometryWeightedHiggsFunctional`; it is not the usual Standard Model doublet
normalization unless the field and coupling conventions are translated. The
coupling and vacuum value are supplied. No electroweak vacuum selection,
renormalization-group flow, continuum pole theorem, or 125 GeV prediction is
claimed. Claim grade: `M [comp]`.
-/
```

### 7. `AgentTasks/context-packs/finite-strict-past-nilpotence-20260716-20260716-144958.md` [Submitted P9 retarded nilpotent reach job]

Score: `0.772`

```text
## Submitted P9 retarded nilpotent reach job

Submitted Aristotle project:

- `dd4fb31d-a4d4-4d1e-a565-510c57aafe3a`
  `null-edge-p9-retarded-nilpotent-reach-20260623`

Task:

- `a24c6395-edc0-44dc-bd1e-71a8a9b95213`

Staged source:

- `AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean`

Task note:

- `AgentTasks/null-edge-p9-retarded-nilpotent-reach-aristotle-2026-06-23.md`

Targets:

- `applyKernel_vanishes_off_reach`
- `iterateApply_supported_in_exact_reach`
- `no_reach_beyond_rank`
- `iterateApply_eq_zero_beyond_rank`

Scientific role: this job turns the causal-set retarded/nonlocal response
literature into a finite theorem target. If a support relation strictly
decreases a rank on a finite diamond, exact reach is empty beyond the rank
height and iterated response kernels vanish. This would give P9 a clean finite
retarded-horizon theorem, independent of any fine-grained continuum limit.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean
```

The Lean preflight found exactly the four intended proof-hole warnings and no
other errors; non-ASCII scan was clean. The focused package helper reported
four proof-hole lines, zero proof-escape tokens, and zero unsafe tokens.

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9RetardedNilpotentReach`

Verification:
```

### 8. `AutonomousLab/work/role-activations/role-20260716-201927-f0636405_deliverable.md` [6. Finite/internal Dirac geometry is precedent for the Higgs split]

Score: `0.772`

```text
### 6. Finite/internal Dirac geometry is precedent for the Higgs split

**Primary source:** Ali H. Chamseddine and Alain Connes, *Noncommutative
Geometry as a Framework for Unification of all Fundamental Interactions
including Gravity. Part I*, arXiv:1004.0464,
DOI:10.1002/prop.201000069. Existing key: `8HGA475I`; full text added during
this activation.

The paper treats spacetime as a continuous four-manifold times a finite
internal geometry and obtains a Higgs doublet in its spectral construction.
This is relevant precedent for keeping spacetime propagation and an internal
finite Dirac/Higgs sector distinct. Its Euclidean product geometry, finite-
algebra assumptions, and spectral-action parameter relations are not a causal-
set or null-edge derivation and must not be imported as one.
```

## Scoped paper hits

### 1. Scalar Field Green Functions on Causal Sets

Score: `0.787`
Zotero key: `4IHIDDGX`
arXiv: `1701.07212`
DOI: `10.1088/1361-6382/aa6bc7`
URL: http://arxiv.org/abs/1701.07212

Abstract:

We examine the validity and scope of Johnston's models for scalar field retarded Green functions on causal sets in 2 and 4 dimensions. As in the continuum, the massive Green function can be obtained from the massless one, and hence the key task in causal set theory is to first identify the massless Green function. We propose that the 2-d model provides a Green function for the massive scalar field on causal sets approximated by any topologically trivial 2 dimensional spacetime. We explicitly demonstrate that this is indeed the case in a Riemann normal neighbourhood. In 4-d the model can again be used to provide a Green function for the massive scalar field in a Riemann normal neighbourhood which we compare to Bunch and Parker's continuum Green function. We find that the same prescription can also be used for deSitter spacetime and the conformally flat patch of anti deSitter spacetime. Our analysis then allows us to suggest a generalisation of Johnston's model for the Green function for a causal set approximated by 3 dimensional flat spacetime.

### 2. Quantum Field Theory On Causal Sets

Score: `0.763`
Zotero key: `arxiv:2306.04800`
arXiv: `2306.04800`
URL: http://arxiv.org/abs/2306.04800

Abstract:

Overview of matter QFT on fixed causal-set backgrounds, including Green functions, Sorkin-Johnston two-point functions, and fermion/interacting-theory directions.

### 3. Scalar Field Theory on a Causal Set in Histories Form

Score: `0.751`
Zotero key: `9RF2ESFQ`
arXiv: `1107.0698`
DOI: `10.1088/1742-6596/306/1/012017`
URL: https://www.zotero.org/19894138/items/9RF2ESFQ

Abstract:

Recasts into histories-based form a quantum field theory for a free scalar field on a background causal set. The resulting decoherence-functional resembles that of the continuum theory. The counterpart of the d'Alembertian operator is nonlocal and is a generalized inverse of the discrete retarded Green function. Comments on the significance and suggests how to include interactions.

### 4. Is the cosmological constant a nonlocal quantum residue of discreteness of the causal set type?

Score: `0.741`
Zotero key: `G3FT8BXC`
arXiv: `0710.1675`
URL: http://arxiv.org/abs/0710.1675v1

### 5. Feynman Propagator for a Free Scalar Field on a Causal Set

Score: `0.739`
Zotero key: `T389PSF5`
arXiv: `0909.0944`
DOI: `10.1103/PhysRevLett.103.180401`
URL: https://www.zotero.org/19894138/items/T389PSF5

Abstract:

The Feynman propagator for a free bosonic scalar field on the discrete spacetime of a causal set is presented. The formalism includes scalar field operators and a vacuum state which are first steps towards scalar quantum field theory on a causal set. This work can be viewed as a novel regularisation of quantum field theory based on a Lorentz invariant discretisation of spacetime.
