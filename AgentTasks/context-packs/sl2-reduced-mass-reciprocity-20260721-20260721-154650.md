# Aristotle semantic context pack

Generated: 2026-07-21T15:47:15
Query: `two by two determinant one equal trace reciprocal characteristic polynomial doubled Weyl Dirac quantum walk spectral pairing`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/MassMixedness.lean` [normalized_det]

Score: `0.797`

```text
theorem normalized_det {N : Nat} (psi : Fin N -> Fin 2 -> Complex)
    (T : Complex) (hT : T ≠ 0) (htr : (famMomentum psi).trace = T) :
    (T⁻¹ • famMomentum psi).det = (famMomentum psi).det / T ^ 2 := by
  rw [ Matrix.det_smul, pow_two ] ; ring ; aesop;

/-
**T3 (Lagrange / trace-distance form).**  The squared wedge is the
distinguishability combination:
`|psi /\ phi|^2 = |psi|^2 |phi|^2 - |<psi, phi>|^2`.
For unit spinors the right side is the squared trace distance of the pure
qubit states, so the rest gap is the energy-weighted optimal
distinguishability.
-/
```

### 2. `AutonomousLab/work/NE-3PLUS1/CODEX_LITERATURE_MASSIVE_DIRAC_CONTINUUM_2026-07-20.md` [D'Ariano, Mosco, Perinotti, and Tosini (2016)]

Score: `0.790`

```text
### D'Ariano, Mosco, Perinotti, and Tosini (2016)

- Paper: *Discrete time Dirac quantum walk in 3+1 dimensions*
- arXiv: <https://arxiv.org/abs/1603.06442>

They obtain a massive Dirac walk by locally coupling two Weyl walks on a BCC
lattice.  The construction supports the same structural choice made in
`HNUPlueckerMassiveStay`: opposite-chirality Weyl sectors plus a local mass
coupling.  Their low-momentum particle-state approximation and fidelity
analysis are useful comparison targets, but they are not a changing-lattice
full-`L2` theorem.
```

### 3. `PhysicsSM/Spinor/TwistorPluckerMass.lean` [twoTwistorMassSqTraceConvention]

Score: `0.785`

```text
def twoTwistorMassSqTraceConvention
    (Z W : SpinorChartTwistor) : ℂ :=
  2 * (twoTwistorMomentum Z W).det

/-- The determinant convention is exactly the squared twistor spinor pairing. -/
```

### 4. `PhysicsSM/Draft/TwistorPluckerMass.lean` [twoTwistorMassSqTraceConvention]

Score: `0.785`

```text
def twoTwistorMassSqTraceConvention
    (Z W : SpinorChartTwistor) : ℂ :=
  2 * (twoTwistorMomentum Z W).det

/-- The determinant convention is exactly the squared twistor spinor pairing. -/
```

### 5. `PhysicsSM/Spinor/TwistorPluckerMass.lean` [twoTwistorMassSqDetConvention]

Score: `0.780`

```text
def twoTwistorMassSqDetConvention
    (Z W : SpinorChartTwistor) : ℂ :=
  (twoTwistorMomentum Z W).det

/--
Trace-pairing-convention mass square for two chart twistors, with the factor
`2` kept explicit.
-/
```

### 6. `PhysicsSM/Spinor/TwistorPluckerMass.lean` [multiTwistorMassSqDetConvention_eq_pairwiseMass]

Score: `0.780`

```text
theorem multiTwistorMassSqDetConvention_eq_pairwiseMass
    {n : Nat} (Z : MultiTwistorChart n) :
    multiTwistorMassSqDetConvention Z = multiTwistorPairwiseMass Z := by
  exact multi_twistor_momentum_det_eq_pairwiseMass Z

/--
The trace-pairing convention differs from the determinant convention by the
explicit factor `2`.
-/
```

## Scoped paper hits

### 1. Fermion Doubling in Dirac Quantum Walks

Score: `0.785`
Zotero key: `U58ZFXGR`
arXiv: `2601.15885`
URL: http://arxiv.org/abs/2601.15885v2

Abstract:

We consider discrete spacetime models known as quantum walks, which can be used to simulate Dirac particles. In particular we look at fermion doubling in these models, in which high momentum states yield additional low energy solutions which behave like Dirac particles. The presence of doublers carries over to the `second quantised' version of the walks represented by quantum cellular automata, which may lead to spurious solutions when introducing interactions. Moreover, we also consider pseudo-doublers, which have high energy but behave like low energy Dirac particles, and cause potential problems regarding the stability of the vacuum. To address these issues, we propose a family of quantum walks, that are free of these doublers and pseudo-doublers, but still simulate the Dirac equation in the continuum limit. However, there remain a small number of additional low energy solutions which do not directly correspond to Dirac particles. While the conventional Dirac walk always has a zero probability for the walker staying at the same point, we obtain the family of walks by allowing this probability to be non-zero.

### 2. Dirac quantum walk on tetrahedra

Score: `0.777`
Zotero key: `8RZQA73D`
arXiv: `2404.09840`
DOI: `10.1103/physreva.110.042418`
URL: http://arxiv.org/abs/2404.09840

### 3. The Dirac equation as a quantum walk: higher dimensions, observational convergence

Score: `0.771`
Zotero key: `4F87TGCN`
arXiv: `1307.3524`
DOI: `10.1088/1751-8113/47/46/465302`

### 4. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.766`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 5. Two-component Dirac-like Hamiltonian for generating quantum walk on one-, two- and three-dimensional lattices

Score: `0.759`
Zotero key: `MITSBCVI`
DOI: `10.1038/srep02829`
URL: https://www.zotero.org/19894138/items/MITSBCVI

Abstract:

From the unitary operator used for implementing two-state discrete-time quantum walk on one-, two- and three- dimensional lattice we obtain a two-component Dirac-like Hamiltonian. In particular, using different pairs of Pauli basis as position translation states we obtain three different form of Hamiltonians for evolution on one-dimensional lattice. We extend this to two- and three-dimensional lattices using different Pauli basis states as position translation states for each dimension and show that the external coin operation, which is necessary for one-dimensional walk is not a necessary requirement for a walk on higher dimensions but can serve as an additional resource to control the dynamics. The two-component Hamiltonian we present here for quantum walk on different lattices can serve as a general framework to simulate, control, and study the dynamics of quantum systems governed by Dirac-like Hamiltonian.
