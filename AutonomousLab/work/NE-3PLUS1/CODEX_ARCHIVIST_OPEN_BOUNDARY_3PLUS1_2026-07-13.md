# Archivist map: open-boundary 3+1 route

Date: 2026-07-13
Role: Codex / Archivist
Work item: `LAB-BOOTSTRAP-001`
Route artifact: `CODEX_OPEN_CAUSAL_DIAMOND_ROUTE_2026-07-13.md`

## Question

Can an open causal diamond evade the periodic-torus species obstruction while
retaining exact local unitary null propagation, and what known results constrain
that attempt?

## Primary-source map

### 1. Non-torus spectral graphs can change the bulk species count

Yumoto and Misumi identify lattice Dirac operators with graph matrices and use
spectral graph theory to count zero eigenvalues on non-torus and non-regular
lattices. Their four-dimensional hyperball example is direct prior art for the
open-causal-diamond route.

- Jun Yumoto and Tatsuhiro Misumi, *Lattice fermions as spectral graphs*,
  arXiv:2112.13501, JHEP 02 (2022) 104.
  <https://arxiv.org/abs/2112.13501>
- Jun Yumoto and Tatsuhiro Misumi, *Equivalence of lattice operators and graph
  matrices*, arXiv:2311.11320.
  <https://arxiv.org/abs/2311.11320>

Use: supports the Euclidean/spectral claim that changing topology from a torus
to an open contractible graph can remove bulk zero multiplicity. It does not
establish a unitary real-time walk, a Lorentzian mass shell, or the absence of
boundary species.

### 2. Directed-edge scattering gives the right unitarity architecture

Joye studies unitary scattering quantum walks on arbitrary graphs. States live
on graph edges and each vertex carries a scattering matrix. This is the exact
architectural class suggested by the null-billiard seed: propagation traverses
an edge and all mixing occurs through local vertex scattering.

- Alain Joye, *Unitary and Open Scattering Quantum Walks on Graphs*,
  arXiv:2409.08428, accepted in Reviews in Mathematical Physics.
  <https://arxiv.org/abs/2409.08428>

Use: replace the path-specific permutation by a general theorem schema. For a
finite directed-edge state space, prove global unitarity from the block-local
unitarity of each vertex scattering matrix. Boundary vertices use smaller
unitary blocks; no stationary boundary step is required.

Convention warning: Joye's term "open scattering quantum walk" also includes
quantum-channel dynamics. Our target is the closed, unitary finite-graph class
with an open spatial boundary. Do not confuse the two uses of "open."

### 3. A reflecting boundary can carry protected zero and pi modes

Discrete-time walks have independent topological data at quasienergies zero
and pi. Bulk-boundary correspondence can force protected edge states even when
the finite bulk update looks innocuous.

- Janos K. Asboth and Hideaki Obuse, *Bulk--Boundary Correspondence for Chiral
  Symmetric Quantum Walks*, arXiv:1303.1199, Phys. Rev. B 88, 121406(R) (2013).
  <https://arxiv.org/abs/1303.1199>
- B. Tarasinski, J. K. Asboth, and J. P. Dahlhaus, *Scattering theory of
  topological phases in discrete-time quantum walks*, arXiv:1401.2673,
  Phys. Rev. A 89, 042327 (2014).
  <https://arxiv.org/abs/1401.2673>
- K. Bessho and M. Sato, *Nielsen-Ninomiya Theorem with Bulk Topology: Duality
  in Floquet and Non-Hermitian Systems*, arXiv:2006.04204,
  Phys. Rev. Lett. 127, 196404 (2021).
  <https://arxiv.org/abs/2006.04204>

Use: the decisive census is not only the bulk eigenvalue multiplicity. It must
classify zero and pi boundary eigenspaces and distinguish intrinsic spinor
multiplicity from distinct species. The finite update sequence, not only its
one-period matrix, may carry the relevant invariant.

## The new theorem ladder

1. `DirectedEdgeGlobalUnitary`: on a finite graph, a direct sum of unitary
   incoming-to-outgoing vertex scattering maps induces a unitary update on the
   directed-edge Hilbert space.
2. `PathBilliardNoBoundaryLocalization`: for the reflection-only path seed,
   every eigenvector has equal coordinate norm; zero and pi modes, when
   present, are global cycle modes rather than boundary-localized states.
3. `OpenDiamondZeroPiBoundaryCensus`: for the first 3+1 open diamond and an
   explicit local coin, compute the full zero/pi eigenspaces and boundary mass
   of every eigenvector.
4. `BulkRestrictionDiracTangent`: on vertices farther than one update range
   from the boundary, the low-momentum/eigenmode restriction has the intended
   Dirac tangent with the displayed normalization.
5. `ExhaustionBoundaryEscape`: along nested diamonds, prove either that all
   unwanted boundary modes escape every fixed compact interior region or that
   a nonzero boundary species remains. The second outcome kills the route.

## Kill conditions

- A local unitary vertex completion necessarily carries an ungappable zero or
  pi boundary mode with nonvanishing interior weight in the exhaustion limit.
- The only boundary coins avoiding such a mode destroy chirality, gauge
  covariance, primitive null support, or the Dirac tangent.
- The Euclidean single-valley count cannot be connected to the spectrum of the
  real-time unitary update without inserting the desired species projection.
- The boundary condition supplies an unphysical preferred frame that survives
  the exhaustion limit.

## Archivist recommendation

Prioritize the directed-edge global-unitarity theorem and a complete zero/pi
boundary census before further open-hyperball zero counting. The latter is
already literature-supported; the former is the new scientific bottleneck.
Treat the 1+1 null billiard as an anti-vacuity and API fixture, not evidence that
the 3+1 boundary problem is solved.

## Same-cycle oracle disposition

The clean-room oracle `Scripts/experiments/directed_edge_open_diamond.py`
implemented Joye's directed-edge architecture on finite L1 balls in `Z^3`.
It found:

- exact global unitarity for every tested local unitary block;
- extensive exact zero/pi boundary sectors for the Grover coin;
- no exact zero/pi root for the Fourier coin at radii 2--5, but near-zero and
  near-pi modes with about 92--95 percent boundary weight, including a phase
  distance near `5.1e-6` at radius 5.

This kills the Grover coin as the intended 3+1 completion and makes the Fourier
coin a likely asymptotically light boundary control, not a positive result.
The literature warning about bulk-boundary transfer is therefore active in the
first concrete three-dimensional experiment.

## Retrieval record

- Neo4j semantic abstract searches were run for open-boundary unitary walks,
  spectral-graph doubling, directed-edge scattering, and Nielsen--Ninomiya
  boundary/anomaly constraints.
- Existing graph records found: arXiv:2112.13501, 2311.11320, 1303.1199,
  1401.2673, and 2006.04204.
- arXiv:2409.08428 was verified directly from the current arXiv record; it is a
  candidate for Zotero/Neo4j ingestion after the canonical-ID duplicate check.
