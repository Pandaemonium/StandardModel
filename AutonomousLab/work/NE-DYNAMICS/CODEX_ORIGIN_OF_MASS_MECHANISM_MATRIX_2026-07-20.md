# Origin-of-mass mechanism and claim matrix

Date: 2026-07-20
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: living classification target; rows have different evidence grades

## 1. Strongest honest claim today

> The project contains a common finite causal/operator architecture and
> kernel-checked representatives for several principal ways a rest gap or
> composite rest energy can arise. It does not yet derive all physical Standard
> Model masses, absolute scales, flavor ratios, the continuum QCD mass gap, or
> physical pole positions.

The intended upgrade is conditional:

> Relative to a displayed Standard Model plus neutrino and finite-transfer
> action class, the admitted mass responses are classified as distinct
> obstructions to gapless null transport, with explicit overlap laws and a
> finite-to-spectral reconstruction ladder.

That classification is not yet a single capstone theorem. The matrix below
fixes the target universe so that an eventual exhaustiveness statement has
content. Several internal gates are now exact: the one-generation
renormalizable Yukawa channels are enumerated; the canonical weak and color
contractions are unique up to scalar in the displayed concrete
representations; the finite neutrino branches are separated; and the HNU
one-particle regulator has a changing-lattice strong position-space limit.
None of those facts selects the free coefficients or turns a finite composite
gap into a QCD pole mass.

## 2. Universe of admissible mechanisms

Initial classification scope:

1. finite null-composition kinematics and Dirac-like rest operators;
2. the renormalizable Standard Model scalar, gauge, and Yukawa action blocks;
3. leading neutrino extensions: right-handed Dirac, dimension-five Majorana,
   and finite seesaw elimination;
4. finite gauge-invariant many-body/transfer dynamics as a regulator for
   composite QCD rest energy;
5. anomaly-compatible interaction-induced symmetric mass generation as an
   explicit boundary of the quadratic/bilinear response class;
6. inertial and gravitational response as a consistency test on the total rest
   response, not an extra additive source.

Excluded from any present exhaustiveness claim:

- arbitrary higher-dimensional effective operators beyond the declared
  neutrino branch;
- supersymmetric, composite-Higgs, technicolor, dark-sector, or other BSM
  fields unless separately added to the universe;
- nonlocal interactions or unconstrained operator insertions;
- observed mass values and flavor textures;
- a continuum Yang-Mills mass-gap theorem;
- a nonperturbative pole-mass theorem unless the spectral/continuum ladder is
  explicitly supplied.

The proposed exhaustiveness theorem is therefore relative to a declared action
grammar. Symmetric mass generation is not silently absorbed into a bilinear
mass term: it must either be added through an explicit interaction row or be
named as out of scope. This boundary is essential because a gapped response can
be carried by a propagator zero rather than a one-particle mass pole.

## 3. Compact comparison

| Class | Primitive/supplied data | Response called mass | Current grade | Main unpaid bridge |
|---|---|---|---|---|
| Null composition | Null spinors/directions and finite carrier | Pluecker determinant and rest-operator gap | `M` finite | Dynamical selection and pole/continuum semantics |
| Fermion chiral turn | Shared scalar `v`, independent equivariant Yukawa map `Y_f`, chirality conventions | Singular values/eigenvalues of `(v / sqrt 2) Y_f` in a positive physical sector | `M` algebra and finite legality/contraction classifiers, `T` SM formula | Derive/classify the flavor coefficients in `Y_f`; justify any full-doublet cross-space bridge; pole reconstruction |
| Broken gauge orbit | `H0`, gauge representation and couplings | Positive Gram stiffness of `X |-> X H0`; stabilizer is massless kernel | `M` finite, `T` SM mechanism | Full electroweak convention lock and physical propagator |
| Scalar radial mode | Scalar potential and vacuum `H0` | Hessian normal to the gauge orbit | `M` finite, `T` SM formula | Vacuum selection, radiative corrections, physical pole |
| Neutrino extension | Declared right-handed fields or dimension-five operator; heavy scale | Dirac/Majorana block or seesaw Schur complement | `M` minimal, Dirac, Weinberg, seesaw, mixed two-state, and exact two-state singular-mass branches; `T` mechanism | Arbitrary-generation Takagi factorization, multi-generation flavor data, and pole control |
| Composite gauge sector | Gauge action, transfer operator, vacuum, gauge-invariant observable | Rest-state energy or correlation-decay/transfer gap | `M` finite spectral/overlap/pole-residue controls, `T` lattice reconstruction | Honest finite nonabelian witness, field-algebra reflection positivity, SU(3), changing-lattice interacting limit |
| Symmetric mass generation | An anomaly-compatible interacting multiplet and local many-body interaction | Symmetry-preserving many-body gap, potentially represented by a propagator zero rather than a bilinear pole | `T` mechanism, `M` overlap obstruction only | Null-edge interacting realization, anomaly ledger, and correlator reconstruction |
| Inertial/gravitational response | Total action/stress response and coframe variation | Equality of inertial and source response | `M` finite identities, `C` physical completion | Shared action, continuum conservation, GR limit |

`M` means machine-verified program-internal finite statement; `T` means a
source-verified established mechanism; `C` means an open program
identification. No row is currently a prediction of an observed absolute mass.

## 4. Detailed rows

### A. Null-composition and Pluecker gap

**Data.** Finite null-spinor columns `psi_i`; their positive Gram/momentum
matrix; complex oriented areas `psi_i wedge psi_j`; a declared carrier or rest
operator.

**Exact finite content.** The determinant is the sum of squared pairwise areas.
It vanishes at rank one/collinearity and is positive for a nondegenerate
rank-two witness. The same complex area can define a Hermitian two-channel rest
operator whose square is the nonnegative area norm.

**Anchors.**

- `GateI1/Core.lean`;
- `PlueckerMassOperator.lean`;
- `PlueckerPositiveEnergyTransfer.lean`;
- `PlueckerOSHankelKernel.lean`;
- `Pluecker3Plus1ComplexMass.lean`;
- `PluckerMassDynamics.lean`.

**Positive-energy transfer bridge.**
`PlueckerPositiveEnergyTransfer.lean` now composes the nonzero wedge directly
with the finite Hamiltonian-transfer ladder. The positive rest eigenline has
energy `norm z`, exact Euclidean decay, exact logarithmic energy
reconstruction, and positive transfer-denominator weight; the determinant,
energy, decay rate, and weight all use the same wedge data, with no independent
mass parameter. The negative eigenline is an explicit control: its Euclidean
factor is greater than one at positive spacing. Thus positive-energy selection
is a real reconstruction hypothesis, not a consequence of Hermiticity of the
indefinite rest operator. The theorem remains finite and quadratic; it does not
derive reflection positivity of an interacting action or a continuum pole.

**Finite reflected-kernel rung.** The selected decay factor
`exp (-a * norm z)` now generates a finite Hankel kernel
`K(i,j) = lambda^(i+j)` whose quadratic form is exactly one square. The kernel
is positive semidefinite and the nondegenerate `3-4-5` wedge gives the exact
factor `exp (-5)` at unit spacing. An explicit nonzero two-time null vector
also proves that this one-mode kernel is rank one. This is a finite
reflected-two-point consequence, not reflection positivity of an interacting
field algebra or a strict transfer-gap theorem.

**Input debt.** The spinors, their normalization, and the selected state remain
supplied. Kinematics does not choose the electron mass, Higgs vacuum, Yukawa
texture, or QCD scale.

**Kill condition.** If every observable depends only on an arbitrary supplied
`|z|`, the construction is a geometric parametrization of a rest term rather
than a distinct physical mass mechanism.

### B. Fermion chiral turn

**Data.** Left/right representations, a gauge-equivariant Yukawa map `Y_f`, the
shared scalar vacuum scale `v`, and chirality/grading conventions.

**Response.** In the convention-fixed Standard Model formula,
`M_f = (v / sqrt 2) Y_f` couples chiral sectors. Its physical masses require
singular-value/eigenstate and propagator semantics, not merely nonzero matrix
entries.

**Anchors.**

- `GateYM/YukawaTurnAmplitude.lean`;
- `GateYM/ChiralMassStructure.lean`;
- `PhysicsSM/StandardModel/YukawaGauge.lean` (trusted finite classifier);
- `SharedHiggsMassData.lean`;
- `SharedHiggsScalarSharingNoGo.lean`;
- `PlueckerYukawaModuli.lean`;
- `ParticleMassMechanismMasterCapstone.lean`.

**Input debt.** The present finite formalization accepts an arbitrary `Y`. It
does not derive flavor rank, hierarchy, CKM data, or a unique Pluecker-to-Yukawa
map.

**Exact moduli control.** In the explicit `C2` representation
`trivial + sign`, the two distinct equivariant couplings `diag(1,0)` and
`diag(0,1)` have the same Frobenius norm and determinant. Thus determinant- or
modulus-type Pluecker data cannot select a unique Yukawa coupling even within
the admissible intertwiner space. The general classification target is the
representation-theoretic moduli space `Hom_G(V_R, V_L)` (with the Higgs
representation included in the physical Standard Model version), followed by
Pluecker level sets or strata inside that space.

**Independent control.** `Y = 0` kills the fermion response while leaving the
gauge and radial responses available. A nilpotent nonzero `Y` is a warning that
nonzero entries do not by themselves imply a positive mass spectrum.

**Exact shared-input limit.** The repository fermion operator has no Higgs
doublet argument. Identical bosonic vacuum data can therefore coexist with
different fermion operators, and two explicit linear maps from the Higgs
doublet to fermion-operator space disagree on the same vector. What is shared
through the displayed fermion functor is the scalar `v`, not a canonically
selected full-vector bridge. At nonzero `v`, distinct Yukawa matrices remain
distinct. This does not classify or exclude additional fermion-mass routes.

**Trusted one-generation legality classifier.** The trusted module
`PhysicsSM.StandardModel.YukawaGauge` enumerates all candidate triples of a
physical left multiplet, right multiplet, and Higgs or conjugate-Higgs marker
in the repository convention `Q = T3 + Y/2`. Its theorem
`candidateGaugeLegal_iff_exists_yukawaFlip` proves that the displayed finite
chirality, weak-doublet/singlet, color, and hypercharge predicates select
exactly the charged-lepton, down-quark, up-quark, and optional right-handed
neutrino channels. This is stronger than listing the familiar terms, but its
weak and color predicates are representation-pattern tags rather than actual
tensor-product intertwiners.

**Kernel-checked contraction layer.**
`InvariantContractions.lean`, harvested from Aristotle project
`7c70f6e1-5a0f-4d8d-a549-86b3ef4f8a9f`, proves in the displayed concrete
representations that every `SL(2,C)`-invariant complex bilinear form is a
scalar multiple of the alternating tensor and every complex linear map on
`C^3` commuting with all special-unitary matrices is a scalar multiple of the
identity. It also proves both canonical contractions are nonzero. This closes
the contraction-shape gate for those representations: gauge symmetry fixes the
weak/color tensor shape up to scalar. It does not fix the flavor-space matrix,
its rank, its singular values, or the scalar coefficients.

**Classification target.** Determine the moduli of gauge-equivariant,
grading-compatible Higgs-assisted right-to-left maps. Any conditional
uniqueness theorem must display hypotheses strong enough to reduce the relevant
intertwiner space and must still account for residual phase freedom. The
project should not describe Pluecker data as selecting `Y_f` without such a
theorem.

### C. Broken gauge-orbit stiffness

**Data.** Gauge Lie-algebra directions `X_a`, their representation on the Higgs
space, gauge couplings, and the same vacuum vector `H0`.

**Response.** The mass matrix is the Gram matrix of orbit tangents
`X_a H0`. It is positive semidefinite. A diagonal entry vanishes exactly when
the corresponding generator stabilizes `H0`.

**Anchors.**

- `GaugeMassGram.lean`;
- `EWWMassSU2.lean` as a finite electroweak-oriented successor;
- `HiggsTangentDecomposition.lean` for orbit/radial separation.

**Input debt.** Representation normalization and couplings are supplied. The
generic Gram theorem alone does not identify the physical `W`, `Z`, photon, or
their measured masses.

**Independent control.** A stabilizing generator has zero gauge response even
when `H0`, `Y_f`, and radial curvature are nonzero.

**Kill condition.** If the claimed photon direction is not exactly the
stabilizer under the chosen hypercharge convention, the electroweak
interpretation fails even though the generic Gram theorem remains true.

### D. Scalar radial curvature

**Data.** A gauge-invariant scalar potential and a selected vacuum orbit.

**Response.** The scalar mass coefficient is the Hessian normal to the orbit.
For the finite quartic doublet normalization used here it is
`m_H^2 = 2 * lambda * v^2`.

**Anchors.**

- `HiggsDoubletRadialCurvature.lean`;
- `HiggsTangentDecomposition.lean`;
- `HiggsDofConservation.lean`.

**Input debt.** `lambda` and the vacuum scale are supplied. The Standard Model
does not predict the Higgs pole mass from gauge symmetry alone. The finite
curvature is a tree-level response coefficient, not yet the interacting pole.

**Independent control.** `lambda = 0` kills radial curvature while a nonzero
vacuum can continue to generate gauge and fermion responses.

**Kill condition.** Calling the finite Hessian the observed 125 GeV mass without
radiative and spectral reconstruction is false shape.

### E. Neutrino mass extensions

**Data.** One of three explicitly different universes:

1. add right-handed singlets and a Dirac Yukawa map;
2. add the dimension-five lepton-number-violating Weinberg operator;
3. add a heavy Majorana block and eliminate it by a controlled seesaw/Schur
   complement.

**Response.** Dirac and Majorana singular values/Takagi data, or the light
effective seesaw block. Ordinary complex eigenvalues of a complex symmetric
mass matrix are not used as physical masses.

**Anchors.**

- `NeutrinoDiracMajorana.lean`;
- `NeutrinoSeesaw.lean`;
- `SchurSeesaw.lean`;
- `NeutrinoCPSeesawBridge.lean`;
- `NeutrinoMassMechanismCapstone.lean`;
- `NeutrinoMassClassification.lean` (verified finite four-branch return,
  pinned by `OriginMassAxiomGuard.lean` and root-imported);
- `MixedPseudoDiracBranch.lean` (complex symmetric two-state algebraic branch);
- `MixedPseudoDiracPhysicalMass.lean` (exact eigenvalues of `M^H M`,
  nonnegative squared singular masses, and nilpotent semantic control).

The new classification makes four principal boundaries exact in one finite
API:

1. an empty right-handed slot forces every chirality-odd Dirac block to vanish;
2. two bare Standard Model lepton-doublet hypercharges `-1/2` do not form a
   gauge-invariant renormalizable same-chirality bilinear;
3. adjoining one right-handed singlet permits an explicit nonzero Dirac turn,
   while the Weinberg branch is recorded separately as dimension five,
   non-renormalizable, heavy-scale dependent, and lepton-number violating;
4. the one-generation seesaw has exact Schur complement `-m_D^2/M_R`, exact
   triangular congruence block diagonalization, and a controlled residual under
   the displayed small-mixing hypothesis `|m_D/M_R| <= epsilon`.

This is an operator and field-content classification. It does not derive the
heavy scale, the Dirac coupling, mixing angles, CP phases, or a physical pole.
`MixedPseudoDiracBranch.lean` closes the missing two-state algebraic row:
it embeds the pure Dirac and pure Majorana limits in one complex symmetric
matrix, proves its characteristic polynomial and exact algebraic roots,
supplies pseudo-Dirac expansions under an explicit denominator hypothesis, and
gives a genuinely mixed nonzero witness. `MixedPseudoDiracPhysicalMass.lean`
now supplies the physically relevant finite correction: the two squared masses
are the nonnegative eigenvalues of `M^H M`, with exact trace, determinant,
discriminant, and real-specialization formulas. Its nonzero complex symmetric
nilpotent control has only zero ordinary eigenvalues while `M^H M` is nonzero,
so ordinary complex-eigenvalue language is decisively inadequate. The module
does not prove arbitrary-generation Autonne-Takagi factorization or determine
flavor data. Accordingly, do not cite the combined finite modules as a complete
phenomenological neutrino theory.

**Input debt.** Extra field content, the heavy scale, and coupling matrices are
supplied. The finite Schur identity does not determine observed neutrino masses
or mixings.

**Non-overlap rule.** A Majorana/Weinberg term is not another contribution to a
minimal-SM Dirac mass. It defines a different operator class with a different
symmetry cost. A mixed Dirac-Majorana model must use one displayed block matrix
so overlap is calculated once.

### F. Composite and binding mass

**Data.** A gauge action, a positive physical transfer operator or Hamiltonian,
a vacuum, a gauge-invariant sector/observable, and constituent rest inputs.

**Response.** The composite rest energy is an eigenvalue above the vacuum or a
positive spectral feature visible in a connected two-point function. Binding
energy is a comparison between the interacting total and a declared separated
constituent reference.

**Current anchors.**

- `GateYM/TransferPositivity.lean`;
- `GateYM/TransferHilbert.lean` and successors;
- `GateYM/SlabTransferGap.lean`;
- `GateYM/FusionTransferSpectrum.lean`;
- `GateI1/CompositeApertureMass.lean`;
- `GateI1/BindingMassQuantitative.lean`;
- `Carrier/BindingDefect.lean`.
- `TransferCorrelationMassFalsifier.lean`;
- `TransferPositiveBridge.lean`;
- `ObservableGapLinkage.lean`;
- `FiniteHamiltonianTransferPole.lean`;
- `FiniteOSReflectionPositivity.lean`.

**Current boundary.** The strongest controls are finite/toy and do not yet give
an SU(3) hadron sector or continuum confinement. The physical QCD mass gap is
not proved.

The separate free one-particle HNU regulator now has a stronger continuum
control than this row: `HNUChangingLatticeContinuumCapstone.lean` proves a
three-term strong `L2` changing-lattice limit, and transfers it to position
space by inverse-Fourier isometry, for the declared finite-energy data and
schedule. This discharges an important regulator objection for free Weyl
evolution. It cannot be used as the missing interacting transfer-matrix,
reflection-positivity, or SU(3) continuum theorem; those require new dynamics
and uniform estimates.

**Anti-double-counting law.** For a chosen QCD Hamiltonian, total hadron mass is
one rest-frame response. Quark kinetic/potential energy, gluon energy, explicit
quark mass, and trace anomaly are terms in a subordinate decomposition. Ji's
trace/traceless split is physical; the finer split is scheme dependent. Do not
add the subordinate pieces again on top of the total composite mass.

**Required next theorem.** Instantiate the repository's general finite
reflection-positive kernel and transfer-Hilbert APIs on an honest nonabelian
gauge ensemble. The current focused intermediate target proves the exact
finite reflected Hankel sum-of-squares
`K(t,s) = sum_a w_a lambda_a^(t+s)`, reconstructs nonnegative transfer
energies, and retains an explicit zero-overlap control. It is a two-point
spectral consumer, not full field-algebra Osterwalder-Schrader positivity.

**Literature/API bridge.** The finite target follows the reflection-positivity
and transfer-matrix architecture of Luescher (1977) and Osterwalder-Seiler
(1978), together with the symmetry-projector and finite-volume mass-extraction
workflow of Della Morte--Giusti (2011) and the local gluonic-operator overlap
controls of Chen et al. (2006). The exact source audit and proposed Lean API are
recorded in
`CODEX_LITERATURE_LATTICE_TRANSFER_MASS_2026-07-20.md`. Positivity alone does
not imply a gap, and a gap alone does not imply that a chosen observable sees
the state.

**Finite action-to-spectral bridge.**
`FiniteHamiltonianTransferPole.lean` proves that a finite positive Hermitian
Hamiltonian generates the genuine transfer matrix `T = exp (-a H)`, with L2
operator contraction for nonnegative Euclidean spacing. A nonzero positive-
energy eigenmode then has exact exponential transfer decay, exact logarithmic
energy reconstruction, and a unique scalar transfer-denominator zero with
positive coefficient equal to the mode norm squared. Its orbit kernel is Gram
positive. This closes a finite quadratic derivation chain from a chosen
Hamiltonian to decay and visible pole weight. It is not interacting
Osterwalder-Seiler reflection positivity, an infinite-volume atom, or LSZ. The
positive coefficient is not the signed analytic residue in local coordinate
`z - q^-1`.

**Reflection-positivity separation.**
`FiniteOSReflectionPositivity.lean` formalizes the actual finite reflected
pairing and the compatible reflected block, then constructs the quotient by
its null directions as a real inner-product space. Explicit two-point
witnesses prove both non-implications: a symmetric positive-definite full
matrix can fail reflection positivity, and a reflection-positive symmetric
matrix can have a negative eigenvalue. This kills the shortcut from numerical
matrix positivity to Osterwalder--Schrader reconstruction. The remaining A3
task must prove the reflected field-algebra condition for the concrete gauge
action; the finite matrix theorem does not supply it.

**Exact overlap control.**
`TransferCorrelationMassFalsifier.transfer_gap_does_not_fix_correlation_mass`
uses one fixed finite transfer operator and two observables. One observable sees
the distinguished eigenmode and the other is orthogonal to it, so the same
transfer spectrum produces different raw correlations. Their connected
normalized decay ratios are not distinguished by this witness. This proves
that the observable and its overlap are independent acceptance data; it does
not prove an observable-dependent mass, a lattice-QCD mass, or an asymptotic
continuum decay theorem.

**Exact positive finite complement.**
`TransferPositiveBridge.connectedCorrelation_fin2_normalized_tendsto` proves
the two-state diagonal case in the other direction. For positive transfer
eigenvalues, a strict ground/excited ordering, and nonzero overlap with the
first excited mode, the connected correlation divided by the excited
eigenvalue power is identically the positive squared overlap, and the
logarithmic transfer ratio is strictly positive. This closes the smallest
finite gap/overlap/correlation bridge. It remains a finite diagonal theorem,
not reflection-positive SU(3), a continuum limit, or a particle pole.

**Exact observable-gap linkage and failure control.**
`ObservableGapLinkage.linkage_under_nonzero_overlap` proves at the abstract
finite spectral level that a connected correlation with a displayed
first-excited term and asymptotically negligible lower remainder has leading
base exactly `lambda_1` and strictly positive amplitude when the overlap is
nonzero. Its three-state witness has a symmetric positive transfer spectrum
`(3,2,1)` but an observable orthogonal to the first excited state, so the
correlation skips base `2`, decays with base `1`, and reports a strictly larger
logarithmic mass. A separate finite gauge action proves that gauge invariance
does not force first-excited overlap, and nonzero overlap does not force gauge
invariance. Thus gauge admissibility and spectral visibility are independent
obligations. The theorem assumes the spectral decomposition/remainder estimate;
it does not derive these from the `SU(3)` action.

**Exact finite pole-residue complement.** `FMSPoleTransfer.lean` proves that a
finite Kallen-Lehmann spectral atom produces the expected simple resolvent
residue, that an FMS-style leading coefficient transfers that residue when the
remainder vanishes at the atom, that the residue is positive exactly when the
leading coefficient is nonzero, and that an explicit remainder can cancel it.
This closes a finite observable-to-residue logic rung while preserving the
central falsifier: leading-term algebra does not imply pole survival without a
remainder hypothesis. It is not LSZ reduction, a continuum propagator pole, or
a measured hadron/Higgs mass.

### G. Symmetric mass generation boundary

**Data.** A declared anomaly-compatible fermion multiplet and a local
interaction strong enough to gap the many-body theory without a
symmetry-breaking fermion bilinear.

**Response.** A symmetry-preserving many-body gap. In relevant constructions,
the single-particle Green function can have a zero where an ordinary massive
particle would have a pole.

**Current boundary.** The project has no null-edge SMG construction. The row is
included to prevent a false claim that the bilinear/quadratic rows exhaust all
known mass-generation mechanisms.

**Finite control.**
`GapPoleResponseObstruction.gap_does_not_fix_pole` exhibits two unitarily
conjugate finite Hermitian involutions with identical spectrum but different
weight in a fixed external direction. It proves that internal spectrum alone
does not fix a readout that is not itself determined by spectral data. The
theorem is an overlap model, not a physical-mass no-go and not a formalization
of an interacting propagator zero.

### H. Inertial and gravitational response

**Data.** The total action or Hamiltonian response, stress/source map, and
coframe/soldering variation.

**Response.** Equality or controlled relation among rest energy, inertial
response, and channel-blind gravitational source.

**Boundary.** This is not an eighth additive mass contribution. It asks whether
the already selected total response couples consistently to acceleration and
geometry. Finite trace or coframe identities do not yet imply Einstein's
equation, universal free fall in the continuum, or quantum gravity.

## 5. Shared-input and non-overlap laws

The electroweak rows B-D share the scalar scale `v`; the bosonic rows C-D also
share the convention-fixed doublet vector `H0(v)`. They remain distinct because
they are different typed derivatives or evaluations of the action:

- fermion: scalar multiplication of a supplied equivariant Yukawa block by
  `v / sqrt 2`; a full-vector dependence requires a separately declared bridge;
- gauge: quadratic stiffness of the covariant kinetic term along the orbit of
  `H0`;
- scalar: Hessian of the potential normal to that orbit.

Therefore:

1. count `v` once as the universally shared electroweak input and `H0(v)` once
   as shared bosonic data;
2. count `Y_f`, gauge couplings/representation, and scalar-potential parameters
   separately;
3. do not add the three response eigenvalues into one particle's mass;
4. use independent zero controls to show that the sectors are not aliases;
5. reserve "unified" for the common action/data architecture, not numerical
   equality of the mass responses.

The exact parity law is correspondingly limited. Chirality-odd fermion turns
are Hilbert-Schmidt orthogonal to chirality-even gauge/Higgs responses, but the
gauge Gram and scalar Hessian are both even and need not be orthogonal. Their
typed domains and provenance provide the intended separation bookkeeping:
generator-orbit space versus scalar-normal fluctuation space. Physical
non-double-counting still requires a faithful row-to-mechanism assignment; it
does not follow from parity disjointness alone. A Majorana neutrino block has
the same odd form as the Dirac/Yukawa row, so a mixed model must use one
displayed block operator and count each entry by provenance rather than parity
alone.

## 6. Spectral acceptance ladder

A program-internal coefficient may be promoted through the following grades.

1. **Algebraic coefficient.** A nonzero matrix/Hessian/Gram entry.
2. **Finite gap.** A positive difference in a declared self-adjoint Hamiltonian
   or unitary quasienergy spectrum.
3. **Visible finite response.** A gauge-invariant observable has nonzero overlap
   with the excitation and its positive two-point spectral measure displays the
   gap.
4. **Dispersion/rest interpretation.** The selected branch has the required
   momentum dependence and a rest frame.
5. **Gauge-invariant observable reconstruction.** In gauge sectors, a local
   gauge-invariant composite interpolator has nonzero overlap with the state;
   an FMS-type leading-term map is conditional evidence, not an extra source.
6. **Changing-lattice reconstruction.** Sampling, interpolation, normalization,
   and ultraviolet-tail estimates converge to a continuum response.
7. **Physical mass claim.** The limiting pole/rest response is matched to a
   declared physical sector and observable.

No current mechanism should silently skip from grade 1 or 2 to grade 7. The HNU
massive `3+1` capstone is a genuine grade-6 result for its declared
one-particle evolution problem: for fixed nonzero complex mass, fixed time, and
fixed square-integrable data, the changing-lattice live approximation converges
strongly after inverse Fourier transport to the exact massive Dirac flow. It
does not promote the interacting fermion, Higgs, gauge-boson, or composite rows
to grade 6 or 7.

The scalar and vector parts of the new observable gate now have exact finite
anchors.
`HiggsFMSRadialObservable.lean` proves the gauge-invariant radial expansion,
the resulting four connected-form terms, positivity of the leading coefficient
for a nonzero vacuum, and preservation of a finite resolvent identity under the
leading scaling. `HiggsFMSVectorObservable.lean` proves exact local-gauge
cancellation, the leading/mixed/quadratic vector expansion, an invertible
two-by-two leading bridge, and a noninjective three-to-two mismatch control.
Neither observable-expansion module proves perturbative dominance or a pole.
The finite conditional pole-transfer logic is now kernel-checked in
`FMSPoleTransfer.lean`: a simple atom transfers only when the displayed
remainder has zero residue, and an explicit cancellation witness proves why
that hypothesis is indispensable. The continuum dominance, LSZ, and
changing-lattice pole-survival steps remain open; see
`CODEX_LITERATURE_FMS_MASS_OBSERVABLES_2026-07-20.md`.

The source-audited implementation obligations are now separated more sharply.
Osterwalder-Seiler/Luscher-type reflection positivity reconstructs positive
physical dynamics; Usui's Theorem 2.1 then gives a unique positive lattice
spectral measure from Hermiticity, translation invariance, reflection
positivity, and polynomial boundedness. Neither theorem supplies nonzero
overlap with the lowest edge or proves that an isolated atom survives a
changing-lattice limit. The detailed source audit and three named subgates are
recorded in `CODEX_LITERATURE_GAP_TO_POLE_2026-07-20.md`.

The finite reflected-kernel theorem landed as
`FiniteReflectionPositiveKL.lean` from Aristotle project
`3b51906d-3dd8-485f-948d-572a31d2bd72`. It proves only the two-point Hankel
consequence of a positive finite spectral measure. It does not discharge the
source hypotheses on a lattice action. In particular, link-reflection and
site-reflection positivity are not interchangeable, and ordinary matrix
positivity is not a substitute for positivity of the reflected field algebra.

The finite composition has now landed as
`FiniteReflectionPositiveGapPoleBridge.lean`. Given transfer eigenvalues in
`(0,1]`, observable norm-square weights, a simple selected transfer energy,
and nonzero overlap, it proves in one guarded theorem that the reflected Hankel
kernel is positive, the transfer energy is nonnegative, and the finite energy
resolvent has a nonzero residue equal to the same overlap weight. Its exact
`lambda=(1,1/2)` fixture gives mass `log 2` and unit residue. Thus the finite
gap/overlap/reflection/pole semantics are now connected rather than merely
adjacent. The remaining gate is to derive the positive spectral data from an
interacting reflection-positive action and prove that the isolated atom and
overlap survive the changing-lattice limit.

Two further finite rungs now make that remaining gate more precise.
`FiniteSelfAdjointTransferReflectionPole.lean` derives the reflected Hankel
Gram identity from an actual self-adjoint transfer operator and observable
orbit; a visible eigenvector gives exact exponential correlation and a positive
simple resolvent residue. `FiniteTransferPositivity.lean` proves that a Gram
factorization gives positive definiteness and that an explicitly supplied
strict top gap gives exponential decay, but also proves two kill controls:
positive definiteness supplies no uniform strict gap, and the same scalar gap
can coexist with different top spectral projectors.

The nonabelian observable half is now concrete but deliberately unpaired.
`SU3PlaquetteObservable.lean` supplies a finite gauge-invariant `SU(3)`
plaquette observable. It does not prove reflection positivity, a transfer gap,
or nonzero overlap with the first excited state. These cannot be inferred from
gauge invariance. The next accepted A3 composition must therefore derive or
assume visibly, and in this order: reflected action positivity, positive
transfer reconstruction, strict gap, and nonzero observable overlap.

## 7. Exhaustiveness theorem target

An eventual theorem should quantify over a concrete finite action grammar, not
over the word "mass." One candidate grammar contains:

- null principal transport;
- local lower-order chiral maps compatible with declared gauge representations;
- a renormalizable scalar doublet potential;
- covariant gauge kinetic terms;
- declared dimension-five neutrino terms;
- a finite positive gauge-transfer sector.

The theorem should classify every quadratic term in the expansion about a
declared vacuum/physical sector into the rows above, modulo field redefinition
and gauge redundancy. A counterexample outside this grammar does not refute the
scoped theorem; a counterexample inside it does.

The intended conclusion has two layers that must not be merged:

1. **Relative structural exhaustiveness.** Within the displayed field content,
   locality/order bound, gauge representations, and operator grammar, every
   admitted quadratic rest response belongs to a named row, with symmetric
   mass generation and composite binding explicitly represented as boundaries
   of that quadratic grammar.
2. **Physical derivation.** The coefficients, vacuum, scales, nonperturbative
   states, continuum limit, and observable pole data are selected by the full
   dynamics and agree with experiment.

Only the first layer is an immediate formal-classification target. Calling it
"all sources of mass derived" would erase the second layer and overstate the
science.

## 8. Immediate gates

1. Keep `SharedHiggsMassData.lean` scoped to common-scalar sharing and retain
   the explicit cross-space no-go; do not restore the false vector-sharing
   reading without a new representation bridge.
2. Compose `MassResponseNonOverlap.lean` into the eventual scoped
   exhaustiveness theorem: odd/even parity where valid, typed-domain separation
   for gauge versus scalar, and explicit provenance for Dirac/Majorana overlap.
3. Treat A2 as an intertwiner-moduli problem. Classify the admissible
   Higgs-assisted Yukawa space and its Pluecker level sets; do not claim
   uniqueness from determinant data.
4. Compose the landed operator-orbit, reflected-Hankel, decay, and residue
   theorems only through explicit hypotheses. Keep zero-overlap and
   equal-gap/different-projector controls beside every positive statement.
5. Pair the landed finite `SU(3)` plaquette observable with a concrete action
   whose field algebra satisfies the correct link- or site-reflection
   positivity. Derive the transfer operator and prove a strict gap and nonzero
   first-excited overlap; positivity of a numerical matrix is not enough.
6. Compose the landed mixed pseudo-Dirac and exact two-state singular-mass
   branches with `NeutrinoMassClassification.lean`.
   `FiniteTakagiMajoranaPartial.lean` now supplies the arbitrary-generation
   squared-singular basis, conditional phase-paired assembly, corrected
   squared-mass identity, and a counterexample to the false orientation. The
   remaining arbitrary-generation Takagi gate is the phase-compatible basis
   construction in zero and repeated singular-value subspaces. Retain that
   blocker, together with flavor, scale-selection, and pole debts, before
   making a finite-operator exhaustiveness claim.
7. Package the action grammar as a typed finite syntax and prove the relative
   exhaustiveness theorem by constructors, including an explicit outside-grammar
   counterexample such as symmetric mass generation or a higher-dimensional
   operator.
8. Defer any "all sources of mass derived" claim until coefficient/scale
   selection, SU(3), spectral, and interacting continuum bridges are green.
