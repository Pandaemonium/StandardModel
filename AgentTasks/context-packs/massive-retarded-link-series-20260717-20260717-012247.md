# Aristotle semantic context pack

Generated: 2026-07-17T01:23:11
Query: `finite massive retarded causal link matrix geometric series nilpotent kernel multi-edge path propagator`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md` [Mathematical frameworks and mappings]

Score: `0.800`

```text
## Mathematical frameworks and mappings

A natural formal starting point is an oriented graph \(G=(V,E)\), where \(V\) is a set of localized interaction events and each edge \(e:u\to v\) represents an elementary allowed propagation step from \(u\) to \(v\). In a continuum embedding, the null-edge postulate would read \((x_v-x_u)^2=0\) with \(x_v^0>x_u^0\). In a pregeometric version, one would instead mark certain causal relations as primitive “lightlike generators” and require every elementary propagation edge to belong to that class. The corresponding quantum theory would not assign a single path to a particle; it would sum amplitudes over allowed null-linked histories, much as the checkerboard model and histories-based causal-set formalisms already do in simpler settings. citeturn22view0turn24view0

A minimalist amplitude prescription is
\[
\mathcal A_{fi}
=
\sum_{H\in\mathcal H(i\to f)}
\Biggl(
\prod_{e\in H} K_e
\Biggr)
\Biggl(
\prod_{v\in H} \Gamma_v
\Biggr),
\]
where \(H\) runs over admissible null-edge histories, \(K_e\) is an edge kernel, and \(\Gamma_v\) is a vertex amplitude. This is schematic, but it matches the logic of both path-integral and S-matrix constructions: one computes transition amplitudes from boundary data rather than narrating a classical trajectory between measurements. In standard QFT language, LSZ tells us that the S-matrix can be obtained from time-ordered Green functions; in direct-action QED, Davies showed that an endpoint-centered S-matrix perturbation theory can be mathematically equivalent to ordinary QED to all orders. Those results make an event-graph formulation conceptually respectable, provided it can eventually reproduce the same asymptotic observables. citeturn33academia23turn23search2

The checkerboard model is the clea
```

### 2. `AgentTasks/aristotle-standalone/claude-goal3-exactRG-20260709/STRATEGY_PROMPT.md` [Context (you are blind to the wider repo; seeds are in `seeds/`)]

Score: `0.783`

```text
## Context (you are blind to the wider repo; seeds are in `seeds/`)

A finite "null-edge" program models a 1D chain carrier whose sites carry two
couplings: an **aperture** `lam` (on-site mass-like term) and a **closure**
`kap` (nearest-neighbour edge term). The claim to convert from oracle-grade to
kernel-grade: **Lorentz/relativistic structure is not an input; it emerges as
the fixed point of an EXACT rational RG (real-space decimation), with no limits
and no floating point.** Everything below is finite rational/complex matrix
algebra.

The seed files (clean-room port them; Mathlib only, do NOT assume they are
importable — copy the definitions you need into `RequestProject/Main.lean`):

- `seeds/RGSchurMassWitness.lean` (namespace `...RGSchurMass`): the decimation
  primitive. `nullL`, `nullN` are the `2x2` null edges (`nullL^2=0`, `nullN^2=0`,
  `nullL*nullN + nullN*nullL = 1`). `chain_schurComplement_eq` and
  `effective_offdiag_eq_neg_edgeProd` give the two-site Schur complement (integrate
  out the middle site). `collinear_schurComplement_eq_zero (t)` is the CURRENT
  **one-coupling** collinear negative control (a collinear pair decimates to zero
  effective edge).
- `seeds/ContinuumLimit.lean` (namespace `...ContinuumLimit`): the Dirac quantum
  walk `Ustep k θ = Ushift k * Ucoin θ` on `Fin 2`, with `dirac_mass_shell` the
  pinned dispersion and `Ustep_hasDerivAt_generator` its generator.
- `seeds/SubluminalBound.lean`: the group-velocity bound `v_g <= 1`, equality iff
  massless, from the pinned dispersion `cos ω = cos k cos θ`.
- `seeds/MassPhaseDiagram.lean`: the `3x3` mass block `B(lam,kap)` with spectrum
  `{lam-kap, lam, lam+kap}`; the massless/critical line is `|kap| = |lam|`.
- `seeds/FiniteRGFlow.lean`: abstract RG-orbit machinery (`orbit`, `StepPreserve
```

### 3. `AgentTasks/overnight-allmass-run-2026-07-09/harvest/goal3/claude-goal3-exactRG-20260709_aristotle/STRATEGY_PROMPT.md` [Context (you are blind to the wider repo; seeds are in `seeds/`)]

Score: `0.783`

```text
## Context (you are blind to the wider repo; seeds are in `seeds/`)

A finite "null-edge" program models a 1D chain carrier whose sites carry two
couplings: an **aperture** `lam` (on-site mass-like term) and a **closure**
`kap` (nearest-neighbour edge term). The claim to convert from oracle-grade to
kernel-grade: **Lorentz/relativistic structure is not an input; it emerges as
the fixed point of an EXACT rational RG (real-space decimation), with no limits
and no floating point.** Everything below is finite rational/complex matrix
algebra.

The seed files (clean-room port them; Mathlib only, do NOT assume they are
importable — copy the definitions you need into `RequestProject/Main.lean`):

- `seeds/RGSchurMassWitness.lean` (namespace `...RGSchurMass`): the decimation
  primitive. `nullL`, `nullN` are the `2x2` null edges (`nullL^2=0`, `nullN^2=0`,
  `nullL*nullN + nullN*nullL = 1`). `chain_schurComplement_eq` and
  `effective_offdiag_eq_neg_edgeProd` give the two-site Schur complement (integrate
  out the middle site). `collinear_schurComplement_eq_zero (t)` is the CURRENT
  **one-coupling** collinear negative control (a collinear pair decimates to zero
  effective edge).
- `seeds/ContinuumLimit.lean` (namespace `...ContinuumLimit`): the Dirac quantum
  walk `Ustep k θ = Ushift k * Ucoin θ` on `Fin 2`, with `dirac_mass_shell` the
  pinned dispersion and `Ustep_hasDerivAt_generator` its generator.
- `seeds/SubluminalBound.lean`: the group-velocity bound `v_g <= 1`, equality iff
  massless, from the pinned dispersion `cos ω = cos k cos θ`.
- `seeds/MassPhaseDiagram.lean`: the `3x3` mass block `B(lam,kap)` with spectrum
  `{lam-kap, lam, lam+kap}`; the massless/critical line is `|kap| = |lam|`.
- `seeds/FiniteRGFlow.lean`: abstract RG-orbit machinery (`orbit`, `StepPreserve
```

### 4. `PhysicsSM/Draft/NullEdge/Carrier/RGSchurMassWitness.lean` [mid_effective_nilpotent_iff]

Score: `0.776`

```text
theorem mid_effective_nilpotent_iff (Minv : Matrix (Fin 2) (Fin 2) ℂ) :
    IsNilpotent (nullL * Minv * nullN) ↔ Minv 1 1 = 0 := by
  constructor
  · intro hnil
    by_contra hne
    exact mid_effective_not_nilpotent Minv hne hnil
  · intro h0
    rw [nullL_mul_mid_mul_nullN, h0, zero_smul]
    exact ⟨1, by simp⟩

end PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass
```

### 5. `AgentTasks/context-packs/finite-strict-past-nilpotence-20260716-20260716-144958.md` [Task]

Score: `0.771`

```text
## Task

Fill the four proof holes in `NullEdgeP9RetardedNilpotentReach/Core.lean`
without changing definitions or theorem statements.

This is a finite retarded-support scaffold for P9. Causal-set response
operators can be retarded and nonlocal; on a finite acyclic diamond, however, a
support relation that strictly decreases a rank should have a finite propagation
horizon. The target is the corresponding finite theorem: beyond the rank
height, exact reach is empty and the iterated response kernel vanishes.
```
```

### 6. `AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md` [Blocker 4: non-ultralocal control is not yet formalized]

Score: `0.771`

```text
### Blocker 4: non-ultralocal control is not yet formalized

We are open to nonlocality, but not uncontrolled nonlocality.

The preferred direction is a path-sum or combinatorial-decay theorem:

- finite-volume path sums first,
- then convergence or controlled limit,
- with exponential decay allowed as a sufficient bound but not assumed as the core mechanism.

Question for Pro:

What is the best mathematical formalism for a null-edge path-sum release: Green's function/resolvent, Schur complement, random-walk expansion, transfer matrix, overlap/sign-function, or something else?
```

### 7. `PhysicsSM/Draft/NullEdge/Carrier/RGSchurMassWitness.lean` [mid_effective_sq]

Score: `0.770`

```text
theorem mid_effective_sq (Minv : Matrix (Fin 2) (Fin 2) ℂ) :
    (nullL * Minv * nullN) * (nullL * Minv * nullN)
      = (Minv 1 1) • (nullL * Minv * nullN) := by
  rw [nullL_mul_mid_mul_nullN, smul_mul_smul_comm, nullL_mul_nullN_idem,
    smul_smul]

/-- **The general effective edge is non-nilpotent iff the propagator element
is nonzero.** So decimation through a general hidden block generates a
non-null (mass-like) effective term exactly when the null directions are
propagator-coupled - and preserves nullity exactly when that element
vanishes (the general collinear/decoupled control). -/
```

### 8. `AgentTasks/finite-strict-past-nilpotence-aristotle-2026-07-16.md` [Objective]

Score: `0.770`

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

## Scoped paper hits

### 1. Particle propagators on discrete spacetime

Score: `0.760`
Zotero key: `3FEVHQJA`
arXiv: `0806.3083`
DOI: `10.1088/0264-9381/25/20/202001`
URL: http://arxiv.org/abs/0806.3083

Abstract:

A quantum mechanical description of particle propagation on the discrete spacetime of a causal set is presented. The model involves a discrete path integral in which trajectories within the causal set are summed over to obtain a particle propagator. The sum-over-trajectories is achieved by a matrix geometric series. For causal sets generated by sprinkling points into 1+1 and 3+1 dimensional Minkowski spacetime the propagator calculated on the causal set is shown to agree, in a suitable sense, with the causal retarded propagator for the Klein-Gordon equation. The particle propagator described here is a step towards quantum field theory on causal set spacetime.

### 2. Correction terms for propagators and d'Alembertians due to spacetime discreteness

Score: `0.738`
Zotero key: `arxiv:1411.2614`
arXiv: `1411.2614`
DOI: `10.1088/0264-9381/32/19/195020`
URL: http://arxiv.org/abs/1411.2614

Abstract:

Finite-sprinkling correction terms for causal-set retarded propagators and d'Alembertian operators compared with continuum limits.

### 3. Quantum Fields on Causal Sets

Score: `0.721`
Zotero key: `ED8DKNPU`
arXiv: `1010.5514`
URL: https://www.zotero.org/19894138/items/ED8DKNPU

Abstract:

Causal set theory provides a model of discrete spacetime in which spacetime events are represented by elements of a causal set---a locally finite, partially ordered set in which the partial order represents the causal relationships between events. The work presented here describes a model for matter on a causal set, specifically a theory of quantum scalar fields on a causal set spacetime background. The work starts with a discrete path integral model for particles on a causal set. Here quantum mechanical amplitudes are assigned to trajectories within the causal set. By summing these over all trajectories between two spacetime events we obtain a causal set particle propagator. With a suitable choice of amplitudes this is shown to agree (in an appropriate sense) with the retarded propagator for the Klein-Gordon equation in Minkowski spacetime. This causal set propagator is then used to define a causal set analogue of the Pauli-Jordan function that appears in continuum quantum field theories. A quantum scalar field is then modelled by an algebra of operators which satisfy three simple conditions (including a bosonic commutation rule). Defining time-ordering through a linear extension of the causal set these field operators are used to define a causal set Feynman propagator. Evidence is presented which shows agreement (in a suitable sense) between the causal set Feynman propagator and the continuum Feynman propagator for the Klein-Gordon equation in Minkowski spacetime. The Feynman propagator is obtained using the eigendecomposition of the Pauli-Jordan function, a method which can also be applied in continuum-based theories. The free field theory is extended to include interacting scalar fields. This leads to a suggestion for a non-perturbative S-matrix on a causal set. Models for continuum-based phenomenology and spin-half particles on a causal set are also presented.

### 4. Equivalence of lattice operators and graph matrices

Score: `0.720`
Zotero key: `Z2DPSX6K`
arXiv: `2311.11320`
URL: https://arxiv.org/abs/2311.11320

Abstract:

We explore the relationship between lattice field theory and graph theory, placing special emphasis on the interplay between Dirac and scalar lattice operators and matrices within spectral graph theory. The paper introduces an anti-symmetrized adjacency matrix for cycle digraphs and directed paths, and relates graph Laplacians, Wilson terms, and lattice Dirac operators.

### 5. Feynman Propagator for a Free Scalar Field on a Causal Set

Score: `0.719`
Zotero key: `T389PSF5`
arXiv: `0909.0944`
DOI: `10.1103/PhysRevLett.103.180401`
URL: https://www.zotero.org/19894138/items/T389PSF5

Abstract:

The Feynman propagator for a free bosonic scalar field on the discrete spacetime of a causal set is presented. The formalism includes scalar field operators and a vacuum state which are first steps towards scalar quantum field theory on a causal set. This work can be viewed as a novel regularisation of quantum field theory based on a Lorentz invariant discretisation of spacetime.

### 6. Renormalizing Yukawa interactions in the standard model with matrices and noncommutative geometry

Score: `0.719`
Zotero key: `SHPRQMGH`
arXiv: `1906.02297`
URL: https://arxiv.org/abs/1906.02297

Abstract:

Shows that gauge-independent terms in the one-loop and multi-loop beta-functions of the Standard Model can be computed from Wetterich functional renormalization of a matrix model associated with the finite spectral triple underlying the spectral-action computation of the Standard Model Lagrangian. Provides a matrix-Yukawa duality for beta-functions.

### 7. Spin on a 4D Feynman Checkerboard

Score: `0.716`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 8. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.714`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`
