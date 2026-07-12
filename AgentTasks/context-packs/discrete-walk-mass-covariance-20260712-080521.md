# Aristotle semantic context pack

Generated: 2026-07-12T08:05:46
Query: `exact discrete quantum walk covariance Pluecker mass coin chiral phase parity momentum reversal`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Key_Conjectures.md` [What we would like to show]

Score: `0.812`

```text
facts.

Publication-level statement:

> In a sourced class of finite null-step quantum walks, the chirality-flip
> parameter determines the Dirac mass in the continuum scaling limit. The
> finite Pluecker/observer-channel mass identities are the static invariant
> readouts of the same null-step dynamics.
```

### 2. `Sources/Null_Edge_Key_Conjectures.md` [What we would like to show]

Score: `0.805`

```text
### What we would like to show

Near-term theorem targets:

```lean
no_2x2_anticommutant_of_all_pauli
mass_term_forces_LR_doubling
isotropicFlip_iff_scalar
flipGenerator_scalarPart_eq_diracMass
flipGenerator_l1_vectorPart_breaks_isotropy
celestialBoost_acts_by_sl2_on_coin
scalarFlip_is_sl2_invariant
walkVisibleMomentum_det_eq_massSq
walkVisibleMomentum_det_sl2_invariant
walkNormalizedCoin_det_eq_massRatioSq
nullStepWalk_unitary_for_all_momenta
nullStepWalk_dispersion_expansion_dirac
quasienergy_smallMomentum_eq_sqrt_m2_plus_p2
walkProjectorCoherence_eq_massRatio
checkerboardTransfer_sq_eq_kgRecurrence
qwContinuumLimit_matches_diracHamiltonian
universality_under_small_unitary_perturbations
diracFixedPoint_stable_under_isotropyPreserving_perturbations
properTimePurityRate_eq_flipFrequency
```

Analysis-level and frontier targets:

```lean
nullStepWalk_scalingLimit_eq_diracPropagator
bandLimitedNullWalk_convergesToDirac
nullStepWalk_doublerBranches_at_BZ_fixedPoints
brillouinZone_coneCensus
decoheredFlip_static_variance_eq_integrated_autocorr
causalSetNullWalk_propagator_lorentzInvariant
kahlerDirac_doublers_vs_generations_disjoint
```

The doubler/generation bookkeeping is a gate, not a side note. Lattice and walk
models can produce Brillouin-zone or staggered/Kahler-Dirac multiplicities,
while the internal `H_3(O)` story supplies a separate candidate family
multiplicity. Before dynamics and generation claims are presented together, the
program must show that these multiplicities are disjoint, or else state a no-go
explaining which apparent generations are discretization artifacts.

Publication-level statement:

> In a sourced class of finite null-step quantum walks, the chirality-flip
> parameter determines the Dirac mass in the continuum scaling limit. The
> finite Plue
```

### 3. `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md` [11. The Lean anchor table]

Score: `0.804`

```text
5)` and massless controls. Fixed-momentum finite symbol only; no Trotter/PDE/propagator limit and no second-derivative claim |
| 9 | `exact_lattice_dispersion`, `mass_is_zero_momentum_quasienergy`, `zero_momentum_xPlus_eigenvector`, `zero_momentum_xMinus_eigenvector`, `exact_quantum_walk_dispersion_verdict` | `NullEdge/ExactQuantumWalkDispersion.lean` | M, self-guarded (in-file pins) | **exact lattice spectrum**: `cos(omega a)=cos(k a)cos(m a)` and at zero momentum the two exact eigenphases are `exp(-i m a)` and `exp(+i m a)`. The turn parameter is the principal-branch positive quasienergy; quasienergy periodicity is explicit |
| 9 | `checkerboard_channel_action_total`, `checkerboard_channel_phase_eq_carrier`, `three_four_five_channel_action_witness` | `NullEdge/FourChannelPathActionCapstone.lean` | M, self-guarded (in-file pins) | **carrier-derived finite action budget**: on every real checkerboard state, the expectations of `Q_A,Q_C,4Q_T,4E_#` sum exactly to the expectation of `4D#D`; the on-shell `(5,3,4)` witness gives `(64,0,64,0)` and total `128`. State-level, not yet a local action assignment on each history |
| 9 | `historyAction_append`, `historyPhase_append`, `flatCheckerboard_action`, `quarterTurn_history_phase`, `checkerboardAmplitude_eq_corner_power`, `history_local_four_channel_action_verdict` | `NullEdge/HistoryLocalFourChannelAction.lean` | M, self-guarded (in-file pins) | **history-local action and phase**: channel-labelled event actions add and phases multiply under concatenation; the flat checkerboard has one aperture event per step, turn count equal to direction reversals, and zero closure/soldering counts; the quarter-turn action gives exactly `i^r` and `(i eps m)^r`, with a nonzero one-turn witness. General four weights remain input; only the flat
```

### 4. `NULL-EDGE_TARGET_AUDIENCE.md` [E. Either complete the (3+1) construction or leave it out of the headline]

Score: `0.804`

```text
### E. Either complete the (3+1) construction or leave it out of the headline

A (3+1) result would markedly raise the ceiling. The natural comparison is the tetrahedral Dirac walk of Nzongani and collaborators. Your construction should answer:

* Can the mass coin be generated from local Plücker data?
* Is the overall update exactly unitary?
* Does it recover the correct Dirac matrices and speed normalization?
* Does it avoid or classify the normalization obstruction you found?
* Is it equivalent to their walk under a local basis change, or a genuinely different family?
* What becomes of the phase of the complex Plücker coordinate?

If these questions are not resolved, keep the tetrahedral material to a short outlook in Paper I.
```

### 5. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P4-F. Luminal checkerboard dynamics, formalized]

Score: `0.800`

```text
### P4-F. Luminal checkerboard dynamics, formalized

Core claim. Relativistic `1+1` propagation has an exact finite description by
lightlike microscopic steps with a corner chirality-flip amplitude, with the
Klein-Gordon-style recurrence appearing after squaring the first-order transfer.

Banked Lean. `PhysicsSM.Spinor.Checkerboard` and
`PhysicsSM.Spinor.CheckerboardDynamics` (trusted): history counts, corner-weight
powers, last-step recursion, iterated transfer-operator evolution, finite
Klein-Gordon-style recurrence. Kernel-clean closed forms in
`PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle`.

Remaining. This candidate can either stand alone or merge with the existing
`Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md` advance note.
The higher-dimensional universality statement is explicitly out of scope here
(it belongs to the dynamics program, not a banked paper).

New dynamics target. The Pro critique identifies a discrete null-step quantum
walk as the cleanest bridge from checkerboard kinematics to chirality coherence:

```text
U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x),
cos(omega a) = cos(k a) cos(mu a).
```

For a nondegenerate eigenstate, the `z`-chirality coherence tends in the
continuum limit to `mu / sqrt(k^2 + mu^2) = m/E`. This should become the
combined P2/P4 dynamics target: luminal conditional shifts, chirality-flip
amplitude, Dirac dispersion, and observer-visible `m/E` in one finite model.
This is the strongest proposed bridge from the kinematic Plucker theorem to a
real dynamics paper, because it puts the lightlike shift, chirality flip,
dispersion relation, and proper-time ratio in one auditable finite model.

Sharpened P4 split. The publishable near-term claim should be the homogeneous
fixed-point theorem, not the full
```

### 6. `AgentTasks/context-packs/nullstrand-wave5-selected-dynamics-20260625-161802.md` [P4. Luminal checkerboard dynamics, formalized]

Score: `0.798`

```text
### P4. Luminal checkerboard dynamics, formalized

Core claim. Relativistic `1+1` propagation has an exact finite description by
lightlike microscopic steps with a corner chirality-flip amplitude, with the
Klein-Gordon-style recurrence appearing after squaring the first-order transfer.

Banked Lean. `PhysicsSM.Spinor.Checkerboard` and
`PhysicsSM.Spinor.CheckerboardDynamics` (trusted): history counts, corner-weight
powers, last-step recursion, iterated transfer-operator evolution, finite
Klein-Gordon-style recurrence. Kernel-clean closed forms in
`PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle`.

Remaining. This candidate can either stand alone or merge with the existing
`Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md` advance note.
The higher-dimensional universality statement is explicitly out of scope here
(it belongs to the dynamics program, not a banked paper).

New dynamics target. The Pro critique identifies a discrete null-step quantum
walk as the cleanest bridge from checkerboard kinematics to chirality coherence:

```text
U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x),
cos(omega a) = cos(k a) cos(mu a).
```

For a nondegenerate
...[truncated]
```
```

### 7. `AgentTasks/context-packs/nullstrand-wave4-g1-audit-20260625-150653.md` [What we have formally proven]

Score: `0.795`

```text
### What we have formally proven

The dynamics side has several anchors:

- `PhysicsSM.Spinor.Checkerboard` and
  `PhysicsSM.Spinor.CheckerboardDynamics` give trusted finite checkerboard
  combinatorics and recurrence/dynamics theorems.
- `PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle` adds draft
  endpoint closed forms.
- `PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore` proves a finite
  null-step walk core: traces/determinants, quasienergy relation, and a
  continuum coherence expression matching `m/E` in the small-parameter limit.
- `PhysicsSM.Draft.NullEdgeQWUnitarity` proves the relevant Pauli-rotation
  gates and one-step walk are unitary.
- `PhysicsSM.Draft.NullEdgeQWExpProvenance` proves the Euler closed-form gates
  match exponential provenance for `Rz` and `Rx`.
- `PhysicsSM.Draft.NullEdgeP2WalkProjectorCoherenceBridge` connects the walk
  coherence ratio to the P2 mass-ratio/coherence theorem.
- `PhysicsSM.Draft.NullEdgeObserverPartialTrace` proves that finite hidden
  partial trace commutes with visible congruence and that determinant-one
  visible congruence preserves the unnormalized determinant.
- `PhysicsSM.Draft.NullEdgeP4VisibleDetInvariant` isolates the same P4
  invariant at the `2 x 2` visible-matrix level: determinant-one visible
  congruence preserves `det(P_vis)`, while trace normalization turns the
  determinant into the frame-relative squared readout.
- `PhysicsSM.Draft.NullEdgeP4PauliNo2x2Mass` proves the single-Weyl no-go: a
  `2 x 2` complex matrix anticommuting with all three Pauli matrices is zero,
  so an invertible Clifford mass term forces an `L plus R` doubling.
- `PhysicsSM.Draft.NullEdgeP4ScalarFlipIsotropy` proves the isotropy half of
  the fixed-point package: a flip generator commuting with all Pauli directions
  has no
```

### 8. `Sources/Null_Edge_Key_Conjectures.md` [What we have formally proven]

Score: `0.794`

```text
### What we have formally proven

The dynamics side has several anchors:

- `PhysicsSM.Spinor.Checkerboard` and
  `PhysicsSM.Spinor.CheckerboardDynamics` give trusted finite checkerboard
  combinatorics and recurrence/dynamics theorems.
- `PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle` adds draft
  endpoint closed forms.
- `PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore` proves a finite
  null-step walk core: traces/determinants, quasienergy relation, and a
  continuum coherence expression matching `m/E` in the small-parameter limit.
- `PhysicsSM.Draft.NullEdgeQWUnitarity` proves the relevant Pauli-rotation
  gates and one-step walk are unitary.
- `PhysicsSM.Draft.NullEdgeQWExpProvenance` proves the Euler closed-form gates
  match exponential provenance for `Rz` and `Rx`.
- `PhysicsSM.Draft.NullEdgeP2WalkProjectorCoherenceBridge` connects the walk
  coherence ratio to the P2 mass-ratio/coherence theorem.
- `PhysicsSM.Draft.NullEdgeObserverPartialTrace` proves that finite hidden
  partial trace commutes with visible congruence and that determinant-one
  visible congruence preserves the unnormalized determinant.
- `PhysicsSM.Draft.NullEdgeP4VisibleDetInvariant` isolates the same P4
  invariant at the `2 x 2` visible-matrix level: determinant-one visible
  congruence preserves `det(P_vis)`, while trace normalization turns the
  determinant into the frame-relative squared readout.
- `PhysicsSM.Draft.NullEdgeP4PauliNo2x2Mass` proves the single-Weyl no-go: a
  `2 x 2` complex matrix anticommuting with all three Pauli matrices is zero,
  so an invertible Clifford mass term forces an `L plus R` doubling.
- `PhysicsSM.Draft.NullEdgeP4ScalarFlipIsotropy` proves the isotropy half of
  the fixed-point package: a flip generator commuting with all Pauli directions
  has no
```

## Scoped paper hits

### 1. Discrete spacetime, quantum walks and relativistic wave equations

Score: `0.796`
Zotero key: `K87E7K68`
arXiv: `1802.03910`
DOI: `10.1103/PhysRevA.97.042131`
URL: https://www.zotero.org/19894138/items/K87E7K68

Abstract:

It has been observed that quantum walks on regular lattices can give rise to wave equations for relativistic particles in the continuum limit. In this paper, we define the three-dimensional discrete-time walk as a product of three coined one-dimensional walks. The factor corresponding to each one-dimensional walk involves two projection operators that act on an internal coin space; each projector is associated with either the “forward” or “backward” direction in that physical dimension. We show that the simple requirement that there is no preferred axis or direction along an axis—that is, that the walk be symmetric under parity transformations and steps along different axes of the cubic lattice be uncorrelated—leads, in the case of the simplest solution, to the requirement that the continuum limit of the walk is fully Lorentz-invariant. We show further that, in the case of a massive particle, this symmetry requirement necessitates the use of a four-dimensional internal space (as in the Dirac equation). The “coin flip” operation is generated by the parity transformation on the internal coin space, while the differences of the projection operators associated with each dimension must all anticommute. Finally, we discuss the leading correction to the continuum limit, and the possibility of distinguishing through experiment between the discrete random walk and the continuum-based Dirac equation as a description of fermion dynamics.

### 2. Quantum simulation of quantum relativistic diffusion via quantum walks

Score: `0.790`
Zotero key: `I7G53I6T`
arXiv: `1911.09791v2`
URL: http://arxiv.org/abs/1911.09791v2

Abstract:

Discrete-time quantum walks with temporal noise on the coin admit a continuum limit described by a Lindblad equation with Dirac Hamiltonian part and chirality-flip / chirality-dependent phase-flip jumps. Useful prior art for the null-edge chirality-coherence and quantum-walk dynamics lane.

### 3. Connecting the discrete- and continuous-time quantum walks

Score: `0.786`
Zotero key: `XK9ZRDNJ`
DOI: `10.1103/physreva.74.030301`
URL: https://doi.org/10.1103/physreva.74.030301

### 4. Bulk--Boundary Correspondence for Chiral Symmetric Quantum Walks

Score: `0.782`
Zotero key: `9QPIHJEW`
arXiv: `1303.1199`
DOI: `10.1103/PhysRevB.88.121406`
URL: http://arxiv.org/abs/1303.1199

Abstract:

Discrete-time quantum walks (DTQW) have topological phases that are richer than those of time-independent lattice Hamiltonians. Even the basic symmetries, on which the standard classification of topological insulators hinges, have not yet been properly defined for quantum walks. We introduce the key tool of timeframes, i.e., we describe a DTQW by the ensemble of time-shifted unitary timestep operators belonging to the walk. This gives us a way to consistently define chiral symmetry (CS) for DTQW's. We show that CS can be ensured by using an "inversion symmetric" pulse sequence. For one-dimensional DTQW's with CS, we identify the bulk ZxZ topological invariant that controls the number of topologically protected 0 and pi energy edge states at the interfaces between different domains, and give simple formulas for these invariants. We illustrate this bulk--boundary correspondence for DTQW's on the example of the "4-step quantum walk", where tuning CS and particle-hole symmetry realizes edge states in various symmetry classes.

### 5. Relativistic effects and rigorous limits for discrete- and continuous-time quantum walks

Score: `0.781`
Zotero key: `QSB24VR9`
DOI: `10.1063/1.2759837`
URL: https://doi.org/10.1063/1.2759837
