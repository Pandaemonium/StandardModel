# Aristotle semantic context pack

Generated: 2026-07-09T15:01:05
Query: `Dirac quantum walk continuum limit quantitative Taylor remainder matrix norm Lie Trotter fixed momentum Ustep generator checkerboard`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P4-F. Luminal checkerboard dynamics, formalized]

Score: `0.818`

```text
ces the flip
generator to be scalar, making vector flip components anisotropic couplings
rather than mass.

Lead venue. ITP or math-physics.

Literature anchors. Earle checkerboard notes; Foster-Jacobson 4D checkerboard;
Strauch's discrete/continuous quantum-walk Dirac limits (`XK9ZRDNJ`,
`QSB24VR9`); Arrighi-Nesme-Forets on the Dirac equation as a quantum walk
with higher-dimensional convergence (`4F87TGCN`); D'Ariano-Mosco-Perinotti-
Tosini 3+1 Dirac quantum walk (`JZEJ4VXA`); Sato-Katori's Dirac quantum walk
with ultraviolet cutoff (`G7NXEZBU`); Arnault-Perez-Arrighi-Farrelly on
discrete-time quantum walks as fermions of lattice gauge theory (`PTHQB2RM`);
Arrighi-Facchini-Forets on discrete Lorentz covariance (`VHPN6G7D`); and
Bisio-D'Ariano-Perinotti-Tosini QCA derivations of Weyl, Dirac, and Maxwell
dynamics (`BVJBTK8J`, `KCQGEDJE`). Farrelly's QCA review (`964TN6X7`)
is now the broad prior-art guardrail, and Eon-Di Molfetta-Magnifico-Arrighi's
3+1 discrete QED construction (`VIAIBSRI`) is especially relevant because it
uses lightlike circuit wires, starts from a Dirac quantum walk, and extends it
to gauge-invariant multi-particle dynamics.

Claim boundary. A finite path-sum / recurrence result in `1+1`, plus a
homogeneous null-step quantum-walk fixed-point package if the new targets land.
It is not yet a proof of generic higher-dimensional Dirac universality or a
causal-set spinor propagator. It also is not yet the G1
`checkerboardBohmBell_master`: that capstone still requires a trajectory measure
and concrete assembly of null steps with Born equivariance from the banked
checkerboard lemmas.
```

### 2. `PhysicsSM/Draft/NullEdgeQWNormPreservation.lean`

Score: `0.816`

```text
import Mathlib

/-!
# Null-step QW norm preservation

The unitarity theorem should imply concrete norm preservation for the
two-component spinor state used by the null-step quantum walk.
-/

open Complex Matrix
open scoped Matrix
```

### 3. `PhysicsSM/NullStrand/ZigZag/QuantumWalk.lean` [quantumWalkOperator]

Score: `0.815`

```text
def quantumWalkOperator (a k μ : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.Ua a k μ

/-- One-step walk trace identity in terms of lattice data. -/
```

### 4. `PhysicsSM/NullStrand/ZigZag/QuantumWalk.lean` [quantumWalk_trace]

Score: `0.813`

```text
theorem quantumWalk_trace (a k μ : ℝ) :
    (quantumWalkOperator a k μ).trace =
      2 * Complex.cos (k * a) * Complex.cos (μ * a) := by
  simpa [quantumWalkOperator] using
    PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.trace_Ua a k μ

/-- Walk operator is determinant-one (special-unitary trace class). -/
```

### 5. `Sources/Null_Edge_Key_Conjectures.md` [What we would like to show]

Score: `0.810`

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

### 6. `AgentTasks/null-edge-codex-overnight-run-ledger-2026-06-23.md` [Literature cadence after null-step quantum-walk integration]

Score: `0.809`

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

### 7. `PhysicsSM/Draft/NullEdgeNullStepQuantumWalkCore.lean` [Rx]

Score: `0.808`

```text
def Rx (θ : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![Complex.cos (θ : ℂ), -(I * Complex.sin (θ : ℂ));
     -(I * Complex.sin (θ : ℂ)), Complex.cos (θ : ℂ)]

/-- The one-step null-step quantum walk `U_a(k) = exp(-i k a σ_z) exp(-i μ a σ_x)`.
`a` is the lattice spacing, `k` the (quasi)momentum, `μ` the bare mass/coupling. -/
```

### 8. `Sources/Null_Edge_Key_Conjectures.md` [What the literature says]

Score: `0.808`

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

### 1. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.826`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 2. Dirac equation as a quantum walk over the honeycomb and triangular lattices

Score: `0.807`
Zotero key: `BMFTJTIS`
arXiv: `1803.01015`
DOI: `10.1103/PhysRevA.97.062111`
URL: https://www.zotero.org/19894138/items/BMFTJTIS

Abstract:

A discrete-time quantum walk (QW) is essentially an operator driving the evolution of a single particle on the lattice, through local unitaries. Some QWs admit a continuum limit, leading to well-known physics partial differential equations, such as the Dirac equation. We show that these simulation results need not rely on the grid: the Dirac equation in (2+1) dimensions can also be simulated, through local unitaries, on the honeycomb or the triangular lattice, both of interest in the study of quantum propagation on the nonrectangular grids, as in graphene-like materials. The latter, in particular, we argue, opens the door for a generalization of the Dirac equation to arbitrary discrete surfaces.

### 3. Relativistic effects and rigorous limits for discrete- and continuous-time quantum walks

Score: `0.801`
Zotero key: `QSB24VR9`
DOI: `10.1063/1.2759837`
URL: https://doi.org/10.1063/1.2759837

### 4. Discrete spacetime, quantum walks and relativistic wave equations

Score: `0.796`
Zotero key: `K87E7K68`
arXiv: `1802.03910`
DOI: `10.1103/PhysRevA.97.042131`
URL: https://www.zotero.org/19894138/items/K87E7K68

Abstract:

It has been observed that quantum walks on regular lattices can give rise to wave equations for relativistic particles in the continuum limit. In this paper, we define the three-dimensional discrete-time walk as a product of three coined one-dimensional walks. The factor corresponding to each one-dimensional walk involves two projection operators that act on an internal coin space; each projector is associated with either the “forward” or “backward” direction in that physical dimension. We show that the simple requirement that there is no preferred axis or direction along an axis—that is, that the walk be symmetric under parity transformations and steps along different axes of the cubic lattice be uncorrelated—leads, in the case of the simplest solution, to the requirement that the continuum limit of the walk is fully Lorentz-invariant. We show further that, in the case of a massive particle, this symmetry requirement necessitates the use of a four-dimensional internal space (as in the Dirac equation). The “coin flip” operation is generated by the parity transformation on the internal coin space, while the differences of the projection operators associated with each dimension must all anticommute. Finally, we discuss the leading correction to the continuum limit, and the possibility of distinguishing through experiment between the discrete random walk and the continuum-based Dirac equation as a description of fermion dynamics.

### 5. Connecting the discrete- and continuous-time quantum walks

Score: `0.792`
Zotero key: `XK9ZRDNJ`
DOI: `10.1103/physreva.74.030301`
URL: https://doi.org/10.1103/physreva.74.030301
