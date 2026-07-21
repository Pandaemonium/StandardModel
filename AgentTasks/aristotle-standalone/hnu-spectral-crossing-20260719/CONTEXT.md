# Aristotle semantic context pack

Generated: 2026-07-19T18:13:33
Query: `unitary family eigenvalue crossing zero pi quasienergy global spectral gap compact Brillouin torus`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/24h-publication-run-2026-07-12/RECIPROCAL_EMBEDDING_AUDIT_REPORT.md` [1. Independent verification of the 2×2 oracle (all PASS)]

Score: `0.810`

```text
`527²+336²=625²`), argument
  `≠ 0, π`. So neither a 0‑ nor a π‑quasienergy crossing survives at the old
  corner. The two nonzero determinants `2304/625` and `196/625` are the exact
  witnesses.

**Conclusion of §1:** the two‑band fixture is exactly determinant‑one,
quadratically flat at the intended origin, finite‑Laurent, unitary on the
torus, and gaps the old corner at both 0 and π. Every published number holds.

---
```

### 2. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/CODEX_OPEN_CAUSAL_DIAMOND_ROUTE_2026-07-13.md` [First 3+1 directed-edge oracle]

Score: `0.799`

```text
## First 3+1 directed-edge oracle

`Scripts/experiments/directed_edge_open_diamond.py` constructs the spatial L1
ball in `Z^3`, places amplitudes on all directed nearest-neighbor edges, and
builds the global update from a unitary incoming-to-outgoing scattering block
at each vertex. Every update traverses one edge; there is no boundary waiting
state. This is an external numerical oracle, not a proof or a Dirac-tangent
construction.

The first census is discriminating:

- Global unitarity holds to numerical precision for both tested local coin
  families at radii 1 through 5.
- The Grover coin fails decisively. At radius 2 it has 13 exact zero and 13
  exact pi modes; at radius 3 it has 53 of each. The compressed boundary
  projector has eigenvalue one in both eigenspaces, proving numerically that
  each contains a fully boundary-supported direction.
- A degree-adapted discrete-Fourier coin removes exact zero/pi modes at radii
  2 through 5, but does not clear the boundary gate. Its nearest zero and pi
  modes carry roughly 92--95 percent boundary weight. At radius 5 their phase
  distance is about `5.1e-6`, so the absence of an exact finite-size root is
  not ev
...[truncated]
```

### 3. `AutonomousLab/work/NE-3PLUS1/CODEX_OPEN_CAUSAL_DIAMOND_ROUTE_2026-07-13.md` [First 3+1 directed-edge oracle]

Score: `0.799`

```text
## First 3+1 directed-edge oracle

`Scripts/experiments/directed_edge_open_diamond.py` constructs the spatial L1
ball in `Z^3`, places amplitudes on all directed nearest-neighbor edges, and
builds the global update from a unitary incoming-to-outgoing scattering block
at each vertex. Every update traverses one edge; there is no boundary waiting
state. This is an external numerical oracle, not a proof or a Dirac-tangent
construction.

The first census is discriminating:

- Global unitarity holds to numerical precision for both tested local coin
  families at radii 1 through 5.
- The Grover coin fails decisively. At radius 2 it has 13 exact zero and 13
  exact pi modes; at radius 3 it has 53 of each. The compressed boundary
  projector has eigenvalue one in both eigenspaces, proving numerically that
  each contains a fully boundary-supported direction.
- A degree-adapted discrete-Fourier coin removes exact zero/pi modes at radii
  2 through 5, but does not clear the boundary gate. Its nearest zero and pi
  modes carry roughly 92--95 percent boundary weight. At radius 5 their phase
  distance is about `5.1e-6`, so the absence of an exact finite-size root is
  not ev
...[truncated]
```

### 4. `Sources/Null_Edge_Stay_Update_Literature_and_Proof_Agenda_2026-07-19.md` [A. Massive global zero/pi gap]

Score: `0.797`

```text
### A. Massive global zero/pi gap

Prove that the nontrivial Pluecker mass coin gaps both `+1` and `-1`
quasienergies over the entire closed Brillouin cube. The key intermediate
statement is a parity census for the HNU endpoint:

```text
endpoint(k) = endpoint(-k)
iff k is the origin or lies on the Brillouin boundary.
```

An exact SU(2) block-determinant reduction then appears to force any massive
zero/pi crossing onto those two loci, where a mass angle strictly between zero
and pi excludes it. This is currently oracle-supported and must not be cited as
a theorem until the Lean proof lands.
```

## Scoped paper hits

### 1. Scattering theory of topological phases in discrete-time quantum walks

Score: `0.735`
Zotero key: `DEK4EJME`
arXiv: `1401.2673`
DOI: `10.1103/PhysRevA.89.042327`
URL: http://arxiv.org/abs/1401.2673

Abstract:

One-dimensional discrete-time quantum walks show a rich spectrum of topological phases that have so far been exclusively analysed in momentum space. In this work we introduce an alternative approach to topology which is based on the scattering matrix of a quantum walk, adapting concepts from time-independent systems. For gapped quantum walks, topological invariants at quasienergies 0 and π probe directly the existence of protected boundary states, while quantum walks with a non-trivial quasienergy winding have a discrete number of perfectly transmistting unidirectional modes. Our classification provides a unified framework that includes all known types of topology in one dimensional discrete-time quantum walks and is very well suited for the analysis of finite size and disorder effects. We provide a simple scheme to directly measure the topological invariants in an optical quantum walk experiment.

### 2. Complete homotopy invariants for translation invariant symmetric quantum walks on a chain

Score: `0.733`
Zotero key: `RS6P7CBT`
arXiv: `1804.04520`
DOI: `10.22331/q-2018-09-24-95`
URL: http://arxiv.org/abs/1804.04520

Abstract:

We provide a classification of translation invariant one-dimensional quantum walks with respect to continuous deformations preserving unitarity, locality, translation invariance, a gap condition, and some symmetry of the tenfold way. The classification largely matches the one recently obtained (arXiv:1611.04439) for a similar setting leaving out translation invariance. However, the translation invariant case has some finer distinctions, because some walks may be connected only by breaking translation invariance along the way, retaining only invariance by an even number of sites. Similarly, if walks are considered equivalent when they differ only by adding a trivial walk, i.e., one that allows no jumps between cells, then the classification collapses also to the general one. The indices of the general classification can be computed in practice only for walks closely related to some translation invariant ones. We prove a completed collection of simple formulas in terms of winding numbers of band structures covering all symmetry types. Furthermore, we determine the strength of the locality conditions, and show that the continuity of the band structure, which is a m
...[truncated]

### 3. Compactly-supported Wannier functions and algebraic $K$-theory

Score: `0.732`
Zotero key: `SH5N2H8Q`
arXiv: `1608.04696`
DOI: `10.1103/PhysRevB.95.115309`
URL: http://arxiv.org/abs/1608.04696

Abstract:

In a tight-binding lattice model with $n$ orbitals (single-particle states) per site, Wannier functions are $n$-component vector functions of position that fall off rapidly away from some location, and such that a set of them in some sense span all states in a given energy band or set of bands; compactly-supported Wannier functions are such functions that vanish outside a bounded region. They arise not only in band theory, but also in connection with tensor-network states for non-interacting fermion systems, and for flat-band Hamiltonians with strictly short-range hopping matrix elements. In earlier work, it was proved that for general complex band structures (vector bundles) or general complex Hamiltonians---that is, class A in the ten-fold classification of Hamiltonians and band structures---a set of compactly-supported Wannier functions can span the vector bundle only if the bundle is topologically trivial, in any dimension $d$ of space, even when use of an overcomplete set of such functions is permitted. This implied that, for a free-fermion tensor network state with a non-trivial bundle in class A, any strictly short-range parent Hamiltonian must be gapless
...[truncated]
