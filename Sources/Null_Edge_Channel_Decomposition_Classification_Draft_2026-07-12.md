# Rigid Coefficients, Noncanonical Channels

## Moduli and Selector Obstructions for Decompositions of a Finite Krein-Dirac Carrier

**Paper F manuscript scaffold, July 12, 2026**

**Status:** mathematical-physics draft built around kernel-checked finite results.
The classification statements below concern one explicit rational `4 x 4`
carrier and an abstract fixed-total refinement problem. They do not establish a
preferred decomposition in nature, derive Standard Model sectors, or classify
all finite Dirac operators.

### Claim notation

- **M [orig]**: machine-verified theorem internal to this project.
- **T [import]**: established mathematics to be cited and compared carefully.
- **C [orig]**: proposed theorem or selection principle, with a stated gate and
  kill condition.
- **I [interp]**: interpretation of the finite mathematics, not a theorem.

---

## Abstract

A decomposition can be unique after its summands have been chosen without the
choice of summands being canonical. We make that distinction exact for a finite
rational Krein-Dirac carrier whose squared operator has a displayed four-term
expansion. The four displayed matrices are linearly independent, explicit
coordinate readers recover their coefficients, and the carrier square has the
unique coefficient vector `(1,1,1,1)`. This is coefficient rigidity.

Canonicity is a different question. The retained chirality and Krein-adjoint
types do not distinguish the three even channels. We classify two resulting
moduli problems. First, after fixing the three named even directions, all
strictly positive self-adjoint even complement rays orthogonal to them are
parameterized by the rational points of an open disk; distinct disk points give
distinct positive four-dimensional sectors containing the same named channels.
Second, the complete ordered three-channel fixed-total refinement fiber, under
type-only linear constraints, is an affine torsor for zero-sum shifts.

We then classify several proposed routes from moduli to selection. A selector
invariant under the full translation action is constant. An additive selector
rigidifies a refinement fiber exactly when it is injective on the zero-sum
shift group, and no finite-valued additive selector can do so in the presence
of a nonzero rational ambiguity direction. Componentwise trace has an explicit
nonzero invisible shift. Every commutator-blind rational-linear scalar selector
on the represented carrier factors through trace and is therefore
noninjective. Positive quadratic costs do select unique refinements, but the
selected point depends on a supplied positive metric; permutation symmetry
selects equal weights only conditionally on treating the unresolved channels
as interchangeable.

The result is neither a uniqueness theorem nor a declaration of arbitrariness.
It is a classification of what is fixed, what remains movable, and what extra
structure a noncircular physical or information-theoretic selector must use.

---

## 1. The problem is not decomposition. It is selection.

The carrier square already decomposes. The hard question is whether that
decomposition is forced by the structure one is willing to regard as
intrinsic.

For the explicit rational carrier, write

```text
4 D^# D = Q_A + Q_C + Q_T + E_sold.
```

The displayed terms are named aperture, closure, turn, and soldering in the
larger null-edge program. Those names are useful only if the corresponding
summands can be recovered without quietly inserting the answer into the
recovery rule. Linear independence proves that the coefficients of these four
already chosen matrices are unique. It does not prove that the matrices are
the uniquely natural basis of the relevant operator space.

This paper turns that logical gap into the main object of study.

> **Decisive lede.** The finite carrier has rigid coordinates but nontrivial
> decomposition moduli. The mathematical task is to classify those moduli and
> determine which additional structures, if any, select a preferred orbit.

The distinction is elementary to state and easy to blur:

| Question | Mathematical content | Current answer |
| --- | --- | --- |
| Are the coefficients unique once `Q_A,Q_C,Q_T,E_sold` are fixed? | Injectivity of the coefficient map | Yes, exactly |
| Are those four matrices selected by chirality and Krein-adjoint type alone? | Canonicity of the presentation | No |
| What are the positive alternatives compatible with the named even channels? | Positive complement moduli | Rational open disk |
| What are all type-only refinements with fixed total? | Affine classification | Torsor for zero-sum shifts |
| What additional datum selects one refinement? | Selector classification | Several exact no-go results; conditional positive selectors |
| Which selector is physically or informationally compelled? | Reconstruction problem | Open |

The paper's contribution is to answer the middle four questions precisely and
to formulate the last one so that it can fail.

---

## 2. Main theorem architecture

The paper should state one publication-facing classification theorem with six
parts. Each part already has a precise Lean anchor, except for the final
physical-selection program, which is deliberately conjectural.

### Theorem A: coefficient rigidity of the displayed carrier square

**M [orig].** Let

```text
C(a,c,t,e) = a Q_A + c Q_C + t Q_T + e E_sold.
```

For the explicit rational witness, four matrix entries define readers
`readA`, `readC`, `readT`, and `readE` satisfying

```text
readA(C(a,c,t,e)) = a,
readC(C(a,c,t,e)) = c,
readT(C(a,c,t,e)) = t,
readE(C(a,c,t,e)) = e.
```

Consequently:

1. `C` is injective;
2. `Q_A,Q_C,Q_T,E_sold` are linearly independent over `Q`;
3. any two presentations in this fixed ordered four-tuple have identical
   coefficients; and
4. the concrete carrier square recovers `(1,1,1,1)`.

This theorem is strong and narrow. It is a coordinate-rigidity result for a
specified presentation, not a basis-selection theorem.

**Exact anchors:**
`FourChannelRigidity.channel_coordinates_recover`,
`FourChannelRigidity.four_channel_coefficients_unique`,
`FourChannelRigidity.channelCombination_injective`,
`FourChannelRigidity.four_channels_linearIndependent`, and
`FourChannelRigidity.carrier_square_coefficients_recovered`.

### Theorem B: positive complement rays form an open-disk moduli space

Let `N` be the represented rational carrier space, equipped with its finite
Krein pairing. Retain self-adjointness, even chirality, and orthogonality to the
three named even channels. In the exact six-coordinate normal form, define

```text
diskVector(u,v) = normalForm(1,-1,0,0,u,v),
D_Q = {(u,v) in Q^2 : u^2 + v^2 < 1}.
```

**M [orig].** Every strictly positive vector satisfying those retained
conditions has a unique representation

```text
X = s diskVector(u,v),
```

with `(u,v) in D_Q` and `s != 0`. Thus normalized positive complement rays are
classified by `D_Q`, while actual nonzero vectors retain the unique scale `s`.

For every `(u,v) in D_Q`, the associated four-coordinate family

```text
tiltedPositive(u,v,m,x,e,g)
```

is strictly positive away from the zero coordinate tuple and contains all
three named even channels. Distinct disk points define distinct represented
positive sectors, separated by an explicit positive `diskVector` witness. On
the unit-circle boundary, the complement becomes null.

This is the geometric centerpiece of the paper. The ambiguity is not merely
"more than one choice." It is an exactly parameterized, nondegenerate moduli
space with an explicit boundary.

**Exact anchors:**
`ChannelPositiveComplementDisk.tiltedPositive_gram`,
`ChannelPositiveComplementDisk.tiltedPositive_strict`,
`ChannelPositiveComplementDisk.named_channels_in_every_tiltedSector`,
`ChannelPositiveComplementDisk.tiltedSectors_distinct`,
`ChannelPositiveComplementDisk.positive_named_orthogonal_normal_form`,
`ChannelPositiveComplementDisk.interior_witness_positive`, and
`ChannelPositiveComplementDisk.boundary_witness_null`.

**Important scope.** The theorem fixes the three named even channels before it
classifies their positive complements. It therefore does not prove that those
three channels are themselves canonical. It is a carrier-specific rational
realization of finite Krein geometry, not a claim to originate the general
theory of positive Grassmannians.

### Theorem C: the full type-only refinement fiber is an affine torsor

Let `V` be any additive commutative group representing the retained linear
per-channel type, and let `S in V` be a fixed total. Define

```text
Refinement(S) = {(b_0,b_1,b_2) : b_0+b_1+b_2=S},
ZeroSumShift(V) = {(h_0,h_1,h_2) : h_0+h_1+h_2=0}.
```

**M [orig].** `ZeroSumShift(V)` acts freely and transitively on
`Refinement(S)`. After choosing any base refinement, translation gives an
equivalence

```text
ZeroSumShift(V) ~= Refinement(S).
```

Equivalently, any target refinement is reached from any base by a unique
zero-sum shift. Whenever `V` contains a nonzero direction, every refinement has
a distinct type-compatible refinement with the same total.

This is the complete classification at the type-only level. It is not merely a
construction of a family of counterexamples.

**Exact anchors:**
`ChannelRefinementTorsor.refinementAddTorsor`,
`ChannelRefinementTorsor.refinementEquivZeroSumShift`,
`ChannelRefinementTorsor.existsUnique_translate`, and
`ChannelRefinementTorsor.refinement_not_unique_of_nonzero`.

**Important scope.** The torsor theorem does not impose positivity, locality,
gauge equivalence, edge relabeling, dynamics, nonlinear cross-channel
relations, or a physical constraint quotient. Those are additional structures,
not hidden consequences of the fixed-total equation.

### Theorem D: exact criterion for an additive selector

An additive selector is a homomorphism

```text
sigma : ZeroSumShift(V) -> A.
```

Call it rigidifying when `sigma(difference(b,c))=0` forces `b=c`.

**M [orig].** An additive selector rigidifies the full fixed-total refinement
fiber if and only if `sigma` is injective on the zero-sum shift group.

If `V` is a rational module with a nonzero direction, then `ZeroSumShift(V)`
contains an injected copy of `Q`. Hence no additive selector with finite target
can rigidify the fiber.

This theorem converts a vague request for "a natural invariant" into a precise
separation problem: identify a selector whose kernel contains no physically
distinct residual shift, or justify a quotient on which its remaining kernel
is exactly gauge.

**Exact anchors:**
`ChannelSelectorRigidity.selector_rigid_iff_injective`,
`ChannelSelectorRigidity.rationalShift_injective`, and
`ChannelSelectorRigidity.no_finite_selector_rigidifies`.

### Theorem E: naturality and scalar-linear selector obstructions

The word "natural" is too weak unless the symmetry under which naturality is
required is stated. This paper separates three exact obstruction classes.

#### E1. Full residual-translation invariance

**M [orig].** Any score invariant under every translation of a torsor is
constant. On a nontrivial torsor, no predicate invariant under the full shift
group has a unique preferred point.

**Exact anchors:**
`ChannelNaturalityNoGo.invariant_selector_constant`,
`ChannelNaturalityNoGo.no_unique_invariant_preferred`, and
`ChannelNaturalityNoGo.no_unique_type_invariant_refinement`.

Interpretation: a successful selector must break the full type-only
translation symmetry, or the theory must first justify quotienting some of
those translations as equivalences. Calling the selector "intrinsic" does not
remove this obligation.

#### E2. Componentwise trace

**M [orig].** On the live represented carrier, a nonzero trace-zero matrix
produces an explicit zero-sum shear invisible to the trace of every component.
The componentwise trace profile is therefore noninjective and cannot rigidify
the fixed-total refinement fiber.

**Exact anchors:**
`ChannelTraceSelectorNoGo.traceInvisibleShift_nonzero`,
`ChannelTraceSelectorNoGo.traceProfile_invisible`,
`ChannelTraceSelectorNoGo.traceProfile_not_injective`, and
`ChannelTraceSelectorNoGo.traceProfile_does_not_rigidify`.

#### E3. Commutator-blind scalar linear functionals

**M [orig].** Every rational-linear scalar functional on the represented
`4 x 4` carrier that annihilates every commutator is a scalar multiple of
matrix trace:

```text
f(X) = (f(I)/4) trace(X).
```

Every such selector is noninjective because the carrier has an explicit
nonzero trace-zero direction.

**Exact anchors:**
`ChannelCommutatorSelectorClassification.offDiag_is_commutator`,
`ChannelCommutatorSelectorClassification.diagSub_is_commutator`,
`ChannelCommutatorSelectorClassification.selector_factors_through_trace`, and
`ChannelCommutatorSelectorClassification.no_commutatorBlind_selector_injective`.

This closes one entire scalar-linear branch. It does not rule out nonlinear,
vector-valued, spectral, locality-sensitive, positive-sector, constrained, or
information-theoretic selectors. Conjugation invariance must not be identified
with commutator blindness outside this exact linear setting.

### Theorem F: positive quadratic selection works, but only relative to a metric

For positive weights `a,b,c`, define the scalar resource cost

```text
Q(x,y,z) = a x^2 + b y^2 + c z^2
```

on the affine plane `x+y+z=s`.

**M [orig].** The exact completion-of-squares identity gives a sharp lower
bound and a unique weighted-barycentric minimizer:

```text
x_* = bc s / (ab+ac+bc),
y_* = ac s / (ab+ac+bc),
z_* = ab s / (ab+ac+bc).
```

Equal weights select `(s/3,s/3,s/3)`. Weights `(1,2,3)` select
`(6s/11,3s/11,2s/11)`. Thus strict convexity removes the affine ambiguity only
after a positive channel metric has been supplied. Different positive metrics
select different decompositions of the same total.

The same theorem family identifies a conditional naturality principle: full
invariance under the two adjacent exchanges of channel labels is equivalent to
equal diagonal weights, and a positive fully symmetric metric uniquely selects
equal thirds.

**Exact anchors:**
`ChannelQuadraticSelectorFamily.weighted_completion_identity`,
`ChannelQuadraticSelectorFamily.weighted_cost_lower_bound`,
`ChannelQuadraticSelectorFamily.selected_unique_of_cost_le`,
`ChannelQuadraticSelectorFamily.positive_quadratic_selectors_disagree`,
`ChannelQuadraticSelectorFamily.full_permutation_invariance_iff`, and
`ChannelQuadraticSelectorFamily.positive_symmetric_unique_equal_thirds`.

This is a positive selection theorem and a negative canonicity theorem at once.
It says exactly what a variational principle can accomplish and exactly which
datum it still owes.

### Theorem G: a residual stabilizer orbit already identifies positive sectors

The exact six-coordinate Gram form weights the two negative normal-form
coordinates equally. Exchanging those coordinates is therefore a rational
order-two isometry. It fixes the three named even channels pointwise and acts
on the positive-complement disk by

```text
(u,v) |-> (v,u).
```

**M [orig/comp].** The points `(3/5,0)` and `(0,3/5)` determine distinct
strictly positive represented sectors, each with exact Gram norm `32/25`, but
they lie in one orbit of this residual isometry. Consequently every selector
invariant under that explicitly declared symmetry gives the two complement
witnesses the same value.

**Exact anchors:**
`ChannelStabilizerSelectorSuccessor.swapNegativeNormal_gram`,
`swapNegativeNormal_fixes_named_channels`,
`swapNegativeNormal_diskVector`, and
`rational_swap_orbit_obstructs_invariant_selector`.

This is the first exact orbit control on the disk. Its scope is deliberately
narrow: the swap is proved to preserve the rational quadratic structure, not
matrix multiplication, the carrier dynamics, locality, gauge data, or a
physical equivalence relation. The next classification problem is the full
rational pointwise stabilizer of the named channels and its orbit invariants.

---

## 3. Publication-facing classification verdict

The capstone theorem bundles the finite result into one statement.

> **M [orig].** The explicit four-channel coefficient map is injective. There
> exist distinct strictly positive represented sectors containing the same
> named even channels. Every fixed-total type-only refinement is reached from
> every other by a unique zero-sum shift. Raw represented solder-degree,
> componentwise trace, and commutator-blind rational-linear scalar selectors
> fail under their displayed hypotheses. Positive quadratic selectors choose
> unique points but disagree when their supplied metrics disagree.

**Exact anchor:**
`PhysicsSM.Draft.NullEdge.ChannelDecompositionModuliCapstone.channel_decomposition_classification_verdict`.

The supporting capstone declarations make the geometry and scope separately
available:

- `distinct_positive_named_sectors` supplies a positive separating witness;
- `positive_complement_rays_classified_by_open_disk` supplies the unique disk
  coordinate and nonzero scale;
- `live_refinement_fibre_is_nontrivial_torsor` supplies the complete affine
  classification and a nontriviality witness;
- `represented_selector_obstruction_suite` packages three represented
  selector failures under their exact definitions; and
- `positive_quadratic_selection_is_metric_dependent` gives the explicit
  `(1/3,1/3,1/3)` versus `(6/11,3/11,2/11)` control.

The correct conclusion is:

> The displayed four-channel presentation is rigid after it is chosen, but the
> weaker positive and type-only structures leave genuine moduli. The tested
> intrinsic selectors do not canonically collapse those moduli; supplied
> positive metrics do, but select metric-dependent points.

The incorrect conclusions are equally important:

- not "the four terms are arbitrary";
- not "the four names are forced by the carrier square";
- not "positivity uniquely determines the physical sector";
- not "no selector can ever work"; and
- not "the moduli already represent observed interactions or particles."

---

## 4. Three spaces that must not be conflated

The manuscript should keep three classification spaces visibly separate.

### 4.1 Coefficient space of a fixed ordered presentation

This is `Q^4`, mapped injectively into the operator space by
`(a,c,t,e) |-> C(a,c,t,e)`. Here the basis is fixed and the question is only
whether coefficients are recoverable. They are.

### 4.2 Positive complement space relative to named even channels

This is the rational open disk after quotienting nonzero complement vectors by
scale. It classifies positive complement rays orthogonal to the three fixed
named channels. The unit circle is a null boundary.

### 4.3 Type-only fixed-total refinement fiber

This is an affine torsor modeled on all zero-sum shifts in the retained linear
type space. It is much larger than the open-disk family because it deliberately
forgets positivity and other nonlinear or relational constraints.

A top-tier presentation should include a diagram of maps and forgetful steps:

```text
fixed named presentation
        |
        | forget coordinate readers
        v
positive sectors containing the named channels  ---->  rational open disk
        |
        | forget positivity and orthogonality
        v
fixed-total type-only refinements              ---->  zero-sum-shift torsor
```

The arrows are conceptual forgetful maps to be defined precisely before they
are promoted to theorems. The current Lean results classify each displayed
level but do not yet formalize this entire diagram as a functorial hierarchy.

---

## 5. Selector taxonomy

The paper should replace the binary question "is the decomposition unique?"
with a taxonomy of selectors and their exact obligations.

| Selector class | Input retained | Exact status | What survives |
| --- | --- | --- | --- |
| Coordinate readers | Chosen matrix entries/support | Rigidifies the displayed basis | Correct but presentation-relative |
| Full-shift-invariant score or predicate | Type-only torsor action | Constant / cannot uniquely select | Must break or quotient the shift symmetry |
| Finite-valued additive selector | Rational ambiguity direction | Cannot be injective | Infinite or nonadditive data needed |
| Componentwise trace | Represented component matrices | Explicit invisible shear | Spectral data richer than trace remains open |
| Commutator-blind scalar linear selector | Full represented matrix algebra | Factors through trace; noninjective | Nonlinear/vector-valued/local selectors remain open |
| Raw solder-degree selector | Represented word degree requirements | Inconsistent in the capstone's tested class | Must descend through represented relations |
| Positive diagonal quadratic cost | Positive weights/metric supplied | Unique minimizer | Selection depends on the metric |
| Fully permutation-symmetric positive quadratic cost | Channel exchangeability supplied | Unique equal-thirds point | Exchangeability itself needs justification |
| Physical constraint/cohomology selector | Constraint complex and physical quotient | Future integration target here | Could remove gauge-exact ambiguity |
| Information-theoretic selector | Operational states/channels and monotonicity law | Open | Must be noncircular and stable |

This table should be one of the paper's central figures. It makes the result
constructive: each failed selector narrows the design space for a successful
one.

---

## 6. What can select a channel decomposition?

The classification result earns its physical relevance only if the residual
moduli can be compared with structures that physics already requires. The
paper should therefore formulate, but not pre-judge, two selection programs.

### 6.1 Physical selection program

**C [orig].** Define a category of finite carriers whose objects include the
operator, chirality, Krein adjoint, edge/locality data, and any physical
constraint complex. Define morphisms before choosing channel labels. A
physical selector should satisfy all of the following:

1. **Representation descent.** It is unchanged by different source words that
   evaluate to the same represented operator.
2. **Automorphism covariance.** It is invariant or equivariant under the
   declared gauge, edge-relabeling, and frame transformations.
3. **Locality sensitivity.** If locality is meant to distinguish channels, the
   selector must use an intrinsic range or support filtration rather than
   preassigned channel coordinates.
4. **Constraint compatibility.** Gauge-exact or null-homotopic changes should
   be quotiented only after a physical constraint complex is supplied.
5. **Positivity without circularity.** A positive physical sector must be
   derived from the carrier data or dynamics, not chosen as the span of the
   desired answer.
6. **Stability.** The selected orbit should persist under an explicit class of
   admissible perturbations and, ultimately, coarse-graining.
7. **Separation.** On the live examples, the selector must distinguish at
   least the explicit disk-separated positive sectors or prove them physically
   equivalent.

Candidate structures to test include spectral projectors, locality/range
filtrations, action Hessians, constrained physical cohomology, response to
boundary conditions, and renormalization stability. None is claimed here to
have passed all seven gates.

**Noncircularity test.** Delete the words aperture, closure, turn, and solder
from the definition. If the selector cannot still be stated, it has probably
encoded the desired decomposition rather than derived it.

### 6.2 Information-theoretic selection program

**C [orig].** An information selector should be defined from operational data:
states, channels, distinguishability tasks, coding cost, or recoverability. It
must not assign costs directly to already named channel coordinates.

A serious candidate should provide:

1. a state or channel space associated functorially with the carrier;
2. a nonnegative functional with a clear operational meaning;
3. a data-processing or coarse-graining law;
4. a refinement law describing how the functional behaves when one channel is
   split or two are merged;
5. an equality characterization strong enough to identify its kernel;
6. a proof that the induced selector descends to represented operators;
7. a comparison on the same explicit disk and torsor witnesses used by the
   physical selectors; and
8. stability of the selected orbit under perturbation of the operational data.

Possible candidates include distinguishability loss, compression length,
recoverability error, relative-entropy production, or a resource monotone.
These are research directions, not results of the current finite
classification.

### 6.3 The comparison theorem the paper ultimately wants

The strongest positive successor would prove that independently motivated
physical and information-theoretic selectors descend to the same quotient and
select the same stable orbit.

**C [orig], target theorem.** For a declared carrier category and equivalence
group, the physical selector `S_phys` and information selector `S_info` have
the same zero set or the same unique minimizing orbit, and this orbit contains
the displayed four-channel decomposition.

**Gate:** both selectors must be defined without channel names and evaluated on
the explicit nondegenerate alternatives.

**Kill condition:** if the selectors choose different inequivalent disk or
torsor points, there is no unified selection principle at that level of
structure.

---

## 7. Kill conditions

The classification paper should state its failure conditions before extending
the interpretation.

### K1. Coefficient-rigidity overclaim

If the manuscript infers canonical channel identities solely from linear
independence or coordinate recovery, the central conclusion is false. Those
theorems presuppose the displayed ordered matrices and readers.

### K2. Open-disk scope failure

If the positive complement theorem is presented as a classification of all
carrier decompositions, the claim outruns the theorem. It classifies positive
complement rays orthogonal to three fixed named channels in the live rational
carrier.

### K3. Torsor scope failure

If positivity, locality, gauge equivalence, or cross-channel relations are
silently attributed to the type-only torsor, the affine classification has
been misread.

### K4. Selector circularity

If a proposed selector requires the desired channel coordinates, support
entries, or labels in its definition, it demonstrates conditional rigidity,
not natural selection.

### K5. Presentation non-descent

If a source-level grading assigns different values to expressions representing
the same operator, it is not a selector on the represented carrier.

### K6. Kernel too large

If an additive selector has a nonzero physically inequivalent shift in its
kernel, it does not rigidify the decomposition. Trace supplies the explicit
control example.

### K7. Metric insertion

If a variational principle selects the desired split only because its positive
metric or weights were chosen to do so, the decomposition has been moved into
an input.

### K8. Quotient inflation

If all residual shifts are declared gauge merely to recover uniqueness, the
theory has erased the classification problem rather than solved it. The
equivalence relation must be independently motivated and tested on nontrivial
observables.

### K9. No stability

If the selected point changes discontinuously under small admissible changes
of carrier data, it is unlikely to define a robust physical channel identity.

### K10. No operational distinction

If all disk and torsor alternatives are observationally equivalent under every
intrinsic probe available to the model, then the correct result is an
equivalence-class theorem, not a preferred-decomposition theorem.

These kill conditions are productive outcomes. A sharp underdetermination
theorem is publishable even if no preferred selector survives.

---

## 8. Proposed manuscript structure

### 1. Introduction: rigid coordinates are not canonical channels

- Lead with the logical distinction, not the four physical names.
- State the classification verdict in the first two pages.
- Explain why decomposition ambiguity matters in squared Dirac-type operators,
  finite noncommutative models, and structured operator factorizations without
  claiming a general theorem beyond the finite carrier.
- Include a one-panel diagram of the three spaces in Section 4.

### 2. The finite rational Krein-Dirac carrier

- Define the represented matrix space, chirality, Krein adjoint, pairing, and
  explicit carrier square.
- Display `Q_A,Q_C,Q_T,E_sold` and the four readers.
- Lock basis, signs, transpose/adjoint convention, and rational scalar field.
- Separate declarations inherited from the larger null-edge program from
  definitions needed only for this paper.

### 3. Rigidity of a chosen four-term presentation

- Prove Theorem A.
- Explain why coordinate recovery is stronger than a numerical rank check.
- Immediately state the boundary: shared type and block count do not select the
  basis.

### 4. Krein signature and positive complement geometry

- Introduce the six-coordinate normal form and its `(4,2)` quadratic signature.
- Derive the tilted positive families.
- Prove strict positivity in the disk, nullity on the boundary, and sector
  separation.
- Prove the unique positive complement normal form.
- Draw the rational open disk, with interior positive and boundary null.

### 5. Affine classification of fixed-total refinements

- Define `Refinement(S)` and `ZeroSumShift(V)`.
- Prove the torsor equivalence abstractly.
- Instantiate the nontriviality result on the live represented carrier.
- Explain exactly which structures have been forgotten at this level.

### 6. Selector criteria and no-go theorems

- Prove the additive injectivity criterion.
- Prove the full-translation naturality no-go.
- Prove the finite-valued obstruction.
- Exhibit the trace-invisible shift.
- Classify commutator-blind scalar linear selectors.
- State the raw represented degree obstruction only with its exact hypotheses.

### 7. Conditional positive selection by convex costs

- Prove the completion-of-squares theorem.
- Derive the unique weighted barycenter.
- Compare equal and unequal weights exactly.
- Classify permutation invariance of the diagonal metric.
- Frame the supplied metric as the remaining datum, not as an inconvenience.

### 8. From moduli to physical or informational selection

- Define the criteria in Section 6 as formal research gates.
- Compare candidate selectors on the same explicit witnesses.
- Distinguish a preferred point, a preferred orbit, and a justified quotient.

### 9. Discussion and boundaries

- State what is complete: coefficient, open-disk, torsor, and tested-selector
  classifications.
- State what is not: full automorphism quotient, full positive Grassmannian,
  physical selector, information selector, stability, continuum relevance.
- Present the kill conditions as the roadmap.

### Appendices

- A. Explicit rational matrices and coordinate computations.
- B. Six-coordinate Krein normal form.
- C. Torsor and selector proofs in abstract algebraic form.
- D. Lean theorem map and assumption-footprint audit.
- E. Reproduction commands and version pins.

---

## 9. Exact Lean anchor map

All paths are relative to `PhysicsSM/Draft/NullEdge/`.

| Manuscript result | Lean module | Exact declaration(s) |
| --- | --- | --- |
| Four readers recover coefficients | `FourChannelRigidityCapstone.lean` | `channel_coordinates_recover` |
| Unique coefficients | `FourChannelRigidityCapstone.lean` | `four_channel_coefficients_unique` |
| Injective coefficient map | `FourChannelRigidityCapstone.lean` | `channelCombination_injective` |
| Linear independence | `FourChannelRigidityCapstone.lean` | `four_channels_linearIndependent` |
| Carrier-square coefficients `(1,1,1,1)` | `FourChannelRigidityCapstone.lean` | `carrier_square_coefficients_recovered` |
| Rigidity plus noncanonicity boundary | `FourChannelRigidityCapstone.lean` | `four_channel_rigidity_with_boundary` |
| Exact tilted-sector metric | `ChannelPositiveComplementDisk.lean` | `tiltedPositive_gram` |
| Strict positivity in open disk | `ChannelPositiveComplementDisk.lean` | `tiltedPositive_strict` |
| Named channels lie in every tilted sector | `ChannelPositiveComplementDisk.lean` | `named_channels_in_every_tiltedSector` |
| Distinct disk points give distinct sectors | `ChannelPositiveComplementDisk.lean` | `tiltedSectors_distinct` |
| Unique positive complement coordinate and scale | `ChannelPositiveComplementDisk.lean` | `positive_named_orthogonal_normal_form` |
| Interior and boundary controls | `ChannelPositiveComplementDisk.lean` | `interior_witness_positive`, `boundary_witness_null` |
| Fixed-total refinement torsor | `ChannelRefinementTorsor.lean` | `refinementAddTorsor`, `refinementEquivZeroSumShift` |
| Unique shift between refinements | `ChannelRefinementTorsor.lean` | `existsUnique_translate` |
| Nontrivial refinement fiber | `ChannelRefinementTorsor.lean` | `refinement_not_unique_of_nonzero` |
| Fully invariant selector is constant | `ChannelNaturalityNoGo.lean` | `invariant_selector_constant` |
| No unique fully invariant preference | `ChannelNaturalityNoGo.lean` | `no_unique_invariant_preferred`, `no_unique_type_invariant_refinement` |
| Additive rigidity iff injectivity | `ChannelSelectorRigidity.lean` | `selector_rigid_iff_injective` |
| Rational ambiguity injection | `ChannelSelectorRigidity.lean` | `rationalShift_injective` |
| Finite-valued additive no-go | `ChannelSelectorRigidity.lean` | `no_finite_selector_rigidifies` |
| Explicit trace-invisible shift | `ChannelTraceSelectorNoGo.lean` | `traceInvisibleShift_nonzero`, `traceProfile_invisible` |
| Trace does not rigidify | `ChannelTraceSelectorNoGo.lean` | `traceProfile_not_injective`, `traceProfile_does_not_rigidify` |
| Commutator-blind scalar classification | `ChannelCommutatorSelectorClassification.lean` | `selector_factors_through_trace` |
| Commutator-blind scalar noninjectivity | `ChannelCommutatorSelectorClassification.lean` | `no_commutatorBlind_selector_injective` |
| Weighted completion of squares | `ChannelQuadraticSelectorFamily.lean` | `weighted_completion_identity` |
| Unique weighted minimizer | `ChannelQuadraticSelectorFamily.lean` | `selected_unique_of_cost_le` |
| Metric dependence | `ChannelQuadraticSelectorFamily.lean` | `positive_quadratic_selectors_disagree` |
| Permutation symmetry criterion | `ChannelQuadraticSelectorFamily.lean` | `full_permutation_invariance_iff` |
| Symmetric unique equal-thirds selector | `ChannelQuadraticSelectorFamily.lean` | `positive_symmetric_unique_equal_thirds` |
| Distinct positive named sectors | `ChannelDecompositionModuliCapstone.lean` | `distinct_positive_named_sectors` |
| Open-disk ray classification | `ChannelDecompositionModuliCapstone.lean` | `positive_complement_rays_classified_by_open_disk` |
| Live nontrivial torsor | `ChannelDecompositionModuliCapstone.lean` | `live_refinement_fibre_is_nontrivial_torsor` |
| Represented selector obstruction suite | `ChannelDecompositionModuliCapstone.lean` | `represented_selector_obstruction_suite` |
| Residual swap orbit obstruction | `ChannelStabilizerSelectorSuccessor.lean` | `rational_swap_orbit_obstructs_invariant_selector` |
| Metric-dependent positive selection | `ChannelDecompositionModuliCapstone.lean` | `positive_quadratic_selection_is_metric_dependent` |
| Publication-facing classification verdict | `ChannelDecompositionModuliCapstone.lean` | `channel_decomposition_classification_verdict` |

The paper should quote the exact hypotheses from these declarations in theorem
statements rather than rely on the summaries in this scaffold.

---

## 10. Evidence and originality boundary

### What the finite formalization establishes

1. Exact coefficient rigidity for one explicit rational four-matrix
   presentation.
2. Exact classification of a carrier-specific family of positive complement
   rays by a rational open disk.
3. Exact affine/torsor classification of all fixed-total type-only ordered
   three-channel refinements.
4. Necessary and sufficient injectivity criterion for additive selectors.
5. Exact obstructions for full shift invariance, finite-valued additive data,
   componentwise trace, and commutator-blind rational-linear scalar data.
6. Exact positive quadratic selection together with exact metric dependence.

### What must be treated as established external mathematics

The final manuscript must compare its constructions with the literature on:

- finite-dimensional Krein spaces and fundamental symmetries;
- positive subspaces and Grassmannian/domain parameterizations;
- moduli and orbit spaces of Dirac-type or spectral data;
- affine torsors and invariant theory;
- commutator quotients and trace classification on full matrix algebras; and
- variational selection on affine constraint spaces.

The likely originality is not the abstract existence of these mathematical
structures. It is their exact carrier-specific composition, the simultaneous
positive and affine classifications, the selector taxonomy, and the
machine-checked boundary between rigidity and canonicity. That originality
claim must be confirmed by a dedicated literature review before submission.

### What remains interpretation or conjecture

- that aperture, closure, turn, and soldering are the physically preferred
  names for the selected finite summands;
- that a selector derived from the carrier will choose the displayed point;
- that physical and information-theoretic selectors coincide;
- that the finite moduli survive or collapse in a continuum limit; and
- that any selected orbit corresponds to observed particle, gauge, or
  gravitational sectors.

These claims should not appear in the abstract or theorem statements as
results.

---

## 11. Submission-strength work program

### Required for the negative-classification paper

1. Define the carrier category and the equivalence group used in the paper.
2. Make the relation among coefficient space, positive disk, and affine torsor
   into precise maps or explicitly explain why only a comparison is claimed.
3. Classify the relevant automorphism action on the open-disk family or state a
   sharply scoped orbit problem.
4. Include at least two inequivalent nonzero decompositions and one true
   equivalence control.
5. Compare directly with Krein positive-subspace and Dirac-operator moduli
   literature.
6. Audit every use of "canonical," "intrinsic," and "natural" against a named
   symmetry or universal property.
7. Build the capstone and all listed assumption-footprint guards under the
   pinned Lean toolchain.

### Required for a stronger positive-selection paper

1. Define a noncircular physical selector on the full represented carrier.
2. Define an operational information selector with a data-processing or
   refinement law.
3. Prove descent of both selectors through represented relations.
4. Determine their kernels on the full zero-sum ambiguity group.
5. Compare the selected orbits on the explicit disk and torsor witnesses.
6. Prove perturbative or coarse-graining stability.

### Recommended figures

1. **Rigid coordinates versus movable basis:** a fixed four-vector basis with
   unique coefficients beside a family of admissible bases.
2. **Positive open disk:** interior points label positive sectors; the circle is
   the null boundary; two rational points carry explicit separating vectors.
3. **Affine refinement torsor:** a base point plus the plane of zero-sum shifts.
4. **Selector decision tree:** descent, invariance, injectivity, positivity,
   metric dependence, and stability.
5. **The hierarchy diagram:** fixed presentation -> positive moduli -> type-only
   torsor, with the structures forgotten at each step.

---

## 12. Conclusion draft

The carrier square does not confront us with a choice between uniqueness and
arbitrariness. It exhibits a more structured possibility. Once four explicit
summands are fixed, their coefficients are rigid and exactly recoverable. But
the retained chirality, adjoint, positivity, and fixed-total data do not by
themselves make that presentation canonical. The remaining choices form
classifiable spaces: an open disk of positive complement rays and an affine
torsor of type-only refinements.

That classification changes the scientific question. One should no longer ask
whether the preferred decomposition can be recognized by inspection. One must
state the additional structure that is allowed to recognize it. Full residual
invariance recognizes nothing. Finite additive data cannot separate a rational
ambiguity. Trace misses an explicit shear. Commutator-blind scalar linear data
collapse to trace. Positive convex costs select uniquely, but only relative to
a supplied metric.

The next theorem, if there is one, must therefore be a selection theorem rather
than another decomposition identity. It must derive a stable orbit from
physical or operational information without encoding the desired channel names
in advance. If no such selector exists, the nonuniqueness is itself the result:
the finite carrier determines a class of admissible decompositions, not a
privileged one. Either outcome is mathematically sharp, physically honest, and
testable on the exact witnesses already in hand.
