# The null-edge program: a holistic overview of the significant results

Date: 2026-07-21
Status: program-level synthesis. Every result below is graded; nothing is asserted
without a grade. This document is a map of what has been *proven*, at what strength, and
what remains supplied or open. It is deliberately conservative: where a claim is a
mechanism rather than a derivation, a representation rather than an explanation, or a
finite model rather than a continuum theorem, it says so.

---

## How to read this document (the claim calculus)

The Lean 4 kernel is the source of truth for this repository. A result is trusted only
when the intended mathematical statement is represented correctly in Lean, the proof is
accepted by the kernel under the pinned toolchain (`leanprover/lean4:v4.28.0`), and its
axiom footprint is audited (the standard base is `propext, Classical.choice, Quot.sound`;
flagship results carry a build-enforced `#print axioms` guard).

Every result carries a grade:

- **T** - a theorem with a source-verified classical proof, formalized here.
- **M** - machine-verified: kernel-checked in this repository, axiom-pinned.
- **M (conditional)** - kernel-checked, but the headline reading rests on a displayed
  hypothesis that is not itself discharged in-repo.
- **C** - a pre-registered conjecture, with a gate and a kill-condition.
- **Open** - a named unsolved problem.

Originality tags: **[orig]** new here, **[comp]** known mathematics newly formalized,
**[import]** borrowed, **[interp]** interpretation. A composite claim is only as strong as
its weakest link.

**The single most important framing.** This program derives *mechanisms*, supplies
*specific algebras and calibrations*, and proves *obstructions*. It predicts **no measured
number** confronting experiment. Any unqualified "we derive the Standard Model / general
relativity" is false. The true and defensible statement is: *we derive certain mechanisms
(colour, mass-as-area, CP-as-volume, the causal skeleton of geometry), we represent every
mass as null-edge data, and we prove a family of no-go obstructions; these structures
remain supplied and these steps remain open.*

**A note on reliability.** The program's kernel-checked *statements* have been far more
reliable than the prose around them. In one recent adversarial-audit day, fourteen prose
over-claims were caught and corrected against zero unsound theorems, across three
independent audit rounds. The lesson, and the discipline this document follows: grade
precisely, distinguish representation from derivation, and run the domain literature before
writing the physical gloss.

---

## Executive summary (the one-page version)

**The foundational object.** The single primitive is the *null edge*: a light-speed
constituent carrying a Weyl 2-spinor `psi in C^2`, together with a finite *causal order* on
the events edges connect. The program's distinctive thesis is that these two aspects of one
object are the shared root of the two great theories - the 2-spinor is simultaneously a
matter state (Standard-Model branch) and, through soldering, a null direction of spacetime
(general-relativity branch).

**The strongest results, in one line each:**

1. **Mass is the geometry of disagreeing light** (T/M, trusted). For null spinors
   `psi_1,...,psi_N`, `det(sum_i psi_i psi_i^dag) = sum_{i<j} |psi_i wedge psi_j|^2`: the
   invariant mass squared of an assembled lightlike system is the total pairwise Plucker
   area, zero exactly when all directions agree.

2. **Kinematic completeness of the mass representation** (M, [comp]+[orig]). *Every*
   future-causal four-momentum is the soldered sum of finitely many future-null edges, with
   mass squared equal to their pairwise area. Not just a construction - a coordinate for the
   entire forward cone.

3. **A geometrically generated, exactly unitary Dirac walk** (M, [orig]). The Plucker
   coordinate `z = psi wedge phi` generates a canonical odd-Hermitian mass operator, unique
   in its covariance class; it exponentiates to an exactly unitary walk converging to the
   Dirac flow at rate `O(1/n)`; the maximal momentum-space Hamiltonian is self-adjoint.

4. **The Standard-Model gauge and matter structure from division algebras** (M, [comp] for
   Furey's mechanism). Colour `SU(3)`, quantized electric charge, weak isospin `T3`,
   hypercharge, the Gell-Mann-Nishijima relation, `W+-`, and one-generation `SU(2)^2-U(1)`
   anomaly cancellation are kernel-checked operators on a division-algebra ideal.

5. **The GR/SM hinge: one object, two theories** (M, [orig]). The soldering capstone proves
   that a 2-spinor's rank-one Hermitian is a future-null Minkowski vector, that two
   non-parallel edges sum to a timelike vector whose invariant mass squared equals the
   Plucker area, and that this coincides - *by proof* - with both the trusted determinant
   mass and the `SL(2,C)` Lorentz action.

6. **A family of kernel-checked no-go obstructions** (M, [orig]) - the program's most
   reliable output type: fermion-doubling aliases that no onsite coin removes; a
   spectrum-does-not-determine-mass obstruction repaired exactly by moment data; a
   frame-blindness/rank obstruction on fluctuation suppression; a proof that an adiabatic
   leakage telescope cannot certify sector decoupling.

**What is supplied, not derived:** the octonionic internal algebra; spatial dimension three;
the discrete-gravity operator coefficients; the absolute mass/length scale; the
ladder-origin of `W+-` and `T3`. **What is open:** three fermion generations; gauge-boson
(Higgs-mechanism) mass; interacting field dynamics; any predicted number.

---

## Part I. Origin of mass (the flagship lane)

### I.1 The core theorem: mass as pairwise disagreement (T/M, [comp]+[orig])

`PhysicsSM.Spinor.PluckerMass`. For `psi_1,...,psi_N in C^2` with
`P = sum_i psi_i psi_i^dag`,
```
det P = || wedge^2 M ||_HS^2 = sum_{i<j} |det[psi_i  psi_j]|^2 >= 0,
```
vanishing exactly when the occupied directions span a line. Under the mostly-minus Pauli
map each `psi_i psi_i^dag` is a future-null momentum and `det P` is the Lorentzian square of
the total. Read physically: *a system built from lightlike constituents has invariant mass
equal to the total pairwise disagreement of their directions, and is massless exactly when
they all point one way.* The 2x2 Cauchy-Binet layer is classical; the finite bundle
formulation, the exact massless criterion, and the machine-checked packaging are the
contribution.

### I.2 Kinematic completeness: every mass is null-edge data (M, [comp]+[orig])

`PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness` (unconditional; eight
axiom-guarded theorems). The converse of I.1: a Hermitian `P` is positive semidefinite iff
it is a finite null-edge bundle `sum_i psi_i psi_i^dag`; under the Pauli map these are
exactly the future-pointing, non-spacelike four-momenta; each factor is future-null; and the
Lorentzian square is the pairwise area. Therefore **every future-causal four-momentum is a
sum of future-null edges whose pairwise disagreement is its mass** - the null-edge input is
not a special ansatz but a coordinate for the entire forward cone. Combined with the
Poincare-invariance of the Minkowski length, this licenses *completeness of representation*
for mass-as-Casimir.

**Scope discipline.** This is representation, not derivation. It does not select the
four-momentum and predicts no mass value; the two-spinor decomposition of a massive momentum
is classical amplitude kinematics (spinor-helicity), and only its finite formalization and
completeness packaging are new. It says nothing about the dynamical mechanisms that fix a
momentum's value.

### I.3 Three notions of mass - two joined by proof, one provably not (M, [orig])

The program carries three distinct quantities called mass, and the landed theorems fix how
they relate:

- **Composite/kinematic** (I.1) and **dynamical/spectral** (the mass parameter of the Dirac
  walk, read from a mass shell or resolvent pole) are **the same quantity** under the Plucker
  identification: `PluckerWalkMassBridge` proves the walk's Dirac square is `|k|^2 + det P`,
  the walk is massless exactly when the edges are parallel, and the resolvent stand-off is set
  by the same area.
- **Elementary/Yukawa** mass is **provably not determined** by the displayed Plucker data:
  `PlueckerYukawaModuli` exhibits two distinct admissible gauge-equivariant couplings sharing
  Plucker norm, determinant, *and* the full singular-value multiset. Gate A2 is a
  moduli/classification statement, not a uniqueness statement.

Bottom line for the lane: *the null-edge Plucker structure determines composite and dynamical
mass - one quantity, by proof - and provably does not determine elementary Yukawa masses from
the displayed invariants. The program explains the mass that comes from binding and
disagreement of directions; it does not, on this data, explain why the electron has the mass
it has.*

### I.4 The spectrum-to-mass dichotomy (M, [comp]+[orig])

`GapPoleGeneralObstruction` + `SpectralMeasureReadoutRepair`. Negative half: in every finite
dimension there exist operators with the *same spectrum* whose physical-sector weight takes
the extreme values `1` and `0`, so a `spectrum -> mass readout` map is ill-posed. Positive
half (the repair): the spectral *measure* determines the readout - the moment sequence
`<v, H^k v>` determines the weights by Vandermonde, with a matched sharpness witness showing
`n-1` moments do not suffice. Conclusion: *the physically correct input is the spectral
measure (the Kallen-Lehmann data), not the spectrum* - exactly what lattice practice extracts
from correlators.

### I.5 The origin-of-mass gates, honestly graded

- **A2 (Plucker -> Yukawa):** moduli gate, with a counterexample. See I.3.
- **A3 (composite bridge):** assembled in one model (`CompositeMassBridgeModel`) discharging
  gauge invariance, positivity, gap, and first-excited overlap simultaneously - but the model
  is three states and an abelian group. A *toy*, not a physical composite-mass result.
- **A4 (gap -> pole):** upgraded from obstruction to dichotomy. See I.4.
- **A5 (neutrino):** Dirac/Majorana classification, type-I and Schur seesaw, Weinberg dim-5,
  PMNS phases (`SeesawNGeneration`, `NeutrinoMassClassification`, ...). Caveat: a Majorana
  reading requires symmetry of the *inverse* mass matrix, not mere invertibility.
- **A6 (inertial = gravitational):** **Open.** Its former "finite core" headline was a
  hypothesis-free trace-pairing identity true for every matrix, so it is not evidence for the
  equivalence principle; recorded open.
- **CP structure:** a two-family Jarlskog CP-odd interference observable is kernel-checked at
  the *toy* level (`BargmannJarlskogToy`), together with a three-generation CP-threshold bridge
  (`CPThreeGenerationBridge`). The full three-family CKM Jarlskog closure is in progress, not
  landed - grade this a mechanism-level result, not a derivation of the measured Jarlskog value.

---

## Part II. The 3+1 quantum walk (from area to the Dirac gap)

Manuscript: `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`.

### II.1 The Plucker-derived mass operator, uniquely (M, [orig])

`PluckerMassOperator`, `PluckerRestOperatorUniqueness`. The complex Plucker coordinate
`z = psi wedge phi` generates the odd-Hermitian rest operator `B_z = [[0,z],[z-bar,0]]` with
`B_z^2 = det(P) I` and `(k Gamma + B_z)^2 = (k^2 + det P) I`. This assignment is the **unique**
positively homogeneous, phase-equivariant map with the displayed grading and normalization
(`equivariant_uniqueness_of_rest_map`, kernel-checked). The modulus is the rest energy, the
phase survives in oriented turn amplitudes, and a transported relative phase becomes a
gauge-invariant spectral mismatch - a free one-particle observable.

### II.2 Exact unitarity and the Dirac continuum limit (M, [orig])

Exponentiating `B_z` gives an exactly unitary null-step walk. Fixed-momentum symbols converge
to Dirac flow uniformly on bounded momentum and mass sets at rate `O(1/n)`; a changing-lattice
construction gives strong `L^2` convergence to the free massive Dirac flow for fixed mass,
time, and data. **Scope:** fixed mass/data/time, free evolution, no interactions - a solid,
citable QCA continuum-limit result whose distinguishing feature is that it is machine-checked.

### II.3 Self-adjointness and the mass-gap-aware resolvent (M, [orig])

`HNUMassiveMaximalMultiplier`, `HNUResolventDomainBridge`. The affine Hermitian symbol defines
a densely-defined maximal multiplication operator on momentum-space `L^2` that is self-adjoint
and closed (dense maximal graph domain, formal self-adjointness, both imaginary shifts
surjective). The fibre resolvent bound is *sharper than the unit norm*:
`(1 + |z|^2) ||R v||^2 <= ||v||^2`, so the resolvent stands off the spectrum by the full rest
gap `sqrt(1+|z|^2)` - the resolvent estimate itself sees the mass, with the norm-one bound its
massless shadow.

### II.4 The fermion-doubling obstructions (M/No-Go, [orig])

The finite `3+1` cubic walk is not globally doubler-free, and this is proven exactly, not
inferred from a plot: at the corners `{0,pi}^3` the massless symbol aliases the origin
(`U^(4) = (-1)^r I`); at body-center momentum the massive step is a non-scalar involution for
*every* mass angle, so quasienergies `0` and `pi` persist and there is no uniform Floquet gap.
An all-coins alias theorem proves that **no** momentum-independent onsite coin - the Plucker
mass coin included - removes any alias; extra range, coupled substeps, or enlarged cells are
structurally required. The interior crossings carry an exact per-node Floquet charge
bookkeeping that sums to zero at each quasienergy (an anomaly-inflow structure).

### II.5 Why a successor regulator is hard - the bundle obstruction and its tools (M, [orig])

The required extra structure has a bundle-theoretic reason: a nonzero one-particle index
forbids an exponentially localized orthonormal band basis, even though the band *projector*
stays quasi-local (the Wannier/K-theory obstruction). Two finite tools constrain any adiabatic
decoupling: a proof that the naive per-step leakage telescope *cannot* certify vanishing
leakage (its bound equals the total band-rotation angle in the limit, not zero -
`MovingProjectorTelescopeNoGo`), and a never-antipodal threshold that replaces the unreachable
"leakage -> 0" gate with a finite, checkable one (`NeverAntipodalThreshold`; the threshold
constant is conservative for the `SU(2)`-valued endpoint map).

**The honest 3+1 verdict.** This conforms to Nielsen-Ninomiya rather than evading it: the full
lattice is chirally balanced, the interest is in interior decoupling, and the opposite-chirality
companion remains in the full register. An alias-free exactly-local `3+1` regulator, interacting
field dynamics, and absolute-scale selection remain **open**.

---

## Part III. The Standard Model branch (division-algebra structure)

`PhysicsSM.Algebra.Furey` (49 modules) and `PhysicsSM.StandardModel`. This is a clean-room
formalization of Furey's programme; the mechanism is [comp] (Furey), the formalization [orig].

### III.1 Derived as kernel-checked operators (M)

- **Colour `SU(3)`** fundamental on the colour-triplet minimal ideal
  (`ColorTripletFundamental`, FB-SU3).
- **Quantized electric charge** `Q` with colour-charge conservation.
- **Weak isospin `T3`** with per-state eigenvalues; **hypercharge** (lepton `Y=-1`, quark
  `Y=1/3`); the **operator-level Gell-Mann-Nishijima relation** `Q = T3 + Y/2`.
- **`W+-`** raising/lowering operators with the `su(2)` commutators.
- **One-generation `SU(2)^2 - U(1)_Y` anomaly cancellation**
  (`OneGenerationPackage -> StandardModel.AnomalyPackage`).

### III.2 Why the weak force is left-handed (M, [comp]+[orig])

`ChiralityFromActionSplit` + `WeakIsospinChiralityProjector`. On the associative left-action
algebra, weak isospin acts by left multiplication and chirality is a right-multiplication
grading; left and right multiplication commute by associativity, so weak transitions cannot
change chirality - parity violation *without* a chiral projector imposed by hand. The chirality
operator on the leptonic ideal is exactly the (minus) fermion-parity of the two weak modes; the
`su(2)_L` generators are number-conserving, hence respect it. **Honest residual:** the
identification of weak-mode fermion parity with *spacetime* handedness is a supplied physical
input; and Furey/Todorov already state the informal observation, so only the kernel derivation
is [orig].

### III.3 The precise remaining electroweak gap and the deeper debts (Open / Supplied)

- **S2b (Open):** `W+-` and the `T3` eigenvalues are supplied as explicit maps/tables, *not*
  yet derived from the octonion ladder. A uniqueness handle exists (`WeakIsospinLadderDerived`:
  `[T3,T]=T`, `[Y,T]=0`, correct action forces `T = TPlusEnd`), but the ladder-origin is owed.
  `su(2)_L` requires quaternionic `C(x)H` input beyond `Cl(6)`.
- **Gauge-boson (Higgs-mechanism) mass (Open):** there is no null-edge account of `W/Z` mass via
  the Higgs mechanism / Goldstone sector - a genuine gap for any "all forms of mass" claim.
- **Three generations (Open):** the `Cl(6)` three-family structure is not built.
- **The octonionic internal algebra itself is Supplied** - the deepest SM debt.

---

## Part IV. General relativity from null edges

### IV.1 The soldering hinge: one object, two theories (M, [orig])

`NullEdgeSpinorSolderingAristotle` + `NullEdgeSolderingPluckerBridge`. A 2-spinor's rank-one
Hermitian `psi psi^dag` is a future-null Minkowski vector (`SL(2,C)`-equivariant); two
non-parallel edges sum to a timelike vector whose invariant mass squared is the Plucker wedge
area. Crucially, this is proven to **coincide** with both the trusted determinant mass
(`soldering_mass_eq_plucker_det`) and the project's `SL(2,C) -> SO+(1,3)` Pauli action
(`nullEdgeVector_eq_hermitianCoords`), and with the spiral corner calculus. This is the
kernel-checked realization of "the 2-spinor is simultaneously a matter state and a null
direction of spacetime" - the program's central unification claim, established at a point.

### IV.2 Finite Palatini and the interior Einstein equation (M conditional)

`FinitePalatiniBoundaryFlux`. An exact finite regional divergence (Gauss/Stokes) identity: the
incidence divergence summed over an interior equals its oriented cut flux. Under a boundary
counterterm hypothesis, fixed-boundary stationarity is equivalent to a finite Einstein equation
at each interior site. **Caveat (vacuity guard):** the equivalence rests on five structural
predicates that are not instantiated by any in-repo model; the honest label is *conditional
interior Einstein equation*, not "derive". The exact cut-flux identity itself is unconditional.

### IV.3 A concrete vacuum-Weyl jet and a no-branch obstruction (Realization/No-Go)

`NonlinearLorentzPalatiniConcreteVacuumWeylJet` realizes a nonflat vacuum-Weyl second jet on an
explicit `3^4` carrier, giving the standard mixed vacuum Einstein equation at that order.
`PeriodicVacuumWeylAnalyticNoBranch` (at `C2`) proves the realized jet does *not* continue to a
nearby nonlinear stationary branch. **Literature caveat:** pointwise-residual failure coexisting
with averaged convergence is a known, resolved phenomenon in Regge calculus (Brewin-Gentle,
Miller, Gentle) - averaging rescued it there - so the obstruction should be tested against an
averaged stationarity condition before being headlined.

### IV.4 The GR-branch debts (Supplied / Import / Open)

Spatial dimension three is supplied (shell-angular selector); the Benincasa-Dowker discrete
d'Alembertian coefficients are imported; the absolute scale is a Malament decoration (supplied).
The layer-coherent `(2,2)` no-go is a *derived* obstruction that sharpens the branch.

---

## Part V. The cosmological constant

### V.1 What is proven, and what was withdrawn (M, [orig])

The everpresent-`Lambda` question - can long-wavelength number fluctuations be pushed below
Poisson while staying symmetric? - motivated a family of finite linear-algebra results on
invariant covariance matrices:

- `FrameBlindnessSuppression` / `FrameBlindnessCompactGroup`: for a finite (resp. compact)
  transitive group action, an invariant PSD covariance that suppresses one regional mode
  suppresses its whole orbit-span; selective suppression requires breaking invariance.
- `HyperuniformityRankDichotomy` (the sharpest, and a *refutation of the requested claim*):
  invariance does **not** forbid hyperuniformity - `I - J/N` is invariant, PSD, and
  annihilates the uniform mode at every `N`. The real dichotomy is about the *shape* of
  regional variance: a 2-transitive (rank-2) symmetry *forces* the finite-population law
  `V(A) = a|A|(N-|A|)/(N-1)`, linear in region size; higher rank permits bounded regional
  variance (an explicit cyclic witness).
- `ExchangeableRegionalVariance`, `StabilizerOrbitCorrelationDecay`: the mechanism that
  actually underlies the causal-set situation is *point-stabilizer orbit size* - correlation
  at a separation class is bounded by the base variance over the class size, so large
  stabilizer orbits drive an invariant covariance toward white noise (Poisson).

### V.2 Honest scope (the withdrawn gloss)

**These are finite linear-algebra results about covariance matrices. They are not theorems
about point processes or Lorentz invariance, and they derive nothing about the value, sign, or
magnitude of `Lambda`.** An earlier gloss - "invariance forbids hyperuniformity, blocking the
everpresent-`Lambda` escape route" - was *withdrawn*: Torquato's reviews define disordered
hyperuniform systems as statistically isotropic, and the Lorentz group (with the interval as a
pair invariant) is nowhere near rank 2, so the finite obstruction does not apply to Poincare
invariance. The honest link is a finite illustration of how symmetry-rank constrains fluctuation
suppression - not a shadow of the causal-set zero-one laws.

---

## Part VI. Supporting mathematical results

- **Octonions and division algebras** (`PhysicsSM.Algebra.Octonion`, 50 modules; T/M, [comp]).
  The XOR-binary-label octonion algebra with Fano-orientation signs, composition/division
  properties, and the `G2`/`C3` structures. This is the trusted nonassociative foundation;
  parenthesization is explicit throughout (octonions are not associative).
- **Spin(10) pure-spinor / Selector theorem** (`PhysicsSM.Draft.Spin10*`; M partial + Open
  holes). The pure-spinor normal form and the single-pure-spinor orbit over algebraic
  `GSpin(10,C)` are landed; the marked-transitivity Selector step and a Fierz-identity step
  remain documented holes.
- **E8 / exceptional Lie theory** (`PhysicsSM.Lie`; **partial**). A determinant theorem is
  landed, but this is *not yet* a full formalization of the E8 root system. Graded partial to
  avoid over-claim.
- **Yang-Mills area law** (`PhysicsSM.Draft.NullEdge.GateYM`; M). A concrete-lattice area law
  is kernel-checked through the transport layer (a Kotecky-Preiss polymer step is the active
  frontier). A finite Wilson-loop area-law statement, not a continuum confinement proof.
- **Feynman checkerboard / luminal motion** (M, [comp]). Exact finite path-sum and
  corner-walk equivalence for the `1+1` checkerboard, with kernel-checked corner conventions.
- **Spiral layer / three-family CP** (M toy, [orig]). Kernel-checked pieces of the CP
  structure: a two-family Jarlskog CP-odd interference *toy* (`BargmannJarlskogToy`) and a
  three-generation CP-threshold bridge (`CPThreeGenerationBridge`); the crossover and the full
  three-family Jarlskog closure remain in progress.

---

## Part VII. The cross-cutting patterns

Two structural observations emerge only when the lanes are read together. Neither is a theorem;
both are honest descriptions of the result-shape.

**1. The blindness-and-breaker pattern (a three-way taxonomy, not one theorem).** In each lane a
leading-order quantity is provably *blind* to the datum the physics depends on, and the content
lives in the *first thing that breaks the blindness*. An adversarial test refuted the naive
"one unifying theorem" reading and replaced it with a verified three-way split: (i) genuine
orbit-quotient factorization (crossing orientation, Wilson-plaquette center, vacuum shift, and
the spectrum-blindness of mass); (ii) orbit *attainability* (the extreme-weight part of the mass
result); (iii) a genuinely different mechanism (independence of gauge invariance from
first-excited overlap). The mass lane's content is attainability, not invariance - which is why
it behaved differently throughout.

**2. Realized at finite order, obstructed at continuation.** In four of five lanes the program
owns a *proved obstruction* rather than an open gap, sitting at the same place each time -
between a finite or leading-order realization and its continuation to the full object: mass
(spectrum does not fix the readout), `3+1` (Wilson-Cayley strict-locality obstruction), GR (the
vacuum-Weyl jet does not continue to a nonlinear branch), `Lambda` (frame-blind suppression
cannot be made selective). This is a respectable epistemic position - and the exact opposite of
"we derive it all."

The program's most reliable and most defensible outputs are **no-gos and representation
theorems**, not derivations of numbers.

---

## Part VIII. The honest bottom line

**DERIVED (kernel-checked from null-edge structure):** colour `SU(3)`; mass = Lorentz-invariant
Plucker area, and its completeness over the whole forward cone; the CP-odd-as-oriented-volume
mechanism (at the two-family Jarlskog toy level); the Higgs stress algebra; the electroweak
quantum numbers and one-generation anomaly cancellation; the scale-reconstruction boundary; and
a family of obstructions (fermion-doubling aliases, spectrum-vs-mass, layer-coherent `(2,2)`,
frame-blindness rank dichotomy, leakage telescope).

**SUPPLIED / IMPORTED (the load-bearing debts):** the octonionic internal algebra; spatial
dimension three; the Benincasa-Dowker operator coefficients; the ladder-origin of `W+-`/`T3`
(S2b); the absolute scale.

**OPEN:** three fermion generations; gauge-boson (Higgs-mechanism) mass; the inertial =
gravitational identification (A6); interacting field dynamics; an alias-free local `3+1`
regulator; and any predicted number confronting experiment.

**The three sentences worth defending outward:**

1. *Every future-causal four-momentum is a sum of future-null edges whose pairwise disagreement
   is its invariant mass* - a complete, kernel-checked representation of mass as null-edge
   geometry (not a derivation of any mass value).

2. *One 2-spinor is simultaneously a matter state and a null direction of spacetime* - the
   GR/SM hinge, established at a point by the soldering capstone, with the mass, the Lorentz
   action, and the corner calculus proven to be the same objects.

3. *The Standard Model's colour, charge, hypercharge, Gell-Mann-Nishijima relation, weak
   isospin, and one-generation anomaly cancellation are operators on a division-algebra ideal* -
   a kernel-checked realization of Furey's mechanism, with the ladder-origin of the weak sector
   and the internal algebra itself honestly still supplied.

---

## Verification and provenance

Every headline result above lives in a module with a build-enforced axiom guard
(`#guard_msgs ... in #print axioms ...`) pinning it to the standard base
`[propext, Classical.choice, Quot.sound]`, with no `sorry`, `native_decide`, or added axioms in
trusted or flagship-draft code. The two manuscripts (`Null_Edge_P1_Origin_of_Mass_*` and
`Null_Edge_From_Area_to_Dirac_Gap_*`) carry per-result status marks and a reproducibility command
list; the claim-graded dependency map is
`Sources/Null_Edge_Derivation_Map_SM_GR_2026-07-17.md`. This document should be read alongside
those; where any of them disagrees, the kernel-checked statement in the cited module is
authoritative, and the prose - including this document's - is provisional until audited against
it.
