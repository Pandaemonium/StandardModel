# Aristotle semantic context pack

Generated: 2026-07-09T22:15:15
Query: `finite local observable algebra net tensor factors microcausality isotony joint generation noncommutative regions`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/context-packs/null-edge-qubit-concurrence-20260621-manual.md` [Scope]

Score: `0.782`

```text
## Scope

This job is finite matrix algebra only. It does not prove LOCC monotonicity,
does not assert a continuum time theorem, and does not choose a physical
normalization beyond the determinant expression.
```

### 2. `Sources/NullStrand_Open_Questions_For_Frontier_Models.md` [Q6 — A null-local, covariant, continuum-correct operator (or a sharp no-go)]

Score: `0.774`

```text
### Q6 — A null-local, covariant, continuum-correct operator (or a sharp no-go)

**Informal goal.** Independent of Q5's internal structure, we want to know whether a
single first-order operator on a Lorentz-covariant causal structure can be **all** of:
retarded, intrinsically local, supported on primitive null continuations, covariant in
law, stable, and convergent to the right continuum operator. The folklore worry is
that covariant causal-set operators are forced to be nonlocal.

**Precise target.** Set up a **property matrix** (retardedness, intrinsic locality,
primitive null support, covariance-in-law, stability, continuum convergence) and either
exhibit one operator satisfying all columns, or prove a precise tradeoff / no-go
showing two properties are incompatible. Additionally: test whether an apparently
nonlocal *effective* operator can be realized as the **projected square of a natural
null-local operator on an enlarged state space** (a dilation), with naturality and
dimension controls so trivial encodings don't count.

**Guidance wanted.** What is the current best statement of the causal-set nonlocality
obstruction (Sorkin/Johnston-style retarded operators, the "nonlocal d'Alembertian"
literature), and is it a true no-go or an artifact of specific constructions? Is there
a Stinespring-like dilation framework in which a local operator on a larger space
projects to the desired effective dynamics, and what naturality condition rules out
cheating?

---
```

### 3. `PhysicsSM/NullStrand/Entanglement/SeparabilityObstruction.lean` [entangledState]

Score: `0.770`

```text
def entangledState
    {A B : Type*} [Fintype A] [Fintype B] (ρ : Law (A × B)) : Prop :=
  ¬ separableState ρ

/-- Synonym for the finite null-direction local-positive product representation. -/
```

### 4. `Sources/NullStrand_Lean_Roadmap_Improved.md` [Gate G2 — covariant one-particle kinematics and finite nonlocality tests]

Score: `0.770`

```text
### Gate G2 — covariant one-particle kinematics and finite nonlocality tests

Adds:

- intrinsic null measure and Lorentz covariance;
- observer flux measure and mass-ratio variance theorem;
- finite product-null separability obstruction;
- synchronization-defect framework and baseline computations;
- finite Bell current/rates.
```

### 5. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [0. Dirac square-root criterion]

Score: `0.762`

```text
n should attach here, not in the visible mass
theorem. Replacing the usual Standard Model finite algebra by an
`H_3(O)`/Albert-algebra candidate is a hypothesis about the internal
`D_F`/Yukawa block. It must reproduce representation data without ad hoc
states before it can be promoted beyond a lead.

Noncommutative geometry now becomes an audit, not just inspiration. The finite
`D_{U,Phi}` candidate should be checked against the pieces of an almost-
commutative spectral triple that make sense on a finite causal order complex:
grading, real structure, first-order condition, inner fluctuation behavior,
orientability or volume-cycle surrogate, and low-order spectral-action terms.
If the audit fails, that is useful: it tells us exactly where causal incidence
differs from the Connes-Chamseddine template.

The closest graph-level prior art is Marcolli-van Suijlekom gauge networks
(arXiv:1301.3480), so the novelty claim must be narrower than "graph spectral
triple with Higgs." The null-edge contribution is the causal-directed,
Lorentzian/Krein, Pluecker-kinetic version. Perez-Sanchez's 2025 comment on
gauge networks is a useful failure mode: if the Higgs/Yukawa block becomes
constant or disappears under the relevant coarse-graining, then the finite
operator has not produced a dynamical Higgs sector.

Prize targets:

```lean
superDirac_productGrading_def
superDirac_kreinForm_def
superDirac_is_odd
superDirac_total_grading_def
superDirac_etaKreinAdjoint_def
superDirac_is_etaSelfAdjoint_or_antiSelfAdjoint
realStructure_chargeConjugation_def
massShellSign_eq_plusProjector_sub_minusProjector
covariantOrderDifferential_sq_eq_diamondCurvature
diamond_pathDefect_eq_holonomySubOne_mul_reference
higgsBlock_sq_eq_yukawaMassMatrix
nullGraphDirac_commutator_eq_localSymbol
localNullSymbol_sq
```

### 6. `Sources/NullStrand_Lean_Roadmap_Improved.md` [O3 — entanglement and synchronization curvature]

Score: `0.761`

```text
### O3 — entanglement and synchronization curvature

Do not seek an unconditional iff. Seek theorem families parameterized by locality, positivity, covariance, and regularity assumptions on `HiddenTransportRule`.
```

### 7. `Sources/A_null-strand_Bohm–Bell_theory.md` [14. Locality versus covariance]

Score: `0.761`

```text
## 14. Locality versus covariance

Claude’s proposed blanket causal-set no-go is too strong for the roadmap.

The established generalized causal-set d’Alembertians of Aslanbeigi, Saravani, and Sorkin are manifestly Lorentz invariant, retarded, and nonlocal. ([arXiv][2]) But a 2025 preprint by Boguñá and Krioukov proposes an intrinsic local causal-set d’Alembertian and proves a continuum-convergence result in sprinkled Minkowski spacetime. ([arXiv][3])

Lean should therefore formalize an **operator audit**, not assume an impossibility theorem:

```lean
Retarded
NullEdgeSupported
IntrinsicLocal
LorentzNaturalInLaw
Stable
ContinuumCorrect
```

A particularly useful open interface is a null-local dilation:

```lean
structure NullDilation (L : Matrix Q Q ℂ) where
  Hidden : Type
  liftD : Matrix (Q × Hidden) (Q × Hidden) ℂ
  nullSupport : SupportedOn liftD IsNullContinuation
  embed : ...
  project : ...
  realizes : project ∘ liftD^2 ∘ embed = L
```

A nonlocal effective operator might be the marginal or square of a local null process on an enlarged state space. Existence or impossibility of such a dilation is a sharper theorem target than the simple lattice-versus-causal-set dichotomy.
```

### 8. `Sources/NullStrand_Lean_Roadmap_Improved.md` [W14 — causal-set locality and dilation]

Score: `0.760`

```text
### W14 — causal-set locality and dilation

Do not encode a blanket theorem that Lorentz-covariant causal-set boxes must be nonlocal. Compare candidate operators under a common property matrix:

- retardedness;
- intrinsic locality;
- primitive null support;
- covariance in law;
- stability;
- continuum convergence.

Also test whether an effective operator can be realized as the projected square of a natural null-local operator on an enlarged state space. Add naturality and dimension controls so trivial encodings do not count.
```

## Scoped paper hits

No paper hits returned.
