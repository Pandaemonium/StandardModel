# Null-edge Gate C1 non-ultralocal release plan

Date: 2026-06-27

Status: strategic branch, not yet a proved theorem.

Gemini Deep Research note:

```text
Some external analyses use GateC1_NL as the umbrella name for everything that
drops ultralocality. In this repo, keep the sharper split:
  GateC1_NU = controlled non-ultralocal release;
  GateC1_NL = declared nonlocal fallback.
```

Do not let imported `NL` language demote the main target. If a construction has
path-sum, resolvent, finite-volume, spectral-island, or tail-control data, route
it through `GateC1_NU`. Use `GateC1_NL` only when the construction deliberately
makes no controlled non-ultralocality claim.

Gemini Deep Research integration status:

```text
The Gemini packet supports the strategic split, but its GateC1_NL umbrella
language is translated here into the sharper repo taxonomy:
  GateC1_local = local or exponentially/quasi-locally controlled release;
  GateC1_NU    = controlled non-ultralocal release;
  GateC1_NL    = declared nonlocal fallback.
```

Its main added value is not a new construction of the physical projector. The
central unknown remains the same:

```text
Find a null-edge-native branch observable B(U) whose target spectral island has
nonzero origin chiral index and whose complement has a true inverse bad-sector
gap.
```

What the Gemini packet does sharpen is the audit posture around any proposed
non-ultralocal release:

```text
SLAC-style tails:
  audit slow decay, interacting phase structure, and scaling behavior.

Stacey/tangent-style kernels:
  audit zone-edge poles, spectral-island separation, and finite-volume
  normalization.

Overlap/Ginsparg-Wilson/sign kernels:
  treat exponential locality as a sufficient theorem under gap/smoothness
  hypotheses, not as the primitive null-edge control notion.

SMG or mirror-decoupling analogies:
  reject propagator-zero mirror removal; require a true inverse-propagator gap.

Riesz/resolvent projectors:
  use them only with explicit spectral-island, gauge-covariance, path-sum or
  finite-volume/regulator-control data.
```

So the plan change is conservative:

```text
Do not rename the working target to uncontrolled GateC1_NL.
Do strengthen the GateC1_NU release audit with tail class, regulator scaling,
zone-edge, ghost-zero, and determinant/anomaly checkpoints.
```

## 1. Decision

Keep the old local target, but add a separate non-ultralocal theorem program.

Use three target labels:

```text
GateC1_local:
  finite-range or exponentially/quasi-locally controlled physical chiral
  release.

GateC1_NU:
  non-ultralocal release. The operator is not required to be finite-range or
  exponentially local, but it must have explicit control by path sums,
  resolvents, spectral calculus, finite-volume limits, power-law tails, or
  another non-ultralocal certificate.

GateC1_NL:
  explicitly nonlocal release. No locality claim is made, but spectral control,
  gauge covariance or dressing, true bad-sector inverse gap, ghost-zero
  exclusion, anomaly accounting, Krein positivity, and regulator stability
  remain mandatory.
```

The working target is:

```text
GateC1_NU first.
GateC1_NL only if path-sum / resolvent / finite-volume control cannot be
upgraded.
```

Guiding sentence:

```text
We are dropping finite-range / exponential locality as a release requirement.
We are not dropping spectral control, gauge covariance, ghost-zero exclusion,
anomaly accounting, Krein positivity, or regulator stability.
```

Dropping ultralocality removes a Nielsen-Ninomiya-type assumption. It does not
solve the ghost, anomaly, gauge, Krein, or regulator problems.

## 2. Claim boundary

`GateC1_NU` may claim:

```text
one retained physical Weyl branch;
true inverse-propagator bad-sector gap;
no propagator-zero mirror removal;
gauge covariance or precise gauge dressing, at the relevant level;
Krein-positive physical residues, at the relevant level;
anomaly accounting or explicit anomaly obstruction, at the quantum level;
regulator stability inside the non-ultralocal target;
declared non-ultralocal control.
```

It must not claim automatically:

```text
finite-range locality;
exponential locality;
cluster decomposition;
ordinary local continuum QFT;
compact-gauge-field locality;
gauge-invariant chiral determinant without anomaly work;
unitarity outside the audited physical sector.
```

## 3. Three theorem levels

Do not prove the full quantum gauge theory in one theorem. Stage `GateC1_NU`.

### Level 0: kinematic/free release

```text
GateC1_NU_Free
```

Proves only:

```text
one physical Weyl branch;
bad sector has true inverse-propagator gap;
no propagator-zero mirror removal;
declared non-ultralocal control.
```

No dynamical gauge determinant is claimed.

### Level 1: background-gauge release

```text
GateC1_NU_BackgroundGauge
```

Adds:

```text
gauge covariance or precise gauge dressing;
Krein-positive physical residue;
stability under admissible gauge backgrounds.
```

This still does not claim a fully gauge-invariant chiral determinant.

### Level 2: quantum/anomaly-complete release

```text
GateC1_NU_Quantum
```

Adds:

```text
determinant-line control;
anomaly accounting;
regulator stability strong enough for the intended quantum claim.
```

This split blocks the false inference:

```text
one-Weyl kinematic selection => consistent dynamical chiral gauge theory.
```

## 4. Native non-ultralocal control: path sums first

Do not make exponential decay the primitive definition. The null-edge-native
control notion should be combinatorial:

```text
operator kernel = sum over allowed null-edge paths.
```

For cells or vertices `x,y`, gauge field `U`, and allowed path class
`Gamma(x,y)`, write:

```text
K(x,y;U) = sum_{gamma in Gamma(x,y)} A(gamma;U).
```

Here `A(gamma;U)` is a path amplitude built from edge transports, branch
weights, spin/internal factors, phases, regulator weights, and any spectral
projector factors.

The primitive certificate is:

```text
PathSumControl:
  1. allowed path class Gamma(x,y);
  2. gauge-covariant path amplitude A(gamma;U);
  3. convergence or regulated convergence of sum_gamma A(gamma;U);
  4. controlled tails by path length, action, cost, or filtration;
  5. stability under admissible gauge fields and regulator removal.
```

Exponential decay is one sufficient special case:

```text
number of paths of length n <= C_path b^n,
amplitude per path <= C_amp a^n,
a b < 1,
therefore the long-path tail is summable, with exponential tail bound.
```

But the plan should also allow:

```text
power-law tails;
oscillatory Feynman-style cancellation;
resolvent or Riesz-kernel tails;
regulated finite-volume path sums;
intentionally nonlocal but canonical projectors.
```

Guardrail:

```text
Absolute or uniformly summable tail control is strongest.
Pure cancellation-based convergence is allowed only with an explicit
conditional-convergence audit, because it can otherwise hide ghosts or
projection artifacts.
```

Interacting-gauge guardrail:

```text
Tail control must be checked in the intended gauge/background class, not only
for the free symbol. Long-range kernels can change phase structure, scaling,
and finite-volume normalization even when they remove free doublers.
```

## 5. Central object: a canonical branch observable

The hard object is no longer a local `T_br`.

The hard object is:

```text
B(U)
```

a canonical Hermitian or Krein-Hermitian branch observable.

Requirements:

```text
B(U) is built from null-edge-native data;
B(U) is gauge-covariant or precisely gauge-dressed;
B(U) has a target spectral island separated by delta > 0;
the target island has nonzero chiral index;
the target island corresponds to exactly one physical Weyl branch;
the complement admits a true inverse bad-sector gap.
```

Start finite-dimensionally with the polynomial spectral projector:

```text
Pi_phys(U) = p(B(U)),
```

where:

```text
p(lambda) = 1 on target spectral values;
p(lambda) = 0 on bad-sector spectral values.
```

The polynomial version should be formalized before the Riesz contour integral.
It is easier in finite Lean and already captures the projector and gauge
covariance logic.

The Riesz form is the later analytic version:

```text
Pi_phys(U) =
  (1 / 2 pi i) integral_Gamma (z - B(U))^{-1} dz,
```

where `Gamma` encloses only the target spectral island.

## 6. Gauge covariance of spectral projectors

If:

```text
B(U^g) = g B(U) g^{-1},
```

then polynomial spectral projectors satisfy:

```text
p(B(U^g)) = g p(B(U)) g^{-1}.
```

The Riesz version similarly follows from:

```text
(z - B(U^g))^{-1} = g (z - B(U))^{-1} g^{-1}.
```

This is why the branch observable route is preferable to a gauge-fixed branch
label.

## 7. Origin polarization test for every candidate `B`

A major trap is:

```text
B = D_+^dagger D_+
```

This is canonical, positive, and likely gauge-covariant, but it may be scalar
on the balanced origin kernel. It may distinguish zero/nonzero spectrum while
still failing to distinguish physical chirality.

Every candidate `B` must therefore pass:

```text
ChiralIndex Gamma0 (p(B0)) = targetIndex != 0.
```

If `B0` commutes with the chirality-flipping balance symmetry `J`, then every
polynomial `p(B0)` also commutes with `J`, and the C106a trace theorem forces:

```text
ChiralIndex Gamma0 (p(B0)) = 0.
```

Finite sanity check:

```text
If B commutes with the balance symmetry J, its spectral projector cannot select
one Weyl branch.
```

The non-ultralocal plan does not avoid the origin-polarization issue. It avoids
the locality obstruction after a valid polarizing observable exists.

## 8. Released non-ultralocal operator

Let:

```text
P = Pi_phys,
Q = 1 - P.
```

The cleanest first construction is exactly block diagonal:

```text
D_NU = P D_weyl P + m Q.
```

Physical branch clause:

```text
P D_NU P = sigma^mu q_mu + O(|q|^2)
```

on one retained Weyl line with the desired chirality.

Bad-sector clause:

```text
sigma_min(Q D_NU Q) >= m > 0.
```

This is a true inverse-propagator gap. It must not be replaced by a zero of the
propagator or a point-split numerator.

Only after proving the exact block-diagonal theorem should we add off-diagonal
Schur-control:

```text
D_NU =
  [ A(q)      B_mix(q) ]
  [ C_mix(q)  D_bad(q) ]

A(q) = sigma^mu q_mu + O(|q|^2)
||B_mix(q)||, ||C_mix(q)|| = O(|q|)
sigma_min(D_bad(q)) >= m > 0
```

Then:

```text
A_eff(q) = A(q) - B_mix(q) D_bad(q)^{-1} C_mix(q)
         = sigma^mu q_mu + O(|q|^2).
```

## 9. Proposed Lean/API vocabulary

Use a hierarchy rather than one locality predicate:

```lean
inductive NonultralocalControlKind where
  | finiteRange
  | exponentialTail
  | powerLawTail
  | absolutelySummablePathSum
  | regulatedFiniteVolumeLimit
  | resolventFunctionalCalculus
  | oscillatoryPathSumWithAudit
  | declaredNonlocal
  | formalOnly
```

Qualifying rules:

```text
GateC1_local:
  finiteRange or exponentialTail.

GateC1_NU:
  finiteRange, exponentialTail, powerLawTail, absolutelySummablePathSum,
  regulatedFiniteVolumeLimit, resolventFunctionalCalculus, or
  oscillatoryPathSumWithAudit.

GateC1_NL:
  declaredNonlocal, or any GateC1_NU control kind.
```

Forbidden coercions:

```text
formalOnly -> GateC1_NU
declaredNonlocal -> GateC1_local
declaredNonlocal -> GateC1_NU
ProjectorFamily P -> LocalityCertificate P
PathSumControlled P -> ExponentialTail P
```

Sketch:

```lean
structure GateC1_NU_Free (Core : NullEdgeCore) : Prop where
  D_NU :
    ReleasedOperator Core
  Pi_phys :
    BranchProjector Core
  Gamma_lat :
    LatticeChirality Core
  projector :
    IsProjectorFamily Pi_phys
  oneWeyl :
    PhysicalWeylLine D_NU Pi_phys Gamma_lat
  continuumSymbol :
    ContinuumWeylSymbol D_NU Pi_phys Gamma_lat
  badInverseGap :
    UniformBadSectorInverseGap D_NU Pi_phys
  noGhostZero :
    NoPropagatorZeroMirrorRemoval D_NU Pi_phys
  nonultralocalControl :
    NonultralocalControlCertificate D_NU Pi_phys
```

```lean
structure GateC1_NU_BackgroundGauge (Core : NullEdgeCore)
    extends GateC1_NU_Free Core where
  gaugeSafe :
    GaugeCovariantOrDressed D_NU Pi_phys
  kreinPositive :
    KreinPositivePhysicalResidue D_NU Pi_phys
  stableBackgrounds :
    StableUnderAdmissibleGaugeFields D_NU Pi_phys
```

```lean
structure GateC1_NU_Quantum (Core : NullEdgeCore)
    extends GateC1_NU_BackgroundGauge Core where
  anomaly :
    AnomalyAccounted D_NU Pi_phys Gamma_lat
  determinantLine :
    DeterminantLineControlled D_NU Pi_phys
  stable :
    RegulatorStable D_NU Pi_phys
```

## 10. Theorem stack

Replace the old single C106 bridge with a non-ultralocal sequence.

### C106_NonultralocalGateC1_API

Defines:

```text
GateC1_NU_Free
GateC1_NU_BackgroundGauge
GateC1_NU_Quantum
NonultralocalControlKind
PathSumCertificate
DeclaredNonlocal
UniformBadSectorInverseGap
NoGaugeCoupledGhostZeros
```

Acceptance tests:

```text
formalOnly cannot prove GateC1_NU;
declaredNonlocal cannot prove GateC1_local;
declaredNonlocal does not qualify for controlled GateC1_NU;
bad sector requires inverse gap.
```

### C107_FiniteSpectralProjectorGaugeCovariance

Proves polynomial spectral projector facts:

```text
p(B)^2 = p(B) from finite spectral/idempotence hypotheses;
B gauge-covariant implies p(B) gauge-covariant;
spectral island data gives a canonical projector.
```

This is the best next finite job.

### C108_OriginBranchObservableCertificate

Defines and proves:

```text
if B0 commutes with balance symmetry J,
then every polynomial/spectral projector p(B0) has zero chiral index.
```

Acceptance test:

```text
candidate B must escape J at the origin.
```

### C109_NonultralocalBlockGapRelease

Proves:

```text
P D_weyl P + m(1-P)
```

has:

```text
one Weyl branch;
bad inverse gap at least m;
no propagator-zero mirror removal by construction;
gauge covariance if P and D_weyl are gauge-covariant.
```

### C110_PathSumControl

Proves:

```text
path_count(n) <= C b^n
amplitude_bound(n) <= A a^n
a b < 1
=> controlled summable tail.
```

Also define power-law and regulated finite-volume variants later.

Note: an early C108 path-sum control Aristotle job was submitted before this
numbering sharpened. Treat it as an early `C110_PathSumControl` result or
renumber during integration.

### C111_ResolventPathExpansion

Connects spectral projectors to null-edge path sums:

```text
Riesz/resolvent projector admits path-sum expansion under Neumann/gap
hypotheses.
```

This makes the spectral-projector route and path-sum route the same
architecture.

### C112_DeterminantLineAnomalyContract

Defines:

```text
AnomalyAccounted
DeterminantLineControlled
GaugeableAnomalyFreeMultiplet
HasInflowOrCounterterm
BadSectorGhostAnomaly
BadSectorMirrorAnomaly
```

This is where `GateC1_NU_Quantum` becomes stricter than kinematic release.

## 11. Candidate `B(U)` sources and triage

### Candidate 1: `B = D_+^dagger D_+`

Likely insufficient.

Pros:

```text
canonical;
positive Hermitian;
gauge-covariant if D_+ is.
```

Risk:

```text
probably scalar on the balanced origin kernel;
detects zero/nonzero, not physical chirality.
```

Acceptance test:

```text
ChiralIndex Gamma0 chi_target(B0) != 0.
```

### Candidate 2: Hermitian spectral-flow kernel

Use an overlap-like kernel:

```text
H_NED(U;m) = Gamma_lat (D_NED(U) - m R)
T_NU = sign(H_NED)
Pi_phys = (1 + T_NU)/2.
```

Pros:

```text
known conceptual lane;
sign kernels are standard in overlap/Ginsparg-Wilson constructions;
can be gauge-covariant.
```

Risks:

```text
needs spectral island / mass-window theorem;
may inherit raw-overlap singular crossing hazards;
not null-edge-native unless H_NED is native.
```

### Candidate 3: path-cost / null-edge action observable

Define `B` from a null-edge path action, cost, or transfer operator:

```text
B = branch-cost observable.
```

Pros:

```text
most null-edge-native;
connects directly to path-sum control.
```

Risks:

```text
needs proof that the target island has nonzero chiral index;
may classify routes/tastes rather than chirality.
```

### Candidate 4: finite-volume spectral projector

On a finite lattice volume:

```text
B_L = canonical finite-volume branch observable
Pi_L = chi_target(B_L)
```

Then prove convergence in matrix elements, correlators, or path-sum tails.

Guardrail:

```text
B_L must be generated from null-edge data before Pi_L is defined.
```

### Candidate 5: tautological `B = 2P - 1`

Use only as an API sanity check. It proves:

```text
if a good projector already exists, then a spectral observable exists.
```

It is not a construction.

## 12. Immediate action list

1. Freeze `GateC1_local` as unsolved.

2. Promote `GateC1_NU` as the controlled non-ultralocal target, reserving
   `GateC1_NL` for explicit declared nonlocal fallback.

3. Prove finite polynomial spectral-projector covariance:

```text
C107_FiniteSpectralProjectorGaugeCovariance
```

4. Prove balance-commuting spectral projectors have zero chiral index:

```text
C108_OriginBranchObservableCertificate
```

5. Define the origin candidate-`B` certificate.

6. Prove the block-diagonal non-ultralocal release theorem:

```text
C109_NonultralocalBlockGapRelease
```

7. Integrate or renumber the existing path-sum control job as:

```text
C110_PathSumControl
```

8. Only then search hard for actual `B` candidates.

## 13. What can be claimed after each milestone

After `C107 + C108`:

```text
We have a canonical finite spectral branch-projector API, provided B exists
and passes the origin chiral-index test.
```

After `C109`:

```text
We have a kinematic non-ultralocal C1 release theorem from any certified branch
projector.
```

After `C110 + C111`:

```text
The branch projector is not merely formal; it has path-sum/resolvent control.
```

After `C112`:

```text
The release can be promoted, if anomaly conditions hold, to a quantum
background/dynamical gauge-theory claim.
```

Before `C112`, do not claim a completed chiral gauge theory.

## 14. Historical nonlocal-warning lane

Gemini Deep Research reinforced that non-ultralocality is a real escape from a
Nielsen-Ninomiya assumption, but also surfaced a useful historical warning:
long-range lattice fermion kernels have their own pathologies. These warnings
should be used as audit prompts, not as automatic no-go claims.

### SLAC-type derivatives

SLAC-style nonlocal derivatives avoid doublers by using a discontinuous or
sawtooth-like momentum symbol, producing long-range position-space couplings.

Audit lesson:

```text
Non-ultralocal branch selection must include tail/scaling/interacting-gauge
audits. A formal no-doubler derivative is not automatically a healthy
continuum gauge theory.
```

Gemini sharpened this warning: the dangerous part is not merely that the kernel
is nonlocal, but that slowly decaying tails can alter interacting phase
structure and Mermin-Wagner-type expectations. Treat this as an audit prompt,
not as a theorem already proved against the null-edge construction.

Plan impact:

```text
Path-sum control should record the tail class explicitly:
  absolute summability,
  power-law exponent,
  oscillatory conditional convergence,
  finite-volume regulated limit,
  resolvent expansion.
```

If the tail is only conditionally controlled by cancellation, require a separate
stability audit under admissible gauge backgrounds.

### Stacey / tangent-fermion style kernels

Tangent-dispersion or generalized-eigenvalue fermions can preserve useful
single-cone/chiral behavior while producing effective nonlocal kernels and
zone-edge singular behavior.

Representative warning shape:

```text
H(k) proportional to tan(a k / 2)
```

or a local generalized-eigenvalue problem whose effective Hamiltonian is
nonlocal. This can isolate a single cone in useful condensed-matter settings,
but zone-edge poles and finite-volume normalization factors must be audited
before any gauge-theory claim.

Audit lesson:

```text
Spectral islands must be separated by a real mass window, and regulator
normalization/scaling must be audited. A branch projector that is formal at
finite volume may still have bad large-volume normalization or zone-edge
singularities.
```

Plan impact:

```text
C107/C111 should not stop at projector existence.
They need spectral-island separation and finite-volume/regulator-stability
fields before being used in release claims.
```

### Symmetric mass generation

SMG remains a separate route:

```text
C1_SMG keeps locality but abandons freeness.
C1_NU keeps a free/operator release theorem but abandons ultralocality.
```

Do not mix SMG into `GateC1_NU` too early. The Golterman-Shamir warning about
propagator zeros applies directly to any mirror-decoupling story that replaces
massive poles with zeros.

Plan impact:

```text
GateC1_NU requires UniformBadSectorInverseGap.
No SMG-inspired propagator-zero removal may satisfy the bad-sector gap clause.
```

### Domain-wall / boundary constructions

Domain-wall fermions are a separate extra-dimensional escape route. They can
separate chiral modes on different boundaries, but they also introduce bulk
volume, residual chiral-symmetry breaking at finite wall separation, and a
different locality question.

Plan impact:

```text
Use domain-wall ideas only if the null-edge core supplies a native
bulk-to-boundary map or if the construction is explicitly marked as an imported
comparison class.
```

This keeps the non-ultralocal branch from quietly becoming a higher-dimensional
domain-wall theory without a stated bridge.

### Overlap / Ginsparg-Wilson

Overlap and Ginsparg-Wilson remain the comparison class for a controlled
non-ultralocal spectral/sign kernel. Hernandez-Jansen-Luescher-style
exponential locality should be treated as a sufficient theorem under gap and
smoothness hypotheses, not as the primitive definition of control.

Plan impact:

```text
C110_PathSumControl:
  derive exponential decay as a subcritical path-entropy corollary when
  possible.

C111_ResolventPathExpansion:
  connect Riesz/sign/resolvent kernels to path sums through Neumann or
  functional-calculus expansions.
```

### Literature anchor checklist

Before promoting a `GateC1_NU` result into a manuscript claim, cross-check the
claim against the relevant historical lane:

```text
Nielsen-Ninomiya / Friedan:
  which locality, continuity, Hermiticity, translation, and chirality
  assumptions were dropped?

Neuberger / overlap / Ginsparg-Wilson / Luescher:
  is the spectral/sign construction gauge-covariant, and what anomaly or
  determinant-line claim is actually being made?

Hernandez-Jansen-Luescher:
  is exponential locality being claimed as a theorem, or only used as a
  sufficient comparison case?

SLAC / Stacey:
  do tails, zone-edge singularities, and finite-volume normalization pass the
  intended interacting/regulator audit?

Golterman-Shamir / SMG warnings:
  is every unwanted gauge-charged branch given a true inverse-propagator gap
  rather than a propagator zero?
```

## 15. Risk ledger

```text
Risk 1:
  B exists only as a hand-built projector.
  Fix: require NativeBranchObservable before defining Pi_phys.

Risk 2:
  B classifies route/taste labels, not chirality.
  Fix: require nonzero origin chiral index.

Risk 3:
  B commutes with the balance symmetry J.
  Fix: prove zero-index no-go and reject such B.

Risk 4:
  bad sector is removed by propagator zero.
  Fix: require UniformBadSectorInverseGap.

Risk 5:
  non-ultralocal projector breaks gauge covariance.
  Fix: define Pi_phys spectrally from gauge-covariant B.

Risk 6:
  non-ultralocality causes uncontrolled continuum behavior.
  Fix: require path-sum, resolvent, finite-volume, or declared-nonlocal
  control; do not call it local.

Risk 7:
  one-Weyl kinematics is mistaken for an anomaly-free gauge theory.
  Fix: separate GateC1_NU_Free from GateC1_NU_Quantum.

Risk 8:
  non-ultralocal tails reproduce known SLAC/Stacey-style scaling or interaction
  pathologies.
  Fix: require explicit tail class, finite-volume/regulator normalization, and
  admissible-gauge stability audits.

Risk 9:
  external `GateC1_NL` language collapses the controlled non-ultralocal target
  into a weaker declared-nonlocal fallback.
  Fix: translate umbrella `NL` claims into `GateC1_NU` when a control
  certificate exists; reserve `GateC1_NL` for deliberately uncontrolled
  declared nonlocality.

Risk 10:
  finite-volume spectral projectors look correct while hiding zone-edge poles,
  volume-growing normalization, or bad regulator scaling.
  Fix: require spectral-island separation plus finite-volume/regulator
  normalization before using a projector in a release claim.
```

## 16. Bottom line

The non-ultralocal plan is:

```text
Define GateC1_NU first.
Construct a canonical branch observable B.
Select the physical branch by finite spectral, Riesz, sign, or path-sum
projector.
Require nonzero origin chiral index.
Control the kernel by combinatorial path sums, resolvent expansion,
finite-volume limit, or another explicit non-ultralocal certificate.
Prove a true inverse bad-sector gap.
Keep ghost, anomaly, gauge, Krein, and regulator audits mandatory.
Reserve GateC1_NL for explicit declared nonlocal fallback.
```

The decisive object is:

```text
B(U).
```

The decisive finite test is:

```text
Does chi_target(B0) have nonzero chiral index on the balanced origin fiber?
```

If yes, the non-ultralocal release theorem is likely reachable. If no native
`B` passes that test, the nonlocal route can still be made mathematically
formal, but it is not a null-edge-native C1 solution.

## 17. Pro/Furey-Hughes synthesis update

Two new Pro analyses sharpen the next move.

The pre-Furey/Hughes analysis ranked Schur-Feshbach / gapped auxiliary structure
as the strongest practical source of a native branch observable:

```text
K_eff = K_LL - V (K_HH)^{-1} W.
```

The post-Furey/Hughes analysis ranked a null-edge overlap/sign branch
involution as the strongest conceptual selector:

```text
T_br(U) = sign(H_ne(U));
P_phys(U) = (1 + T_br(U)) / 2;
P_bad(U) = (1 - T_br(U)) / 2.
```

The combined architecture is now:

```text
Use a preferred sign/involution/complex-structure projector for branch
selection.

Use Schur-Feshbach, domain-wall, boundary, or structured auxiliary machinery for
the safe mirror gap.

Control the resulting non-ultralocality by finite-volume path sums, resolvent
expansions, or spectral calculus with explicit tail/regulator audits.
```

This is the structural lesson from Furey/Hughes: the selector should be an
internally preferred algebraic structure whose centralizer preserves the good
symmetries while its projector breaks the physical/mirror balance. It should
not be an arbitrary scalar correction.

### Updated candidate ranking

```text
1. Null-edge overlap/sign branch involution:
     T_br(U) = sign(H_ne(U)).
   Best if H_ne is genuinely null-edge-native and P0 sign(H_ne) P0 is
   balance-odd on the origin kernel.

2. Schur-Feshbach / gapped-auxiliary observable:
     K_eff = K_LL - V (K_HH)^{-1} W.
   Best practical source of a native self-energy, a path-sum expansion, and a
   true bad-sector gap.

3. Domain-wall / boundary-transfer observable:
   a sign or transfer-matrix implementation of the same selector/gap idea.
   Treat branch depth, causal layer, or Schur elimination depth as the native
   analogue before adding a literal new physical dimension.

4. Null-edge complex structure from primal/dual soldering:
     C_ne^2 = -1, with projectors (1 +/- i C_ne) / 2.
   Very close to the Furey/Hughes complex-structure pattern, but it fails C1 if
   C_ne is central or balance-even on the origin kernel.

5. Path-orientation, holonomy, or branch-geometry observables:
   highly native, but dangerous if they collapse to traced scalar data or merely
   classify tastes/routes instead of chirality.

6. Raw finite-volume path sums:
   best used as an implementation/control layer for the above constructions,
   not as an arbitrary hand-built selector.
```

Negative control:

```text
Scalar, central, or balance-even corrections on the origin kernel are presumed
dead for C1 unless a later non-polynomial or controlled nonlocal step creates a
genuine balance-odd origin component.
```

### Schur parity criterion

For a block self-energy

```text
Sigma = V M^{-1} W,
```

with balance involutions `J_L` and `J_H`, record parities:

```text
J_L V J_H = sigma_V V;
J_H M^{-1} J_H = sigma_M M^{-1};
J_H W J_L = sigma_W W;
sigma_V, sigma_M, sigma_W in {+1, -1}.
```

Then:

```text
J_L Sigma J_L = (sigma_V sigma_M sigma_W) Sigma.
```

Therefore the Schur channel produces a balance-odd origin self-energy exactly
when:

```text
sigma_V sigma_M sigma_W = -1.
```

If all three ingredients are balance-even, the Schur term is balance-even and
cannot be the missing C1 selector.

### C1-Origin+ pre-release audit

Keep C109a passive:

```text
C109a = finite origin-polarizer entry ticket.
```

Before using an origin projector in a release theorem, require the stronger
`C1-Origin+` audit:

```text
P0^2 = P0;
P0 is Krein-self-adjoint, or self-adjoint in the finite audit model;
rank(P0) is the intended physical multiplicity;
Odd_J(P0) != 0;
Tr_K0(Gamma P0) != 0;
P0 Gamma P0 is chirality-pure, up to intended gauge/flavor multiplicity;
P0 is gauge-safe at the origin, or comes from a gauge-covariant family P(U);
P0 (partial_q D) P0 has the intended Weyl tangent-residue witness.
```

Logical ladder:

```text
C109a:
  passive origin-polarizer certificate.

C1-Origin+:
  strengthened pre-release origin audit.

Riesz/spectral-island bridge:
  persistence of the selected projector near the origin.

GateC1_NU_Free:
  one physical Weyl branch plus true bad-sector inverse gap.

GateC1_NU_BackgroundGauge / Quantum:
  gauge, Krein, anomaly, determinant-line, and regulator audits.
```

### Sign-involution no-go and escape test

The overlap/sign route must pass the same origin test:

```text
If H_ne,0 is balance-even, then sign(H_ne,0) is balance-even and C1 still fails.
```

So the finite-origin test is:

```text
Odd_J(P0 sign(H_ne(0,1)) P0) != 0;
Tr_K0(Gamma (1 + P0 sign(H_ne(0,1)) P0) / 2) != 0.
```

This prevents a renamed balance-even Wilson kernel from masquerading as a
successful null-edge overlap solution.

## 18. Reference-model-first policy

Do not invent a new Gate C1 release model merely for novelty.

The preferred strategy is:

```text
Start from a working chiral-fermion architecture with known physics.
Identify the exact theorem/audit that makes it work.
Translate that architecture into null-edge language only where the translation
is structurally honest.
Then ask what, if anything, is genuinely new in the null-edge interpretation.
```

This changes the research posture. The baseline should not be "design a brand
new chiral regulator." The baseline should be:

```text
Can overlap/domain-wall/Ginsparg-Wilson-style chiral release be interpreted as
a null-edge branch-selector construction with controlled non-ultralocality?
```

If yes, the project gains a proven physics backbone. If no, the failure should
be recorded as a precise obstruction, not bypassed by inventing a looser model.

### Reference-model ladder

Use the literature families as a ladder, not as a menu of disconnected ideas.

```text
Level 1: Overlap / Ginsparg-Wilson
  Closest proven chiral-regulator architecture.
  Null-edge question:
    Can H_ne be chosen natively so that sign(H_ne) passes the balance-odd origin
    test?

Level 2: Domain-wall / boundary fermions
  Closest proven structured mirror-separation architecture.
  Null-edge question:
    Can branch depth, causal layer, path length, or Schur-elimination depth play
    the role of the wall/bulk direction?

Level 3: Schur-Feshbach effective operators
  Closest mechanism for deriving a light operator from a gapped auxiliary
  sector.
  Null-edge question:
    Can the auxiliary block be forced by null-edge geometry, and does its parity
    satisfy sigma_V sigma_M sigma_W = -1?

Level 4: Causal set retarded operators
  Closest Lorentzian/discrete/non-ultralocal geometric cousin.
  Null-edge question:
    Can retarded causal path sums supply the kernel/control layer without
    pretending to solve chirality by themselves?

Level 5: Furey/Hughes and finite spectral/internal geometry
  Closest algebraic inspiration for preferred internal structures and
  centralizer-driven symmetry breaking.
  Null-edge question:
    Can the missing branch selector be interpreted as a preferred algebraic
    structure whose centralizer preserves gauge-safe symmetries?

Level 6: SLAC/Stacey/tangent and SMG warning lanes
  Closest cautionary examples.
  Null-edge question:
    Which locality, tail, zone-edge, ghost-zero, and anomaly audits must be
    passed before any non-ultralocal claim is trusted?
```

### Translation rules

For any borrowed architecture, require a three-column translation table:

```text
Known model object | Null-edge interpretation | Audit needed
```

Examples:

```text
overlap kernel H_W
  -> null-edge Hermitian/Krein-Hermitian kernel H_ne
  -> balance-odd origin test; spectral gap; gauge covariance; locality/path-sum
     control

sign(H_W)
  -> branch involution T_br = sign(H_ne)
  -> T_br^2 = 1; nonzero chiral trace; no balance-even kernel masquerade

domain-wall fifth direction
  -> branch depth, causal layer, path length, boundary, or Schur elimination
     depth
  -> native-origin justification; residual mirror coupling audit

bulk/domain-wall gap
  -> Schur-Feshbach heavy-sector inverse gap
  -> true inverse-propagator gap, not a propagator zero

causal-set retarded sum
  -> null-edge path-sum kernel
  -> shell-count/amplitude convergence; gauge-background stability

Furey/Hughes complex structure
  -> null-edge C_ne, T_br, or centralizer-defining projector
  -> centralizer audit; gauge-safe preserved symmetry; balance broken
```

### Claim discipline

The highest-value outcome is not "a new model." The highest-value outcome is:

```text
A known working chiral-release mechanism can be reconstructed from null-edge
data, with the null-edge structure explaining the origin of its branch selector,
path-sum control, or symmetry-breaking projector.
```

The second-best outcome is:

```text
A known working mechanism cannot be made null-edge-native, and the obstruction
is formalized.
```

The weak outcome to avoid is:

```text
A formally new operator is introduced, but it lacks the proven overlap/domain-
wall/Ginsparg-Wilson physics audits and only appears to solve C1 because the
hard checks were moved out of view.
```

Therefore every proposed `B(U)`, `T_br`, or `D_NU` should be classified as one
of:

```text
reference-model reinterpretation;
reference-model deformation;
native null-edge construction with reference-model audit;
declared speculative construction.
```

Only the first three should feed Gate C1 theorem work. The last category may be
useful for exploration, but should not be promoted as the main C1 route.

## 19. Null-edge flavored-overlap / matrix-valued Wilson kernel

The next concrete Gate C1 reference-model test is:

```text
Null-edge flavored overlap.
```

The goal is not to invent a new chiral regulator. The goal is to adapt the
known overlap/Ginsparg-Wilson architecture and ask whether the kernel can be
made null-edge-native.

Baseline form:

```text
D_kernel(U) = D_ne(U) + W_branch(U) - m0 R;
H_ne(U) = Gamma_K D_kernel(U);
T_br(U) = sign(H_ne(U));
P_phys(U) = (1 + T_br(U)) / 2;
P_bad(U) = (1 - T_br(U)) / 2.
```

Here `W_branch` is not a scalar Wilson term. It is a matrix-valued
branch/taste/flavor Wilson term, analogous in role to flavored-mass or
staggered-Wilson terms in the lattice literature.

### Why scalar Wilson failure does not kill this route

The existing scalar Wilson no-go should be read narrowly:

```text
A scalar, balance-even correction on the origin kernel cannot polarize
chirality directly.
```

It does not say:

```text
Wilson-style kernels are useless inside an overlap/sign construction.
```

The overlap/Ginsparg-Wilson route uses a kernel to define a sign operator and a
modified lattice chirality. The Wilson-like term is not itself the final
physical chiral release.

Therefore the active question is:

```text
Can a matrix-valued, gauge-safe, balance-odd null-edge Wilson/flavored-mass
kernel produce an H_ne whose sign operator passes the finite-origin polarizer
test?
```

### Matrix-valued Wilson requirements

A candidate `W_branch` should satisfy:

```text
Gauge safety:
  [W_branch, rho(G_gauge)] = 0
  or
  W_branch(U^g) = rho(g) W_branch(U) rho(g)^-1.

Hermitian/Krein safety:
  H_ne = Gamma_K (D_ne + W_branch - m0 R)
  is Hermitian or Krein-Hermitian in the intended finite audit.

Origin balance escape:
  Odd_J(P0 W_branch(0,1) P0) != 0.

Sign-kernel escape:
  Odd_J(P0 sign(H_ne(0,1)) P0) != 0.

Chiral visibility:
  Tr_K0(Gamma (1 + P0 sign(H_ne(0,1)) P0) / 2) != 0.

Continuum safety:
  the selected sector has the intended Weyl tangent symbol.

Mirror safety:
  the unwanted sector has a true inverse-propagator gap, not a propagator zero.

Control:
  sign(H_ne) has finite-volume, path-sum, resolvent, or spectral-gap control.
```

### Known-model analogues

Use these as reference models:

```text
Wilson-overlap:
  scalar Wilson kernel plus sign operator.
  Null-edge lesson:
    scalar Wilson can still be part of a sign-kernel construction, but the
    origin compression must not remain balance-even.

Staggered-Wilson / flavored-mass overlap:
  matrix/taste-valued mass terms split tastes before applying overlap.
  Null-edge lesson:
    treat the origin branch-balance space like a taste/branch space and test
    matrix-valued Wilson terms.

Naive/minimally doubled flavored overlap:
  flavored mass terms split species for alternative overlap kernels.
  Null-edge lesson:
    if the null-edge core naturally gives a small branch pair, minimally
    doubled analogies may be more relevant than full hypercubic doubler towers.

Domain-wall:
  sign operator obtained through a bulk/boundary transfer construction.
  Null-edge lesson:
    branch depth, path length, causal layer, or Schur-elimination depth may play
    the role of the wall direction.

Perfect-action / RG Ginsparg-Wilson:
  non-ultralocal kernels arise from block-spin fixed-point logic.
  Null-edge lesson:
    path-sum/resolvent control can be a principled regulator structure, not an
    arbitrary nonlocal add-on.
```

### Modified chirality audit

A Ginsparg-Wilson release should not be audited only with the naive chirality
operator. It should introduce a modified chirality operator, schematically:

```text
Gamma_hat = Gamma (1 - a R D)
```

or the appropriate null-edge analogue.

Required distinction:

```text
Gamma:
  finite-origin diagnostic chirality used in the current C108/C109 stack.

Gamma_hat:
  overlap/Ginsparg-Wilson modified chirality used by the released operator.
```

Open theorem question:

```text
How does the finite-origin trace test with Gamma relate to the released
Ginsparg-Wilson index or trace with Gamma_hat?
```

Do not silently identify them.

### Immediate theorem targets

Add the following focused targets:

```text
C123_MatrixWilsonOriginCriterion:
  finite matrix-valued Wilson/flavored-mass origin test.

C124_GinspargWilsonAlgebraForArbitraryKernel:
  derive the GW relation and modified chirality algebra from a Hermitian sign
  kernel.

C125_ModifiedChiralityOriginBridge:
  relate Gamma, Gamma_hat, origin trace, and overlap index without conflating
  the diagnostics.

C126_SchurGeneratedMatrixWilson:
  show when a Schur self-energy can serve as a balance-odd matrix Wilson term.

C127_StaggeredWilsonToNullEdgeTranslation:
  produce a reference-model translation table and identify the exact audits
  needed before claiming a null-edge adaptation.
```

### Go/no-go test

This route is promising only if:

```text
P0 sign(Gamma_K (D_ne + W_branch - m0 R))(0,1) P0
```

has nonzero balance-odd origin content and the selected overlap branch has the
right Weyl tangent symbol.

If every gauge-safe, null-edge-natural `W_branch` is balance-even on the origin
kernel, then this reference-model adaptation fails for a precise reason and the
project should record that obstruction before inventing a more exotic release.

## 20. Decision point: null-edge overlap program first

Pro sharpens the reference-model-first policy into a single decision:

```text
Make Gate C1 a null-edge reinterpretation of overlap/Ginsparg-Wilson/domain-wall
fermions, not an attempt to invent a new anti-doubling mechanism.
```

The first deliverable is therefore no longer:

```text
Find a beautiful null-edge-native selector B(U).
```

The first deliverable is:

```text
Can the null-edge operator be put into overlap/Ginsparg-Wilson form?
```

Only after that should the project ask whether the overlap kernel has a
particularly elegant null-edge-native interpretation.

### Null-edge overlap program

Start with a Hermitian or Krein-Hermitian finite-volume kernel:

```text
H_ne(U).
```

Define:

```text
epsilon_ne(U) = sign(H_ne(U));
T_br(U) = epsilon_ne(U).
```

A model overlap operator is:

```text
D_ov,ne = (1 / a) (1 + Gamma sign(H_ne)).
```

The exact formula may need a null-edge/Krein adaptation, but the backbone should
remain overlap/Ginsparg-Wilson:

```text
sign of a structured Hermitian kernel
  -> modified chirality
  -> no naive doubling under the known overlap/GW assumptions.
```

### Borrowed theorem target

The primary theorem should be the null-edge analogue of the Ginsparg-Wilson
relation:

```text
D_ov,ne Gamma + Gamma D_ov,ne =
  a D_ov,ne Gamma D_ov,ne
```

or the correct generalized/Krein version.

Then define:

```text
Gamma_hat = Gamma (1 - a D_ov,ne);
P_hat,+ = (1 + Gamma_hat) / 2;
P_hat,- = (1 - Gamma_hat) / 2.
```

The finite-origin polarizer becomes a diagnostic for the induced sign selector:

```text
T0 = sign(H_ne(0,1)) restricted to K0;
Odd_J(T0) != 0;
Tr_K0(Gamma (1 + T0) / 2) != 0.
```

Passing this diagnostic means only:

```text
the null-edge overlap kernel sees the physical/mirror imbalance at the origin.
```

It does not replace the overlap/GW theorem, locality/path-sum control, spectral
gap, index/anomaly accounting, or bad-sector gap.

### Homotopy-to-Wilson shortcut

The most efficient way to inherit known physics may be a gap-preserving homotopy
to the standard Wilson-overlap kernel:

```text
H_t = (1 - t) H_W + t H_ne,  t in [0,1].
```

If the admissible-background spectral gap does not close along this path, then
`H_ne` lies in the same overlap index/locality class as the reference Wilson
kernel. This would avoid re-proving the entire anti-doubling mechanism from
scratch.

This becomes a major go/no-go test:

```text
Can H_ne be connected to H_W without closing the sign-kernel gap?
```

If yes, Gate C1 becomes a null-edge reinterpretation/deformation of a proven
chiral regulator. If no, the obstruction should be recorded before moving to a
more speculative branch.

### Updated priority order

```text
1. Overlap/Ginsparg-Wilson first:
     define H_ne, sign(H_ne), D_ov,ne, Gamma_hat; prove or refute the null-edge
     GW relation.

2. Domain-wall second:
     interpret the sign operator through a boundary/defect/transfer picture,
     with branch depth, causal layer, path length, or Schur-elimination depth as
     possible null-edge analogues.

3. Furey/Hughes third:
     use centralizer/projector language to audit the preferred algebraic
     structure inside H_ne; do not ask it to replace overlap/GW.

4. Finite-origin tests fourth:
     compute J-oddness and chiral trace of the induced sign selector on K0.

5. SMG later:
     keep as a possible mirror-gapping supplement only after ghost-zero issues
     are neutralized.
```

### New immediate theorem targets

```text
C128_TranslateOverlapToGateC1:
  exact dictionary between standard overlap/GW objects and Gate C1 objects.

C129_BuildNullEdgeKernelHne:
  candidate H_ne kernels with adjointness, gauge covariance, and gap candidates.

C130_HomotopyToWilsonKernel:
  gap-preserving homotopy H_t = (1-t)H_W + tH_ne, or a precise obstruction.

C131_OriginBalanceAuditForSignKernel:
  compute Odd_J(sign(H_ne)|K0) and the origin chiral trace diagnostic.

C132_NullEdgeSignPathsumLocality:
  use sign/resolvent representation to prove controlled path-sum locality.
```

## 22. Integrated Aristotle results through C127

The completed Aristotle jobs now support a sharper theorem ladder.

### Passive origin entry ticket

C109a repaired and completed the passive finite API:

```text
IsOriginPolarizerCertificate D =
  ChiralTrace D.Gamma0 (Selector D) != 0.
```

No physical-release fields belong in C109a.

### Centralizer and false-positive audit

C112-C113 confirm:

```text
balance-even -> zero chiral trace;
nonzero trace -> nonzero J-odd content;
chiral trace sees only J-odd content;
scalar/central selectors fail;
gauge-safe but balance-even selectors still fail;
trace-visible but gauge-unsafe selectors are false positives.
```

Use these as the finite rejection tests for any `B(U)`, `T_br`, or
`W_branch`.

### Branch bridge

C114 supplies the bridge architecture:

```text
origin polarizer
  + spectral island
  + uniform gap
  + smooth/analytic branch data
  + gauge covariance
  -> stable nearby branch projector.
```

Nonzero origin trace alone is not a branch-line theorem.

### Ghost/gap audit

C115 makes the mirror rule formal:

```text
true bad-sector inverse gap and ghost zero are mutually exclusive.
```

Structured projector-plus-mass gapping is the preferred mirror-sector pattern;
propagator-zero mirror removal remains rejected.

### Schur-generated matrix Wilson term

C118 proves:

```text
Sigma = V M^{-1} W;
J_L Sigma J_L = (sigma_V sigma_M sigma_W) Sigma.
```

Thus a Schur channel can generate a balance-odd `W_branch` exactly when:

```text
sigma_V sigma_M sigma_W = -1.
```

If all ingredients are balance-even, the Schur self-energy is balance-even and
fails the origin test.

### C1-Origin+

C119 inserts the strengthened finite pre-release audit:

```text
C109a passive certificate
  -> C1-Origin+
  -> Riesz/spectral-island bridge
  -> GateC1_NU_Free.
```

`C1-Origin+` adds idempotency, self/Krein-adjointness, intended rank, nonzero
J-odd content, nonzero chiral trace, chirality purity, gauge-safety placeholder,
and tangent-residue placeholder. It still does not imply release.

### Sign-kernel no-go

C120 proves the overlap-specific warning:

```text
H0 balance-even -> sign(H0) balance-even -> zero origin chiral trace.
```

Therefore the null-edge overlap route must pass:

```text
Odd_J(P0 sign(H_ne(0,1)) P0) != 0.
```

### Reference-model recommendation

C127 recommends:

```text
Primary model for W_branch:
  Adams staggered-Wilson / flavored mass.

Best finite/Lean generator:
  Schur-generated self-energy with the C118 parity rule.

Anomaly/Krein cross-check:
  domain-wall transfer.

Fallback:
  naive flavored-mass overlap.
```

This updates the working Gate C1 target:

```text
null-edge flavored overlap first,
with W_branch modeled on staggered-Wilson/flavored mass and audited by Schur
parity, sign-kernel origin oddness, C1-Origin+, ghost/gap separation, and
Riesz/spectral-island persistence.
```

## 23. Integrated Aristotle results C116, C117, C125

Three additional completed jobs sharpen what the next breakthrough must do.

### C116: path-sum control is summability-first

C116 proves a finite path-sum/Neumann-series control package:

```text
walkSum M i j n = (M^n) i j;
path sums are controlled by summable per-shell bounds;
exponential decay is one sufficient case, not the primitive definition;
finite-volume convergence and infinite/limit claims must be kept separate;
projector/selector attachment preserves control but does not create a gap.
```

Update:

```text
GateC1_NU should use summable shell/path control as the primitive non-ultralocal
certificate.
```

### C117: the finite origin escape hatch is exactly J-odd content

C117 proves the finite minimal-escape package:

```text
scalar/central corrections fail;
balance-even selectors fail;
chiral trace sees only oddPart_J;
nonzero chiral trace requires nonzero J-odd part;
2 x 2 Pauli witnesses show the finite obstruction is not empty.
```

The load-bearing compatibility is:

```text
Gamma J + J Gamma = 0.
```

Update:

```text
No finite scalar, central, or balance-even workaround should be pursued.
Every candidate W_branch, H_ne, sign(H_ne), or projector must exhibit J-odd
content at the relevant origin compression.
```

### C125: origin Gamma trace does not automatically transfer to Gamma_hat

C125 proves the exact modified-chirality trace decomposition:

```text
Tr(Gamma_hat P) =
  Tr(Gamma P) - a Tr(Gamma R D P).
```

It also gives counterexamples where:

```text
Tr(Gamma P0) != 0
but
Tr(Gamma_hat P0) = 0.
```

Update:

```text
Origin Gamma-trace is only an entry ticket. A null-edge overlap release must
separately control the GW defect term a Tr(Gamma R D P), or prove compatibility
between P0 and the released overlap projector.
```

Required bridge hypotheses now include:

```text
spectral gap for sign(H_ne);
stable branch projector;
P0-overlap-projector compatibility;
no singular crossing;
correct Weyl tangent symbol;
GW relation and admissible R data.
```

### New breakthrough target

The decisive finite seed is now:

```text
H_ne = Gamma_K (D_ne + W_branch - m0 R)
```

such that:

```text
Odd_J(P0 W_branch P0) != 0;
Odd_J(P0 sign(H_ne) P0) != 0;
Tr(Gamma (1 + P0 sign(H_ne) P0) / 2) != 0;
the GW-defect term does not cancel the released Gamma_hat trace;
the bad-sector gap is a true inverse-propagator gap;
path-sum/sign control satisfies a summable-shell certificate.
```

## 21. Baez-style qubit/qutrit finite-origin design principle

Baez's qubit/qutrit framing should inform the finite origin algebra, not replace
the overlap/Ginsparg-Wilson backbone.

Use it as a disciplined way to model `K0`, the balance involution `J`, and
matrix-valued Wilson/flavored-mass terms:

```text
K0 approximately =
  branch-balance qubit
  tensor chirality/spin qubit
  tensor internal qutrit/qubit data.
```

This is not yet a theorem or a claimed physical factorization. It is a design
and audit language for finite origin candidates.

### Branch balance as a qubit

The physical/mirror balance symmetry behaves like a two-state system. In this
language:

```text
balance-even selector:
  identity-like on the branch qubit;
  rejected by the C108 zero-trace theorem.

balance-odd selector:
  Pauli-like on the branch qubit;
  possible finite-origin polarizer.
```

This gives a clean interpretation of the current finite no-go:

```text
If a candidate acts trivially on the branch-balance qubit, it cannot release
chirality.
```

### Internal structure as qutrit/qubit data

The internal gauge sector should be treated as the part of the finite system
that the C1 selector must preserve or transform covariantly.

Design rule:

```text
W_branch should act nontrivially on the branch-balance qubit while acting as a
gauge-safe identity/projector/intertwiner on the internal qutrit/qubit sector.
```

Toy search form:

```text
W_branch =
  Pauli_branch
  tensor SpinChiralityFactor
  tensor InternalGaugeSafeFactor.
```

This helps avoid two bad outcomes:

```text
1. W_branch is internal-only and therefore balance-even on K0.
2. W_branch breaks the desired gauge/internal symmetry while trying to polarize
   the branch qubit.
```

### Centralizer audit

For any finite-origin factorization ansatz, compute:

```text
centralizer(W_branch);
centralizer(T_br);
centralizer(P_phys).
```

Acceptable outcome:

```text
the branch-balance symmetry is broken;
the desired gauge-safe internal centralizer is preserved.
```

This is the precise place where Baez/Furey/Hughes-style finite algebra and the
overlap/GW program meet:

```text
finite qubit/qutrit algebra:
  organizes the origin selector and centralizer audit.

overlap/Ginsparg-Wilson:
  supplies the anti-doubling/sign-kernel backbone.
```

### Finite theorem target

The first theorem target in this language is:

```text
If K0 decomposes as Branch tensor Internal, and J acts by a branch swap, then
every selector of the form I_branch tensor A_internal is balance-even and has
zero chiral trace under the C108 hypotheses.

A selector with a Pauli-like branch factor can have nonzero balance-odd chiral
trace, provided its internal factor is gauge-safe.
```

This theorem would make the matrix-valued Wilson search more disciplined:

```text
Do not search over arbitrary matrices.
Search over finite information-theoretic tensor factors and centralizers.
```

### Claim boundary

The qubit/qutrit framing does not solve:

```text
fermion doubling;
the GW relation;
sign-kernel locality;
bad-sector gapping;
anomaly accounting;
Krein positivity;
gauge determinant construction.
```

It only sharpens the finite origin selector language and the design of
matrix-valued Wilson/flavored-mass terms.

## 24. Integrated Aristotle update: overlap core solved, seed-to-sign is the bottleneck

Date: 2026-06-27
Source: Completed Aristotle jobs C121, C122, C123, C124, C126, C128, C129, C131, C133, C134, C135, C136, and C137. See `AgentTasks/null-edge-aristotle-gate-c1-completed-integration-3-2026-06-27.md`.

The latest completed jobs materially improve the Gate C1 picture.

The overlap/Ginsparg-Wilson algebra should now be treated as a solved interface problem in finite algebra: once we have a gapped sign involution `epsilon = sign(H_ne)`, the GW relation, modified chirality, complementary projectors, and branch-selection algebra follow. This means the main scientific risk is no longer "can we invent a chiral lattice algebra?" The risk is whether the null-edge kernel can supply the right sign involution while preserving gauge safety, a bad-sector gap, and a nonzero released chirality trace.

The current decisive chain is:

1. Build a finite origin seed `W_branch` that is gauge-safe and balance-odd.
2. Preferably derive it by Schur/Feshbach elimination with parity product `-1`, rather than inserting it by hand.
3. Form `H_ne = Gamma_K (D_ne + W_branch - m0 R)`.
4. Prove Hermitian or controlled Krein-Hermitian sign-kernel health plus a spectral gap.
5. Prove `Odd_J(sign(H_ne)) != 0`; this is the seed-to-sign transfer problem.
6. Apply the overlap/GW algebra.
7. Protect `Tr(Gamma_hat P_phys)` from the C125 defect using either strict domination or a structural zero condition.
8. Prove the mirror/bad sector has a true inverse-propagator gap, not a propagator zero.
9. Import anomaly/index/locality control from a standard overlap/domain-wall model whenever possible.

The strongest finite seed is now the C136 flavored-overlap witness. It shows that the whole algebraic chain can work in dimension 4: nonzero odd Wilson seed, nonzero odd sign kernel, nonzero physical chiral trace, exact GW relation, nonzero `Gamma_hat` trace, and a true bad-sector gap. This is not yet Gate C1, because it does not prove locality, anomaly cancellation, continuum branch behavior, or a Standard Model gauge representation. But it is the first compact finite proof-of-concept that the path is internally coherent.

The cleanest gauge-safe origin mechanism is the C134/C133 branch-Pauli construction: put the chirality-selecting odd factor in the branch qubit and keep gauge action in an internal centralizer, ideally the internal identity on the qutrit factor. Internal-only terms are safe but balance-even and fail; noncentral internal terms may be odd-looking but break gauge safety.

The main open theorem is now:

`Gauge-safe odd seed + gapped Hermitian/Krein kernel + sign-transfer + Gamma_hat defect protection + bad-sector inverse gap -> Gate C1 finite release certificate.`

Near-term work should be organized around proving or refuting this theorem in the smallest finite model first, then lifting it to a reference overlap/domain-wall homotopy. If the gauge-safe odd channel cannot be realized in the actual Standard Model internal representation, we should switch to import mode: treat Gate C1 as the standard overlap/domain-wall regulator with a null-edge interpretation of the kernel, rather than trying to force a new native regulator.
## 25. Integrated Aristotle update: finite native mechanism now has a viable core

Date: 2026-06-27
Source: Completed Aristotle jobs C130, C139, C140, and C141. See `AgentTasks/null-edge-aristotle-gate-c1-completed-integration-4-2026-06-27.md`.

This batch materially improves the Gate C1 outlook.

The finite native route now has a plausible algebraic core:

```text
internal-only gauge action
  -> gauge-safe branch-Pauli odd seed
  -> gapped Hermitian sign kernel
  -> nonzero odd sign transfer
  -> exact overlap/GW algebra
  -> protected Gamma_hat trace
  -> heavy-block bad-sector gap
```

The biggest new result is the combination of C140 and C141. C140 says a gauge-safe balance-odd branch seed exists exactly in the regime we hoped for: gauge acts internally and does not gauge the branch involution `J`. If `J` is included in the gauge representation, native odd selection collapses, because every gauge-safe term becomes balance-even. C141 then shows that the C136 finite seed can be lifted to branch x flavor x qutrit with internal identity, preserving gauge safety, sign oddness, GW algebra, nonzero physical trace, nonzero `Gamma_hat` trace, and a bad-sector gap.

C139 closes the finite no-ghost audit: in the Schur-Feshbach block form, the bad-sector compression is the heavy block `M`, so the bad sector has a true inverse-propagator gap exactly when `M` is invertible. Balance-odd Schur parity can coexist with that gap; oddness alone does not imply the gap.

C130 gives the import/homotopy route: sign-kernel trace/index data are constant along a Hermitian uniformly gapped homotopy. This is the right interface for importing standard overlap/domain-wall physics. Its one analytic handoff is the continuity estimate for the sign matrix under a uniform gap, which remains theorem-design rather than fully trusted Lean.

Updated interpretation: Gate C1 is no longer blocked at the level of finite algebraic existence. The finite seed exists, the gauge-safe odd channel exists under a clear assumption, and the bad-sector gap audit has a clean finite theorem. The remaining work is to lift this from a finite algebraic witness to a physically honest regulator: prove or import uniform gap/homotopy, locality/path-sum control, anomaly/index behavior, and Standard Model representation compatibility.

Trust note: the C141 lifted finite witness uses draft-trust computational reduction (`Lean.ofReduceBool` / `Lean.trustCompiler`) in its Aristotle artifact. Treat it as a successful finite computational witness, not as trusted repo Lean, until the finite checks are replaced by kernel-only proofs.
## 26. Literature spine update: null-edge overlap should track proven overlap/flavored-mass/domain-wall models

Date: 2026-06-27
Source: `AgentTasks/null-edge-gate-c1-literature-spine-2026-06-27.md`; Zotero collection `9WIG8WGR`; Neo4j collection `Null Edge Gate C1 overlap references`.

The literature search reinforces the reference-model-first policy. The Gate C1 operator should be developed as a null-edge overlap/Ginsparg-Wilson operator with a flavored/species-splitting branch Wilson term:

```text
H_ne = Gamma_K (D_ne + W_branch - m0 R)
T_br = sign(H_ne)
D_ov,ne = rho (1 + Gamma_K T_br)
```

The core references are Neuberger/Luscher/Ginsparg-Wilson for the overlap/GW algebra; Hernandez-Jansen-Luscher for locality/admissibility; Hasenfratz-Laliena-Niedermayer and Kikukawa-Yamada for index/anomaly import; Adams/Hoelbling/Misumi for flavored-mass and staggered-overlap analogues; Kaplan/Kikukawa for domain-wall import mode; and Golterman-Shamir/Poppitz-Shang for mirror/propagator-zero warnings.

The most important modeling consequence is that `W_branch` should not be treated as an arbitrary new correction. It should be developed as a null-edge analogue of an Adams-style flavored mass or species-splitting Wilson term. This matches the finite branch-Pauli/qutrit seed better than a scalar Wilson term and gives us known lattice constructions to compare against.

The locality target should be expressed in two compatible languages:

1. Standard overlap admissibility/locality, following Hernandez-Jansen-Luscher.
2. Null-edge combinatorial path-sum control, following the C122/C143 line.

The anomaly/index target should be imported through a gapped homotopy to a standard overlap/domain-wall model whenever possible, rather than reproved from scratch.

The ghost rule is now literature-backed: do not remove gauge-charged mirrors by propagator zeros. A successful Gate C1 release needs a true inverse-propagator gap or a standard overlap/domain-wall decoupling mechanism.
## 27. Integrated Aristotle update: homotopy, path-sum, anomaly, and ghost-rule interfaces

Date: 2026-06-27
Source: Completed Aristotle jobs C142, C143, C146, C147, and C153. See `AgentTasks/null-edge-aristotle-gate-c1-completed-integration-5-2026-06-27.md`.

This batch makes the reference-model-first Gate C1 route substantially sharper.

The most important technical update is C146: sign-continuity under a uniform spectral gap is now a machine-checked theorem via continuous functional calculus. This closes the analytic handoff from the earlier homotopy work. If we can build a uniformly gapped Hermitian homotopy from a reference overlap/domain-wall kernel to the null-edge kernel, the sign kernel varies continuously along that path.

C142 packages the import theorem: a gauge-covariant, gap-preserving homotopy from a reference sign kernel to the null-edge sign kernel transfers the GW branch-selection algebra, index/anomaly class, projector rank/chirality data, and locality assumptions. This is now the cleanest formal interface for using known overlap/domain-wall physics rather than inventing a new regulator.

C143 gives the non-ultralocal path-sum certificate we wanted. A finite odd path contribution survives the infinite path sum if shell-count/amplitude bounds make the tail summable and the finite odd piece strictly dominates the tail. This is the null-edge combinatorial/path-integral replacement for demanding ultralocality.

C147 gives the anomaly/index import contract and a Standard Model anomaly audit interface. Anomaly behavior should now be tracked as a certificate stack: finite index data, gapped homotopy, gauge covariance, locality/admissibility, continuum compatibility, and determinant-line/anomaly matching.

C153 turns the ghost warning into an explicit Gate C1 rule: never remove a gauge-charged branch by a propagator zero. Acceptable mirror/bad-sector removal requires an inverse-propagator gap, a Schur-Feshbach heavy-block gap, or a standard overlap/domain-wall projection mechanism.

The current proof strategy should therefore be stated as:

```text
finite gauge-safe odd seed
  -> gapped sign kernel
  -> sign-continuity under uniform gap
  -> gap-preserving homotopy to reference overlap/domain-wall
  -> inherited GW/projector/index/anomaly/locality data
```

For native non-ultralocal control, the parallel path is:

```text
finite odd path contribution
  + shell-count/amplitude summability
  + strict domination over the tail
  -> nonzero limiting Odd_J
```

Remaining open work is now concentrated in the still-running jobs: general sign-transfer, Standard Model gauge-internality, trusted proof promotion of the finite seed, finite-to-branch-line lifting, concrete reference homotopy, Adams/flavored-mass translation, locality comparison to HJL, and domain-wall import details.
## 28. Integrated Aristotle update: kernel-only finite seed and flavored-overlap interpretation

Date: 2026-06-27
Source: Completed Aristotle jobs C144, C145, C149, C150, C151, and C152. See `AgentTasks/null-edge-aristotle-gate-c1-completed-integration-6-2026-06-27.md`.

This batch strengthens the finite native route and connects it more firmly to known overlap/flavored-mass/domain-wall physics.

C145 removes the main trust caveat from the finite seed: the branch x flavor x qutrit witness has now been rebuilt using exact symbolic matrix identities, with no evaluator-trusted reduction dependency reported. The finite seed proves the needed involution, Hermiticity, gap, nonzero odd seed, nonzero odd sign kernel, GW relation, physical trace, `Gammahat` trace, and internal-gauge safety facts.

C144 gives the clean gauge-internality pivot: if the Standard Model gauge action is internal relative to the branch factor and does not gauge the branch involution `J`, native Gate C1 has a gauge-safe odd seed. If `J` is gauged, native odd selection is impossible and we should switch to import mode.

C150 says `W_branch` should be documented as a null-edge flavored/species-splitting Wilson term, closest in role to Adams-style flavored mass / staggered-overlap constructions. This is a better interpretation than treating `W_branch` as an ad hoc correction.

C149 gives a concrete reference-connection criterion: compare the finite seed to a flavor-matched reference overlap/flavored-overlap kernel by sector signatures, then use a straight-line gapped homotopy if the norm difference is smaller than the reference gap. This makes the next reference-matching step finite and computable.

C151 links Hernandez-Jansen-Luscher locality to null-edge path-shell summability. Exponential locality and ultralocality are sufficient special cases; the natural null-edge condition is controlled shell-count/amplitude summability.

C152 gives a domain-wall/topological-boundary fallback: if native overlap stalls, import mode can be phrased as equality or homotopy of the boundary sign class `T_br`, after which the finite overlap/GW algebra transfers.

Updated working interpretation:

```text
W_branch = null-edge flavored/species-splitting Wilson term
H_ne = Gamma_K (D_ne + W_branch - m0 R)
T_br = sign(H_ne)
D_ov,ne = rho (1 + Gamma_K T_br)
```

The project should now focus on choosing a concrete flavor-matched reference kernel, comparing sector signatures, and proving a gapped homotopy/locality/anomaly import path.
## 29. Integrated Aristotle update: sign-transfer requires anticommutation or sign-straddling

Date: 2026-06-27
Source: Completed Aristotle job C138. See `AgentTasks/null-edge-aristotle-gate-c1-completed-integration-7-2026-06-27.md`.

C138 closes the general sign-transfer blocker in a precise form.

The correct theorem is not that any nonzero `J`-odd seed survives the sign functional calculus. That is false. The correct sufficient condition is that the full Hermitian gapped kernel anticommutes with the balance involution `J`, or equivalently has a sign-straddling structure strong enough to force the sign operator itself to be `J`-odd.

The updated sign-transfer condition is:

```text
H_ne Hermitian/invertible/gapped
J H_ne J = -H_ne
  -> Odd_J(sign(H_ne)) = sign(H_ne) != 0
```

The corresponding no-go is:

```text
H_ne J-even
  -> Odd_J(sign(H_ne)) = 0
```

And the key warning is:

```text
Odd_J(W_branch) != 0
```

is not enough by itself. If a dominant positive `J`-even background pushes the whole spectrum positive, `sign(H_ne)` can collapse to the identity and lose all odd charge.

This narrows the Gate C1 obligation. The actual null-edge kernel must be shown to be in the anticommuting/sign-straddling regime, not merely to contain a nonzero odd seed. The finite branch-Pauli seed passes because it realizes the anticommuting/sign-straddling structure exactly.
## 30. Reference-kernel import doctrine after Pro sharpening

Date: 2026-06-27
Source: Pro analysis on treating the finite seed as the input to a reference-kernel import theorem.

The central strategic correction is:

```text
The finite branch x flavor x qutrit seed is not the Gate C1 release.
It is the finite input to a reference-kernel import theorem.
```

The closing chain should now be organized as:

```text
finite seed
  -> sector-signature match to a trusted overlap/flavored-overlap/domain-wall reference
  -> mass-window / sign-straddling certificate
  -> uniformly gapped Hermitian or Hilbertized-Krein homotopy
  -> imported GW/index/anomaly/locality-or-control package
  -> GateC1_NU, with optional promotion to local/quasi-local Gate C1
```

The working kernel remains:

```text
H_ne    = Gamma_K (D_ne + W_branch - m0 R)
T_br    = sign(H_ne)
D_ov,ne = rho (1 + Gamma_K T_br)
```

But the new load-bearing claim is not merely that `W_branch` is non-scalar or has nonzero `J`-odd part. C138 showed that this is too weak. A dominant positive `J`-even background can make `sign(H_ne)` collapse to the identity and erase the odd branch information.

The correct operational condition is a mass-window/sign-straddling certificate:

```text
one physical sector has shifted mass <= -delta;
all unwanted sectors have shifted mass >= delta;
kinetic and even perturbations are smaller than the margin;
the sign-kernel gap stays open over the admissible region.
```

Equivalently, the actual kernel must be in an anticommuting or sign-straddling regime strong enough that the sign functional calculus preserves the branch distinction.

### Reference import theorem target

The next central theorem should be named something like:

```text
NullEdgeReferenceOverlapImport
```

It should assume:

```text
1. H_ne is Hermitian or has a controlled Hilbertized-Krein Hermitian form.
2. SM gauge acts internally relative to the branch involution J, or an exact gauge-dressing is supplied.
3. W_branch - m0 R gives the required sector mass signs with a strict margin.
4. H_ne is uniformly sign-gapped on admissible momenta/backgrounds.
5. H_ne is connected to a reference overlap/flavored-overlap/domain-wall kernel by a gauge-covariant gapped homotopy.
6. The sector-signature vector matches the reference: rank, gauge representation, chirality sign, J parity, shifted mass sign, Krein sign, and index/anomaly weight.
7. The origin finite seed lifts to a stable branch-line spectral island near the physical locus.
8. The overlap bad sector has a true inverse-propagator gap.
9. Anomaly/index, ghost, Krein, and control/locality certificates are supplied or imported.
```

Then:

```text
D_ov,ne = rho (1 + Gamma_K sign(H_ne))
```

can close `GateC1_NU`. It can close local/quasi-local Gate C1 only if the control certificate is upgraded to finite-range, exponential, or otherwise accepted quasi-local control.

### What this changes

The project should no longer spend effort proving isolated finite oddness facts unless they feed one of these import certificates. The highest-value facts are now:

```text
MassWindow(H_ne, W_branch, R, m0)
SectorSignatureMatch(H_ne, H_ref)
GappedHomotopy(H_ref, H_ne)
BranchLineLift(H_ne)
SMGaugeInternality(J, Gamma_K, W_branch, R)
OverlapBadSectorInverseGap(D_ov,ne)
OverlapLinearizesToWeylSymbol(D_ov,ne)
NonultralocalControlCertificate(D_ov,ne)
AnomalyIndexImport(H_ref -> H_ne)
```

### Updated claim boundary

Do not claim:

```text
nonzero Odd_J(W_branch) implies C1;
finite seed implies physical release;
overlap/GW algebra implies anomaly accounting;
formal sign projector implies locality/control;
Krein self-adjointness alone gives a healthy sign functional calculus;
mirror removal by propagator zero is acceptable;
reference-model resemblance is enough without sector signatures and a gapped homotopy.
```

Do claim, if the theorem package is proved:

```text
GateC1_NU closes when H_ne is sign-straddling, gauge-internal, branch-line stable,
gapped-homotopic to a matched reference kernel, and equipped with the required
bad-gap, anomaly/index, ghost, Krein, and non-ultralocal control certificates.
```

### New Aristotle jobs opened from this sharpening

The active queue already covers branch-line lift, sector-signature audit, flavored-mass dictionary, path-shell locality, SM `J`-not-gauged audit, and finite-seed promotion.

The new gaps are:

```text
C159: NullEdgeReferenceOverlapImport theorem/API package.
C160: Mass-window and sign-straddling theorem package.
C161: Overlap linearization and bad-sector inverse-gap theorem package.
```

## 31. Integrated Aristotle update: C148 finite seed to branch-line bridge

Date: 2026-06-27
Source: Completed Aristotle job C148. See `AgentTasks/null-edge-aristotle-gate-c1-completed-integration-8-2026-06-27.md`.

C148 is now complete and integrated into the documentation/status layer.

The important result is that the finite seed can be connected to branch-line
language through a precise certificate:

```text
finite sign kernel S = sign(H_ne)
  -> branch projector P = (1 - S) / 2
  -> true inverse-propagator gap
  -> sub-gap perturbation stability
  -> stable near-origin branch-projector certificate
```

This replaces a vague origin-trace bridge with a sharper requirement. A
successful finite seed must provide a nonzero `J`-graded sign-kernel selection
invariant and a true inverse-propagator gap. Ordinary trace data is not enough,
and nonzero origin trace without a gap can fail to define a stable branch
projector.

The integration consequence is:

```text
Reference-kernel import should require a C148-style branch-line lift
certificate, not merely finite oddness or ordinary chiral trace.
```

Claim boundary:

```text
C148 does not by itself prove the physical Weyl symbol, SM gauge internality,
anomaly/index import, non-ultralocal control, or locality. It supplies the
finite-to-branch projector stability component required by the GateC1_NU import
package.
```

## 32. Integrated Aristotle update: C157 gauge-internality audit and C158 finite-seed module

Date: 2026-06-27
Source: Completed Aristotle jobs C157 and C158. See `AgentTasks/null-edge-aristotle-gate-c1-completed-integration-9-2026-06-27.md`.

Two support pieces are now integrated.

C157 reduces the Furey/Hughes/SM gauge-safety issue to an explicit assumption:

```text
SMActsInternally:
  every SM gauge generator acts as id_B tensor g_i
  relative to the null-edge branch factor B.
```

Under this assumption, `J = J_b tensor id` commutes with all gauge generators,
so the C144 `J_not_gauged` condition applies. If the branch factor is mixed by a
gauge generator, native mode fails. The main physical danger is identifying the
null-edge branch grading with the chirality factor touched by `SU(2)_L` or
hypercharge.

Required recorded assumptions before claiming native gauge safety:

```text
A1: the branch factor carrying J is disjoint from every factor acted on by SM gauge generators;
A2: the null-edge branch grading is not weak-isospin/hypercharge chirality;
A3: the Furey/Hughes associative internal action and octonion conventions are fixed;
A4: flavor/generation operators do not leak into the branch factor.
```

C158 supplied a draft Lean module now copied into the repo:

```text
PhysicsSM/Draft/NullEdgeGateC1FiniteSeed.lean
```

It proves the finite overlap/Ginsparg-Wilson algebra:

```text
Gamma_K^2 = 1
T_br^2 = 1
D_ov,ne = 1 + Gamma_K T_br
  -> Gamma_K D + D Gamma_K = D Gamma_K D
```

This strengthens the finite seed status: once the sign kernel is supplied as an
involution, the exact GW algebra is a pure finite algebra theorem.

Claim boundary:

```text
C158 does not prove T_br = sign(H_ne) analytically, mass-window/sign-straddling,
branch-line lift, anomaly/index import, bad-sector physical inverse gap, or
non-ultralocal control. C157 does not prove the physical SM embedding satisfies
SMActsInternally; it states the exact assumption and no-go.
```

## 33. Integrated Aristotle update: C155 point-split W_branch and C159 import interface

Date: 2026-06-27
Source: Completed Aristotle jobs C155 and C159. See `AgentTasks/null-edge-aristotle-gate-c1-completed-integration-10-2026-06-27.md`.

C159 gives the current central theorem interface:

```text
NullEdgeReferenceOverlapImport:
  finite seed input
  + sector-signature match
  + uniform gapped homotopy
  + mass-window/sign-straddling
  + reference GW/one-Weyl/bad-gap data
  + anomaly, ghost, and control certificates
  -> GateC1_NU.
```

The important structural rule is now machine-checkable in the returned
skeleton: the finite seed is not the release, `GateC1_NU` is weaker than
`GateC1_local`, and anomaly/control certificates are load-bearing rather than
automatic consequences of a homotopy.

C155 gives the strongest concrete `W_branch` guidance so far. The preferred
construction should be point-split/flavored/species-mass-like:

```text
W_branch(corner) = product_mu pauliSign(c_mu)
```

with:

```text
Brillouin-zone corner -> null-edge branch;
corner parity -> branch grading;
product_mu cos(a p_mu) -> diagonal flavored mass W_branch;
taste projector -> branch/flavor projector.
```

This is exactly the full branch-hypercube version of the C145 branch-Pauli
seed. It automatically has the C138 sign-straddling property for at least one
branch direction, while a constant mass cannot sign-straddle.

Updated modeling instruction:

```text
Do not treat W_branch as an arbitrary matrix-valued insertion.
Model W_branch as a null-edge point-split flavored/species mass whenever
possible, then match its sector signature to naive/flavored-overlap references.
```

Updated next theorem targets:

```text
1. Define the actual null-edge point-split W_branch.
2. Prove its mass-window/sign-straddling condition for H_ne.
3. Compute the resulting sector-signature vector.
4. Match that vector to a naive/flavored-overlap or domain-wall reference.
5. Use the C159 import interface to assemble GateC1_NU.
```
## 34. Integrated Aristotle update: C154, C156, C160-C166 and literature pass

Date: 2026-06-27
Source: Completed Aristotle jobs C154, C156, C160, C161, C162, C163, C164, C165, C166. See `AgentTasks/null-edge-aristotle-gate-c1-completed-integration-11-2026-06-27.md`.

This batch changes the center of gravity again.

The point-split route is viable, but the pure product point-split mass is not a
one-sector release. In four branch directions:

```text
pointSplitMassSign(corner) = (-1)^(level(corner))
```

so it produces an eight-sector parity multiplet, not one physical Weyl sector.
A one-sector release requires a level-resolving Adams/Wilson-style term. In the
C163 model the standard level windows give:

```text
m0 in (0,2): 1 light sector
m0 in (2,4): 5 light sectors
m0 in (4,6): 11 light sectors
m0 in (6,8): 15 light sectors
m0 > 8: 16 light sectors
```

Updated preferred `W_branch` form:

```text
point-split parity/flavored mass
  + level-resolving Adams/Wilson-style branch term.
```

C160 and C161 now supply the finite theorem packages needed after this choice:

```text
C160: mass-window/sign-straddling stability and even-dominant no-go.
C161: bad sector has inverse-propagator gap when T aligns with Gamma;
      physical sector is light when T anti-aligns with Gamma;
      Weyl linearization requires a separate certificate.
```

C164 gives the reference bridge:

```text
H_t = H_ref + t (H_ne - H_ref)
```

with sufficient condition:

```text
H_ref gap gamma and ||H_ne - H_ref|| < gamma
  -> H_t uniformly gapped with residual gap gamma - ||H_ne - H_ref||.
```

C156 gives the non-ultralocal control certificate:

```text
finite propagation + row l1 bound + summable coefficients
  -> uniform far-field/path-shell control.
```

C165 makes native gauge safety a generator-level checklist:

```text
SMActsInternally = every SM generator has form id_B tensor g_i.
```

C166 recommends the near-term strategy:

```text
abstract block-reference import first;
domain-wall import second;
native overlap last.
```

Updated immediate target:

```text
Build a typed C159 assembly theorem with abstract certificates, instantiate it
with a level-resolving point-split/Adams W_branch model, and then discharge the
certificates one by one.
```

## 35. Pro CKM sharpening: use a known one-sector flavored-overlap mass first

Date: 2026-06-27
Source: Pro analysis recommending a Creutz-Kimura-Misumi style one-flavor
naive flavored-overlap reference as the first concrete Gate C1 target.

The latest Pro guidance sharpens the level-resolving point-split direction into
a specific reference-matching target:

```text
Do not try to make the pure finite seed itself be the release.
Choose a known one-sector flavored-overlap kernel first, then prove the
null-edge kernel is in its uniformly gapped homotopy class.
```

The important correction is that the pure product/parity point-split mass is now
best treated as a diagnostic or no-go example in four branch directions:

```text
M_P(corner) = (-1)^level
```

This separates the 16 corners into an eight-plus-eight parity split. It is a
useful balance-odd seed, but it does not isolate one physical sector.

The preferred one-sector candidate is the Creutz-Kimura-Misumi style
point-split/flavored mass:

```text
M_CKM = M_P + M_V + M_T + M_A
```

with desired corner table:

```text
M_CKM(level 0) = 15
M_CKM(level > 0) = -1
```

The resulting shifted null-edge branch Wilson term should be studied first:

```text
W_branch^(1) = r (15 R - M_CKM).
```

In the simplest diagnostic case `R = I`, this gives:

```text
physical corner: W_branch^(1) = 0
all nonzero corners: W_branch^(1) = 16r
one-sector window: 0 < m0 < 16r
```

This is exactly the kind of one-sector mass-window/sign-straddling certificate
needed by the C159 import interface. The optional stabilizer

```text
W_branch^(1,epsilon)
  = r (15 R - M_CKM) + epsilon r sum_mu (1 - C_mu)
```

should be treated as a diagnostic robustness term, not as the primitive
construction, unless it is needed to separate accidental degeneracies.

### Updated reference priority

The reference hierarchy is now:

```text
1. CKM-style one-flavor naive flavored-overlap kernel.
2. Wilson-overlap kernel as a sanity/reference comparison.
3. Adams staggered-overlap only if the null-edge branch factor is proven to be
   taste-like rather than naive-corner-like.
4. Domain-wall/boundary import as fallback and as a bad-gap/anomaly cross-check.
```

The corresponding Hermitian kernels should be compared by a sub-gap homotopy:

```text
H_t = H_ref + t (H_ne - H_ref)
```

with sufficient criterion:

```text
||H_ne - H_ref|| < gamma_ref
```

where `gamma_ref` is the reference spectral gap over the admissible region. The
error budget should be decomposed rather than hidden:

```text
H_ne - H_ref =
  (Gamma_K - Gamma_ref) A_ref
  + Gamma_K (A_ne - A_ref)
```

with separate bounds for:

```text
E_D, E_W, E_R, E_Gamma, E_gauge.
```

### Updated theorem obligations

The highest-priority theorem targets are now:

```text
PureProductParity_NoGo_4D:
  pure product/parity mass selects eight sectors, not one.

CKM_MassTable_OneSector_4D:
  M_CKM has table 15 at level zero and -1 at every nonzero corner.

ShiftedCKM_OneSector_Window:
  W_branch^(1) gives exactly one light sector for 0 < m0 < 16r in the
  R = I diagnostic case, with a general R-version recorded as assumptions.

GappedHomotopy_To_CKM_Reference:
  sub-gap norm control gives a uniformly gapped homotopy from CKM reference to
  the null-edge kernel.

IndexImport_OverlapHomotopy:
  index, anomaly, and GW/projector data are imported along that gapped homotopy
  only when the ghost, Krein, SM-gauge, and control certificates are present.
```

### Updated strategic claim

The near-term claim should become:

```text
Gate C1 is plausibly reducible to proving that the null-edge branch Wilson term
is a CKM-like one-sector flavored mass, with a gapped homotopy to the known
one-flavor flavored-overlap reference.
```

Do not claim Gate C1 is closed until the CKM table, shifted one-sector window,
sector-signature match, gapped homotopy, branch-line lift, SM internality,
bad-sector inverse gap, anomaly/index import, and non-ultralocal control
certificates are all supplied.

## 36. Integrated Aristotle update: C171R and C172 import certificates

Date: 2026-06-27
Source: Completed Aristotle jobs C171R and C172. See
`AgentTasks/null-edge-aristotle-gate-c1-completed-integration-13-2026-06-27.md`.

These two jobs tighten the C159 reference-import architecture.

C172 gives the cheapest finite reference scaffold:

```text
finite sector set S
one designated light sector
real mass per sector
heavy complement with gap gamma > 0
straight-line mass homotopy
```

The abstract block-reference model proves the finite spectral part of the Gate
C1 import contract:

```text
sector-signature match
  + null-edge bad-sector inverse gap
  + null-edge light-sector lightness
  -> one light sector
  -> true bad-sector inverse-propagator gap
  -> uniformly gapped straight-line homotopy
```

This is intentionally only a scaffold. It does not prove physicality,
anomaly/index behavior, locality/control, determinant-line health, or Standard
Model gauge internality. Those remain explicit certificate fields.

C171R supplies the certificate stack consumed by the C159 import theorem:

```text
ReferenceImportContract
  kind: directFlavoredOverlap | abstractBlock | domainWall
  anomaly/index certificate
  locality/control certificate
  determinant-line/ghost certificate
  sub-gap homotopy certificate
```

Two useful claim boundaries are now formalized in the returned package:

```text
GW algebra alone does not imply anomaly cancellation.
A sign function alone does not imply summable locality/control.
```

So the Gate C1 assembly must keep these certificates visible:

```text
AnomalyIndexCertificate:
  index transported, reference anomaly-free, anomaly transported.

LocalityControlCertificate:
  path-shell summability or admissibility/locality theorem.

DetGhostControlCertificate:
  determinant line triviality and no ghost zero.

SubgapCertificate:
  norm difference below the reference gap.
```

Plan impact:

```text
Use C172 abstract block-reference as the first finite assembly target.
Replace the abstract reference by CKM/direct flavored-overlap or domain-wall
only after the sector signs, gap, anomaly/index, locality/control, determinant,
ghost, and SM-internality certificates are supplied.
```

Claim boundary:

```text
C171R + C172 do not close Gate C1. They make the import interface sharper and
prevent accidental overclaiming. The remaining load-bearing blockers are still
the CKM mass table/window, C170R sub-gap bound, direct reference match,
SM internality, anomaly/index source theorem, determinant-line control,
ghost-zero exclusion, and non-ultralocal control.
```

## 37. Integrated Aristotle update: C170R, C175, C177, and C178

Date: 2026-06-27
Source: Completed Aristotle jobs C170R, C175, C177, and C178. See
`AgentTasks/null-edge-aristotle-gate-c1-completed-integration-14-2026-06-27.md`.

This batch fills several of the concrete reference-import obligations.

C170R completes the sub-gap homotopy certificate that C164/C159 needed. It
decomposes the operator difference into five bounded pieces:

```text
H_ne - H_ref =
  kinetic mismatch
  + W_branch mismatch
  + R/m0 mismatch
  + gauge/admissibility perturbation
  + branch-frame mismatch.
```

With named constants:

```text
kappa, omega, rho, alpha, beta
```

it proves the sufficient bound:

```text
||H_ne - H_ref|| <= kappa + omega + rho + alpha + beta.
```

If:

```text
kappa + omega + rho + alpha + beta < gamma_ref,
```

then the straight-line homotopy stays uniformly gapped with residual margin:

```text
gamma_ref - ||H_ne - H_ref||.
```

This closes the abstract homotopy-control slot. It does not prove that the
actual CKM/null-edge constants satisfy the inequality; those constants still
need to be computed or bounded.

C175 proves the pure product/parity no-go in dimension four:

```text
M_P(corner) = (-1)^level
```

has:

```text
8 positive corners and 8 negative corners.
```

So any selector depending only on `M_P` cannot isolate the unique level-zero
corner. C175 also records the level-linear Wilson comparison:

```text
W_level = r sum_mu (1 - c_mu) = 2r level
```

with values and multiplicities:

```text
0, 2r, 4r, 6r, 8r
1, 4, 6, 4, 1.
```

C177 proves the CKM branch-mass gauge-safety theorem under `SMActsInternally`.
If the finite space factors as:

```text
Branch tensor Internal
```

and every SM generator acts as:

```text
id_Branch tensor g_i,
```

while `M_CKM`, `R`, and `W_branch` act as branch operators tensored with the
internal identity, then `W_branch` commutes with every SM generator. The no-go
is equally important: a single branch-mixing gauge generator that fails to
commute with the branch mass breaks native gauge safety unless an explicit
gauge dressing is supplied.

C178 gives the high-level index-import architecture. It splits the import stack
into:

```text
HomotopyTransferred:
  overlap/GW algebra, projector rank, index/spectral-flow data, Krein sign.

IndependentCertificates:
  anomaly/index-weight matching, SM gauge representation, non-ultralocal
  control, locality/admissibility, determinant-line health, no ghost zero.
```

It also makes the sector-signature checklist explicit:

```text
rank;
chirality;
branch parity;
gauge representation;
shifted mass sign;
Krein sign;
anomaly/index weight.
```

The most important strategic warning from C178 is:

```text
CKM is useful as the flavor-texture/mass-table reference.
Do not treat a literal naive product flavored-overlap operator as the final
reference unless it is proven doubler-resolved.
```

The safer operator-side reference should be a doubler-resolved
Neuberger-overlap, tuned flavored-overlap, or domain-wall reference whose sector
signature matches the CKM-like null-edge branch mass.

Updated near-term state:

```text
Sub-gap homotopy API: now available via C170R.
Pure parity no-go: now proved via C175.
Gauge safety of branch masses: now certified under SMActsInternally via C177.
Index-import architecture: now sharpened via C178.
Still running or open: CKM mass table, shifted CKM one-sector window, direct
CKM/reference homotopy, and the physical certificate instantiations.
```

## 38. Integrated Aristotle update: C173 CKM table and C179 reference choice

Date: 2026-06-27
Source: Completed Aristotle jobs C173 and C179. See
`AgentTasks/null-edge-aristotle-gate-c1-completed-integration-15-2026-06-27.md`.

This batch both validates the CKM mass table and sharpens how it should be used.

C173 proves the CKM-style four-dimensional corner table under the standard
elementary-symmetric convention. For signs:

```text
c_mu in {+1, -1}
```

define:

```text
M_V = sum_mu c_mu
M_T = sum_{mu < nu} c_mu c_nu
M_A = sum_{mu < nu < rho} c_mu c_nu c_rho
M_P = product_mu c_mu
M_CKM = M_P + M_V + M_T + M_A.
```

The algebraic identity is:

```text
1 + M_CKM = product_mu (1 + c_mu).
```

Therefore:

```text
level 0:   M_CKM = 15
level > 0: M_CKM = -1
```

This confirms the CKM table exactly. No correction or rescaling is needed,
provided the components are the genuine elementary symmetric functions.

C179 then corrects the physical reference strategy. CKM is the right mass
texture/table to use, but a literal naive CKM/product flavored-overlap operator
should not be the first physical reference. The ranked reference choice is now:

```text
1. Wilson/Neuberger overlap as first physical reference.
2. Abstract block reference as scaffold/interface underneath it.
3. Domain-wall reference as second physical cross-check.
4. Adams/staggered-overlap only with a separate taste-index theorem.
5. Literal naive CKM/tuned naive flavored-overlap is disqualified as first
   target unless independently proven doubler-resolved.
```

The operational interpretation is:

```text
Use CKM as a flavor texture / finite mass-table input.
Use a doubler-resolved Wilson/Neuberger, tuned overlap, or domain-wall operator
as the physical reference whose index, gap, locality, and GW properties are
actually trusted.
```

C179's doubler-resolved criteria are:

```text
correct continuum index and mode count with no hidden factor-16;
O(1/a) gap on doubler branches compatible with C170R constants;
exact GW or equivalent chiral identity, not tuning alone;
no ghost zeros at doubler corners;
locality/control on admissible backgrounds;
gauge consistency under SMActsInternally.
```

Plan impact:

```text
Do not abandon the CKM table; C173 made it a validated finite ingredient.
Do demote literal naive CKM as the physical reference target.
Promote Wilson/Neuberger overlap, with CKM texture as an auxiliary flavor/mass
factor, as the first reference-import lane.
```

Open work after this update:

```text
C174 shifted CKM one-sector window remains running.
C176 CKM/reference homotopy remains running, but must be read through the C179
warning: the reference must be doubler-resolved.
New follow-up jobs should target Wilson/Neuberger reference import with CKM
texture, not literal naive CKM as the physical operator.
```

## 39. Integrated Aristotle update: C174, C176, C180-C183, and C185

Date: 2026-06-27
Source: Completed Aristotle jobs C174, C176, C180, C181, C182, C183, and C185.
See `AgentTasks/null-edge-aristotle-gate-c1-completed-integration-16-2026-06-27.md`.

This batch turns several open Gate C1 obligations into explicit certificate
interfaces.

C174 closes the shifted CKM one-sector window in the diagnostic `R = I` case.
With:

```text
W_branch^(1) = r (15 R - M_CKM)
```

and `R = I`, it proves:

```text
level 0:   W_branch = 0
level > 0: W_branch = 16r
```

So for:

```text
0 < m0 < 16r
```

the level-zero sector lies on the light/negative side and all unwanted sectors
lie on the heavy/positive side, with margin:

```text
min(m0, 16r - m0).
```

C176 packages the gapped-homotopy interface for the reference import. If
`H_ref` has lower gap `gamma_ref` and:

```text
||H_ne - H_ref|| <= E_D + E_W + E_R + E_Gamma + E_gauge < gamma_ref,
```

then the straight-line homotopy from `H_ref` to `H_ne` remains uniformly gapped
with residual gap:

```text
gamma_ref - (E_D + E_W + E_R + E_Gamma + E_gauge).
```

This supplies the load-bearing input for sign-kernel and spectral-projector
continuity. It still does not prove index/signature constancy by itself; it
supplies the gap input those arguments consume.

C180 formalizes the seven-slot sector-signature match:

```text
rank;
chirality;
branch parity;
gauge representation;
shifted mass sign;
Krein sign;
anomaly/index weight.
```

A one-slot mismatch fails the match. For bad sectors, same shifted-mass signs
plus inverse-gap bounds prevent zero crossing under straight-line homotopy.
The physical certificates remain external:

```text
anomaly/index;
locality/control;
determinant-line;
SM internality.
```

C181 gives a concrete instantiation plan for the C170R constants. It uses a
telescoping chain:

```text
H_ne = H0 -> H1 -> H2 -> H3 -> H4 -> H5 = H_ref
```

where each leg controls one mismatch:

```text
kappa: kinetic/Dirac-symbol mismatch;
omega: W_branch/flavored-mass mismatch;
rho: R and m0 shift mismatch;
alpha: gauge/admissibility perturbation;
beta: branch-frame/tetrad/soldering mismatch.
```

The constants are not assumed small. They must be bounded, retuned, or reduced
by changing `m0`, `r`, `R`, the reference gap, the admissibility window, frame
alignment, or the homotopy subdivision.

C182 turns determinant-line and ghost-zero control into an explicit certificate
package. It distinguishes:

```text
TrueInverseGap
```

from:

```text
PropagatorZeroMirrorRemoval.
```

The key rule is now formalized:

```text
propagator-zero mirror removal is incompatible with a true bad-sector inverse
gap.
```

Determinant-line control, anomaly/index import, and ghost-zero exclusion remain
logically independent certificate fields.

C183 gives the anomaly/index source interface. The important split is:

```text
topological/index data:
  transported along gauge-safe gapped homotopy;

representation-theoretic Standard Model anomaly cancellation:
  checked independently from representation content, hypercharge normalization,
  chirality assignment, and gauge internality.
```

It also records one Standard Model generation as an explicit anomaly-free
certificate in the returned package, while keeping reference index theorems as
external source obligations.

C185 gives the Krein-sign continuity certificate. A spectral gap alone is not
enough. To prevent silent Krein-sign flips, the import needs:

```text
projector continuity;
nondegenerate restricted Krein form;
null-safety;
positive spectral gap.
```

If the restricted Krein form degenerates, the sign can flip. This should be
included in the sector-signature and reference-import audit.

Updated state:

```text
CKM table: proved.
Shifted CKM one-sector window: proved in R = I diagnostic form.
Pure product parity no-go: proved.
Sub-gap homotopy API: proved.
Sector-signature API: proved.
Gauge safety under SMActsInternally: proved.
Determinant/ghost interface: proved.
Anomaly source interface: proved.
Krein-sign continuity interface: proved.
Non-ultralocal control instantiation: still running as C184.
Physical reference choice: Wilson/Neuberger first, with CKM as texture/table.
```

Main remaining conceptual blocker:

```text
Build or specify the actual null-edge operator as a CKM-textured,
doubler-resolved Wilson/Neuberger or domain-wall reference import, then compute
or bound the C170/C181 constants and fill the anomaly, determinant, ghost,
Krein, SM-gauge, and non-ultralocal control certificates.
```

## 40. Pro architecture update: Wilson/Neuberger handles spacetime, CKM handles branch texture

Date: 2026-06-27
Source: Pro analysis on the first physical architecture after the CKM/reference
choice pivot.

The strategic ambiguity is now resolved:

```text
CKM table = finite branch/flavor mass texture.
Wilson/Neuberger = first physical doubler-resolved overlap reference.
Domain-wall = cross-check / fallback / inflow model.
Abstract block = scaffold for proving the homotopy, not the final physics
reference.
```

Do not let the CKM table carry the full burden of spacetime doubler resolution.
The safe architecture is:

```text
Wilson spacetime doubler resolver + CKM branch/flavor texture.
```

not:

```text
CKM texture alone as the physical lattice operator.
```

### Reference kernel

Let the reference Hilbert space factor schematically as:

```text
V_ref = V_spin tensor V_gauge tensor V_CKM.
```

Use:

```text
D_W^0(U) = D_naive^cov(U) + W_space(U)
```

with free symbol:

```text
D_W^0(p)
  = i sum_mu gamma_mu sin(p_mu)
    + r_W sum_mu (1 - cos(p_mu)).
```

Put the CKM texture in the finite branch/flavor factor:

```text
W_CKM = r_b (15 R_CKM - M_CKM).
```

In the first pass:

```text
R_CKM = I.
```

Then:

```text
H_ref(U)
  =
  Gamma_ref [
      D_W^0(U) tensor I_CKM
      + I_spin,gauge tensor W_CKM
      - m0 R_ref
  ].
```

with first-pass normalization:

```text
R_ref = I.
```

The overlap reference is:

```text
D_ov,ref(U)
  =
  rho_ov [1 + Gamma_ref sign(H_ref(U))].
```

### Null-edge endpoint

Use:

```text
H_ne(U)
  =
  Gamma_K [
      D_ne^cov(U)
      + W_NE,space(U)
      + W_CKM^ne(U)
      - m0 R_ne(U)
  ],
```

and:

```text
D_ov,ne(U)
  =
  rho_ov [1 + Gamma_K sign(H_ne(U))].
```

If notation insists on:

```text
H_ne = Gamma_K(D_ne + W_branch - m0 R),
```

then define:

```text
D_ne := D_ne^cov + W_NE,space
W_branch := r_b(15R_ne - M_CKM^ne).
```

This makes explicit that CKM splits branch/flavor sectors while the Wilsonized
spacetime part resolves momentum doublers.

### Combined free mass window

Let:

```text
n = number of pi-components in the spacetime momentum corner;
ell = CKM level;
w_0 = 0;
w_bad = 16 r_b.
```

The shifted free mass is:

```text
mu(n, ell) = 2 r_W n + w_ell - m0.
```

Then:

```text
mu(0,0) = -m0 < 0.
```

Spacetime doublers in the CKM-light sector satisfy:

```text
n >= 1, ell = 0:
mu(n,0) >= 2 r_W - m0.
```

CKM-heavy sectors at the physical spacetime corner satisfy:

```text
n = 0, ell > 0:
mu(0,ell) = 16 r_b - m0.
```

So a clean sufficient window is:

```text
0 < m0 < min(2 r_W, 16 r_b).
```

with free reference margin:

```text
gamma_free = min(m0, 2 r_W - m0, 16 r_b - m0).
```

This is the theorem target that combines C174's CKM window with ordinary Wilson
doubler resolution.

### Homotopy after transport

After transporting the reference into the null-edge frame:

```text
H_ref^S(U,q) = S(q,U) H_ref(U,q) S(q,U)^-1,
```

use:

```text
H_t(U,q) = (1 - t) H_ref^S(U,q) + t H_ne(U,q).
```

The C170/C181 budget becomes:

```text
||H_ne - H_ref^S||
  <= kappa + omega + rho + alpha + beta
  < gamma_ref.
```

In the ideal first pass:

```text
omega = 0
rho = 0
beta = 0 in the flat/free branch frame
alpha = 0 at U = 1
kappa = 0 only if the null-edge kinetic is chosen to match the Wilsonized
        reference.
```

The hard constants are:

```text
kappa, alpha, beta.
```

Retune in this order:

```text
1. Set omega = 0 by using the exact same CKM table on both sides.
2. Set rho = 0 by taking R = I in the first theorem.
3. Choose m0 in the middle of the allowed mass window.
4. Increase r_b so the CKM-heavy gap is not limiting.
5. Use a multi-stage homotopy or abstract block intermediate if straight-line
   control is too crude.
6. Shrink the admissible gauge-field ball to reduce alpha.
7. Improve branch-frame/soldering alignment to reduce beta.
8. If kappa remains large, choose a closer Wilsonized null-edge kinetic
   reference.
```

### Updated theorem target

The combined architecture should close `GateC1_NU` only through:

```text
CKM-decorated Wilson mass window;
sector-signature match;
C170/C181 sub-gap homotopy;
overlap sign/GW algebra;
overlap light/heavy inverse-gap theorem;
branch-line lift;
SMActsInternally or exact gauge dressing;
no propagator-zero mirror removal;
Krein/Hilbertization audit;
anomaly/index import;
non-ultralocal control;
final assembly theorem.
```

Claim boundary:

```text
H_ref works does not imply the null-edge program works.
The null-edge claim is that H_ne lies in the same gapped, sector-signature
matched overlap component as the CKM-decorated Wilson/Neuberger reference.
```

## 41. Integrated Aristotle update: C184 and C186-C192 architecture batch

Date: 2026-06-27
Source: Completed Aristotle jobs C184 and C186-C192. See
`AgentTasks/null-edge-aristotle-gate-c1-completed-integration-17-2026-06-27.md`.

This batch largely closes the abstract certificate-design phase.

C184 supplies the `GateC1_NU` non-ultralocal control instantiation. It packages
path-shell control by per-shell operator-norm contributions, a summable
dominating amplitude profile, finite-propagation as a sufficient special case,
tail-to-zero theorems, and a resolvent/sign-kernel route. This fills the
control slot that remained open after C171R/C183/C185.

C186 gives the concrete first physical architecture:

```text
Wilson/Neuberger overlap reference
  + CKM texture as a finite branch/flavor mass table.
```

The key claim boundary is unchanged:

```text
CKM texture is not the spacetime kinetic operator.
Wilson/Neuberger resolves spacetime doublers.
CKM splits finite branch/flavor sectors.
```

C187 formalizes the no-new-doubler principle for finite CKM texture. A
momentum-independent finite texture does not create Brillouin-zone doublers
under invertibility/gap-compatibility hypotheses. The failure modes are exactly
the expected ones: noninvertible texture, momentum-dependent CKM factor,
gauge-mixing texture, or a sign/gap closure.

C188 specializes the C170/C181 constants to the Wilson/Neuberger+CKM
architecture. In the ideal first-pass construction:

```text
omega = 0  from identical CKM texture;
rho   = 0  from R = I and shared m0;
alpha = 0  in the free theory;
beta  = 0  in the flat aligned branch frame;
kappa is the hard kinetic/Wilsonized null-edge mismatch.
```

C189 supplies the domain-wall fallback architecture. CKM belongs as a boundary
flavor coupling. The fallback needs residual-mass control, mirror gap, boundary
index/inflow, determinant/ghost control, SM internality, and locality/control.
Domain-wall is now a structured fallback/cross-check, not an alternative that
automatically closes Gate C1.

C190 supplies the reference theorem source map. The first source lane is:

```text
Wilson/Neuberger overlap:
  GW relation;
  lattice index theorem;
  locality/admissibility;
  anomaly-cancellation/determinant-line source shape.
```

The second lane is domain-wall boundary/inflow and effective-overlap
equivalence. Adams/staggered-overlap remains a later lane requiring a separate
taste-index theorem.

C191 gives the `SMActsInternally` Furey/Hughes audit. The branch factor carrying
`J` and CKM texture must be disjoint from the factors acted on by SM gauge
generators. Weak chirality, hypercharge, generation/flavor, or octonion ladder
operations must not leak into the null-edge branch factor.

C192 gives the final `GateC1_NU` assembly skeleton. It names the certificate
fields and proves only the structural implication:

```text
all certificates supplied -> GateC1_NU.
```

It does not assert that any certificate is automatically true.

Updated status:

```text
Abstract certificate stack: essentially complete.
Concrete first architecture: Wilson/Neuberger + CKM texture.
Main remaining work: instantiate the certificates for the actual null-edge
operator and prove the combined Wilson+CKM mass-window theorem C193.
```

## 42. Pro confirmation: first physical import is Wilson/Neuberger, not CKM alone

Date: 2026-06-27
Source: Pro analysis pasted in
`C:\Users\Owner\.codex\attachments\9bc42fda-a54b-45e8-870c-9aec20a37454\pasted-text.txt`.

The latest Pro analysis sharpens the architecture without changing the main
direction.

The first physical reference should be:

```text
Wilson/Neuberger overlap reference
  with CKM inserted as an internal branch/flavor mass table.
```

Do not make literal CKM, naive CKM, or a CKM-style finite table carry the whole
spacetime doubler-resolution burden unless a separate flavored-overlap theorem
is proved for the actual null-edge kinetic kernel.

Use the role split:

```text
Wilson/Neuberger:
  spacetime momentum-corner doubler resolution.

CKM table:
  finite branch/flavor/qutrit mass texture.

Domain-wall:
  fallback, inflow cross-check, or overlap interpretation.

Abstract block kernel:
  homotopy scaffold, not the final physical reference.
```

The reference kernel remains:

```text
H_ref(U) =
  Gamma_ref [
    D_W^0(U) tensor I_CKM
    + I tensor r_b(15 I - M_CKM)
    - m0 I
  ].
```

The null-edge endpoint remains:

```text
H_ne(U) =
  Gamma_K [
    D_ne^cov(U)
    + W_NE,space(U)
    + r_b(15 R_ne - M_CKM^ne)
    - m0 R_ne
  ].
```

The clean free mass window is:

```text
0 < m0 < min(2 r_W, 16 r_b).
```

with margin:

```text
gamma_free = min(m0, 2 r_W - m0, 16 r_b - m0).
```

This creates the intended sign table:

```text
negative shifted mass:
  exactly spacetime corner n = 0 and CKM level ell = 0.

positive shifted mass:
  all spacetime doublers n >= 1 and all CKM-heavy sectors ell > 0.
```

The C170/C181 constants should now be read as an error budget after transporting
both kernels to the same Hilbert space and branch frame:

```text
kappa = kinetic and Wilsonized null-edge mismatch.
omega = CKM texture mismatch.
rho   = R and m0 shift mismatch.
alpha = gauge/admissibility perturbation.
beta  = branch-frame, tetrad, or soldering mismatch.
```

First-pass target values:

```text
omega = 0 by using the same CKM table.
rho   = 0 by taking R = I.
alpha = 0 in the free theory.
beta  = 0 in the flat aligned frame.
kappa is the hard remaining constant.
```

The immediate proof stack is:

```text
C193: combined CKM-decorated Wilson mass-window theorem.
C194: concrete null-edge Wilsonized kinetic and kappa-bound certificate.
C195: Wilson/Neuberger source-certificate interface.
C196: sector-signature map and failure conditions.
C197: SMActsInternally factor audit for Furey/Hughes conventions.
C198: multi-stage homotopy through an abstract block kernel.
C199: high-level strategy audit for the fastest GateC1_NU closure path.
```

Claim boundary:

```text
H_ref works is not enough.
The null-edge claim is that H_ne is in the same gapped, sector-signature matched
overlap component as H_ref.
```

## 43. Integrated Aristotle update: C193 free Wilson+CKM mass-window theorem

Date: 2026-06-27
Source: Aristotle project `e63bde80-6cec-4422-a350-0189a78037dc`, task
`0678f49b-4230-465f-94fa-4c0210598cdd`.

C193 completes the first finite theorem in the Wilson/Neuberger+CKM reference
stack.

Returned model:

```text
w(r_b, ell) =
  0          if ell = 0;
  16 r_b    if ell > 0.

mu(r_W, r_b, m0, n, ell) =
  2 r_W n + w(r_b, ell) - m0.

gamma_free(r_W, r_b, m0) =
  min(m0, 2 r_W - m0, 16 r_b - m0).
```

Under:

```text
r_W > 0;
0 < m0 < min(2 r_W, 16 r_b),
```

the returned theorem package proves:

```text
mu(0,0) < 0;
mu(n,0) > 0 for every n >= 1;
mu(n,ell) > 0 for every ell > 0;
mu(n,ell) < 0 iff (n,ell) = (0,0);
gamma_free > 0;
mu(0,0) <= -gamma_free;
mu(n,ell) >= gamma_free for every non-physical sector;
over n in {0,1,2,3} and ell in {0,...,15}, exactly one sector is light.
```

The returned Lean names include:

```text
w;
w_zero;
w_pos_of_pos;
mu;
gamma_free;
gamma_free_pos;
mu_phys_neg;
mu_doubler_pos;
mu_heavy_pos;
mu_neg_iff;
mu_phys_le_neg_margin;
mu_heavy_ge_margin;
light_sector_count;
gateC1_free_mass_window.
```

Important nuance:

```text
r_b > 0 is not a separate needed hypothesis.
It follows from 0 < m0 < 16 r_b.
```

Status impact:

```text
C193 closes the free reference sign-window certificate.
It does not close GateC1_NU.
It supplies gamma_free as the reference margin for the C170/C181 homotopy budget.
```

The next hard theorem is now sharper:

```text
prove that the transported null-edge endpoint H_ne remains within gamma_free
of the CKM-decorated Wilson/Neuberger reference, or use a multi-stage homotopy
whose every segment stays gapped.
```

Artifact:

```text
AgentTasks/aristotle-output/e63bde80-6cec-4422-a350-0189a78037dc/extracted/0678f49b-4230-465f-94fa-4c0210598cdd_aristotle/RequestProject/Main.lean
```

Local promotion note:

```text
The returned Lean source is preserved as an Aristotle artifact.
It has not yet been promoted into PhysicsSM trusted or draft modules in this
cycle because local Lean verification was not requested/run here.
```

## 44. Integrated Aristotle update: C194-C203 after C193

Date: 2026-06-27
Source: completed Aristotle projects C194-C203.

This batch turns the post-C193 picture into a much more explicit certificate
program.

C194 supplies the first concrete null-edge Wilsonized kinetic scaffold. The
recommended free/flat choice is:

```text
W_NE,space(p) =
  r_b sum_j spatial (1 - cos p_j).
```

This intentionally reuses the Wilson/Neuberger doubler-lifting profile and does
not ask CKM to remove spacetime doublers. C194 also formalizes:

```text
Gapped(g,H);
transport(S,Sinv,H);
KappaCertificate(S,Sinv,H_ne,H_ref,kappa);
GappedHomotopic(A,B).
```

The main flat/free theorem is:

```text
if H_ref is gapped by g,
if 0 <= kappa < g,
if the transported H_ne differs from H_ref by at most kappa,
then H_ref and transported H_ne are gapped-homotopic.
```

This is now the central operator-level obligation:

```text
prove ReferenceIsGapped;
prove NullEdgeKineticCloseEnough;
keep kappa < gamma_free or use a multi-stage path.
```

C195 supplies the overlap source-certificate interface. It separates:

```text
algebraic Ginsparg-Wilson/overlap data;
locality/admissibility;
anomaly/index;
determinant-line/quantum gauge measure;
ghost-zero exclusion.
```

Important import rule:

```text
algebraic GW, locality under uniform admissibility, and index can be transported
along a uniformly gapped homotopy;
the determinant line is not imported automatically.
```

C196 supplies the finite sector-signature layer:

```text
rank;
chirality;
branch parity;
gauge representation;
shifted-mass sign;
Krein sign;
index weight.
```

A mismatch in any one field blocks the reference import. It also reconstructs
the C193-style uniqueness theorem at the signature level:

```text
mu_ref(n,ell) < 0 iff (n,ell) = (0,0).
```

C197 supplies the `SMActsInternally` audit framework. The branch data used by
`J`, `Gamma_K`, `R`, and `W_CKM` must sit in the centralizer of all SM gauge
generators, or be handled by an explicit gauge-dressed replacement. The hard
warning is:

```text
if gauge generators mix the branch parity used by the CKM selector, native C1
branch selection fails.
```

C198 supplies the multi-stage homotopy fallback:

```text
H_Wilson+CKM -> H_abs.block -> H_ne.
```

The composition theory is useful, but it leaves one documented analytic
eigenvalue-continuity/signature-preservation obligation. Treat C198 as a
scaffold, not a closed theorem.

C199 strategy audit recommends making the kappa mismatch bound the critical
path. C193 should be packaged as a reusable gap lemma, while `SMActsInternally`
and source certificates remain required but off the immediate proof bottleneck.

C200 attempted a project draft port of C193 but did not have the actual C193
Lean artifact available in its request project. It reconstructed parts of the
source and reported non-matching concrete choices. Therefore:

```text
do not promote the C200 port;
use the actual C193 artifact instead.
```

C201 supplies the `gamma_free` sign-stability theorem. In scalar form:

```text
m(phys) <= -gamma;
m(s) >= gamma for s != phys;
|delta(s)| < gamma for all s
  implies
m(phys)+delta(phys) < 0
and
m(s)+delta(s) > 0 for s != phys.
```

It also gives an operator-style homotopy theorem assuming a Weyl/Lipschitz drift
certificate. This is exactly how C193 feeds the kappa/alpha/beta budget.

C202 supplies the branch-line lift scaffold via maintained spectral islands and
Riesz-style projectors. It separates finite-dimensional projector/rank/chiral
index persistence from the analytic contour-integral input.

C203 supplies the source-contract map. Its key claim boundary:

```text
GateC1_NU_Free:
  free no-doubling/sign window + algebraic overlap/GW.

GateC1_NU_BackgroundGauge:
  add locality/admissibility or non-ultralocal control and anomaly/index.

GateC1_NU_Quantum:
  add determinant-line/gauge-measure control and ghost-zero exclusion.
```

It also identifies missing source work:

```text
Hasenfratz-Laliena-Niedermayer for explicit lattice index identity;
Narayanan-Neuberger vacuum-overlap/determinant-line origin;
reflection/Osterwalder-Schrader positivity or explicit open-problem note;
nonabelian nonperturbative chiral determinant remains an open claim boundary.
```

Updated critical path:

```text
1. Promote the actual C193 artifact, not the C200 reconstruction.
2. Package C194/C201/C202 theorem interfaces into a coherent draft module set.
3. Prove ReferenceIsGapped for the concrete Wilson+CKM reference.
4. Specify H_ne and prove NullEdgeKineticCloseEnough with kappa < gamma_free.
5. If direct kappa fails, use C198 multi-stage homotopy.
6. Instantiate C196 sector-signature match and C197 SMActsInternally.
7. Use C195/C203 source contracts to state exactly which level of GateC1_NU is
   claimed.
```

## 45. Integrated Aristotle update: C204-C208 free-gate assembly layer

Date: 2026-06-27
Source: completed Aristotle jobs C204-C208.

C204 gives the safe promotion plan for the real C193/C194/C201/C202 artifacts.
It explicitly rejects the C200 reconstruction and recommends four draft leaves:

```text
GateC1/WilsonMassWindow.lean       from C193;
GateC1/GappedHomotopy.lean         from C194;
GateC1/SignStability.lean          from C201;
GateC1/ProjectorPersistence.lean   from C202.
```

C205 is a major reference-side result. It proves an abstract
`ReferenceIsGapped` theorem for the CKM-decorated Wilson/Neuberger reference:

```text
C193 scalar margin
+ DiracFiber Clifford norm identity
-> ReferenceIsGapped gamma_free H_ref.
```

The single exposed non-scalar input is the Clifford/gamma anticommutation that
kills the cross term:

```text
K (Gamma x) + Gamma (K x) = 0.
```

C206 decomposes the null-edge closeness certificate. It defines:

```text
H_ne = Gamma_K [D + W + r_b(15R - M_CKM) - m0 R].
```

and splits kappa into:

```text
kappaBranch;
kappaKin;
kappaWil;
kappaCKM;
kappaRm0.
```

The important simplification is:

```text
if transport(M_CKM^ne) = M_CKM^ref
and transport(R_ne) = R_ref,
then kappaCKM = 0 and kappaRm0 = 0.
```

The remaining first-pass estimate becomes:

```text
kappaBranch + kappaKin + kappaWil < gamma_free.
```

C207 supplies an abstract `GateC1_NU_Free` assembly theorem. It combines:

```text
C193 mass window;
C205-style ReferenceIsGapped;
C194 kappa < gap -> gapped homotopy;
C206 NullEdgeKineticCloseEnough;
C196 sector-signature match;
C201 sign-stability;
C202 maintained spectral island.
```

It explicitly excludes:

```text
background-gauge claims;
determinant-line claims;
anomaly claims;
ghost-sector claims;
quantum/loop claims.
```

C208 supplies the missing-source priority table:

```text
P1 Kato:
  Riesz projection and isolated spectral subspace stability.

P2 Davis-Kahan:
  quantitative spectral-subspace perturbation bounds.

P3 Hasenfratz-Laliena-Niedermayer:
  lattice index theorem from the Ginsparg-Wilson relation.

P4 Narayanan-Neuberger:
  vacuum-overlap and determinant-line origin.

P5 Fujikawa:
  secondary continuum chiral-Jacobian cross-check.
```

Updated status:

```text
GateC1_NU_Free now has an abstract external assembly theorem.
The reference-side gap is externally formalized, modulo the concrete Clifford
anticommutation input.
The null-edge-side kappa certificate is decomposed.
The remaining hard task is concrete instantiation:
  actual H_ne data,
  actual transport S,
  CKM/R matching,
  numeric or symbolic bounds for kappaBranch+kappaKin+kappaWil < gamma_free.
```

## 46. Integrated Aristotle update: C209-C213 concrete-instantiation boundary

Date: 2026-06-27
Source: completed Aristotle jobs C209-C213.

C209 maps the C205 Clifford/gap input back to existing project work. Because the
returned request project did not contain the actual repo modules, it does not
prove the concrete bridge. It gives a verified abstract skeleton and a clear
next local task:

```text
open PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean;
open PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean;
map the repo Gamma/K conventions into:
  Anticomm(G,K);
  NormSquare;
  ReferenceIsGapped.
```

The key risk is whether the reference operator is the additive `K + Gamma`
model used in the skeleton or the actual Neuberger `1 + gamma5 sign(H)` form. If
the latter, the cross-term proof must be redone for the sign-kernel form.

C210 formalizes the best-case kappa result. With endpoint data packaged into a
record, every kappa component is defined as a normed mismatch. It proves:

```text
if transport(Gamma_K) = Gamma_ref;
if transport(D_ne^cov + W_NE,space) = D_W^0;
if transport(M_CKM^ne) = M_CKM;
if transport(R_ne) = I;
then kappa = 0.
```

It also proves the realistic first theorem:

```text
if CKM and R transport exactly,
then kappa = kappaBranch + kappaKin + kappaWil.
```

So the main inequality remains:

```text
kappaBranch + kappaKin + kappaWil < gamma_free.
```

C211 gives the exact real-artifact promotion execution plan. It maps the real
artifacts to draft targets and insists on statement-identity review. This is the
correct local promotion path before claiming any of these external Lean packages
inside the repo.

C212 gives the most important status clarification:

```text
we are still choosing an operator until the concrete carrier, H_ref, H_ne/kappa
map, and free side-condition zeros are frozen.
```

Closure of `GateC1_NU_Free` requires:

```text
1. fix finite carrier, basis, and exact field;
2. instantiate H_ref with explicit matrix entries;
3. instantiate H_ne and kappa decomposition;
4. prove the decomposition identity;
5. compute/reference the H_ref gap;
6. prove gap stability for H_ne;
7. prove free side conditions are zero;
8. feed all data into C207;
9. run axiom/vacuity/non-overclaim audits.
```

C213 maps determinant-line follow-up sources:

```text
Narayanan-Neuberger 1993:
  determinant-as-overlap origin and phase ambiguity.

Kaplan-Schmaltz 1995:
  domain-wall eta-invariant and partial boundary/inflow cross-check.

Hasenfratz-Laliena-Niedermayer 1998:
  still the required index-theorem source.
```

Forbidden claim boundary:

```text
Narayanan-Neuberger is provenance for the overlap determinant, not a full
nonabelian nonperturbative gauge-invariant determinant-line solution.
```

Updated status:

```text
Abstract GateC1_NU_Free plumbing is ready externally.
Concrete closure still waits on a fixed finite operator model and the kappa
inequality for that model.
```

## 47. Integrated Aristotle update: C214-C218 says stop abstract job expansion

Date: 2026-06-27
Source: completed Aristotle jobs C214-C218.

C214-C217 produced concrete toy/proposal-level finite models and arithmetic
templates. They are useful as implementation scaffolds, but they are not yet the
authoritative null-edge operator in this repo.

C214 proposes a first finite carrier:

```text
Carrier = Fin 3;
field = Complex;
basis = generation basis.
```

This is useful for a generation/CKM toy carrier, but it is not yet enough for
the full spinor x branch x CKM reference operator. It should be treated as a
carrier-freeze proposal, not a final physical carrier.

C215 proposes a momentum-corner diagonal representation for `H_ref`:

```text
Corner = Fin 4 -> Bool;
ell = number of pi-components;
H_ref diagonal entry = Gamma * (2 r_b ell - m0).
```

This is valuable because it avoids DFT machinery for the first proof, but it is
a corner-basis reference model. It must still be reconciled with the C193
Wilson+CKM sector labels and with the actual Clifford/spinor representation.

C216 gives a self-contained finite-matrix `H_ne` and transport toy model with:

```text
exact CKM transport;
exact R transport;
nonzero kinetic, Wilson, and branch residuals.
```

This supports the C206 decomposition, but it uses concrete illustrative 3x3 real
matrices. Do not treat it as the physical null-edge endpoint unless those
matrices are explicitly adopted as the model.

C217 gives exact rational arithmetic for the kappa inequality. The useful
general lesson is:

```text
balanced window:
  r_W >= m0;
  r_b >= m0/8;
then gamma_free = m0.
```

At normalized values:

```text
m0 = 1;
r_W = 1;
r_b = 1/8;
gamma_free = 1.
```

It also shows how to prove a falsifiable rational bound, but its concrete
numeric residual `kappaWil = 3/100` is a template until derived from the actual
operator.

C218 gives the strategic decision:

```text
stop opening new abstract Aristotle jobs;
promote and locally check the real artifact spine;
freeze the concrete operator;
then submit only implementation- or gap-closing jobs.
```

Updated action boundary:

```text
The next work should be local Lean promotion/freezing, not another speculative
certificate wave.
```

Concrete next local targets:

```text
1. Promote C193/C194/C201/C202 real artifacts into Draft modules.
2. Decide whether the first carrier is corner-basis, generation-only, or
   spinor x corner x CKM.
3. Define authoritative H_ref and H_ne in that carrier.
4. Recompute kappa pieces from that actual definition.
5. Only then claim the C207 assembly theorem applies.
```

## 48. Integrated Aristotle update: C219-C221 local-promotion handoff

Date: 2026-06-27
Source: completed Aristotle jobs C219-C221.

C219 gives the local-promotion readiness audit. The recommended target files are:

```text
PhysicsSM/Draft/NullEdge/GateC1/C193.lean;
PhysicsSM/Draft/NullEdge/GateC1/C194.lean;
PhysicsSM/Draft/NullEdge/GateC1/C201.lean;
PhysicsSM/Draft/NullEdge/GateC1/C202.lean.
```

The allowed edit style is deliberately thin:

```text
import source artifact;
alias or theorem wrapper by exact source;
no reconstruction;
no changed signatures;
no new theory.
```

C220 narrows the Clifford bridge target. The local theorem should import the
existing C21 actual Clifford-symbol conventions and prove the C205/C209
anticommutation/norm bridge without inventing a new gamma convention. The known
obstruction remains:

```text
the bare branch symbol is chirality-balanced;
do not route the gap proof through the bare balanced branch.
```

Instead, carry the chirality projectors explicitly and prove only the local
Clifford/norm bridge.

C221 supports the `H_ref` side through spectral-graph Wilson matrices:

```text
H_ref = m I + r L,
```

where `L` is the cycle-graph Laplacian / Wilson second-difference matrix. The
corner modes reproduce sector masses:

```text
constant mode:
  mu(1,0) = m;

alternating mode:
  mu(1,1) = m + 4r.
```

This supports the finite Wilson reference only. It leaves `H_ne` untouched and
does not claim full `GateC1_NU`.

Updated handoff:

```text
The next step should be local promotion and narrow local Lean work, not another
external abstract job wave.
```

## 49. Integrated Aristotle update: C222-C224 exact promotion surface

Date: 2026-06-28
Source: completed Aristotle jobs C222-C224.

C222 inspected the actual copied files for C193/C194/C201/C202 plus the local
C21/branch modules. Its conclusion is narrower than earlier plans:

```text
Promote only the four self-contained Mathlib-only artifacts:
  C193 CKM/Wilson mass window;
  C194 kappa-to-gapped-homotopy;
  C201 sign stability;
  C202 projector persistence.

Leave the local NullEdgeActualCliffordSymbol and BranchClassifier files
external for now.
```

Recommended target files:

```text
PhysicsSM/Draft/NullEdge/GateC1/CKMWilsonWindow.lean;
PhysicsSM/Draft/NullEdge/GateC1/GappedHomotopy.lean;
PhysicsSM/Draft/NullEdge/GateC1/SignStability.lean;
PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean.
```

Collision risks:

```text
C202 opens a bare GateC1 namespace with generic names;
C194 uses NullEdgeGateC1;
C201 uses C201;
C193 and C201 have duplicate margin definitions with different argument order.
```

Therefore promotion should avoid broad `open`/`export` behavior and preserve
claim boundaries. If namespace edits are needed, theorem statements should not
be changed.

C222's first local Clifford bridge target is:

```text
branchKernel_chiralIndex_zero:
  the actual C21 branch kernel has zero chiral index in the C202/C205
  vocabulary.
```

This bridge must preserve the known obstruction:

```text
the bare branch symbol is chirality-balanced.
```

C223 maps the graph-matrix literature to `H_ref` only:

```text
arXiv:2112.13501:
  spectral graph representation and species/doubler count from graph spectrum.

arXiv:2311.11320:
  lattice operator to graph-matrix equivalence, Wilson term as graph Laplacian,
  DFT/circulant diagonalization.
```

These support:

```text
H_ref.graph_matrix_representation;
H_ref.wilson_laplacian_term;
H_ref.corner_or_DFT_diagonalization;
H_ref.species_count_support.
```

They do not support `H_ne` and do not close `GateC1_NU`.

C224 supplies the local patch-report boundary:

```text
If Draft promotion is applied without Lean checks, report it as unverified.
Do not touch trusted code, lakefile, toolchain, or existing source artifacts.
```

Updated action:

```text
Apply an additive Draft promotion patch for the four self-contained artifacts,
or pause and ask before promotion. Do not submit more broad abstract jobs before
this local promotion surface is resolved.
```

## 50. Local Draft promotion applied for C193/C194/C201/C202

Date: 2026-06-28

Applied the C222-C224 local promotion surface as an additive Draft patch.

Created:

```text
PhysicsSM/Draft/NullEdge/GateC1/CKMWilsonWindow.lean;
PhysicsSM/Draft/NullEdge/GateC1/GappedHomotopy.lean;
PhysicsSM/Draft/NullEdge/GateC1/SignStability.lean;
PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean.
```

Each file is copied from the corresponding real Aristotle artifact with a local
Draft provenance header.

Important status boundary:

```text
No local Lean checks have been run.
These files are Draft artifacts.
Compilation status is unknown.
No trusted code was promoted.
No full GateC1_NU claim is made.
```

Next local tasks:

```text
1. Run targeted Lean checks if requested.
2. Resolve any namespace/import issues found by those checks.
3. Add an import-only aggregator only after the leaf modules compile.
4. Start the C220 bridge theorem branchKernel_chiralIndex_zero.
```

## 51. Pro operator-freeze update: CKM texture inside Wilson/Neuberger overlap

Date: 2026-06-28
Source: Pro analysis in
`C:\Users\Owner\.codex\attachments\9bc42fda-a54b-45e8-870c-9aec20a37454\pasted-text.txt`.

This update sharpens the current architecture rather than changing it.

First physical reference:

```text
Wilson/Neuberger overlap reference
  with CKM inserted as an internal branch/flavor mass texture.
```

Do not use CKM by itself as the spacetime doubler-resolution mechanism unless
there is a separate CKM/flavored-overlap theorem for the actual null-edge
kernel. The safe split is:

```text
Wilson/Neuberger:
  resolves spacetime momentum corners.

CKM table:
  splits finite branch/flavor sectors.

Null-edge endpoint:
  must be transported into the same gapped overlap component.
```

The reference Hilbert space should be treated schematically as:

```text
V_ref = V_spin tensor V_gauge tensor V_CKM.
```

The reference Hermitian kernel is:

```text
H_ref(U) =
  Gamma_ref [
    D_W^0(U) tensor I_CKM
    + I tensor W_CKM
    - m0 R_ref
  ],
```

where the first-pass normalization is:

```text
R_ref = I;
W_CKM = r_b(15 R_CKM - M_CKM);
R_CKM = I.
```

In the diagnostic CKM table:

```text
level 0:   W_CKM = 0;
level > 0: W_CKM = 16 r_b.
```

The null-edge endpoint should be stated with the spacetime Wilsonizer visible:

```text
H_ne(U) =
  Gamma_K [
    D_ne^cov(U)
    + W_NE,space(U)
    + W_CKM^ne(U)
    - m0 R_ne(U)
  ].
```

If existing notation compresses terms, use:

```text
D_ne := D_ne^cov + W_NE,space;
W_branch := W_CKM^ne.
```

Do not let this notation hide the fact that spacetime doublers are resolved by
the Wilson/Neuberger part, not by CKM alone.

The free shifted mass is:

```text
mu(n,ell) = 2 r_W n + w_ell - m0,
```

with:

```text
w_0 = 0;
w_ell = 16 r_b for ell > 0.
```

The decisive first-pass mass window is:

```text
0 < m0 < min(2 r_W, 16 r_b).
```

It should prove:

```text
negative shifted mass:
  exactly n = 0 and ell = 0;

positive shifted mass:
  all spacetime doublers n >= 1;
  all CKM-heavy sectors ell > 0.
```

The free margin is:

```text
gamma_free = min(m0, 2 r_W - m0, 16 r_b - m0).
```

The transported homotopy should be:

```text
H_ref^S(U,q) = S(q,U) H_ref(U,q) S(q,U)^-1;
H_t(U,q) = (1 - t) H_ref^S(U,q) + t H_ne(U,q).
```

The central error budget is:

```text
||H_ne - H_ref^S|| <= kappa + omega + rho + alpha + beta < gamma_free.
```

Use the constants as follows:

```text
kappa:
  kinetic / Dirac-symbol / Wilsonized-spacetime mismatch.

omega:
  CKM/flavored-mass mismatch.

rho:
  R and m0 shift mismatch.

alpha:
  admissible gauge-background perturbation.

beta:
  branch-frame, tetrad, soldering, or transport-frame mismatch.
```

First theorem simplifications:

```text
omega = 0 by using the same CKM table on both sides;
rho = 0 by taking R_ref = R_ne = I;
alpha = 0 in the free theory U = 1;
beta = 0 in the flat/free branch frame;
kappa is the main hard constant.
```

If the straight-line inequality fails, retune in this order:

```text
1. Keep omega = 0 by exact CKM transport.
2. Keep rho = 0 by first proving the R = I theorem.
3. Choose m0 near the middle of the allowed mass window.
4. Increase r_b so the CKM-heavy gap is not limiting.
5. Use a multi-stage homotopy:
   H_Wilson+CKM -> H_abs.block -> H_ne.
6. Shrink the admissible gauge-field ball to reduce alpha.
7. Improve the branch-frame transport to reduce beta.
8. If kappa remains large, choose a reference closer to the actual null-edge
   Wilsonized kinetic.
```

The sector-signature map must include:

```text
rank;
chirality;
branch parity;
gauge representation;
shifted-mass sign;
Krein sign;
index/anomaly weight.
```

Any mismatch blocks the reference import.

The updated close stack is:

```text
C170 CKM-decorated Wilson reference mass window;
C171 sector-signature match;
C172 gapped homotopy from H_ref^S to H_ne;
C173 overlap sign and Ginsparg-Wilson algebra;
C174 overlap light/heavy sector and true bad-sector inverse gap;
C175 branch-line projector lift;
C176 SMActsInternally or exact gauge dressing;
C177 no propagator-zero mirror removal;
C178 Krein/Hilbertization audit;
C179 anomaly/index import;
C180 non-ultralocal control certificate;
C181 GateC1_NU assembly theorem.
```

Claim boundary:

```text
GateC1_NU closes only if the null-edge endpoint is shown to be in the same
gapped sector-signature class as the Wilson/Neuberger+CKM reference.

It is not enough to say the reference works.
The null-edge homotopy and sector-signature match are the physical import data.
```

## 52. Integrated Aristotle update: C225-C227 local API spine

Date: 2026-06-28
Source: completed Aristotle jobs C225-C227.

C225 audited the four promoted Draft leaves and found a real local hygiene
blocker:

```text
The promoted files began with a module docstring before import Mathlib.
Lean treats /-! ... -/ as a command, so import was not first.
```

Applied local fix:

```text
Convert only the leading provenance /-! to a plain /- comment in:
  CKMWilsonWindow.lean;
  GappedHomotopy.lean;
  SignStability.lean;
  ProjectorPersistence.lean.
```

No theorem statement or proof was intentionally changed by this fix.

C225's main integration warning:

```text
Do not use blanket open GateC1 / open NullEdgeGateC1 in aggregators.
Unify or wrap the duplicate gamma_free/gammaFree definitions before using them
together, because their argument orders differ.
```

C226 supplied the first local projector/chiral-index bridge core. Added to
`ProjectorPersistence.lean`:

```text
chiralIndex_zero_of_rank_balanced;
chiralIndex_zero_of_trace_zero.
```

These are obstruction lemmas, not release lemmas:

```text
chirality-balanced branch kernel => chiral index zero.
```

C226's recommended future bridge theorem is:

```text
branchKernel_chiralIndex_zero:
  any idempotent projector onto ker(cliffordSymbol(branchP a)) that commutes
  with gamma5 has chiralIndex gamma5 P = 0.
```

This theorem must live in a bridge module importing both the C21 actual
Clifford-symbol conventions and the GateC1 projector vocabulary. Missing local
ingredients include:

```text
gamma5_anticommutes_cliffordSymbol;
branchKernel_rank_two;
branchKernelProjector and its idempotency/range/commutation lemmas;
branchKernel_chiralParts_rank_one or branchKernel_chiralTrace_zero.
```

C227 supplied a new Draft API module:

```text
PhysicsSM/Draft/NullEdge/GateC1/OperatorFreeze.lean
```

It defines the operator-freeze interface:

```text
FrozenOverlap:
  H_ref, H_ne, S, Sinv, gammaFree, hRefGapped.

BudgetDecomposition:
  Dkappa, Domega, Drho, Dalpha, Dbeta;
  constants kappa, omega, rho, alpha, beta;
  total = kappa + omega + rho + alpha + beta.
```

The central API theorem is:

```text
frozen_gappedHomotopic_of_budget:
  total < gammaFree
  -> GappedHomotopic H_ref (transport S Sinv H_ne).
```

The first-pass theorem is:

```text
frozen_firstPass:
  omega = rho = alpha = beta = 0;
  kappa < gammaFree;
  -> transported H_ne is gapped-homotopic to H_ref.
```

C227 also added explicit no-overclaim guardrails:

```text
ckm_cannot_lift_spacetime_doublers;
wilson_lifts_spacetime_doublers;
budget_cannot_manufacture_gap.
```

Status boundary:

```text
The C225-C227 changes have been integrated as Draft/local documentation and
Draft Lean code.
No local Lean checks were run in this live repo during this integration.
Aristotle reported standalone checks in its focused projects, but those are not
the same as live-repo verification.
No trusted code was promoted.
No full GateC1_NU claim is made.
```

Updated immediate local proof queue:

```text
1. Check the promoted leaves plus OperatorFreeze when verification is requested.
2. Add an import-only GateC1 aggregator only after those leaves compile.
3. Build the C226 bridge:
   branchKernel_chiralIndex_zero.
4. Instantiate FrozenOverlap with the authoritative H_ref/H_ne and discharge
   the first-pass zero clauses plus kappa < gammaFree.
```

## 53. Integrated Aristotle update: C228-C230 source, island, and analogy audits

Date: 2026-06-28
Source: completed Aristotle jobs C228-C230.

C228 supplied the source-contract map for the Wilson/Neuberger+CKM reference
import. Its main enforced boundaries are:

```text
CKM/flavored mass terms support internal branch/flavor splitting.
They do not prove spacetime doubler resolution for the null-edge endpoint.

Ginsparg-Wilson algebra does not prove determinant-line or gauge-measure
control.

Hernandez-Jansen-Luscher locality is conditional on smooth/admissible gauge
fields.

Adams anomaly/index support applies to the overlap reference in the physical
mass window; importing it to H_ne requires gapped homotopy and sector-signature
match.

Golterman-Shamir forbids mirror removal by propagator zeros.
```

The theorem tiers should remain:

```text
GateC1_NU_Free:
  free reference no-doubling/window, gapped homotopy, sector-signature match,
  true bad-sector inverse gap, no propagator-zero mirror removal.

GateC1_NU_BackgroundGauge:
  add gauge/admissibility hypotheses, covariance/dressing, and controlled
  locality or non-ultralocal certificate.

GateC1_NU_Quantum:
  add determinant-line control, anomaly cancellation/accounting, and regulator
  stability.
```

C228's recommended next API after `OperatorFreeze` is:

```text
GappedReferenceImportCertificate:
  reference source contract;
  sector-signature match;
  gapped homotopy H_ne ~ H_ref;
  source-specific side conditions.
```

C229 supplied the spectral-island/projector-persistence plan connecting C202 to
C175. It separates four obligations:

```text
O1 finite spectral-island persistence;
O2 Riesz projection existence/stability;
O3 Davis-Kahan quantitative subspace-rotation bound;
O4 branch-line chiral-index persistence.
```

Finite-first work:

```text
projector conjugation invariance;
trace-cyclicity;
integrality of chiral index;
integer-continuity / locally constant index on connected intervals.
```

Analytic/source-contract work:

```text
Kato/Riesz projector construction and continuity for isolated spectral
islands;
Davis-Kahan bounds for quantitative projector rotation;
homotopy survival of the target spectral island.
```

C229 found an important API warning:

```text
An IsRieszProjector fingerprint of "idempotent + commuting + equal rank" is
underdetermined. It does not prove uniqueness.
```

Therefore the future Riesz/projector API must include a real spectral/range
condition, not just rank and commutation data.

C230 audited Watterson's Dirac-Kahler chiral/flavour projection paper. Decision:

```text
PARK as analogy only.
```

Useful lesson:

```text
simultaneous chiral/flavour projection requires projector-commutation and
dual-complex bookkeeping care.
```

No-overclaim boundary:

```text
Dirac-Kahler projection does not supply the null-edge operator, does not replace
Wilson/Neuberger spacetime doubler resolution, does not provide a true
bad-sector inverse gap, and does not prove anomaly/determinant/Krein safety.
```

Status boundary:

```text
C228-C230 outputs are integrated as planning/source-contract guidance.
No C228-C230 Lean artifacts were promoted into the live repo in this pass.
No local Lean checks were run.
```

## 54. Integrated Aristotle update: C231 and C233

Date: 2026-06-28
Source: completed Aristotle jobs C231 and C233.

C231 audited the live `OperatorFreeze` Draft port. It found:

```text
The dependency set is right:
  OperatorFreeze uses CKMWilsonWindow, GappedHomotopy, and SignStability.

OperatorFreeze correctly does not depend on ProjectorPersistence.

Namespace risk is low:
  new declarations live under GateC1.OperatorFreeze.
```

Remaining live-port caveat:

```text
The focused package could only validate flat module imports.
The live repo imports
  PhysicsSM.Draft.NullEdge.GateC1.*
are plausible but still unverified in this live checkout because no local Lean
check was run.
```

C231 also found and we applied a local parse fix:

```text
The stale doc comment immediately before chiralIndex_zero_of_rank_balanced in
ProjectorPersistence was demoted to a plain comment.
```

Aggregator rule remains:

```text
Do not add an import-only GateC1 aggregator until the Draft leaves and
OperatorFreeze pass live checks.
```

C233 strengthened the Riesz/spectral-projector API. Main result:

```text
The weak fingerprint
  idempotent + commuting + equal rank
is not enough.
```

Replacement principle:

```text
An idempotent spectral projector should be pinned by range and kernel:
  range = generalized-eigenspace sum over the target spectral set;
  kernel = generalized-eigenspace sum over the complement.
```

Finite-first theorem to formalize:

```text
eq_of_isIdempotent_range_ker:
  idempotent linear maps with equal range and equal kernel are equal.
```

Future API names should avoid colliding with C227's `OperatorFreeze` namespace.
C233's standalone artifact used a theorem name overlapping the existing
`GateC1.OperatorFreeze.frozen_gappedHomotopic_of_budget`, so it was not promoted
as live code in this pass. Treat it as a design source for a future module such
as:

```text
PhysicsSM/Draft/NullEdge/GateC1/SpectralProjectorAPI.lean
```

Status boundary:

```text
C231 contributed one local Draft parse fix.
C233 was integrated as design guidance only.
No local Lean checks were run.
No trusted code was promoted.
```

## 55. Integrated Aristotle update: C232 and C234

Date: 2026-06-28
Source: completed Aristotle jobs C232 and C234.

C232 supplied a generic branch-kernel zero-index theorem. Local Draft module
added:

```text
PhysicsSM/Draft/NullEdge/GateC1/BranchKernelChiralIndexZero.lean
```

The useful theorem is:

```text
nullBranch_chiralIndex_zero:
  for any nonzero null covector p, any idempotent P commuting with gamma5 whose
  range is ker(cliffordSymbol p) has chiralIndex gamma5 P = 0.
```

Interpretation:

```text
This is an obstruction theorem.
It proves the chirality-balanced branch-kernel result in the GateC1
projector/chiral-index vocabulary.
It is not a Weyl release theorem.
```

The full branch-specific theorem:

```text
branchKernel_chiralIndex_zero
```

needs only the geometry layer to provide:

```text
branchP_ne_zero;
branchP_mink_zero.
```

Current live evidence shows the relevant geometry file is:

```text
PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean
```

C235 has been submitted with that live dependency included, so it should be the
next integration point for the actual `branchP` specialization.

C234 supplied the live-safe spectral projector API. Local Draft module added:

```text
PhysicsSM/Draft/NullEdge/GateC1/SpectralProjectorAPI.lean
```

It uses:

```text
namespace GateC1.SpectralProjectorAPI
```

and avoids defining anything under:

```text
GateC1.OperatorFreeze
```

Core declarations:

```text
eq_of_isIdempotent_range_ker;
IsWeakRieszFingerprint;
weak_fingerprint_not_unique;
IsSpectralProjector;
IsSpectralProjector.unique;
KatoSourceContract;
DavisKahanSourceContract;
frozen_proj_eq_of_budget.
```

Claim boundary:

```text
SpectralProjectorAPI supplies range/kernel uniqueness and analytic source
contracts.
It does not prove spacetime no-doubling, chiral polarization, anomaly,
determinant-line control, Krein positivity, gauge safety, ghost safety, or full
GateC1_NU.
```

Status boundary:

```text
C232 and C234 Lean artifacts were copied as Draft modules.
No local Lean checks were run in the live repo.
No trusted code was promoted.
```

## 56. Pro architecture update: Null-Edge Overlap as the primary C1 operator

Date: 2026-06-28
Source: Pro analysis in
`C:\Users\Owner\.codex\attachments\5230e00c-8f61-493e-b9e2-b467d63d70a6\pasted-text.txt`.

This update sharpens the operator choice:

```text
null-edge finite kernel
  -> gamma5-Hermitian Wilson/flavored-Wilson Hermitian kernel H_ne
  -> Neuberger overlap sign operator sign(H_ne)
  -> Ginsparg-Wilson chiral projectors
  -> Weyl determinant / anomaly-free multiplet construction
```

Equivalently, the same architecture can be implemented as a domain-wall fermion
whose four-dimensional kernel is null-edge-derived. The fifth/domain-wall
direction should be treated as the spectral-flow/sign-function engine, not as a
physical null direction in the first pass.

The architectural correction is:

```text
The null-edge seed supplies the local/path-combinatorial kernel and
branch-mass geometry.

The overlap sign function supplies the chiral release.
```

Therefore:

```text
Do not try to make the finite retarded seed itself be the C1 release operator.
Treat it as a kernel, deformation, or path-combinatorial input to an
index-carrying overlap/Ginsparg-Wilson/domain-wall construction.
```

### 56.1 Candidate operator

Let `S_+` be a finite set of oriented null-edge steps, with reverse steps
included by adjoint shifts. Let `T_ell(U)` be the gauge-covariant shift along
the null edge `ell`.

The first-pass kernel should be a symmetrized, gamma5-Hermitian null-edge naive
kernel:

```text
D_ne^0 =
  (1 / 2a) sum_{ell in S_+}
    c_ell Gamma_ell (T_ell - T_ell^dagger),
```

with soldering matrices chosen so that, near the desired branch,

```text
D_ne^0(p) = i gamma^mu p_mu + O(a |p|^2)
```

after the chosen Euclidean or Hamiltonian continuation.

Add a Wilson/species-splitting mass:

```text
W_ne =
  (r / a) sum_{ell in S_+} b_ell (2 - T_ell - T_ell^dagger)
  + W_flav.
```

Use `W_flav = 0` only if the scalar Wilson mass separates the actual null-edge
branches. If not, move to a flavored or matrix-valued Wilson mass.

Define:

```text
A_ne = D_ne^0 + W_ne - rho/a,
H_ne = gamma5 A_ne,
D_ov,ne = (rho/a) (1 + gamma5 sign(H_ne)).
```

The physical Weyl theory is then built with Ginsparg-Wilson projectors:

```text
gamma5_hat = gamma5 (1 - (a/rho) D_ov,ne),
P_hat_pm = (1 +/- gamma5_hat) / 2,
P_pm = (1 +/- gamma5) / 2.
```

A left-handed field is selected by a Ginsparg-Wilson constraint such as:

```text
P_hat_minus psi = psi,
bar_psi P_plus = bar_psi.
```

Do not state this as "the finite seed literally contains only one Weyl pole."
The lattice chiral theory is a Ginsparg-Wilson Dirac operator plus chiral
projected determinant/measure data.

### 56.2 How null-edge data enters

The null-edge structure should enter inside the Hermitian overlap kernel:

```text
covariant shift graph:
  elementary hops in D_ne^0 and W_ne are allowed null edges.

soldering data:
  Gamma_ell reconstructs the continuum Clifford/tetrad structure.

Wilson/species mass map:
  W_ne(p) - rho/a is negative on the desired physical branch and positive on
  mirror/doubler branches, up to convention.

overlap sign argument:
  H_ne = gamma5(D_ne^0 + W_ne - rho/a) carries the sign/index structure.

path-sum kernel:
  sign(H_ne), rational approximants, Chebyshev approximants, or domain-wall
  transfer matrices expand into sums over allowed null-edge paths.
```

This reconciles the Feynman-checkerboard intuition with the known lattice
chiral-fermion machinery: the primitive kernel is null-edge/path-combinatorial,
while the chiral release is the overlap sign/domain-wall boundary mechanism.

### 56.3 Branch-mass diagnostic

If `D_ne^0(p)` has branch zeros `p_j` with local chiral/topological charges
`chi_j`, define:

```text
m_j = W_ne(p_j) - rho/a.
```

Then the overlap index is controlled by the selected negative-mass branches:

```text
index ~ sum_{j : m_j < 0} chi_j,
```

up to sign convention and source-contract hypotheses.

This changes how to interpret scalar Wilson terms:

```text
Scalar Wilson is not enough as a direct chirality polarizer.
Scalar Wilson may be enough inside an overlap kernel if it gives the right
branch-mass sign pattern.
```

If the scalar branch-mass function cannot separate the actual null-edge branch
structure, the next candidate is a flavored or matrix-valued Wilson term.

### 56.4 Assumptions to discard or relax

Discard:

```text
finite seed as complete release operator;
retardedness as a C1 proof;
scalar Wilson lift as direct mirror removal;
CKM/flavor as spacetime doubler removal;
requiring the first successful C1 operator to be native and novel.
```

Relax:

```text
ultralocality and exact finite range;
strict translation invariance beyond the free-symbol theorem.
```

Postpone:

```text
deriving tetrad/null-frame data from a bare graph.
```

For the C1 theorem, retardedness belongs later at the Green-function or
Lorentzian reconstruction layer. The overlap sign theorem wants a Hermitian
kernel.

### 56.5 Revised theorem ladder

The immediate theorem stack should be:

```text
T0 C1-compatible null-edge kernel:
  prove gamma5-Hermiticity, Hermiticity of H_ne, and gauge covariance.

T1 free continuum and branch classification:
  compute D_ne^0(p), classify branch zeros p_j, local charges chi_j, and branch
  masses m_j.

T2 branch mass window:
  prove a rho/r/W_flav window with the desired branch negative and all mirror
  branches positive.

T3 free overlap gap and no mirror pole:
  prove H_ne(p)^2 >= g^2 > 0 away from controlled topological-sector
  boundaries, and show mirror branches have true inverse-propagator gaps.

T4 Ginsparg-Wilson and index theorem:
  prove the GW relation and the overlap index formula for D_ov,ne.

T5 gapped homotopy to a reference overlap kernel:
  prove H_t = (1-t)H_ref + tH_ne remains gapped for all t, or use the stronger
  sufficient norm bound ||H_ne - H_ref|| < gap(H_ref).

T6 gauge admissibility and locality/control:
  prove the gap and controlled non-ultralocality under admissible gauge
  backgrounds.

T7 Weyl determinant and anomaly compatibility:
  define the anomaly-free Standard Model chiral multiplet using GW projectors
  and a controlled determinant-line/measure construction.

T8 domain-wall equivalence:
  prove the null-edge domain-wall boundary operator tends to D_ov,ne as the
  wall length goes to infinity.

T9 null-edge path-sum representation:
  show sign(H_ne) or its approximants are controlled sums over allowed
  null-edge paths.
```

### 56.6 Revised C1 success criterion

The target success criterion is now:

```text
There exists a gauge-covariant, gamma5-Hermitian, null-edge-derived Hermitian
kernel H_ne = gamma5(D_ne^0 + W_ne - rho/a) such that:

1. H_ne is finite-range at the kernel level on the null-edge graph, or has a
   controlled local/path-sum structure.
2. The free symbol has the desired continuum branch and an explicitly
   classified set of mirror/doubler branches.
3. The Wilson/flavored-Wilson branch mass has the correct sign pattern.
4. H_ne has a stable spectral gap as the overlap sign argument.
5. D_ov,ne = (rho/a)(1 + gamma5 sign(H_ne)) satisfies the GW relation.
6. The physical Weyl theory is defined with GW/Luscher chiral projectors.
7. Mirror branches are removed by inverse-propagator gaps, not propagator zeros.
8. The operator is exponentially local or has a controlled non-ultralocal
   path-sum/resolvent/domain-wall decay law.
9. H_ne is gapped-homotopic to a known safe reference, or its index is computed
   directly.
10. In admissible gauge sectors, anomaly/index/measure data match the intended
    anomaly-free Standard Model multiplet.
11. Turning off the null-edge deformation returns a standard Wilson/overlap or
    domain-wall reference theory.
```

Status boundary:

```text
This is a sharpened architecture, not a solved theorem.
The next proof-critical object is the explicit H_ne branch-mass window and
overlap gap.
No full GateC1_NU claim is made until the overlap index, no-ghost gap, and
source-contract audits are discharged.
```

## 57. Higher-context Pro update: Hermitianization and reference-import API

Date: 2026-06-28
Source: Pro analysis in
`C:\Users\Owner\.codex\attachments\42a823cf-1c8c-4337-a9e8-59cc85d1e72a\pasted-text.txt`.

This response confirms the Null-Edge Overlap architecture, but adds several
important implementation guardrails.

### 57.1 Do not feed raw retarded `D_+` to the overlap sign function

If the primitive null-edge seed is genuinely retarded or non-Hermitian, it is
not automatically a valid overlap kernel. The sign construction wants a
Hermitian, gamma-Hermitian, normal, or otherwise Hilbertized kernel.

Therefore the first C1 operator must use one of:

```text
Option A:
  build a symmetric / Euclideanized / gamma-Hermitian null-edge kernel first.

Option B:
  form a Hermitian retarded/advanced dilation:

    H_RA =
      [ 0                         D_+ + W - m0 R ]
      [ (D_+ + W - m0 R)^dagger   0             ].

  Then use sign(H_RA).
```

The retarded path interpretation should return at the propagator, resolvent,
domain-wall, or path-sum level. It should not be smuggled into an un-Hermitian
object and then passed directly to an overlap sign function.

### 57.2 Refined endpoint operator

Use the null-edge Wilson-overlap endpoint:

```text
D_ov,NE(U) = rho [ 1 + Gamma_NE sign(H_NE(U)) ],
```

with:

```text
H_NE(U) =
  Gamma_NE [
    D_NE,sym^cov(U)
    + W_NE,space(U)
    + W_NE,int(U)
    - m0 R_NE
  ].
```

Interpretation of the terms:

```text
D_NE,sym^cov:
  null-edge covariant Dirac-like kinetic kernel.

W_NE,space:
  spacetime doubler-resolving Wilson/Laplacian term.

W_NE,int:
  internal branch/flavor/CKM texture, if needed.

Gamma_NE:
  audited lattice chirality, or Krein/Hilbertized chirality.

R_NE:
  positive sector metric/normalizer.
```

First theorem simplification:

```text
R_NE = I;
W_NE,int = 0;
Gamma_NE = S gamma5 S^-1;
free theory U = 1.
```

Then add internal texture only after the base null-edge/Wilson bridge works:

```text
W_NE,int = S (I tensor W_CKM) S^-1 + controlled error.
```

Do not allow arbitrary `R_NE` in the first theorem. If `R_NE` is nontrivial, the
mass-window theorem becomes a generalized eigenvalue problem:

```text
W_NE,int v = m0 R_NE v.
```

That belongs in a later theorem.

### 57.3 Reference import rather than reinvention

The reference should remain:

```text
H_ref(U) =
  gamma5 [
    D_Wilson(U) tensor I_int
    + I tensor W_int
    - m0 I
  ].
```

The core proof is not that the null-edge operator is merely similar in prose to
the reference. It is:

```text
H_NE ~=_gapped H_ref
```

via a transported homotopy:

```text
H_ref^S(U) = S H_ref(U) S^-1;
H_t(U) = (1 - t) H_ref^S(U) + t H_NE(U);
sigma_min(H_t) >= delta > 0.
```

A sufficient first condition is:

```text
||H_NE - H_ref^S|| < gap(H_ref).
```

The refined budget names are:

```text
kappa:
  kinetic/null-edge-versus-Wilson mismatch.

omega:
  internal/CKM mass-table mismatch.

rho_R:
  R and m0-shift mismatch.

alpha:
  gauge/admissibility perturbation.

beta:
  branch-frame/tetrad/soldering mismatch.
```

First-pass target:

```text
omega = 0;
rho_R = 0;
beta = 0 in the flat branch frame;
alpha = 0 in the free theory;
kappa < gamma_ref.
```

If the direct straight-line inequality fails, do not abandon the route. Insert
a two-step bridge:

```text
H_ref -> H_block -> H_NE,
```

where `H_block` is an abstract block reference with the null-edge sector table
and a deliberately large gap. Then prove two smaller gapped homotopies.

### 57.4 Formal versus physical targets

Keep three labels distinct:

```text
GateC1_local:
  local or quasi-local conventional release.

GateC1_NU:
  controlled non-ultralocal release.

GateC1_formal:
  algebraic toy or projector-only result, not a physical release.
```

`GateC1_formal` must not close C1. It may provide APIs, obstruction theorems,
or sanity checks only.

### 57.5 First theorem to prioritize

The highest-value theorem is now:

```text
NullEdgeOverlapReferenceImport:
  H_ref has a known overlap mass window and gap;
  H_NE is Hermitian or Hilbertized Hermitian;
  H_NE is transported to the same Hilbert space as H_ref;
  ||H_NE - S H_ref S^-1|| <= epsilon < gap(H_ref);
  therefore H_t remains uniformly gapped;
  sign(H_NE) is well-defined;
  the overlap index/sector signature of H_NE equals that of H_ref.
```

This theorem should not itself pretend to finish quantum C1. It should assemble
only the free/background operator import. The physical `GateC1_NU` assembly also
requires:

```text
GW algebra;
physical Weyl branch;
true bad-sector inverse gap;
no propagator-zero mirror removal;
gauge covariance or dressing;
Krein/Hilbert positivity;
anomaly and determinant-line accounting;
non-ultralocal/path-sum control;
regulator stability.
```

### 57.6 Updated local work order

Use this order for the next local/Aristotle rounds:

```text
1. Claim-boundary API:
   GateC1_local, GateC1_NU, GateC1_formal.

2. Wilson/overlap reference mass window.

3. Null-edge Hermitian or RA-dilated kernel definition.

4. Null-edge-to-Wilson free symbol/sector match.

5. Gapped homotopy stability / reference import.

6. Sign-function and Ginsparg-Wilson import.

7. Branch-line spectral lift.

8. Bad-sector inverse gap and no-ghost theorem.

9. Standard Model gauge-internality/dressing.

10. Path-sum/resolvent/domain-wall control.

11. Anomaly/determinant-line source contract.

12. Null-Edge Overlap release assembly.
```

Status boundary:

```text
This update further narrows the operator target.
It still does not define the actual project H_NE or prove the kappa/gap bound.
The raw retarded operator remains a seed/path object, not the sign-kernel.
```

## 58. Integrated Aristotle update: C238 Null-Edge Overlap strategy audit

Date: 2026-06-28
Source: completed Aristotle job C238.

C238 confirms that the proposed kernel has the right first serious Gate C1
shape:

```text
H_ne = gamma5 [D_ne^0 + W_ne + M_br - rho/a].
```

But it makes the load-bearing order sharper:

```text
1. H_ne is genuinely self-adjoint on a named Hilbert structure.
2. H_ne has a true spectral gap at zero, so sign(H_ne) exists.
3. D_ov,ne is then derived and checked against Ginsparg-Wilson algebra.
```

Do not introduce:

```text
D_ov,ne = (rho/a)(1 + gamma5 sign(H_ne))
```

as a physical release milestone until the first two clauses are either proved
or carried as explicit hypotheses.

C238's theorem ladder:

```text
T1 gamma5-Hermiticity / self-adjointness:
  centered null-edge kernel is a valid Hermitian sign kernel.

T2 tetrahedral free-field doubler and spectral-gap test:
  actual Brillouin-zone geometry decides whether scalar Wilson lifts all
  unwanted branches.

T3 sign plus Ginsparg-Wilson algebra:
  mostly algebra once T1 and the gap hypothesis hold.
```

The main risk is no longer "is the formula plausible?" It is:

```text
Does the tetrahedral shift Brillouin zone have exactly the branch structure we
think it has, and does scalar W_ne produce a real gap?
```

C238 ranks the traps:

```text
1. tetrahedral Brillouin-zone geometry;
2. chirality and gamma5 convention consistency;
3. Krein versus Hilbert self-adjointness on the retarded/dilation track;
4. gauge-covariant shift adjointness under general U;
5. spectral gap and sign well-definedness;
6. anomaly/source contract;
7. path-sum convergence.
```

Reuse priority:

```text
SpectralProjectorAPI:
  highest priority for sign/projector identities.

SignStability:
  sign stability under perturbations once a gap exists.

OperatorFreeze:
  parameter-window and budget language.

ProjectorPersistence and GappedHomotopy:
  persistence and homotopy support.

BranchKernelChiralIndexZero:
  negative control showing what the bare balanced branch cannot do.

CKMWilsonWindow:
  useful as a mass-window template only; keep CKM quarantined from spacetime
  doubler resolution.
```

Updated work queue:

```text
1. Prove the abstract Hermitian-kernel theorem.
2. Prove conditional sign/GW algebra under sign(H)^2 = 1.
3. Prove or refute the tetrahedral branch/gap claim.
4. Add M_br only if scalar Wilson leaves a residual light branch.
5. Keep the retarded/advanced dilation as a separate path-sum bridge, not as
   the first overlap kernel.
6. Wrap the result with SignStability/OperatorFreeze only after T1-T3.
```

Status boundary:

```text
C238 is strategy/audit integration only.
No live Lean verification was performed.
No GateC1_NU theorem is claimed.
```

## 64. Integrated Aristotle update: C240 tetrahedral branch window

Date: 2026-06-28
Source: completed Aristotle job C240.

C240 formalized the finite/free tetrahedral branch-window calculation behind
the first Null-Edge Overlap kernel. The returned Draft module has been copied
into:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetrahedralBranchWindow.lean
```

Main finite results:

```text
tetrahedral_B_sum:
  sum_A B_A = gamma4.

tetrahedral_B_weighted_sum:
  sum_A v_A^j B_A = gamma_j.

vTetra_sum_zero / vTetra_moment:
  the explicit normalized tetrahedron realizes the needed moments.

tetra_homogeneous_injective:
  the homogeneous tetrahedral rows (1, v_A) are linearly independent.

B_sin_branch_inference:
  sum_A B_A sin(k_A) = 0 forces sin(k_A) = 0 for every A,
  in the finite coefficient model.

branchMass_from_wilson:
  at a branch with n pi-coordinates,
  m_n = (2 r n - rho) / a.

branch_mass_negative_origin / branch_mass_positive_doublers:
  if a > 0 and 0 < rho < 2r, then m_0 < 0 and m_n > 0 for n = 1..4.
```

The important caveat is explicit:

```text
The 16-branch count assumes the four k_A are independent 2*pi-periodic angle
coordinates on the null-edge Brillouin torus.
```

This is not a minor bookkeeping issue. It is now the next theorem target:

```text
Lambda = span_Z {n_A};
k_A(p) = n_A dot p;
prove that p -> (k_A(p)) descends to an isomorphism between the relevant
Brillouin torus and (R / 2*pi Z)^4.
```

Program interpretation:

```text
Scalar Wilson is still not a direct chirality selector on the balanced origin
kernel.

But scalar Wilson may be sufficient as the branch-mass term inside the
Hermitian overlap sign kernel.
```

This resolves a previous confusion:

```text
old no-go:
  D_+ + scalar Wilson cannot directly release one Weyl line from the balanced
  bare kernel.

C240 role:
  scalar Wilson supplies the Wilson-overlap branch-mass sign table; the overlap
  sign/Ginsparg-Wilson machinery supplies the chiral projectors.
```

Updated near-term proof pressure:

```text
1. Prove the lattice-duality / Brillouin-torus theorem.
2. Prove the global free no-zero/gap theorem for the scalar Wilson window.
3. Assemble sign(H_ne), D_ov,ne, and the GW projector algebra.
4. Prove a true bad-sector inverse gap and no propagator-zero mirror removal.
5. Only then add gauge covariance, path-sum control, Krein positivity,
   anomaly, and determinant-line source contracts.
```

Status boundary:

```text
C240 is finite/free and Draft-only.
No live repo Lean check was run during integration.
No trusted code was promoted.
No GateC1_NU theorem is claimed.
```

## 59. Integrated Aristotle update: C235 actual branch-kernel zero-index proof

Date: 2026-06-28
Source: completed Aristotle job C235.

C235 proves the actual branch-kernel obstruction in the live C21 Clifford-symbol
vocabulary. The returned module has been integrated as:

```text
PhysicsSM/Draft/NullEdge/GateC1/BranchKernelActualChiralIndexZero.lean
```

It is kept separate from the earlier generic
`BranchKernelChiralIndexZero.lean` scaffold so that both layers remain
available:

```text
BranchKernelChiralIndexZero.lean:
  generic obstruction / scaffold layer.

BranchKernelActualChiralIndexZero.lean:
  actual `branchP a` and `cliffordSymbol` specialization from C235.
```

C235's main theorem:

```text
branchKernel_chiralIndex_zero (a : Fin 4) (P : CMat4)
  (hP   : IsIdempotentElem P)
  (hcom : Commute gamma5 P)
  (hran : forall v : Spin -> Complex,
      P *v v = v <-> cliffordSymbol (branchP a) *v v = 0) :
  GateC1.chiralIndex gamma5 P = 0.
```

The proof route:

```text
1. Use the C226 obstruction lemma `chiralIndex_zero_of_trace_zero`.
2. Reduce to `trace (gamma5 * P) = 0`.
3. Use `Commute gamma5 P` to make `P` block diagonal in the Weyl split.
4. Use the fixed-space/kernel hypothesis to identify the two Weyl block fixed
   spaces with the kernels of the two 2 x 2 Clifford-symbol blocks.
5. Use the actual null branch condition to prove each Weyl block has rank one.
6. Conclude equal chiral block traces and therefore zero chiral index.
```

Returned helper lemmas include:

```text
gamma5_involution;
blockA_rank_one;
blockB_rank_one;
toBlocks_offdiag_zero;
block_diag_of_commute;
trace_gamma5_mul;
idem_rank_add_rank_eq_card;
toBlocks11_idem / toBlocks22_idem;
toBlocks11_fixed_iff / toBlocks22_fixed_iff;
branchKernel_chiralTrace_zero.
```

Interpretation:

```text
This is an obstruction theorem.
It proves that any chirality-commuting projector onto the bare branch kernel has
zero chiral index.
```

It does not provide:

```text
a chiral release;
a physical Weyl projector;
a bad-sector inverse gap;
Krein positivity;
gauge/anomaly/determinant-line closure.
```

Program impact:

```text
The bare branch kernel is now even more definitively classified as the wrong
object for release. The new Null-Edge Overlap kernel must escape this theorem by
using the Hermitian Wilson/sign mechanism and GW projectors, not by selecting a
chirality-commuting projector onto the bare branch kernel.
```

Status boundary:

```text
Aristotle reported the focused package built with no proof placeholders and
standard axioms only.
No local live-repo Lean check was run during integration.
No trusted code was promoted.
No GateC1_NU theorem is claimed.
```

## 63. Integrated Aristotle update: C241 scalar Wilson versus branch mass

Date: 2026-06-28
Source: completed Aristotle job C241.

C241 returned both a decision framework and a Lean formalization of the finite
branch-mass interpolation core. The Lean module has been integrated as:

```text
PhysicsSM/Draft/NullEdge/GateC1/BranchMass.lean
```

Decision:

```text
Start with M_br = 0.
Add M_br only if the actual tetrahedral/null-edge branch test shows scalar
Wilson cannot separate the physical branch from unwanted branches.
```

Scalar Wilson is enough iff:

```text
1. D_ne^0 has the intended branch list;
2. W_ne(physical) is uniquely in the kept mass window;
3. all unwanted branch Wilson values are separated from the kept branch.
```

Scalar Wilson fails if:

```text
D_ne^0(p_j) = 0 = D_ne^0(p_k);
W_ne(p_j) = W_ne(p_k);
one branch must be kept while the other must be lifted.
```

C241 proves the scalar obstruction:

```text
scalar_shift_preserves_degeneracy:
  adding a constant scalar mass shift cannot separate a Wilson-degenerate pair.
```

If scalar Wilson fails on distinct branch points, C241 proves the cos-product
branch mass is expressive enough:

```text
M_br(p) = sum_I c_I prod_{A in I} cos(k_A)
```

Formal core:

```text
Branch n:
  branch points modeled as Fin n -> Bool.

Mono n:
  cos-product monomial indices.

chi:
  Walsh-Hadamard kernel.

walsh:
  coefficient-to-branch-profile synthesis.

walshInv:
  explicit inverse transform.
```

Main finite theorem:

```text
branch_mass_interpolation_four:
  arbitrary branch masses on the 16 branch points are realizable by a unique
  cos-product coefficient vector.
```

This is useful but dangerous:

```text
Full M_br can fit any 16-point branch profile.
Therefore unconstrained M_br is not predictive.
```

Guardrails for M_br:

```text
1. Necessity gate:
   turn it on only after scalar Wilson fails.

2. Minimality / sparsity:
   allow only the lowest-degree or smallest-support monomials needed.

3. Symmetry quotient:
   enforce tetrahedral/null-edge graph automorphism invariance where possible.

4. Prediction ledger:
   every free coefficient counts as added moduli freedom.

5. Gauge caveat:
   the free theorem assumes commuting cos(k_A). The covariant replacement
   C_A = (T_A + T_A^dagger)/2 is noncommuting in gauge backgrounds and needs a
   separate symmetrized-operator theorem.
```

Program impact:

```text
The scalar-vs-matrix Wilson question is now precise.
We should not preemptively use M_br.
We should wait for the tetrahedral branch test, then add the sparsest
gamma5-even Hermitian M_br only if the test requires it.
```

Status boundary:

```text
Aristotle reported the focused C241 file built with no proof placeholders and
standard axioms only.
The live repo copy is Draft-only and has not been locally checked.
No trusted code was promoted.
No GateC1_NU theorem is claimed.
```

## 61. Literature update: overlap reference is safe, tetrahedral branch geometry is decisive

Date: 2026-06-28
Source note:

```text
AgentTasks/null-edge-gate-c1-overlap-kernel-literature-review-2026-06-28.md
```

The focused literature review supports the current split:

```text
Overlap/Ginsparg-Wilson/domain-wall:
  safest chiral-release machinery.

Null-edge/tetrahedral kernel:
  new geometric input whose free branch structure must be proved.
```

Main source roles:

```text
Neuberger 9707022:
  overlap sign construction from Wilson-Dirac negative-mass kernel.

Luescher 9802011:
  Ginsparg-Wilson relation gives exact lattice chiral symmetry and avoids the
  no-go theorem by changing the lattice chirality realization.

Hernandez-Jansen-Luescher 9808010:
  locality is a conditional/admissible-gauge source contract.

Kaplan 9206013:
  domain-wall is the unfolded/topological version of the overlap idea.

Adams 0912.2850 and 1008.2833:
  flavored mass terms are legitimate overlap-kernel tools when scalar branch
  mass is insufficient.

Creutz 0712.1201 and Bedaque-Buchoff-Tiburzi-Walker-Loud 0804.1145:
  non-orthogonal/hyperdiamond-like branch geometry is delicate; enough symmetry
  and minimal doubling can pull against each other.

Golterman-Shamir 2311.12790:
  propagator-zero mirror removal remains forbidden.
```

Program conclusion:

```text
The decisive near-term physics theorem is the tetrahedral free-symbol and
branch-mass theorem.
```

Do not assume:

```text
hypercubic Brillouin-zone structure;
automatic 16-branch classification;
automatic scalar-Wilson sufficiency.
```

Instead prove:

```text
coframe identities for B_A;
actual branch-zero classification for the tetrahedral shift torus;
scalar Wilson mass window, or the precise residual branch that requires M_br.
```

## 62. Integrated Aristotle update: C239 Hermitian-kernel API

Date: 2026-06-28
Source: completed Aristotle job C239.

C239 returned a standalone Lean module proving the abstract Hermitian-kernel
validity theorem for the Null-Edge Overlap route. The returned module has been
integrated into:

```text
PhysicsSM/Draft/NullEdge/GateC1/NullEdgeOverlapKernel.lean
```

It supersedes the earlier hand-written local scaffold with a stronger
star-algebra API:

```text
A:
  abstract real star-algebra.

star:
  adjoint operation.

g:
  gamma5 / chirality operator.

D:
  centered null-edge kinetic term.

E:
  gamma-even Hermitian contribution.

m * 1:
  real mass shift rho/a.
```

Core theorem:

```text
If
  star g = g;
  g * g = 1;
  star D = -D;
  g * D = -(D * g);
  star E = E;
  g * E = E * g;

then
  star (g * (D + E - m * 1)) = g * (D + E - m * 1).
```

Split version:

```text
E = W + M_br
```

with `W` and `M_br` each Hermitian and gamma-even.

Physics-facing theorem:

```text
H_ne_isHermitian:
  H_ne = gamma5 (D_ne^0 + W_ne + M_br - rho/a)
  is Hermitian under the explicit Gate C1 kernel assumptions.
```

Returned intermediate lemmas:

```text
gammaConj_odd;
gammaConj_even;
D_conj_eq;
A_ne_conj_eq;
star_real_smul_one;
real_smul_one_comm.
```

Local addition preserved:

```text
normalized_ginspargWilson_of_involutions:
  if gamma^2 = 1 and epsilon^2 = 1, then
  D = 1 + gamma epsilon satisfies the normalized GW algebra.
```

Interpretation:

```text
T1 from C238 is now represented by Draft Lean code:
  the proposed centered null-edge kernel is a valid Hermitian sign-kernel
  provided the explicit structural assumptions are met.
```

What remains:

```text
T2:
  tetrahedral free-symbol / branch / spectral-gap theorem.

T3:
  full sign(H_ne) construction and GW release theorem after the gap is proved.
```

Status boundary:

```text
Aristotle reported the focused C239 file built with no proof placeholders and
standard axioms only.
The live repo copy is Draft-only and has not been locally checked.
No trusted code was promoted.
No GateC1_NU theorem is claimed.
```

## 60. Integrated Aristotle update: C242 reference-import API

Date: 2026-06-28
Source: completed Aristotle job C242.

C242 designed and returned a Draft Lean API for the central reference-import
move:

```text
H_refS = S H_ref S^-1;
H_t = (1 - t) H_refS + t H_ne;
||H_ne - H_refS|| <= epsilon < gap;
therefore H_t has a uniform surviving gap delta = gap - epsilon.
```

The returned module has been integrated as:

```text
PhysicsSM/Draft/NullEdge/GateC1/NullEdgeOverlapReferenceImport.lean
```

Core API:

```text
GapBound gap A:
  uniform inverse-gap predicate gap * ||x|| <= ||A x||.

NullEdgeOverlapReferenceImport:
  H_ref;
  H_ne;
  norm-preserving transport S;
  transported reference H_refS;
  gap;
  epsilon;
  ref_gapped;
  below_margin;
  margin epsilon < gap;
  source contracts.
```

Core proved theorem shape:

```text
homotopy_lower_bound:
  if A has gap gap and ||B - A|| <= epsilon,
  then every convex interpolation (1 - t)A + tB has gap at least gap - epsilon.

gapped_homotopy:
  applies that theorem to H_refS -> H_ne.
```

This is exactly the mathematical heart of the reference-import path:

```text
below reference margin
  -> no zero crossing along the homotopy
  -> sign sector can be imported, provided the sign-stability contract is
     available.
```

C242 also makes source-contract boundaries explicit. These are represented as
hypotheses, not proved facts:

```text
Neuberger overlap construction;
Ginsparg-Wilson algebra;
Hernandez-Jansen-Luscher locality;
Luscher determinant/measure;
anomaly accounting;
sign-stability / sector-signature invariance.
```

Layering:

```text
GateC1_formal:
  sector equality only.

GateC1_NU_Free:
  sector equality plus Neuberger/GW contracts.

GateC1_NU_BackgroundGauge:
  add locality/admissible-background contract.

GateC1_NU_Quantum:
  add determinant-line/measure and anomaly contracts.
```

Program impact:

```text
The Null-Edge Overlap route now has a clean API split:

1. Prove concrete H_ne is below-margin from H_refS.
2. Use the C242 gapped-homotopy theorem to preserve the sign sector.
3. Import source contracts only at the layer where they are actually needed.
```

Recommended follow-on theorem:

```text
GapBound gap H_ref
  -> GapBound gap (S H_ref S^-1)
```

for norm-preserving transport `S`, so `ref_gapped` can be derived from the
reference kernel instead of assumed on the transported kernel.

Status boundary:

```text
Aristotle reported the focused C242 file built with no proof placeholders and
standard axioms only.
No local live-repo Lean check was run during integration.
No trusted code was promoted.
No GateC1_NU theorem is claimed.
```

## 65. Pro feedback update: rank-4 tetrahedral scalar-Wilson overlap first

Date: 2026-06-28
Source note:

```text
AgentTasks/null-edge-pro-feedback-tetrahedral-scalar-wilson-2026-06-28.md
```

Pro's feedback supports the current first free C1 model:

```text
H_tet(k) = gamma5 [
  (i/a) sum_A B_A sin(k_A)
  + (1/a)(r sum_A(1 - cos k_A) - rho)
].
```

The key model condition is now explicit:

```text
The free null-edge lattice is the rank-4 abelian translation group
Lambda_tet ~= Z^4 generated by e_A = a n_A.

The dual Brillouin torus is Hom(Lambda_tet, U(1)) ~= (R / 2*pi Z)^4,
with independent coordinates k_A defined by T_A -> exp(i k_A).
```

Do not treat this as hidden hypercubic momentum.  The `k_A` are character
coordinates on the rank-4 oblique null-edge translation lattice.

The proof order is now:

```text
1. Prove the tetrahedral rank-4 lattice/BZ model.
2. Prove the Euclidean Clifford/Hilbert sign-kernel convention.
3. Prove the direct tetrahedral branch-zero theorem.
4. Prove the scalar Wilson branch window.
5. Prove the global free gap for H_tet.
6. Derive overlap/Ginsparg-Wilson algebra and corrected projectors.
7. Prove the free no-mirror-pole theorem for D_ov,tet.
8. Use reference import only after the direct free theorem.
```

Critical correction:

```text
H_tet must be gapped at the physical branch.
H_tet(0) = -(rho/a) gamma5 is invertible.
The physical zero belongs to D_ov,tet, not to H_tet.
```

Euclidean boundary:

```text
The overlap sign-kernel theorem uses Euclidean/Hilbert gamma matrices.
Lorentzian null slash singularities belong to the later path/soldering
interpretation, not to the free spectral gap proof.
```

M_br policy:

```text
Keep M_br = 0 for the clean tetrahedral free theorem.
Introduce M_br only if scalar Wilson fails a proved branch/gap test.
If introduced, M_br must be gamma5-even, Hermitian, gauge-covariant,
point-group constrained, and minimal.
```

Status boundary:

```text
This update sharpens the operator target and Aristotle launch sequence.
It does not close GateC1_NU, gauge locality, anomaly, determinant-line, Krein,
or no-ghost audits.
```
## 66. Integrated Aristotle update: C246 post-C240 theorem ladder

Date: 2026-06-28
Source:

```text
AgentTasks/null-edge-c246-next-wave-queue-aristotle-2026-06-28.md
```

C246 confirms the current near-term theorem order:

```text
C244:
  rank-4 lattice-duality / Brillouin-torus theorem.

C247:
  Euclidean Clifford / coframe convention theorem.

C243:
  global free gap theorem for H_tet.

C248:
  sign(H_ne) and Ginsparg-Wilson assembly with corrected projectors.

C249:
  free no-mirror-pole theorem for D_ov,tet.
```

If these pass, the free model can be treated as complete at the
`GateC1_NU_Free` level. Only then should we proceed to:

```text
reference-import cross-check;
BackgroundGauge covariance/admissibility/source-contract layer;
Quantum anomaly/determinant-line layer.
```

Decision discipline:

```text
Scalar Wilson is the default first path.
M_br is a proved-need-only fallback.
```

The single claim-safety sentence is:

```text
C240 makes scalar Wilson viable as an overlap branch-mass input; it does not
make scalar Wilson a direct chiral projector.
```

Stop rules retained by C246:

```text
H_tet must be gapped at k = 0; the physical zero belongs to D_ov,tet.
Lorentzian null slash singularities do not belong in the Euclidean sign-kernel
proof.
Finite-volume pi corners require even lattice lengths if a finite model is
used.
Gauge shifts do not commute away from U = 1.
M_br can fake success if introduced without a specific proved failing branch.
```

Status boundary:

```text
C246 is a planning artifact.
No Lean theorem was changed or promoted.
No GateC1_NU theorem is claimed.
```
## 67. Pro D4 update: envelope, not release lattice

Date: 2026-06-28
Source:

```text
AgentTasks/null-edge-pro-d4-lattice-guidance-2026-06-28.md
```

Pro confirms the D4 lane is real and useful, but not a replacement for the
current Gate C1 lattice.

Current mainline remains:

```text
L_H = span_Z {h_A}
```

with the four tetrahedral null-edge generators and independent tetrahedral
phases `k_A` on `Hom(L_H,U(1))`.

D4 relation:

```text
L_H subset D4,
[D4 : L_H] = 8,
D4 / L_H ~= (Z/2Z)^3.
```

The dual tori satisfy:

```text
T_D4 -> T_LH
```

as an 8-fold cover.  Therefore:

```text
The tetrahedral k_A are complete coordinates on Hom(L_H,U(1)).
They are not complete coordinates on Hom(D4,U(1)).
On D4, the same k_A have 8 possible extensions.
```

Physical warning:

```text
D4 sites with only h_A shifts give 8 disconnected copies of the tetrahedral
operator.

D4 sites with D4 root shifts connect the cosets, but add timelike and spacelike
primitive steps under eta_phys = -x_0^2 + (1/3)(x_1^2+x_2^2+x_3^2).
```

Thus:

```text
Full D4 is not a purely null-edge primitive lattice.
Switching to full D4 changes the C240 branch theorem.
```

Use D4 as:

```text
symmetry envelope;
coset bookkeeping lattice;
triality / Spin(8) / F4 / 24-cell bridge;
later constraint source for M_br if M_br becomes necessary.
```

Do not use D4 as:

```text
current C1 release lattice;
a shortcut around C244/C243;
a way to hide extra sectors;
a way to introduce arbitrary branch-mass texture.
```

D4 theorem lane:

```text
D4-1 inclusion/index/SNF.
D4-2 dual/BZ cover.
D4-3 causal shell classification.
D4-4 disconnected-copy theorem.
D4-5 optional eight-null-vector branch theorem.
D4-6 D4-constrained M_br only if needed.
D4-7 triality/internal-sector audit.
```

Rule:

```text
D4 is an envelope, not the Gate C1 release lattice.
```

## 68. Pro follow-up: C250 D4 correction and same-parity obstruction

Date: 2026-06-28
Sources:

```text
AgentTasks/null-edge-c250-d4-envelope-audit-aristotle-2026-06-28.md
AgentTasks/null-edge-pro-d4-followup-after-c250-2026-06-28.md
```

C250 ran out of budget before producing a formal Lean deliverable, but returned
a useful checkpoint. Pro then checked that checkpoint and confirmed the main
result with one important wording correction.

Confirmed:

```text
L_H subset D4,
[D4 : L_H] = 8,
D4 / L_H ~= (Z/2Z)^3,
L_H^* = (1/4)L_H,
D4^* subset L_H^* with index 8.
```

Important wording correction:

```text
T_D4 -> T_LH is an 8-fold cover/unfolding.

The D4 momentum torus covers the tetrahedral momentum torus.
The tetrahedral torus is the folded quotient of the D4 torus.
```

So the C250 warning survives, but should be stated carefully:

```text
Switching from L_H to D4 does not preserve the C240 branch theorem.
It changes the momentum torus and the primitive shift set.
```

Pro also sharpened the intrinsic lattice characterization:

```text
L_H = {x in Z^4 : Hx = 0 mod 4}
    = {x in Z^4 :
        all coordinates have the same parity,
        and sum_i x_i = 0 mod 4}.
```

The strongest new guardrail is the same-parity obstruction. Define:

```text
L_same =
  {x in Z^4 :
    x_0, x_1, x_2, x_3 all have the same parity}.
```

Then:

```text
L_H subset L_same subset D4,
[L_same : L_H] = 2,
[D4 : L_same] = 4.
```

Under:

```text
q(x) = -x_0^2 + (1/3)(x_1^2 + x_2^2 + x_3^2),
```

any integral null translation lies in `L_same`. Therefore:

```text
Null translations alone cannot connect full D4.
```

Consequences:

```text
D4 sites with only h_A shifts:
  8 disconnected L_H copies.

D4 sites with D4 root shifts:
  connected, but primitive steps include timelike and spacelike hops.

All-eight-future-null body-diagonal model:
  gives L_same, not full D4, and must be treated as a new model.
```

Decision:

```text
Keep L_H as the active Gate C1 lattice.
Use D4 only as an envelope, comparison, quotient, triality/F4/Spin(8), and
possible later M_br-constraint lane.
Do not replace L_H by D4 unless the branch, gap, scalar-Wilson, and no-mirror
proofs are restarted from zero.
```

## 69. Integrated Aristotle update: C244 tetrahedral lattice-duality theorem

Date: 2026-06-28
Source:

```text
AgentTasks/null-edge-c244-tetrahedral-lattice-duality-aristotle-2026-06-28.md
```

C244 returned a completed Draft Lean formalization of the rank-4 tetrahedral
lattice / Brillouin-torus theorem:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetrahedralLatticeDuality.lean
```

Main results reported by Aristotle:

```text
homogeneousTetraMap_eq_zero_imp:
  the homogeneous tetrahedral coordinate map has zero kernel.

homogeneousTetraMap_injective:
  the coordinate map is injective.

NtetMat_det:
  the 4 x 4 homogeneous tetrahedral matrix has determinant -16 over R.

NtetMatZ_det_natAbs:
  the same integer matrix has determinant absolute value 16.

toTorusHom_surjective:
  the character/angle map surjects onto (R / 2*pi Z)^4.

mem_nullEdgeDualLattice:
  the period lattice is exactly the set where each k_A is in 2*pi Z.

tetraTorusEquiv:
  the quotient by this period lattice is additively equivalent to
  Fin 4 -> AddCircle (2*pi).
```

Interpretation:

```text
C244 discharges the C240 caveat that the four k_A are independent
2*pi-periodic Brillouin-torus angles for the active rank-4 tetrahedral
translation lattice.
```

Important boundary:

```text
This is a theorem about the active L_H / Lambda_tet model, not a theorem about
full D4.

The physical choice of L_H as the translation lattice remains a modeling
choice. Once that choice is made, the k_A angle coordinates are now formalized.
```

Current proof ladder update:

```text
C244:
  integrated.

C243:
  still open; the returned continuation left the global-gap scaffold incomplete.

C248:
  still open; the returned continuation did not supply the corrected
  hat_gamma5/projector algebra package.

C247 and C249:
  still pending/running at the time of this integration note.
```

## 70. Stay/coin update: null transport plus onsite fiber evolution

Date: 2026-06-28
Source:

```text
AgentTasks/null-edge-stay-move-decision-memo-2026-06-28.md
```

Adopt the positive physical framing:

```text
All nontrivial spatial transport steps are lightlike/null.
The update rule may also include local onsite fiber evolution.
```

Use three layers:

```text
transport graph:
  null/lightlike spatial shifts;

onsite fiber dynamics:
  local coin/rest/mass/Yukawa/Wilson/internal terms at a site;

derived propagator/path sum:
  histories built from null transports and onsite factors.
```

This gives a natural home to:

```text
Wilson branch lifting;
mass and chirality mixing;
finite internal Dirac/Yukawa blocks;
onsite phases;
local coin rotations;
symmetry-constrained M_br fallback terms.
```

Gate C1 interpretation:

```text
The current H_tet already has this split.

null-shift kinetic term:
  (i/a) sum_A B_A sin(k_A)

onsite/fiber branch-shaping term:
  (1/a)(r sum_A(1 - cos k_A) - rho)
```

Admissible onsite/fiber terms must be:

```text
local;
gauge-covariant or gauge-scalar;
tetrahedral-symmetric unless explicitly broken;
Hermitian and gamma5-even for Wilson/branch-mass use inside H_ne;
or explicitly declared as chirality/Yukawa/internal finite-Dirac data;
recorded as moduli if not symmetry-forced.
```

Resulting theorem shape:

```text
D_null:
  built from null shifts.

E_onsite:
  local, gauge-covariant, and symmetry-constrained.

H = gamma5(D_null + E_onsite - rho/a):
  Hermitian and gapped.

D_ov = (rho/a)(1 + gamma5 sign(H)):
  overlap/GW release candidate.
```

This update does not change the active free proof:

```text
Continue the L_H scalar-Wilson overlap proof first.
Treat onsite/fiber evolution as the interpretation layer and admissibility
contract for Wilson, Yukawa, and possible M_br terms.
```

## 71. Pro update: next decisive target is TetraFreeOperatorGap

Date: 2026-06-28
Source:

```text
C:\Users\Owner\.codex\attachments\bd6f4d6f-96fc-4ef5-bef2-e76b9eaf9d0f\pasted-text.txt
```

Decision:

```text
Do not spend the next mainline cycle on D4, stay-move, E8, path-sum
interpretation, or more abstract API polish.

The active Gate C1 proof target is:

  TetraFreeOperatorGap

meaning:

  the checked tetrahedral scalar gap proxy must be lifted to an actual
  finite/free operator gap.
```

Immediate ranking:

```text
1. Direct tetrahedral finite/free operator gap.
2. Reference-import / gapped-homotopy certificate.
3. D4, stay-move, and path-sum lanes as side lanes only.
```

The short mainline is now:

```text
checked scalar gap expression
  -> symbol matrix gap
  -> finite/free operator gap
  -> overlap no-mirror theorem
  -> KappaCertificate / gapped homotopy
  -> gauge/anomaly/locality contracts
```

The first serious operator is:

```text
H_tet(k) =
  gamma5 [
    (i/a) sum_A B_A sin(k_A)
    + (1/a)(r sum_A(1 - cos(k_A)) - rho)
  ].
```

Use:

```text
Q(k) = sum_A B_A sin(k_A),
R(k) = sum_A (1 - cos(k_A)),
M(k) = r R(k) - rho.
```

The required bridge is:

```text
H_tet(k)^2 >= (c^2/a^2) I
```

or, at the first Lean stage:

```text
||H_tet(k) psi||^2
  >= [freeGapScalar_tet(k) / a^2] ||psi||^2.
```

Then prove a finite Fourier bridge:

```text
symbol gap on every k
  -> translation-invariant finite/free operator gap.
```

New Lean file started:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetraFreeOperatorGap.lean
```

Current role of that file:

```text
1. Define the active branch-window predicate FundamentalTetraBZ.
2. Define the scalar square-gap coefficient tetraFreeGapSq.
3. Prove tetraFreeGapSq_pos from the checked C243 scalar gap theorem.
4. Define the symbol square-lower-bound certificate.
5. Define the uniform symbol square-gap certificate.
6. Isolate the FourierBlockDiagonalizationBridge obligation.
```

What remains before the real theorem:

```text
TetraCoframeQuadraticForm:
  prove the actual Clifford/coframe square identity for Q(k).

TetraSymbolGap:
  prove the proposed H_tet(k) satisfies the square-lower-bound certificate.

UniformTetraSymbolGap:
  extract either an explicit positive c or a compactness-based uniform minimum.

FourierBlockDiagonalization_Tetra:
  prove the finite translation-invariant operator is block diagonalized by the
  rank-4 tetrahedral Fourier transform.

TetraFreeOperatorGap:
  package the symbol and Fourier results into the full finite/free gap.

TetraFreeOverlapNoMirror:
  prove the overlap operator has exactly the physical zero and no mirror poles.
```

Important correction:

```text
Do not demand nonzero global chiral index in the free vacuum theorem.

The free theorem should prove:
  one physical overlap branch;
  no mirror/doubler poles;
  valid GW chiral projectors;
  Weyl projection can be defined on the one surviving branch.

Nonzero index belongs to nontrivial gauge/topological sectors.
```

Keep `M_br` off for the clean theorem:

```text
M_br = 0 in the main tetrahedral free proof.

Introduce M_br only after a proved scalar-Wilson failure, and only with
gamma5-even, Hermitian, gauge-covariant, symmetry-constrained, minimal data.
```

D4 policy:

```text
D4 remains an envelope / side theorem lane, not the active Gate C1 release
lattice.
```

Stay/coin policy:

```text
Onsite fiber evolution is allowed as interpretation and admissibility language,
but no new stay/coin term should be added to the active C1 proof unless the
clean scalar-Wilson tetrahedral proof fails.
```

Question to Pro, if needed:

```text
What is the cleanest formal Clifford/coframe identity for the actual
tetrahedral H_tet(k) square?

In particular, should the next Lean theorem prove an exact identity

  Q(k)^2 = scalar(k) * I

or only the lower-bound inequality needed for TetraSymbolGap?
```

## 72. Pro update: exact Q-square lemma first, exported lower bound second

Date: 2026-06-28
Source:

```text
C:\Users\Owner\.codex\attachments\1f3f288d-58bb-4d50-8c57-a1082de1bbff\pasted-text.txt
```

Decision:

```text
Do both, in this order:

1. Prove the exact Clifford/coframe identity as a local structural lemma.
2. Immediately derive the lower-bound inequality.
3. Make the lower-bound inequality the public interface consumed by
   TetraSymbolGap.
```

The proof stack is now:

```text
TetraQSquareExact:
  structural Clifford/coframe truth.

TetraQLowerBound:
  gap-facing corollary.

TetraSymbolGap:
  consume only the lower-bound API.

TetraFreeOperatorGap:
  later Fourier/operator lift.
```

First checked Lean step:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetraQSquareExact.lean
```

This file proves the scalar/coframe part of the exact identity:

```text
qExact(s) =
  (3/4) * sum_A s_A^2
  - (1/8) * (sum_A s_A)^2.
```

It proves:

```text
tetraKineticCoeffNormSq_eq_qExact:
  the checked tetrahedral kinetic coefficient norm from C243 is exactly
  qExact(sin(k)).

qLower_le_qExact:
  (1/4) * sum_A s_A^2 <= qExact(s).

qLower_le_tetraKineticCoeffNormSq:
  the exported lower-bound coefficient is bounded by the checked kinetic
  coefficient norm.
```

The operator-gap bridge was updated:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetraFreeOperatorGap.lean
```

New bridge coefficient:

```text
tetraFreeGapSqLower(a,r,rho,k) =
  [ qLower(sin(k)) + wilsonScalar(r,rho,k)^2 ] / a^2.
```

New bridge theorem:

```text
tetraFreeGapSqLower_le_tetraFreeGapSq:
  the lower-bound coefficient is bounded by the checked scalar free-gap
  coefficient.
```

Status:

```text
The scalar/coframe exact identity and lower-bound API are now locally
Lean-checked and targeted-built.

The true matrix identity

  Q(k)^2 = qExact(k) * I

for an actual Euclidean gamma representation is still open.
```

Important convention boundary:

```text
Do not use the existing Lorentzian `NullEdgeActualCliffordSymbol.lean` as the
Euclidean sign-kernel square.  That file uses mostly-minus Lorentzian gamma
matrices and correctly exhibits null-slash nilpotency and chirality-balanced
branch kernels.

The overlap sign kernel needs a Euclidean/Hilbert Clifford convention.
```

Next Lean target:

```text
EuclideanTetraQSquareExact:
  define or import a Euclidean Hermitian gamma representation;
  define B_A = (1/4) gamma_4 + (3/4) v_A^i gamma_i;
  prove the anticommutator Gram entries;
  prove Q(k)^2 = qExact(sin(k)) * I;
  export the norm lower bound using qLower.
```

Question to Pro, if needed:

```text
Should we build the Euclidean gamma representation concretely as 4x4 complex
matrices, or prove the next theorem abstractly from anticommutator Gram
hypotheses and instantiate it later?
```
## 73. Abstract tetrahedral matrix-square identity is now kernel-checked

Date: 2026-06-28

Status: proof-lane update after Pro feedback.

The latest Pro guidance was to stop trying to prove the tetrahedral kinetic
square by first choosing concrete 4x4 gamma matrices. The better first move is
to prove the matrix/operator identity abstractly from the Euclidean
anticommutator and tetrahedral Gram hypotheses, then instantiate a concrete
spin representation later.

That abstract step is now in Lean:

- `PhysicsSM/Draft/NullEdge/GateC1/TetraQMatrixSquareExact.lean`
- `tetraGram A B = 5/8` on the diagonal and `-1/8` off the diagonal.
- `TetraEuclideanSlashData` packages matrices `B A`, Hermiticity, and the
  anticommutator relation
  `B A * B B + B B * B A = 2 * tetraGram A B * I`.
- `Q D s = sum_A s_A B A`.
- `Q_square_exact` proves the exact identity
  `Q(s)^2 = qExact(s) I`.
- `Q_hermitian` and `Q_star_mul_exact` upgrade this to
  `Q(s)^* Q(s) = qExact(s) I` for real coefficients.
- `qLower_le_Q_square_coeff` exports the already-proved scalar lower bound
  `qLower(s) <= qExact(s)`.
- `Q_inverse_formula` proves the explicit two-sided inverse away from
  `qExact(s) = 0`, giving a checked algebraic no-kernel statement for the
  free-symbol proof lane.
- `Q_det_ne_zero_of_exists_ne_zero` proves the corresponding determinant-level
  branch statement: if any coefficient is nonzero, then `det Q(s) != 0`.
- `TetraQSquareExact.lean` now proves that `qExact(s) = 0` iff all four
  tetrahedral coefficients vanish, plus the equivalent nonzero/existence
  formulation. This makes the branch locus explicit rather than implicit in
  positivity estimates.

This is a meaningful narrowing of Gate C1. The project now has a
kernel-checked algebraic bridge from the tetrahedral sign kernel to the scalar
positive form needed by the free-symbol gap argument, without relying on the
Lorentzian sign conventions in `NullEdgeActualCliffordSymbol.lean` and without
committing yet to a concrete gamma-matrix realization.

The next Lean targets are:

1. Instantiate `TetraEuclideanSlashData` with a concrete finite spin model, or
   prove an existence theorem from a standard Euclidean Clifford construction.
2. Connect `Q(sin k)` to the free tetrahedral overlap/Wilson symbol in
   `TetraFreeOperatorGap.lean`.
3. Prove the finite-dimensional pointwise spectral lower bound for the full
   free symbol, including the Wilson or overlap mass term.
4. Lift the pointwise bound through the Fourier bridge to the operator gap.
5. Only after those free-theory facts are stable, return to gauge coupling,
   locality/quasi-locality, anomaly, and reflection-positivity audits.

Operationally, this supports the current proof priority: keep `D4`, stay-move,
path-sum, and concrete-gamma work as parallel supporting lanes, but keep the
main Gate C1 proof lane focused on the tetrahedral overlap/free-symbol gap.
## 74. Scalar Wilson free-symbol bridge is now kernel-checked

Date: 2026-06-28

Status: proof-lane update after Pro guidance on the next C1 theorem.

The current Gate C1 architecture remains centered on a Hermitian, gapped
Euclidean/Hilbert sign kernel. The overlap operator remains derived only after
the free-symbol gap is proved. Lorentzian/Krein/path-sum interpretation, D4,
stay-move terms, concrete gamma witnesses, and matrix-valued branch masses are
kept as parallel or later lanes.

The first bridge from the abstract tetrahedral slash identity to the scalar
Wilson/overlap free symbol is now in Lean:

- `PhysicsSM/Draft/NullEdge/GateC1/TetraScalarWilsonSymbol.lean`
- `sinCoeffs k A = sin(k A)`.
- `mWilson r rho k = r * sum_A (1 - cos(k A)) - rho`.
- `K D a r rho k = a^{-1} * (i Q(sin k) + mWilson(k) I)`.
- `K_star` proves the adjoint formula
  `K(k)^* = a^{-1} * (-i Q(sin k) + mWilson(k) I)`.
- `K_star_mul` proves the exact free-symbol identity
  `K(k)^* K(k) = ((qExact(sin k) + mWilson(k)^2) / a^2) I`.
- `scalarWilsonCoeff_lower` exports the coefficient-level lower bound from
  `qLower <= qExact`.
- `scalarWilsonCoeff_gap_from_qLower` consumes an external scalar/global-gap
  hypothesis
  `c^2 <= qLower(sin k) + mWilson(k)^2`
  and gives the scaled coefficient gap
  `c^2/a^2 <= (qExact(sin k) + mWilson(k)^2)/a^2`.

This is the first genuinely C1-facing theorem after the abstract `Q` progress:
the Euclidean tetrahedral sign-kernel algebra now feeds directly into the
scalar Wilson free-symbol square. The next target is to connect this theorem to
the existing global-gap scaffold and then formulate the finite Fourier/operator
gap lift. Concrete Pauli/tensor gamma matrices should be added as a separate
witness/regression file, not imported by the main proof unless necessary.

## 75. First Wilson band and uniform-gap adapter

Date: 2026-06-28

Status: proof-lane update after Pro guidance on the symbol-to-gap bridge.

The scalar Wilson/free-symbol module now includes the first-band API and the
first physical positivity adapters:

- `FirstWilsonBand r rho := 0 < r and 0 < rho and rho < 2*r`.
- Helper lemmas export `r > 0`, `rho > 0`, `rho < 2*r`, and
  `0 < 2*r - rho`.
- `scalarWilsonCoeff_pos_of_firstBand` adapts the existing
  `TetrahedralGlobalGap` pointwise branch-window scaffold to the checked exact
  scalar Wilson coefficient. It proves that, on the fundamental branch window
  and with `a > 0`, the coefficient
  `(qExact(sin k) + mWilson(k)^2) / a^2`
  is strictly positive.
- `scalarWilsonCoeff_uniform_scaled_gap_from_qLower` proves the adapter Pro
  requested: if a scalar certificate supplies
  `mu <= qLower(sin k) + mWilson(k)^2` uniformly, with `mu > 0`, then the exact
  scalar Wilson coefficient inherits the physical scaled uniform gap
  `mu/a^2`.
- `scalarWilsonCoeff_uniform_scaled_gap_from_qLower_exists` packages the same
  adapter in existential form.

What is now proved:

- `firstBandMu r rho` is an explicit positive certificate throughout the first
  Wilson band.
- `scalarWilsonCoeff_uniform_gap` proves
  `exists mu > 0, forall k, mu <= qLower(sin k) + mWilson(k)^2`.
- `scalarWilsonExactCoeff_uniform_gap` combines that certificate with
  `qLower <= qExact` and `a > 0` to prove a scaled exact-coefficient gap for
  `(qExact(sin k) + mWilson(k)^2) / a^2`.
- `K_star_mul_uniform_coeff_gap` packages the result in symbol-square form:
  every momentum block has `K(k)^* K(k) = coeff(k) I` with
  `coeff(k) >= gamma > 0`.
- The proof uses the finite real-variable split around
  `R(k) = sum_A (1 - cos(k_A))`: outside the middle interval the Wilson mass is
  bounded away from zero, and inside the middle interval `qLower` is bounded
  below by the elementary inequality
  `qLower >= (1/4) * R(k) * (2 - R(k))`.

What remains:

- Transfer the `K(k)` norm gap to the Hermitian sign-kernel symbol
  `H(k) = gamma5 K(k)` once a unitary/Hermitian `gamma5` interface is fixed.
- Lift the pointwise symbol norm gap through a finite Fourier/Parseval bridge
  to the free operator gap.

## 76. Finite L2 symbol norm gap for `K`

Date: 2026-06-28

Status: proof-lane update after Pro guidance on the symbol-to-operator bridge.

The scalar Wilson/free-symbol module now exports a vector norm-squared theorem,
not just coefficient identities:

- `l2NormSq v = sum_i Complex.normSq(v_i)` is the explicit finite Hilbert/L2
  norm square used by the proof-facing API. This avoids relying on a possibly
  non-Hilbert default norm instance for bare function spaces.
- `l2NormSq_mulVec_of_star_mul_eq_smul_one` is the generic matrix bridge:
  if `A^* A = coeff I`, then
  `l2NormSq(A v) = coeff * l2NormSq(v)`.
- `l2NormSq_mulVec_lower_of_star_mul_coeff_gap` is the lower-bound variant.
- `K_symbol_l2NormSq_gap` consumes `K_star_mul_uniform_coeff_gap` and proves
  the canonical pointwise finite-L2 symbol gap:
  `exists gamma > 0, forall k psi,
    gamma * l2NormSq(psi) <= l2NormSq(K(k) psi)`.

This is the theorem the Fourier/Parseval lift should consume. The remaining
gap path is now:

1. Add a `gamma5` unitary transfer theorem from `K` to the Hermitian
   sign-kernel symbol `H = gamma5 K`.
2. Prove a generic finite unitary block-diagonalization theorem:
   pointwise symbol L2 gap implies free-operator L2 gap.
3. Instantiate that theorem on the rank-4 cyclic translation torus.
## 77. Gamma5 transfer and abstract block-diagonal operator gap

Date: 2026-06-28

Status: proof-lane update after Pro guidance on the route from symbol gap to
operator gap.

The `K` symbol gap has now been transferred to the Hermitian sign-kernel symbol
and the generic Fourier/Parseval bridge has been isolated:

- `H gamma5 D a r rho k = gamma5 * K D a r rho k`.
- `H_l2NormSq_eq_K_l2NormSq` proves that if
  `gamma5^* gamma5 = 1`, then finite L2 norm squared is preserved by left
  multiplication with `gamma5`.
- `H_symbol_l2NormSq_gap` transfers the checked scalar Wilson/free-symbol
  finite-L2 gap from `K` to `H = gamma5 K`.
- `FiniteBlockDiagonalGap.lean` introduces a thin
  `UnitaryBlockDiagonalization` interface with:
  `fieldL2NormSq`, a Fourier/block transform `F`, a free operator `Hfree`,
  block symbols `Hsym`, Parseval, and the block-diagonalization law.
- `operator_gap_of_unitary_block_diagonalization` proves that a pointwise
  finite-L2 symbol gap implies the corresponding free-operator finite-L2 gap.
- `operator_gap_exists_of_unitary_block_diagonalization` packages the same fact
  with an existential positive gap constant.

This completes the abstract proof lane from:

```text
tetrahedral Q square
  -> scalar Wilson coefficient gap
  -> K symbol finite-L2 gap
  -> H symbol finite-L2 gap
  -> abstract block-diagonal free-operator gap
```

The next concrete Lean target is no longer a hard inequality. It is the
construction of the finite rank-4 cyclic translation torus and its Fourier
diagonalization data:

```text
Site = ZMod N0 x ZMod N1 x ZMod N2 x ZMod N3
shift T_A increments the A-th coordinate
F is the finite Fourier transform
Hfree diagonalizes to Hsym(k)
```

Once that concrete diagonalization witness is provided, the existing abstract
operator-gap theorem should produce the free Gate C1 sign-kernel gap.

## 78. Equal-side finite torus scaffold

Date: 2026-06-28

Status: concrete finite-lattice substrate update after Pro guidance.

The first concrete finite translation substrate is now checked in Lean:

- `PhysicsSM/Draft/NullEdge/GateC1/TetraFiniteTorusEqual.lean`.
- `SiteN N = Fin 4 -> ZMod N`.
- `MomN N = Fin 4 -> ZMod N`.
- `shiftSite N A` increments the `A`-th cyclic coordinate.
- `unshiftSite N A` decrements the `A`-th cyclic coordinate.
- `shiftEquiv N A` packages each coordinate shift as a finite permutation.
- `shiftSite_commute` proves that the four site shifts commute.
- `unshiftSite_commute` proves that the four inverse site shifts commute.
- `fieldL2NormSq` is the finite L2 norm square for spinor fields on the torus.
- `shiftField` is the pullback action of a coordinate shift on spinor fields.
- `shiftField_l2NormSq` proves that coordinate shifts preserve field L2 norm
  square.
- `shiftField_commute` proves that the induced field shifts commute.

This completes the first equal-side `ZMod N^4` substrate requested by Pro. It
does not yet define Fourier characters or the unitary Fourier transform. The
next concrete theorem target is:

```text
TetraCharactersEqual:
  define characters on SiteN N;
  prove the shift eigenvalue theorem;
  build/export the unitary Fourier transform;
  prove diagonalization of the free H symbol.
```

Keep `gamma5` abstract in this concrete Fourier work. The concrete Pauli/tensor
witness remains a later satisfiability/regression lane, not a dependency of the
main Gate C1 proof.

## 79. Equal-side character definitions

Date: 2026-06-28

Status: concrete Fourier scaffold update.

The equal-side character layer has begun in Lean:

- `PhysicsSM/Draft/NullEdge/GateC1/TetraCharactersEqual.lean`.
- `zmodAngle N m = 2*pi*m.val/N`.
- `momentumAngles N m` exports the four rank-4 momentum angles.
- `phase theta = exp(i theta)`.
- `phase_normSq` proves `Complex.normSq (phase theta) = 1`.
- `characterAngle N m x` defines the finite site/momentum character pairing.
- `character N m x = phase(characterAngle N m x)`.
- `character_normSq` proves every character value has complex norm square one.
- `fourierNormFactor N = 1 / sqrt(|SiteN N|)`.
- `fourierNormFactor_pos` proves the unitary normalization factor is positive.
- `siteAddChar` wraps the low-level character expression in Mathlib's
  additive-character API, avoiding direct `ZMod.val` wraparound proofs in the
  theorem layer.
- `siteAddChar_shiftSite` proves the coordinate-shift character law
  `chi_m(x + e_A) = chi_m(x) chi_m(e_A)`.
- `siteAddChar_sum_eq_ite` adapts Mathlib character orthogonality for the
  rank-4 site torus.
- `siteAddChar_injective` proves that momentum labels inject into the
  theorem-facing rank-4 additive characters.
- `siteAddChar_pair_orthogonality_mom_eq_ite` proves pairwise additive-character
  orthogonality indexed by momentum labels.
- `rawFourier` defines the unnormalized transform using the negative additive
  character convention.
- `rawFourier_shiftField` pins the shift convention:
  `rawFourier(shiftField_A Psi)(m) = shiftEigenvalue(m,A) rawFourier(Psi)(m)`.

This older status note is superseded by Section 81 for raw Parseval. Full
free-symbol diagonalization remains a later target. The next concrete tasks
from this stage were:

1. Define the unitary Fourier transform using `fourierNormFactor`.
2. Prove Parseval/unitarity from the additive-character orthogonality theorem.
3. Prove the inverse-shift eigenvalue theorem.
4. Diagonalize the centered derivative and Wilson terms separately.
5. Use those facts to instantiate `UnitaryBlockDiagonalization`.

## 80. Positive transport phase and phase-level finite differences

Date: 2026-06-28

Status: finite Fourier convention update after Pro guidance.

The finite equal-side Fourier lane now has the positive transport orientation
needed to match the existing symbol convention:

- `invShiftField` is the inverse pullback shift on fields.
- `transportShift` is the canonical free-operator shift and is defined as
  `invShiftField`.
- `invShiftField_l2NormSq` and `transportShift_l2NormSq` prove finite-L2 norm
  preservation.
- `invShiftField_commute` and `transportShift_commute` prove the inverse/free
  transport shifts commute.
- `phasePlus N m A = siteAddChar N m (basisSite N A)`.
- `rawFourier_invShiftField` proves the positive-phase convention:
  `rawFourier(invShiftField_A Psi)(m) =
   phasePlus(m,A) rawFourier(Psi)(m)`.
- `rawFourier_transportShift` gives the same theorem for the canonical
  `transportShift`.
- `shiftEigenvalue_eq_phasePlus_inv` proves that the previously checked
  pullback-shift eigenvalue is the inverse of `phasePlus`.
- `centeredTransportDiff` is the phase-level finite centered difference
  `transportShift_A - shiftField_A`.
- `rawFourier_centeredTransportDiff` proves it diagonalizes as
  `phasePlus - phasePlus^{-1}`.
- `wilsonLaplacianField` is the one-direction Wilson laplacian
  `2 - transportShift_A - shiftField_A`.
- `rawFourier_wilsonLaplacianField` proves it diagonalizes as
  `2 - phasePlus - phasePlus^{-1}`.

This locks the sign convention Pro warned about: the finite free operator should
be built from `transportShift`, not from the older pullback `shiftField`, so that
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

## 81. Raw Parseval is now kernel-checked

Date: 2026-06-28

Status: finite Fourier theorem milestone.

The raw Parseval and normalized Fourier/unitarity layers requested by Pro are
now formalized in Lean.

New generic bridge:

- `PhysicsSM/Draft/NullEdge/GateC1/FiniteFourierParseval.lean`.
- `characterMatrix` packages a finite Fourier kernel as a matrix with momentum
  rows and site columns.
- `rawFourierGeneric` is the reusable unnormalized finite transform.
- `l2NormSq_mulVec_of_star_mul_eq_smul_one_rect` proves the rectangular matrix
  L2 bridge: if `A.conjTranspose * A = coeff I`, then `A` multiplies finite L2
  norm square by `coeff`.
- `characterMatrix_star_mul_of_column_orthogonality` turns column
  orthogonality of the finite character table into the matrix identity.
- `scalarRawFourier_l2NormSq_of_column_orthogonality` proves scalar raw
  Parseval from column orthogonality.
- `rawFourier_l2NormSq_of_column_orthogonality` lifts the scalar result
  coordinatewise over a finite spin index.

Concrete equal-side tetrahedral adapter:

- `siteAddChar_bijective` proves that momentum labels enumerate all complex
  characters of `SiteN N`.
- `fourierChar_bijective` proves the same for the negative/Fourier convention.
- `fourierChar_sum_apply_eq_ite` proves the momentum-summed character delta
  using Mathlib's finite Pontryagin-duality theorem.
- `fourierChar_column_orthogonality` proves the concrete column orthogonality
  theorem needed by the generic Parseval bridge.
- `rawFourier_l2NormSq_siteN` proves:

```text
blockL2NormSq(rawFourier N Psi)
  =
|SiteN N| * fieldL2NormSq N Psi
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
unitary transform, without expanding all four cyclic coordinates by hand.

Next theorem stack:

1. Add the phase-to-trig adapter linking `phasePlus` to the existing
   `sinCoeffs` and scalar Wilson `1 - cos` convention.
2. Assemble the full finite/free `Hfree` diagonalization against the existing
   scalar Wilson symbol.

Potential Pro guidance question:

```text
What is the cleanest Mathlib-facing route from
  phasePlus N m A = AddChar.zmodAddEquiv (m A) 1
to
  phasePlus - phasePlus^{-1} = 2 i sin(k_A)
and
  2 - phasePlus - phasePlus^{-1} = 2(1 - cos(k_A))?

Should we prove this by unfolding AddChar.zmodAddEquiv through Circle.exp and
AddCircle, or should we introduce a project-local phase wrapper and prove a
single adapter theorem between zmodAddEquiv and phase(zmodAngle)?
```

## 82. Phase-to-trig bridge is now kernel-checked

Date: 2026-06-28

Status: finite Fourier symbol-matching milestone.

The phase-to-trigonometry adapter requested by Pro is now formalized in Lean:

- `PhysicsSM/Draft/NullEdge/GateC1/TetraPhaseTrigEqual.lean`.
- `kAngle N m A` names the one-coordinate finite momentum angle.
- `kOfMom N m` packages finite momenta as rank-4 real momentum angles.
- `phasePlus_eq_coordAddChar` aliases the already-proved one-coordinate
  character form of `phasePlus`.
- `coordAddChar_one_eq_cexp` proves the low-level convention bridge:
  `AddChar.zmodAddEquiv z 1 = exp(i zmodAngle(z))`.
- `phasePlus_eq_cexp` proves `phasePlus = exp(i k_A)`.
- `phasePlus_eq_cos_add_i_sin` proves the Euler-form theorem.
- `phasePlus_inv_eq_conj` exports the inverse-as-conjugate theorem.
- `phasePlus_inv_eq_cos_sub_i_sin` proves the inverse Euler form.
- `phasePlus_sub_inv_eq_two_i_sin` proves:

```text
phasePlus - phasePlus^{-1} = 2 sin(k_A) i
```

- `two_sub_phasePlus_sub_inv_eq_two_one_sub_cos` proves:

```text
2 - phasePlus - phasePlus^{-1} = 2(1 - cos(k_A))
```

- `sinCoeffs_kOfMom` and `wilsonCosCoeff_kOfMom` provide named symbol-facing
  adapters.
- `fourierUnitary_centeredTransportDiff_trig` transfers the normalized Fourier
  centered-difference diagonalization into trig form.
- `fourierUnitary_wilsonLaplacianField_trig` transfers the normalized Fourier
  Wilson-laplacian diagonalization into trig form.

Verified:

```text
lake build PhysicsSM.Draft.NullEdge.GateC1.TetraPhaseTrigEqual
```

This closes the convention bridge from finite additive characters to the
trigonometric scalar Wilson symbol. The remaining finite/free task is now the
operator assembly theorem:

```text
fourierUnitary_diagonalizes_Hfree
```

followed by the block-gap instantiation:

```text
TetraFreeOperatorGap_equalN
```
