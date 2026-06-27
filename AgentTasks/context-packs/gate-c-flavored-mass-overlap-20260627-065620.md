# Aristotle semantic context pack

Generated: 2026-06-27T06:56:28
Query: `Gate C flavored mass overlap Wilson regulator point splitting modified chirality spectral flow branch zeros ghost safety`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/NullStrand_Lean_Roadmap.md` [Gate B — relativistic one-particle continuum model]

Score: `0.757`

```text
### Gate B — relativistic one-particle continuum model

Adds:

- intrinsic covariant null measure;
- flux-weighted observer current;
- global process existence;
- spectral gap/ergodicity for positive mass;
- correct massless boundary behavior.
```

### 2. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [New master criterion: finite Dirac square root]

Score: `0.754`

```text
stial relaxation gap is a square-level diagnostic; the more
  fundamental object is the first-order flip generator whose eigenvalue is
  the mass.
- The complex Plucker amplitude should be retained before taking modulus:
  its modulus gives the pairwise mass spread, while its phase is the
  Pancharatnam/Berry target to compare with graph holonomy.
- The sign of the square root is a required two-sheet branch datum for any
  CPT, particle/antiparticle, or in/out interpretation.

The finite two-sheet branch algebra is now integrated in
`PhysicsSM.Draft.NullEdgeDiracTwoSheetCore`: any operator with
`D^2 = m^2 I` and `m != 0` has complementary projectors
`(1/2)(I plus/minus m^{-1}D)` carrying the `+m` and `-m` branches. The remaining
physics question is not whether the branches exist algebraically, but how a
causal graph, CPT convention, or scattering boundary condition should interpret
them.

The static bundle bridge is now also integrated in
`PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`: after extracting Weyl
coordinates from the trusted finite bundle momentum, the chiral slash squares
to `PhysicsSM.Spinor.PluckerMass.finPairwisePluckerMass`. The concrete
mass-shell branch specialization is integrated in
`PhysicsSM.Draft.NullEdgeDiracMassShellProjectorsCore`, proving idempotence,
orthogonality, and the `+m`/`-m` slash eigenvalue equations for the mass-shell
projectors.

**2026-06-21 branch/projector additions.** Added Foldy-Wouthuysen `NFMI3A99`
(`10.1103/physrev.78.29`), Newton-Wigner `74NU4C33`
(`10.1103/revmodphys.21.400`), and Thaller's *The Dirac Equation* `UI9343SX`
(`10.1007/978-3-662-02753-0`) to Zotero/Neo4j under `two-sheet-branch`.
These are guardrails for interpreting the algebraic branch projectors without
overclaiming a scattering or localization theory.
```

### 3. `PhysicsSM/Draft/StandardModelAnomalyPackage.lean` [weakDoubletCount]

Score: `0.747`

```text
def weakDoubletCount (multiplets : List ChiralMultiplet) : Nat :=
  (multiplets.map fun m =>
    if m.weak.isDoublet then m.colorMultiplicity else 0).sum

/-- Local perturbative gauge and mixed anomaly cancellation conditions. -/
```

### 4. `AgentTasks/aristotle-yukawa-mass-operator-prompt-20260622.md` [Objective]

Score: `0.745`

```text
## Objective

Prove the finite bridge between Higgs/Yukawa chirality-flip legality and the
first-order mass operator used in the null-edge origin-of-mass program.

The intended interpretation is:

- the finite Yukawa table is the Standard-Model permission rule for
  chirality-changing vertices;
- the scalar post-symmetry-breaking mass parameter `m` defines an odd
  left/right flip operator;
- the square of that first-order flip is the scalar mass block `m * m`.
```

### 5. `Sources/Null_Edge_Key_Conjectures.md` [What might be missing]

Score: `0.745`

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

### 6. `Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md` [Target B: formulate the Higgs as a graph chirality-flip operator]

Score: `0.743`

```text
## Target B: formulate the Higgs as a graph chirality-flip operator

Define a null-edge Weyl walk with left/right sectors and an allowed flip operator:

[
F:\Psi_L\otimes H\to \Psi_R.
]

Then show that its continuum limit gives the Dirac mass term.

This directly ties the graph program to the known Standard Model mass mechanism.
```

### 7. `AgentTasks/aristotle-strategy-roadmap-prompt-20260621.md` [Branches to prioritize]

Score: `0.743`

```text
## Branches to prioritize

Prioritize these, in roughly this order:

1. Diamond source visibility and the cosmological-constant branch.
2. The finite causal super-Dirac/operator spine:
   `D_{U,Phi}=d_U+delta_U+Phi+Phi^dagger`.
3. Pluecker mass, Dirac square roots, and branch projectors.
4. Pluecker/Bargmann phase and graph holonomy matching.
5. Bivector/BF simplicity-defect wrapper.
6. Generation blindness and internal Gram/Yukawa flavor geometry.
7. Kähler-Dirac order-complex fermions and two-sheet/CPT structure.
8. Quantum-measure/decoherence-functional finite algebra.
```

### 8. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [2026-06-25 super-Dirac refinement (concrete gate)]

Score: `0.741`

```text
order spectral
action is finite linear algebra rather than asymptotic heat-kernel analysis.
The first useful target is:

```text
Tr(D_total^2) = graph kinetic trace + Yukawa trace + diamond-curvature trace
```

This should be attempted before any continuum spectral-action claim.

Higgs/Yukawa boundary. The safe theorem-level claim is that Higgs/Yukawa
insertions are gauge-legal chirality-changing mass operators, and that a scalar
off-diagonal flip can square to a mass block. The sharper physical chain is:

```text
Yukawa/Higgs coupling
-> left/right chirality coherence
-> explicit dephasing, trace, detector restriction, or observer channel
-> visible mixedness.
```

Do not double count this as an independent "Higgs mass" plus a separate
"Plucker mass." The important target is that the Higgs/Yukawa singular value and
the Plucker determinant represent the same on-shell scalar in two descriptions.
The integrated draft module `NullEdgeYukawaMassOperator` is the finite
bookkeeping bridge.

The Pro critique gives a useful finite two-level target for this bridge. For a
fixed-helicity chiral Hamiltonian

```text
H_h = [[-h |p|, m], [m, h |p|]],
E = sqrt(|p|^2 + m^2),
Pi_+ = (1 / 2) (I + H_h / E),
```

the left/right coherence of the positive-energy projector is

```text
2 |(Pi_+)_{LR}| = m / E.
```

After an explicit chiral dephasing channel `Delta_chi`, the dephased
determinant gives the same ratio. This is the publication-safe Higgs bridge:
the Yukawa/Higgs block creates coherent left/right coupling first; normalized
visible mixedness is the shadow seen after a named observer/dephasing channel.

Phase guardrail. The complex Plucker amplitude should be kept in P2, but raw
pair phases are not themselves physical spin observables. Individual
`psi_i wedge psi_j` phases change und
```

## Scoped paper hits

### 1. Propagator zeros and lattice chiral gauge theories

Score: `0.763`
Zotero key: `8NRUZ46K`
arXiv: `2311.12790`
URL: http://arxiv.org/abs/2311.12790

Abstract:

Symmetric mass generation (SMG) has been advocated as a mechanism to render mirror fermions massive without symmetry breaking, ultimately aiming for the construction of lattice chiral gauge theories. It has been argued that in an SMG phase, the poles in the mirror fermion propagators are replaced by zeros. Using an effective lagrangian approach, we investigate the role of propagator zeros when the gauge field is turned on, finding that they act as coupled ghost states. In four dimensions, a propagator zero makes an opposite-sign contribution to the one-loop beta function as compared to a normal fermion. In two dimensional abelian theories, a propagator zero makes a negative contribution to the photon mass squared. In addition, propagator zeros generate the same anomaly as propagator poles. Thus, gauge invariance will always be maintained in an SMG phase, in fact, even if the target chiral gauge theory is anomalous, but unitarity of the gauge theory is lost.

### 2. From Twistor-Particle Models to Massive Amplitudes

Score: `0.739`
Zotero key: `NVT2C7IF`
arXiv: `2203.08087`
DOI: `10.3842/SIGMA.2022.045`
URL: https://www.zotero.org/19894138/items/NVT2C7IF

Abstract:

In his twistor-particle programme of the 1970's, Roger Penrose introduced a representation of the massive particle phase space in terms of a pair of twistors subject to an internal symmetry group. Here we use this representation to introduce a chiral string whose target is a complexification of this space, extended so as to incorporate supersymmetry. We show that the gauge anomalies associated to the internal symmetry group vanish only for maximal supersymmetry, and that correlators in these string models describe amplitudes involving massive particles with manifest supersymmetry. The models and amplitude formulae exhibit a double copy structure from gauge theory on the Coulomb branch to gravity, although the graviton remains massless. The formulae are closely related to those obtained earlier by the authors expressed in terms of the polarised scattering equations.

### 3. Index Theorem and Overlap Formalism with Naive and Minimally Doubled Fermions

Score: `0.736`
Zotero key: `QB6UXK3U`
arXiv: `1110.2482`
URL: https://www.zotero.org/19894138/items/QB6UXK3U

Abstract:

A theoretical foundation for the index theorem in naive and minimally doubled lattice fermions by studying the spectral flow of a Hermitean version of Dirac operators, using point-splitting to implement flavored mass terms. The spectral flow correctly detects the index of the would-be zero modes determined by gauge field topology and the number of species doublers. Presents new overlap fermions from naive fermion kernels with a flavor number depending on the mass terms.

### 4. Constraints on the symmetric mass generation paradigm for lattice chiral gauge theories

Score: `0.725`
Zotero key: `AV4P6E5X`
arXiv: `2505.20436`
DOI: `10.1103/qd1t-wzy1`
URL: http://arxiv.org/abs/2505.20436

Abstract:

Within the symmetric mass generation (SMG) approach to the construction of lattice chiral gauge theories, one attempts to use interactions to render mirror fermions massive without symmetry breaking, thus obtaining the desired chiral massless spectrum. In this paper we argue that the zeros that often replace the mirror poles of fermion two-point functions in an SMG phase should be kinematical singularities. We conjecture that the SMG interactions generate opposite-chirality bound states, which combine with the gapped elementary mirror states to form massive Dirac fermions. The propagator zeros can then be avoided by choosing an appropriate set of interpolating fields that contains both elementary and composite fields. This allows us to apply general constraints on the existence of a chiral fermion spectrum which are valid in the presence of (non-gauge) interactions of arbitrary strength, including in any SMG phase. Using a suitably constructed one-particle lattice hamiltonian describing the fermion spectrum, we formulate a generalized no-go theorem which establishes the conditions for the applicability of the Nielsen-Ninomiya theorem to this hamiltonian. If these conditions are satisfied, the massless fermion spectrum must be vector-like.

### 5. Quantum Many-Body Lattice C-R-T Symmetry: Fractionalization, Anomaly, and Symmetric Mass Generation

Score: `0.725`
Zotero key: `9FFS4GFC`
arXiv: `2412.19691`
URL: http://arxiv.org/abs/2412.19691

Abstract:

Charge conjugation (C), mirror reflection (R), and time reversal (T) symmetries, along with internal symmetries, are essential for massless Majorana and Dirac fermions. These symmetries are sufficient to rule out potential fermion bilinear mass terms, thereby establishing a gapless free fermion fixed point phase, pivotal for symmetric mass generation (SMG) transition. In this work, we systematically study the anomaly of C-R-T-internal symmetry in all spacetime dimensions by analyzing the projective representation (i.e. the fractionalization) of the C-R-T-internal symmetry group in the quantum many-body Hilbert space on the lattice. By discovering the fermion-flavor-number-dependent C-R-T-internal symmetry's anomaly structure, we demonstrate an alternative way to derive the minimal flavor number for SMG, which shows consistency with known results from Kahler-Dirac fermion or cobordism classification. Our findings reveal that, in general spatial dimensions, either 8 copies of staggered Majorana fermions or 4 copies of staggered Dirac fermions admit SMG.
