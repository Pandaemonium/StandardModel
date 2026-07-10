# Collaborator brief: finite null information, proof, and simulation

Standalone brief for external scientific and formal-methods collaborators,
2026-07-10. No repository access is assumed.

## 1. Program in one paragraph

We are building a Lean 4 formalization and numerical laboratory for the thesis
that relativistic mass is a positive spectral obstruction to coherently
compressing finite null information. The exact finite kinematic core is

```text
det(sum_i psi_i psi_i^dag) = sum_{i<j} |psi_i wedge psi_j|^2.
```

Each primitive spinor contribution is rank one and null; nonalignment produces
a positive timelike determinant. A finite Dirac-like carrier has a constrained
physical cohomology, a separately chosen positive sector, a spectral mass
operator, exact history/path-sum dynamics, and four second-order obstruction
types called aperture, closure, turn, and soldering. The program is not yet a
continuum QFT or a derivation of the Standard Model.

## 2. What is already machine checked

The current finite corpus includes:

- canonical determinant/Pluecker mass and null decomposition;
- entropy, concurrence, and compression identities;
- finite Kugo-Ojima cohomology, Hilbert-Hodge representatives, explicit
  positive and negative controls, and a separate spectral mass witness;
- exact checkerboard path sums, discrete Dirac recursion, lattice dispersion,
  unitary updates, speed bounds, and first tetrahedral 3+1 kinematics;
- a four-type carrier-square decomposition with concrete coefficient rigidity;
- signed closure binding, Schur/seesaw effective mass, positive-sector gaps,
  finite Fock and confinement-shaped witnesses;
- local holonomy, soldering covariance, finite coframe geometry, and action
  variation;
- gauge-mass Gram matrices, Higgs degree-of-freedom bookkeeping, CP/flavor
  witnesses and no-gos;
- finite recovery/resource identities, self-consistent decoder feedback, and
  event-count/Lambda arithmetic.

The proof corpus has explicit counterexamples against automatic positivity,
canonical generation count, universal carrier uniqueness, and several tempting
but false operator identifications.

## 3. This run's two products

### A. Manuscript evidence spine

We want a bold, readable technical manuscript where every headline follows the
chain

```text
claim -> exact Lean theorem -> witness/control -> simulation -> falsifier.
```

We seek criticism of physical interpretation, missing assumptions, nearby prior
art, and the strongest honest thesis.

### B. Executable null-information laboratory

We want a reusable simulator for null bundles, checkerboard/quantum-walk
dynamics, Hodge/positive-sector spectra, binding and Schur reduction, quantum
channels, self-consistent decoders, and finite ensembles. Numerical results are
graded as exact fixtures, theorem regressions, imported-physics reproductions,
calibrated fits, or genuine predictions. We seek benchmark designs that can
falsify the dictionary rather than merely fit it.

## 4. The three source programs

Three research essays propose a broader theory:

1. physics as encoding, quotienting, positive decoding, holonomy, spectral
   cost, coarse-graining, and recovery;
2. a moduli theory in which decoder presentations are equivalent up to
   chain-homotopy/intertwining relations;
3. a local operational process theory with regional algebras, channels,
   measurement records, refinement, RG, gravity, and event count.

Their finite proof-ready pieces are being extracted; their continuum and
foundational claims remain conjectural.

## 5. Highest-value questions

1. **Locality:** what is the minimal finite categorical/net structure whose
   refinement could honestly approach AQFT microcausality, rather than assuming
   tensor factorization by hand?
2. **Continuum dynamics:** which convergence theorem for exact checkerboard or
   quantum-walk kernels would be both mathematically attainable and physically
   decisive?
3. **Simulation observables:** which known-physics benchmarks distinguish the
   null-information mechanism from a generic parametrized Hamiltonian?
4. **Recovery and particles:** can a finite resolvent/Combes-Thomas theorem tie
   spectral gap to a rigorous recovery/localization length?
5. **Scale:** what finite/RG theorem would turn the current dimensionless mass
   structure into an absolute scale without inserting the answer?
6. **Symmetry breaking and Higgs:** what is the smallest constructive finite
   reservoir/thermodynamic-limit bridge beyond degree-of-freedom bookkeeping?
7. **Gravity:** what finite Ward/stationarity identity is a nontrivial precursor
   to Jacobson/Einstein response rather than a renamed variation equation?
8. **Probability:** which graph-native hypotheses could support a genuine POVM
   Gleason reconstruction, and which are merely the Born rule restated?

## 6. Known pitfalls

- The constraint differential `Q`, its Hilbert-Hodge Laplacian
  `Q^*Q+QQ^*`, and the spectral mass operator `D#D` are distinct.
- Krein self-adjointness and nondegenerate cohomology do not imply positivity.
- A two-factor no-signaling theorem is not emergent spacetime locality.
- Exact finite SSB requires degeneracy; spontaneous selection needs a
  thermodynamic/refinement limit.
- A supplied running coupling can define an invariant scale without deriving
  the beta function or measured units.
- Componentwise Dirac velocity eigenvalues `+/-c` are not simultaneous
  classical trajectories for every particle. The scalar Higgs self-mass remains
  outside the current null-zigzag mechanism.
- Fitted agreement is not prediction. Every calibration must be disclosed.
- We do not claim a continuum Yang-Mills mass gap, full quantum gravity, the
  Born rule, initial conditions, or the number of null events.

## 7. Requested response format

Please give numbered findings. Mark each as theorem, known result/reference,
conjecture, counterexample, simulation proposal, or missing definition. For any
proposed mechanism, state assumptions, the cheapest finite test, a nondegenerate
witness, and a kill condition. Precise negative results are as valuable as
positive constructions.
