# Aristotle semantic context pack

Generated: 2026-07-10T00:46:10
Query: `Hermitian Clifford symbol normalized unitary quantum walk step Dirac`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeQWNormPreservation.lean`

Score: `0.814`

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

### 2. `PhysicsSM/Draft/NullEdgeQWUnitarity.lean`

Score: `0.814`

```text
import Mathlib

/-!
# Null-step quantum-walk unitarity

The null-step walk uses closed-form Pauli rotations. This module certifies
unitarity of those rotations and their one-step product before treating the
walk as a genuine finite quantum evolution operator.
-/

open Complex Matrix
open scoped Matrix
```

### 3. `Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md` [Area 1: The chirality-flip-to-mass universality conjecture]

Score: `0.803`

```text
anded step amplitude is the spin projection operator in the step direction, the left-handed amplitude the orthogonal projector. A path with N steps, B bends, and T net right-minus-left bends gets amplitude i^{±T} 3^{−B/2} 2^{−N}. Crucially: "A Dirac mass m introduces the amplitude iεm to flip chirality in any given time step ε" — exactly the treatise's mechanism, in 3+1 D, with no fermion doubling. This is the single most direct existing realization of the null-edge mass conjecture.
- **D'Ariano–Perinotti and Bisio–D'Ariano–Tosini QCA/quantum-walk program.** From locality, homogeneity, isotropy, unitarity (and minimal internal dimension 2), they prove only two nontrivial quantum walks exist on the body-centered-cubic Cayley graph of Z³; these are the Weyl walks, and coupling two of them with an off-diagonal mass term reproduces the 3+1 Dirac equation at small wavevector (Phys. Rev. A 90, 062106). The "Discrete time Dirac quantum walk in 3+1 dimensions" (arXiv:1603.06442) gives the explicit FFT implementation. The mass term is literally the chirality-coupling amplitude; Lorentz covariance is recovered at small wavevector and deformed (doubly-special-relativity-like) at the cutoff (Bibeau-Delisle et al., EPL 109, 50003).
- **Arrighi–Nesme–Forets, "The Dirac equation as a quantum walk: higher dimensions" (J. Phys. A 47, 465302).** Establishes observational convergence to the Dirac equation in 3+1 D.

**The precise relationship and the open universality problem.** In every construction the small-wavevector dispersion is ω² = |k|² + m_eff², with m_eff equal to (a constant times) the chirality-flip amplitude per step divided by the lattice spacing — i.e., m_eff ∝ ν in the treatise's language. What is NOT established, and is the key open problem, is a UNIVERSALITY/RG statement
```

### 4. `AgentTasks/model-calls/gemini/2026-06-24-round-009-constructive-next-job.md` [Response]

Score: `0.802`

```text
## Response

``text
**Theorem Target:** The unitary null-step evolution operator, `U_s = exp(-i s H)`, where `s` is a proper-time-like parameter, decomposes into projection-weighted phase rotations: `U_s = exp(-i s E) P+ + exp(+i s E) P-`.

**Possible Failure Mode:** The assumption that `s` is a simple scalar proper-time might be incorrect. If the underlying causal graph requires a more complex, non-local, or state-dependent step definition, `exp(-i s H)` may not be the correct unitary propagator for a single null-step. This would force a re-evaluation of the link between the continuous-parameter Hamiltonian `H` and the discrete graph dynamics.

**Literature/Source Check:** Review the "checkerboard" model (1+1D Dirac equation) propagator in R. P. Feynman's "Quantum Electrodynamics and the Path Integral". This provides the canonical derivation for a discrete, null-step quantum walk propagator, serving as the benchmark for the proposed `U_s` and its relationship to `H`.

``
```

### 5. `Sources/Null_Edge_Key_Conjectures.md` [What we would like to show]

Score: `0.800`

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

### 6. `PhysicsSM/Draft/NullEdgeNullStepQuantumWalkCore.lean` [Rx]

Score: `0.799`

```text
def Rx (θ : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![Complex.cos (θ : ℂ), -(I * Complex.sin (θ : ℂ));
     -(I * Complex.sin (θ : ℂ)), Complex.cos (θ : ℂ)]

/-- The one-step null-step quantum walk `U_a(k) = exp(-i k a σ_z) exp(-i μ a σ_x)`.
`a` is the lattice spacing, `k` the (quasi)momentum, `μ` the bare mass/coupling. -/
```

### 7. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P4-F. Luminal checkerboard dynamics, formalized]

Score: `0.799`

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

### 8. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [80. Positive transport phase and phase-level finite differences]

Score: `0.798`

```text
hiftField`, so that
the symbol convention remains `T_A -> exp(+i k_A)`.

Next concrete theorem:

```text
raw Parseval:
  blockL2NormSq(rawFourier Psi)
    = |SiteN N| * fieldL2NormSq(Psi)

then:
  fourierUnitary = |SiteN N|^{-1/2} rawFourier
  blockL2NormSq(fourierUnitary Psi) = fieldL2NormSq(Psi)
```

Only after this unitary normalization is checked should the diagonalized
finite-difference/Wilson pieces be assembled into the full `Hfree` symbol.
```

## Scoped paper hits

### 1. Two-component Dirac-like Hamiltonian for generating quantum walk on one-, two- and three-dimensional lattices

Score: `0.793`
Zotero key: `MITSBCVI`
DOI: `10.1038/srep02829`
URL: https://www.zotero.org/19894138/items/MITSBCVI

Abstract:

From the unitary operator used for implementing two-state discrete-time quantum walk on one-, two- and three- dimensional lattice we obtain a two-component Dirac-like Hamiltonian. In particular, using different pairs of Pauli basis as position translation states we obtain three different form of Hamiltonians for evolution on one-dimensional lattice. We extend this to two- and three-dimensional lattices using different Pauli basis states as position translation states for each dimension and show that the external coin operation, which is necessary for one-dimensional walk is not a necessary requirement for a walk on higher dimensions but can serve as an additional resource to control the dynamics. The two-component Hamiltonian we present here for quantum walk on different lattices can serve as a general framework to simulate, control, and study the dynamics of quantum systems governed by Dirac-like Hamiltonian.

### 2. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.792`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 3. Discrete spacetime, quantum walks and relativistic wave equations

Score: `0.791`
Zotero key: `K87E7K68`
arXiv: `1802.03910`
DOI: `10.1103/PhysRevA.97.042131`
URL: https://www.zotero.org/19894138/items/K87E7K68

Abstract:

It has been observed that quantum walks on regular lattices can give rise to wave equations for relativistic particles in the continuum limit. In this paper, we define the three-dimensional discrete-time walk as a product of three coined one-dimensional walks. The factor corresponding to each one-dimensional walk involves two projection operators that act on an internal coin space; each projector is associated with either the “forward” or “backward” direction in that physical dimension. We show that the simple requirement that there is no preferred axis or direction along an axis—that is, that the walk be symmetric under parity transformations and steps along different axes of the cubic lattice be uncorrelated—leads, in the case of the simplest solution, to the requirement that the continuum limit of the walk is fully Lorentz-invariant. We show further that, in the case of a massive particle, this symmetry requirement necessitates the use of a four-dimensional internal space (as in the Dirac equation). The “coin flip” operation is generated by the parity transformation on the internal coin space, while the differences of the projection operators associated with each dimension must all anticommute. Finally, we discuss the leading correction to the continuum limit, and the possibility of distinguishing through experiment between the discrete random walk and the continuum-based Dirac equation as a description of fermion dynamics.

### 4. Quantum simulation of quantum relativistic diffusion via quantum walks

Score: `0.780`
Zotero key: `I7G53I6T`
arXiv: `1911.09791v2`
URL: http://arxiv.org/abs/1911.09791v2

Abstract:

Discrete-time quantum walks with temporal noise on the coin admit a continuum limit described by a Lindblad equation with Dirac Hamiltonian part and chirality-flip / chirality-dependent phase-flip jumps. Useful prior art for the null-edge chirality-coherence and quantum-walk dynamics lane.

### 5. Dirac equation as a quantum walk over the honeycomb and triangular lattices

Score: `0.777`
Zotero key: `BMFTJTIS`
arXiv: `1803.01015`
DOI: `10.1103/PhysRevA.97.062111`
URL: https://www.zotero.org/19894138/items/BMFTJTIS

Abstract:

A discrete-time quantum walk (QW) is essentially an operator driving the evolution of a single particle on the lattice, through local unitaries. Some QWs admit a continuum limit, leading to well-known physics partial differential equations, such as the Dirac equation. We show that these simulation results need not rely on the grid: the Dirac equation in (2+1) dimensions can also be simulated, through local unitaries, on the honeycomb or the triangular lattice, both of interest in the study of quantum propagation on the nonrectangular grids, as in graphene-like materials. The latter, in particular, we argue, opens the door for a generalization of the Dirac equation to arbitrary discrete surfaces.
