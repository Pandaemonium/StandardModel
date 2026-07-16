# Aristotle semantic context pack

Generated: 2026-07-13T08:56:29
Query: `3+1 strict local unitary quantum walk finite-depth null substeps mixed Laurent non-nearest hyperdiamond minimal doubling zero pi quasienergy`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/overnight-publication-run-2026-07-11/HELP_NEEDED_2026-07-11.md` [H3. Find the minimal strict-local `3+1` Dirac walk, or prove the resource lower bound]

Score: `0.836`

```text
### H3. Find the minimal strict-local `3+1` Dirac walk, or prove the resource lower bound

**Why this is hard.** Exact unitarity, finite propagation range, the desired
Dirac tangent, isotropy, small internal dimension, and the absence of unwanted
high-momentum copies compete with one another.

**Landed frontier.** In the current ordered degree-one architecture:

- the complete massive zero/pi crossing set is known over the full Brillouin
  zone;
- every momentum-independent onsite coin retains the even aliases;
- the massive body-center keeps `+1/-1` modes for every mass angle;
- no normalized degree-one nearest-neighbor factor can carry the required
  stationary term;
- integer-frequency finite harmonics in the current commutator-Wilson family
  retain the aliases, while the exact de-aliasing control uses a noninteger
  frequency and is not strict finite range.

The six-direction D4 control is exactly local and unitary but its current mixing
does not contain the required four-component Dirac sector. A Wilson Hamiltonian
removes sampled copies but its exponential is not a finite-range one-step QCA.

**What we need.** Either:

1. an explicit alias-controlled strict QCA with a full all-momentum proof; or
2. a cross-architecture theorem quantifying the minimum extra range, substeps,
   cell size, memory, or internal dimension required.

**What would close the gate.** Full determinant/mass-shell classification, not
corner sampling; exact locality, not a local Hamiltonian whose exponential has
tails; and a nondegenerate Dirac tangent at the intended low-energy point.

The algebraic precursor is now landed. Every unit of the finite Laurent-
polynomial ring over a field is a nonzero coefficient times a unique monomial,
a genuine two-term polynomial is not a unit, and the deter
```

### 2. `AgentTasks/24h-publication-run-2026-07-12/MEMO_3PLUS1_ATTACK.md` [1. The problem, stated exactly]

Score: `0.827`

```text
## 1. The problem, stated exactly

Exhibit a strictly local (finite-range Laurent symbol), exactly unitary,
translation-invariant discrete-time update on a 3+1 lattice with finite
internal dimension whose quasienergy spectrum has exactly one Dirac
point --- an involutory unit-speed Dirac tangent at the origin --- and
no other +-1-quasienergy crossings anywhere in the zone, at either
quasienergy 0 or pi.

OR prove that no such update exists in a stated architecture class: a
discrete-time Nielsen-Ninomiya theorem.

Either outcome is field-changing for the discrete-spacetime and QCA
communities. The second is the one the evidence favors.
```

### 3. `PhysicsSM/Draft/NullEdge/PairModularSelection.lean` [behind]

Score: `0.826`

```text
structure behind the exactly-unitary null-step walk and the phase witness. -/
```

### 4. `AgentTasks/24h-publication-run-2026-07-12/SPARK_LIT_RECIPROCAL_SHIFT_PAIRING_2026-07-11.md` [Ranked findings]

Score: `0.824`

```text
ters
   rather than another separable onsite coin.  Their numerical statement about
   absence of additional roots is not a substitute for our exact torus
   certificate.
   [arXiv:2601.15885v2](https://arxiv.org/html/2601.15885v2), especially
   Sections III.2 and IV.

3. **Causality plus unitarity legitimizes finite-depth local circuit and
   ancillary-cell escape architectures.**  Arrighi, Nesme, and Werner prove
   that a causal unitary on a graph is locally implementable and apply the
   representation to arbitrary-dimensional QCA.  This does not promise a
   four-component one-cell solution; rather, it says that a valid causal
   survivor may naturally appear as a layered circuit on enlarged local cells.
   That makes "extra directional memory" a principled construction resource,
   not an admission of nonlocality.
   [arXiv:0711.3975](https://arxiv.org/abs/0711.3975).

4. **The one-dimensional index/factorization literature separates delay from
   local mixing.**  Gross, Nesme, Vogts, and Werner prove that the quantum-walk
   index is integer-valued, additive under composition, represented by shifts,
   and that trivial-index walks are partitioned unitaries.  Our reciprocal word
   has determinant one and no net delay, so its scientific value is the exact
   higher-order local mixing it supplies, not a hidden index.  This reinforces
   the need for an explicit 3D root or charge argument after embedding.
   [arXiv:0910.3675v2](https://arxiv.org/abs/0910.3675v2).

5. **Quadratic dispersion is a known de-doubling resource, but current twisted
   walks do not close our stricter gate.**  Jolly and Di Molfetta construct
   twisted walks whose continuum limit contains a dispersion term and analyze
   its regularizing effect on doubling.  The paper is useful as a compari
```

### 5. `AgentTasks/24h-publication-run-2026-07-12/GRAND_STRATEGY7_REPORT.md` [P3 — Exactly-unitary strict-local Wilson walk (`d = 4`) — the physics-standard cure]

Score: `0.823`

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

### 6. `AgentTasks/24h-publication-run-2026-07-12/GRAND_STRATEGY7_REPORT.md` [P4 — Minimally-doubled (Karsten–Wilczek) unitary walk (`d = 4`) — the honest minimum]

Score: `0.821`

```text
### P4 — Minimally-doubled (Karsten–Wilczek) unitary walk (`d = 4`) — the honest minimum

Do not try for one cone; achieve exactly **two**, related by a valley symmetry,
and package as a flavor doublet:
```
U₄(q) = factor qx α₁ · factor qy α₂ · factor qz α₃ · factor(θ_KW(q)) β,
θ_KW(q) chosen so that cos θ_KW = ζ·(cos qx + cos qy + cos qz − 1),   |ζ| tuned so the mass
vanishes at exactly q = 0 and one axis corner, and is nonzero at all others.
```
* Laurent-finite range one; retains a single-axis `C₄` symmetry and the
  valley-exchange symmetry mapping the two surviving cones.
* Predicted root set: **exactly two** zero-quasienergy cones (origin + one
  corner), everything else gapped. This is the sharp, provable "you cannot get
  one on the hypercubic strict-local involutory class, two is the minimum"
  statement — the cleanest guaranteed-true theorem in the batch.
```

### 7. `AgentTasks/context-packs/explicit-six-channel-coin-20260710-20260710-025001.md` [Integrated null-step quantum-walk strategy result]

Score: `0.814`

```text
## Integrated null-step quantum-walk strategy result

Integrated Aristotle job:

- `00dd71c5-70bd-477f-9b40-6770b2024bd9`:
  `null-edge-null-step-quantum-walk-strategy-20260623`.

New repo artifacts:

- `PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore`
- `AgentTasks/null-edge-null-step-quantum-walk-strategy-report-2026-06-23.md`

Proved declarations:

- `trace_Ua`
- `det_Ua`
- `IsQuasienergy`
- `isQuasienergy_iff_trace`
- `sinOmegaSq`
- `sinOmegaSq_eq`
- `coherenceSq`
- `tendsto_sin_mul_div`
- `coherenceSq_continuum`
- `coherenceSq_continuum_mE`

Scientific significance:

- This is the strongest current P2/P4 dynamics bridge. It gives a finite
  null-step quantum walk whose trace gives the lattice Dirac quasienergy
  relation and whose squared chirality coherence converges to `(m/E)^2` in the
  continuum limit.
- It directly supports the publication spine:
  `Plucker geometry -> observer-conditioned celestial qubit -> chirality
  coherence -> null-step dynamics -> stable channel sectors`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeNullStepQuantumWalkCore.lean
lake build PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore
```

Both checks passed after removing one unused simp-argument warning from the
returned proof.
```
```
```

### 8. `AgentTasks/context-packs/d4-finite-unitary-walk-20260710-20260710-021300.md` [Integrated null-step quantum-walk strategy result]

Score: `0.814`

```text
## Integrated null-step quantum-walk strategy result

Integrated Aristotle job:

- `00dd71c5-70bd-477f-9b40-6770b2024bd9`:
  `null-edge-null-step-quantum-walk-strategy-20260623`.

New repo artifacts:

- `PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore`
- `AgentTasks/null-edge-null-step-quantum-walk-strategy-report-2026-06-23.md`

Proved declarations:

- `trace_Ua`
- `det_Ua`
- `IsQuasienergy`
- `isQuasienergy_iff_trace`
- `sinOmegaSq`
- `sinOmegaSq_eq`
- `coherenceSq`
- `tendsto_sin_mul_div`
- `coherenceSq_continuum`
- `coherenceSq_continuum_mE`

Scientific significance:

- This is the strongest current P2/P4 dynamics bridge. It gives a finite
  null-step quantum walk whose trace gives the lattice Dirac quasienergy
  relation and whose squared chirality coherence converges to `(m/E)^2` in the
  continuum limit.
- It directly supports the publication spine:
  `Plucker geometry -> observer-conditioned celestial qubit -> chirality
  coherence -> null-step dynamics -> stable channel sectors`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeNullStepQuantumWalkCore.lean
lake build PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore
```

Both checks passed after removing one unused simp-argument warning from the
returned proof.
```
```
```

## Scoped paper hits

### 1. Dirac quantum walk on tetrahedra

Score: `0.808`
Zotero key: `8RZQA73D`
arXiv: `2404.09840`
DOI: `10.1103/physreva.110.042418`
URL: http://arxiv.org/abs/2404.09840

### 2. Dirac equation as a quantum walk over the honeycomb and triangular lattices

Score: `0.800`
Zotero key: `BMFTJTIS`
arXiv: `1803.01015`
DOI: `10.1103/PhysRevA.97.062111`
URL: https://www.zotero.org/19894138/items/BMFTJTIS

Abstract:

A discrete-time quantum walk (QW) is essentially an operator driving the evolution of a single particle on the lattice, through local unitaries. Some QWs admit a continuum limit, leading to well-known physics partial differential equations, such as the Dirac equation. We show that these simulation results need not rely on the grid: the Dirac equation in (2+1) dimensions can also be simulated, through local unitaries, on the honeycomb or the triangular lattice, both of interest in the study of quantum propagation on the nonrectangular grids, as in graphene-like materials. The latter, in particular, we argue, opens the door for a generalization of the Dirac equation to arbitrary discrete surfaces.

### 3. Connecting the discrete- and continuous-time quantum walks

Score: `0.798`
Zotero key: `XK9ZRDNJ`
DOI: `10.1103/physreva.74.030301`
URL: https://doi.org/10.1103/physreva.74.030301

### 4. Two-component Dirac-like Hamiltonian for generating quantum walk on one-, two- and three-dimensional lattices

Score: `0.795`
Zotero key: `MITSBCVI`
DOI: `10.1038/srep02829`
URL: https://www.zotero.org/19894138/items/MITSBCVI

Abstract:

From the unitary operator used for implementing two-state discrete-time quantum walk on one-, two- and three- dimensional lattice we obtain a two-component Dirac-like Hamiltonian. In particular, using different pairs of Pauli basis as position translation states we obtain three different form of Hamiltonians for evolution on one-dimensional lattice. We extend this to two- and three-dimensional lattices using different Pauli basis states as position translation states for each dimension and show that the external coin operation, which is necessary for one-dimensional walk is not a necessary requirement for a walk on higher dimensions but can serve as an additional resource to control the dynamics. The two-component Hamiltonian we present here for quantum walk on different lattices can serve as a general framework to simulate, control, and study the dynamics of quantum systems governed by Dirac-like Hamiltonian.

### 5. Relativistic effects and rigorous limits for discrete- and continuous-time quantum walks

Score: `0.793`
Zotero key: `QSB24VR9`
DOI: `10.1063/1.2759837`
URL: https://doi.org/10.1063/1.2759837

### 6. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.789`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`
