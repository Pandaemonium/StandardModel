# Aristotle semantic context pack

Generated: 2026-07-09T15:08:04
Query: `finite Hermitian Hamiltonian Cayley transform Crank Nicolson unitary discrete action carrier mass block exact time evolution`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/krasnov-qubit-hermitian-unitary-aristotle-2026-05-29.md` [Aristotle task: Krasnov diagonal complex structure is unitary]

Score: `0.792`

```text
# Aristotle task: Krasnov diagonal complex structure is unitary

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `1b237619-fc1e-45a9-be78-f60c06229cda`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-round-20260529-project`
**Output**: `AgentTasks/aristotle-output/krasnov-qubit-hermitian-unitary-20260529`
**Type**: Krasnov octonionic qubit / Hermitian form and unitary diagonal action

**Integrated**: 2026-05-30
**Integrated files**:
- `PhysicsSM/Spinor/KrasnovQubitHermitian.lean`
- `PhysicsSM.lean`

**Review note**: Aristotle's trusted theorem file was imported, locally
reviewed, provenance-cleaned, and checked with the pinned Lean toolchain.
```

### 2. `AgentTasks/model-calls/gemini/2026-06-24-round-009-constructive-next-job.md` [Response]

Score: `0.772`

```text
## Response

``text
**Theorem Target:** The unitary null-step evolution operator, `U_s = exp(-i s H)`, where `s` is a proper-time-like parameter, decomposes into projection-weighted phase rotations: `U_s = exp(-i s E) P+ + exp(+i s E) P-`.

**Possible Failure Mode:** The assumption that `s` is a simple scalar proper-time might be incorrect. If the underlying causal graph requires a more complex, non-local, or state-dependent step definition, `exp(-i s H)` may not be the correct unitary propagator for a single null-step. This would force a re-evaluation of the link between the continuous-parameter Hamiltonian `H` and the discrete graph dynamics.

**Literature/Source Check:** Review the "checkerboard" model (1+1D Dirac equation) propagator in R. P. Feynman's "Quantum Electrodynamics and the Path Integral". This provides the canonical derivation for a discrete, null-step quantum walk propagator, serving as the benchmark for the proposed `U_s` and its relationship to `H`.

``
```

### 3. `AgentTasks/model-calls/claude/2026-06-24-round-009-adversarial-next-job.md` [Candidate B: unitary evolution U_s = exp(−isH), spectral decomposition]

Score: `0.764`

```text
## Candidate B: unitary evolution U_s = exp(−isH), spectral decomposition
```

### 4. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [internalSegment]

Score: `0.761`

```text
def internalSegment {d : Type*} [Fintype d] [DecidableEq d] (Δs : ℝ)
    (M : Matrix d d ℂ) : Matrix d d ℂ :=
  NormedSpace.exp (-(Complex.I : ℂ) • (Complex.ofReal Δs • M))

/-- HOL-002: Unitary one-step holonomy for Hermitian generator. -/
```

### 5. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [internalHolonomyPathU]

Score: `0.753`

```text
def internalHolonomyPathU {N : ℕ} {d : Type*} [Fintype d] [DecidableEq d]
    (Δs : Fin (N + 1) → ℝ) (M : Fin (N + 1) → Matrix d d ℂ)
    (hH : ∀ i : Fin (N + 1), (M i).IsHermitian) : Matrix.unitaryGroup d ℂ :=
  ⟨internalHolonomyPath Δs M, internalHolonomy_unitary_of_hermitian Δs M hH⟩

/-- The packaged unitary holonomy has the expected underlying matrix. -/
```

### 6. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [88. Lean update: Hfree real-space Hermitian seed closed]

Score: `0.751`

```text
## 88. Lean update: Hfree real-space Hermitian seed closed

Date: 2026-06-29

`TetraFreeOperator.lean` now defines the real-space Hermitian overlap-seed kernel

```text
Hfree(gamma5, D, a, r, rho) = gamma5 * Kfree(D, a, r, rho)
```

as pointwise finite spin-matrix action on the checked real-space `Kfree` operator.

The module also proves `fourierUnitary_Hfree_trig`: under the normalized finite Fourier transform, `Hfree` is exactly the momentum-space symbol `TetraScalarWilsonSymbol.H gamma5 D a r rho (kOfMom m)` acting on the transformed field.

This closes the finite/free Kfree/Hfree assembly item locally.  The remaining work is no longer to identify the scalar overlap seed in real space; it is to build the physical C1 layer on top of that seed: matrix-valued branch retention, anomaly matching, positivity/Krein audit, and locality/quasi-locality certificates.
```

### 7. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [79. Equal-side character definitions]

Score: `0.750`

```text
s note is superseded by Section 81 for raw Parseval. Full
free-symbol diagonalization remains a later target. The next concrete tasks
from this stage were:

1. Define the unitary Fourier transform using `fourierNormFactor`.
2. Prove Parseval/unitarity from the additive-character orthogonality theorem.
3. Prove the inverse-shift eigenvalue theorem.
4. Diagonalize the centered derivative and Wilson terms separately.
5. Use those facts to instantiate `UnitaryBlockDiagonalization`.
```

### 8. `AgentTasks/baez-g2-c3-gut-block-bridge-aristotle-2026-05-31.md` [Target declarations]

Score: `0.747`

```text
## Target declarations

Define a block embedding with trivial weak block:

```lean
noncomputable def c3MatrixAsGUTBlock
    (M : Matrix (Fin 3) (Fin 3) Complex) :
    Matrix (Fin 2 Sum Fin 3) (Fin 2 Sum Fin 3) Complex :=
  Matrix.fromBlocks (1 : Matrix (Fin 2) (Fin 2) Complex) 0 0 M
```

Use the actual Lean spelling for the sum index if needed:
`Fin 2 ⊕ Fin 3`.

Prove:

```lean
theorem matrixActsUnitaryOnC3_gutBlock_patiSalam
    {M : Matrix (Fin 3) (Fin 3) Complex}
    (hM : MatrixActsUnitaryOnC3 M) :
    PhysicsSM.Gauge.GUTSquare.PatiSalamPredicate
      (c3MatrixAsGUTBlock M) := ...
```

and, with determinant-one as an explicit hypothesis:

```lean
theorem matrixActsUnitaryOnC3_gutBlock_smBlock_of_det
    {M : Matrix (Fin 3) (Fin 3) Complex}
    (hM : MatrixActsUnitaryOnC3 M)
    (hdet : M.det = 1) :
    PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
      (c3MatrixAsGUTBlock M) := ...
```

Finally specialize to the octonion-side action matrix:

```lean
theorem preservesComplexTripleHermitian_gutBlock_patiSalam
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g) :
    PhysicsSM.Gauge.GUTSquare.PatiSalamPredicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) := ...
```

Useful existing theorem:

- `PreservesComplexTripleHermitian.onComplexVecMatrix_gutSquare_isUnitary`
- `MatrixActsUnitaryOnC3.gutSquare_isUnitary`
- `GUTSquare.isUnitary_fromBlocks`
```

## Scoped paper hits

### 1. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.748`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 2. Correction terms for propagators and d'Alembertians due to spacetime discreteness

Score: `0.742`
Zotero key: `arxiv:1411.2614`
arXiv: `1411.2614`
DOI: `10.1088/0264-9381/32/19/195020`
URL: http://arxiv.org/abs/1411.2614

Abstract:

Finite-sprinkling correction terms for causal-set retarded propagators and d'Alembertian operators compared with continuum limits.

### 3. A discrete relativistic spacetime formalism for 1 + 1-QED with continuum limits

Score: `0.734`
Zotero key: `CZTK2MRM`
arXiv: `2103.13150`
DOI: `10.1038/s41598-022-06241-4`
URL: https://www.zotero.org/19894138/items/CZTK2MRM

Abstract:

We build a quantum cellular automaton (QCA) which coincides with $1+1$ QED on its known continuum limits. It consists in a circuit of unitary gates driving the evolution of particles on a one dimensional lattice, and having them interact with the gauge field on the links. The particles are massive fermions, and the evolution is exactly U(1) gauge-invariant. We show that, in the continuous-time discrete-space limit, the QCA converges to the Kogut–Susskind staggered version of $1+1$ QED. We also show that, in the continuous spacetime limit and in the free one particle sector, it converges to the Dirac equation—a strong indication that the model remains accurate in the relativistic regime.

### 4. Spin on a 4D Feynman Checkerboard

Score: `0.731`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 5. Path-integral solution of the one-dimensional Dirac quantum cellular automaton

Score: `0.729`
Zotero key: `2FI8JCDW`
arXiv: `1406.1021`
DOI: `10.1016/j.physleta.2014.09.020`
URL: https://www.zotero.org/19894138/items/2FI8JCDW

Abstract:

Quantum cellular automata, which describe the discrete and exactly causal unitary evolution of a lattice of quantum systems, have been recently considered as a fundamental approach to quantum field theory and a linear automaton for the Dirac equation in one dimension has been derived. In the linear case a quantum cellular automaton is isomorphic to a quantum walk and its evolution is conveniently formulated in terms of transition matrices. The semigroup structure of the matrices leads to a new kind of discrete path-integral, different from the well known Feynman checkerboard one, that is solved analytically in terms of Jacobi polynomials of the arbitrary mass parameter.
