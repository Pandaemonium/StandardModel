# Aristotle semantic context pack

Generated: 2026-07-06T06:19:34
Query: `completely monotone slice projector reflection positivity half operator OS form Faizal Shabir 2606.19362`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [The queue]

Score: `0.784`

```text
### The queue

- **Q1 (Wilson cut factorization; in-repo agent + possible Aristotle
  finisher; medium).** Instantiate `ReflectionPositivityKernel` for the
  Wilson ensemble on a link-reflection lattice: produce the mirror
  coordinates `(A, C, A)` from the T3 `Reflection` structure
  (`ReflectionCore` link classification + `WilsonReflectionCompatibility`),
  show the no-cut-plaquette part of the weight is factorized
  (`cutKernel_posSemidef_of_factorized`), and reduce the cut-plaquette
  couplings to the mixture corollary via a spectral decomposition of the
  one-plaquette kernel: `wilsonKernel_posSemidef` +
  `hadamard_posSemidef` (Schur products) give the PSD input; any PSD
  kernel is a nonnegative mixture of rank-one squares. Deliverable:
  `wilson_reflectionForm_nonneg` on a concrete reflection lattice
  (the `ReflectionCutExample` two-layer model is the minimal instance).
  This CLOSES RP-LINK at the finite level.
- **Q2 (transfer Hilbert space from RP; medium-hard; design first).**
  From `IsReflectionPositive W`: the sesquilinear form
  `<f, g> := reflectionForm`-polarized, quotient by the null space,
  finite-dimensional inner-product space, and the transfer operator as a
  positive self-adjoint operator on it. Mathlib has the quadratic-form
  and quotient machinery; the design note should fix the polarization
  convention first. Kill condition (adopted): if the null-edge/Wilson
  weight cannot be given a PSD cut kernel (Q1 fails), the transfer route
  is blocked and this item is renamed, not fudged.
- **Q3 (D12 sector-correct transfer matrix; design theorem; medium).**
  Adopted target, superseding any naive Gauss-sector gap statement (the
  oracle's 2x2-torus discovery stands): define the flux-sector
  decomposition of the Gauss-invariant space, prove the tr
```

### 2. `AgentTasks/null-edge-p2-branch-orientation-aristotle-2026-06-24.md` [Scientific role]

Score: `0.776`

```text
## Scientific role

This task advances the `P2-R` finite operator lane.

The current branch-reflection modules show that `R = H/E` reconstructs the
two-level chiral Hamiltonian, squares to the identity on shell, and preserves
screen second moments under repeated local application. The next small
certificate is that the operator is an actual real reflection: it has trace
zero, determinant `-1` on shell, and is therefore not the identity.

This matters because it separates the finite branch operator from a generic
norm-preserving map. It is orientation-reversing finite `2 x 2` algebra only,
not a chirality, zitterbewegung, Pluecker-ray, shift, walk, or continuum claim.
```

### 3. `AgentTasks/model-calls/gemini/2026-06-24-round-019-constructive-after-four-trace.md` [Response]

Score: `0.774`

```text
## Response

Based on your current status, the highest-value next step is to solidify the physical meaning of the new four-reflection trace formula before expanding into new areas. A non-constancy proof is the most direct way to do this.  *   **Theorem Target:** For the finite real 2x2 branch-reflection API, there exists a set of four reflections $(R_1, R_2, R_3, R_4)$ and a non-trivial evolution path such that the trace, Tr$(R_4 R_3 R_2 R_1)$, is not constant. The variation of this trace can be explicitly correlated with a change in the Plücker coordinates of the associated observer channel.  *   **Physics Value:** This would provide the first concrete witness that the four-reflection scalar is a dynamic observable, not a topological invariant. Successfully linking its variation to observer-channel geometry would establish a direct bridge between the reflection-based algebraic structure and the P1-F observer normalization priority, providing a candidate mechanism for "readout".  *   **Failure/Demotion Mode:** If all accessible four-reflection traces prove to be constant, it would imply a deeper, unexpected topological constraint or symmetry in the system. The P2 work would be demoted in priority. The project would immediately pivot to the next simplest candidate for a dynamic scalar: investigating six-reflection traces or focusing exclusively on P1/P4/P7 chirality dynamics as the primary source of observable evolution.  *   **Literature/Source Check:** Review the formalism of reflection operators and their invariants in the context of Clifford (Geometric) Algebras. Specifically, check how compositions of reflections are used to construct rotors and other transformations, and how their traces are interpreted. A key source for this would be Pertti Lounesto's "Clifford Al
```

### 4. `AgentTasks/null-edge-constrained-integrator-loop-ledger-2026-06-24.md` [Scientific value]

Score: `0.774`

```text
### Scientific value

The branch reflection now has a finite P9-facing observable meaning: applied
pointwise to screen-cell amplitudes, it preserves the real fiber norm and hence
the screen second moment. The screen-cardinality variance bound transfers to
the reflected source. This is the first direct bridge between the P2 reflection
operator and the P9 screen/noise observable, without adding shift or continuum
assumptions.
```

### 5. `PhysicsSM/Draft/SpinCoherentProjectorAristotle.lean` [spinProjector_conjTranspose]

Score: `0.772`

```text
theorem spinProjector_conjTranspose (a : Fin 3 → ℝ) :
    (spinProjector a)ᴴ = spinProjector a := by
  -- The conjugate transpose of the projector is the projector itself.
  simp [spinProjector, pauliVec_conjTranspose]

/-- The coherent-state projector has trace `1` (no norm hypothesis). -/
```

### 6. `AgentTasks/null-edge-constrained-integrator-loop-postmortem-2026-06-24.md` [2. P2 branch-reflection operator package]

Score: `0.772`

```text
### 2. P2 branch-reflection operator package

The run also integrated or confirmed several adjacent P2 operator facts:

```lean
PhysicsSM.Draft.NullEdgeP2BranchResolution
PhysicsSM.Draft.NullEdgeP2BranchReflection
PhysicsSM.Draft.NullEdgeP2BranchOrientation
PhysicsSM.Draft.NullEdgeP2PositiveBranchProjector
PhysicsSM.Draft.NullEdgeP2ChiralProjectorCoherence
PhysicsSM.Draft.NullEdgeP2ReflectionProductDetParity
```

Together these make the finite branch reflection a much cleaner object:

- it reconstructs the two-level chiral Hamiltonian after multiplying by energy;
- it acts as the difference of positive and negative branch projectors;
- it is traceless;
- on shell, it is an involution;
- on shell, it has determinant `-1`;
- determinant products collapse to parity;
- two-sheet/projector and chiral-coherence readouts are now better separated
  from trace and determinant claims.

This is not yet a super-Dirac theorem, but it is a useful local algebra package
for P2-R and P4-R.
```

### 7. `AgentTasks/null-edge-constrained-integrator-loop-ledger-2026-06-24.md` [Scientific value]

Score: `0.769`

```text
### Scientific value

The P2 branch reflection is now certified as orientation-reversing finite
algebra: trace zero, determinant `-1` on shell, and non-identity. This guards
against over-reading the operator as an identity-like norm preservation fact
while still avoiding chirality/zitterbewegung/walk semantics.
```

### 8. `AgentTasks/null-edge-p2-p9-reflection-iteration-variance-aristotle-2026-06-24.md` [Scientific role]

Score: `0.766`

```text
## Scientific role

This task advances the `P2-R` / `P4-R` / `P7-R` operator bridge and the `P9-F`
finite source-visibility/noise lane.

The previous integrated bridge proves that one on-shell branch reflection
`R = H / E` preserves the real two-component fiber norm, the P9 screen second
moment, and the screen-cardinality variance bound when applied pointwise across
screen cells. This task upgrades that one-step theorem to finite repeated local
reflection steps:

```text
one reflection preserves the screen observable
-> any finite iterate preserves the screen observable
-> the screen variance bound is stable under any finite iterate.
```

This is a discrete stability theorem for the already-defined reflection
observable. It is not a null-step walk, shift operator, boundary condition,
continuum limit, or gravitational response law.
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.768`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. Reflection Positivity---A Representation Theoretic Perspective

Score: `0.754`
Zotero key: `1802.09037`
arXiv: `1802.09037`
URL: http://arxiv.org/abs/1802.09037

Abstract:

Refection Positivity is a central theme at the crossroads of Lie group representations, euclidean and abstract harmonic analysis, constructive quantum field theory, and stochastic processes. This book provides the first presentation of the representation theoretic aspects of Refection Positivity and discusses its connections to those different fields on a level suitable for doctoral students and researchers in related fields.

### 3. Characterization of Reflection Positivity: Majoranas and Spins

Score: `0.746`
Zotero key: `1506.04197`
arXiv: `1506.04197`
DOI: `10.1007/s00220-015-2545-z`
URL: http://arxiv.org/abs/1506.04197

Abstract:

We study linear functionals on a Clifford algebra (algebra of Ma- joranas) equipped with a reflection automorphism. For Hamiltonians that are functions of Majoranas or of spins, we find necessary and sufficient conditions on the coupling constants for reflection positivity to hold. One can easily check these conditions in concrete models. We illustrate this by discussing a number of spin systems with nearest-neighbor and long-range interactions.

### 4. An Analysis of Completely-Positive Trace-Preserving Maps on 2x2 Matrices

Score: `0.723`
Zotero key: `PKMDHXHA`
arXiv: `quant-ph/0101003`
URL: http://arxiv.org/abs/quant-ph/0101003

Abstract:

We give a useful new characterization of the set of all completely positive, trace-preserving (i.e., stochastic) maps from 2x2 matrices to 2x2 matrices. These conditions allow one to easily check any trace-preserving map for complete positivity. We also determine explicitly all extreme points of this set, and give a useful parameterization after reduction to a certain canonical form.

### 5. Tri-partitions and Bases of an Ordered Complex

Score: `0.720`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x
