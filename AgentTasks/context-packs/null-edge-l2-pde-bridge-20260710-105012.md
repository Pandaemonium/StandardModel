# Aristotle semantic context pack

Generated: 2026-07-10T10:50:26
Query: `infinite-volume L2 Fourier multiplier convergence Dirac quantum walk uniform operator bound Pluecker complex mass`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Prior art and differentiation]

Score: `0.800`

```text
xtra volume/geometricity constraints for EPRL-like bivector data, including Hopf-link conditions on boundary graphs | A finite boundary-graph scaffold testing whether Pluecker simplicity plus closure can talk to spin-foam geometricity without claiming full sector isolation |
| Alexander-Marciano-Smolin graviweak chirality (arXiv:1212.5246) | Weak \(SU(2)\) as the chiral half of the spacetime connection; a Dirac fermion as a chiral neutrino plus a Higgs-quantum-number scalar | The discrete chirality-flip vertex and its tie to the Pluecker/simplicity mass picture |
| D'Ariano-Mosco-Perinotti-Tosini, Bisio-D'Ariano-Perinotti-Tosini, Arrighi-Nesme-Forets, Farrelly, Sato-Katori, Eon-Di Molfetta-Magnifico-Arrighi, and related Dirac quantum-walk/QCA work (`JZEJ4VXA`, `BVJBTK8J`, `KCQGEDJE`, `4F87TGCN`, `964TN6X7`, `G7NXEZBU`, `VIAIBSRI`) | Homogeneous Weyl/Dirac quantum walks and QCA, small-momentum Dirac limits, discrete covariance issues, ultraviolet cutoff/convergence guardrails, and lightlike-wire discrete QED constructions | The null-edge interface: forced `L plus R` mass doubling, scalar flip as the mass selection rule, invariant `det(P_vis)=m^2` tied to the Pluecker theorem, and a clean separation between the homogeneous fixed-point package and the causal-set spinor-propagator frontier |
| Sorkin / Das-Nasiri-Yazdi everpresent Lambda (`ZP7E648U`, `K5CFI3HI`, `IHVSDGUC`) | Fluctuating sign-changing cosmological constant of order `1 / sqrt(V)` from causal-set discreteness plus unimodular conjugacy, together with observational tests and amplitude tension | A possible finite source-visibility reason for the mean-zero target: coherent/internal vacuum bookkeeping should be boundary-like while visible Plucker excitations source bulk diamond defects |
| Quillen superconnections
```

### 2. `FUTURE_DIRECTIONS.md` [Lean formalization prerequisites]

Score: `0.799`

```text
### Lean formalization prerequisites

- A definition of `QuantumWalkStep` as a linear operator on `Fin n → ComplexOctonion`
- The existing action-table theorems from `OperatorAlgebra.lean`
- Mathlib's `LinearMap.comp` for composing operators
- Eventually: Fourier analysis on ℤ/nℤ for the continuum limit

---
```

### 3. `Sources/Null_Edge_Key_Conjectures.md` [What the literature says]

Score: `0.793`

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

### 4. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P4-F. Luminal checkerboard dynamics, formalized]

Score: `0.792`

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

### 5. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Executive conclusion]

Score: `0.791`

```text
a causal-set cosmology: if finite diamond observables make
coherent/internal vacuum bookkeeping boundary-like or mean-zero while visible
Pluecker excitations source bulk defects, the program offers a structural
reason for a mean-zero fluctuating source. If not, this branch should be
demoted. The origin-of-mass/operator branch is the strongest mathematical
target and is already partly banked by the Dirac square-root modules. The
bivector/BF and generation-blindness branches are the next cheap decisive
finite tests. Measurement, black-hole information, strong CP, confinement, and
hierarchy should stay interpretive watch-list items until they force a new
finite constraint or prediction.

A Dirac-style correction now sharpens the program further. Nearly every
trusted keystone is a square: determinant mass, squared Pluecker modulus,
Bloch mixedness, reduced-density impurity, and Laplacian-type propagation.
That means the next central object should not be another quadratic invariant,
but the finite first-order operator whose square produces these invariants.
The short slogan is:

> The Pluecker mass theorem is the square of a theorem we have not yet fully
> written.

At the static spinor-bundle level, the square root is ordinary finite algebra.
Write

```text
P = sum_i psi_i psi_i^dagger = P_mu sigma^mu.
```

Then a Clifford/Dirac slash satisfies

```text
(gamma . P)^2 = (P_mu P^mu) I = det(P) I.
```

Composed with the trusted Pluecker theorem, this gives the near-term Lean
target:

```lean
diracSlash_bundleMomentum_sq_eq_pluckerMass
```

under explicit signature, gamma-matrix, and Pauli-matrix conventions. This is
still finite algebra, not a continuum Dirac equation. The larger conjectural
target is a causal super-Dirac operator on the order complex,

```text
D_{U,Phi} = d_U
```

### 6. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [81. Raw Parseval is now kernel-checked]

Score: `0.791`

```text
q N Psi
```

- `blockL2NormSq_const_mul` proves finite block-L2 scaling under a global
  complex coefficient.
- `fourierNormFactor_sq_mul_card` proves that the normalization factor
  `1/sqrt(|SiteN N|)` cancels the raw Fourier cardinality factor.
- `fourierUnitary` defines the normalized Fourier transform.
- `fourierUnitary_l2NormSq_siteN` proves:

```text
blockL2NormSq(fourierUnitary N Psi)
  =
fieldL2NormSq N Psi
```
- `fourierUnitary_shiftField` transfers pullback-shift diagonalization to the
  normalized Fourier transform with eigenvalue `phasePlus^{-1}`.
- `fourierUnitary_transportShift` transfers canonical transport-shift
  diagonalization to the normalized Fourier transform with eigenvalue
  `phasePlus`.
- `fourierUnitary_centeredTransportDiff` transfers the centered-difference
  diagonalization with symbol `phasePlus - phasePlus^{-1}`.
- `fourierUnitary_wilsonLaplacianField` transfers the Wilson-laplacian
  diagonalization with symbol `2 - phasePlus - phasePlus^{-1}`.
- `phasePlus_eq_zmodAddEquiv_one` proves the symbol-convention guardrail:
  `phasePlus N m A` is exactly the one-coordinate `ZMod` character
  `AddChar.zmodAddEquiv (m A) 1`.
- `phasePlus_inv_eq_conj` proves the inverse phase is the complex conjugate,
  preparing the phase-to-trig bridge.

Verified:

```text
lake build PhysicsSM.Draft.NullEdge.GateC1.FiniteFourierParseval
lake build PhysicsSM.Draft.NullEdge.GateC1.TetraCharactersEqual
```

This is a meaningful C1 bridge milestone. We now have the finite equal-side
raw Fourier transform proven to have exactly the expected L2 scaling, and the
normalized Fourier transform proven unitary for the finite L2 norm, and the
phase-level finite-difference/Wilson diagonalization transferred to that
unitary transform, without expanding all four cyclic coordinat
```

### 7. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Executive conclusion]

Score: `0.785`

```text
nd Pauli-matrix conventions. This is
still finite algebra, not a continuum Dirac equation. The larger conjectural
target is a causal super-Dirac operator on the order complex,

```text
D_{U,Phi} = d_U + delta_U + Phi + Phi^dagger,
```

whose square decomposes into a covariant graph Laplacian, diamond curvature,
Higgs/Yukawa chirality-flip blocks, and the visible Plucker scalar block. If
such an operator cannot be made natural and finite, the program remains a
collection of related quadratic analogies rather than a unified theory.

The operator criterion has four immediate consequences.

First, the visible `2 x 2` Hermitian momentum block naturally carries
\(m^2\), not \(m\). A genuine mass term belongs in the doubled
left/right space as an off-diagonal block. The Higgs/Yukawa chirality-flip
vertex is therefore not an auxiliary explanation added after the Pluecker
mass theorem; it is the finite mass entry of the first-order operator whose
square returns the determinant-level mass.

Second, the square root is two-sheeted. The sign choice
\(\sqrt{\det P}=\pm m\) should be treated as an algebraic constraint on any
CPT, particle/antiparticle, or in/out-sheet proposal. This does not by itself
prove a physical two-sheet scattering construction, but it makes the branch
structure a required part of the operator story rather than optional
decoration.

Third, the complex Pluecker amplitude should be kept before taking modulus.
For a pair of spinors,

```text
psi_i wedge psi_j = |psi_i wedge psi_j| exp(i Phi_ij).
```

The squared modulus is the mass-spread theorem. The phase is the natural
Pancharatnam/Berry companion to test against the graph holonomy layer. The
right finite object is therefore a complex first-order bivector amplitude,
whose modulus and phase give two real shadows
```

### 8. `Sources/Null_Edge_Key_Conjectures.md` [What we would like to show]

Score: `0.784`

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

## Scoped paper hits

### 1. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.798`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 2. Relativistic effects and rigorous limits for discrete- and continuous-time quantum walks

Score: `0.781`
Zotero key: `QSB24VR9`
DOI: `10.1063/1.2759837`
URL: https://doi.org/10.1063/1.2759837

### 3. Connecting the discrete- and continuous-time quantum walks

Score: `0.776`
Zotero key: `XK9ZRDNJ`
DOI: `10.1103/physreva.74.030301`
URL: https://doi.org/10.1103/physreva.74.030301

### 4. Dirac equation as a quantum walk over the honeycomb and triangular lattices

Score: `0.774`
Zotero key: `BMFTJTIS`
arXiv: `1803.01015`
DOI: `10.1103/PhysRevA.97.062111`
URL: https://www.zotero.org/19894138/items/BMFTJTIS

Abstract:

A discrete-time quantum walk (QW) is essentially an operator driving the evolution of a single particle on the lattice, through local unitaries. Some QWs admit a continuum limit, leading to well-known physics partial differential equations, such as the Dirac equation. We show that these simulation results need not rely on the grid: the Dirac equation in (2+1) dimensions can also be simulated, through local unitaries, on the honeycomb or the triangular lattice, both of interest in the study of quantum propagation on the nonrectangular grids, as in graphene-like materials. The latter, in particular, we argue, opens the door for a generalization of the Dirac equation to arbitrary discrete surfaces.

### 5. Discrete spacetime, quantum walks and relativistic wave equations

Score: `0.760`
Zotero key: `K87E7K68`
arXiv: `1802.03910`
DOI: `10.1103/PhysRevA.97.042131`
URL: https://www.zotero.org/19894138/items/K87E7K68

Abstract:

It has been observed that quantum walks on regular lattices can give rise to wave equations for relativistic particles in the continuum limit. In this paper, we define the three-dimensional discrete-time walk as a product of three coined one-dimensional walks. The factor corresponding to each one-dimensional walk involves two projection operators that act on an internal coin space; each projector is associated with either the “forward” or “backward” direction in that physical dimension. We show that the simple requirement that there is no preferred axis or direction along an axis—that is, that the walk be symmetric under parity transformations and steps along different axes of the cubic lattice be uncorrelated—leads, in the case of the simplest solution, to the requirement that the continuum limit of the walk is fully Lorentz-invariant. We show further that, in the case of a massive particle, this symmetry requirement necessitates the use of a four-dimensional internal space (as in the Dirac equation). The “coin flip” operation is generated by the parity transformation on the internal coin space, while the differences of the projection operators associated with each dimension must all anticommute. Finally, we discuss the leading correction to the continuum limit, and the possibility of distinguishing through experiment between the discrete random walk and the continuum-based Dirac equation as a description of fermion dynamics.
