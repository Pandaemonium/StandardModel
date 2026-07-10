# Aristotle semantic context pack

Generated: 2026-07-10T10:50:35
Query: `fermion doubling Dirac quantum walk stationary amplitude remove Brillouin corner aliases preserve unitary locality Pluecker mass coin`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Key_Conjectures.md` [What the literature says]

Score: `0.830`

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

### 2. `Sources/Null_Edge_Key_Conjectures.md` [What we would like to show]

Score: `0.830`

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

### 3. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Prior art and differentiation]

Score: `0.812`

```text
xtra volume/geometricity constraints for EPRL-like bivector data, including Hopf-link conditions on boundary graphs | A finite boundary-graph scaffold testing whether Pluecker simplicity plus closure can talk to spin-foam geometricity without claiming full sector isolation |
| Alexander-Marciano-Smolin graviweak chirality (arXiv:1212.5246) | Weak \(SU(2)\) as the chiral half of the spacetime connection; a Dirac fermion as a chiral neutrino plus a Higgs-quantum-number scalar | The discrete chirality-flip vertex and its tie to the Pluecker/simplicity mass picture |
| D'Ariano-Mosco-Perinotti-Tosini, Bisio-D'Ariano-Perinotti-Tosini, Arrighi-Nesme-Forets, Farrelly, Sato-Katori, Eon-Di Molfetta-Magnifico-Arrighi, and related Dirac quantum-walk/QCA work (`JZEJ4VXA`, `BVJBTK8J`, `KCQGEDJE`, `4F87TGCN`, `964TN6X7`, `G7NXEZBU`, `VIAIBSRI`) | Homogeneous Weyl/Dirac quantum walks and QCA, small-momentum Dirac limits, discrete covariance issues, ultraviolet cutoff/convergence guardrails, and lightlike-wire discrete QED constructions | The null-edge interface: forced `L plus R` mass doubling, scalar flip as the mass selection rule, invariant `det(P_vis)=m^2` tied to the Pluecker theorem, and a clean separation between the homogeneous fixed-point package and the causal-set spinor-propagator frontier |
| Sorkin / Das-Nasiri-Yazdi everpresent Lambda (`ZP7E648U`, `K5CFI3HI`, `IHVSDGUC`) | Fluctuating sign-changing cosmological constant of order `1 / sqrt(V)` from causal-set discreteness plus unimodular conjugacy, together with observational tests and amplitude tension | A possible finite source-visibility reason for the mean-zero target: coherent/internal vacuum bookkeeping should be boundary-like while visible Plucker excitations source bulk diamond defects |
| Quillen superconnections
```

### 4. `Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md` [Area 1: The chirality-flip-to-mass universality conjecture]

Score: `0.811`

```text
anded step amplitude is the spin projection operator in the step direction, the left-handed amplitude the orthogonal projector. A path with N steps, B bends, and T net right-minus-left bends gets amplitude i^{±T} 3^{−B/2} 2^{−N}. Crucially: "A Dirac mass m introduces the amplitude iεm to flip chirality in any given time step ε" — exactly the treatise's mechanism, in 3+1 D, with no fermion doubling. This is the single most direct existing realization of the null-edge mass conjecture.
- **D'Ariano–Perinotti and Bisio–D'Ariano–Tosini QCA/quantum-walk program.** From locality, homogeneity, isotropy, unitarity (and minimal internal dimension 2), they prove only two nontrivial quantum walks exist on the body-centered-cubic Cayley graph of Z³; these are the Weyl walks, and coupling two of them with an off-diagonal mass term reproduces the 3+1 Dirac equation at small wavevector (Phys. Rev. A 90, 062106). The "Discrete time Dirac quantum walk in 3+1 dimensions" (arXiv:1603.06442) gives the explicit FFT implementation. The mass term is literally the chirality-coupling amplitude; Lorentz covariance is recovered at small wavevector and deformed (doubly-special-relativity-like) at the cutoff (Bibeau-Delisle et al., EPL 109, 50003).
- **Arrighi–Nesme–Forets, "The Dirac equation as a quantum walk: higher dimensions" (J. Phys. A 47, 465302).** Establishes observational convergence to the Dirac equation in 3+1 D.

**The precise relationship and the open universality problem.** In every construction the small-wavevector dispersion is ω² = |k|² + m_eff², with m_eff equal to (a constant times) the chirality-flip amplitude per step divided by the lattice spacing — i.e., m_eff ∝ ν in the treatise's language. What is NOT established, and is the key open problem, is a UNIVERSALITY/RG statement
```

### 5. `Sources/Null_Edge_Key_Conjectures.md` [What might be missing]

Score: `0.807`

```text
### What might be missing

The hardest missing piece is not another scalar identity. It is a real
universality theorem:

- a class of allowed walks with precise locality/unitarity/covariance
  hypotheses;
- a scaling limit theorem rather than a Taylor expansion in one toy model;
- a band-limited convergence estimate using an isolated quasienergy branch and
  a controlled logarithm;
- a full Brillouin-zone census of gap closings, cone locations, chiralities,
  multiplicities, and effective masses;
- a connection between the walk spinor/chirality space and the visible/internal
  observer-channel space;
- an invariant `det P_vis = m^2` bridge, separate from the frame-relative
  normalized `det rho_vis`;
- a single-cone or honest species/doubler accounting;
- a proof that Kähler-Dirac multiplicity, left/right chirality doubling, and
  internal generations are not being double-counted;
- a robust treatment of gauge fields and position dependence;
- a way to handle higher-dimensional isotropy and fermion doubling concerns;
- numerical pilots showing the expected dispersion and stability beyond the
  exactly solvable model.

Failure mode: the null-step walk reproduces Dirac behavior only after fragile
fine-tuning, or the mass parameter in the walk cannot be tied to the Pluecker
and observer-channel invariants without extra assumptions.
Another failure mode is that the walk mass can only be matched to the
frame-normalized `det rho_vis`, with no invariant unnormalized determinant
statement. That would weaken the claimed bridge to P1.

The invariant mass bridge should be derived independently from the walk
dispersion. Starting from a quasienergy `epsilon_a(k)`, prove either an exact
deformed shell

```text
epsilon_a(k)^2 - |q_a(k)|^2 = m^2
```

for a naturally derived lattice mom
```

### 6. `Sources/Null_Edge_Key_Conjectures.md` [What we would like to show]

Score: `0.801`

```text
facts.

Publication-level statement:

> In a sourced class of finite null-step quantum walks, the chirality-flip
> parameter determines the Dirac mass in the continuum scaling limit. The
> finite Pluecker/observer-channel mass identities are the static invariant
> readouts of the same null-step dynamics.
```

### 7. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P4-F. Luminal checkerboard dynamics, formalized]

Score: `0.796`

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

### 8. `Sources/Underexplored_Angles_Lit_Review.md` [3. Quantum Cellular Automata (QCA) / Quantum Walks as the Dynamics Layer]

Score: `0.796`

```text
## 3. Quantum Cellular Automata (QCA) / Quantum Walks as the Dynamics Layer
The COG idea needs a local tick rule. Quantum cellular automata and discrete-time quantum walks are close cousins: local, discrete-space/discrete-time update rules that can approximate relativistic particles. Recent work directly studies fermion doubling in QCA/quantum-walk models and how it relates to Nielsen–Ninomiya-style constraints.

* **Why it matters:** This provides an existing mathematical language for "Planck-tick local evolution" without immediately reinventing all of lattice QFT. It also highlights known traps: locality, unitarity, Lorentz recovery, and fermion doubling.
* **Concrete experiment:** Implement a tiny QCA-like COG rule for a 1D or 2D Dirac particle, then ask whether adding octonionic internal state labels naturally creates generations, doublers, or gauge-like phases.
* **Reference:** [Fermion Doubling in Quantum Cellular Automaton Models (arXiv:2505.07900)](https://arxiv.org/abs/2505.07900)
```

## Scoped paper hits

### 1. Discrete spacetime, quantum walks and relativistic wave equations

Score: `0.801`
Zotero key: `K87E7K68`
arXiv: `1802.03910`
DOI: `10.1103/PhysRevA.97.042131`
URL: https://www.zotero.org/19894138/items/K87E7K68

Abstract:

It has been observed that quantum walks on regular lattices can give rise to wave equations for relativistic particles in the continuum limit. In this paper, we define the three-dimensional discrete-time walk as a product of three coined one-dimensional walks. The factor corresponding to each one-dimensional walk involves two projection operators that act on an internal coin space; each projector is associated with either the “forward” or “backward” direction in that physical dimension. We show that the simple requirement that there is no preferred axis or direction along an axis—that is, that the walk be symmetric under parity transformations and steps along different axes of the cubic lattice be uncorrelated—leads, in the case of the simplest solution, to the requirement that the continuum limit of the walk is fully Lorentz-invariant. We show further that, in the case of a massive particle, this symmetry requirement necessitates the use of a four-dimensional internal space (as in the Dirac equation). The “coin flip” operation is generated by the parity transformation on the internal coin space, while the differences of the projection operators associated with each dimension must all anticommute. Finally, we discuss the leading correction to the continuum limit, and the possibility of distinguishing through experiment between the discrete random walk and the continuum-based Dirac equation as a description of fermion dynamics.

### 2. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.798`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 3. Dirac equation as a quantum walk over the honeycomb and triangular lattices

Score: `0.796`
Zotero key: `BMFTJTIS`
arXiv: `1803.01015`
DOI: `10.1103/PhysRevA.97.062111`
URL: https://www.zotero.org/19894138/items/BMFTJTIS

Abstract:

A discrete-time quantum walk (QW) is essentially an operator driving the evolution of a single particle on the lattice, through local unitaries. Some QWs admit a continuum limit, leading to well-known physics partial differential equations, such as the Dirac equation. We show that these simulation results need not rely on the grid: the Dirac equation in (2+1) dimensions can also be simulated, through local unitaries, on the honeycomb or the triangular lattice, both of interest in the study of quantum propagation on the nonrectangular grids, as in graphene-like materials. The latter, in particular, we argue, opens the door for a generalization of the Dirac equation to arbitrary discrete surfaces.

### 4. Spin on a 4D Feynman Checkerboard

Score: `0.788`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 5. Fermion confinement via Quantum Walks in 2D+1 and 3D+1 spacetime

Score: `0.788`
Zotero key: `E6B5QHJE`
arXiv: `1612.08027`
DOI: `10.1103/PhysRevA.95.042112`
URL: https://www.zotero.org/19894138/items/E6B5QHJE

Abstract:

We analyze the properties of a two- and three-dimensional quantum walk that are inspired by the idea of a brane-world model put forward by Rubakov and Shaposhnikov [Phys. Lett. B 125, 136 (1983)PYLBAJ0370-269310.1016/0370-2693(83)91253-4]. In that model, particles are dynamically confined on the brane due to the interaction with a scalar field. We translated this model into an alternate quantum walk with a coin that depends on the external field, with a dependence which mimics a domain wall solution. As in the original model, fermions (in our case, the walker) become localized in one of the dimensions, not from the action of a random noise on the lattice (as in the case of Anderson localization) but from a regular dependence in space. On the other hand, the resulting quantum walk can move freely along the “ordinary” dimensions.
