# Aristotle semantic context pack

Generated: 2026-07-11T17:03:40
Query: `full ordered 3+1 Bloch split step global chirality Xi commutes iff mass angle sine zero Weyl sector charge`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeP2ChiralityCoherence.lean`

Score: `0.773`

```text
import Mathlib.Tactic

/-!
# P2 chirality coherence in a two-level Dirac/Yukawa block

This module records a small finite algebraic bridge for the Higgs/Yukawa
interpretation. The off-diagonal mass entry of the positive-energy chiral
projector has l1 chirality coherence `m / E`.

Physics interpretation boundary: the theorem says the mass coupling creates
left/right coherence in the chiral block. Visible mixedness appears only after
an explicit observer channel, dephasing, or partial trace; it should not be
double-counted as an additional independent mass mechanism.
-/
```

### 2. `AgentTasks/aristotle-downloads-wave12-13-20260626/fur-h6-dvt-jordan-yukawa-constraint-audit/fur-h6-dvt-jordan-yukawa-constraint-audit_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [29.4 Kernel and ordinary chirality of a nonzero null slash]

Score: `0.768`

```text
### 29.4 Kernel and ordinary chirality of a nonzero null slash

For a nonzero null covector `p`, the four-component Weyl/chiral gamma block form
gives

```text
c(p) = [ 0    A(p) ]
       [ B(p) 0    ],

A(p) = p_0 I + p_i sigma_i,
B(p) = p_0 I - p_i sigma_i.
```

At a high branch, `p = s ell_a^flat = s (1, -n_a)` with `s != 0`, so

```text
A(p) = s (I - n_a.sigma),
B(p) = s (I + n_a.sigma).
```

Since `n_a.sigma` has eigenvalues `+1` and `-1`, both `A(p)` and `B(p)` have
rank one. Thus

```text
rank c(p) = 2,
dim ker c(p) = 2.
```

Moreover the kernel splits as one Weyl line of each ordinary chirality:

```text
dim(ker c(p) cap H_+) = 1,
dim(ker c(p) cap H_-) = 1.
```

Consequently

```text
trace(Pker Gamma_s Pker) = 0,
Pker Gamma_s Pker has eigenvalues +1 and -1 on the two kernel lines,
Pker Gamma_s Pker != +Pker,
Pker Gamma_s Pker != -Pker.
```

This is the core Route B hand proof. If the Lean representation is the usual
four-component Clifford slash, this proves that raw ordinary branch chirality is
not scalar and that bare `OperatorForcesAlignment` should fail.
```

### 3. `AgentTasks/aristotle-downloads-wave12-13-20260626/c58-projected-branch-weyl-projector/c58-projected-branch-weyl-projector_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [29.4 Kernel and ordinary chirality of a nonzero null slash]

Score: `0.768`

```text
### 29.4 Kernel and ordinary chirality of a nonzero null slash

For a nonzero null covector `p`, the four-component Weyl/chiral gamma block form
gives

```text
c(p) = [ 0    A(p) ]
       [ B(p) 0    ],

A(p) = p_0 I + p_i sigma_i,
B(p) = p_0 I - p_i sigma_i.
```

At a high branch, `p = s ell_a^flat = s (1, -n_a)` with `s != 0`, so

```text
A(p) = s (I - n_a.sigma),
B(p) = s (I + n_a.sigma).
```

Since `n_a.sigma` has eigenvalues `+1` and `-1`, both `A(p)` and `B(p)` have
rank one. Thus

```text
rank c(p) = 2,
dim ker c(p) = 2.
```

Moreover the kernel splits as one Weyl line of each ordinary chirality:

```text
dim(ker c(p) cap H_+) = 1,
dim(ker c(p) cap H_-) = 1.
```

Consequently

```text
trace(Pker Gamma_s Pker) = 0,
Pker Gamma_s Pker has eigenvalues +1 and -1 on the two kernel lines,
Pker Gamma_s Pker != +Pker,
Pker Gamma_s Pker != -Pker.
```

This is the core Route B hand proof. If the Lean representation is the usual
four-component Clifford slash, this proves that raw ordinary branch chirality is
not scalar and that bare `OperatorForcesAlignment` should fail.
```

### 4. `AgentTasks/aristotle-downloads-wave12-13-20260626/c60-species-split-nodal-line-lift/c60-species-split-nodal-line-lift_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [29.4 Kernel and ordinary chirality of a nonzero null slash]

Score: `0.768`

```text
### 29.4 Kernel and ordinary chirality of a nonzero null slash

For a nonzero null covector `p`, the four-component Weyl/chiral gamma block form
gives

```text
c(p) = [ 0    A(p) ]
       [ B(p) 0    ],

A(p) = p_0 I + p_i sigma_i,
B(p) = p_0 I - p_i sigma_i.
```

At a high branch, `p = s ell_a^flat = s (1, -n_a)` with `s != 0`, so

```text
A(p) = s (I - n_a.sigma),
B(p) = s (I + n_a.sigma).
```

Since `n_a.sigma` has eigenvalues `+1` and `-1`, both `A(p)` and `B(p)` have
rank one. Thus

```text
rank c(p) = 2,
dim ker c(p) = 2.
```

Moreover the kernel splits as one Weyl line of each ordinary chirality:

```text
dim(ker c(p) cap H_+) = 1,
dim(ker c(p) cap H_-) = 1.
```

Consequently

```text
trace(Pker Gamma_s Pker) = 0,
Pker Gamma_s Pker has eigenvalues +1 and -1 on the two kernel lines,
Pker Gamma_s Pker != +Pker,
Pker Gamma_s Pker != -Pker.
```

This is the core Route B hand proof. If the Lean representation is the usual
four-component Clifford slash, this proves that raw ordinary branch chirality is
not scalar and that bare `OperatorForcesAlignment` should fail.
```

### 5. `AgentTasks/aristotle-downloads-wave12-13-20260626/c61-gauge-covariant-link-dressed-projectors/c61-gauge-covariant-link-dressed-projectors_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [29.4 Kernel and ordinary chirality of a nonzero null slash]

Score: `0.768`

```text
### 29.4 Kernel and ordinary chirality of a nonzero null slash

For a nonzero null covector `p`, the four-component Weyl/chiral gamma block form
gives

```text
c(p) = [ 0    A(p) ]
       [ B(p) 0    ],

A(p) = p_0 I + p_i sigma_i,
B(p) = p_0 I - p_i sigma_i.
```

At a high branch, `p = s ell_a^flat = s (1, -n_a)` with `s != 0`, so

```text
A(p) = s (I - n_a.sigma),
B(p) = s (I + n_a.sigma).
```

Since `n_a.sigma` has eigenvalues `+1` and `-1`, both `A(p)` and `B(p)` have
rank one. Thus

```text
rank c(p) = 2,
dim ker c(p) = 2.
```

Moreover the kernel splits as one Weyl line of each ordinary chirality:

```text
dim(ker c(p) cap H_+) = 1,
dim(ker c(p) cap H_-) = 1.
```

Consequently

```text
trace(Pker Gamma_s Pker) = 0,
Pker Gamma_s Pker has eigenvalues +1 and -1 on the two kernel lines,
Pker Gamma_s Pker != +Pker,
Pker Gamma_s Pker != -Pker.
```

This is the core Route B hand proof. If the Lean representation is the usual
four-component Clifford slash, this proves that raw ordinary branch chirality is
not scalar and that bare `OperatorForcesAlignment` should fail.
```

### 6. `AgentTasks/aristotle-downloads-wave12-13-20260626/c62-composite-interpolating-zero-escape/c62-composite-interpolating-zero-escape_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [29.4 Kernel and ordinary chirality of a nonzero null slash]

Score: `0.768`

```text
### 29.4 Kernel and ordinary chirality of a nonzero null slash

For a nonzero null covector `p`, the four-component Weyl/chiral gamma block form
gives

```text
c(p) = [ 0    A(p) ]
       [ B(p) 0    ],

A(p) = p_0 I + p_i sigma_i,
B(p) = p_0 I - p_i sigma_i.
```

At a high branch, `p = s ell_a^flat = s (1, -n_a)` with `s != 0`, so

```text
A(p) = s (I - n_a.sigma),
B(p) = s (I + n_a.sigma).
```

Since `n_a.sigma` has eigenvalues `+1` and `-1`, both `A(p)` and `B(p)` have
rank one. Thus

```text
rank c(p) = 2,
dim ker c(p) = 2.
```

Moreover the kernel splits as one Weyl line of each ordinary chirality:

```text
dim(ker c(p) cap H_+) = 1,
dim(ker c(p) cap H_-) = 1.
```

Consequently

```text
trace(Pker Gamma_s Pker) = 0,
Pker Gamma_s Pker has eigenvalues +1 and -1 on the two kernel lines,
Pker Gamma_s Pker != +Pker,
Pker Gamma_s Pker != -Pker.
```

This is the core Route B hand proof. If the Lean representation is the usual
four-component Clifford slash, this proves that raw ordinary branch chirality is
not scalar and that bare `OperatorForcesAlignment` should fail.
```

### 7. `AgentTasks/aristotle-downloads-wave12-13-20260626/c59-post-c21-projected-release-criterion/c59-post-c21-projected-release-criterion_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [29.4 Kernel and ordinary chirality of a nonzero null slash]

Score: `0.768`

```text
### 29.4 Kernel and ordinary chirality of a nonzero null slash

For a nonzero null covector `p`, the four-component Weyl/chiral gamma block form
gives

```text
c(p) = [ 0    A(p) ]
       [ B(p) 0    ],

A(p) = p_0 I + p_i sigma_i,
B(p) = p_0 I - p_i sigma_i.
```

At a high branch, `p = s ell_a^flat = s (1, -n_a)` with `s != 0`, so

```text
A(p) = s (I - n_a.sigma),
B(p) = s (I + n_a.sigma).
```

Since `n_a.sigma` has eigenvalues `+1` and `-1`, both `A(p)` and `B(p)` have
rank one. Thus

```text
rank c(p) = 2,
dim ker c(p) = 2.
```

Moreover the kernel splits as one Weyl line of each ordinary chirality:

```text
dim(ker c(p) cap H_+) = 1,
dim(ker c(p) cap H_-) = 1.
```

Consequently

```text
trace(Pker Gamma_s Pker) = 0,
Pker Gamma_s Pker has eigenvalues +1 and -1 on the two kernel lines,
Pker Gamma_s Pker != +Pker,
Pker Gamma_s Pker != -Pker.
```

This is the core Route B hand proof. If the Lean representation is the usual
four-component Clifford slash, this proves that raw ordinary branch chirality is
not scalar and that bare `OperatorForcesAlignment` should fail.
```

### 8. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [29.4 Kernel and ordinary chirality of a nonzero null slash]

Score: `0.768`

```text
### 29.4 Kernel and ordinary chirality of a nonzero null slash

For a nonzero null covector `p`, the four-component Weyl/chiral gamma block form
gives

```text
c(p) = [ 0    A(p) ]
       [ B(p) 0    ],

A(p) = p_0 I + p_i sigma_i,
B(p) = p_0 I - p_i sigma_i.
```

At a high branch, `p = s ell_a^flat = s (1, -n_a)` with `s != 0`, so

```text
A(p) = s (I - n_a.sigma),
B(p) = s (I + n_a.sigma).
```

Since `n_a.sigma` has eigenvalues `+1` and `-1`, both `A(p)` and `B(p)` have
rank one. Thus

```text
rank c(p) = 2,
dim ker c(p) = 2.
```

Moreover the kernel splits as one Weyl line of each ordinary chirality:

```text
dim(ker c(p) cap H_+) = 1,
dim(ker c(p) cap H_-) = 1.
```

Consequently

```text
trace(Pker Gamma_s Pker) = 0,
Pker Gamma_s Pker has eigenvalues +1 and -1 on the two kernel lines,
Pker Gamma_s Pker != +Pker,
Pker Gamma_s Pker != -Pker.
```

This is the core Route B hand proof. If the Lean representation is the usual
four-component Clifford slash, this proves that raw ordinary branch chirality is
not scalar and that bare `OperatorForcesAlignment` should fail.
```

## Scoped paper hits

### 1. Spin on a 4D Feynman Checkerboard

Score: `0.739`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 2. Bulk--Boundary Correspondence for Chiral Symmetric Quantum Walks

Score: `0.733`
Zotero key: `9QPIHJEW`
arXiv: `1303.1199`
DOI: `10.1103/PhysRevB.88.121406`
URL: http://arxiv.org/abs/1303.1199

Abstract:

Discrete-time quantum walks (DTQW) have topological phases that are richer than those of time-independent lattice Hamiltonians. Even the basic symmetries, on which the standard classification of topological insulators hinges, have not yet been properly defined for quantum walks. We introduce the key tool of timeframes, i.e., we describe a DTQW by the ensemble of time-shifted unitary timestep operators belonging to the walk. This gives us a way to consistently define chiral symmetry (CS) for DTQW's. We show that CS can be ensured by using an "inversion symmetric" pulse sequence. For one-dimensional DTQW's with CS, we identify the bulk ZxZ topological invariant that controls the number of topologically protected 0 and pi energy edge states at the interfaces between different domains, and give simple formulas for these invariants. We illustrate this bulk--boundary correspondence for DTQW's on the example of the "4-step quantum walk", where tuning CS and particle-hole symmetry realizes edge states in various symmetry classes.

### 3. Generalized Global Symmetries

Score: `0.728`
Zotero key: `AXAWAGGB`
arXiv: `1412.5148`
DOI: `10.1007/JHEP02(2015)172`
URL: http://arxiv.org/abs/1412.5148

Abstract:

A $q$-form global symmetry is a global symmetry for which the charged operators are of space-time dimension $q$; e.g. Wilson lines, surface defects, etc., and the charged excitations have $q$ spatial dimensions; e.g. strings, membranes, etc. Many of the properties of ordinary global symmetries ($q$=0) apply here. They lead to Ward identities and hence to selection rules on amplitudes. Such global symmetries can be coupled to classical background fields and they can be gauged by summing over these classical fields. These generalized global symmetries can be spontaneously broken (either completely or to a subgroup). They can also have 't Hooft anomalies, which prevent us from gauging them, but lead to 't Hooft anomaly matching conditions. Such anomalies can also lead to anomaly inflow on various defects and exotic Symmetry Protected Topological phases. Our analysis of these symmetries gives a new unified perspective of many known phenomena and uncovers new results.

### 4. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.724`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 5. Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation

Score: `0.723`
Zotero key: `N68MN4ET`
arXiv: `hep-lat/9802011`
DOI: `10.1016/S0370-2693(98)00423-7`
URL: https://arxiv.org/abs/hep-lat/9802011

Abstract:

It is shown that the Ginsparg-Wilson relation implies an exact symmetry of the fermion action, which may be regarded as a lattice form of an infinitesimal chiral rotation. Using this result it is straightforward to construct lattice Yukawa models with unbroken flavour and chiral symmetries and no doubling of the fermion spectrum. A contradiction with the Nielsen-Ninomiya theorem is avoided, because the chiral symmetry is realized in a different way than has been assumed when proving the theorem.
