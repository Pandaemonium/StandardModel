# Origin-of-mass completeness ledger

Date: 2026-07-21
Owner: Codex
Work item: `MASS-ORIGIN-001`

## Executive verdict

There are two different completeness claims.

1. **Kinematic representation completeness.** Every future-causal total
   four-momentum can be represented as a finite sum of rank-one future-null
   spinor momenta, and its invariant mass squared is the total pairwise
   Pluecker wedge area. This is now kernel-checked and landed.
2. **Dynamical mechanism completeness.** Every admitted mass-generating or
   mass-extracting mechanism in a stated physical theory is realized by the
   null-edge dynamics and reconstructs the physical observable mass. This is
   not complete.

The first claim is universal in momentum space. It automatically represents
the total rest mass of elementary particles, composites, bound states, and
macroscopic systems once their future-causal total momentum is supplied. It
does not explain why dynamics selected that momentum, pole, coupling, or scale.

## Kinematic theorem ladder

| Rung | Exact content | Status |
|---|---|---|
| K1 | `det (sum_i psi_i psi_i^dagger) = sum_(i<j) |psi_i wedge psi_j|^2` | Landed |
| K2 | A `2 x 2` complex matrix is PSD iff it is a finite null-edge bundle momentum | Landed |
| K3 | Every nonnegative real mass is realized by an explicit two-edge bundle | Landed |
| K4 | Pauli soldering round-trip and `det (hermOfVec p) = minkowskiSq p` | Landed |
| K5 | Future-causal `p` implies `hermOfVec p` is PSD | Landed; Aristotle `fab399da` harvested and independently checked |
| K6 | Every future-causal `p` has a bundle with both vector and Pluecker-mass identities | Landed |
| K7 | The normalized quadratic Lorentz scalar is uniquely the Minkowski form | Landed; final Aristotle `b4554e39` source harvested, byte-matched, and independently checked |

K7 is a finite symmetry audit, not the full Wigner classification. Its exact
target says that invariance under two spatial half-turns, two quarter-turns,
and an exact rational Lorentz boost forces a symmetric quadratic form to be a
scalar multiple of the Minkowski metric.

## Mechanism taxonomy

The admissible universe must always be stated: field content, symmetries,
operator dimension, and observable/reconstruction rule. Relative to the
Standard Model plus declared neutrino extensions and finite composite transfer
models, the useful top-level rows are:

| Mechanism row | What is being classified | Current formal status | Null-edge status |
|---|---|---|---|
| Kinematic invariant | Total future-causal four-momentum and its Casimir | K1-K7 landed | Direct finite null-edge representation |
| Fermion chiral turn | Dirac/Yukawa map evaluated on the Higgs vacuum | Shared-vacuum and turn operators landed; arbitrary values remain inputs | Direct Pluecker rest-operator specialization exists, but dynamics does not force the specialization |
| Broken gauge orbit | Gram stiffness of broken gauge directions; stabilizer kernel | PSD Gram matrix, exact stabilizer criterion, and degree-of-freedom transfer landed | Finite operator analogue; no derivation from primitive null links |
| Scalar radial mode | Hessian normal to the vacuum orbit | Finite radial-curvature and propagation modules landed | Finite stiffness analogue; Higgs pole and `125 GeV` value not derived |
| Neutrino extension | Dirac, Majorana/Weinberg, and mixed/seesaw branches | Finite branch taxonomy and two-state physical singular masses landed; arbitrary-generation Takagi basis remains in flight | Operator/matrix representation; extra fields or higher-dimensional operators are explicit inputs |
| Composite rest energy | Gauge-invariant transfer/correlation spectrum of the interacting sector | Positive finite transfer, visible-overlap law, and a nondegenerate toy bridge landed | Kinematically represented by K6; physical `SU(3)` continuum mass is not derived |
| Inertial/gravitational response | Whether the same total rest response governs inertia and gravity | Finite equivalence/geometry controls only | A consistency test, not an additional additive mass contribution |

Unstable resonance masses, running masses, and medium effective masses are
different **readout definitions** of spectral or dispersion data. They should
not be added as new fundamental source rows without a stated effective theory.
Likewise, quark energy, gluon energy, explicit quark mass, and the trace anomaly
are subordinate decompositions of one hadron rest response, not four extra
masses to add on top.

## What can now be claimed

> Every future-causal four-momentum, and therefore every nonnegative
> relativistic invariant mass at the level of total momentum, admits a finite
> null-edge representation. Its mass squared is exactly the total pairwise
> Pluecker wedge area of that representation.

This is a representation theorem. It covers all species and mechanisms at the
kinematic output level because they all present a total future-causal
four-momentum. It does not classify their internal dynamics.

> Within the displayed finite Lorentz audit, the Minkowski square is the unique
> normalized quadratic momentum invariant, so the represented scalar is not an
> arbitrarily chosen quadratic mass proxy.

## What still cannot be claimed

- all observed mass values, ratios, or hierarchies are derived;
- every mass-generating mechanism is the same Pluecker mechanism;
- the Higgs potential, Yukawa matrices, QCD scale, or neutrino extension follows
  from null-edge kinematics;
- every finite operator gap is a physical pole mass;
- the finite composite model is continuum `SU(3)` QCD;
- the full Wigner/Poincare representation classification is formalized;
- gravitational and inertial mass equivalence follows from the kinematic bundle
  theorem.

## Completion gates for the stronger mechanism claim

1. Freeze an admissible action/operator class and prove the taxonomy exhaustive
   relative to that class. Exhaustiveness without fixed field content and
   operator dimension is not a well-posed theorem.
2. Give every row a typed map from primitive null-edge/carrier data to the
   corresponding response operator. A visual analogy or shared word such as
   "stiffness" does not count.
3. Prove non-double-counting: the kinetic Pluecker shell and an internal mass
   block are an on-shell consistency relation, not independent additive masses.
4. Apply one common reconstruction contract: positive physical sector,
   positive evolution/spectral measure, isolated visible support, correct
   dispersion, and controlled continuum limit.
5. Supply a nondegenerate witness and a kill condition for every row.
6. Separate representation from selection. A scale-selection action, RG
   transmutation theorem, or a broad no-go is still required for observed
   numerical masses.

## Scoped grammar landing

`ScopedMassMechanismGrammar.lean` now makes the mechanism quantifier explicit.
It provides typed response domains for fermion, gauge-orbit, scalar-normal,
neutrino, and composite-transfer responses; separately records source rows and
mass readouts; and names symmetric mass generation, higher-dimensional
operators, undeclared fields, and nonlocal responses as outside-grammar
boundaries. The theorem `classified_iff_admissible` proves exact closure of
this declared syntax, while the module docstring states why this is not yet a
classification of the quadratic expansion of a physical action.

This closes the bookkeeping part of completion gate 1. The nontrivial next
theorem must define a finite action grammar, take its vacuum expansion, and
prove that every resulting quadratic rest response maps into the typed syntax
modulo gauge redundancy and field redefinition.

## Immediate work queue

1. Finish arbitrary-generation Autonne-Takagi without distinct/nonzero
   singular-value assumptions.
2. Lift the landed typed mechanism grammar from syntax closure to a theorem
   about the quadratic expansion of a declared finite action.
3. Upgrade the finite composite bridge from the abelian toy to a nonabelian
   gauge-invariant transfer observable, then pursue reflection-positive and
   changing-lattice reconstruction.

## Primary local anchors

- `PhysicsSM/Draft/NullEdge/PluckerMassKinematicCompleteness.lean`
- `PhysicsSM/Draft/NullEdge/FiniteLorentzMassCasimir.lean`
- `PhysicsSM/Draft/NullEdge/ScopedMassMechanismGrammar.lean`
- `PhysicsSM/Draft/NullEdge/GateI1/Core.lean`
- `PhysicsSM/Draft/NullEdge/SharedHiggsMassData.lean`
- `PhysicsSM/Draft/NullEdge/CompositeMassBridgeModel.lean`
- `PhysicsSM/Draft/NullEdge/ObservableGapLinkage.lean`
- `PhysicsSM/Draft/NullEdge/MixedPseudoDiracPhysicalMass.lean`
- `PhysicsSM/Draft/NullEdge/FiniteTakagiMajoranaPartial.lean`

Literature and package audit: PhysLean contains Lorentz-vector and Minkowski
product infrastructure but no ready Poincare/Wigner mass-classification theorem.
The mechanism rows and reconstruction obligations follow the source audit in
`CODEX_LITERATURE_ORIGIN_MASS_CLASSIFICATION_2026-07-20.md`.

The historical classification anchor is E. Wigner, "On Unitary
Representations of the Inhomogeneous Lorentz Group," *Annals of Mathematics*
40 (1939), DOI `10.2307/1968551`. The present K7 target does not formalize that
paper: it cleanly extracts only the quadratic-Casimir uniqueness needed here.
Crossref resolved the DOI during this pass. The local Neo4j semantic search
returned no scoped hit, and the Zotero reader was temporarily unreachable, so
no new library item was written.
