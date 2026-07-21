# Aristotle semantic context pack

Generated: 2026-07-19T13:15:11
Query: `HNU anomalous Floquet Weyl micromotion winding zero pi quasienergy boundary topological invariant`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AutonomousLab/state/DECISIONS.md` [ADR-006: Promote anomalous Floquet topology as the primary 3+1 escape route]

Score: `0.843`

```text
## ADR-006: Promote anomalous Floquet topology as the primary 3+1 escape route

- Date: 2026-07-13
- Status: active research decision
- Decision: treat the full finite-depth micromotion, not only the endpoint
  Floquet matrix, as the next primary object for the strict 3+1 program.
  Published work exhibits a single Weyl fermion in a three-dimensional
  periodically driven lattice through nontrivial Floquet-unitary topology.
  Build a clean-room finite schedule and prove its zero/pi census, local Weyl
  charge, nonzero loop winding, and primitive-null factorization gate.
- Rationale: open-boundary directed-edge walks are exactly unitary, but the
  first three-dimensional Grover and Fourier coins carry exact or
  asymptotically light boundary sectors. An anomalous Floquet loop can
  compensate static Weyl charge through micromotion topology without
  outsourcing the partner to a spatial boundary. This uses, rather than
  suppresses, the project's discrete-time architecture and existing zero/pi
  bookkeeping.
- Mandatory gate: no claim that Null-Edge has a single 3+1 species is
  authorized until the loop invariant, full tagged census, locality,
  null-support factorization, and anomaly gates are all proved. Kill the route
  if primitive-null factorizations force zero winding.
- Design note:
  `AutonomousLab/work/NE-3PLUS1/CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md`.
```

### 2. `AgentTasks/context-packs/afpl-floquet-winding-design-20260713-122035.md` [Floquet charge bookkeeping]

Score: `0.829`

```text
## Floquet charge bookkeeping

Primary source: T. Bessho and M. Sato, "Nielsen-Ninomiya Theorem with Bulk
Topology: Duality in Floquet and Non-Hermitian Systems," arXiv:2006.04204,
Phys. Rev. Lett. 127, 196404 (2021), including the supplement.

The paper relates sums of local gapless-mode charges to a bulk dynamical
topological invariant and records a dimension-dependent sign for the
quasienergy-pi contribution. This supports the charge-sum architecture, but the
exact class-A versus symmetry-protected case and the zero/pi sign convention
must be copied from the displayed theorem before use in Paper B.

Controls:

- Higashikawa, Nakagawa, and Ueda, arXiv:1806.06868, explicitly realize a
  single Weyl fermion with a topologically nontrivial Floquet unitary. This is
  the positive control showing why the bulk invariant cannot simply be omitted.
- Gupta and Short, arXiv:2601.15885v2, explicitly report removal of conventional
  doublers and pseudo-doublers but retain additional low-energy solutions. The
  exact census must determine whether their tangent, global chirality, or
  residual modes supply the compensating structure.
```
```

### 3. `AgentTasks/24h-publication-run-2026-07-12/B_STRICT_LAURENT_SOURCE_AUDIT_2026-07-11.md` [Floquet charge bookkeeping]

Score: `0.828`

```text
## Floquet charge bookkeeping

Primary source: T. Bessho and M. Sato, "Nielsen-Ninomiya Theorem with Bulk
Topology: Duality in Floquet and Non-Hermitian Systems," arXiv:2006.04204,
Phys. Rev. Lett. 127, 196404 (2021), including the supplement.

The paper relates sums of local gapless-mode charges to a bulk dynamical
topological invariant and records a dimension-dependent sign for the
quasienergy-pi contribution. This supports the charge-sum architecture, but the
exact class-A versus symmetry-protected case and the zero/pi sign convention
must be copied from the displayed theorem before use in Paper B.

Controls:

- Higashikawa, Nakagawa, and Ueda, arXiv:1806.06868, explicitly realize a
  single Weyl fermion with a topologically nontrivial Floquet unitary. This is
  the positive control showing why the bulk invariant cannot simply be omitted.
- Gupta and Short, arXiv:2601.15885v2, explicitly report removal of conventional
  doublers and pseudo-doublers but retain additional low-energy solutions. The
  exact census must determine whether their tangent, global chirality, or
  residual modes supply the compensating structure.
```

### 4. `AgentTasks/aristotle-downloads/73a1d386-9910-493b-84b2-1867bdf6ef2e/output-final_aristotle/HNU_SINGLE_WEYL_RECONSTRUCTION.md` [11. Verdict]

Score: `0.827`

```text
## 11. Verdict

- **Construction:** the field-free HNU single-Weyl Floquet model is
  reconstructed exactly (§§1–5), with all decisive properties confirmed: finite
  depth-8 strictly-local unitary schedule; a single `ε=0` Weyl node at `Γ` of
  charge `+1`; a complete `𝕋³` census (no second `ε=0` cone; `ε=π` degeneracy is
  the whole boundary); nonzero loop winding `W = 1`; consistency with the
  Bessho–Sato generalized balance.
- **No-go / scoped incompatibility:** the winding is carried by spin-conditioned
  shifts and **vanishes** for any spin-blind (unconditional null shift +
  on-site turn) factorization. Whether HNU counts as "primitive-null" hinges
  entirely on whether projector-conditioned nearest-neighbour shifts are
  admitted as primitives (§7).
- **Missing formula:** one sign-convention correction (§1.3, §10).
```

### 5. `Sources/Null_Edge_References.md` [Anomalous-Floquet 3+1 route]

Score: `0.826`

```text
## Anomalous-Floquet 3+1 route

Anchor papers for the anomalous-Floquet route to a strict 3+1 single Weyl (AF0
landed `FloquetMicromotionSchedule`, OD5 `OpenDiamondCausalExhaustion`, AF-ladder
in flight). See `AutonomousLab/work/NE-3PLUS1/CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md`
and `CLAUDE_SKEPTIC_AF3_AF4_INVARIANT_PREANALYSIS_2026-07-13.md`. Clean-room the
theorem shape and invariants from the mathematical definitions; do not copy code.

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-HigashikawaNakagawaUeda2019` | `1806.06868` | Higashikawa, Nakagawa, Ueda, "Floquet chiral magnetic effect", Phys. Rev. Lett. 123, 066403 (2019) | Existence proof for the route: a single Weyl fermion (forbidden statically by Nielsen-Ninomiya) realized via a topologically nontrivial Floquet unitary; AZ-class classification of Floquet unitaries. Provenance for AF0-AF6. | INSPIREHEP VERIFIED 2026-07-13 |
| `TBD-BesshoSato2021` | `2006.04204` | Bessho, Sato, "Nielsen-Ninomiya Theorem with Bulk Topology: Duality in Floquet and Non-Hermitian Systems", Phys. Rev. Lett. 127, 196404 (2021) | The Nielsen-Ninomiya extension permitting bulk chiral fermions in dynamical systems via intrinsic bulk topology; theorem-shape for the AF no-go evasion. | INSPIREHEP VERIFIED 2026-07-13 |
| `TBD-RudnerLindnerBergLevin2013` | `1212.3324` | Rudner, Lindner, Berg, Levin, "Anomalous edge states and the bulk-edge correspondence for periodically-driven two dimensional systems", Phys. Rev. X 3, 031005 (2013) | Anomalous Floquet (AFAI) edge modes at 0 and pi persist with zero bulk Chern; the `W3` winding invariant and the boundary anomaly-inflow framing (open-diamond boundary-mode audit). | ARXIV VERIFIED 2026-07-13 |
| `TBD-UmerBomantaraGong2021` | `2009.09189` | Umer, Bomantara
```

### 6. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md` [Lateral move]

Score: `0.824`

```text
## Lateral move

The current no-go work asks a periodically updated null-edge system to behave
like a static lattice Hamiltonian. That discards the strongest extra structure
we possess: the full one-period micromotion.

The proposed pivot is to construct a topologically nontrivial Floquet unitary
loop in three spatial dimensions. Its low-quasienergy spectrum should contain
one Weyl crossing, while the compensating integer required by the static
Nielsen--Ninomiya balance is carried by the winding of the full time-dependent
unitary, not by a second low-energy Weyl cone.

This is not speculative precedent. Higashikawa, Nakagawa, and Ueda give a
periodically driven three-dimensional lattice realization of a single Weyl
fermion, explicitly forbidden in static systems, using a topologically
nontrivial Floquet unitary:

- S. Higashikawa, M. Nakagawa, and M. Ueda, *Floquet chiral magnetic effect*,
  arXiv:1806.06868, Phys. Rev. Lett. 123, 066403 (2019).
  <https://arxiv.org/abs/1806.06868>

Bessho and Sato formulate the corresponding extension of Nielsen--Ninomiya:
bulk chiral fermions can occur in dynamical systems because the dynamics has
an intrinsic bulk topology absent in the static theorem.

- T. Bessho and M. Sato, *Nielsen-Ninomiya Theorem with Bulk Topology: Duality
  in Floquet and Non-Hermitian Systems*, arXiv:2006.04204,
  Phys. Rev. Lett. 127, 196404 (2021).
  <https://arxiv.org/abs/2006.04204>

No external implementation is to be copied. The papers supply theorem shape,
topological invariants, and convention checks for a clean-room finite model.
```

### 7. `AutonomousLab/work/NE-3PLUS1/CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md` [Lateral move]

Score: `0.824`

```text
## Lateral move

The current no-go work asks a periodically updated null-edge system to behave
like a static lattice Hamiltonian. That discards the strongest extra structure
we possess: the full one-period micromotion.

The proposed pivot is to construct a topologically nontrivial Floquet unitary
loop in three spatial dimensions. Its low-quasienergy spectrum should contain
one Weyl crossing, while the compensating integer required by the static
Nielsen--Ninomiya balance is carried by the winding of the full time-dependent
unitary, not by a second low-energy Weyl cone.

This is not speculative precedent. Higashikawa, Nakagawa, and Ueda give a
periodically driven three-dimensional lattice realization of a single Weyl
fermion, explicitly forbidden in static systems, using a topologically
nontrivial Floquet unitary:

- S. Higashikawa, M. Nakagawa, and M. Ueda, *Floquet chiral magnetic effect*,
  arXiv:1806.06868, Phys. Rev. Lett. 123, 066403 (2019).
  <https://arxiv.org/abs/1806.06868>

Bessho and Sato formulate the corresponding extension of Nielsen--Ninomiya:
bulk chiral fermions can occur in dynamical systems because the dynamics has
an intrinsic bulk topology absent in the static theorem.

- T. Bessho and M. Sato, *Nielsen-Ninomiya Theorem with Bulk Topology: Duality
  in Floquet and Non-Hermitian Systems*, arXiv:2006.04204,
  Phys. Rev. Lett. 127, 196404 (2021).
  <https://arxiv.org/abs/2006.04204>

No external implementation is to be copied. The papers supply theorem shape,
topological invariants, and convention checks for a clean-room finite model.
```

### 8. `AutonomousLab/work/NE-3PLUS1/CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md` [AF4: generalized balance composition]

Score: `0.818`

```text
### AF4: generalized balance composition

First identify each local determinant-sign charge with the Chern charge on an
`S^2` enclosing that Weyl node. For HNU, compose that local charge with the
endpoint degree and the exact zero/pi census; do not pretend the extended pi
boundary is a collection of isolated nodes. For a genuinely per-gap schedule,
state the zero- and pi-gap balances separately. The static control has zero
winding and recovers cancellation. The anomalous witness has endpoint degree
one and permits one net zero-sector Weyl crossing while the global Floquet
topology and pi boundary carry the compensation. This is the decisive theorem.
```

## Scoped paper hits

### 1. Scattering theory of topological phases in discrete-time quantum walks

Score: `0.771`
Zotero key: `DEK4EJME`
arXiv: `1401.2673`
DOI: `10.1103/PhysRevA.89.042327`
URL: http://arxiv.org/abs/1401.2673

Abstract:

One-dimensional discrete-time quantum walks show a rich spectrum of topological phases that have so far been exclusively analysed in momentum space. In this work we introduce an alternative approach to topology which is based on the scattering matrix of a quantum walk, adapting concepts from time-independent systems. For gapped quantum walks, topological invariants at quasienergies 0 and π probe directly the existence of protected boundary states, while quantum walks with a non-trivial quasienergy winding have a discrete number of perfectly transmistting unidirectional modes. Our classification provides a unified framework that includes all known types of topology in one dimensional discrete-time quantum walks and is very well suited for the analysis of finite size and disorder effects. We provide a simple scheme to directly measure the topological invariants in an optical quantum walk experiment.

### 2. Symmetries, Topological Phases and Bound States in the One-Dimensional Quantum Walk

Score: `0.767`
Zotero key: `GBCXCI7E`
arXiv: `1208.2143`
DOI: `10.1103/PhysRevB.86.195414`
URL: http://arxiv.org/abs/1208.2143

Abstract:

Discrete-time quantum walks have been shown to simulate all known topological phases in one and two dimensions. Being periodically driven quantum systems, their topological description, however, is more complex than that of closed Hamiltonian systems. We map out the topological phases of the particle-hole symmetric one-dimensional discrete-time quantum walk. We find that there is no chiral symmetry in this system: its topology arises from the particle-hole symmetry alone. We calculate the Z2 \times Z2 topological invariant in a simple way that is consistent with a general definition for 1-dimensional periodically driven quantum systems. These results allow for a transparent interpretation of the edge states on a finite lattice via the the bulk-boundary correspondance. We find that the bulk Floquet operator does not contain all the information needed for the topological invariant. As an illustration to this statement, we show that in the split-step quantum walk, the edges between two bulks with the same Floquet operator can host topologically protected edge states.

### 3. Bulk--Boundary Correspondence for Chiral Symmetric Quantum Walks

Score: `0.767`
Zotero key: `9QPIHJEW`
arXiv: `1303.1199`
DOI: `10.1103/PhysRevB.88.121406`
URL: http://arxiv.org/abs/1303.1199

Abstract:

Discrete-time quantum walks (DTQW) have topological phases that are richer than those of time-independent lattice Hamiltonians. Even the basic symmetries, on which the standard classification of topological insulators hinges, have not yet been properly defined for quantum walks. We introduce the key tool of timeframes, i.e., we describe a DTQW by the ensemble of time-shifted unitary timestep operators belonging to the walk. This gives us a way to consistently define chiral symmetry (CS) for DTQW's. We show that CS can be ensured by using an "inversion symmetric" pulse sequence. For one-dimensional DTQW's with CS, we identify the bulk ZxZ topological invariant that controls the number of topologically protected 0 and pi energy edge states at the interfaces between different domains, and give simple formulas for these invariants. We illustrate this bulk--boundary correspondence for DTQW's on the example of the "4-step quantum walk", where tuning CS and particle-hole symmetry realizes edge states in various symmetry classes.

### 4. Nielsen-Ninomiya Theorem with Bulk Topology: Duality in Floquet and Non-Hermitian Systems

Score: `0.752`
Zotero key: `RCSSD8MZ`
arXiv: `2006.04204`
DOI: `10.1103/PhysRevLett.127.196404`
URL: http://arxiv.org/abs/2006.04204

Abstract:

The Nielsen-Ninomiya theorem is a fundamental theorem on the realization of chiral fermions in static lattice systems in high-energy and condensed matter physics. Here we extend the theorem in dynamical systems, which include the original Nielsen-Ninomiya theorem in the static limit. In contrast to the original theorem, which is a no-go theorem for bulk chiral fermions, the new theorem permits them due to bulk topology intrinsic to dynamical systems. The theorem is based on duality enabling a unified treatment of periodically driven systems and non-Hermitian ones. We also present the extended theorem for non-chiral gapless fermions protected by symmetry. Finally, as an application of our theorem and duality, we predict a new type of chiral magnetic effect -- the non-Hermitian chiral magnetic skin effect.

### 5. Complete homotopy invariants for translation invariant symmetric quantum walks on a chain

Score: `0.748`
Zotero key: `RS6P7CBT`
arXiv: `1804.04520`
DOI: `10.22331/q-2018-09-24-95`
URL: http://arxiv.org/abs/1804.04520

Abstract:

We provide a classification of translation invariant one-dimensional quantum walks with respect to continuous deformations preserving unitarity, locality, translation invariance, a gap condition, and some symmetry of the tenfold way. The classification largely matches the one recently obtained (arXiv:1611.04439) for a similar setting leaving out translation invariance. However, the translation invariant case has some finer distinctions, because some walks may be connected only by breaking translation invariance along the way, retaining only invariance by an even number of sites. Similarly, if walks are considered equivalent when they differ only by adding a trivial walk, i.e., one that allows no jumps between cells, then the classification collapses also to the general one. The indices of the general classification can be computed in practice only for walks closely related to some translation invariant ones. We prove a completed collection of simple formulas in terms of winding numbers of band structures covering all symmetry types. Furthermore, we determine the strength of the locality conditions, and show that the continuity of the band structure, which is a minimal requirement for topological classifications in terms of winding numbers to make sense, implies the compactness of the commutator of the walk with a half-space projection, a condition which was also the basis of the general theory. In order to apply the theory to the joining of large but finite bulk pieces, one needs to determine the asymptotic behaviour of a stationary Schrödinger equation. We show exponential behaviour, and give a practical method for computing the decay constants.
