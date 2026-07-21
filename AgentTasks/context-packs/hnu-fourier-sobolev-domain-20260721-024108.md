# Aristotle semantic context pack

Generated: 2026-07-21T02:41:17
Query: `Fourier transform self adjoint Dirac multiplication operator Sobolev graph domain position space differential operator`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AutonomousLab/work/NE-CONTINUUM/CODEX_CONT-FOURIER-001_API_MAP_2026-07-12.md` [F3: generator identification on a displayed core]

Score: `0.842`

```text
### F3: generator identification on a displayed core

Use Schwartz spinors as the first domain. With the explicit `2*pi` convention,
prove that Fourier conjugation identifies the spatial Dirac differential
operator with multiplication by `H(k,m)`. Then identify the evolution equation
first in Schwartz space or tempered distributions. A later theorem may close
the unbounded-operator/domain statement on the natural Sobolev domain.
```

### 2. `AutonomousLab/work/NE-CONTINUUM/CLAUDE_REVIEW_FourierDiracSchwartzCapstone_2026-07-13.md` [Verdict: ACCEPT]

Score: `0.826`

```text
## Verdict: ACCEPT

Exact Schwartz-domain Fourier symbol identity: the position-space free Dirac
differential expression transforms to multiplication by the momentum symbol `H`.
```

### 3. `AutonomousLab/work/NE-CONTINUUM/CLAUDE_REVIEW_PositionDiracSchwartzOperator_2026-07-13.md` [Narrowest claim]

Score: `0.825`

```text
## Narrowest claim

The free position-space Dirac differential expression, with Mathlib's `-I/(2*pi)`
normalization, is a continuous linear endomorphism of four-component Schwartz
space whose forward Fourier transform equals multiplication by the affine
momentum symbol `H(w)`. Fixed-continuum, Schwartz-domain; no differentiability of
the time group in the Schwartz topology, no closed-`L2` generator, no PDE, and no
changing-lattice limit is claimed.
```

### 4. `AutonomousLab/reviews/CLAUDE_REVIEW_FourierDiracSchwartzCapstone_2026-07-13.md` [Narrowest defensible claim]

Score: `0.824`

```text
## Narrowest defensible claim

For every Schwartz spinor `g : SchwartzMap FourierMomentum3 Spinor`, the
mathlib-Fourier-normalized position-space free `3+1` Dirac differential expression
`positionDirac m g = (-I/(2*pi))(a1 d_0 + a2 d_1 + a3 d_2)g + m beta g` satisfies
`𝓕(positionDirac m g)(w) = H(w_0,w_1,w_2,m) . 𝓕(g)(w)`, i.e. the Fourier
transform intertwines it exactly with multiplication by the repository free
momentum symbol `H`. This is a generator-symbol identity on the Schwartz domain;
it is NOT a closed-`L2` generator domain, Stone-generator, lattice/continuum
limit, or PDE-reconstruction theorem (all explicitly out of scope).
```

### 5. `AutonomousLab/reviews/CLAUDE_REVIEW_FourierDiracSchwartzCapstone_2026-07-13.md` [Verdict: ACCEPT]

Score: `0.823`

```text
## Verdict: ACCEPT

A correct, well-scoped Schwartz-domain generator-symbol theorem: the
`-I/(2*pi)`-normalized position-space free Dirac differential expression
Fourier-transforms exactly to multiplication by the repository momentum symbol
`H`. Convention, scope, topology, and (replayed) axiom footprint all check out.
Two non-blocking notes. No proof or statement change required.
```

### 6. `PhysicsSM/Draft/NullEdge/PositionDiracSchwartzOperator.lean`

Score: `0.822`

```text
import PhysicsSM.Draft.NullEdge.FourierDiracSchwartzCapstone
import PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGroup

/-!
# Position-space Dirac generator as a continuous Schwartz operator

Focused Aristotle target, continuum rung T2-A.  The landed Fourier/Dirac
capstone identifies a raw integrable differential expression with the affine
Dirac momentum symbol.  This successor packages that expression as an actual
continuous linear endomorphism of four-component Schwartz space and upgrades
the symbol theorem to the packaged operator.

This is still a fixed-continuum Schwartz-domain result.  It does not yet prove
that the exact time group is differentiable in the Schwartz topology, identify
the closed `L2` generator, or establish the changing-lattice limit.

Provenance: theorem statements and definitions were prepared locally; Aristotle
project `b064c004-2bd9-4c3a-8e86-064b65300def` supplied the proofs, which were
replayed under the repository's pinned Lean toolchain before integration.
-/
```

### 7. `AutonomousLab/reviews/CLAUDE_REVIEW_FourierDiracSchwartzCapstone_2026-07-16.md` [Verdict: APPROVE (draft-trust integration confirmed)]

Score: `0.817`

```text
## Verdict: APPROVE (draft-trust integration confirmed)

`PhysicsSM/Draft/NullEdge/FourierDiracSchwartzCapstone.lean` states and proves
the intended mathematics:

- **Statement identity.** `fourier_positionDirac`: for every Schwartz spinor
  `g` and mass `m`, the Fourier transform of
  `positionDirac m g = (-I/(2*pi)) * (alpha . grad g) + m * beta * g`
  equals pointwise multiplication by the repository's canonical free symbol
  `H kx ky kz m = kx*alpha1 + ky*alpha2 + kz*alpha3 + m*beta`
  (checked against BOTH definition sites: `Compact3Plus1DiracRate.H` and
  `Clifford3Plus1WalkSymbol.H`; identical formula, same alpha/beta constants -
  standard Dirac-basis matrices, alpha_j the anti-diagonal/off-diagonal Dirac
  alphas, beta = diag(1,1,-1,-1)).
- **Normalization honesty.** Mathlib's forward transform uses
  `exp(-2*pi*I*<x,w>)`, so the derivative rule contributes `2*pi*I*w_j`; the
  displayed `-I/(2*pi)` prefactor makes the composite coefficient exactly
  `w_j`. The 2*pi convention is explicit in the definition and docstring, as
  the work item requires ("preserve Mathlib's explicit 2*pi convention").
- **Domain honesty.** Everything is on `SchwartzMap FourierMomentum3 Spinor`;
  the docstring states it is a generator-symbol theorem, NOT a closed L2
  generator-domain claim, NOT changing-lattice convergence, NOT a completed
  PDE reconstruction. This matches the item boundary ("open F3 only with a
  displayed Sobolev or Schwartz domain; do not rename unitary L2 transport as
  a PDE theorem").
- **Supporting lemmas sound.** `coordinateDerivative` is the honest
  directional `fderiv` at `EuclideanSpace.single j 1`;
  `fourier_matrixAction` commutes a fixed bounded matrix action through the
  transform with an explicit integrability argument;
  `positionDirac_integrable
```

### 8. `AutonomousLab/work/NE-CONTINUUM/CLAUDE_REVIEW_FourierDiracSchwartzCapstone_2026-07-13.md` [Narrowest claim]

Score: `0.808`

```text
## Narrowest claim

For every Schwartz spinor `g`, the normalized position-space free Dirac
differential expression `(-I/(2 pi)) sum_j alpha_j d_j g + m beta g` has forward
Fourier transform equal to `matrixAction(H(w)) (𝓕 g w)`, i.e. multiplication by
the exact free momentum symbol `H`. This is an exact Schwartz-domain Fourier
symbol identity for the spatial Dirac expression; it is not a time-evolution PDE,
a closed-`L2` generator-domain statement, or a lattice/continuum-limit theorem.
```

## Scoped paper hits

### 1. Laplace and Dirac Operators on Graphs

Score: `0.778`
Zotero key: `WW6TKVH8`
arXiv: `2203.02782`
URL: https://www.zotero.org/19894138/items/WW6TKVH8

Abstract:

Discrete versions of the Laplace and Dirac operators studied in the context of combinatorial models of statistical mechanics and quantum field theory. Introduces several variations of the Laplace and Dirac operators on graphs and investigates graph-theoretic versions of the Schroedinger and Dirac equation, with a combinatorial interpretation for solutions, and proves gluing identities for the Dirac operator on lattice graphs as well as for graph Clifford algebras.

### 2. Spectral Theory of Self-adjoint Finitely Cyclic Operators and Introduction to Matrix Measure $L^2$-spaces

Score: `0.766`
Zotero key: `F5KRJPCA`
arXiv: `2212.13953`
URL: http://arxiv.org/abs/2212.13953

Abstract:

We study finitely cyclic self-adjoint operators in a Hilbert space, i.e. self-adjoint operators that posses such a finite subset in the domain that the orbits of all its elements with respect to the operator are linearly dense in the space. One of the main goals here is to obtain the representation theorem for such operators in a form analogous to the one well-known in the cyclic self-adjoint operators case. To do this, we present here a detailed introduction to matrix measures, to the matrix measure $L^2$ spaces, and to the multiplication by scalar functions operators in such spaces. This allows us to formulate and prove in all the details the less known representation result, saying that the finitely cyclic self-adjoint operator is unitary equivalent to the multiplication by the identity function on $\mathbb{R}$ in the appropriate matrix measure $L^2$ space. We study also some detailed spectral problems for finitely cyclic self-adjoint operators, like the absolute continuity.

### 3. First order approach and index theorems for discrete and metric graphs

Score: `0.756`
Zotero key: `2DEG7MT2`
arXiv: `0708.3707`
URL: https://www.zotero.org/19894138/items/2DEG7MT2

Abstract:

Introduces first order (supersymmetric) Dirac operators on discrete and metric (quantum) graphs. To cover all self-adjoint boundary conditions for the metric graph Laplacian, develops discrete graph operators on a decorated graph, the decoration at each degree-d vertex being a subspace of C^d, generalising the scalar vertex value. Develops exterior derivative, differential forms, Dirac and Laplace operators in the discrete and metric case using a supersymmetric framework, and computes the supersymmetric index of the discrete Dirac operator generalising the Euler-characteristic index formula; the metric Dirac index agrees with the discrete one.

### 4. Equivalence of lattice operators and graph matrices

Score: `0.741`
Zotero key: `Z2DPSX6K`
arXiv: `2311.11320`
URL: https://arxiv.org/abs/2311.11320

Abstract:

We explore the relationship between lattice field theory and graph theory, placing special emphasis on the interplay between Dirac and scalar lattice operators and matrices within spectral graph theory. The paper introduces an anti-symmetrized adjacency matrix for cycle digraphs and directed paths, and relates graph Laplacians, Wilson terms, and lattice Dirac operators.

### 5. Locality properties of Neuberger's lattice Dirac operator

Score: `0.738`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010
