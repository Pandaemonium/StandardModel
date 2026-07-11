# Aristotle semantic context pack

Generated: 2026-07-10T18:33:37
Query: `changing lattice Dirac walk sampling interpolation Fourier strong L2 convergence position space PDE`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Luminal_Motion_Checkerboard_Research_Program.md` [3.1 The model and the theorem]

Score: `0.787`

```text
### 3.1 The model and the theorem

On a spacetime lattice with spacing $\varepsilon$ (units $\hbar = c = 1$),
paths move one step right or left per time step. The amplitude of a path
with $R$ direction reversals is $(i\varepsilon m)^R$. Feynman's claim
(rigorous since Skopenkov-Ustinov, c. 2020-22): the lattice path sum
converges, as $\varepsilon \to 0$ with endpoints fixed, to the exact 1+1D
Dirac propagator.
```

### 2. `Sources/Null_Edge_Causal_Graph_Bibliography.md` [B. Feynman checkerboard & Dirac quantum walks]

Score: `0.782`

```text
## B. Feynman checkerboard & Dirac quantum walks

- (1992) Quantum field theoretic behavior of a deterministic cellular automaton — `doi:10.1016/0550-3213(92)90628-O`
- (1994) Dirac and Weyl equations on a lattice as quantum cellular automata — `arXiv:hep-th/9304070`
- (1996) Discrete physics and the Dirac equation — `arXiv:hep-th/9603202`
- (1996) From quantum cellular automata to quantum lattice gases — `arXiv:quant-ph/9604003`
- (2010) Notes on The Feynman Checkerboard Problem — `arXiv:1012.1564`
- (2013) Two-component Dirac-like Hamiltonian for generating quantum walk on one-, two- and three-dimensional lattices — `doi:10.1038/srep02829`
- (2014) Path-integral solution of the one-dimensional Dirac quantum cellular automaton — `arXiv:1406.1021`
- (2015) Quantum walking in curved spacetime — `arXiv:1505.07023`
- (2016) Spin on a 4D Feynman Checkerboard — `arXiv:1610.01142`
- (2017) Fermion confinement via Quantum Walks in 2D+1 and 3D+1 spacetime — `arXiv:1612.08027`
- (2018) Discrete spacetime, quantum walks and relativistic wave equations — `arXiv:1802.03910`
- (2018) Dirac equation as a quantum walk over the honeycomb and triangular lattices — `arXiv:1803.01015`
- (2018) Electromagnetic lattice gauge invariance in two-dimensional discrete-time quantum walks — `doi:10.1103/physreva.98.032333`
- (2020) Quantum field theory from a quantum cellular automaton in one spatial dimension and a no-go theorem in higher dimensions — `arXiv:2006.08927`
- (2022) A discrete relativistic spacetime formalism for 1 + 1-QED with continuum limits — `arXiv:2103.13150`
```

### 3. `Sources/A_null-strand_Bohm–Bell_theory.md` [9. A fully explicit lattice version]

Score: `0.775`

```text
# 9. A fully explicit lattice version

Your original lattice intuition can be implemented particularly cleanly in (1+1) dimensions.

Let

[
a=c\tau,
]

where (a) is the spatial spacing and (\tau) the time step.

At each site, the wavefunction has two components,

[
\psi_n(x)=
\begin{pmatrix}
R_n(x)\
L_n(x)
\end{pmatrix}.
]

Apply a local mass coin

[
C_\theta
========
```

### 4. `AgentTasks/null-edge-codex-overnight-run-ledger-2026-06-23.md` [Literature cadence after null-step quantum-walk integration]

Score: `0.765`

```text
## Literature cadence after null-step quantum-walk integration

Ran a focused P2/P4 literature pass on Dirac quantum walks and quantum cellular
automata. Added to Zotero collection `9W59V3K9` and mirrored into Neo4j under
claim `null-edge-p2p4-null-step-qw-dirac-bridge`:

- `XK9ZRDNJ`: Frederick W. Strauch,
  *Connecting the discrete- and continuous-time quantum walks*,
  DOI `10.1103/physreva.74.030301`.
  Role: guardrail for the discrete/continuous quantum-walk-to-Dirac bridge.
- `QSB24VR9`: Frederick W. Strauch,
  *Relativistic effects and rigorous limits for discrete- and continuous-time
  quantum walks*, DOI `10.1063/1.2759837`.
  Role: guardrail for rigorous Dirac limits, localization, and relativistic
  effects in quantum walks.
- `BVJBTK8J`: Alessandro Bisio, Giacomo Mauro D'Ariano, Paolo Perinotti, and
  Alessandro Tosini,
  *Free quantum field theory from quantum cellular automata: derivation of Weyl,
  Dirac and Maxwell quantum cellular automata*, arXiv `1601.04832`.
  Role: prior art for QCA derivations of Weyl/Dirac dynamics in the relativistic
  limit.
- `KCQGEDJE`: Alessandro Bisio, Giacomo Mauro D'Ariano, Paolo Perinotti, and
  Alessandro Tosini,
  *Weyl, Dirac and Maxwell Quantum Cellular Automata*, arXiv `1601.04842`.
  Role: prior art and phenomenological guardrail for QCA dispersion.

Existing Zotero item `JZEJ4VXA` already covers D'Ariano-Mosco-Perinotti-Tosini
3+1 Dirac quantum walks.
```

### 5. `Sources/NullStrand_Lean_Roadmap.md` [Fourth proof batch]

Score: `0.762`

```text
### Fourth proof batch

- weak weighted angular PDE via Lax–Milgram;
- continuum spectral gap under uniform ellipticity;
- nonexplosion/ergodicity;
- foliated many-particle master theorem.
```

### 6. `NULL-EDGE_TARGET_AUDIENCE.md` [C. Prove a genuine propagation theorem]

Score: `0.760`

```text
### C. Prove a genuine propagation theorem

The one-step (O(a^2)) estimate in the present draft is not enough for this audience. Prove something of the form

[
\sup_{\substack{|k|\le K\na\le T}}
\left|
U_a(k)^n-e^{-inaH_z(k)}
\right|
\le C(K,\mu,T)a.
]

Then derive a position-space or wave-packet statement. Ideally also prove convergence for a suitable class of spatially varying initial data.

This is probably the single highest-value missing theorem. Quantum-walk researchers already have a developed continuum-limit literature, so the result should explicitly state whether it improves, specializes, or simply instantiates existing convergence machinery.
```

### 7. `PhysicsSM/NullStrand/ZigZag/QuantumWalk.lean` [quantumWalkOperator]

Score: `0.757`

```text
def quantumWalkOperator (a k μ : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.Ua a k μ

/-- One-step walk trace identity in terms of lattice data. -/
```

### 8. `Sources/Null_Edge_Key_Conjectures.md` [What the literature says]

Score: `0.756`

```text
### What the literature says

The relevant prior art is strong. Feynman's checkerboard is the historical
base case. D'Ariano-Mosco-Perinotti-Tosini (`JZEJ4VXA`) treat a 3+1
discrete-time Dirac quantum walk. Bisio-D'Ariano-Perinotti-Tosini
(`BVJBTK8J`, `KCQGEDJE`) connect quantum cellular automata with free-field and
Dirac dynamics. Arrighi-Nesme-Forets (`4F87TGCN`) derive the Dirac equation as
a quantum walk. Arnault-Perez-Arrighi-Farrelly (`PTHQB2RM`) connect
discrete-time walks to fermions in lattice gauge theory. Arrighi-Facchini-Forets
(`VHPN6G7D`) analyze discrete Lorentz covariance. Sato-Katori (`G7NXEZBU`)
provide a Dirac quantum-walk ultraviolet-cutoff guardrail. Arnault et al.
(`I7G53I6T`) give a relativistic quantum diffusion route. Strauch (`XK9ZRDNJ`,
`QSB24VR9`) is useful for early discrete-time quantum walk Dirac limits.
Bisio-D'Ariano-Tosini (`arXiv:1212.2839`) is especially relevant because it
sets the QCA/Dirac comparison as an operational convergence problem. The 2025
QCA fermion-doubling analysis (`arXiv:2505.07900`) makes full Brillouin-zone
species accounting a theorem obligation for this program.

So the novelty cannot be "Dirac from quantum walks." The novelty must be the
null-edge interface: Pluecker mass, observer-conditioned mixedness,
chirality-coherence mass ratio, and formalized finite theorem packaging.
The dynamic mass should be matched to the unnormalized determinant `det P_vis`,
not to `det rho_vis` except after an observer/frame normalization. This keeps
the P1 frame audit intact.
```

## Scoped paper hits

### 1. Dirac equation as a quantum walk over the honeycomb and triangular lattices

Score: `0.795`
Zotero key: `BMFTJTIS`
arXiv: `1803.01015`
DOI: `10.1103/PhysRevA.97.062111`
URL: https://www.zotero.org/19894138/items/BMFTJTIS

Abstract:

A discrete-time quantum walk (QW) is essentially an operator driving the evolution of a single particle on the lattice, through local unitaries. Some QWs admit a continuum limit, leading to well-known physics partial differential equations, such as the Dirac equation. We show that these simulation results need not rely on the grid: the Dirac equation in (2+1) dimensions can also be simulated, through local unitaries, on the honeycomb or the triangular lattice, both of interest in the study of quantum propagation on the nonrectangular grids, as in graphene-like materials. The latter, in particular, we argue, opens the door for a generalization of the Dirac equation to arbitrary discrete surfaces.

### 2. Locality properties of Neuberger's lattice Dirac operator

Score: `0.790`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 3. Discrete spacetime, quantum walks and relativistic wave equations

Score: `0.776`
Zotero key: `K87E7K68`
arXiv: `1802.03910`
DOI: `10.1103/PhysRevA.97.042131`
URL: https://www.zotero.org/19894138/items/K87E7K68

Abstract:

It has been observed that quantum walks on regular lattices can give rise to wave equations for relativistic particles in the continuum limit. In this paper, we define the three-dimensional discrete-time walk as a product of three coined one-dimensional walks. The factor corresponding to each one-dimensional walk involves two projection operators that act on an internal coin space; each projector is associated with either the “forward” or “backward” direction in that physical dimension. We show that the simple requirement that there is no preferred axis or direction along an axis—that is, that the walk be symmetric under parity transformations and steps along different axes of the cubic lattice be uncorrelated—leads, in the case of the simplest solution, to the requirement that the continuum limit of the walk is fully Lorentz-invariant. We show further that, in the case of a massive particle, this symmetry requirement necessitates the use of a four-dimensional internal space (as in the Dirac equation). The “coin flip” operation is generated by the parity transformation on the internal coin space, while the differences of the projection operators associated with each dimension must all anticommute. Finally, we discuss the leading correction to the continuum limit, and the possibility of distinguishing through experiment between the discrete random walk and the continuum-based Dirac equation as a description of fermion dynamics.

### 4. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.776`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 5. Equivalence of lattice operators and graph matrices

Score: `0.768`
Zotero key: `Z2DPSX6K`
arXiv: `2311.11320`
URL: https://arxiv.org/abs/2311.11320

Abstract:

We explore the relationship between lattice field theory and graph theory, placing special emphasis on the interplay between Dirac and scalar lattice operators and matrices within spectral graph theory. The paper introduces an anti-symmetrized adjacency matrix for cycle digraphs and directed paths, and relates graph Laplacians, Wilson terms, and lattice Dirac operators.
