# Four-channel decomposition classification program

Updated: 2026-07-10 PDT.

Current status: the F1 type-only affine fibre, an explicit residual shear
subgroup, F2 conditional two-sign-grading uniqueness, the exact additive
selector-rigidity criterion, the finite-selector obstruction, and the
full-translation naturality no-go are landed and guarded in
`ChannelRefinementTorsor.lean`, `ChannelShearModuli.lean`,
`ChannelSelectorUniqueness.lean`, `ChannelSelectorRigidity.lean`,
`ChannelNaturalityNoGo.lean`, `ChannelSelectorDescent.lean`,
`ChannelSolderDegreeNoGo.lean`, `ChannelTraceSelectorNoGo.lean`,
`ChannelQuadraticSelectorFamily.lean`, `ChannelKreinMetricNoGo.lean`, and
`ChannelCommutatorSelectorClassification.lean`. The descent theorem gives
the exact intrinsicality gate: for a surjective carrier evaluation, a source
selector descends uniquely iff it preserves the evaluation kernel. The live
concrete carrier then kills the first proposed intrinsic selector: the nonzero
idempotent `P = c1 * c1#` represents both a solder-degree-two word and its
degree-four square, so no additive represented selector can assign both raw
degrees. The hostile design report is `FOUR_CHANNEL_CLASSIFICATION_REVIEW.md`;
the corrected counter-audit is preserved at
`AgentTasks/aristotle-output/6833acfa-0112-4a83-93cb-cf496354afd7/result/codex-pub-live-selector-kernel-counteraudit-20260711-project_aristotle/LIVE_SELECTOR_KERNEL_COUNTERAUDIT_2026-07-11.md`.
The abstract selector-preserving quotient is now defined exactly in
`ChannelSelectorQuotient`: quotient by the selector kernel, with class equality
equivalent to selector indistinguishability and a canonical equivalence to the
selector range. This is standard first-isomorphism infrastructure. Calling any
instance physical still requires a surviving, independently justified physical
or information selector; that substantive gate remains open.

A positive variational selector is also now classified at scalar scope.
`ChannelQuadraticSelectorFamily` proves that every positive diagonal quadratic
resource metric has a unique weighted-barycentric minimizer on each fixed-total
fibre. It also proves the decisive metric-dependence control: equal weights
select `(1/3,1/3,1/3)`, while positive weights `(1,2,3)` select
`(6/11,3/11,2/11)` for the same unit total. Thus strict convexity restores
uniqueness only after the channel metric is supplied; it does not by itself
make the physical decomposition canonical.
`ChannelQuadraticInnerLift` now proves the same completion identity, lower
bound, and global unique-minimizer theorem in every real inner-product channel
space, with no finite-dimensionality or differentiability assumption. It also
retains the nonzero control that two positive metrics select different vector
decompositions. This closes the operator/inner-product-space algebraic lift, but the
inner product and weights remain supplied rather than derived.
Within this diagonal family, full permutation symmetry of the three unresolved
channel labels is equivalent to equal weights and therefore selects equal
thirds. This is a precise naturality theorem, but applying it physically
requires an argument that aperture, closure, and turn really are exchangeable
after the retained structure is fixed.

The shortest carrier-derived positive metric is now CLOSED NEGATIVELY.
`ChannelKreinMetricNoGo` defines the adjoint-induced form
`trace(A# B)` on the live represented carrier and exhibits the exact nonzero
direction `E01-E10`. It is chirality-even and Krein-self-adjoint, but its
self-pairing is `-2`. Hence this form is not positive semidefinite on the
complete retained even self-adjoint sector and cannot feed the positive
quadratic selector without a further positive-sector restriction. Restricting
to the span of the desired named channels would be circular unless that span is
derived independently.

The complete signature of that failed live metric is now classified, not just
witnessed. `ChannelKreinSectorSignature` proves that every chirality-even,
Krein-self-adjoint represented operator has a unique six-coordinate normal
form and exact self-pairing
`a^2+d^2+e^2+g^2-2*b^2-2*f^2`. The diagonal four-coordinate subspace is
positive definite and the complementary two-coordinate plane is strictly
negative away from zero. This is an exhaustive `4+ / 2-` square-coordinate
classification of the supplied form. It does not identify the positive
coordinates with the physical channels or derive a canonical fundamental
symmetry.

The scalar linear commutator-blind branch is now classified completely.
`ChannelCommutatorSelectorClassification` proves that every rational-linear
functional on the live represented `4 x 4` carrier which annihilates all
matrix commutators has the exact form
`f(X) = (f(1)/4) trace(X)`. The explicit nonzero trace-zero direction then
proves that no such selector is injective. This upgrades the earlier trace
witness from one failed example to a structural quotient theorem: under this
intrinsicity condition, the selector sees only the one-dimensional trace
quotient. The scope is deliberately sharp. Nonlinear, vector-valued, spectral,
locality-sensitive, positive-sector, and information-theoretic selectors are
not classified by this result.
Aristotle hostile audit `dfe5e4dc` independently re-derived the matrix-unit
signs, arbitrary-matrix factorization, nonzero trace-zero control, non-vacuity,
and standard-three assumption footprint and returned PASS. Its binding warning
is the stated scope boundary: publication prose must retain “rational-linear
scalar.”

Two attractive selectors are now closed negatively for different reasons.
Raw solder degree fails to descend through the live evaluation kernel because
different word degrees represent the same idempotent operator. Componentwise
matrix trace is intrinsic and conjugation-invariant on represented operators,
but a nonzero trace-zero shear is invisible in every component, so the trace
profile is not injective on the complete refinement shift group and cannot
rigidify the fibre.

Current publication grade: **a coherent standalone negative-classification
theorem spine is landed; the stronger positive-selector paper remains
theorem-gated**. The negative route combines the complete type-only torsor and
shears, exact descent criterion, live mixed-degree kill, trace-profile and full
commutator-blind scalar no-gos, supplied-metric dependence, and exhaustive
`(4,2)` Krein signature. It still needs the carrier/equivalence packaging,
nondegenerate orbit examples, nearest-work confrontation, and release audit.
The positive route additionally needs one channel-name-free selector with a
proved live relation-kernel descent and a physical-versus-information selector
comparison on the same nondegenerate carriers. Raw solder degree and scalar
commutator-blind selection are now closed negative branches, not candidates to
recycle under new names.

`ChannelPositiveSectorModuli` is LANDED. The explicit `5-4-3` rational Krein
boost produces a second injective four-coordinate positive family with exact
norm preservation, full coordinate uniqueness, and a norm-one member outside
the diagonal positive family. This strengthens the negative route by proving
positive-sector choice is itself nonunique. It does not classify the full
positive Grassmannian or supply a physical fundamental symmetry. Fundamental
decompositions and `O(p,q)` positive-subspace orbits are standard Krein
geometry; the defensible novelty is the explicit live `(4,2)` carrier
realization and its composition with the selector-obstruction spine.
`ChannelPositiveComplementDisk` is also LANDED: every positive even
self-adjoint vector orthogonal to the three named even channels has a unique
nonzero scale and rational open-disk coordinate; every disk point gives a
distinct positive four-coordinate family containing those channels. The strict
interior and null unit-circle controls are exact. This is a complete moduli
theorem for that positive-complement problem, but still not the missing
refinement-level carrier/gauge equivalence relation or a physical selector.

## Scientific question

Classify the decompositions of a finite null-edge carrier square that are
compatible with its adjoint, chirality, edge structure, locality, positivity,
and coarse-graining, and determine which additional principles select the
aperture/closure/turn/solder presentation uniquely up to the stated physical
equivalences.

The tension is already kernel-checked:

- `CarrierRigidity.square_decomposition` expands the chosen carrier square
  exactly into aperture, closure, soldering, and turn terms. There is no
  unaccounted algebraic remainder in that expansion.
- `CarrierRigidity.parity_decomposition_unique`, `square_oddPart`, and
  `square_evenPart` show that chirality canonically fixes only the coarse split:
  soldering is odd, while aperture, closure, and turn share the even sector.
- `CarrierRigidity.Concrete.shared_type_but_distinct` and
  `NullEdgeCloser.split_not_forced` prove that adjoint/chirality type and block
  count alone do not select a unique four-way refinement.
- `FourChannelRigidity.four_channels_linearIndependent` and
  `carrier_square_coefficients_recovered` prove that the explicit rational
  witness is coefficient-rigid once its coordinate/support selectors are
  supplied.

Thus the classification problem is not whether the displayed expansion is an
identity. It is which refinements of the canonical even sector count as the
same decomposition, what their moduli are, and which naturality requirements
select a preferred orbit.

## Candidate paper

Working title:

**Moduli and Selector Obstructions for Channel Decompositions in Finite
Krein--Dirac Carriers**

Headline target:

> Chirality fixes a unique odd/even carrier-square split but leaves a moduli
> space of even-sector refinements; every commutator-blind scalar linear
> selector collapses to trace, while stronger locality, positivity, and
> information principles either select the four physical channels or expose a
> precise residual ambiguity.

This reframes portfolio Paper F. Positive Hodge theory, decoder positivity, and
information monotonicity are candidate selectors within the classification,
not disconnected theorem collections.

## Objects and equivalence

A classification theorem must define these before enumerating examples:

1. A `CarrierDatum` containing the finite module, adjoint, chirality, soldering
   directions, transports, turn field, and square.
2. A `ChannelDecomposition` of the square into finitely many components with
   declared parity, adjoint type, word/solder degree, and edge-exchange type.
3. An equivalence relation generated by carrier isomorphisms, gauge changes,
   edge relabelings, and changes of channel coordinates that preserve every
   declared selector.
4. A forgetful map that drops selectors. Its fibers are the decomposition
   moduli spaces.
5. A naturality notion under restriction, disjoint union, refinement, and
   coarse-graining.

Without these definitions, a list of alternative matrix sums is not a
classification.

## Theorem ladder

### F0. Semantic normal form

Restate the existing square identity as an exhaustive word-source expansion,
while explicitly separating this from uniqueness of a named decomposition.
Prove a nonzero concrete witness for every displayed channel.

### F1. Type-only moduli

Classify refinements allowed by adjoint and chirality alone. The expected
result is that the odd component is unique, while the three named even
components can be changed by an explicit family of invertible coordinate
transformations preserving their sum. Exhibit a continuous rational
one-parameter family and prove when two members are inequivalent under the
chosen equivalence relation.

Status: type-only affine fibre CLOSED. `ChannelRefinementTorsor` proves that,
after choosing a base refinement, the complete fixed-total fibre is equivalent
to the additive group of zero-sum admissible shifts, and packages it as an
`AddTorsor` with free and transitive translation plus a nonzero-direction
nonuniqueness theorem.
`ChannelShearModuli` supplies an explicit faithful determinant-one rational
subgroup. The selector-preserving physical quotient remains open.

### F2. Joint-selector decomposition

Introduce the extra selectors suggested by the current algebra:

- chirality parity isolates soldering;
- solder/word degree separates turn from the two-solder terms;
- edge exchange separates symmetric aperture from antisymmetric closure.

Prove that commuting involutions or idempotent projectors yield a unique joint
eigenspace decomposition, and instantiate the theorem on the live carrier.
If the selectors fail to commute or fail to be intrinsic, return that exact
obstruction rather than calling the basis canonical.

Status: conditional uniqueness CLOSED. `ChannelSelectorUniqueness` proves that
two internal decompositions carrying the same pair of sign gradings coincide,
by combining the gradings into four distinct eigenvalues. Deriving a physically
intrinsic second grading remains open.

The algebraic criterion is also CLOSED. `ChannelSelectorRigidity` proves that
an additive selector rigidifies the complete fixed-total fibre exactly when it
is injective on zero-sum shifts. A nonzero rational-module ambiguity contains
an injected copy of `Q`, so no finite-valued additive selector can rigidify it.
This leaves infinite-valued physical invariants and justified quotient data as
the serious selector candidates.

The representation criterion is also CLOSED at generic scope.
`ChannelSelectorDescent` proves that kernel preservation is always necessary
for descent and is sufficient with a unique result when the evaluation is
surjective. `ChannelSolderDegreeNoGo` closes the first live instantiation
negatively: `P = c1 * c1#` is nonzero and idempotent, so a degree-two word and
its degree-four square coincide after evaluation. Therefore no additive map on
the represented carrier can read raw solder degree consistently. This is an
enabling quotient theorem plus an exact carrier-specific kill, not the
still-missing surviving selector; edge exchange, locality, positivity, or an
information monotone must now face the same full-kernel test.

The first infinite-valued represented selector is also CLOSED negatively.
`ChannelTraceSelectorNoGo` constructs an explicit nonzero trace-zero shear and
proves that the componentwise trace profile does not rigidify any fixed-total
fibre. Trace is therefore an honest intrinsic invariant but an incomplete
selector. This distinguishes failure by presentation dependence (solder
degree) from failure by residual moduli (trace).

### F3. Orbit and invariant classification

Classify decompositions modulo gauge, edge permutation, and carrier
isomorphism. Candidate invariants include component ranks, adjoint signatures,
support patterns, spectra, positive cones, commutants, and intersection data.
Give at least two inequivalent nondegenerate carriers and one equivalence
control.

### F4. Physical naturality

Test locality, causal-support preservation, checkerboard compatibility,
reflection/physical positivity, and covariance under soldered frame changes.
Determine which conditions remove which moduli. A uniqueness theorem must state
the minimal sufficient set; a no-go must exhibit multiple inequivalent
decompositions satisfying every tested condition.

Status: the maximal-symmetry no-go is CLOSED. `ChannelNaturalityNoGo` proves
that every score invariant under the full zero-sum translation torsor is
constant, and that no invariant predicate can uniquely prefer a refinement
when the retained type space has a nonzero direction. Thus a successful
physical selector must break this residual symmetry or justify a smaller
equivalence quotient; complete type-only invariance cannot select the named
channels.

The componentwise trace profile provides a less extreme physical control: it
is not invariant under every zero-sum shift, but it is still blind to an exact
nonzero trace-zero shear. Thus even a standard conjugation-invariant spectral
summary leaves residual moduli.

### F5. Information-theoretic naturality

Classify refinements whose aperture component is a faithful null-direction
resource monotone, whose closure component records gauge-invariant loop data,
and whose allowed coarse-grainings obey a displayed data-processing or
monotonicity law. Compare the physically selected and information-selected
orbits. Agreement is a unification result; disagreement is a useful theorem
showing that the two interpretations require distinct extra structure.

Status: the scalar positive-quadratic selector family is CLOSED.
`ChannelQuadraticSelectorFamily` gives the sharp completion-of-squares identity,
the unique minimizer for every positive diagonal metric, and an exact pair of
positive metrics selecting different decompositions of the same total. The
remaining information-theoretic gate is to derive one metric from an intrinsic
resource monotone or data-processing law, then compare it with a physical
metric on the same nondegenerate carrier.

### F6. Refinement and RG naturality

Ask whether the selected channels transform functorially under graph
refinement and whether their span closes under the intended blocking map. If
blocking mixes the channels, classify the smallest closed effective coupling
space and identify the four-channel locus inside it.

## Publication gates

The negative-classification Paper F is earned when all of the following hold:

1. the category, decomposition object, and equivalence relation are explicit;
2. the type-only moduli space is classified, not merely witnessed;
3. one selector theorem gives necessary and sufficient conditions for a unique
   orbit, or a sharp no-go proves residual underdetermination;
4. at least two inequivalent nonzero examples and one boundary control are
   formalized;
5. the live descent, trace-factorization, positive-metric-dependence, and Krein
   signature obstructions are composed into one carrier-specific theorem chain;
6. every use of `exhaustive`, `unique`, or `canonical` names exactly which
   structure is retained.

The stronger positive-selection version additionally requires physical and
information-theoretic selectors to be derived and compared on the same
objects, with a displayed refinement/data-processing or stability law.

Likely venue lane: *Annales Henri Poincare* for a general invariant
classification with stability, or *Journal of Mathematical Physics* / *Journal
of Physics A* for a finite operator-algebra classification. A finite list of
matrix witnesses remains supporting material, not a paper.

## Kill outcomes

- If every reasonable selector leaves a large moduli space, publish the exact
  underdetermination theorem and stop calling the four names canonical.
- If physical and information selectors choose inequivalent decompositions,
  separate the two dictionaries rather than claiming one unification.
- If uniqueness follows only after inserting coordinate readers equivalent to
  the desired answer, record that circularity as a no-go.
- If refinement necessarily generates more channels, replace four-channel
  closure by a classified effective channel algebra.

## Immediate actions

1. Treat raw solder degree as killed on the live concrete representation:
   `ChannelSolderDegreeNoGo.no_additive_solder_degree_selector` is the required
   mixed-degree control. Retain it only on the universal homogeneous
   presentation, with that different target named explicitly.
2. Define the next channel-name-free candidates, beginning with edge exchange,
   locality/support, positivity, fuller spectral data, and information
   monotonicity, and test each
   against the full live evaluation kernel. A finite list of declared
   homogeneous relations is insufficient without a kernel-generation theorem.
3. Require nonzero represented words in distinct selected sectors and a
   deliberately non-homogeneous selector control. This rules out the trivial
   identity selector and coordinate readers that encode the answer.
4. Define the quotient of the landed full affine fibre by a noncircular
   selector-preserving equivalence relation covering carrier isomorphism,
   gauge, and edge relabeling.
5. Define the carrier-level candidate second selectors without naming the
   desired channels in their definitions: word/solder degree and edge exchange
   are the first algebraic targets; locality and positivity are controls.
6. Instantiate `ChannelSelectorUniqueness` only after proving that a candidate
   selector is intrinsic, commutes with chirality on the retained sector, and
   has the required separated joint spectrum.
7. Give two inequivalent nonzero carriers and compare the orbits preferred by
   physical selectors with those preferred by information monotonicity and
   refinement naturality.
8. Prove the normalization bridge between the abstract `CarrierRigidity`
   square and the concrete `FourChannelRigidityCapstone` witness before using
   either as a universal classification example.

## Lean reference notes

The first Mathlib search found reusable infrastructure rather than a reason to
invent a local direct-sum API:

- `DirectSum.Decomposition` packages a constructive inverse to canonical
  recomposition and can represent a selected channel decomposition.
- `LinearMap.IsSymmetric.directSum_isInternal_of_commute` proves the internal
  direct-sum decomposition into simultaneous eigenspaces for a commuting pair
  of symmetric operators on a finite-dimensional inner-product space.
- `DirectSum.idempotent` and the `Submodule.IsCompl` projection lemmas provide
  the projector/idempotent language for selectors.

The live Krein setting is not automatically a positive-definite inner-product
space, so the simultaneous-symmetric theorem cannot be imported semantically
without first specifying the positive sector or proving an algebraic
commuting-idempotent analogue. That convention boundary is part of F2.

## Nearest-work boundary

The paper must confront three established neighboring moduli problems rather
than present affine quotients or Dirac-square decompositions as new in
themselves:

- Cacic, arXiv:0902.2068, classifies moduli spaces of Dirac operators for finite
  spectral triples. Our object is different only if we hold the carrier square
  fixed and classify its selector-compatible decompositions and equivalence
  orbits.
- Ackermann--Tolksdorf, hep-th/9503153 and hep-th/9612149, develop generalized
  Lichnerowicz/superconnection decompositions and an affine quotient of
  connections defining a fixed Dirac operator by the relevant kernel. Thus the
  generic kernel-descent theorem is enabling infrastructure, not a novelty
  claim.
- Yamaguchi--Mitsuhashi, arXiv:2411.04766, identifies a quantum geometric tensor
  as a complete asymmetry measure in a compact-group, finite-dimensional
  positive-Hilbert, pure-state i.i.d. conversion setting. It is a candidate F5
  selector only after those hypotheses are separately represented or rejected
  for the finite Krein carrier.

The defensible novelty target is therefore the carrier-specific relation
presentation, its selector-preserving decomposition moduli, and a proved
agreement or disagreement between physical and information-theoretic selected
orbits.
