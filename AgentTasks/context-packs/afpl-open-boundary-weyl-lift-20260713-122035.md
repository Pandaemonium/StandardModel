# Aristotle semantic context pack

Generated: 2026-07-13T12:20:59
Query: `open boundary unitary quantum walk reflecting boundary memory three dimensional Weyl Pauli tensor causal cone anomaly inflow`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `NULL-EDGE_TARGET_AUDIENCE.md` [Paper I: the flagship]

Score: `0.812`

```text
## Paper I: the flagship

**Proposed title**

> **Null-Spinor Area as the Rest Gap of an Exactly Unitary Dirac Walk**

**Primary audience:** quantum walks, QCAs, mathematical physics.

**Required core results:**

1. Null-spinor Cauchy–Binet and exact collinearity boundary.
2. Natural Plücker-derived Hermitian mass operator.
3. Exact unitary history expansion with the (\tan(a\mu)) relation.
4. Uniform many-step continuum convergence.
5. Complete spectral and doubling audit.
6. Ideally, an exactly unitary (3+1) extension or a definitive comparison with the tetrahedral walk.

The Lean artifact should be prominent but subordinate to the physics theorem. Aim for approximately 20–25 pages plus a technical supplement.
```

### 2. `AgentTasks/24h-publication-run-2026-07-12/GRAND_STRATEGY7_REPORT.md` [P3 — Exactly-unitary strict-local Wilson walk (`d = 4`) — the physics-standard cure]

Score: `0.808`

```text
### P3 — Exactly-unitary strict-local Wilson walk (`d = 4`) — the physics-standard cure

Add a Cayley-unitarized Wilson term that vanishes quadratically at the origin
and grows to the corners:
```
W(q) = r · Σ_j (1 − c_j) · β,                    (Hermitian, Ξ-odd via β)
U₃(q) = (I − i W(q))(I + i W(q))⁻¹ · splitStep(q,0)   [Cayley]
     or  U₃(q) = splitStep(qx,qy,qz, θ_W(q))  with cos θ_W = f(Σ(1−c_j)).
```
* Laurent-finite in the *symbol* sense: `1 − c_j = 1 − (z_j+z_j⁻¹)/2` is
  Laurent; the Cayley transform is a finite Laurent *unit* iff the denominator
  is a Laurent unit (needs `det(I + iW)` a monomial — check via
  `LaurentUnitResource.qca_det_is_unique_monomial`; if not, use the
  mass-angle form `θ_W(q)`, which is manifestly Laurent per factor but makes the
  Wilson profile a bounded-range trigonometric mass).
* Symmetry / roots: retains the **full cubic point group** (`W` is symmetric in
  `c_j`); particle-hole is broken by `W` — which is exactly permitted, since P3
  deliberately leaves the global-chiral class. Predicted root set: **unique cone
  at the origin, all seven doublers gapped** (textbook Wilson). Lowest novelty
  (it is the Wilson mechanism), but a strict-local *exactly unitary discrete-time*
  Wilson walk with a **kernel-certified** unique cone is still a clean, true,
  citable theorem and the safest positive result.
```

### 3. `AgentTasks/overnight-null-information-run-2026-07-10/MANUSCRIPT_CLAIM_MATRIX.md` [Manuscript claim and evidence matrix]

Score: `0.803`

```text
rPower.directionPathSum_eq_transfer_pow`, `UnitaryCheckerboardTransfer.physicalTransfer_unitary`, `BoundedMomentumManyStepContinuum`, `FiniteWalkPositionConvergence.onePlusOne_finite_kernel_bound`, `SummableFourierContinuumLift`, `FermionDoublingAudit` | 1+1 conventions, supplied phases, imported analytic free propagator, and a walk-specific envelope for countable synthesis | quarter-angle kernel witness, pure-flip boundary, exact value `85`, uniform `Dbox t^2/n`, exact `{0,pi}` band-touching set | S05/S18 | wrong phase/orientation, finite kernel violates bound, nonsummable modes, or no normalized L2/PDE upgrade | Codex | exact unitary/checkerboard composition, full-zone audit, bounded symbol rate, and finite position-kernel bound landed; normalized L2/infinite-volume PDE open |
| M6 | a selected D4 shell supplies a local finite six-channel null walk whose anisotropic rank-four sector admits no scalar-square invariant block; a separate four-component successive-axis construction has exact local unitarity, explicit Clifford eigenbases, an ordered x/y/z/mass symbol, compact-box `O(1/n)` Dirac convergence, finite Fourier/L2 control, and a phase-retaining complex Pluecker mass coin inserted into the local walk | M selected finite models/no-go/spatial walk; V2 reproduction; C full physical continuum | `D4FiniteUnitaryWalk`, `AxisCoinComplexCliffordNoGo.axisBlockCoin_has_no_complex_clifford_block`, `CliffordDiagonalPositionBridge.axisBasis_conjugates_velocity`, `Finite3Plus1AnalyticSignBridge.finiteLocalSymbol_eq_analytic_neg`, `Pluecker3Plus1ComplexMass.massCoin4_unitary_group`, `ComplexPlueckerLocalWalk.complexLocalStep_preserves_norm`, `complexLocalStep_mode` | time axis, sign table, factor order, and explicit eigenbases supplied; product-DFT packaging, isotropy normalizat
```

### 4. `AgentTasks/null-edge-cycle-09-literature-2026-07-02.md` [Sources checked]

Score: `0.792`

```text
t proof is a finite `2 x 2` momentum-symbol Trotter problem.

- Recent broader quantum-walk continuum-limit material, e.g. "Continuum Limits
  of Lazy Open Quantum Walks", arXiv:2512.17755.
  Link: https://arxiv.org/html/2512.17755v1
  Relevance: not a direct source for our unitary checkerboard theorem, but it
  confirms that modern work still separates unitary ballistic/Dirac limits from
  dissipative or dephased variants. We should not import open-system claims into
  the present unitary finite-core statement.
```

### 5. `AgentTasks/overnight-allmass-run-2026-07-09/LIT_SEARCH_LOG.md` [2026-07-09 16:50 PDT - Codex - 3+1 checkerboard and universal-speed audit]

Score: `0.789`

```text
## 2026-07-09 16:50 PDT - Codex - 3+1 checkerboard and universal-speed audit
- Foster-Jacobson, arXiv:1610.01142, gives a 4D null-face lattice Weyl path
  integral with spin-projector products and mass-induced chirality flips. Its
  tetrahedral first-moment normalization uses microscopic step speed `3c`,
  matching the exact `1/3` tight-frame factor now proved locally.
- D'Ariano-Mosco-Perinotti-Tosini, arXiv:1705.08552, gives an exact finite-time
  position-space path-sum propagator for a 3+1 Weyl quantum walk on a Cayley
  graph of `Z^3`. Nzongani et al., arXiv:2404.09840, recover the 3+1 Dirac
  equation from a unitary tetrahedral walk. These rule out a blanket
  single-particle 3+1 checkerboard no-go.
- Mlodinow-Brun, arXiv:2006.08927, is a no-go for a common local
  **many-particle QCA/QFT construction** in two or more spatial dimensions.
  It does not rule out the single-particle walks above; many-body locality must
  be treated as a separate rung.
- Claim repair: `all particles and channels microscopically move at c` is not a
  common well-typed operator statement. The achievable universal theorem is a
  shared null characteristic cone when all field equations have the same
  principal symbol and the extra channels are lower order. A principal-order
  channel or metric-changing soldering term can change the cone.
```

### 6. `PhysicsSM/Draft/NullEdge/ExactQuantumWalkDispersion.lean` [quantumWalk_unitary]

Score: `0.780`

```text
theorem quantumWalk_unitary (a k mu : ℝ) :
    PhysicsSM.Draft.NullEdgeQWUnitarity.IsUnitary2
      (quantumWalkOperator a k mu) := by
  simpa [quantumWalkOperator,
    PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.Ua,
    PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.Rz,
    PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.Rx,
    PhysicsSM.Draft.NullEdgeQWUnitarity.Ua,
    PhysicsSM.Draft.NullEdgeQWUnitarity.Rz,
    PhysicsSM.Draft.NullEdgeQWUnitarity.Rx] using
    PhysicsSM.Draft.NullEdgeQWUnitarity.Ua_unitary a k mu

/-- Compact spectral verdict: the concrete trace identity, its quasienergy
bridge, unitarity, determinant one, and both zero-momentum eigenphases. -/
```

### 7. `AgentTasks/overnight-null-information-run-2026-07-10/PAPER_I_NOVELTY_AUDIT_2026-07-10.md` [Verdict table]

Score: `0.780`

```text
## Verdict table

| Candidate claim | Closest checked precedent | Defensible wording |
|---|---|---|
| A two-spinor wedge gives `det P = |z|^2` | Cauchy--Binet, spinor-helicity, and rank-one Hermitian momentum are established | Classical kinematics, formalized here |
| `B(z) = [[0,z],[conj z,0]]` is the canonical odd Hermitian rest operator and gives `H^2 = (k^2 + det P) I` | Standard Dirac mass matrices and phase conjugacies are established; no checked source in the scoped corpus derives this operator from the null-spinor Pluecker coordinate | New synthesis/construction; avoid claiming discovery of odd mass matrices themselves |
| The unitary coin has corner/stay ratio `-i tan(a mu)` | Succi--Fillion-Gourdeau--Palpacelli (2015) explicitly relate exponential Dirac mass matrices to quantum-walk Euler angles through tangent formulas | Established parametrization; the new payload is its exact recursive-kernel composition with Pluecker-derived `B(z)` and machine verification |
| The recursive unitary kernel equals `cos(a mu)^n` times the polynomial checkerboard kernel | D'Ariano--Mosco--Perinotti--Tosini (2014) give an exact Dirac-QCA path integral; Feynman-checkerboard literature counts turns | Exact finite theorem in this artifact; describe as a checked composition unless a broader full-text search establishes priority |
| Uniform `O(1/n)` product convergence | Product formulas and observational-convergence machinery are established | New explicit instantiation/constant for this derived walk, not a new Trotter theory |
| Successive-axis local `3+1` walk | Mlodinow--Brun (2018) construct a 3D walk as three one-dimensional factors; Nzongani et al. (2024) give a tetrahedral `3+1` Dirac walk | Established architecture; new payload is the formalized ordered bridge, explicit co
```

### 8. `NULL-EDGE_TARGET_AUDIENCE.md` [What these readers will ask immediately]

Score: `0.780`

```text
## What these readers will ask immediately

They are unlikely to be impressed merely by

[
m=\sqrt{\det P}
]

being substituted into a familiar split-step walk. They will ask:

1. **Is the walk genuinely new, or unitarily equivalent to a standard Dirac walk?**
2. **What is forced by the null-spinor data, rather than chosen after the fact?**
3. **Is there a uniform many-step continuum theorem?**
4. **Does the construction work in (3+1) dimensions?**
5. **What happens across the entire Brillouin zone—doubling, extra cones, anomalous branches, and high-momentum behavior?**
6. **Can the construction be second-quantized or coupled locally?**
7. **How does it compare theorem-by-theorem with the tetrahedral, Weyl-QCA, split-step, and checkerboard constructions already in the literature?**

Those questions should determine the entire structure of Paper I.
```

## Scoped paper hits

### 1. Dirac quantum walk on tetrahedra

Score: `0.788`
Zotero key: `8RZQA73D`
arXiv: `2404.09840`
DOI: `10.1103/physreva.110.042418`
URL: http://arxiv.org/abs/2404.09840

### 2. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.772`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 3. Quantum walking in curved spacetime

Score: `0.765`
Zotero key: `755V4SCW`
arXiv: `1505.07023`
DOI: `10.1007/s11128-016-1335-7`
URL: https://www.zotero.org/19894138/items/755V4SCW

Abstract:

A discrete-time quantum walk (QW) is essentially a unitary operator driving the evolution of a single particle on the lattice. Some QWs admit a continuum limit, leading to familiar PDEs (e.g., the Dirac equation). In this paper, we study the continuum limit of a wide class of QWs and show that it leads to an entire class of PDEs, encompassing the Hamiltonian form of the massive Dirac equation in ( $$1+1$$ ) curved spacetime. Therefore, a certain QW, which we make explicit, provides us with a unitary discrete toy model of a test particle in curved spacetime, in spite of the fixed background lattice. Mathematically, we have introduced two novel ingredients for taking the continuum limit of a QW, but which apply to any quantum cellular automata: encoding and grouping.

### 4. Connecting the discrete- and continuous-time quantum walks

Score: `0.765`
Zotero key: `XK9ZRDNJ`
DOI: `10.1103/physreva.74.030301`
URL: https://doi.org/10.1103/physreva.74.030301

### 5. Relativistic effects and rigorous limits for discrete- and continuous-time quantum walks

Score: `0.764`
Zotero key: `QSB24VR9`
DOI: `10.1063/1.2759837`
URL: https://doi.org/10.1063/1.2759837
