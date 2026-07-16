# General Relativity and the Null-Edge Framework

**Status:** research note and reconstruction roadmap, updated 2026-07-16  
**Scope:** standard general relativity, causal reconstruction, finite null-edge
geometry, and the precise gap between the current formalization and a continuum
gravitational theory

## Abstract

The null-edge program starts from causal events, primitive null support, local
soldering data, and amplitudes or transports assigned to finite histories.
General relativity starts from a smooth Lorentzian metric whose null cones,
proper times, volume form, connection, and curvature are dynamical. The two
descriptions meet at a sharp reconstruction problem.

The strongest established bridge is kinematical. Causal structure determines
the continuum conformal geometry under standard causality hypotheses, while a
volume element fixes the missing conformal scale. Sums of noncollinear null
displacements become timelike and acquire positive endpoint proper time; sums
of noncollinear null momenta become timelike and acquire invariant mass. The
same Lorentzian cross terms underlie both facts.

The current null-edge formalization adds finite coframes, local-frame
covariance, induced metrics, transport defects, holonomy, Clifford soldering,
and exact Dirac-square decompositions. It also contains finite variational,
thermodynamic, spectral, and teleparallel avatars of gravitational equations.
These are useful algebraic tests, but they do not yet derive the Einstein
equation, a continuum tetrad, Newton's constant, or gravitational backreaction.

This note separates established general relativity, machine-checked finite
identities, conditional reconstructions, and conjectural dynamics. It now
selects one primary completion architecture:

> Causal order and counting define a normalized causal wave operator. Its
> corrected principal symbol reconstructs the full metric; coframes and spin
> connections are gauge-relative lifts of that metric; and an interval-count
> action is the primary candidate for Einstein dynamics. Spectral,
> thermodynamic, and teleparallel constructions remain comparison routes and
> controls, not independent fundamental gravities.

This decision removes competing scale fields and competing curvature actions.
It does not remove the main theorem debts: the wave operator, probe sector,
manifoldlike phase, connection, and effective action must still be derived and
shown to converge from order and number.

## Claim notation

This note uses the program claim calculus.

- **T [import]**: established continuum mathematics or physics, with a source.
- **T|H [interp]**: a theorem conditional on displayed reconstruction
  hypotheses, with a null-edge interpretation.
- **M [orig]**: machine-checked finite identity internal to this repository.
- **C [orig]**: conjectural bridge with a stated success criterion and kill
  condition.

No claim labelled **M** is thereby a theorem about continuum general
relativity.

## 1. What general relativity requires

General relativity is not merely the statement that matter follows curved
paths. Its kinematical datum is a Lorentzian metric \(g\) on spacetime. With the
project's mostly-minus convention,

\[
  ds^2 = g_{\mu\nu} dx^\mu dx^\nu,
  \qquad \operatorname{sign}(g)=(+,-,-,-).
\]

The metric determines three local classes of displacement:

\[
  ds^2>0 \text{ timelike},\qquad ds^2=0 \text{ null},\qquad
  ds^2<0 \text{ spacelike}.
\]

For a timelike worldline, proper time is

\[
  d\tau = \frac{1}{c}\sqrt{g_{\mu\nu}dx^\mu dx^\nu}.
\]

The metric also determines the Levi-Civita connection, geodesics, curvature,
and the volume element. Dynamics are supplied by the Einstein equation

\[
  G_{\mu\nu}+\Lambda g_{\mu\nu}
    = \frac{8\pi G}{c^4}T_{\mu\nu},
  \qquad
  G_{\mu\nu}=R_{\mu\nu}-\frac12 Rg_{\mu\nu}.
\]

A null-edge framework has therefore not recovered general relativity until it
can account for all of the following:

1. causal and conformal structure;
2. local scale and volume;
3. a nondegenerate coframe or metric;
4. covariant transport and local Lorentz symmetry;
5. curvature and, if present, torsion or nonmetricity;
6. a conserved matter source;
7. a dynamical law equivalent to Einstein's equation in a controlled limit;
8. Newton's constant, the cosmological term, and boundary conditions;
9. a continuum or ensemble limit with acceptable Lorentz behavior.

The present project has finite pieces of items 3-6 and algebraic avatars of
item 7. Items 7-9 remain open as physical reconstruction theorems.

## 2. Null propagation and aggregate proper time

### 2.1 Primitive null segments

A null segment satisfies \(ds^2=0\). Its proper-time length is zero. A finite
piecewise-null path also has zero proper time on each open segment, and an
idealized corner has no duration of its own.

Positive proper time can nevertheless appear at the level of the net
displacement. This is not a sum of microscopic null proper times. It is the
Lorentzian norm of a coarse-grained displacement connecting the endpoints.

### 2.2 Exact null-tick formula in 1+1 dimensions

Let a history contain \(N_+\) right-moving and \(N_-\) left-moving null steps,
each of coordinate duration \(\varepsilon\), and set \(c=1\). Then

\[
  t=\varepsilon(N_++N_-),\qquad
  x=\varepsilon(N_+-N_-).
\]

The endpoint interval is

\[
  \tau^2=t^2-x^2=4\varepsilon^2N_+N_-,
  \qquad
  \tau=2\varepsilon\sqrt{N_+N_-}.
\]

Consequently,

\[
  v=\frac{x}{t}=\frac{N_+-N_-}{N_++N_-},
  \qquad
  \frac{\tau}{t}=\sqrt{1-v^2}=\frac1\gamma.
\]

This is **T [import]**, elementary special-relativistic kinematics. It supports
four precise statements.

- A history supported in only one null direction remains null.
- Occupation of both directions makes the endpoint separation timelike.
- For fixed coordinate duration, balanced occupation gives maximal proper
  time.
- Increasing directional bias increases coordinate ticks per unit proper time
  by the Lorentz factor \(\gamma\).

The endpoint formula, the exact \(\tau^2=t^2(1-v^2)\) identity, its
null/timelike dichotomy, the coordinate-time bound, and saturation exactly at
\(N_+=N_-\) are also **M [comp]** in `NullTickProperTime.lean`, with a nonzero
balanced two-tick witness. This is a machine-checked formalization of standard
kinematics, not a new physical law.

The formula depends on the populations \(N_+\) and \(N_-\), not on their order.
One reversal and many reversals can connect endpoints with the same proper
time. Corner count is a dynamical history statistic, not the definition of
proper time.

### 2.3 Momentum-space analogue

For an on-shell free particle,

\[
  E^2=p^2c^2+m^2c^4,
  \qquad
  v=\frac{pc^2}{E},
  \qquad
  \frac{d\tau}{dt}=\frac{mc^2}{E}.
\]

In units \(c=1\),

\[
  \left(\frac{p}{E}\right)^2
   +\left(\frac{m}{E}\right)^2=1.
\]

Thus the massless limit has \(v=1\) and \(d\tau/dt=0\), while the rest frame
has \(p=0\) and \(d\tau/dt=1\). This is a useful kinematic dictionary, but it
must not be reified as a literal Euclidean motion "through time."

For future-directed null momenta \(k_i\), their sum satisfies

\[
  P=\sum_i k_i,
  \qquad
  P^2=2\sum_{i<j} k_i\mathbin{\cdot}k_j.
\]

Collinear null momenta keep \(P^2=0\); noncollinear support can give \(P^2>0\)
and hence an invariant mass. The position-space and momentum-space statements
have the same Lorentzian form:

\[
  \boxed{\text{proper time} = \text{timelike norm of aggregate displacement}},
\]

\[
  \boxed{\text{mass} = \text{timelike norm of aggregate momentum}}.
\]

In the current manuscript, the noncollinearity is refined through the
spinorial exterior product. The Pluecker area determines a finite odd rest
operator and turn gate. The defensible dependency is therefore

\[
  \text{noncollinear null data}
  \longrightarrow \text{area and timelike norm}
  \longrightarrow \text{mass operator}
  \longrightarrow \text{turn amplitude}.
\]

Turns enact the mass coupling; they are not yet proved to create its absolute
scale.

### 2.4 Curved proper time must be reconstructed locally

The endpoint norm in Section 2.2 does not extend to one global norm for an
arbitrary curved trajectory. A viable curved construction partitions a null
history into mesoscopic blocks, transports the null displacements in each
block to one reconstructed local frame, and defines

\[
  V_b^I=\sum_{r\in b}U_{b\leftarrow r}{}^I{}_J\ell_r^J,
  \qquad
  \tau_C[\gamma]=\sum_b\sqrt{\eta_{IJ}V_b^IV_b^J}.
\]

A block with only one collinear null direction contributes zero; mixed
directions can produce a timelike aggregate. Conditional on
\(V_b^I=e^I{}_{\mu}\Delta x_b^\mu+o(L)\), refinement gives the usual path
integral of proper time. This is a **C [orig]** reconstruction target, not a
current theorem. It corrects the tempting but false idea that curved
proper time is determined by one global endpoint norm.

## 3. Causal order gives conformal geometry, not scale

The most important reconstruction discipline is the order-scale split.

### 3.1 The order half

Under standard causality hypotheses, continuum causal structure determines
topological, differentiable, and conformal information. The relevant primary
anchors are Hawking-King-McCarthy and Malament. The conclusion needed here is
not that a finite graph automatically supplies a metric. It is that a suitable
continuum causal relation determines the metric only up to local Weyl rescaling:

\[
  g_{\mu\nu}\sim \Omega^2(x)g_{\mu\nu}.
\]

This is **T [import]**, with hypotheses. It gives the light cones but not rods,
clocks, volume, or curvature scale.

### 3.2 The scale half

If

\[
  g_{\mu\nu}=\Omega^2\bar g_{\mu\nu}
\]

in \(d\) dimensions, then

\[
  \sqrt{|g|}\,d^dx=\Omega^d\sqrt{|\bar g|}\,d^dx.
\]

A local volume measure therefore fixes the missing conformal factor. In causal
set language, number can approximate volume,

\[
  N(R)\approx \rho\,\operatorname{Vol}(R),
\]

when a density \(\rho\) and a manifold approximation are supplied. This is the
content behind the useful slogan "order plus number equals geometry."

The scale recovery can be written exactly. Let \(\bar g\) be any representative
of the causally reconstructed conformal class in dimension \(d\), and suppose
the counting limit supplies a smooth positive measure \(d\mu\). Define

\[
  r(x)=\frac{d\mu}{d\operatorname{Vol}_{\bar g}}(x),
  \qquad
  \Omega(x)=r(x)^{1/d},
  \qquad
  g=\Omega^2\bar g.
\]

Then

\[
  d\operatorname{Vol}_{g}
    =\Omega^d d\operatorname{Vol}_{\bar g}
    =d\mu.
\]

The positive \(\Omega\) is unique. Thus, **T|H [interp]**, a recovered causal
relation plus a recovered smooth volume measure determines a unique Lorentzian
metric, provided the continuum causality and manifold-approximation hypotheses
hold. The hard null-edge problem is proving that its order and counts have
exactly such a joint limit.

For the null-edge program, two scale mechanisms are logically possible:

1. **counting scale:** event or interval counts reconstruct local volume;
2. **decoration scale:** the Gram data of a soldering coframe supplies local
   lengths and volume.

The framework must say whether these are equivalent, complementary, or
redundant. Using both independently would double-count scale. A serious
reconstruction theorem should prove that the decorated Gram volume agrees
asymptotically with the counting volume, or should select one as primitive.

### 3.3 What a bare causal graph does not supply

A bare partial order does not canonically produce:

- a finite null tetrad at each event;
- a preferred spatial direction;
- a fixed finite-valency nearest-neighbor graph;
- a spin structure;
- a connection or curvature tensor;
- an absolute discreteness scale;
- the Einstein equation.

The no-preferred-direction result for Poisson sprinklings is especially
important: a Lorentz-equivariant measurable rule cannot extract a spacetime
direction from a sprinkling, and a finite-valency graph cannot be attached in
that manner. Any local null frame must therefore be decorated, gauge-relative,
statistical, or reconstructed by an additional theorem.

### 3.4 Selected operator-first metric architecture

The most promising completion supplied by the new analysis is to derive the
metric from a causal scalar operator rather than from a preferred coframe.
Let the physically normalized finite operator \(\widehat B_C\) have a proposed
continuum limit

\[
  \widehat B_C f \longrightarrow Lf=\Box_g f+Vf.
\]

For the standard curved-spacetime causal-set d'Alembertian, the expected scalar
term is \(V=-R/2\). Generalized nonlocal kernels and the newer local proposal
should be treated as alternative implementations of a common convergence
interface, not as simultaneously fundamental operators.

Define the corrected carre du champ

\[
  \boxed{
  \Gamma_C(f,h)=\frac12\left[
    \widehat B_C(fh)-f\widehat B_Ch-h\widehat B_Cf
      +fh\widehat B_C1
  \right].}
\]

The final term is load-bearing. If \(L=\Box_g+V\), then the scalar-potential
contributions cancel exactly, while the second-order product rule gives

\[
  \Gamma_L(f,h)=g^{\mu\nu}\partial_\mu f\,\partial_\nu h.
\]

This exact algebraic statement is now machine checked as **M [comp]** in
`CausalOperatorMetric.lean`: the corrected pairing is symmetric, annihilates
constants, is invariant under adding any multiplication operator
\(f\mapsto Vf\), and reduces to a supplied metric pairing under the normalized
second-order product rule. The same module now proves that four supplied limits
on \(1,f,h,fh\) transport through the corrected pairing, and identifies the
limit with the metric cross term when the limiting operator is
\(\Box_g+V\). The causal-set application remains **C [orig]** because those
joint product limits are premises, not consequences of the finite order.

The arbitrary-operator boundary has now been narrowed by
`FiniteCausalOrderOperator.lean`. From a supplied finite strict causal order it
constructs open intervals, interval-count past layers, the exact local
four-dimensional Benincasa-Dowker coefficients, and the broadened smeared
kernel. It proves event-relabeling covariance, exact source-to-project sign
conversion, inverse-square scale covariance, same-scale local reduction, and
the corrected pairing directly on finite scalar fields. A two-event witness
shows that the layer sum is not vacuous. These are **M [comp]** finite
identities, not a derivation of dimension four: the coefficient family is
selected from the four-dimensional continuum target, while the microscopic
and nonlocality scales remain supplied.

The same module now records the next convergence interface without fixing one
carrier across refinement. An `IntrinsicProbeSector` is a supplied finite
probe family natural under every finite order isomorphism, and
`tendsto_intrinsicProbePairing_projectSmeared4D` transports six independent
scalar limits across varying finite carriers to the corresponding corrected
pairing limit. The target is constructed algebraically from those limits; it
is not named or assumed to be a metric. Existence of a nontrivial slowly
varying intrinsic selector, convergence of its operator evaluations, and the
rank/signature gate remain open.

There is also an exact finite warning about the interface itself. The current
`IntrinsicProbeSector` asks each named probe to be individually natural under
every order isomorphism. The checked theorem
`probe_constant_of_automorphismTransitive` shows that this forces every such
probe to be constant on an automorphism-transitive order; a two-event antichain
is an explicit nonvacuous witness. A physical cotangent estimator must therefore
transport a probe **subspace** or quotient up to basis change. It cannot demand
a canonical pointwise-fixed ordered frame from the bare order.

At finite density, arbitrary functions on the event set are too numerous and
too noisy to serve as cotangent probes. A mesoscopic region must supply a
basis-free slowly varying sector \(\mathcal H_D\), for example through low
singular modes of a filtered operator after boundary-dominated modes are
removed. For probes \(f_A\in\mathcal H_D\), form

\[
  G_{AB}(x)=\Gamma_C(f_A,f_B)(x).
\]

The decisive four-dimensional manifoldlikeness gate is a stable rank-four
image with one positive and three negative directions over a nontrivial range
of mesoscopic scales. The quotient

\[
  T_x^*C=\mathcal H_D/\ker\Gamma_C(x)
\]

is then a finite cotangent estimator. Choosing four probe functions is only a
coordinate gauge; no preferred tetrad is selected from the sprinkling.

The normalization of \(\widehat B_C\) carries inverse-length-squared units, so
the operator route can contain the same count calibration that normalizes
volume. The reconstructed metric volume must still satisfy the independent
consistency test

\[
  \int_D\sqrt{|g_C|}\,d^4X\simeq \ell^4|D|.
\]

This avoids two local scale fields, but it does not derive an absolute unit
from a bare order: the value of \(\ell\), or one equivalent positive anchor,
remains supplied. The existing relative scale theorems therefore remain useful
as normalization and no-double-counting audits.

### 3.5 Executable Stage A calibration

`Scripts/experiments/causal_operator_metric.py` now implements the local and
smeared four-dimensional Benincasa-Dowker operator on a conditionally sprinkled
Minkowski diamond and evaluates the corrected pairing on known compactly
supported coordinate probes. This is an external calibration oracle, not an
intrinsic reconstruction: coordinates are used to define the sprinkling and
probe fields, while the operator row uses only causal order, interval counts,
density, and a supplied nonlocality scale. The source `(-+++)` operator is
explicitly sign-converted to the project `(+---)` convention.

The first benchmark found a genuine finite scale window. With probe-support
radius `0.5`, \(N=5000\), and 20 realizations, the ensemble-mean metric error
was `0.387` at \(L_k=0.14\) and `0.424` at \(L_k=0.16\); the latter had lower
per-sprinkling error because of stronger smoothing. At fixed \(L_k=0.16\), the
correct-signature frequency rose from 43% at \(N=1000\) to 95% at
\(N=10000\), while mean per-sprinkling error fell from `2.386` to `0.723`.
Affine probe covariance held to floating-point roundoff.

This is useful positive evidence for the operator route, but it also exposes
the next debt. The metric depends materially on the embedding-defined support
cutoff, and decreasing \(L_k\) improves bias while reviving fluctuations. The
new finite Lean construction now agrees with the order/count operator used by
this oracle at the formula level; it does not internalize the oracle's
sprinkling, coordinate probes, support cutoff, or stochastic convergence. A
basis-free order-derived probe sector and a pre-registered two-scale selection
or averaging rule are required before this counts as metric reconstruction.
Full parameters, outputs, and kill conditions are recorded in
`AgentTasks/null-edge-causal-operator-metric-stage-a-benchmark-2026-07-15.md`.

### 3.6 Intrinsic-probe Stage A2 kill result

`Scripts/experiments/causal_intrinsic_probe_metric.py` now removes coordinates
from the construction of probe values and tests three order-derived sectors:
leading causal-profile modes, raw lowest right-singular modes of the full
smeared operator, and profile modes filtered by its normal operator. Coordinates
choose the marked calibration event and score the probes afterward; they do not
enter any of the three probe formulas.

All three selectors pass their finite intrinsicity controls. Random event
relabeling changes their subspace projectors only at approximately `1e-15` to
`2e-14`, and the corrected pairing retains affine probe covariance to numerical
roundoff. Nevertheless, at fixed nonlocality scale (L=0.18), none of 52
realizations over (N=400,800,1200) passes the joint signature, affine-fit, and
metric-error gate. Profile modes become more locally affine with density but
their pairing does not converge to the fitted Minkowski metric; raw low
singular modes remain non-coordinate-like with very large pulled errors; and
the simplest normal-operator filter repairs neither defect.

This is a **kill result for those three selectors**, not for the corrected
operator architecture. It shows that label invariance and low spectral cost are
not sufficient definitions of a physical probe sector. The next admissible
prototype must combine an intrinsic two-sided interior projector, explicit
retarded support, scale-stable four-dimensional subspace clustering, and a
held-out product-rule or graph-Sobolev score. Full methods and outputs are in
`AgentTasks/null-edge-intrinsic-probe-stage-a-benchmark-2026-07-15.md`.

### 3.7 Interval-volume Stage A4 conditional reconstruction

`Scripts/experiments/causal_johnston_probe_metric.py` clean-room implements the
lightcone factorization of Johnston's interval-volume causal-set embedding
(arXiv:2111.09331v2). Inclusive interval counts estimate timelike proper
times; endpoint polarization supplies intrinsic time; and a past-by-future
spatial-inner-product matrix supplies spatial probes by SVD. The construction
uses no embedding coordinates to select the marked event or construct probe
values. It does, however, take dimension, density, interval endpoints, and the
rank-three spatial truncation as hypotheses.

This literature-grounded replacement is substantially better than the killed
Stage A2 selectors. Over ten frozen realizations at each density, median local
affine-fit error falls from `0.549` at \(N=1000\) to `0.083` at \(N=10000\),
with relabeling and probe-gauge errors at floating-point roundoff. At
\(N=10000\), the median Johnston pulled-metric error is `0.710`, close to the
coordinate-probe control error `0.677`. Thus the interval-volume chart is no
longer the dominant error source at the highest tested density.

The result remains conditional and does not pass G2. The coordinate control
itself has zero passes under the frozen per-realization error threshold `0.50`.
Moreover, the largest singular-value gap selects spatial rank four or five,
never rank three, in all 40 realizations over
\(N=1000,2500,5000,10000\). Dimension four is therefore supplied rather than
reconstructed, absolute scale still comes from density, and count-volume
agreement remains open. Full gates, samples, and provenance are recorded in
`AgentTasks/null-edge-johnston-probe-stage-a4-benchmark-2026-07-15.md`.

### 3.8 Stage A5 operator-control isolation

A coordinate-only development scan at the same order-selected pivots tested
15 frozen `(L,support)` settings at \(N=5000\), without constructing Johnston
spatial probes. Every setting had zero passes under the per-realization
signature-plus-error gate. The fixed selection rule chose `L=0.18` and support
radius `0.65` as the best failed control, with median error `0.741` and 80%
Lorentzian signatures.

On an independent ten-realization \(N=10000\) seed, that setting again has zero
control passes: coordinate probes have median error `0.665` and 90% Lorentzian
signatures. Johnston probes have median pulled error `0.729`, 100% Lorentzian
signatures, and median affine-fit error `0.075`. The probe chart therefore
survives a held-out comparison, while the flat operator control does not.

There is a weaker aggregate shape signal. Multiplying the held-out
ensemble-mean coordinate pairing by its target-fitted best positive scalar
`2.427` reduces relative error from `0.615` to `0.224`. This fitted scalar is
not an admissible scale reconstruction, and the median individually rescaled
error remains `0.570`. The result isolates both an absolute normalization
deficit and insufficient eventwise concentration. Weak-curvature tests should
wait until those flat-space debts are repaired. Full outputs and the blinded
protocol are in
`AgentTasks/null-edge-johnston-operator-stage-a5-benchmark-2026-07-15.md`.

### 3.9 Stage A6 intrinsic quadratic-normalization kill

The Stage A5 scale deficit is not a missing Benincasa-Dowker coefficient. A
primary-source audit confirms equations (2), (8), and (9), and the earlier
`sd(B1)=132.5` at `N=5000`, `L=0.16` closely reproduces the source simulation
value `134.8`.

There is an exact order-side normalization proposal. For centered probes,
twice the corrected pairing equals the operator response on their product.
Consequently, a valid quadratic probe should obey `Bq=2d=8` in four flat
dimensions. The centered-product identity is now kernel-checked in
`FiniteCausalOrderOperator.operator_mul_eq_two_correctedPairingAt_of_centered`.
Interval counts, endpoint-volume time, and the squared compact cutoff define a
relabeling-equivariant candidate `q_C` without opening target metric values.

That candidate fails. All 15 frozen `N=5000` development settings have zero
normalized gate passes. At the selected best failure, `L=0.14` and support
`0.36`, normalization is defined in only 50% of samples and worsens median
error from `0.836` to `1.230`. On an independent `N=10000` seed it is defined
in 70%, worsens `0.831` to `1.032`, and again has zero passes. Mean `Bq_C` is
`0.908` and `0.858` rather than eight. This kills the single-interval
endpoint-volume estimator, not the exact quadratic-moment identity. Full
results are in
`AgentTasks/null-edge-intrinsic-quadratic-normalization-stage-a6-benchmark-2026-07-15.md`.

### 3.10 Stage A7 validated quadratic, failed trace normalization

The Johnston chart supplies a better quadratic moment than one noisy interval
count. Its compact Lorentzian scalar
`q_J=t_J^2-\lVert x_J\rVert^2` is invariant under the unresolved spatial
orthogonal gauge and event relabeling. It was validated before opening any
operator score. At frozen support `0.65` and `N=10000`, all ten held-out
samples pass the `0.25` full-support and inner-germ gate; median overall error
is `0.095`, median inner error `0.121`, correlation `0.991`, and norm ratio
`0.987`. This is a positive conditional reconstruction result.

The downstream scale proposal does not survive. A new `N=10000` development
ensemble selected `L=0.18` for the factor `a_J=8/Bq_J`. On the final held-out
seed, coordinate-oracle median error worsens from `0.661` to `0.743` and
Johnston pulled error worsens from `0.683` to `0.799`. Only 20% of coordinate
controls and none of the Johnston metrics pass. The quadratic is accurate, but
a scalar trace condition cannot repair the remaining anisotropy and
off-diagonal fluctuations. Spatial rank also remains imposed: the dominant gap
selects four or five, never three.

Retain `q_J` as an intrinsic scalar. Kill single-row trace rescaling as scale
reconstruction. The next flat gate is an order-side multi-row conformal metric
average or fit, followed only then by trace normalization and count-volume
comparison. Full staging and outputs are in
`AgentTasks/null-edge-johnston-quadratic-normalization-stage-a7-benchmark-2026-07-15.md`.

### 3.11 Stage A8 found sparse averaging gain, not a stable metric

Stage A8 evaluates several nearby retarded operator rows on one common
Johnston chart before averaging their corrected pairings. Candidate targets
are selected from the pivot's strict past by recovered chart radius; the pivot
is always included and there is no label-dependent cap. Development keeps the
Johnston metric scores closed, scores coordinate-control conformal shape first,
and only then applies the independently validated centered Johnston quadratic
trace. The exact rowwise identity
`B_y q_{J,y}=2 eta_ab Gamma_y(P^a,P^b)` holds to machine precision.

The order-only availability audit gives median row counts `4`, `10`, `21.5`,
`36`, and `61.5` at radii `0.10`, `0.125`, `0.15`, `0.175`, and `0.20` for
`N=10000`. Development selects radius `0.10`, with a median of four rows. On a
fresh held-out seed, coordinate conformal-shape and trace-normalized pass rates
are `50%` and `40%`; the pulled Johnston rates are `30%` and `20%`, with median
errors `0.569` and `0.709`. A same-sprinkling diagnostic shows a real but
incomplete gain over the pivot alone: Johnston conformal median error improves
from `0.755` to `0.569`, and trace-normalized error from `1.151` to `0.709`.

This does not close the `0.50` gate. Raw pulled error slightly worsens, and
larger one-sided neighborhoods fail sharply: at radius `0.15` and above every
development coordinate average is negative definite while the median
quadratic response collapses toward zero. Retain sparse averaging as evidence
that part of the single-row failure is variance. Kill simple broad averaging
over the pivot's strict past. A successor needs a genuinely two-sided interior
chart, a finite-window correction, or a row-bias regression before curved
benchmarks. Full results are in
`AgentTasks/null-edge-johnston-multirow-metric-stage-a8-benchmark-2026-07-15.md`.

### 3.12 Stage A9 closes the flat operator control, not chart covariance

Stage A9 implements Johnston's 2025 simultaneous full-interval embedding. From
supplied dimension, density, and endpoints, inclusive interval counts define
causal-pair spatial distances; a one-anchor min-plus completion fills
spacelike distances; and Euclidean MDS embeds every event at once. This permits
a genuinely two-sided target ball containing strict-past, strict-future, and
spacelike events. The construction is event-relabeling covariant and uses no
sprinkling coordinates before scoring.

Closed `N=2500` development selects averaging radius `0.15` and
trace-after-average. Its median 260-row neighborhood is balanced in recovered
time and mostly spacelike to the pivot. On three fresh `N=4000` realizations,
all coordinate controls pass: median conformal-shape error is `0.234` and
Johnston-trace-normalized error is `0.398`. This is the first held-out closure
of both flat operator-control gates. It shows that the operator's earlier
failure was substantially a concentration and one-sided-window problem.

The full chart itself does not yet close the covariant metric gate. In its own
candidate coordinate basis, all three metrics have signature `(+---)`, all
conformal scores pass with median error `0.245`, and two of three trace scores
pass with median error `0.252`. But a local coordinate pullback gives only 67%
conformal passes and zero trace passes; median pulled trace error is `1.583`
and median local affine-fit error is `0.541`. The global MDS chart is locally
non-affine at the tested density. Its dominant spatial gap also selects rank
five in every tested realization, not the supplied rank three.

Retain two-sided averaging and the direct chart-basis result as conditional
evidence. Do not claim G2 closure. The immediate successor is an overlapping
local atlas with order-derived chart registration and cocycle tests, not a
larger global MDS. Equal-weight rowwise trace normalization is killed as
unstable. Full results are in
`AgentTasks/null-edge-johnston-full-chart-stage-a9-benchmark-2026-07-15.md`.

### 3.13 Stage A10 local charts work before their atlas transitions do

Stage A10 constructs a fresh Johnston lightcone chart at every target selected
by the two-sided Stage A9 carrier. Spatial frames are registered to the pivot
on their common order-derived events by `O(3)` Procrustes fits. Chart
availability, overlap size, pairwise residuals, and all available transition
cocycles are explicit prerequisites; Johnston metric scores stay closed if
they fail.

At `N=2500`, radius `0.075` gives median coordinate-control errors `0.299`
for conformal shape and `0.349` after intrinsic trace normalization, with 80%
passes for both. Nevertheless, median registration and cocycle residuals are
`0.530` and `0.274`, so the atlas pass rate is zero. An independent `N=4000`
transition-only test improves those medians to `0.274` and `0.052`; coordinate
controls have median errors `0.405` and `0.454`, but atlas passes remain zero
because one chart is unavailable and the other samples exceed the frozen
`0.25` registration threshold.

Changing the registration radius does not remove the residual. Exploratory
`GL(3)` and rotation-plus-scale fits do not help enough and worsen cocycle or
conditioning behavior, indicating nonlinear chart mismatch rather than a
simple gauge-group error. Retain the local row metrics and cocycle diagnostics.
Kill independent pairwise Procrustes registration at current finite density.
The next atlas gate should use simultaneous overlap synchronization with one
explicit global spatial gauge. Full results are in
`AgentTasks/null-edge-johnston-local-atlas-stage-a10-benchmark-2026-07-15.md`.

### 3.14 Finite metric-to-first-jet bridge

`PhysicsSM/Draft/NullEdge/CausalMetricFirstJet.lean` now isolates the next
finite algebraic bridge. For supplied matrices $g_{\mu\nu}$ and
$g^{\mu\nu}$, a supplied target first derivative $d_\nu F$, and corrected
operator pairings satisfying

\[
  g_{\mu\nu}g^{\nu\rho}=\delta_\mu{}^\rho,
  \qquad
  \Gamma_C(X^\nu,F)=g^{\nu\rho}d_\rho F,
\]

the guarded Lean theorem proves

\[
  \boxed{g_{\mu\nu}\Gamma_C(X^\nu,F)=d_\mu F.}
\]

It also proves that this recovered first jet is unchanged when an arbitrary
scalar zeroth-order potential is added to the causal operator. These are exact
**M [comp]** identities. They do not construct coordinates, prove that the
pairing has the required principal symbol, invert a noisy finite metric, or
solve the failed Stage A10 transition problem. Their gain is architectural:
after G2 supplies a covariant metric field and compatible probes, the first
derivative input needed by a connection construction is no longer a separate
postulate.

### 3.15 Stage A11 synchronization fixes gauge cycles, not chart geometry

Stage A11 replaces independent pivot registration by one simultaneous spatial
frame synchronization. It fits all available pairwise `O(3)` overlaps, solves
an overlap-weighted connection-Laplacian problem, projects each chart block to
`O(3)`, and fixes only one global gauge at the order-selected pivot. The
resulting transitions have cocycle residuals at floating-point roundoff.

That algebraic consistency does not close the atlas gate. On five development
realizations at `N=2500`, the selected registration radius `0.10` has complete
median chart availability and pairwise edge fraction `0.997`, but its median
synchronized overlap-geometry residual is `0.563`, compared with the
independently optimal `0.542`. On three fresh `N=4000` realizations, median
synchronization mismatch improves to `0.049` and median geometry residual to
`0.349`, while median chart availability is only `0.692`. The frozen pass rate
is zero.

This kills simultaneous frame synchronization as a sufficient repair for the
Stage A10 transition failure. It also localizes the problem: the remaining
mismatch is in the reconstructed local coordinates and chart availability, not
merely an unresolved orthogonal gauge. The next atlas successor must fit a
shared latent overlap geometry or change the local multi-anchor construction
before transported metric and curvature scores are reopened. Full results are
in
`AgentTasks/null-edge-johnston-synchronized-atlas-stage-a11-benchmark-2026-07-15.md`.

### 3.16 Stage A12 repairs availability but kills affine latent consensus

A forensic replay of the Stage A11 seed identified a separate selector defect.
The distorted global MDS neighborhood admitted apparent neighbors with only one
or two strict predecessors or successors, so their local lightcones could not
support spatial rank three. Stage A12 adds an order-only eligibility condition
requiring at least six strict predecessors and six strict successors before a
target enters the local atlas. On the diagnostic replay, median retention is
`0.692`, exactly exposing the previous availability loss; every retained chart
is available and the retained pairwise graph is complete. Keep this filter.

Stage A12 then fits every surviving chart into one pivot-anchored affine latent
geometry using leave-one-chart-out consensus. Unregularized development fits
reduce median geometry error from `0.508` to `0.400`, but never converge and can
collapse a spatial singular value to `0.016`. The only fully convergent setting
keeps condition near one but leaves geometry error at `0.508`.

On three fresh `N=4000` realizations, the frozen stable setting has 100% chart
availability, edge coverage, and optimizer convergence, with median maximum
condition `1.005` and affine cocycles near `2e-16`. Nevertheless, median
common-event geometry error is `0.446` and the atlas pass rate is zero. Kill
this affine latent consensus as a sufficient repair. The next construction
must alter the coordinates themselves, for example through a multi-anchor
interval embedding or joint spacetime factorization. Full results are in
`AgentTasks/null-edge-johnston-latent-affine-atlas-stage-a12-benchmark-2026-07-15.md`.

### 3.17 Finite Levi-Civita bridge from recovered metric jets

`PhysicsSM/Draft/NullEdge/CausalLeviCivita.lean` now applies the finite
coordinate-derivative theorem componentwise to a supplied metric field. Under
explicit corrected-principal-symbol hypotheses for every component, the
operator-recovered metric first jet equals a supplied target tensor exactly.

From such a first jet the same guarded module defines the standard Christoffel
coefficients. If the covariant and inverse metrics obey the displayed exact
inverse relation and the metric first jet is symmetric in its two metric
indices, lowering the raised coefficient recovers the first-kind symbol, the
second-kind coefficient is symmetric in its two derivative directions, and
the finite covariant derivative of the covariant metric vanishes. These are
**M [comp]** coordinate identities.

This closes an algebraic interface, not the reconstruction problem. Probe
existence, metric invertibility under noise, first-jet convergence, a smooth
atlas, and connection convergence remain open premises. In particular, Stage
A12 does not yet provide the common coordinate field needed to instantiate the
connection across neighboring events.

### 3.18 Stage A13 kills separate local full-MDS charts

Stage A13 changes the coordinate construction rather than fitting another
gauge. Around every retained target it selects count-derived past and future
endpoints at a supplied proper-time scale, restricts to their Alexandrov
interval, and reruns the full Johnston spatial-distance completion and MDS.
These local charts therefore use many anchors rather than the single
past-by-future factorization of Stages A10-A12.

The development scan shows a hard tradeoff. Small intervals have weak
availability and overlap. At anchor half-time `0.25`, median local carrier size
is `203.5` and both availability and edge coverage reach 100%, but median
synchronized geometry error is `1.219`, local affine-fit error is `0.777`, and
the median fraction selecting spatial rank three is only `0.083`.

On three fresh `N=4000` realizations, availability, edge coverage, and graph
connectivity remain perfect with median carrier size `320`. Nevertheless,
independently optimal overlap error is `1.074`, synchronized geometry error is
`1.153`, local affine error is `0.673`, and the median rank-three fraction is
zero. Both transition and full-atlas pass rates are zero.

Kill separate local full-MDS embeddings with independently selected endpoint
pairs. This does not kill multi-anchor reconstruction generally. The surviving
candidate is a joint spacetime factorization in which overlapping intervals
share event coordinates during optimization, rather than incompatible local
embeddings being registered afterward. Full results are in
`AgentTasks/null-edge-johnston-multi-anchor-atlas-stage-a13-benchmark-2026-07-15.md`.

### 3.19 Stage A14 kills direct shared partial-distance stress

Stage A14 gives every event in one count-derived central interval a single
spatial coordinate vector. It retains Johnston's order-derived time and
comparable-pair spatial distances, freezes disjoint causal and noncausal
training and held-out constraints, fits spatial ranks one through five, and
selects the smallest rank within one standard error of the best held-out
causal mean-square error. Sprinkling coordinates remain post-selection
controls only.

Development already gives zero factorization and geometry passes for all
three noncausal penalties. Under the frozen zero penalty, three fresh
`N=4000` realizations have median carrier size `383` and held-out causal
relative RMSE `0.190`, but all three select **four spatial dimensions**, the
median untouched-unrelated-pair violation fraction is `0.1025`, and median
affine error is `0.497` versus `0.113` for the Johnston initialization.
Factorization and geometry gate rates remain zero.

This kills direct weighted partial-distance stress, not shared-event
reconstruction generally. The result is an important discriminator: a good
held-out causal-distance score does not imply the correct dimension,
spacelike relation, or local affine geometry. The next reconstruction must
add an independent geometric conditioning principle. Madsen's 2026
well-conditioned-embedding and approximate-isometry result makes an
order-volume-chain conditioning audit and anchor scaffold the most natural
next target; it is a validation framework, not a supplied reconstruction
algorithm. Full results are in
`AgentTasks/null-edge-johnston-shared-factorization-stage-a14-benchmark-2026-07-15.md`.

### 3.20 Stage A15 separates manifold well-conditioning from tetrad extraction

Madsen's 2026 approximate-isometry theorem gives a more disciplined target
than another coordinate loss. Its well-conditioned embeddings require exact
order preservation (F1), a scale-dependent uniform count-volume law (F2), and
longest-chain proper time (F3). The associated anchor scaffold then supplies a
well-conditioned Lorentzian trilateration frame.

Stage A15 audits sampled flat versions of F1-F3 at proper-time scales `0.25`
through `0.40`. Five `N=2500` development realizations calibrate the single
dimensionless chain coefficient `1.05051433598341`. Three fresh `N=4000`
realizations use that value unchanged. All held-out realizations pass sampled
F1, F2, and F3: median count p90 error is `0.267`, chain-time p90 error is
`0.238`, and chain coefficient scale spread is `0.087`.

The project-specific tetrad extraction test fails independently. A Johnston
chart selects five anchors near Madsen's ideal offsets without consulting the
sprinkling coordinates. At the frozen scale, median causal coverage improves
to `0.969`, but normalized minimum singular value is only `0.162`, frame
condition number is `182.7`, and the scaffold pass rate is zero. The resulting
split verdict is important: the underlying flat sprinkling has positive
sampled manifoldlikeness and timelike-scale evidence, while the current
intrinsic map does not expose a stable coframe.

Retain the F1/F2/F3 benchmark as a manifoldlike-phase component. Kill
nearest-ideal-anchor selection in the distorted global Johnston chart. The
next tetrad candidate must optimize intrinsic trilateration conditioning
directly, with a frozen max-volume or minimum-singular-value criterion, before
metric controls are opened. Full results are in
`AgentTasks/null-edge-causal-well-conditioning-stage-a15-benchmark-2026-07-15.md`.

### 3.21 Stage A16 derives a conditioned frame, but not an affine tetrad chart

Stage A16 removes ideal-coordinate proximity from anchor selection. Around an
order-derived deep pivot it constructs a 12-event causal cross, requires one
lower and four upper anchors to bracket every cross event, and maximizes the
worst normalized minimum singular value across three nearby Johnston
lightcone charts. Dimension, density, endpoints, and the Stage A15 scale
remain supplied; sprinkling coordinates are opened only after selection.

This conditioning-first move repairs the specific Stage A15 frame defect. On
three fresh `N=4000` realizations, active causal coverage is exactly one, every
intrinsic frame passes, and every selected frame remains conditioned in the
known Minkowski coordinates. The median normalized minimum singular values are
`0.163` intrinsically and `0.167` in the oracle coordinates; median condition
numbers are `22.9` and `21.9`, compared with Stage A15's `182.7`.

The stronger tetrad-chart gate nevertheless fails in all three realizations.
The median affine transition residual between recovered charts is `1.131`, and
fitting each selected anchor frame to its known coordinates leaves median
relative RMS error `0.910` on the remaining cross events. Thus a stable
anchor frame does not by itself make the surrounding interval-volume chart
locally affine.

Retain the chart-consensus frame selector as a positive scaffold component,
but do not promote it to a derived tetrad, atlas, metric, or curvature input.
The next candidate should impose these selected brackets as hard constraints
inside a joint shared-event coordinate reconstruction. Full results are in
`AgentTasks/null-edge-causal-trilateration-tetrad-selector-stage-a16-benchmark-2026-07-15.md`.

### 3.22 Stage A17 closes a conditional local metric/coframe patch

Stage A17 uses the five A16 anchors to align three lightcone charts into one
affine gauge and assigns each multiply observed event its least-squares shared
coordinate. It then regresses a single symmetric metric against count-derived
proper times on the strict bracket interior. The ridge prior is the average
Minkowski form transported from those same charts, so 3+1 Lorentz signature is
stabilized by a supplied chart model rather than discovered from bare order.

Development selects ridge `0.1` without opening sprinkling coordinates. The
unregularized metric has lower interval error but the wrong inertia in all five
`N=2500` realizations. At `0.1`, every development metric is Lorentzian and
passes the intrinsic interval/sign gate; finite-density coordinate and oracle
controls remain mixed.

On three fresh `N=4000` realizations, every intrinsic and oracle gate passes.
The median shared carrier has `106` events, metric condition `1.73`, held-out
interval error `0.094`, unrelated-pair violation `0.041`, oracle coordinate
error `0.237`, oracle metric error `0.317`, and oracle determinant-volume error
`0.198`. Factoring the fitted metric as `g = e eta e^T` gives an exact local
coframe representative to floating-point roundoff.

This is a genuine conditional bridge: it repairs the A16 affine-chart failure
and supplies a local metric/coframe object that can instantiate the existing
finite Levi-Civita interfaces. It is not yet a tetrad bundle or spin geometry.
Dimension, density, endpoints, anchor scale, and a transported Minkowski prior
remain supplied. The next gate is several overlapping A17 patches with metric
agreement, Lorentz coframe transitions, cocycles, orientation/time-orientation,
and spin-lift controls. Full results are in
`AgentTasks/null-edge-causal-frame-constrained-metric-stage-a17-benchmark-2026-07-15.md`.

### 3.23 Stage A18 obtains overlaps and orientation, but not a tetrad bundle

Stage A18 independently reconstructs A17 metric/coframe patches at up to 12
nearby causally deep centers. It selects three patches by intrinsic local-gate
count and overlap only, fits affine transitions on 70% of each overlap, and
scores the remaining events. It then checks metric covariance, internal
Lorentz defects, affine and Lorentz cocycles, and all diagonal coframe sign
gauges for proper and time-oriented transitions.

At `N=2500`, patch quality is too sparse and no radius passes. At `N=4000`, the
frozen radius `0.40` has median 11 constructed patches, seven intrinsic local
passes, minimum pair overlap `268`, and triple overlap `255`. Every realization
passes overlap and admits a proper/time-oriented sign gauge. Median affine and
Lorentz cocycle residuals are `0.095` and `0.104`.

Metric compatibility does not yet survive uniformly. The transition gate
passes `2/3`, while the metric-bundle and spin-prerequisite gates pass only
`1/3`; median maximum metric-covariance error is `0.714` and Lorentz defect
`0.573`. Thus overlap maximization can choose individually good local patches
whose fitted metrics disagree.

Retain the overlap construction and orientation/time-orientation gauge audit.
Reject overlap cardinality as a sufficient bundle selector. No exact spin
obstruction class is computed, because approximate Lorentz maps with an
approximate cocycle do not define the central `Z2` face data required by the
finite spin-cochain modules. The next gate is intrinsic metric/coframe
synchronization across overlaps. Full results are in
`AgentTasks/null-edge-causal-tetrad-bundle-atlas-stage-a18-benchmark-2026-07-15.md`.

### 3.24 Stage A19 rejects compatibility-only bundle selection

Stage A19 asks whether A18 failed only because it selected patch triples by
overlap rather than compatibility. It retains the frozen A17 and A18 local
construction, but divides every candidate overlap into a 60% transition-fit
slice, a 20% selector-validation slice, and a 20% untouched test slice. Triple
selection can use affine and Lorentz compatibility, metric covariance,
cocycles, orientability, and overlap, but not untouched test error or
sprinkling-coordinate oracle data.

Development is initially encouraging: four of five `N=4000` realizations pass
all selector, untouched-transition, metric-bundle, and spin-prerequisite gates.
Among available triples, median selector and untouched affine errors are
`0.130` and `0.153`, metric-covariance error is `0.259`, and Lorentz defect is
`0.275`. One realization nevertheless has only one intrinsically passing local
patch, exposing an availability warning before held-out evaluation.

The frozen construction fails on three fresh `N=4000` realizations. One has
only two intrinsic patches, and neither available triple passes. Across those
two triples, median selector and untouched affine errors are `0.229` and
`0.250`, metric-covariance error is `0.432`, Lorentz defect is `0.479`, and
affine/Lorentz cocycle errors are `0.303` and `0.345`. Every held-out selector,
transition, metric-bundle, and spin-prerequisite success rate is therefore
zero.

Retain the three-way overlap protocol, which protects final transition tests
from selector leakage. Reject compatibility-only selection among independently
fitted local metrics as a tetrad-bundle construction. No threshold is relaxed,
no exact spin class is computed, and curvature remains closed. The next gate is
a joint metric/coframe synchronization within this conditional atlas lane,
constrained by local count-interval fidelity and independently tested on
overlaps. This does not replace the primary bare-graph G2 target: stable,
probe-covariant metric reconstruction from the corrected causal operator. Full
results are in
`AgentTasks/null-edge-causal-compatible-tetrad-bundle-stage-a19-benchmark-2026-07-15.md`.

### 3.25 Stage A20 obtains a conditional synchronized metric bundle

Stage A20 stops selecting among unchanged A17 metrics and instead fits three
overlapping patch metrics jointly. Each local term retains the original
count-derived interval normal equation and chart-transported ridge, while the
new term penalizes failure of (g_i=A_{ij}g_jA_{ij}^{mathsf T}). Local A17
holdouts and overlap events both receive disjoint selector and untouched test
slices. Neither test slice nor any sprinkling-coordinate oracle enters triple
or synchronization-weight selection.

Development compares weights `0`, `0.01`, `0.1`, `1`, `10`, and `100` on five
common `N=4000` realizations and freezes `0.1`. At that weight four of five
realizations pass all final bundle gates. Median metric-covariance error falls
from `0.346` to `0.235`, while untouched interval and transition errors remain
`0.124` and `0.203`. Every synchronized metric is Lorentzian and every selected
triple admits proper/time-oriented coframe sign gauges.

All three fresh held-out realizations pass selector, untouched local-metric,
untouched transition, metric-bundle, orientation, and spin-prerequisite gates.
Median pre/post-synchronization covariance errors are `0.366` and `0.280`;
untouched interval and transition errors are `0.095` and `0.153`; affine and
Lorentz cocycle residuals are `0.051` and `0.071`. The synchronized metrics
move by median maximum relative error `0.106` from their independent fits, and
their post-selection oracle metric error is `0.448`.

This closes a **conditional synchronized metric-bundle subgate**: joint fitting
can preserve local count geometry while improving cross-patch covariance on
fresh data. It does not derive Lorentzian dimension, signature, or scale from
bare order. Nor does it produce an exact spin structure: the weakest Lorentz
defect is close to threshold, and affine/internal cocycles remain approximate.
The next conditional-atlas gate is global affine-gauge synchronization followed
by one shared metric and exact pullbacks, with untouched local tests preventing
an algebraically exact but geometrically empty bundle. The primary bare-graph
G2 target remains the corrected causal-operator metric. Full results are in
`AgentTasks/null-edge-causal-synchronized-tetrad-bundle-stage-a20-benchmark-2026-07-15.md`.

The exact matrix consequence of this architecture is now kernel-checked. Given
row-gauge factorizations (g=e\eta e^{\mathsf T}), exact metric covariance,
the required coframe inverses, and an exact affine chart cocycle, the induced
internal transitions (L=e_X^{-1}Ae_Y) preserve (eta) and satisfy the matching
internal cocycle. A nonidentity rational boost witnesses nonvacuity. This is an
**M [comp]** conditional bundle identity, guarded against axiom-footprint drift
in `SynchronizedTetradBundleAxiomGuard.lean`; it does not improve the numerical
A20 covariance defects or derive any of its hypotheses from the graph.

### 3.26 Stage A21 closes the exact flat-bundle control, not curved geometry

Stage A21 synchronizes three patch-to-global affine maps on transition-fit
events, defines every pair transition as a ratio of those maps, pools local
count-interval training equations into one constant global metric, and pulls
that metric and one coframe back to every patch. Affine and internal cocycles,
metric covariance, and Lorentz compatibility are then exact to roundoff. Local
and overlap selector/test slices determine whether the exact construction still
represents geometry rather than merely satisfying identities.

Four of five development realizations pass every gate. All three fresh
`N=4000` held-out realizations pass selector, untouched local-metric, untouched
transition, exact-flat-bundle, and trivial flat-spin-control gates. Held-out
median selector/test interval errors are `0.125`/`0.115`, selector/test
transition errors are `0.170`/`0.188`, and all exact bundle residuals are below
`4e-16` in the median. Post-selection oracle affine, coordinate, and metric
errors are `0.207`, `0.407`, and `0.359`.

This closes an **exact conditional flat-bundle control**. It does not derive a
nontrivial spin structure: pulling one global coframe into every patch forces
identity internal transitions, so the identity spin lift is only the expected
contractible Minkowski baseline. Nor can the architecture carry gravity: one
constant global metric has zero connection and curvature by construction. The
next conditional reconstruction must fit position-dependent metric first jets
in the exact global atlas and test curvature on weakly curved geometries. Bare-
graph G2 still requires corrected causal-operator metric convergence. Full
results are in
`AgentTasks/null-edge-causal-global-affine-tetrad-bundle-stage-a21-benchmark-2026-07-15.md`.

### 3.27 Stage A22 detects a conformal response but fails absolute scale

Stage A22 returns to the primary operator-first lane. It samples
conformal-coordinate diamonds with

\[
  g_{\mu\nu}(t)=a(t)^2\eta_{\mu\nu},
  \qquad
  a(t)=\frac{1}{1-Ht},
\]

using physical-volume weight \(a(t)^4\). Causal order is unchanged by the
conformal factor, while counting carries its volume information. The same
smeared four-dimensional causal operator and corrected pairing as Stage A are
evaluated on compact coordinate probes. Development selects the nonlocality
scale and support radius using only `H=0` controls; curved target errors remain
closed during selection.

At the frozen `L=0.18`, physical-support-radius `0.55` setting, five fresh
`N=4000` realizations per background give ensemble mean metric errors `0.713`,
`0.439`, and `0.599` for `H=0`, `0.1`, and `0.2`. Individual Lorentz-signature
rates are `80%`, `60%`, and `80%`. After dividing out the flat estimator's
common conformal bias, the held-out response differs from the target by `15%`
and `19%`. Three fresh `N=8000` realizations per background all recover
signature `(1,3,0)`; their response errors are `18%` and `9%`.

This is useful curved calibration evidence, not a G2 pass. Absolute metric
normalization remains biased, and median determinant-volume errors stay near
`1.7` to `2.0` at `N=8000`. Coordinates still define the probes and support,
and physical density remains supplied. The density refinement indicates that
signature variance improves while normalization and volume bias persist. The
next operator stage must therefore repair absolute normalization and support
selection under a refinement schedule before opening metric first jets or the
curvature triangle. Full results are in
`AgentTasks/null-edge-causal-conformal-operator-metric-stage-a22-benchmark-2026-07-15.md`.

### 3.28 Stage A23 concentrates the metric but fails its first jet

Stage A23 replaces the fixed A22 regulator by the shrinking schedule

\[
  L=c_L\sqrt{\ell T},
  \qquad
  S=c_S\sqrt{LT},
  \qquad
  A=c_A L.
\]

Thus \(\ell/L\to0\), \(L/S\to0\), and all three mesoscopic scales shrink.
Nearby retarded rows use target-centered compact coordinate germs; an affine
field regression estimates the inverse metric and all four coordinate
derivatives at an interior pivot. Flat controls alone select
`(cL,cS,cA)=(0.65,1.4,0.9)`.

All twelve fresh `N=4000` metrics and all nine fresh `N=8000` metrics have
signature `(1,3,0)`. Relative conformal-response errors are `2.5%`/`11.5%` at
`N=4000` and `0.4%`/`6.9%` at `N=8000`, substantially improving Stage A22.
Absolute metric errors remain near `0.4` to `0.5`, however, and median
determinant-volume errors remain near `1.0` to `1.7`.

The first-jet test fails. Unrestricted ensemble errors remain above one and do
not improve monotonically at doubled density. Even projection onto the supplied
de Sitter conformal ansatz leaves temporal-slope errors of `170%` and `81%` in
the `N=8000` controls. Consequently the finite first-jet and Levi-Civita
interfaces remain conditional. The next stage must reconstruct the Weyl scale
from count volume and establish metric-volume agreement before reopening the
derivative gate. Full results are in
`AgentTasks/null-edge-causal-conformal-multirow-metric-stage-a23-benchmark-2026-07-15.md`.

### 3.29 Stage A24 reconstructs the conditional Weyl scale from counts

Stage A24 separates scale from the A23 operator shape. Around an interior
pivot, local Alexandrov count windows shrink as

\[
  W_{\mathrm{coord}}
    =c_W\sqrt{\ell_{\mathrm{coord}}T_{\mathrm{coord}}},
  \qquad
  C=c_CW,
\]

so \(\ell_{\mathrm{coord}}/W_{\mathrm{coord}}\to0\) while the expected number
of events in each window grows. This coordinate schedule does not use the
unknown local Weyl factor.
One random Poisson thinning fits the local factor; a disjoint thinning tests
the pivot volume. With conformal coordinates and \(\eta\) supplied,

\[
  a^4\simeq\frac{n}{\rho V_{\mathrm{coord}}},
  \qquad
  g^{\mu\nu}\simeq a^{-2}\eta^{\mu\nu}.
\]

On five fresh `N=4000` realizations per background, ensemble Weyl-factor errors
are below `0.7%`, median sample errors are `1.9%` to `2.6%`, and median oracle
metric-volume errors are `3.2%` to `5.1%`. At `N=8000`, median disagreement
between the fitted metric volume and the independent pivot count volume is
`10%` to `15%` while the coordinate windows shrink and their counts grow.

This closes a **conditional absolute-scale control**, not bare-order G2. The
window endpoints and centers are embedding-defined, and the conformal class is
supplied. The affine scale gradient also fails to converge uniformly. The next
gate is to fuse this independently reconstructed factor with A23's
operator-derived conformal shape and test one absolute metric against both
oracle and independent count volume before reopening first jets. Full results
are in
`AgentTasks/null-edge-causal-count-volume-weyl-metric-stage-a24-benchmark-2026-07-15.md`.

### 3.30 Stage A25 closes conditional volume fusion, not tensor shape

Stage A25 evaluates the A23 operator metric and A24 count scale on the same
sprinkling and pivot. If \(G^{\mu\nu}\) is the operator estimate, its volume is

\[
  v_G=\frac{1}{\sqrt{|\det G|}}.
\]

Given the independent fitted count volume \(v_C\), the fused inverse metric is

\[
  G_{\mathrm{fused}}^{\mu\nu}
    =\sqrt{\frac{v_G}{v_C}}\,G^{\mu\nu}.
\]

This is the unique positive rescaling of the operator conformal ray with volume
\(v_C\); it uses no target metric. On twelve fresh `N=4000` controls, every
fused metric is Lorentzian, median oracle-volume errors fall from approximately
`140%` to `157%` for the raw operator determinant to `3.7%` to `7.1%`, and
disagreement with the disjoint count volume is `4.0%` to `14.5%`.

The tensor shape remains wrong. Median fused metric errors are `0.51` to
`0.63`, and the curved shape does not improve uniformly at `N=8000`. The fused
first jet is also unstable. Thus A25 conditionally closes the scale/volume
fusion law while isolating operator conformal-shape convergence as the
remaining metric obstruction. Curvature remains closed. Full results are in
`AgentTasks/null-edge-causal-fused-operator-count-metric-stage-a25-benchmark-2026-07-15.md`.

### 3.31 Stage A26 improves shape selection but fails uniform convergence

A26 revisits the A23 flat development grid after A25 has separated scale from
shape. A23 had selected partly on first-jet error; that derivative later failed.
A26 instead removes each operator determinant and selects only on flat
unit-volume shape. The frozen winner is

\[
  (c_L,c_S,c_A)=(0.65,1.2,0.9),
\]

with development median shape error `0.132` and ensemble error `0.059`. No
curved target enters selection. The A25 count-volume fusion is then applied
unchanged on fresh seeds.

At `N=4000`, median fused tensor errors improve to `0.131` and `0.168` for
`H=0` and `H=0.1`, but the `H=0.2` signature rate falls to `50%`. At `N=8000`,
all signatures are Lorentzian and the `H=0.2` median error improves to `0.166`,
while the flat error worsens to `0.489`. Volume errors remain below `10%`, but
the first jet remains between `4.6` and `7.1` in the tested cells.

Thus shape-first selection is retained as the right post-fusion objective, but
this single-density setting fails the uniform density/curvature gate. A future
selector must be frozen across multiple flat development densities, or the
operator must be corrected for its support-dependent anisotropic bias. Curved
scores must remain unopened during selection. Full results are in
`AgentTasks/null-edge-causal-shape-selected-fused-metric-stage-a26-benchmark-2026-07-15.md`.

### 3.32 Stage A27 kills median-only multi-density selection

A27 adds an independent flat `N=8000` development ensemble and chooses one
setting by minimizing the worst flat-density median shape error. This freezes

\[
  (c_L,c_S,c_A)=(0.65,1.2,0.7)
\]

before any new curved scores are opened. The setting passes every development
signature check, but its smaller averaging radius leaves only about `30` to
`50` held-out rows. At fresh `N=4000`, signature rates fall to `75%`, `100%`,
and `50%` across `H=0,0.1,0.2`; the strong-curvature median tensor error is
`1.069`, and first-jet error reaches `54.9`. Fresh `N=8000` tensor scores are
better and all signatures pass, but first-jet errors remain `7.3` to `10.2`.

This kills median-only multi-density selection. A viable flat selector must
control signature tails, worst-realization shape, minimum row support, and
design conditioning before central tensor error. It does not reopen curvature.
Full results are in
`AgentTasks/null-edge-causal-multidensity-shape-selected-fused-metric-stage-a27-benchmark-2026-07-15.md`.

### 3.33 Stage A28 stabilizes support tails but exposes response bias

A28 expands the compact-probe support grid and freezes a two-density flat
selector on signature tails, worst-realization shape, row support, and design
conditioning. It selects

\[
  (c_L,c_S,c_A)=(0.75,1.8,1.1).
\]

All `27` fresh metrics are Lorentzian and every regression saturates its row
cap. Median tensor errors remain between `0.31` and `0.42` across both densities
and all three backgrounds, however. The mean metrics are almost diagonal, but
the temporal response remains approximately twice the spatial response. Thus
larger support repairs A26-A27's tails, not the systematic kernel bias. Full
results are in
`AgentTasks/null-edge-causal-support-tail-selected-metric-stage-a28-benchmark-2026-07-15.md`.

### 3.34 Stage A29 obtains a conditional covariant tensor metric

A29 derives a timelike vector (m) from the positive first moment of the same
retarded operator kernel. For raw inverse metric (G), define

\[
  q=m^{\mathsf T}G^{-1}m,
  \qquad T=\frac{mm^{\mathsf T}}{q},
  \qquad G_r=rT+(G-T).
\]

The construction is affine-probe covariant: under (G\mapsto AGA^{\mathsf T})
and (m\mapsto Am), (q) is invariant and
(G_r\mapsto AG_rA^{\mathsf T}). Two flat development densities select
(r=0.60) by signature and worst-realization shape error; curved targets remain
sealed.

All `27` fresh corrected metrics are Lorentzian. Median full-metric errors are
`0.155` to `0.259` at `N=4000` and `0.129` to `0.168` at `N=8000`; five of six
background-density cells are below `0.20`. Oracle-volume errors are `4.4%` to
`9.1%`, and independent count-volume mismatch is `8.6%` to `20.6%`.

This closes a **conditional tensor-metric control**, not bare-order G2.
Coordinates, dimension, density, supports, windows, and one flat-calibrated
response weight remain supplied. A29 deliberately does not transport the old
first jet through the correction. The next gate is the exact derivative of the
moment projector and determinant/count fusion. Full results are in
`AgentTasks/null-edge-causal-retarded-moment-debiased-metric-stage-a29-benchmark-2026-07-15.md`.

### 3.35 Stage A30 differentiates the correction but the scale jet fails

A30 fits the retarded moment first jet and differentiates the inverse, moment
norm, temporal projector, determinant normalization, and count factor exactly.
Finite-difference and affine-probe covariance tests pass. The correction lowers
operator-only first-jet errors in every cell, from roughly `3.3-4.6` to
`2.8-3.8`.

The fully fused jet still fails. Median errors are `5.5`, `6.6`, and `5.6` at
`N=4000`, and `5.3`, `4.6`, and `4.0` at `N=8000`. The A29 tensor remains
Lorentzian and accurate, but the independently fitted count-factor gradient
amplifies the derivative error. Thus the next gate is no longer tensor shape or
formal differentiation; it is a count-volume gradient estimator calibrated on
both zero-gradient and nonzero-gradient Poisson controls. Levi-Civita and
curvature remain closed. Full results are in
`AgentTasks/null-edge-causal-retarded-moment-first-jet-stage-a30-benchmark-2026-07-15.md`.

### 3.36 External strategy audit after A30

Pro's 2026-07-15 strategy audit independently ranks the remaining bridges in
the following order: operator-metric reconstruction, detection of a
manifoldlike phase, agreement of operator/connection/holonomy curvature, the
null-supported Dirac continuum limit, general stress-energy, and one selected
coarse gravitational dynamics. This ordering is accepted. It agrees with the
program's Malament split and, importantly, tells us not to accumulate more
GR-shaped finite identities while the reconstructed geometry itself is still
unstable.

The audit's six immediate theorem targets have the following disposition.

| Target | Current disposition |
|---|---|
| Potential-canceling metric identity | Landed conditionally in `CausalOperatorMetric.lean`; it proves that the corrected pairing removes a scalar zeroth-order potential and records the convergence interface. |
| Finite coordinate derivative identity | Landed conditionally in `CausalMetricFirstJet.lean`; it lowers the operator pairing vector with a supplied inverse relation. |
| Coframe gauge uniqueness | Partially landed in `SynchronizedTetradBundle.lean`; exact metric covariance produces Lorentz internal transitions and cocycles, but the coframes are not graph-derived. |
| Affine exactness of a moment-fitted derivative | Open for a null-shell derivative. A29-A30 instead establish and test affine covariance of the retarded-moment metric correction; its six exact matrix identities were submitted to Aristotle as project `ffa543b4-ffa1-4dac-bb12-da77ac2bc68d`. |
| Compatibility of the derived connection | Landed as a conditional finite interface in `CausalLeviCivita.lean`; its hypotheses are not yet supplied by the noisy reconstructed first jet. |
| Curvature-estimator comparison | Deliberately unopened. It becomes meaningful only after the same reconstructed metric has a convergent first and second jet. |

The experimental evidence sharpens the first priority. A29 passes the current
conditional pivot-tensor gate, while A30 fails only after the independently
estimated count-volume factor is differentiated. The next experiment is
therefore a separately calibrated density/volume-gradient estimator with both
zero-gradient and nonzero-gradient Poisson controls. Only if that control
improves under refinement should it be fused back into the A29 tensor and fed
to the already formalized Levi-Civita interface.

This is a stage decision, not a claim that Pro's later bridges are solved. The
manifoldlike-ensemble probability, curvature triangle, Dirac-square
convergence, universal matter variation, and coarse Einstein effective action
remain open in precisely that order.

### 3.37 Stage A31 improves the scale gradient but falsifies its diagnosis

A31 replaces the A24 affine factor-gradient fit by a penalized Poisson
log-intensity fit while retaining the A24 pivot factor. The slope penalty is
built from the observed center scatter matrix, so its quadratic form is
covariant under invertible affine changes of the supplied probes. A strict
two-density development split includes both zero-gradient and prescribed
nonzero-gradient Poisson controls and selects the mild value
(`lambda=0.1`) without seeing any curved target.

On fresh samples, the new gradient error improves in five of six cells. The
largest gains occur at `N=4000`: the `H=0.1` median falls from `0.392` to
`0.236`, and the `H=0.2` median from `0.639` to `0.349`. Every fused pivot
metric remains Lorentzian with median tensor error `0.166-0.199` across both
densities.

The fused first jet nevertheless remains at roughly `4-6`. The decisive
control replaces the estimated scale gradient by the exact target gradient;
the error is essentially unchanged. Setting the scale gradient to zero also
leaves it unchanged. A31 therefore falsifies A30's attribution of the dominant
failure to the count-volume gradient. The main error lies in the derivative of
the determinant-normalized operator shape. The next gate must decompose and
control that shape jet on flat zero-jet data before revisiting connection
fitting. Full results are in
`AgentTasks/null-edge-causal-poisson-scale-gradient-stage-a31-benchmark-2026-07-15.md`.

### 3.38 Stage A32 kills rowwise nonlinear shape normalization

A32 tests whether the A31 shape-jet failure is caused by applying the A29
response correction and determinant normalization only after an affine raw
metric/moment fit. It instead corrects and normalizes every admissible local
row before fitting the unit-volume shape field. No new parameter is selected;
all schedules and weights are frozen from A28-A31. Rows are retained only when
their pairing is Lorentzian and their retarded moment timelike, an
affine-invariant criterion.

The test fails decisively. Roughly `20%-30%` of rows are rejected, and the
survivors no longer preserve the A29 pivot metric. Median shape error rises
from `0.131-0.228` for the aggregate-first construction to `0.558-1.327`.
Rowwise fused signature succeeds in only `0%-40%` of cells, and the shape-jet
error does not improve uniformly at doubled density.

Thus nonlinear response correction and normalization must remain after metric
aggregation. The next control should constrain the tangent trace/shape
derivative around the stable aggregate tensor. To avoid a vacuous zero-jet
shrinkage, it must be calibrated on both the flat zero-shape-jet chart and a
known nonlinear coordinate chart of flat spacetime with a nonzero target
shape jet. Full results are in
`AgentTasks/null-edge-causal-rowwise-shape-first-jet-stage-a32-benchmark-2026-07-15.md`.

### 3.39 Stage A33 shows that the first jet cannot yet resolve chart response

A33 prevents a vacuous repair of A32 by constructing exact nonzero shape-jet
controls entirely within flat spacetime. Quadratic coordinates

\[
  y^a=u^a+\frac12 Q^a{}_{mn}u^m u^n
\]

have identity Jacobian at the pivot but exact metric jet
`Q_lambda eta + eta Q_lambda^T`. Zero, temporal, and shear controls are tested
at both densities before any curved evaluation. A scalar weight on the
aggregate shape jet is then selected by worst-cell and ensemble errors.

The selector chooses zero. The worst-cell median normalized error is `1.000`
at weight zero, rises to `1.057` at weight `0.1`, and reaches `4.441` for the
unshrunk derivative. At `N=8000`, the ensemble shear response has only `0.134`
of the target amplitude while its orthogonal noise is `1.727` target norms.
The temporal response is also unstable. Meanwhile the pivot shape remains at
`0.117-0.183` error.

Returning zero is an explicit kill condition, not a G2 pass. The current
estimator cannot resolve nonlinear-chart first-jet covariance at these
densities and this mesoscopic schedule. The next gate must vary the averaging
window or use a constrained local-polynomial tangent fit while retaining both
zero and nonzero flat-chart controls. Full results are in
`AgentTasks/null-edge-causal-quadratic-chart-shape-jet-stage-a33-benchmark-2026-07-15.md`.

### 3.40 Stage A34 finds a nonzero mesoscopic chart response

A34 keeps the exact zero, temporal, and shear flat-chart controls from A33 but
spreads the fitted rows across the full averaging ball by deterministic
farthest-point selection. A viable setting must choose a strictly positive
tangent weight, beat the zero-derivative baseline in worst-cell median and
ensemble error, preserve Lorentzian signature, and keep the worst pivot median
shape error below `0.30` at both densities.

The frozen selector chooses averaging multiplier `1.7` and tangent weight
`0.2`. Its worst-cell median and ensemble chart errors are `0.842` and `0.822`,
respectively, compared with the zero baseline `1.000`; the worst pivot median
shape error is `0.265`. Wider settings score slightly better on the derivative
but fail the pivot-tensor gate.

This is the first nonvacuous positive shape-jet control. It shows that the chart
response discarded by the nearest-row fit is recoverable at a wider
mesoscopic scale. It does not establish bare-order reconstruction: the spread
selector uses supplied embedding coordinates, and dimension, probes, windows,
and response normalization remain supplied. Full results are in
`AgentTasks/null-edge-causal-spread-chart-shape-jet-stage-a34-benchmark-2026-07-15.md`.

### 3.41 Stage A35 obtains conditional full first-jet control

A35 freezes the A34 averaging multiplier and nonzero tangent weight before
evaluating fresh flat and conformally curved samples. It retains the A29
response weight, A31 Poisson penalty, and A24 count scale without curved
retuning. Every held-out fused metric is Lorentzian. Median pivot metric errors
are `0.060-0.148`, and the selected unit-volume shape-jet error is `0.324-0.533`
across both densities and all three backgrounds, compared with raw errors
`1.619-2.664`.

The selected full first-jet median is below `0.70` in all six cells. The shape
component improves uniformly when density doubles, but the full jet does not:
the `H=0.2` error changes from `0.653` to `0.674` as the count-gradient error
worsens. Oracle-scale first-jet errors of `0.316-0.565` confirm that the
remaining nonuniform curved behavior is substantially in the scale derivative.

A35 therefore opens a **conditional finite first-jet bridge**. It is not a
convergence theorem or an intrinsic G2 pass. Coordinates, density calibration,
dimension, probes, windows, response normalization, and spread selection are
still supplied. Full results are in
`AgentTasks/null-edge-causal-spread-fused-first-jet-stage-a35-benchmark-2026-07-15.md`.

### 3.42 Stage A36 constructs a finite Levi-Civita connection without convergence

A36 derives the covariant metric jet from the A35 inverse metric and first jet,

\[
  \partial_\lambda g=-g(\partial_\lambda G)g,
\]

then evaluates the standard Levi-Civita formula. No independent connection is
fitted. Torsion and metric-compatibility residuals are at floating-point
roundoff by construction, and affine covariance and finite-difference controls
pass.

Median connection errors are `0.779-0.863` at `N=4000` and `0.599-0.926` at
`N=8000`; ensemble errors are `0.450-0.641` and `0.412-0.657`. These subunit
errors show that the first-jet field can feed a finite connection without
numerical blowup. They do not show convergence. In particular, the `H=0.2`
median worsens from `0.779` to `0.926` under refinement.

Curvature remains closed. The next gate must either obtain a nonvacuous
two-density connection trend on zero and nonzero flat-chart controls plus the
curved backgrounds, or repair the count-scale derivative isolated by A35. Full
results are in
`AgentTasks/null-edge-causal-spread-levi-civita-connection-stage-a36-benchmark-2026-07-15.md`.

### 3.43 External priority audit after A36

The supplied Pro audit independently selects the same critical path:

\[
  C\longrightarrow B_C\longrightarrow\Gamma_C\longrightarrow g_C
  \longrightarrow\Gamma_C{}^\rho{}_{\mu\nu}
  \longrightarrow R_C.
\]

It recommends that convergence and reconstruction now take priority over more
finite GR-shaped analogues. The audit also sharpens four program boundaries.
First, reconstructing geometry on a known sprinkling and proving that the
gravitational ensemble selects manifoldlike orders are separate problems.
Second, operator, connection, and holonomy curvature must converge to one
geometric observable before the existing finite Bianchi identities support a
continuum claim. Third, the null-supported Dirac square and its `R/4` term come
only after that curvature triangle. Fourth, stress energy must arise from one
localized variation of a common matter action before Einstein dynamics is
claimed.

For dynamics, the audit favors one primary route: a causal/order curvature
action followed by a coarse effective action. Thermodynamic and teleparallel
routes remain consistency tests unless equivalence is separately proved. The
corresponding kill conditions are now adopted: no stable rank-four Lorentzian
scale window kills the metric estimator; persistent disagreement among the
three curvature estimators kills their common geometric interpretation; a
wrong Dirac principal symbol, wrong `R/4` coefficient, or surviving low-energy
doubler kills the intended fermion limit; and matter channels requiring
different metric estimators or gravitational couplings kill the equivalence-
principle interpretation.

The immediate preregistered sequence is therefore: stabilize the conditional
connection trend, construct second-jet controls, compare connection curvature
with `-2 B_C 1`, then add reconstructed loop areas and holonomy curvature. No
Einstein equation is promoted before those gates pass. The exact A37 controls,
pass conditions, and kill conditions are recorded in
`AgentTasks/null-edge-causal-connection-convergence-stage-a37-plan-2026-07-15.md`.

### 3.44 Stage A37 passes the conditional two-density connection gate

A37 locks the exact nonlinear-chart targets before selecting a count-scale
schedule. For the quadratic flat chart, the pivot connection and determinant-
scale jet are

\[
  \Gamma^a{}_{bc}=-Q^a{}_{bc},
  \qquad
  \partial_\lambda f=\frac12\operatorname{tr}Q_\lambda.
\]

The temporal chart therefore tests both shape and scale, while the shear chart
has a nonzero connection with zero scale jet. A flat-only development grid
selects count-window multiplier `0.8`, center multiplier `1.8`, and Poisson
penalty `0.8`, retaining the A34 averaging multiplier `1.7` and tangent weight
`0.2`. No curved target enters selection.

On eight fresh realizations per cell with a distinct held-out seed, every
metric is Lorentzian and every flat median metric error is below `0.30`. Both
nonzero flat charts beat a zero-connection estimator in median and ensemble
error at both densities. The worst median connection error falls from `0.993`
to `0.856`, the worst ensemble error from `0.882` to `0.840`, and the `H=0.2`
median from `0.993` to `0.757`. Every high-density cell is subunit.

A37 therefore passes its preregistered **conditional connection gate** and
removes the A36 curved regression. It does not prove an asymptotic connection
limit. The shear response amplitude remains small, changing from `0.24` to
`0.17`, even as its orthogonal noise falls. Coordinates, dimension, density,
probes, chart maps, support, and mapped-coordinate count windows are supplied.
Curvature remains uncomputed. Full results are in
`AgentTasks/null-edge-causal-connection-convergence-stage-a37-benchmark-2026-07-15.md`.

### 3.45 Stage A38 promotes one-operator weak geometry

The post-A37 architecture is now simplified around one mesoscopic package,

\[
  \mathfrak G_L=(\mathcal A_L,\mu_L,B_L,\prec),
\]

where \(\mathcal A_L\) is a basis-independent function algebra, \(\mu_L\) is
the count measure, \(B_L\) is the count-normalized causal operator, and
\(\prec\) is the causal order. Coordinates are admissible local generators of
\(\mathcal A_L\), not primitive graph decorations. A null coframe is likewise
a gauge-relative factorization of the reconstructed metric, not a preferred
null frame supplied before it.

This package makes the cross-relations precise. Individual null edges carry
causal support; products and commutators of the common operator with
multiplication fields carry continuum geometry. Define

\[
\begin{aligned}
  \Box_L&=B_L-M_{B_L1},\\
  \Gamma_L(f,h)&=\frac12\left(
    B_L(fh)-fB_Lh-hB_Lf+fhB_L1
  \right).
\end{aligned}
\]

Then the exact finite identity

\[
  [[B_L,M_f],M_h]1=2\Gamma_L(f,h)
\]

identifies the metric readout with the double multiplication commutator. The
stronger locality requirement is that the double commutator approach
multiplication and the triple commutator

\[
  [[[B_L,M_f],M_h],M_k]
\]

approach zero on \(\mathcal A_L\). This is a genuine finite/refinement gate,
not an identity for an arbitrary matrix.

The primary connection and curvature route is now weak and operator-only:

\[
\begin{aligned}
  H_f(g,h)&=\frac12\left[
    \Gamma(g,\Gamma(f,h))+\Gamma(h,\Gamma(f,g))
    -\Gamma(f,\Gamma(g,h))\right],\\
  \Gamma_2(f,h)&=\frac12\left[
    \Box\Gamma(f,h)-\Gamma(f,\Box h)-\Gamma(h,\Box f)\right].
\end{aligned}
\]

The Bochner remainder
\(\Gamma_2(f,h)-\langle H_f,H_h\rangle\) is the weak Ricci pairing.
Pointwise Christoffels remain a valuable gauge diagnostic, but they are no
longer the primary curvature construction.

The new Lean module
`PhysicsSM/Draft/NullEdge/CausalOperatorWeakGeometry.lean` checks the double-
commutator identity, normalization on constants, symmetry of the weak Hessian,
and invariance of the pairing, normalized operator, double/triple
commutators, weak Hessian, and normalized \(\Gamma_2\) under arbitrary
multiplication potentials. The accompanying flat `(+---)` finite-difference
control gives a nonzero Hessian/connection signal in temporal and shear
quadratic charts while the weak Ricci remainder tends to zero. Metric and
Hessian errors fall by a factor of four when the spacing halves; the shear
weak-Ricci residual falls by about sixteen, and the temporal residual is at
roundoff.

A38 therefore passes a **supplied-operator flat weak-geometry control**. It is
not a causal-set curvature result: the d'Alembertian and coordinate probes are
supplied, \(\mathcal A_L\) is not reconstructed, and no curved Ricci response
or concentration theorem is shown. The next primary gate is selection of a
mesoscopic algebra with product/operator/\(\Gamma\) closure, decreasing
double-commutator multiplication defect and triple commutator, two-sided
support, stable Lorentz rank, and count-volume agreement. Only then should its
projected \(\Gamma_2\) be compared with \(-2B_L1\) and holonomy curvature.
Full details are in
`AgentTasks/null-edge-causal-operator-weak-geometry-stage-a38-benchmark-2026-07-15.md`.

### 3.46 Stage A39 kills strong locality on the first algebra candidate

A39 constructs the first basis-independent mesoscopic algebra candidate,

\[
  \mathcal A_L^{(2)}=\operatorname{span}
  \{1,V_L,\operatorname{Sym}^2V_L\},
\]

where \(V_L\) is either the oracle coordinate subspace, the conditionally
order-derived Johnston rank-four subspace, or a random negative control. The
object under comparison is the rank-15 subspace projector, not an ordered set
of four coordinates. The evaluation region is selected by two-sided causal
depth, including all threshold ties.

The algebraic construction passes exactly where it should. Every oracle and
Johnston envelope has rank 15; products of generators project into the
degree-two envelope with residuals between `4e-15` and `2e-14`; and an
independent affine `GL(4)` change moves the envelope projector by less than
`2.5e-14`. This is positive evidence that a gauge-relative generator subspace,
rather than a preferred coordinate list, is the correct finite object.

The operator/locality gate fails. After oracle-only development freezes
`cL=0.60` and retained depth fraction `0.15`, held-out medians are:

| sector | N | operator closure | Gamma closure | double defect | triple defect |
|---|---:|---:|---:|---:|---:|
| oracle | 300 | 0.675 | 0.705 | 0.674 | 1.093 |
| oracle | 600 | 0.675 | 0.767 | 0.547 | 1.040 |
| Johnston | 300 | 0.677 | 0.656 | 0.862 | 1.022 |
| Johnston | 600 | 0.712 | 0.692 | 0.625 | 1.024 |
| random | 600 | 0.621 | 0.638 | 0.351 | 1.161 |

The strong double-multiplication defect improves with density, but the strong
triple defect remains near one. The oracle region-mean pairing is never
Lorentzian. Johnston has a Lorentzian mean in three of four low-density samples
but only one of four high-density samples and fails to beat the random sector.
Its eventwise Lorentzian fraction does rise from `0.541` to `0.682`, so
row-level signal and region aggregation are not interchangeable.

A39 therefore kills the combination of a global degree-two envelope,
order-depth averaging, and strong eventwise `L2` commutator convergence. It
does not kill the degree-two projector or the one-operator program. Because
the oracle sector fails, increasing Johnston accuracy alone cannot repair this
gate. The next test keeps the projector but changes to a projected weak
calculus: operator, `Gamma`, weak Hessian, and `Gamma2` outputs are returned to
the algebra and evaluated on an intrinsic deepest-event orbit. Flat weak Ricci
must vanish before any curved target is opened. Full results are in
`AgentTasks/null-edge-causal-mesoscopic-algebra-stage-a39-benchmark-2026-07-15.md`.

### 3.47 Stage A40 kills global projected weak geometry

A40 tests the most direct weak-topology repair of A39. Keeping the same
rank-15 degree-two envelope and its projector \(P_L\), it defines

\[
  \Box_L^w=P_L\Box_L,
  \qquad
  \Gamma_L^w=P_L\Gamma_L,
\]

and builds the weak Hessian, \(\Gamma_2\), and Bochner Ricci remainder entirely
inside the projected algebra. Evaluation occurs on the full orbit of events
with maximal two-sided causal depth.

An independent dense finite-difference control validates the implementation.
Temporal and shear quadratic charts have nonzero Hessian norms `2.02` and
`3.78`, while their weak-Ricci cancellation residuals are `4.5e-12` and
`3.2e-5`. The projected formulas therefore correctly return zero physical
curvature in nonlinear coordinates when the underlying operator is a known
local d'Alembertian.

The causal operator fails the same test. Oracle-only development freezes the
minimax failure `cL=0.45`, retained depth fraction `0.15`. On fresh samples,
every oracle chart is Lorentzian in only half the realizations at both
densities. High-density weak double defects are `0.53-0.55`, weak triple
defects are `1.03-1.08`, and weak-Ricci cancellation residuals are
`0.99-1.02`. Nonlinear Hessians remain nonzero, so the failure is not a zero-
geometry artifact.

The Johnston high-density weak metric is likewise only 50% Lorentzian, with
median condition about `293`, weak triple defect `1.018`, and weak-Ricci
residual `0.994`. It does not beat the random subspace. Projection does not
uniformly improve even the double commutator over A39's strong score.

A40 therefore kills a **global projected degree-two calculus** for the current
retarded operator, region, densities, and schedule. It does not kill A38's
operator identities or weak geometry: the same implementation passes when a
local d'Alembertian is supplied. The next graph-side move must change the
operator normalization or locality architecture, not merely polynomial degree
or projection topology. The two admissible successors are an analytic
derivation of the retarded kernel's temporal/spatial response, or a genuinely
local Alexandrov algebra germ with a protected inner core and shrinking
core/patch ratio. Full results are in
`AgentTasks/null-edge-causal-projected-weak-geometry-stage-a40-benchmark-2026-07-15.md`.

### 3.48 The normalization audit selects a tapered local germ

An independent Aristotle audit returns **REVISE**, with a precise separation
of the analytic and finite tasks. Uncut whole-past polynomial moments are not
the correct normalization problem: near-null rapidity tails make them
ill-posed without compact support. On a compact germ, the scalar principal
symbol has the necessary mismatch diagnostic

\[
  \Delta_{\mathrm{ps}}
  =\frac{|B(t^2)+B(x_1^2)|}{|B(t^2)|+|B(x_1^2)|}.
\]

Lower-order drift or potential corrections cannot repair this temporal versus
spatial principal-symbol ratio. In particular, the A29 rank-one pivot
correction has no canonical lift to an order-only operator and must remain a
finite boundary diagnostic unless a separate natural construction is found.

The selected finite locality object is therefore a zero-extended Alexandrov
germ with marked endpoints, a protected inner core, and a taper determined by
two-sided interval-count depth. The new draft module
`PhysicsSM/Draft/NullEdge/AlexandrovAlgebraGerm.lean` defines that object and
proves exact cutoff support, protected-core normalization, nesting, and
relabeling covariance. It does not select a preferred interval, dimension,
continuum chart, or physical scale. Review also caught a global-sign error in
the audit's displayed source-to-project conversion; the ratio no-go is
unchanged because it is invariant under a common sign reversal.

### 3.49 Stage A41c passes deterministic continuum normalization

A41 evaluates the exact Poisson mean of the published smeared four-dimensional
kernel on the marked flat germ. For Poisson interval mean \(\lambda\),

\[
  \mathbb E[f(N,\epsilon)]
  =e^{-\epsilon\lambda}
   \left(1-9z+8z^2-\frac43z^3\right),
  \qquad z=\epsilon\lambda.
\]

The project-sign continuum operator is integrated on the six classes
\(1,t,t^2,x_1^2,t^3,tx_1^2\), after multiplication by each of two frozen
smooth count-depth profiles. A41c splits the quadrature at every analytic
outer cutoff intersection and inner proper-volume branch. Every order
`160/240` comparison passes.

At `L/R=0.065`, the primary and robustness profiles both give Lorentzian
signature, metric error about `0.03`, response-ratio error below `0.07`,
`Delta_ps` below `0.03`, and maximum nominally zero response below `0.15`.
Across the frozen scale sequence, metric error falls by `84.5%` and `89.0%`.
No scalar, drift, rank-one, or potential correction is used.

A41c therefore passes the **deterministic continuum-normalization subgate**.
It shows that A39/A40 are not explained by a wrong asymptotic scalar
normalization. It does not show that a random finite operator concentrates,
nor does it construct an intrinsic mesoscopic algebra. The finite A41d target
extension separately certifies quadrature at `L/R=0.20,0.16`; it is not a new
asymptotic gate. Full results are in
`AgentTasks/null-edge-causal-continuum-kernel-moments-stage-a41c-benchmark-2026-07-15.md`.

### 3.50 Stage A42 rejects the first discrete concentration schedule

A42 evaluates one live project-sign operator row at the marked center of flat
random sprinklings. The operator coefficients, interval counts, cutoff depth,
and density scale are order/count constructions; coordinates enter only to
sprinkle the flat order and supply oracle polynomial fields. Every sample is
compared with the A41d finite-scale target, not directly with the asymptotic
d'Alembertian.

The held-out `N=20000`, four-realization ensemble gives:

| cutoff | `L/R` | `ell/L` | field error | metric error | `Delta_ps` difference | signature rate |
|---|---:|---:|---:|---:|---:|---:|
| primary | 0.20 | 0.51 | 3.65 | 0.47 | 0.40 | 0.50 |
| primary | 0.16 | 0.63 | 4.83 | 1.15 | 0.12 | 0.25 |
| robustness | 0.20 | 0.51 | 4.16 | 0.31 | 0.24 | 1.00 |
| robustness | 0.16 | 0.63 | 5.60 | 0.66 | 0.16 | 0.25 |

All exact coefficient, endpoint-cutoff, and scale-admissibility checks pass,
but every stratum fails the field and metric thresholds. Metric error improves
with density in all four strata, while field error improves only at `0.16`;
individual errors remain much larger than ensemble-mean errors. The result is
therefore a **kill for this density/scale/averaging schedule**, not for the
continuum kernel. Merely requiring `ell<L` is insufficient: the tested
`ell/L=0.51-0.63` high-density values do not realize the needed
\(\ell\ll L\) hierarchy.

This sharpens the one-operator program proposed above. The next graph-side
task is an analytic variance/concentration audit followed by a preregistered
schedule with substantially smaller `ell/L` or explicit mesoscopic averaging.
Only after row-level finite-target concentration should a local function
subspace be selected by product closure, operator closure, multiplication-like
double commutators, small triple commutators, Lorentzian rank, and count-volume
agreement. Weak Hessian and `Gamma2` curvature remain downstream. Full results
are in
`AgentTasks/null-edge-causal-discrete-germ-moments-stage-a42-benchmark-2026-07-15.md`.

### 3.51 Exact variance exposes a two-scale no-overlap window

The A42 failure can be decomposed more sharply. Writing the broad-layer
factor in the falling-factorial basis gives exact Poisson and finite-binomial
first and second moments. At fixed \(z=\epsilon\lambda\), the one-interval
Poisson variance has expansion

\[
  \operatorname{Var} f(N,\epsilon)
  =\epsilon e^{-2z}\frac{z}{9}
   \left(4z^3-36z^2+75z-30\right)^2+O(\epsilon^2).
\]

The Poisson Mecke identity also gives an exact positive diagonal contribution
to the squared operator row. This is not the full variance because different
predecessors share interval events and the count-depth taper is random. At
`N=20000`, however, it already predicts the observed order of magnitude. For
the primary `L/R=0.20` row, predicted versus observed standard deviations are
`38.22/61.36` on `B1` and `4.79/7.74` on `B(t^2)`. The robustness values are
`32.65/39.11` and `3.47/3.43`. Off-diagonal and taper effects modify a large
existing diagonal term rather than creating the A42 instability from zero.

The associated conditional amplitude diagnostic is

\[
  \frac{\sqrt\epsilon}{L^2}=\frac{\ell^2}{L^4}.
\]

`PhysicsSM/Draft/NullEdge/CausalOperatorTwoScale.lean` proves exactly that if
the schedule obeys \(L^2=c^2\ell R\), this expression equals
\(1/(c^4R^2)\) and does not decrease with \(\ell\). This is an algebraic
schedule no-go, not a probabilistic concentration theorem.

A43 then tests whether increasing `L/R` can cheaply lower the diagonal term.
Its targets were frozen before random data. A41e shows that both `0.30` targets
and the robustness `0.25` target are negative definite with
`Delta_ps=1`; only primary `0.25` remains Lorentzian. Development does
concentrate accurately around some `0.30` targets, but those targets have the
wrong signature. The held-out seed was therefore never opened.

The resulting **no-overlap diagnosis** is finite and schedule-specific: at
`N=20000`, scales large enough for low one-row noise are not simultaneously
inside the two-profile Lorentzian-mean window. Increasing `L` is not an
admissible repair. The successor must either lower `ell` much more aggressively
at a Lorentzian `L/R`, or define an order-derived regional weak observable and
control covariance of its same-graph average. Full records are in
`AgentTasks/null-edge-causal-kernel-diagonal-variance-audit-2026-07-15.md` and
`AgentTasks/null-edge-causal-discrete-germ-concentration-stage-a43-benchmark-2026-07-15.md`.

### 3.52 Locality audit opens a controlled operator fork

The recent local-causal-set d'Alembertian result does not invalidate A41c.
Its displayed divergences for the standard nonlocal operator use noncompact
fields; the authors explicitly recover convergence at fixed compact support
and show that the support and density limits do not commute. A41c uses smooth
compact tapers on a fixed Alexandrov germ, so the relevant lesson is to preserve
that order of limits, not to discard the deterministic mean result.

The same work does supply a serious challenger to the present operator. It
constructs temporal second differences from chain-selected events and spatial
second differences from intrinsic distance neighborhoods. Spatial averaging
suppresses first-derivative leakage, and the paper reports polynomial
convergence in `2+1` Minkowski simulations. Its sign convention is opposite to
the project's `(+---)` convention, its displayed numerical tests are not
four-dimensional, and its primary presentation is symmetric even though a
retarded variant is proposed.

G2 therefore opens a controlled two-branch comparison. Branch N retains the
compact retarded nonlocal kernel but forms an order-derived regional weak
observable and measures its full same-graph overlap covariance. Branch L
clean-room implements the intrinsic local distance/neighborhood operator and
audits first-moment leakage, distance-estimator noise, retardedness, corrected
pairing, Lorentzian rank, and concentration on the same polynomial controls.
Neither branch is promoted before a preregistered held-out comparison. The
source and convention audit is recorded in
`Sources/Null_Edge_Causal_Operator_Locality_Variance_Audit_2026-07-15.md`.

### 3.53 A44a closes the local ideal-moment sign control

The first branch-comparison subgate is now exact. For the source-sign local
stencil

\[
  B_{\rm src}=-(C+d+1)D_t+C D_s,
\]

`PhysicsSM/Draft/NullEdge/LocalCausalOperatorMoments.lean` proves constant and
opposite-affine cancellation. Under the source second-moment relations

\[
  E[t^2]=(d/C+1)L^2,
  \qquad E[x_j^2]=L^2/C,
\]

the project-sign response is `2` on (t^2), `-2` on each (x_j^2), and zero
on a vanishing mixed moment. The resulting `3+1` corrected-pairing diagonal is
exactly `(1,-1,-1,-1)`.

The coordinate-oracle companion constructs finite symmetric hyperboloid
neighborhoods in `1+1`, `2+1`, and `3+1`. Every affine, quadratic, mixed,
proper-time-shell, and moment control passes to at worst `7.2e-15`. Shifting
one spatial-neighborhood point gives affine leakage `-1.7457`, providing a
nontrivial negative control.

A44a therefore passes only the **local ideal-moment and convention subgate**.
It proves that the challenger can carry the desired principal symbol if its
neighborhoods realize the displayed moments. It does not show that longest
chains and intrinsic spacelike distances recover those neighborhoods, and it
does not test random concentration or curved response. The next local test
must expose coordinate-oracle, temporal-order/spatial-oracle, and fully
intrinsic errors separately. Full results are in
`AgentTasks/null-edge-causal-local-operator-moments-stage-a44a-benchmark-2026-07-15.md`.

### 3.54 A44N makes regional covariance explicit

The compact nonlocal branch now has a non-oracle pivot selector and an exact
covariance ledger. Each event receives the count depth

\[
  d(x)=\min\{|J^-(x)|,|J^+(x)|\}.
\]

The selected region consists of every event at or above the requested depth
rank, including every threshold tie. The set is therefore relabeling
covariant without a label-based tie-break. The full compact-row and centered
polynomial-field pipeline passes a permutation test.

For responses (r_i) at (m) selected pivots,

\[
  \left(\frac1m\sum_i r_i\right)^2
  =\frac1{m^2}\sum_i r_i^2
   +\frac1{m^2}\sum_i\sum_{j\ne i}r_i r_j.
\]

`PhysicsSM/Draft/NullEdge/RegionalCovariance.lean` proves this with the literal
ordered off-diagonal sum. The Python ledger preserves both positive and
negative shared-graph covariance and reconstructs the direct regional-mean
second moment to roundoff. It therefore cannot silently replace overlapping
rows by independent samples.

This is an **implementation control**, not evidence that regional averaging
concentrates. No random A44N schedule has been opened. The completed variance
audit does not yet justify one: a reusable-count resource prototype and an
order-only pivot schedule must first establish feasible density, pivot count,
and scale. Any later run must report off-diagonal contribution, effective
pivot count, finite-target bias, and signature. Full details are in
`AgentTasks/null-edge-causal-regional-covariance-stage-a44n-control-2026-07-15.md`.

### 3.55 The local spatial-distance input splits order from scale

The local challenger sorts spatial neighborhoods using the causal-overlap
distance of Boguna and Krioukov. The exact graph datum is now formalized. For
two target events \(a,b\) and a common-past event \(c\), let \(C\) be the events
strictly between \(c\) and both targets. Then

\[
  O_C(a,b;c)
  =\frac{|C|}{\min\{|I(c,a)|,|I(c,b)|\}}.
\]

`PhysicsSM/Draft/NullEdge/FiniteCausalOverlap.lean` proves that this ratio is
symmetric in \(a,b\), lies in `[0,1]` including the zero-denominator case, and
is invariant under every finite order isomorphism. These are exact finite
order/count results.

In `1+1`, the source's exact conditional conversion is also recorded:

\[
  d_{1+1}(\tau,O)=\tau\frac{1-O}{\sqrt O}.
\]

For \(\tau>0\) and \(0<O<1\), this distance is positive. It obeys the exact
homogeneity \(d_{1+1}(\lambda\tau,O)=\lambda d_{1+1}(\tau,O)\). The analogous
large-proper-time proxy \(2\tau(1-O)/c_d\) has the same homogeneity. Thus the
formal conversion itself exhibits the scale boundary: overlap is
dimensionless and the supplied proper-time calibration carries length.

The ratio is dimensionless and is not yet a spatial length. The source
conversion also needs a common-past proper-time estimate and a
dimension-dependent inversion or asymptotic coefficient. Its accelerated
numerical selector uses density and dimension in a first filter, although the
second count-overlap filter is intrinsic. Thus the local operator offers a
plausible low-variance principal symbol but does not bypass G2's dimension and
absolute-scale debts. The next Branch L implementation must report three
levels separately: exact overlap with oracle proper time, order-estimated
proper time with supplied dimension/scale, and any genuinely self-calibrated
distance.

### 3.56 Exact kernel moments sharpen, but do not close, concentration

The final Aristotle variance audit has been integrated selectively into
`PhysicsSM/Draft/NullEdge/CausalOperatorKernelMoments.lean`. The central finite
identity

\[
  (N)_i(N)_j
  =\sum_{k=0}^{\min(i,j)}
    {i\choose k}{j\choose k}k!(N)_{i+j-k}
\]

is now kernel-checked. It supports the finite degree-six polynomial used in
the exact one-count Poisson second-moment formula, while the source-locked
Poisson and finite-binomial expressions remain explicitly labeled as closed
formula definitions rather than a theorem that a finite causal row has either
law. The fixed-\(z\) leading coefficient is proved nonnegative for \(z\geq0\).

The same module proves a corrected conditional Chebyshev statement. It assumes
\(\sigma^2\geq0\), \(m_{\rm eff}>0\), and the full geometric bound

\[
  \operatorname{Var}(A)\leq \frac{\sigma^2}{m_{\rm eff}}.
\]

That hypothesis is the unresolved bridge: it must include random-atom
diagonal noise, finite-population effects, random taper depth, and all
same-graph covariance. The audit confirms that the finite-binomial correction
is far too small to explain or repair A42.

A nominal effective kernel count of 256 at the retained `L/R=0.20` scale would
require roughly `N=335000`, rounded to an `N=400000` planning point. A dense
causal relation matrix there is already about `20 GB` before overhead. The
audit's suggested continuum-coordinate pivot sample also conflicts with A44's
order-only tied-depth selector. Consequently this is a **resource and protocol
hold**, not an authorized benchmark: first implement reusable interval counts,
measure full covariance on development fixtures, and freeze an order-only
schedule. Pointwise concentration remains conditional, and regional averaging
remains the more plausible but unproved route.

### 3.57 Reusable counts pass, while center-target reuse fails

The A44 regional branch no longer has to recompute causal predicates for every
pivot. `Scripts/experiments/causal_reusable_relation.py` stores the exact
strict transitive relation in little-endian packed rows, accumulates global
past/future depths once, and obtains each open interval count from

\[
  n(y,x)=\operatorname{popcount}(R_y\mathbin{\&}J^-(x)).
\]

Small-fixture packed relations, depths, interval counts, relabelings, and full
regional responses agree with the direct implementation. At `N=100000`, the
disk-backed cache uses `1.250 GB`, builds in `333.0 s` against `323.1 s`
predicted from `N=20000`, and evaluates 16 tied-depth pivots in `3.52 s`.
Refined quadratic extrapolation to `N=400000`, 256 pivots is `18.63 GiB` and
`1.73 h`. This closes the development-scale reusable-count resource
precondition, not the physical concentration gate or authorization for the
large run.

A separate deterministic target audit catches an important boundary error.
The A41d center finite target is not uniform across the selected region. The
new relative-null quadrature uses an exact angular cap for the outer diamond
and returns the full corrected-pairing matrix at arbitrary oracle pivots. All
frozen low/high quadrature and Lorentzian-signature controls pass, but a
futureward temporal displacement of only `0.05R` changes the six-channel
target by `0.34` and the metric by `0.12`; the corresponding spatial shift
changes them by only `0.01` and `0.03`. This is retarded finite-boundary bias,
not random variance. A44N must use one finite continuum target per
order-selected pivot before forming its residual covariance ledger.

### 3.58 Per-pivot calibration exposes the remaining regional noise

A44p joins the exact reusable relation, the order-only tied-depth selector, the
expanded affine/quadratic probe envelope, and the off-center continuum target
on one `N=100000` development graph. Sixteen pivots are selected. Their time
offsets stay within `0.012R`, but their spatial offsets reach `0.177R`; finite
target metric shifts from the center have median `0.072` and maximum `0.117`.
All per-pivot target signatures are Lorentzian, and the worst low/high
quadrature discrepancies are only `0.0107` in an operator channel and
`0.00081` in the metric.

After that boundary bias is removed, the graph result remains noisy. The
regional-mean discrete and target metrics are both Lorentzian, but their full
relative error is `0.546`; the 17-channel operator error is `1.370`, and only
14 of 16 individual row metrics are Lorentzian. The actual mean has temporal
component `0.644` versus target `1.618` and time-space components as large as
`0.260`, so repeated-spatial-diagonal scoring would have hidden important
leakage.

The exact within-graph residual-square ledger gives effective pivot counts
about `4.1` for the temporal quadratic and `4.7-28.5` across spatial
quadratics. These are one-graph diagnostics, not population estimates, but
they confirm that nominal pivot count cannot replace covariance measurement.
The next Branch N gate is several fresh `N=100000` development graphs with the
same per-pivot targets and full residual covariance. Held-out data,
`N=400000`, and curvature remain closed.

### 3.59 Regional Lorentzian shape replicates, but global reads block a concentration theorem

The preregistered A44N development stage evaluates three fresh independent
`N=100000` graphs, excluding the A44p pilot. All three 16-pivot regional means
have Lorentzian signature `(1,3,0)`, and 44 of 48 individual pivot metrics are
Lorentzian. Full metric errors are `0.400`, `0.203`, and `0.361`; the
17-channel operator errors are `1.076`, `0.699`, and `0.742`. The exact
diagonal/off-diagonal residual ledger reconstructs the direct regional second
moments to `5.33e-15`. Its pooled diagonal effective pivot counts are `12.10`,
`20.57`, `30.35`, and `60.21` on the four metric diagonal channels. Every
frozen development gate passes, so Branch N remains empirically viable and a
separately preregistered `N=200000` development stage is permitted. This is
three-graph development evidence, not a held-out tail or continuum result.

The analytic covariance bridge is now kernel-checked. For an ordered covariance
ledger with diagonal bound `sigmaSq`, at most `degree` declared neighbors per
row, neighbor covariance at most `kappa*sigmaSq`, and nonpositive undeclared
entries, the regional mean variance contribution is at most

\[
  \frac{\sigma^2(1+\mathrm{degree}\,\kappa)}{m}.
\]

A conditional Chebyshev wrapper is proved with the observable's physical
variance relation left explicit. These are exact finite implications, not
claims that the graph estimator satisfies their hypotheses.

Tracing the implementation reveals why that distinction matters. Pivot
selection ranks every event by global past/future depth. Each selected row also
uses the global future count of every predecessor when deciding its taper.
Thus the realized polynomial support is compact, but the unconditional random
observable reads the whole sprinkling. The conservative dependency graph is
complete, of degree `m-1`. The live Lean module proves that the corresponding
bound is exactly

\[
  \sigma^2\kappa+\frac{\sigma^2(1-\kappa)}{m}.
\]

This is not a lower bound and therefore does not disprove concentration. It
does show that bounded degree cannot prove concentration for the current
global architecture: one must prove `kappa_N -> 0`, localize both selection and
taper inputs to finite-overlap outer germs, or separate anchor selection from
row evaluation by an independent thinning. The `N=200000` run is consequently
deferred until one of those repairs is frozen. G2 has gained replicated
Lorentzian operator-shape evidence and an exact covariance theorem, while its
probabilistic bridge remains open at information-flow locality.

### 3.60 Complete-dependency concentration is reduced to covariance decay

The complete-overlap diagnosis does not by itself imply a variance floor.
`PhysicsSM/Draft/NullEdge/RegionalCovariance.lean` now proves the exact
asymptotic implication needed to keep that distinction honest. For refinement
sequences with positive selected-pivot counts (m_N), suppose

\[
  m_N\longrightarrow\infty,\qquad
  \sigma_N^2\longrightarrow\sigma_\infty^2\in\mathbb R,
  \qquad \kappa_N\longrightarrow0.
\]

Then the complete-dependency upper bound

\[
  \frac{\sigma_N^2(1+(m_N-1)\kappa_N)}{m_N}
  =\sigma_N^2\kappa_N+
    \frac{\sigma_N^2(1-\kappa_N)}{m_N}
\]

tends to zero. The proof is kernel-checked with a build-enforced standard axiom
footprint. It neither constructs the random variables nor proves the three
limits; in particular, empirical effective pivot counts are not substituted
for (kappa_N).

The focused covariance audit has now returned a `REVISE` verdict for the exact
same-graph estimator. The implemented fixed-`N` sprinkling is a binomial
process, not an unconditioned Poisson process. Conditioning on the tied selected
set or global depth field does not restore independent increments, because the
conditioning event and every taper still read global order counts.

There is also a more geometric obstruction template. A fixed minimum number of
deepest pivots in a fixed diamond should coalesce near the continuum depth
maximizer while the controlled nonlocality scale remains much larger. For two
centered selected-row residuals, the exact identity

\[
  2\operatorname{Cov}(X_N,Y_N)
  =\operatorname{Var}(X_N)+\operatorname{Var}(Y_N)
   -\mathbb E[(X_N-Y_N)^2]
\]

shows that asymptotically equal normalized variances and vanishing normalized
row difference imply \(\kappa_N\to1\), not zero. The algebraic limit is now
kernel-checked. Selected-pivot coalescence and normalized stochastic
`L2`-continuity of the complete globally selected/tapered row remain open
probability theorems, so this is not an unconditional covariance lower bound.

The exact A44 observable is retained for operator-shape development or as one
within-graph statistic under independent whole-graph replication. A viable
same-graph successor must compute selector, taper, intervals, and targets from
order-derived outer germs and must select anchors with bounded germ overlap;
localizing sixteen coalescing pivots is insufficient. Density escalation remains
deferred while that population estimand and architecture are frozen.

### 3.61 Relative count scale now composes with tetrad and curvature weights

The density-free scale reconstruction and the coframe/curvature layers were
previously checked in separate modules. The new
`RelativeScaleTetradBridge.lean` closes their finite convention gap in the row
coframe convention

\[
  g=e\eta e^{\mathsf T}.
\]

If \(L\eta L^{\mathsf T}=\eta\) is a supplied Lorentz transition and \(r\) is
the positive relative length factor reconstructed from two nonempty counts and
positive representative coframe volumes, then the combined transition \(rL\)
satisfies

\[
  (rL)\eta(rL)^{\mathsf T}=r^2\eta.
\]

The same theorem package uses \(r^2\) as the relative plaquette-area factor and
therefore sends an area-normalized holonomy curvature limit \(R\) to
\(r^{-2}R\). The count-scale anchor law and the supplied Lorentz-transition
law compose to an exact Weyl-Lorentz overlap cocycle. A nontrivial sixteen-to-one
count witness gives \(r=2\), transition \(2I\), metric factor four, and thereby
separates physical Weyl scale from Lorentz gauge.

These statements are kernel-checked with guarded standard axiom footprints.
They establish the correct finite G2-G3-G4 transformation chain; they do not
derive the regions, representative coframes, Lorentz transitions, plaquettes,
holonomies, or the global unit from the bare order. In particular, the result
prevents a future tetrad reconstruction from silently treating count-derived
scale as a Lorentz gauge transformation.

### 3.62 Maximum separated-germ ensembles fix the same-graph estimand

The A44 covariance audit required a same-graph successor whose selector and
complete information flow are local to order-derived outer germs. Two new
finite modules now fix the combinatorial selector and the population estimand
without choosing vertex labels, coordinates, or one symmetry-breaking
packing.

`AlexandrovGermPacking.lean` treats a marked diamond's two endpoints together
with its strict interior as one closed carrier. A germ is eligible when its
open interval contains at least a supplied count threshold, and a packing is a
finite family of eligible germs with pairwise vertex-disjoint closed carriers.
Because a graph automorphism need not fix any one maximum packing, the
canonical object is the finite ensemble of **all** maximum-cardinality
packings. The module proves:

- a maximum packing exists on every finite causal order;
- every order isomorphism gives an equivalence of the complete maximum-packing
  ensembles;
- ensemble cardinality and uniform averages of equivariant observables are
  exactly relabeling invariant;
- if one eligible germ exists, every maximum packing is nonempty; and
- two disjoint three-event chains provide an explicit two-germ nonvacuity
  witness.

`AlexandrovGermPairEstimand.lean` then sums an observable over every distinct
ordered germ pair in every maximum packing and divides by the corresponding
exact pair count. For a local score (X), its primary statistic is

\[
  q_C=
  \frac{\mathbb E_{\mathrm{max\ pack},\,A\ne B}
    [(X_A-X_B)^2]}{\sigma_C^2},
\]

where the expectation denotes the exact finite ensemble average and
\(\sigma_C^2\) is still a supplied positive marginal variance. The checked
finite covariance estimand is

\[
  \widehat\rho_C=1-\frac{q_C}{2}.
\]

This solves two finite architecture problems: automorphisms no longer force an
arbitrary anchor choice, and the same-graph covariance question now has a
precise selected-ordered-pair estimand. It does **not** yet prove score
independence or covariance decay. Vertex-disjoint carriers imply disjoint
finite read sets only after the operator score, taper, target, and calibration
are all computed internally. Under a fixed-(N) binomial graph law, disjoint
read sets may also remain dependent through the total-count conditioning. No
packing-growth, stabilization, positive-variance, or continuum theorem is
claimed, and maximum-packing existence is not an efficient algorithm.

The next analytic gate is therefore sharply stated: construct the complete
retarded germ score from the closed carrier alone, prove that locality theorem,
and then establish packing growth and a two-germ covariance bound under the
chosen random causal-order law. Density escalation remains deferred until
those statements are frozen.

### 3.63 The retarded control score is now internal to each closed germ

`AlexandrovGermInternalOperator.lean` closes the finite information-flow part
of the gate stated above. For a marked diamond (A), its closed carrier is the
subtype containing the bottom endpoint, top endpoint, and strict interior. The
ambient causal relation restricts to an induced finite causal order on this
subtype.

The central theorem is causal convexity. If (x,y) belong to the closed
carrier and (x\prec z\prec y), then (z) belongs to the same carrier. Hence,
for every pair of carrier events,

\[
  I_{C|A}(x,y)\simeq I_C(x,y),
  \qquad
  |I_{C|A}(x,y)|=|I_C(x,y)|.
\]

Every Benincasa-Dowker layer label needed by the induced retarded operator is
therefore computable internally and agrees exactly with the ambient label. A
stronger compatibility theorem proves that both the local and smeared induced
operators equal the original ambient operators on the zero extension of the
same carrier field. Localizing the information flow has not changed the finite
operator formula.

The marked-diamond boundary depth and taper also have induced-order formulas
that equal their ambient restrictions. Protected anchors are treated by the
uniform average over **all** anchors above a supplied depth threshold, avoiding
another symmetry-breaking selector. An explicit three-event chain supplies a
nonempty depth-one protected-anchor witness.

Two score layers are checked:

- a carrier-typed residual score for supplied local fields and targets, whose
  relabeling covariance is exact; and
- a fully internal cutoff-control score built only from the causal order, a
  universal count-depth profile, and the two numerical operator scales.

The cutoff-control score plugs directly into the maximum separated-packing
ordered-pair mean-square-difference estimand, and the complete expression is a
bare-order invariant. Thus the finite selector, complete read set, taper,
anchor average, retarded operator, and pair estimand now form one exact local
chain.

This is a G2 **locality and compatibility milestone**, not an operator-metric
convergence theorem. The radial cutoff control does not supply the independent
affine/quadratic probe sector needed to reconstruct a Lorentzian metric, and a
carrier-typed continuum target remains supplied data rather than a graph
derivation. The stochastic program still owes maximum-packing growth, positive
marginal variance, fixed-(N) or de-Poissonized two-germ covariance control,
and convergence of a physically complete intrinsic probe family. Those are
now analytic debts rather than ambiguities in the finite information flow.

### 3.64 Lorentz recovery requires a natural subspace, not natural basis vectors

`IntrinsicProbeSubspace.lean` resolves one finite symmetry question left open
by the intrinsic-probe obstruction. For a finite event set (V), define the
canonical zero-sum scalar-field sector

\[
  P_0(V)=\left\{f:V\to\mathbb R:\sum_{x\in V}f(x)=0\right\}.
\]

Relabeling by any causal-order isomorphism is a real-linear equivalence of
field spaces, preserves the total sum, and therefore carries (P_0(V)) exactly
onto (P_0(W)). The module packages this as an intrinsic **probe subspace**:
the subspace is canonical, while a basis in it may transform by a general
linear change of basis.

The five-event antichain supplies an exact positive/negative symmetry control.
Its zero-sum subspace has real dimension four. At the same time, its full
permutation group is transitive, so every scalar probe selected individually
and naturally from the order is constant. If such a probe is also zero-sum, it
vanishes pointwise. Thus bare-order symmetry allows a canonical rank-four
subspace but forbids a canonical ordered list of four nonzero probe vectors.
This is the finite representation-theoretic reason that a recovered coframe
must be gauge-relative.

The construction is connected to the local germ operator without choosing a
basis. On every closed Alexandrov carrier, the corrected pairing of the induced
smeared causal operator restricts to the zero-sum sector, remains symmetric,
and is exactly covariant under ambient order isomorphisms. The G2 architecture
can therefore be stated basis-free all the way through the finite pairing.

This does **not** recover Lorentz invariance. The rank four in the control is
the codimension-one rank of fields on five events, not an emergent spacetime
dimension. The zero-sum sector is also much too large on general carriers and
has no proved slow-variation, affine-coordinate, or principal-symbol property.
The next gate is to derive a natural low-complexity subspace (or an invariant
ensemble of such subspaces), prove that four modes survive a refinement family,
and show that the restricted corrected pairing converges nondegenerately with
Lorentzian inertia (one sign opposite to three). Only then would local
`GL(4)` basis covariance reduce to recovered local Lorentz gauge freedom.

### 3.65 The finite probe-tetrad quotient now has an exact Lorentz stabilizer

`ProbeFrameLorentzGauge.lean` implements the gauge conclusion anticipated in
the preceding section. The first new ingredient is not merely notational: the
active local/smeared layered operator is proved additive and homogeneous and is
bundled as a real-linear map. Its corrected principal-symbol pairing therefore
restricts to a genuine symmetric bilinear form (B_A) on each closed carrier's
natural zero-sum probe subspace.

When that subspace has rank four, a **probe frame** is a basis

\[
  b:\mathbb R^4\overset{\sim}{\longrightarrow}P_0(A).
\]

The reconstructed principal-symbol (inverse-metric) components in this frame
are the Gram matrix

\[
  G_b{}_{ab}=B_A(b_a,b_b).
\]

For any second frame (c), let (M=b^{-1}c) be its basis-change matrix. Mathlib's
bilinear-form change-of-basis theorem gives the exact finite tetrad law

\[
  G_c=M^{\mathsf T}G_bM.
\]

Define the local Lorentzian-inertia gate by existence of a frame with

\[
  G_b=\eta,\qquad \eta=\operatorname{diag}(1,-1,-1,-1).
\]

The module proves that, after one such frame is fixed, a second frame is
normalized if and only if

\[
  M^{\mathsf T}\eta M=\eta.
\]

Thus the residual frame freedom is exactly the mostly-minus Lorentz group. The
existence of a normalized frame implies nondegeneracy of (B_A), and is preserved
and reflected by every ambient causal-order isomorphism. This establishes the
precise finite statement that a successful operator reconstruction yields a
Lorentz-gauge class rather than a preferred tetrad.

The result is still conditional at the decisive points. No theorem yet gives
rank four for the low-complexity sector on physical carriers, proves that the
active pairing passes the Lorentzian-inertia gate, or constructs compatible
frames across overlapping carriers and refinement levels. The next G2-G3
bridge must provide those three facts. Once it does, the existing relative
scale/tetrad transition module can separate Weyl scale from the newly derived
Lorentz transition instead of receiving both as independent data.

### 3.66 Count scale and the probe metric now have reciprocal Weyl weights

`ProbeFrameWeylScaleBridge.lean` closes a separate compatibility gap between
the count-derived Weyl channel and the operator-derived probe metric. The
active smeared operator has two length parameters: the discreteness scale
\(\ell\) and nonlocality scale \(L\). Its branch variable is dimensionless,

\[
  \epsilon(\ell,L)=\left(\frac{\ell}{L}\right)^4,
\]

so every nonzero simultaneous rescaling satisfies

\[
  \epsilon(r\ell,rL)=\epsilon(\ell,L).
\]

The module proves the exact finite operator identity

\[
  B_{r\ell,rL}=r^{-2}B_{\ell,L},
\]

including both the local branch \(\epsilon=1\) and broad-layer branch
\(\epsilon\ne 1\). Because the corrected pairing is linear in the operator,
the restricted carrier form and its matrix in any fixed probe frame obey

\[
  \mathcal B_{r\ell,rL}=r^{-2}\mathcal B_{\ell,L},\qquad
  G_b(r\ell,rL)=r^{-2}G_b(\ell,L).
\]

This inverse-square weight is the expected one: the corrected d'Alembertian
pairing reconstructs a principal symbol \(g^{\mu\nu}\), not the covariant row
metric \(g_{\mu\nu}\). For the count-derived relative length
\(r=\texttt{relativeCountScale}\), let
\(a=\texttt{relativeAreaScale}=r^2\). The existing coframe theorem and the new
probe theorem now give one exact package,

\[
  T\eta T^{\mathsf T}=a\eta,
  \qquad
  G_b(r\ell,rL)=a^{-1}G_b(\ell,L).
\]

The nonunit control is explicit: sixteen events relative to one, on identity
coframe representatives, give \(r=2\), hence covariant metric factor \(4\) and
contravariant probe-Gram factor \(1/4\). This is the first kernel-checked
agreement between the reconstructed count scale and reconstructed operator
metric at the level of tensor variance.

The result does not yet identify the operator's two length parameters from the
bare order, derive the rank-four low-complexity probe sector, pass the
Lorentzian-inertia gate, or construct compatible frames across overlaps. It
does show that if those reconstruction gates succeed, the scale and probe
channels already transform consistently rather than imposing competing Weyl
laws.

### 3.67 Retarded-shell availability is now an exact rank obstruction

`RetardedProbeSupportGate.lean` formalizes the order-side availability test
that precedes any new intrinsic probe selector. Fix natural-number bands for
inclusive interval size \(|I(y,x)|+1\). For each event \(v\), define past and
future abundance by counting band-limited predecessors and successors. The
two-sided interior condition is

\[
  P_I(v)\ge q_I,\qquad F_I(v)\ge q_I,
\]

and the retarded shell at a marked event \(x\) is

\[
  R(x)=\{y\prec x:\ y\text{ is two-sided interior and }
    a_R\le |I(y,x)|+1\le b_R\}.
\]

The module proves that past abundance, future abundance, interior membership,
shell membership, and shell cardinality are all preserved exactly by finite
causal-order isomorphisms. Thus the availability test uses no embedding,
coordinate frame, target metric, or label tie-break.

For any scalar-probe subspace \(P\), restriction to the shell is a linear map

\[
  \operatorname{res}_{R(x)}:P\longrightarrow\mathbb R^{R(x)}.
\]

The qualitative visibility gate says this map is injective: no nonzero probe
combination vanishes on the entire shell. Kernel-checked finite-dimensional
linear algebra now gives

\[
  \dim P\le |R(x)|.
\]

Therefore \(|R(x)|<4\) forbids every shell-visible rank-four sector before
signature or metric scores are opened. The theorem applies to arbitrary probe
subspaces, not only probes strictly supported inside the shell, and shell
visibility is invariant for every `IntrinsicProbeSubspaceSector`. It also
specializes directly to the existing carrier probe frames.

The bound is sharp. On a five-event order with four incomparable leaves before
one top event, a minimal count window exposes exactly four shell events, and
restriction to them separates the rank-four zero-sum sector. This is a
nonvacuity control, not a spacetime model.

The result gives a rigorous reading of the A3 availability failure. Empty or
sub-four shells cannot be repaired by a different basis, generalized
eigensolver, or metric-aware truncation. Conversely, four events only pass the
qualitative rank prerequisite. The observed A3 zero worst-direction coverage
can persist on larger shells, so quantitative coverage, product closure,
stable cluster rank, Lorentzian inertia, and two-scale convergence remain the
next experimental and analytic gates.

### 3.68 Stage A3b recovers the scale hierarchy but not the support sector

Stage A3b separates two questions that the fixed-(s/L) scan had conflated.
For supplied discreteness scale (ell), operator scale (L), and adjacent
ratio (r), choose the central selector scale

\[
  s=\sqrt{\ell L}
\]

and test the triple ((s/r,s,rs)). The geometric mean maximizes the smaller
multiplicative clearance to the endpoints. Hence a strict triple inside
((\ell,L)) exists exactly when

\[
  \frac{L}{\ell}>r^2.
\]

For (ell=(V/N)^{1/4}), this becomes the exact analytic precondition

\[
  N>\frac{V r^8}{L^4}.
\]

At the frozen (V=\pi/24), (L=0.18), and (r=1.25), the threshold is
(N>743.239\). Thus the earlier (N=400) adjacent-scale failure was
unavoidable, while (N=800) has only (0.9\%\) endpoint clearance.

Keeping the best A3 interior and shell bands fixed, the order-only benchmark
then intersects the interiors at all three scales and evaluates every common
mark. The hierarchy is valid and the common interior is nonempty in every
realization at (N=800) and (1200). Nevertheless, only (0.33\%\) and
(2.49\%\), respectively, of common marks have at least four retarded-shell
events at all three scales. A three-realization (N=2400) diagnostic reaches
only (3.23\%\). The largest-scale shell has median cardinality zero at all
three evaluated densities.

This revises the A3 conclusion precisely. An adjacent **scale hierarchy** can
be recovered by a finite-volume-aware schedule, but an adjacent **support
sector** is still absent for almost every order-selected mark. Common
interiority is not the blocker; requiring shell sources to lie in the same
largest-scale two-sided interior is. The frozen (80\%\) randomized-mark
availability gate therefore fails, and the generalized-cluster eigensolver
remains blocked before any spectral gap, emergent rank, signature, or target
metric is inspected.

The next clean test is a larger Alexandrov interval at fixed (ell,L,r) and
fixed count bands, with (N) scaled by volume. That distinguishes boundary
truncation from a structurally unsuitable same-scale source-interiority rule.
Only if the order-side shell gate passes should the basis-free generalized
cluster be constructed.

### 3.69 Stage A3c confirms boundary dependence and kills the global shell as locality

Stage A3c performs the larger-diamond control while keeping the expected
density and every local scale fixed. For integer four-volume multiplier (m),
it sets

\[
  N_m=mN_1,
  \qquad
  T_m=m^{1/4}T_1.
\]

Thus (ell=(V(T_m)/N_m)^{1/4}), (L), (r), the adjacent selector triple,
and every interior/shell band are identical throughout the ladder. An exact
sparse inclusive-count implementation reproduces the archived dense A3b JSON
entry-for-entry while reducing the (N=1200) count step from about one second
to (0.0083) seconds.

On ten fresh realizations at volume multipliers (1,2,4), the fraction of
common marks with at least four shell events at all three scales rises

\[
  1.93\%\ \longrightarrow\ 17.19\%\ \longrightarrow\ 36.97\%.
\]

The common-interior fraction and shell means rise at the same time. A
five-realization volume-eight diagnostic reaches (50.85\%\), with the
largest-scale shell median increasing from zero to four and its mean reaching
(66.26). Every local count and length parameter is unchanged. The finite
boundary is therefore a major cause of the A3b scarcity.

That positive availability trend is not local convergence. In (3+1)
Minkowski spacetime, write a past timelike point relative to the mark as

\[
  t=-\tau\cosh\chi,
  \qquad
  r=\tau\sinh\chi.
\]

The volume element is

\[
  d^4y=\tau^3\sinh^2\chi\,d\tau\,d\chi\,d\Omega.
\]

A fixed interval-volume/count band fixes a proper-time interval
(	au_1\le\tau\le\tau_2), but it leaves the rapidity direction
(0\le\chi<\infty). Since

\[
  \int_0^\infty \sinh^2\chi\,d\chi=\infty,
\]

the Lorentz-invariant timelike shell has infinite continuum volume. A finite
Alexandrov diamond supplies an infrared rapidity cutoff, and enlarging that
diamond removes the cutoff. Two-sided interiority excludes boundary events;
it does not compactify the shell relative to the mark.

`RetardedShellInfraredNoGo.lean` supplies the finite counterpart. For every
(n\in\mathbb N), it constructs a strict three-level causal order with a
nonzero two-sided abundance threshold, a fixed minimal inclusive count band,
and exactly (n) shell sources. Every source has open-interval count zero to
the mark. Kernel-checkably,

\[
  |R(x)|=n
\]

with the same local count data for arbitrary (n). Its guarded assumption footprint
is the standard `[propext, Classical.choice, Quot.sound]`.

The conclusion is sharper than an A3b failure. The global count-band shell is
now rejected as a **local support construction**, even if a still larger
diamond would eventually make its old (80\%\) cardinality gate pass. The
necessary rank obstruction remains valid: fewer than four shell events forbid
a visible rank-four probe sector. But increasing global-shell cardinality
cannot certify locality.

The successor must use a compact, order-derived Alexandrov carrier around the
mark, or an equivariant ensemble of such brackets when no canonical one
exists. Retarded support is then evaluated in the induced finite order and
must be stable under carrier refinement and overlap. The generalized-cluster
eigensolver remains deferred until that compact-carrier gate passes.

## 4. Proposed null-edge gravitational data

Under the selected architecture, a minimal finite history contains order,
number, matter/internal fields, and enough data to construct a normalized
causal operator. Coframes, local spin frames, and transports are intended to be
reconstructed gauge data. The current finite Lean modules still take many of
them as supplied inputs; the following list records those interfaces rather
than claiming that the reconstruction has already been performed.

### 4.1 Events and causal order

Let \(V\) be a locally finite set of events with a partial order \(\prec\).
Intervals

\[
  I(x,y)=\{z\mid x\prec z\prec y\}
\]

carry order and counting information. The covering relation may be used as a
combinatorial link structure, but a causal-set link is not automatically a
fixed-length continuum null vector. Declaring primitive propagation to have
null support is an additional null-edge postulate.

### 4.2 Decorated null directions and dual soldering

At each event \(x\), introduce decorated null directions \(\ell_a(x)\) and a
dual coframe \(\alpha^a(x)\) satisfying

\[
  \alpha^a(\ell_b)=\delta^a{}_b.
\]

The active operator architecture is

\[
  D_h=\sum_a c(\alpha^a)\nabla_{\ell_a},
\]

where primitive support lies along \(\ell_a\), while Clifford soldering uses
the dual covectors \(\alpha^a\). The diagonal expression
\(\sum_a c(\ell_a^\flat)\nabla_{\ell_a}\) is not the active continuum symbol;
the project has already identified a trace obstruction to that identification.

Given an internal Minkowski form \(\eta\) and a square coframe matrix \(e\), the
induced finite metric is

\[
  g=e^{\mathsf T}\eta e.
\]

The project proves **M [orig]** finite statements that invertible frame changes
preserve coframe nondegeneracy, \(\eta\)-orthogonal frame changes preserve the
induced metric, determinant-one changes preserve coframe volume, and the
soldering defect transforms covariantly. These results live in
`NondegenerateSolderingGeometry.lean` and
`SolderingLocalFrameCovariance.lean`.

They establish a valid finite covariance pattern. They do not reconstruct a
continuum tetrad bundle from the causal order.

### 4.3 Connection and transport

An oriented edge \(x\to y\) carries a transport \(U_{xy}\). Under independent
frame changes,

\[
  e_x\mapsto g_xe_x,
  \qquad
  U_{xy}\mapsto g_yU_{xy}g_x^{-1}.
\]

A finite coframe defect is

\[
  T_{xy}=e_y-U_{xy}e_x.
\]

The repository proves **M [orig]** its target-frame covariance and exact
composition law under edge refinement. Closed-loop transport transforms by
conjugation, so class functions of holonomy are gauge invariant.

This is the correct finite skeleton for a spin connection or teleparallel
transport. Its geometric interpretation depends on additional compatibility
conditions.

The concrete matrix-coframe API now closes one of those compatibility steps.
It proves **M [orig]**

\[
  T_{xy}=0
  \quad\Longleftrightarrow\quad
  e_y=U_{xy}e_x.
\]

If the edge transport is internally Lorentz,

\[
  U_{xy}^{\mathsf T}\eta U_{xy}=\eta,
\]

then exact parallel transport preserves the induced metric:

\[
  e_y^{\mathsf T}\eta e_y=e_x^{\mathsf T}\eta e_x.
\]

Zero defects compose under subdivision, and two consecutive Lorentz-parallel
edges preserve the metric from the initial to the final coframe. These are
finite tetrad/metric-compatibility theorems in
`NondegenerateSolderingGeometry.lean`. They still assume the coframes and
Lorentz transports; they do not reconstruct either from a bare causal order.

### 4.4 Curvature, torsion, and nonmetricity must remain distinct

For a small loop or causal diamond, connection curvature is represented by a
holonomy defect. Schematically,

\[
  U_{\partial\Diamond}=1+F_{ab}\,A^{ab}+O(A^2).
\]

At finite spacing, the loop holonomy itself is primary; extracting a curvature
two-form requires a refinement limit and an area normalization.

Three failures must not be conflated.

- **Curvature:** metric-compatible transport has nontrivial loop holonomy.
- **Torsion:** transported edge displacements fail the appropriate closure or
  parallelogram law.
- **Nonmetricity:** transport fails to preserve the induced metric.

The current finite modules implement useful algebraic versions of these slots,
but no continuum tensor identification has yet been proved.

### 4.5 Exact finite compatibility and Bianchi chain

The finite connection algebra can now be stated without analogy. Define

\[
  [X,Y]=XY-YX,
  \qquad
  \{X,Y\}=XY+YX,
  \qquad
  F_{ab}=[\nabla_a,\nabla_b],
\]

and let the adjoint covariant derivative be

\[
  \nabla^{\mathrm{ad}}_a X=[\nabla_a,X].
\]

The Jacobi identity gives the exact cyclic relation

\[
  \nabla^{\mathrm{ad}}_aF_{bc}
  +\nabla^{\mathrm{ad}}_bF_{ca}
  +\nabla^{\mathrm{ad}}_cF_{ab}=0.
\]

This is **M [orig]** in
`PhysicsSM/Draft/NullEdge/FiniteConnectionGeometry.lean`. It is the algebraic
connection-Bianchi identity. It is not yet the torsional first Bianchi identity
\(D T=F\wedge e\), a continuum second-Bianchi theorem for a reconstructed
Riemann tensor, or the contracted identity \(\nabla_\mu G^{\mu\nu}=0\).

The torsionful partner can also be derived exactly. For fixed frame labels and
coframe operators \(E_a\), define

\[
  T_{ab}
    =\nabla_a^{\mathrm{ad}}E_b
      -\nabla_b^{\mathrm{ad}}E_a.
\]

Associativity then gives the finite Cartan identity

\[
  \nabla_a^{\mathrm{ad}}T_{bc}
  +\nabla_b^{\mathrm{ad}}T_{ca}
  +\nabla_c^{\mathrm{ad}}T_{ab}
  =[F_{ab},E_c]+[F_{bc},E_a]+[F_{ca},E_b].
\]

Consequently, if this fixed-label torsion vanishes for every pair, then

\[
  [F_{ab},E_c]+[F_{bc},E_a]+[F_{ca},E_b]=0.
\]

These are **M [orig]** results in `FiniteCartanBianchi.lean`, whose paired
capstone includes both the Cartan first-Bianchi shape and the connection/Jacobi
second-Bianchi shape. The result does not yet define a graded cellular
covariant coboundary or wedge product, include anholonomic frame structure
coefficients, or prove nonvacuous 3-cell/integrated-cycle content. Those are
required before identifying it with the geometric equation
\(D T=F\wedge e\) on a reconstructed null-edge complex.

There is nevertheless an exact fixed-transform covariance theorem. If both
\(\nabla_a\) and \(E_a\) are sent through the same sandwich
\(X\mapsto gXg_L^{-1}\), with \(g_L^{-1}g=1\), then \(T_{ab}\) and each side of
the finite Cartan identity acquire the same outer sandwich. This is
**M [orig]**. It does not cover site-dependent frame rotations, where a genuine
connection transformation includes endpoint or derivative correction terms.

The standard contraction step has also been isolated exactly. In a finite
orthonormal-frame component model, let \(s_a^2=1\) be diagonal inverse-metric
weights and let \(D_eR_{abcd}\) be antisymmetric in \((a,b)\) and in \((c,d)\). From
the uncontracted differential identity

\[
  D_eR_{abcd}+D_cR_{abde}+D_dR_{abec}=0,
\]

`FiniteContractedBianchi.lean` performs both finite sums and proves

\[
  2\,\operatorname{div}Ric=\operatorname{grad}R,
  \qquad
  \operatorname{div}\!\left(Ric-\frac12 gR\right)=0.
\]

This is **M [comp]**, a machine formalization of the standard tensor
contraction, with a nonzero \(1+1\) Lorentz-signature witness
\(D_eR_{abcd}=q_e\epsilon_{ab}\epsilon_{cd}\) for which
\(\operatorname{div}Ric=-1\) and \(\operatorname{grad}R=-2\). It is not yet a
null-edge derivation of the premises: the open bridge must identify normalized
finite curvature with such components, establish the required symmetries and
differential Bianchi identity, and control refinement. What is now closed is
the contraction algebra after those geometric inputs are available.

Under the strong finite tetrad postulate

\[
  [\nabla_a,C_b]=0 \quad\text{for all }a,b,
\]

the same module proves

\[
  [\nabla_a,\{C_b,C_c\}]=0,
  \qquad
  [F_{ab},C_c]=0.
\]

The first equation is metric compatibility for the Clifford-anticommutator
metric proxy with globally fixed frame labels. The second is its curvature
integrability consequence. Both are exact finite identities. Neither by itself
constructs a continuum tetrad, identifies a Levi-Civita connection, or proves
that the finite \(F_{ab}\) converges to Riemann curvature.

The connection algebra also has an **M [orig]** covariance layer. If
\(g_L^{-1}g=1\), then the fixed transform
\(X\mapsto gXg_L^{-1}\) carries commutators, anticommutators, and curvature to
their correspondingly transformed values. Only the displayed left-inverse
relation is needed for these identities. Without the right-inverse relation,
however, this transform need not be an automorphism or group action; a genuine
local Lorentz gauge interpretation still requires bundle data and two-sided
spin transport.

## 5. The Dirac square as a geometric organizer

In continuum spin geometry, a Dirac-type square separates a connection
Laplacian from curvature endomorphisms. This is the conceptual role of the
Lichnerowicz-Weitzenbock formula.

The null-edge carrier has an exact finite analogue. For a soldered operator

\[
  D_0=\sum_a \gamma_a\nabla_a,
\]

the repository proves **M [orig]** a master algebraic split of \(D_0^2\) into
symmetric Gram/anticommutator data and antisymmetric
Clifford-commutator/transport-commutator data. In the larger carrier notation,

\[
  4D^2=Q_A+Q_C+4Q_T
\]

under covariantly constant soldering, while varying soldering introduces an
additional \(E\)-slot in the Krein-adjoint square.

The more explicit finite tetrad/Lichnerowicz chain uses

\[
  D_N=\sum_a C_a\nabla_a,
  \qquad
  D=iD_N+\Gamma_s\Phi,
\]

and proves

\[
  D_N^2=K_{\mathrm{null}}+C_{\Diamond}+T_{\mathrm{frame}},
\]

where

\[
\begin{aligned}
  K_{\mathrm{null}}
    &=\frac14\sum_{a,b}\{C_a,C_b\}\{\nabla_a,\nabla_b\},\\
  C_{\Diamond}
    &=\frac14\sum_{a,b}[C_a,C_b][\nabla_a,\nabla_b],\\
  T_{\mathrm{frame}}
    &=\sum_{a,b}C_a[\nabla_a,C_b]\nabla_b.
\end{aligned}
\]

With the project-wide super-Dirac sign hypotheses, this gives

\[
  D^2=-K_{\mathrm{null}}-C_{\Diamond}-T_{\mathrm{frame}}
      +\Phi^2
      -i\Gamma_s\sum_a C_a[\nabla_a,\Phi].
\]

The finite tetrad postulate kills \(T_{\mathrm{frame}}\) exactly. If the mass
field is also covariantly constant, the final derivative term vanishes and the
square reduces to kinetic, curvature-commutator, and positive mass-square
blocks. These are **M [orig]** results in
`NullEdgeFiniteTetradPostulate.lean`,
`NullEdgeFiniteLichnerowiczBridge.lean`, and the new
`FiniteConnectionGeometry.lean` composition theorem.

The continuum Lichnerowicz target is much more specific: after identifying
the principal symbol and connection Laplacian, the curvature endomorphism must
contract to the convention-correct scalar term, ordinarily \(R/4\) for the
standard spin Dirac operator. The current finite theorem identifies the slot,
not that coefficient or limit.

The intended meanings are:

- \(Q_A\): aperture or symmetric Gram sector;
- \(Q_C\): closure/curvature-like commutator sector;
- \(Q_T\): turn or finite-potential sector;
- \(E\): soldering-gradient sector, where gravity-shaped defects can live.

The crucial honest statement is:

> Unification here is an exact decomposition of one operator square, not an
> identification of all four channels and not a derivation of Einstein
> dynamics.

With commuting scalar weights, the square reduces to a scalar Gram form and the
bivector closure slot vanishes. Nontrivial curvature therefore requires
noncommuting covariant transports or differences. This is a useful structural
constraint on any gravitational extension.

## 6. Selected dynamics and secondary routes

Finite covariance and curvature slots are kinematics. General relativity also
needs a selection law. This note now selects the order/operator variational
route as primary. Thermodynamic, spectral, and teleparallel constructions are
retained as independent continuum checks and possible effective
reformulations; their finite avatars must not be added as separate fundamental
sources of the same Einstein-Hilbert term.

### 6.1 Order/operator variational route (primary)

The causal operator supplies a scalar-curvature estimator because

\[
  \widehat B_C1\longrightarrow-\frac12R,
  \qquad R_C^B=-2\widehat B_C1.
\]

The selected bare gravitational action is therefore an interval-count action
of the form

\[
  \boxed{
  S_g[C]=\frac{1}{16\pi G_0}
    \sum_{x\in C}\ell^4\left(R_C^B(x)-2\Lambda_0\right)
    +S_{\partial C}.}
\]

Benincasa-Dowker-Glaser operators provide the primary literature model for
this proposal. Their continuum analyses recover the Einstein-Hilbert bulk
term in manifoldlike regimes and support a codimension-two joint term for
causally convex regions. The displayed normalization is still a theory choice:
the null-edge program must convention-lock the finite coefficients, boundary
prescription, path-sum measure, and renormalized coupling before making a
physical claim.

A coframe or Dirac spectral action remains a valuable comparison. For example,
one may study

\[
  S_f=\operatorname{Tr} f(D^\#D).
\]

The repository proves finite polynomial examples in which an order-two term
splits into a constant and a curvature-labelled functional, and stationarity
gives a finite scalar equation. These are **M [orig]** avatars.

To show that either finite functional reaches the same infrared action, the
program must prove:

1. convergence of the finite operator or spectral density;
2. a heat-kernel or equivalent asymptotic expansion;
3. identification of the coefficient of \(R\sqrt{|g|}\);
4. control of higher-curvature and nonlocal terms;
5. the correct boundary contribution;
6. a finite-to-continuum variation theorem;
7. a nonzero, correctly normalized Newton coupling.

Without those steps, naming a finite quadratic `Rfin` does not make it scalar
curvature. The spectral term should not initially be summed with the
interval-count action as a second independent source of \(R\sqrt{|g|}\).

### 6.2 Thermodynamic route (secondary continuum check)

Jacobson's continuum argument derives Einstein's equation as an equation of
state by imposing the Clausius relation on every local Rindler horizon, together
with entropy-area proportionality, Unruh temperature, energy flux, and the
Raychaudhuri equation.

The derivation is short enough to display. Choose a local horizon generator
\(k^\mu\), affine parameter \(\lambda\), and an instantaneously stationary cut
with expansion and shear vanishing at the reference event. The null
Raychaudhuri equation then gives, to leading order,

\[
  \theta(\lambda)=-\lambda R_{\mu\nu}k^\mu k^\nu+O(\lambda^2),
\]

so the area change is

\[
  \delta A
    =-\int \lambda R_{\mu\nu}k^\mu k^\nu
      \,d\lambda\,dA.
\]

For entropy density \(\eta\), \(\delta S=\eta\,\delta A\). Near the horizon,
the approximate boost Killing field is
\(\chi^\mu=-\kappa\lambda k^\mu\), so the matter heat flux is

\[
  \delta Q
    =-\kappa\int \lambda T_{\mu\nu}k^\mu k^\nu
      \,d\lambda\,dA.
\]

Using the Unruh temperature \(T=\hbar\kappa/(2\pi)\), the Clausius relation
\(\delta Q=T\delta S\) implies

\[
  R_{\mu\nu}k^\mu k^\nu
    =\frac{2\pi}{\hbar\eta}
      T_{\mu\nu}k^\mu k^\nu
\]

for every null \(k^\mu\). Therefore

\[
  R_{\mu\nu}-\frac{2\pi}{\hbar\eta}T_{\mu\nu}
    =f g_{\mu\nu}
\]

for some scalar \(f\). Stress-energy conservation and the contracted Bianchi
identity then fix \(f=-R/2+\Lambda\). With
\(\eta=1/(4\hbar G)\) in units \(c=k_B=1\), one obtains

\[
  G_{\mu\nu}+\Lambda g_{\mu\nu}=8\pi G T_{\mu\nu}.
\]

This is **T|H [import]**: the conclusion is Einstein's equation, but every
local-horizon, equilibrium, area-entropy, Unruh, Raychaudhuri, and conservation
hypothesis matters. It is attractive for null edges because the contraction is
tested in every null direction rather than assumed as a full tensor equation.

The repository proves **M [orig]** a finite two-variable avatar in which

\[
  \delta Q=T\,\delta S

\]

for all displayed variations is equivalent to a finite gradient equation.
This validates an integrability pattern. It does not reproduce the continuum
argument's local horizons, focusing equation, stress tensor, or universality in
all null directions.

The successor theorem must supply those missing identifications rather than
relabel the finite variables.

### 6.3 Teleparallel route (secondary geometric reformulation)

Teleparallel gravity describes gravity using a coframe and torsion with a flat
connection, and the TEGR action is equivalent to Einstein-Hilbert gravity up to
a boundary term under the continuum hypotheses. This is attractive for a
null-edge framework because edge displacement defects are naturally
torsion-shaped.

The repository contains **M [orig]** finite teleparallel soldering and source
avatars. A successful continuum route must nevertheless prove:

- the appropriate flatness and metricity conditions;
- the exact convention-locked TEGR torsion combination;
- convergence of the finite torsion functional;
- the boundary-term relation to Einstein-Hilbert;
- local Lorentz covariance of the completed construction;
- equivalence of the resulting field equation to Einstein's equation.

Discrete teleparallel and Regge constructions already exist in the literature,
so novelty must lie in the null-edge carrier, its operator decomposition, or a
new reconstruction theorem, not in discretizing torsion by itself.

## 7. Matter, source, and the equivalence principle

The finite carrier separates aperture, closure, turn, and soldering sectors.
The repository also contains explicit finite actions in which a soldering
response is sourced by a sum of matter-channel budgets with a channel-blind
coupling. These are **M [orig]** finite weak-equivalence-principle avatars.

There is also an **M [orig]** finite Noether link in
`FiniteDynamicsNoetherThermoCapstone.lean`. For a self-adjoint finite operator
\(A\) and a unitary \(U\) commuting with it, the same commutation hypothesis
both transports mass-shell solutions to solutions with the same eigenvalue and
conserves the real \(A\)-expectation along the complete discrete \(U\)-orbit.
This is a real symmetry/conservation theorem, but its conserved observable is
not a spacetime stress tensor and the orbit parameter is not yet reconstructed
proper time.

One further final-step implication is now exact at the abstract operator level.
In `FiniteGravityConservation.lean`, for elements of an arbitrary associative
ring,

\[
  \mathcal G=\kappa\mathcal T,\qquad
  [\nabla,\kappa]=0,\qquad
  \kappa_L^{-1}\kappa=1,\qquad
  [\nabla,\mathcal G]=0
  \quad\Longrightarrow\quad
  [\nabla,\mathcal T]=0.
\]

This is an **M [orig]** conditional Bianchi-to-source-conservation bridge. A
nonzero \(2\times2\) rational matrix witness with mutually noncommuting source
and coupling verifies that its hypotheses are jointly satisfiable. It
identifies the exact algebraic last step. It does not construct \(\mathcal G\)
as an Einstein operator, prove the geometric or
contracted Bianchi identity, define \(\mathcal T\) by coframe variation, or
derive universal coupling. Thus its `CovariantlyConserved` predicate is an
adjoint-commutator proxy until those geometric identifications are supplied.
The proof factors through the exact adjoint Leibniz rule. Its sharper form
requires only that left multiplication by \(\kappa\) cancel a zero product;
the displayed left inverse is a simple sufficient hypothesis.

Continuum gravitational sourcing requires substantially more:

1. a local stress-energy tensor obtained by variation with respect to the
   reconstructed coframe or metric;
2. a proof of covariant conservation,
   \(\nabla_\mu T^{\mu\nu}=0\);
3. a discrete Bianchi or Noether identity whose limit gives
   \(\nabla_\mu G^{\mu\nu}=0\);
4. universal coupling before taking traces or expectation values;
5. agreement with the matter equations of motion;
6. weak-field and equivalence-principle tests.

A scalar budget equality is not yet a tensor field equation. The project
charter correctly requires gravity to remain a constrained quotient until a
covariant conserved source exists.

## 8. Lorentz invariance and the role of regulators

A fixed finite hyperdiamond or finite-valency null lattice is useful for exact
algebra, spectra, and continuum-rate estimates. It is not exactly invariant
under the noncompact Lorentz group.

The intended ontology instead uses random causal orders that are Lorentz
invariant in distribution, with finite lattices demoted to gauge-fixed
regulators. This move has two consequences.

First, Poisson sprinkling avoids selecting a preferred direction in the precise
measure-theoretic sense proved by Bombelli-Henson-Sorkin. Second, the same result
prevents an intrinsic finite-valency graph or finite null frame from being
extracted equivariantly. The framework therefore needs a damped or layered
transport kernel rather than naive nearest-neighbor propagation on a sprinkled
causal set.

A complete Lorentz gate should prove:

- distributional covariance of the random substrate;
- covariance or controlled gauge dependence of decorations;
- convergence of observables, not just of a preferred coordinate symbol;
- suppression of regulator anisotropy;
- absence of unwanted nonlocal tails or preferred-frame dispersion;
- compatibility with the branch and doubling audits of the fermion sector.

## 9. Horizons, entropy, and cosmology

Null boundaries are natural in both general relativity and the null-edge
framework, but several distinct claims must remain separated.

### 9.1 Horizons and area

A finite causal diamond can carry a boundary count, flux, and entropy-like
functional. To recover black-hole or local-horizon thermodynamics, the program
must identify a continuum area, derive or justify the entropy coefficient, and
show that the relevant null generators obey the correct focusing law.

### 9.2 Cosmological constant

If number reconstructs volume, causal-set-inspired arguments motivate a
conjugacy between volume and \(\Lambda\), and Poisson fluctuations suggest a
scale \(|\Lambda|\sim V^{-1/2}\). The repository has exact finite scaling and
count-statistics fork theorems, including a hyperuniform branch that suppresses
the fluctuation.

These are not a derivation of the observed cosmological constant. The physical
count variable, sign, stochastic law, backreaction, and observational viability
remain open. The framework should preserve this as a falsifiable fork rather
than a prediction already won.

## 10. Current theorem ledger

| Statement | Grade | What is actually established | Missing bridge |
|---|---|---|---|
| Causal structure fixes continuum conformal geometry under causality hypotheses | T [import] | Light cones and conformal class | Finite-order reconstruction and scale |
| Counting can represent spacetime volume in a manifoldlike causal set | T|H [import] | Order-number reconstruction principle | Density, manifold approximation, fluctuations |
| Causal conformal class plus smooth positive volume fixes the metric uniquely | T|H [interp] | Explicit positive conformal factor \(\Omega=(d\mu/d\operatorname{Vol}_{\bar g})^{1/d}\) | Prove the null-edge order/count limit supplies both inputs |
| A finite strict causal order and supplied scales construct the local/smeared four-dimensional causal operator and its corrected pairing | M [comp] | Open-interval layers, exact local and smeared coefficients, relabeling covariance, project-sign conversion, same-scale local reduction, function-level potential cancellation, and a nonzero two-event layer witness. The natural zero-sum carrier subspace transports up to basis change and has a rank-four five-event control; its corrected pairing is basis-free, four-probe Gram matrices obey exact congruence, and a Lorentz-normalized frame leaves exactly the Lorentz stabilizer. Simultaneous scale change gives the operator and fixed-frame Gram matrix inverse-square weight, reciprocal to the count-derived coframe metric weight, with an exact sixteen-to-one `4` versus `1/4` witness. Count-band two-sided retarded shells and qualitative subspace visibility are intrinsic; visible rank is at most shell cardinality, so a sub-four shell forbids rank four, and a four-leaf control proves sharpness. A3b recovers the adjacent hierarchy; A3c then shows global-shell availability grows strongly with infrared diamond volume at fixed local scales. An exact finite family realizes arbitrary shell cardinality at one fixed minimal count band and nonzero two-sided abundance | Replace the global shell by a compact order-derived Alexandrov carrier or equivariant bracket ensemble; prove carrier refinement/overlap stability, then derive a retarded-visible low-complexity probe subspace with quantitative coverage and product control; derive dimension and positive scales from physical data; prove evaluation convergence, stable rank-four Lorentzian inertia, count-volume agreement, and concentration without embedding-tuned support |
| Bare-relation invariance does not fix absolute scale | M [orig] | Every positive invariant scale has distinct positive global rescalings; transitive relations force invariant scalar fields to be constant | Derive symmetry-breaking calibration data from the physical ensemble |
| Calibrated count fixes a positive four-dimensional Weyl factor on a supplied coframe ray | M [orig] | Exact fourth-root reconstruction and positive-factor uniqueness, with nonzero witnesses | Derive density, manifoldlikeness, and the conformal coframe representative |
| A common unknown count density cancels from relative four-dimensional Weyl and plaquette-area factors | M [orig] | For positive counts and supplied nondegenerate conformal representatives, the density-free profile obeys \(r^4=n\operatorname{Vol}(e_0)/(n_0\operatorname{Vol}(e))\); one positive anchor fixes all relative scales, \(r^2\) fixes the relative area weight, and the positive reconstruction is unique. Fixed-anchor invariance and simultaneous-anchor covariance are distinct checked statements. Overlap transitions compose multiplicatively, reverse transitions multiply to one, and the area weights obey the squared cocycle. Invariant data on a vertex-transitive relation give only a constant profile | Derive regions, counts, the shared-density regime, conformal representatives, dimension four, manifoldlikeness, refinement-compatible overlaps, and the remaining global unit |
| Noncollinear null sums can be timelike | T [import] | Positive invariant norm from null cross terms | Dynamical selection of histories |
| Two-direction 1+1 null ticks obey \(\tau^2=4\varepsilon^2N_+N_-\), with a null/timelike dichotomy and balanced maximum | M [comp] | Exact endpoint algebra and nonzero two-tick witness | Curved-spacetime reconstruction and history dynamics |
| Null-spinor exterior area gives a finite mass operator | M [orig] | Exact finite algebra and gap-closing locus | Absolute scale and interacting renormalization |
| Finite coframe nondegeneracy and induced-metric invariance | M [orig] | Correct matrix-frame covariance | Continuum tetrad bundle |
| A metric does not canonically select a coframe; determinant-one \(A\) and \(-A\) have equal Pauli/Hermitian Minkowski action and opposite nonzero spinor action | M [orig] | Explicit nondegenerate rational Lorentz-gauge witness plus `(+---)` Hermitian action and determinant preservation; bundled \(-I\in SL(2,C)\) is nontrivial, central, order two, and acts trivially by Hermitian congruence before and after edge re-signing | Derive a gauge-relative coframe, prove the Hermitian-action kernel is exactly \(\{I,-I\}\), construct covering surjectivity, and establish global/refinement compatibility |
| Residual spin-lift signs are gauge-trivial on a path and have one `ZMod 2` cycle invariant on a square | M [orig] | Every three-edge path assignment is removed by vertex signs; square assignments are gauge equivalent iff their cycle parities agree, giving exactly two boundary sectors. A supplied defect on one filled face selects one nonempty gauge class. For two square disks glued along one boundary, a shared correction exists exactly when the two defects agree, equivalently when their sum vanishes; `(0,1)` is an exact obstruction witness. The boundary sectors have identical Hermitian Lorentz action but different nonzero spinor action | Prove local Lorentz lift existence, derive graph coframes and face attachments, identify the obstruction with `w2`, and prove continuum spin-bundle convergence |
| A finite `ZMod 2` face-edge boundary matrix gives a complete closed-cycle and quotient-class criterion for spin-lift sign correction | M [orig] | A defect is an edge-sign coboundary exactly when every closed formal face cycle pairs with it to zero, equivalently exactly when there is no nonzero closed-cycle certificate. Its class in `C^2 / im delta` vanishes exactly in that case and is unchanged by adding a coboundary; the glued-square mismatch is nonzero in the quotient | Relate the finite class to graph-derived local lifts, a good-cover nerve, `w2`, and refinement/continuum compatibility |
| Ordered finite face walks and chosen group lifts derive the incidence matrix and central face-defect cochain | M [orig] | For a supplied nontrivial central involution and base face products in `{1,c}`, literal edge re-signing changes the derived cochain by the incidence coboundary and leaves its quotient class invariant. The class vanishes exactly when all face holonomies can be flattened. A four-edge square has a nonzero representative but zero class under an explicit correction | Derive the faces and local `SL(2,C)` lifts from bare graph/coframe/Lorentz data, prove Lorentz-flat products land in the exact central kernel, establish cover/refinement invariance, and identify the class with `w2` |
| Zero coframe defect plus Lorentz transport preserves the induced metric and composes | M [orig] | Exact one-edge and two-edge parallel-metric theorems | Derivation of coframes/transports and refinement convergence |
| Soldering defects transform covariantly and compose | M [orig] | Finite transport/refinement algebra | Geometric convergence and locality |
| Closed holonomy transforms by conjugation | M [orig] | Gauge-covariant finite loop observable | Curvature normalization and continuum limit |
| Finite tetrad postulate implies Clifford-metric and curvature compatibility; fixed one-sided conjugation-shaped transforms preserve the connection algebra | M [orig] | Exact commutator identities and covariance with displayed left inverse | Local Lorentz group action, rotating labels, bundle reconstruction, and convergence |
| Finite commutator curvature obeys cyclic adjoint Bianchi | M [orig] | Exact Jacobi identity | Geometric and contracted Bianchi limits |
| Fixed-label Cartan torsion obeys the torsionful first-Bianchi shape and fixed-sandwich covariance | M [orig] | Exact cyclic derivative/curvature-action identity, torsion-free corollary, and covariance of both sides | Graded cochains, site-dependent local labels, anholonomy, and 3-cell content |
| Finite-index Riemann derivative symmetries plus differential Bianchi imply divergence-free Einstein combination | M [comp] | Explicit double contraction with a nonzero (1+1) Lorentz witness | Derive the component premises from null-edge transport |
| First-order shrinking-loop holonomy expansion or a raw `area * epsilon` remainder bound implies area-normalized curvature convergence | M [orig] | Exact normed-space normalization, quantitative error bound, and a nonzero shrinking-area witness | Derive the area and raw remainder estimate for null-edge diamonds |
| Explicit near-identity links on a decorated finite torus have an exact nonzero plaquette-curvature limit | M [orig] | Ordered path difference is exactly `h^2[A,B]`; explicit nilpotent generators give invertible links and genuine closed-square holonomy whose area-normalized identity displacement converges to the signed nonzero commutator | General graph-derived transports and areas, refinement maps, continuum tensor identification, and curvature-derivative convergence |
| The exact trigonometric group commutator has nonzero unitary iterated, synchronized diagonal, and unrestricted joint curvature limits | M [comp] | Besides the iterated and diagonal results, an exact two-variable expansion factors the full displacement as `sin(p)*sin(q)` times a continuous bracket with origin value `G*A-A*G`; the sinc extension proves the product-area quotient converges for arbitrary unequal rates, and every nonzero-product refinement sequence may sample it | Graph realization, calibrated plaquette areas, refinement maps derived from the graph, continuum curvature identification, and curvature-derivative convergence |
| Componentwise refinement convergence carries curvature antisymmetries and differential Bianchi to a divergence-free limiting Einstein combination | M [orig] | Limiting identities follow by uniqueness of limits and explicit contraction, with a nonzero component witness | Connect matrix holonomy to curvature-derivative components and justify derivative convergence |
| Null-soldered Dirac square splits into Gram and commutator sectors | M [orig] | Exact finite Weitzenbock-shaped identity | Continuum Lichnerowicz identification |
| Finite connection identities compose with the tetrad-specialized Lichnerowicz square | M [orig] | One guarded G3/G4/G5 theorem chain | Principal-symbol and curvature-coefficient convergence |
| Finite stationarity, source, and Clausius avatars | M [orig] | Nonvacuous finite equations | Einstein tensor and conserved stress tensor |
| One finite symmetry hypothesis transports mass-shell solutions and conserves an operator expectation | M [orig] | Exact finite Noether link | Spacetime symmetry, local current, and stress-tensor conservation |
| Field equation plus adjoint Bianchi and parallel left-cancellative coupling implies source conservation | M [orig] | Exact noncommutative Leibniz/cancellation implication; a left-invertible matrix witness with noncommuting source/coupling | Construct the Einstein operator, contracted Bianchi theorem, variational stress tensor, and universal coupling |
| Scalar matter budgets do not determine stress-energy | M [orig] | Explicit distinct symmetric four-tensors with equal rest energy density or equal ordinary matrix trace | Construct the full metric/coframe variation, including pressures and fluxes |
| A full symmetric component response determines its symmetric coefficient tensor uniquely | M [orig] | Equality of finite Frobenius response on every symmetric probe forces matrix equality | Prove the null-edge matter action has the corresponding localized, measure-normalized derivative and satisfies the Noether identity |
| A homogeneous scalar one-cell action yields density and pressure from distinct diagonal responses | M [comp] | The action includes the oriented diagonal coframe determinant and inverse lapse; lapse variation gives minus the oriented spatial-volume factor times `rho`, each spatial-scale variation gives lapse times an oriented opposite-face factor times `p`, and a nonzero covariant orthonormal perfect-fluid component matrix is assembled | Positive-orientation and nondegeneracy hypotheses for the geometric reading; spatial gradients and fluxes; arbitrary coframe variations; graph localization; the scalar equation of motion; Lorentz/Noether identities; covariant conservation |
| One scalar spatial-gradient channel yields anisotropic diagonal stress | M [comp] | Four variations of one oriented diagonal action give \(\rho=K_t+K_x+V\), longitudinal pressure \(p_1=K_t+K_x-V\), and transverse pressures \(p_2=p_3=K_t-K_x-V\); an exact witness has \((\rho,p_1,p_2,p_3)=(5,3,-1,-1)\) | Arbitrary gradients and coframe variations; localization; scalar field equation; Noether identity; on-shell conservation |
| One ADM-shift variation yields scalar momentum flux | M [comp] | For \(\theta^1=a_1(dx^1+\beta dt)\), the checked shift derivative is minus the canonical momentum density; its exact coframe conversion gives \(T_{\hat0\hat1}=((\dot\phi-\beta\partial_1\phi)/N)(\partial_1\phi/a_1)\), with a nonzero unit witness and symmetric assembled component matrix | Arbitrary off-diagonal coframe variations; general gradients; graph localization; scalar field equation; local Lorentz/diffeomorphism Noether identity; symmetric on-shell conserved stress tensor |
| Flat-FLRW lapse stationarity is equivalent to the first Friedmann equation | T\|H [comp/import] | Assuming the standard boundary-reduced Einstein-Hilbert minisuperspace action, adding the constructed homogeneous scalar action and varying the lapse gives exactly \(H^2=(8\pi G/3)\rho+\Lambda/3\), with a nondegenerate positive-matter witness | Derive the FLRW reduction, Einstein-Hilbert action, lapse, scale factor, \(G\), and \(\Lambda\) from graph data; add inhomogeneous dynamics |
| Flat-FLRW scale Euler--Lagrange stationarity yields the spatial and acceleration equations | T\|H [comp/import] | The checked scale partial and momentum time derivative give \(2N^{-1}dH/dt+3H^2=\Lambda-8\pi Gp\); combining this independent scale equation with the lapse equation gives \(\ddot a/(aN^2)-\dot a\dot N/(aN^3)=\Lambda/3-(8\pi G/6)(\rho+3p)\), with an exact accelerating scalar-potential witness | Derive the continuum reduction and constants from graph data; general metric variations, scalar equation, Bianchi/Noether consistency, inhomogeneous Einstein dynamics, and physical cosmological solutions |
| The standard weak-field `00` reduction with \(8\pi G/c^4\) is equivalent to Poisson normalization | M [comp] | Exact constant arithmetic with a nonzero witness | Derive the linearized Einstein component and nonrelativistic source from null-edge dynamics |
| Dust and radiation density laws satisfy scale-factor FLRW continuity | M [comp] | Exact derivative and conservation checks for \(\rho\sim a^{-3}\) and \(\rho\sim a^{-4}\) | Derive homogeneous geometry, Friedmann dynamics, and the equations of state from the model |
| Gravity emerges from entropy monotonicity on nested causal regions | C [orig] | Research route only | Raychaudhuri, area law, all-null-direction theorem |
| The null-edge framework reproduces Einstein's equation | C [orig] | Not established | Full reconstruction ladder below |

## 11. Required reconstruction ladder

The following sequence is designed so that each rung can fail cleanly.

### G0. Manifoldlike causal approximation

Construct an ensemble of locally finite orders and a map to continuum regions
for which interval counts and causal relations converge in probability.

Use a two-scale limit rather than a one-event stencil:

\[
  \ell\ll L\ll L_{\mathrm{curv}},
  \qquad
  \ell\to0,\quad L\to0,\quad \ell/L\to0.
\]

Then each reconstruction region contains asymptotically many events while
shrinking in continuum units. Every metric, topology, connection, and Dirac
estimator must state which parts of its error are controlled by \(\ell/L\) and
which by \(L/L_{\mathrm{curv}}\).

Keep two questions separate. The first asks whether the reconstruction pipeline
converges when the order is known to be sprinkled from a manifold. The second
asks whether the proposed gravitational ensemble concentrates on such orders.
A quantitative test family should combine independently measured defects, for
example

\[
  \mathfrak M_L(C)
    =w_{\mathrm{sig}}\delta_{\mathrm{sig}}
     +w_{\mathrm{alg}}\delta_{\mathrm{chain/product}}
     +w_{\mathrm{vol}}\delta_{\mathrm{count/metric}}
     +w_{\mathrm{curv}}\delta_{\mathrm{curvature}}
     +w_{\mathrm{top}}\delta_{\mathrm{topology}}
     +w_{\mathrm{loc}}\delta_{\mathrm{nonlocality}}.
\]

The weights, normalization, scale interval, and held-out thresholds must be
fixed before testing the dynamics. The eventual ensemble gate is concentration
in probability,

\[
  \Pr[\mathfrak M_{L(\ell)}(C)>\varepsilon]\longrightarrow0,
\]

not merely successful reconstruction on manifold-generated controls. Stable
mesoscopic nerve homology and agreement among the independent curvature
estimators belong here, but they remain unopened until the metric and first-jet
gates close.

**Success:** causal intervals, dimension estimators, and volumes converge on a
specified class of spacetimes.  
**Kill:** no stable manifoldlike sector or uncontrolled nonlocality.

### G1. Conformal reconstruction

Recover the continuum causal relation and prove that it determines the target
conformal class under explicit causality hypotheses.

**Success:** the reconstructed light cones converge independently of regulator
frame.  
**Kill:** persistent preferred cones or inequivalent conformal limits.

### G2. Operator metric and unique scale reconstruction

Construct a count-normalized causal operator and prove that its corrected
carre du champ converges on a mesoscopic probe sector to the full inverse
metric. The finite Gram matrix must exhibit a stable rank-four Lorentzian image
with signature \((+---)\), and its induced volume must agree with counting.

The checked finite boundary is exact: a strict finite causal order determines
open-interval layers and therefore the selected local or smeared
four-dimensional operator once its scales are supplied; scalar zeroth-order
potentials cancel from the resulting function-level corrected pairing. What is
not checked is why the physical graph selects this four-dimensional coefficient
family, how it determines positive microscopic and mesoscopic scales, selection
of \(\mathcal H_D\), joint convergence on products, concentration,
rank/signature stability, or volume convergence.

The Stage A oracle is the first executable partial pass of this gate. It
recovers rank-four Lorentzian ensemble means over a mesoscopic scale window and
shows improving per-sprinkling signature reliability with density. It does not
pass G2 because its probes and smooth support are selected using embedding
coordinates, its absolute density and \(L_k\) are supplied, its finite metric
normalization remains biased, and no joint continuum theorem or count-volume
agreement has been demonstrated.

The Stage A2 intrinsic-probe benchmark closes three tempting shortcuts. Neither
causal-profile PCA, the four lowest right-singular modes of the smeared
operator, nor a fixed normal-operator smoothing of the profile modes passes the
joint metric gate at \(N=400,800,1200\). Their subspaces are label-covariant,
so the failure is geometric rather than a relabeling artifact. These selectors
must not be promoted to \(\mathcal H_D\) without a new mechanism that enforces
two-sided interiority, retarded support, product regularity, and stability over
a scale interval.

The Stage A3 order-side audit confirms the proposed failure mechanism. On the
best availability tuple from the pre-registered development grid,
\(s/L=0.75\), every one of the three Stage A2 selectors has median
worst-direction support coverage zero and zero support-gate passes at
\(N=400,800,1200\), including samples whose retarded shell contains at least
four events. This is not merely an empty-shell artifact: global profile
variance, normal smoothing, and low global singular energy do not ensure that
each selected direction is visible to the local retarded operator row. The
same order-only scan also finds no two-sided interior at \(s/L=1.5\) for any
of 32 frozen tuples in any of 30 development sprinklings. The proposed
adjacent-scale generalized-cluster protocol therefore cannot yet be launched
on this finite-density set. This is a finite-volume/protocol kill, not an
asymptotic no-go for two-sided interiors or for the corrected operator metric.
The full result and every attempted order-side tuple are archived in the Stage
A3 support benchmark and its JSON outputs.

Stage A3b revises the scale-window part of that diagnosis. The max-clearance
schedule (s=\sqrt{\ell L}) admits the adjacent triple exactly when
(L/\ell>r^2), which for the frozen parameters means (N>743.239). Common
three-scale interiors then occur in every evaluated (N=800,1200)
realization. The support gate still fails much earlier than the eigensolver:
only `0.33%` and `2.49%` of common marks have four shell points at all scales,
and a three-realization (N=2400) diagnostic reaches only `3.23%`. The
largest-scale shell median remains zero. The next test is therefore a larger
diamond at fixed local scales, not spectral-cluster construction.

Stage A3c performs that control and finds strong boundary dependence: the
all-scale rank-capable mark rate rises from `1.93%` to `17.19%` to `36.97%`
over volume multipliers `1,2,4`, and reaches `50.85%` in a volume-eight
diagnostic, while `ell`, `L`, and every selector scale remain fixed. This does
not rescue the global shell. A fixed proper-time shell has a noncompact
rapidity direction, and the finite diamond is its infrared cutoff. The new
kernel-checked replicated-source family likewise gives arbitrary shell
cardinality at fixed minimal interval count and nonzero abundance. The global
shell is therefore killed as a local carrier; a compact order-derived
Alexandrov germ or equivariant bracket ensemble is now required.

The Stage A4 Johnston benchmark supplies a more principled conditional probe
sector. Given dimension four and absolute density, interval volumes and a
past-by-future SVD recover a relabeling-covariant local chart whose median
affine-fit error reaches `0.083` at \(N=10000\). Its pulled-metric error `0.710`
then closely tracks the coordinate control `0.677`, locating the leading
high-density error on the finite operator side rather than in the chart. This
is useful progress, but the frozen `0.50` per-realization metric gate still has
zero control passes, and the dominant SVD gap chooses spatial rank four or
five in every tested realization. Hence neither the flat operator limit nor
dimension selection is yet established, and density remains supplied.

Stage A5 then freezes an operator-only development grid before opening new
Johnston scores. No one of its 15 settings passes the flat per-realization
control gate. The selected best failure, `L=0.18` with support radius `0.65`,
also has zero passes on an independent \(N=10000\) seed. A target-fitted
positive scalar improves the held-out ensemble-mean error from `0.615` to
`0.224`, showing a recognizable conformal shape in aggregate, but that fit
cannot supply physical scale and individual rescaled errors remain too large.
The immediate G2 bottleneck is therefore operator normalization and
concentration, followed separately by dimension and absolute-scale
reconstruction. Curved-background scoring remains premature.

Stage A6 tests whether interval counts can repair the normalization without a
target-metric fit. The exact centered identity `B(fh)=2 Gamma_B(f,h)` is
kernel-checked, so a valid intrinsic quadratic field would provide the scalar
condition `Bq=8`. The tested endpoint-volume candidate is relabeling-equivariant
but severely biased and noisy: it yields zero normalized passes in both the
development grid and held-out ensemble and worsens metric errors when applied.
This particular estimator is killed. The remaining normalization task is to
construct and independently validate a mesoscopically regressed quadratic
moment before evaluating it with the causal operator.

Stage A7 supplies that independently validated moment: the Johnston quadratic
has 100% held-out probe passes and about 10% median relative error at
`N=10000`. Nevertheless, its trace factor `8/Bq_J` worsens both coordinate and
Johnston metric errors on the final held-out ensemble. This separates a
successful order-derived scalar reconstruction from a failed absolute-scale
reconstruction. A trace scalar is admissible only after a scale-free
conformal-shape estimator has controlled anisotropy and off-diagonal
fluctuations. G2 therefore remains open at that earlier shape/concentration
gate, as well as at dimension selection and count-volume agreement.

Stage A8 tests the proposed common-chart multi-row successor. A sparse
strict-past neighborhood selected at recovered radius `0.10` gives a paired
reduction in pulled Johnston conformal error from `0.755` to `0.569` and in
trace-normalized error from `1.151` to `0.709`. This is useful evidence that
averaging can suppress part of the anisotropic single-row noise. It is not a
pass: held-out Johnston gate rates remain `30%` and `20%`, and both median
errors exceed `0.50`. Increasing the one-sided neighborhood is actively
harmful; the average becomes negative definite in every development sample by
radius `0.15` and its quadratic trace collapses. G2 therefore remains at the
flat shape/concentration gate. The current broad strict-past averaging rule is
killed, while sparse averaging remains a design clue for a two-sided or
boundary-corrected estimator.

Stage A9 supplies that two-sided test through a full-interval Johnston MDS
chart. The frozen held-out coordinate controls now pass in every realization:
median conformal error is `0.234` and intrinsic-trace-normalized error is
`0.398`. Hence the finite smeared operator can recover a concentrated
Lorentzian metric on flat sprinklings once a suitable two-sided chart and all
scales are supplied. The direct recovered-chart components are also Lorentzian
in all samples, with 100% conformal passes and median trace-normalized error
`0.252`. However, the required probe-change comparison still fails after a
locally fitted pullback: trace passes are zero and median error is `1.583`.
The full chart is not locally affine enough, the dominant spectral gap chooses
rank five, neighborhood event counts are not density-stable, and count-volume
agreement remains unopened. G2 has therefore advanced past the operator
concentration subgate but remains open at local-atlas convergence, dimension,
absolute scale, and volume consistency.

Stage A10 tests the first explicit local-atlas successor. Independent
lightcone charts give good local operator controls, and their transition
cocycle median improves to `0.052` at `N=4000`. But the frozen atlas gate has
zero passes because transition residuals remain too large or a selected chart
is unavailable. Johnston atlas-metric scores therefore remain correctly
closed. Simple `GL(3)` and similarity relaxations do not explain the mismatch.
G2 now has a concrete transition-function kill condition: simultaneous chart
synchronization must produce available, density-stable overlaps and convergent
cocycles before local metrics can be transported into a common tensor field.

Stage A11 performs that simultaneous synchronization. It reduces the held-out
edge mismatch to median `0.049` and makes synchronized cocycles exact to
roundoff, but the actual common-event geometry remains above threshold at
median `0.349`, chart availability has median `0.692`, and the atlas pass rate
is still zero. Orthogonal gauge synchronization is therefore no longer the
immediate G2 bottleneck. A shared latent overlap geometry or a revised
multi-anchor chart is required before the local metric rows can define one
covariant tensor field.

Stage A12 separates the selector and geometry failures. An order-only minimum
causal-depth filter removes every observed rank-three chart-availability
failure and gives complete held-out post-filter availability and edge coverage.
However, a jointly fitted affine latent atlas still has median held-out
common-event error `0.446` under the only fully stable development setting.
Thus target eligibility has a viable order-side repair, while local coordinate
compatibility remains the immediate G2 bottleneck. Additional frame or affine
gauge fitting is now deprioritized in favor of multi-anchor or jointly factored
coordinate reconstruction.

Stage A13 tests the first multi-anchor successor by separately embedding one
count-derived Alexandrov interval around each target. It restores complete
held-out availability and overlap but worsens common-event geometry to median
`1.153`, has median local affine error `0.673`, and selects rank three in none
of the median held-out charts. This implementation is killed. The immediate G2
frontier then moves to a genuinely joint spacetime factorization with shared
event coordinates, not another post-hoc transition fit or separate local MDS.

Stage A14 tests the simplest such shared-coordinate construction by fitting
one partial Euclidean-distance stress problem. Its frozen held-out causal
distance error improves to `0.190`, but all samples select four spatial
dimensions, about 10% of untouched unrelated pairs become timelike, and local
affine error worsens from `0.113` to `0.497`. This implementation is also
killed. G2 now requires a conditioning-first reconstruction: establish
order-volume-chain well-conditioning and an intrinsic anchor scaffold, then
fit coordinates subject to those geometric controls rather than asking one
distance stress to discover geometry and absorb count noise simultaneously.

Stage A15 confirms that this conditioning-first move is not empty. Flat
sprinklings pass sampled order, count-volume, and frozen longest-chain
proper-time gates over a nontrivial mesoscopic scale window at both tested
densities. But the first intrinsic extraction of Madsen-style anchors from the
global Johnston chart produces an ill-conditioned frame despite nearly
complete causal coverage. G2 is therefore split into a positive manifoldlike
embedding audit and an open tetrad decoder. The immediate frontier is a
combinatorial max-volume trilateration selector, not curvature.

Stage A16 executes that selector and closes the narrow frame-conditioning
subgate on its held-out sample. Exact common causal brackets are available in
all three `N=4000` realizations; the chart-consensus frame and the post-selection
true-coordinate frame both pass conditioning in every case. However,
anchor-induced affine maps still fail on neighboring held-out cross events,
and independently fitted chart transitions have order-one residuals. G2 has
therefore advanced from anchor availability to a stable frame candidate, but
not to a local tetrad field. The immediate frontier is a joint shared-event
coordinate solve constrained by the selected frames. Metric transport,
connection, and curvature remain closed.

Stage A17 performs that coordinate solve locally. Three anchor-aligned charts
produce one shared patch, and count-derived proper times fit a common symmetric
metric. With the development-selected chart-metric ridge, all three held-out
patches pass coordinate, Lorentzian metric, causal-sign, coframe-factorization,
and oracle tensor controls. This closes a **conditional local metric/coframe
subgate** of G2 and provides an explicit object for the finite first-jet and
Levi-Civita bridges. It does not close G2 globally: Lorentz signature and
dimension enter through the chart prior, density and scale remain supplied,
and no overlap theorem gives a tetrad bundle or spin lift. The immediate
frontier is bundle reconstruction across multiple overlapping patches, not
curvature.

Stage A18 opens that bundle test and separates three issues. Patch existence
and overlap pass at higher density, and every held-out triple can be made
proper and time oriented by coframe sign gauges. Affine/Lorentz cocycles are
small in the median. But independently fitted metrics fail overlap covariance
in two of three realizations, so G2 still lacks a well-defined tensor field and
tetrad bundle. The exact graph spin-lift obstruction machinery remains an
uninstantiated interface until metric-compatible proper-orthochronous
transitions satisfy a stable cocycle. Curvature remains closed.

Stage A19 tests whether compatibility-based triple selection can repair that
failure without changing the independently fitted patch metrics. A strict
fit/selector/test split gives a positive `4/5` development result but zero
passes in three frozen held-out realizations. This kills compatibility-only
selection as the missing G2 bridge. The split protocol remains useful, but G2
still requires stable operator-metric reconstruction. A joint metric/coframe
synchronization that preserves local count-interval fidelity while enforcing
overlap covariance is the next conditional-atlas test, not a substitute for
that bare-graph target. Exact spin lifting and curvature remain unopened.

Stage A20 makes the first successful joint move in the conditional atlas lane.
It synchronizes three local metric regressions while retaining disjoint local
and overlap tests, and all three frozen held-out realizations pass the resulting
metric-bundle and spin-prerequisite gates. This is stronger than selecting
among independent metrics, but it remains prior-stabilized and only
approximately cocyclic. G2 therefore has a conditional metric bundle, not yet
an exact tetrad/spin bundle or a bare-graph metric. Global affine-gauge
synchronization with exact metric pullbacks is the next atlas gate; corrected
operator-metric convergence remains the primary reconstruction theorem.

Stage A21 supplies the exact flat control that A20 lacked. Global affine gauge
ratios give exact transition cocycles, one pooled constant metric gives exact
pullbacks, and all held-out flat-geometry gates pass. This does not advance G2
to curved spacetime or nontrivial spin topology: the internal transition is the
identity because every coframe is pulled back from one global representative.
The next atlas object must therefore be a position-dependent metric jet over
the same exact coordinate cocycle. Only then can the finite first-jet and Levi-
Civita interfaces meet a nonzero curvature benchmark.

Stage A22 provides the first direct curved test of the selected corrected
causal-operator metric lane. A regulator chosen from flat controls detects the
relative de Sitter conformal response on fresh samples, and higher density
stabilizes Lorentzian signature. The absolute metric and determinant volume do
not converge at the tested fixed regulator, however. G2 therefore advances to
a curved-response diagnostic while remaining open at its scale, support, and
count-volume subgates. A tetrad factorization should not be used to bypass this
failure.

Stage A23 replaces the fixed regulator with a valid shrinking three-scale
schedule and averages target-centered rows before fitting a local metric field.
This closes the finite-density signature problem and improves the relative
conformal response under refinement, but not the absolute determinant volume.
The fitted unrestricted first jet also fails its higher-density test. G2 must
therefore split the surviving operator conformal-shape estimator from an
independent count-volume Weyl estimator, recombine them, and pass volume
agreement before the Levi-Civita bridge is opened again.

Stage A24 now supplies that Weyl estimator conditionally. Shrinking local count
windows recover the absolute factor to a few percent on fresh curved controls,
and an independent Poisson thinning confirms metric/count volume agreement at
the `10%` to `15%` level at doubled density. This is the strongest current
scale result, but its windows remain coordinate-defined and its first gradient
is unstable. G2's next test is no longer whether counts can carry scale in a
known chart; it is whether the A24 factor can normalize the A23 operator shape
and then be reconstructed with intrinsic, relabeling-covariant windows.

Stage A25 performs the first half of that test. Determinant normalization fuses
the A23 operator conformal ray with the A24 count volume without using the
target metric. Every held-out fused metric remains Lorentzian, oracle-volume
errors fall to `3.7%` to `7.1%`, and disjoint count-volume disagreement is
`4.0%` to `14.5%`. The component metric still has `0.51` to `0.63` median
tensor error, however, and neither its conformal shape nor its first jet
improves uniformly at doubled density. G2 is therefore now localized to two
linked debts: convergence of the operator-derived conformal projector and an
intrinsic construction of the windows and probe quotient. The count-volume
fusion law itself should be retained.

Stage A26 shows that part of A25's shape error came from optimizing the wrong
flat objective. Determinant-normalized shape selection greatly improves several
fresh tensor scores, but it is not a convergence result: one `N=4000` curved
cell loses signature and the doubled-density flat error worsens. G2 therefore
retains shape-first selection while rejecting the current setting as
density-stable. The next development split must use multiple flat densities and
leave all curved scores untouched until the selector is frozen.

Stage A27 carries out that two-density freeze but shows that density medians are
insufficient: they select an averaging radius with poor held-out row support and
uncontrolled signature tails. G2's operator-shape successor must therefore use
tail and conditioning gates, not another median-only regulator score. The
result also strengthens the decision to keep first jets and curvature closed.

Stage A28 then repairs the tail failure with expanded support, while isolating
a persistent temporal/spatial response bias. Stage A29 removes that bias using
an affine-covariant timelike projector derived from the retarded kernel's own
first moment. The corrected tensor passes every tested signature gate and the
conditional `0.30` tensor-error gate at both densities. G2 is therefore no
longer blocked by the pivot tensor on these controls; it is blocked by intrinsic
probe/window construction, derivation of the response normalization, and a
stable differentiated metric field.

Stage A30 confirms that the differentiated response correction is algebraically
and numerically well defined and initially points to the count-volume gradient
as the dominant first-jet failure. Stage A31 improves that gradient with a
flat-control-selected affine-covariant Poisson fit, but the fused jet barely
moves. Zero-gradient and exact-target-gradient controls give the same `4-6`
error. The diagnosis is therefore revised: the dominant failure is the
determinant-normalized operator-shape derivative, not the count gradient. G2
should retain the A29 pivot tensor and A24 scale while auditing trace/volume and
unit-volume shape derivatives separately. It should not advance to connection
fitting with the present shape jet.

Stage A32 shows that reversing aggregation and nonlinear normalization is not
the repair: invariant row filtering loses `20%-30%` of the data and destroys
the pivot tensor. G2 therefore keeps aggregate-first correction and moves to a
constrained tangent fit. Its required nonvacuity control is a nonlinear chart
on flat spacetime whose exact coordinate metric has a nonzero shape jet.

Stage A33 supplies that control and finds no viable scalar tangent weight. The
two-density selector chooses zero because temporal and shear chart responses
remain below their orthogonal noise. Since a zero derivative cannot represent
the known nonlinear chart, it is a kill result. G2 is therefore open at
first-jet probe covariance before any Christoffel estimator is physically
instantiated.

Stage A34 changes the mesoscopic row geometry rather than the nonlinear
normalization. Deterministic spread selection across the averaging ball finds a
strictly positive tangent weight that beats the zero baseline on both exact
nonzero flat-chart controls while preserving the pivot metric gate. This opens
a conditional nonvacuity subgate, but the spread construction still uses
supplied embedding coordinates.

Stage A35 freezes that setting on fresh flat and curved samples. All pivot
metrics remain Lorentzian, every selected shape-jet median is below `0.54`, and
every selected full-jet median is below `0.70`. The shape component improves at
doubled density, while the full `H=0.2` result does not because the count-scale
gradient worsens. G2 therefore has a conditional tensor field and first jet,
not a uniform continuum limit.

Stage A36 derives the corresponding Levi-Civita connection. Torsion freedom and
metric compatibility hold algebraically, and all median connection errors are
subunit. The high-curvature cell nevertheless worsens under refinement. G2 has
therefore reached a conditional finite connection control, but connection
convergence, second derivatives, and all three curvature comparisons remain
closed.

Stage A37 selects the count-scale window and penalty only on affine, temporal-
quadratic, and shear-quadratic flat charts. The two nonlinear charts have exact
nonzero Christoffel symbols but zero physical curvature, so returning a zero
connection is not admissible. With the setting frozen, all preregistered fresh
two-density gates pass: the worst median and ensemble errors improve, the A36
`H=0.2` regression disappears, and every high-density cell is subunit. G2 now
has a conditional metric, first jet, and connection that clear a finite
two-density audit.

This does not close G2 as a bare-order or asymptotic theorem. The count windows
and chart coordinates remain supplied, and the shear response amplitude is
small. A37 opens exact second-jet controls, but the one-operator audit makes
them secondary diagnostics rather than the primary curvature route.

Stage A38 formalizes that revised route. Exact finite theorems identify the
corrected pairing with half the double multiplication commutator on one and
show that multiplication potentials leave the normalized operator,
double/triple commutators, weak Hessian, and normalized `Gamma2` unchanged. A
flat finite-difference control returns nonzero Hessians but vanishing weak
Ricci in both nonlinear charts. This passes a supplied-operator control, not a
causal-set gate.

Stage A39 performs that basis-independent mesoscopic-algebra test with the
degree-two envelope `span {1,V,Sym^2 V}`. The exact algebraic controls pass:
the rank is 15, generator products close to roundoff, and the projector is
general-linear invariant. The geometric controls do not. Even the supplied
oracle generator sector has order-one operator, `Gamma`, and strong triple-
commutator defects, and its region-mean pairing is not stably Lorentzian.
Johnston generators do not consistently beat random controls. This kills the
tested global region and strong `L2` topology, not the degree-two envelope as
basis-independent bookkeeping.

Stage A40 then projects every `Box`, `Gamma`, Hessian, and `Gamma2`
intermediate back into that envelope. The nonlinear flat-chart Hessians remain
nonzero, so the test is not vacuous, but the flat Ricci residual stays near
one and barely improves with density. The same projected implementation gives
roundoff-zero flat Ricci for an ordinary centered finite-difference
d'Alembertian. The causal failure therefore points to the retarded kernel's
continuum normalization, boundary/nonlocal contamination, or the use of a
global algebra rather than an implementation error.

The next G2 fork is consequently analytic and local. First derive the
retarded kernel's continuum moments on constants through representative
cubics, including temporal/spatial response and boundary terms, and determine
whether a coordinate-free operator correction can recover the required
second-order symbol. In parallel, specify a genuinely local Alexandrov algebra
germ with an outer patch, protected inner core, and exact retarded-support
condition. The next numerical stage must be selected by that audit and must
again pass both nonlinear flat Ricci cancellations before any curved-Ricci
comparison. Pointwise second jets remain a secondary cross-check.

Stages A41c-A42 resolve the first part of that fork. The exact Poisson-mean
kernel has the correct asymptotic scalar normalization on both frozen local
germs without the A29 rank-one correction. The first discrete schedule does
not concentrate around its finite-scale moments: at `N=20000`, `ell/L` remains
`0.51-0.63`, all four field/metric strata fail, and signature is unstable in
three strata. G2 is therefore open at a two-scale concentration gate, not an
unknown temporal/spatial normalization. The immediate successor must derive
or bound variance as a function of density, `ell/L`, taper, and averaging,
then freeze a feasible schedule before returning to local-algebra selection.

The exact second-moment audit and A43 development sharpen this further. The
conditional pointwise amplitude scale is `ell^2/L^4`; the formerly used
boundary schedule `L^2` proportional to `ell*R` leaves it constant. Raising
`L/R` at fixed density reduces noise but makes three of four A41e finite
targets non-Lorentzian, so that shortcut is killed before held-out testing.
G2 now requires either a genuinely stronger density hierarchy at a
Lorentzian-mean scale or a same-graph regional average whose overlap covariance
is explicit. A pointwise or averaged choice must be made before weak
commutator locality and `Gamma2` are scored again.

The locality audit adds a second, explicitly competing architecture. An
intrinsic local operator built from chain-selected temporal differences and
distance-neighborhood spatial averages directly targets the variance and
first-moment leakage exposed here. It does not inherit the established
four-dimensional curved `Box-R/2` mean, however, and its available numerical
control is only `2+1`. G2 therefore requires a pre-registered same-control
comparison: compact nonlocal regional averaging with full overlap covariance
versus a project-sign clean-room local challenger with intrinsic-distance
error included. Neither branch licenses curvature until the flat corrected
pairing has stable rank, signature, product response, and count-volume scale.

A44 Phase A now fixes both comparison interfaces without opening random data.
For the local branch, the ideal hyperboloid moment stencil has exact `(+---)`
quadratic response in `3+1` and an asymmetric negative control exposes affine
leakage. For the nonlocal branch, a tied top-depth pivot set is order-only and
relabeling covariant, while an exact finite identity and its implementation
retain every off-diagonal same-graph product. The pending random comparison
therefore has no permission to hide local first-moment error or nonlocal
overlap covariance. It still must derive or freeze feasible intrinsic distance
estimators, density schedules, and finite targets before development data.

The completed concentration audit adds exact finite algebra but no missing
geometric variance bound. Finite-binomial corrections cannot rescue A42, and
the first nominal low-noise density would make a naive dense relation matrix
about `20 GB`. The proposed large run is therefore closed until reusable
interval counting is prototyped and A44's order-only tied-depth selector is
used. This preserves the distinction between a conditional Chebyshev theorem
and an actual concentration theorem for overlapping causal germs.

The finite automorphism theorem sharpens the design constraint: the successor
cannot be another ordered list whose members are each fixed by every
automorphism. It must make the subspace projector natural while allowing an
internal `GL(4)` or orthogonal basis action, exactly as a reconstructed coframe
is gauge-relative rather than canonical.

Relate the resulting metric volume to the soldering Gram volume without
introducing a second independent scale field.

The finite boundary is now exact. Bare-relation invariance alone leaves a
positive global rescaling ray, and a nonzero event count determines absolute
volume only after a positive density calibration is supplied. Given that
calibration and a nondegenerate four-dimensional conformal coframe
representative, the unique positive Weyl factor is the fourth root of the
target/base volume ratio.

There is nevertheless a useful relative result before the density is known.
For two positive regional counts \(n,n_0\), supplied conformal representatives
\(e,e_0\), and one common unknown density, define

\[
  r^4=\frac{n\operatorname{Vol}(e_0)}
             {n_0\operatorname{Vol}(e)}.
\]

The common density cancels exactly:

\[
  \omega(\rho,n,e)=r\,\omega(\rho,n_0,e_0)
  \qquad (\rho>0).
\]

Thus one positive anchor scale fixes the remaining profile, and the resulting
coframe-volume ratio is exactly \(n/n_0\). The positive factor is unique. Its
isotropic area weight is \(r^2\), whose square is the displayed volume ratio.
This is narrower than deriving arbitrary geometric areas from volume.

The graph-covariance boundary is also explicit. If regional counts and
representative volumes are invariant under relation automorphisms, the
anchored relative profile is invariant; on a vertex-transitive relation it is
constant. A nonconstant Weyl profile therefore requires relational
inhomogeneity or additional symmetry-breaking data. These identities close the
relative algebraic scale equation but derive none of its geometric inputs and
do not supply the remaining global unit.

Two different covariance statements are now separated. Holding the anchor
fixed gives an invariant scalar field under automorphisms acting on the
evaluation vertex. Transporting both anchor and evaluation vertex gives a
second exact covariance identity. On positive overlaps the transition factors
also satisfy

\[
  r_{x0}=r_{x1}r_{10},\qquad r_{01}r_{10}=1,
\]

and their area weights satisfy the squared cocycle. Thus changing anchors does
not introduce a path-dependent relative unit at this algebraic level. The
theorem still assumes the overlapping regions, positive counts, and conformal
representatives rather than deriving an atlas or refinement cover from the
graph.

**Success:** one full local metric is reconstructed, its volume agrees with
counting, and coframe factorization introduces no second scale.  
**Kill:** unstable rank or signature, failure of the product/chain tests,
incompatible count and metric volumes, or an unfixed Weyl mode.

### G3. Nondegenerate coframe and spin structure

Construct a measurable or gauge-relative coframe field and the associated spin
bundle data.

The local boundary is also explicit. A nonidentity rational Lorentz frame
change produces a distinct nondegenerate coframe with the same induced metric,
so metric reconstruction can determine only a Lorentz-gauge class. The
Hermitian part is now stronger than the initial generic conjugation witness.
Using the trusted `(+---)` Pauli lift, determinant-one `A` and `-A` produce the
same congruence action `X -> A X A^dagger`, preserve the Minkowski determinant,
and act oppositely on every spinor with nonzero image. This establishes the
local central-sign algebra.

That algebra is now bundled directly in Mathlib's `SL(2,C)`. The element
\(-I\) is machine-proved nonidentity, central, and order two, giving concrete
`CentralSignData`. Both \(I\) and \(-I\) act trivially on every complex
\(2\times2\) matrix by \(X\mapsto AXA^\dagger\), and literal edge re-signing
preserves each supplied Hermitian congruence action. This proves the central
sign lies in the kernel of the standard Hermitian action. It does not yet prove
that this kernel contains only \(\{I,-I\}\) or construct the Lorentz cover.

The first graph-global sign layer is now exact as well. Vertex signs remove
every edge-sign assignment on a three-edge path. On an oriented square
boundary, the sum of the four `ZMod 2` lift signs is invariant, and two
assignments are vertex-gauge equivalent exactly when those cycle parities
agree. Hence the boundary has two inequivalent central-sign sectors. They are
invisible to the Hermitian Lorentz action but distinguished by a spinor with
nonzero image. If the square is instead treated as one filled face with a
supplied central defect from chosen base lifts, every defect has a correction
and all corrections of that defect form one gauge class. Thus this is not a
claim of two spin structures on a disk.

The first simultaneous-face obstruction is also explicit. Glue two square
disks along the same boundary, so one edge-sign correction must satisfy both
face defects. Such a correction exists exactly when the two `ZMod 2` defects
agree, equivalently when their sum on the closed two-face cycle vanishes. The
assignment `(0,1)` has obstruction bit one and admits no correction. This is
the expected shape of a degree-two obstruction evaluation on the minimal
two-cell sphere, but the checked theorem does not identify that bit with
\(w_2\) or generalize it to an arbitrary cell complex.

The obstruction calculation now generalizes to every supplied finite face-edge
incidence matrix over `ZMod 2`. Edge-sign corrections map to face defects by
matrix-vector multiplication. A formal face sum is closed when its boundary
row vanishes. Associativity proves that every closed face cycle pairs to zero
with every correctable defect. Finite-dimensional duality proves the converse:
if all closed-cycle pairings vanish, the defect lies in the range of the
edge-to-face coboundary map. Thus correction exists exactly when every pairing
vanishes, equivalently exactly when no nonzero closed-cycle certificate exists;
the glued-square mismatch is a nonzero obstructed instance.

The first transport-to-cochain bridge is now checked. Supplied ordered face
walks determine their mod-two face-edge incidence matrix, while chosen
group-valued edge lifts determine ordered face holonomies. Assume a supplied
nontrivial central involution \(c\) and that every base face product lies in
\(\{1,c\}\). Identity versus nonidentity then extracts a unique defect bit.
Multiplying each edge lift by a central sign factors those signs through the
ordered product, and their sum along the face is exactly the derived incidence
coboundary. Hence one edge re-signing makes every face product equal to the
identity exactly when the derived defect is correctable, equivalently exactly
when no closed face cycle has nonzero pairing with it. An explicit four-edge
square has base product \(c\), derived defect one, and a displayed correction
with trivial corrected product, so the bridge is nonvacuous.

The choice law is literal, not only an existence consequence. If
\(\widetilde U\) is the chosen forward edge-lift field and \(s\) is an edge
sign cochain, reverse traversal remains the inverse of the re-signed forward
lift and

\[
  d\!\left(\operatorname{reSign}(\widetilde U,s)\right)
    = \delta s + d(\widetilde U)
\]

as an equality of face cochains. This is the finite choice-equivariance needed
for a choice-independent obstruction class.

That quotient class is now defined exactly:

\[
  [d(\widetilde U)]\in C^2/\operatorname{im}\delta.
\]

Adding a coboundary leaves the class unchanged, so every pointwise central
edge re-signing gives the same class. The class vanishes exactly when one edge
sign cochain trivializes every supplied face holonomy. The explicit square has
a nonzero defect representative but zero quotient class, because its displayed
edge correction flattens the face. This is the correct distinction between a
lift-dependent cocycle representative and its obstruction class; it is still
finite cochain algebra, not an identification with \(w_2\).

The program still owes surjectivity onto the proper orthochronous Lorentz
group, derivation of face attachments and local `SL(2,C)` lifts from bare graph,
coframe, and Lorentz data, proof that Lorentz-flat face products land in the
central kernel, proof that the concrete Hermitian-action kernel is exactly
\(\{I,-I\}\), invariance under general cover changes and refinement,
identification of the resulting obstruction with the second Stiefel--Whitney
class on a convergent good-cover nerve, derivation of gauge-relative coframes
from graph data, and continuum spin-bundle convergence.

**Success:** nondegeneracy, local Lorentz covariance, and patch compatibility.  
**Kill:** unavoidable frame singularities or non-equivariant preferred
directions.

### G4. Connection and curvature convergence

Derive weak Levi-Civita geometry from the same operator metric before fitting
spin transport. On a basis-independent mesoscopic algebra, first control the
double and triple multiplication commutators and define the weak Hessian and
polarized `Gamma2` expressions of Section 3.45. The Bochner remainder must
converge to the Ricci pairing and its contraction must agree with the scalar
causal-operator readout.

As a secondary pointwise diagnostic, in a chosen probe-coordinate gauge
\(X^\mu\), define

\[
  \partial_\mu^C F
    =g^C_{\mu\nu}\Gamma_C(X^\nu,F)
\]

and use it in the usual Christoffel formula. In the exact continuum
principal-symbol limit this recovers \(\partial_\mu F\), and the resulting
connection is torsion-free by construction. At finite density the chain-rule
defect, metricity defect, conditioning of the inverse Gram matrix, and
dependence on the mesoscopic probe space must all be controlled. A coframe may
then be chosen as a Lorentz-gauge factorization of the reconstructed metric,
and the spin connection fitted from the tetrad postulate with its discarded
symmetric part recorded as a nonmetricity defect.

Show independently that edge transports approximate that metric-compatible
connection and that area-normalized diamond holonomies converge to its
curvature.

A checked sufficient-condition interface is now available. A shrinking-loop
first-order expansion with an eventually nonzero area and vanishing normalized
residual implies convergence of area-normalized holonomy displacement to its
curvature coefficient. More operationally, a raw remainder bounded by
`area * epsilon` with positive area and `epsilon -> 0` gives an explicit
normalized error bound and the same convergence.

That interface now has one constructed, nonzero test family. On the decorated
`ZMod 2 x ZMod 2` torus, constant near-identity matrix links make the difference
of the two ordered plaquette paths exactly `h^2[A,B]`. For explicit upper and
lower nilpotent generators, the links are units with exact reverse links, and
transport around a genuine four-edge closed square has an exact
identity-plus-area expansion. Its normalized residual is componentwise
`(0,-h;h,h^2)` and tends to zero, so the area-normalized displacement from the
identity converges to the orientation-selected nonzero commutator. This is a
finite consistency witness for the holonomy-curvature mechanism, not a
reconstruction theorem for arbitrary graph transports.

There is now also a generator-level analytic bridge beyond that one nilpotent
square. The exact trigonometric group commutator has identity value, zero full
first Frechet derivative, and mixed derivative `G*A-A*G` at the origin. The
difference-quotient theorem first upgrades that jet statement to an iterated
limit. At each fixed `q`, the normalized `p`-displacement converges to the
`p`-edge jet; dividing that jet by `q` and then taking `q -> 0` converges to the
Lie coefficient.

A separate exact noncommutative expansion now proves the synchronized diagonal
limit rather than inferring it from the iterated result. Before involution
cancellation, the quadratic coefficient is

\[
  GA-AG+(A^2-I)+(G^2-I).
\]

Thus both \(A^2=I\) and \(G^2=I\) remove the pure terms, after which

\[
  \frac{H(h,h)-I}{h^2}\longrightarrow GA-AG.
\]

The coefficient is exactly one: the doubled mixed Hessian contribution is
balanced by the quadratic Taylor factor \(1/2\). Hermiticity is not required
for this analytic limit, but Hermitian involutions make every finite regulator
unitary. The live `alpha_1,beta` Clifford pair supplies a nonzero unitary witness
for both the iterated and diagonal statements.

The unrestricted two-variable limit is now checked independently of those
one-parameter statements. Under both involutions the exact displacement has
the factorization

\[
  H(p,q)-I=\sin p\,\sin q\,B(p,q),
\]

where, writing \(C=GA-AG\),

\[
\begin{aligned}
  B(p,q)={}&\cos p\cos q\,C
  +i\cos q\sin p\,(G-AGA)\\
  &+i\cos p\sin q\,(GAG-A)
  +\sin p\sin q\,(AGAG-I).
\end{aligned}
\]

Thus the product-area quotient is the continuous expression
`sinc(p)*sinc(q)*B(p,q)` away from the axes and tends jointly to \(C\) at the
origin. No ratio between \(p\) and \(q\) is assumed. The theorem also samples
along every nonzero-product refinement sequence tending jointly to zero. This
settles rate dependence for this selected regulator family; it does not derive
that family or its product area from graph geometry.

The G2 relative reconstruction now connects to this normalization without an
extra convention. Multiplying every supplied plaquette area by a constant
\(c\) multiplies the normalized curvature coefficient by \(c^{-1}\). Therefore
the relative Weyl factor \(r\) gives area weight \(r^2\) and curvature weight
\(r^{-2}\). In the exact nonzero control, a count ratio \(16:1\) on identity
representatives gives \(r=2\), area factor \(4\), and changes a base curvature
limit \(3\) to \(3/4\). This fixes the relative dimensional bookkeeping; it
still does not derive the base areas, holonomies, or refinement family.

Separately, componentwise convergence carries both curvature-pair
antisymmetries and the differential Bianchi identity to the limit; the
explicit finite contraction theorem then yields zero divergence of the
limiting Einstein combination.

The selected architecture imposes a triangular curvature test rather than
allowing three unrelated curvature labels:

\[
  \boxed{R_C^B\simeq R_C^{\mathrm{conn}}
    \simeq R_C^{\mathrm{hol}}.}
\]

Here \(R_C^B=-2\widehat B_C1\), \(R_C^{\mathrm{conn}}\) is contracted from the
operator-derived Levi-Civita estimator, and \(R_C^{\mathrm{hol}}\) is fitted
from many small transported loops. The present formalization checks pieces of
the holonomy and Bianchi legs only; it has not constructed or compared all
three estimators on one refinement family.

**Success:** the correct curvature symmetries and Bianchi identity emerge.  
**Kill:** path-dependent continuum transport, wrong tensor symmetries, or
surviving nonmetricity.

G4 still owes the substantive geometric work: derive transports, areas, and
refinement maps from the graph rather than choosing them; prove that the
selected trigonometric or a more general connection regulator is actually
realized by those graph transports; identify the matrix coefficient with
continuum curvature components; derive the Levi-Civita estimator from a
convergent finite probe calculus; construct curvature derivatives; prove the
three-way curvature consistency; and prove componentwise or stronger
convergence. The
constructed torus and unitary regulator families prove that the normalization,
orientation, and Lie coefficient can work nontrivially. They do not manufacture
the missing geometric inputs.

### G5. Dirac-square continuum theorem

Construct the operator from an overcomplete near-null shell rather than a
finite preferred set of nearest directions. Inside a mesoscopic diamond, use
all causal pairs, or a covariant statistical sample, whose interval counts and
reconstructed metric norms place them near the local light cone. The diamond
cutoff is essential because causal-set links can be arbitrarily distant while
remaining near-null.

For reconstructed displacements \(\xi_{xy}^J\), fit derivative weights by the
moment conditions

\[
  \sum_y a_{I,xy}=0,
  \qquad
  \sum_y a_{I,xy}\xi_{xy}^J=\delta_I{}^J.
\]

These conditions annihilate constants and make the derivative exact on affine
probe fields. With the G4 spin transport, the target operator is

\[
  D_C\psi(x)=i\gamma^I\sum_y a_{I,xy}
    \left[U_{x\leftarrow y}\psi(y)-\psi(x)\right].
\]

The moment constraints are a proposed numerical/formal interface, not yet a
graph-derived construction. One must prove existence, conditioning, covariance,
locality at scale \(L\), and convergence of the fitted coefficients.

Prove convergence of this dual-soldered finite Dirac operator and its square.

**Success:** a continuum Dirac operator and Lichnerowicz-Weitzenbock formula
with the intended curvature term.  
**Kill:** wrong principal symbol, extra low-energy zeroes, branch
contamination, uncontrolled nonlocal tails, or a curvature coefficient
mismatch.

### G6. Source and conservation

Define the matter action on the same reconstructed geometry and vary it with
respect to the coframe.

**Success:** a local symmetric or convention-appropriate stress tensor with
covariant conservation.  
**Kill:** channel-dependent gravitational coupling or failure of the discrete
Noether/Bianchi identity.

The current finite conservation theorem checks only the final algebraic
cancellation in this rung once a field equation, Bianchi premise, and parallel
left-invertible coupling have already been supplied. It does not discharge the
stress-tensor construction or geometric Bianchi obligations.

There is now also an explicit scalar-budget no-go. Distinct symmetric
four-tensors can have the same `00` energy density, and distinct symmetric
four-tensors can have the same ordinary matrix trace. Therefore the existing
scalar channel sums and expectation budgets cannot by themselves be identified
with \(T_{\mu\nu}\). A successful G6 construction must distinguish variation of
\(g_{\mu\nu}\), variation of \(g^{\mu\nu}\), and variation of a coframe, because
they carry different index, sign, and symmetry interfaces. It must recover the
appropriate pressure, flux, measure normalization, locality, covariance, and
conservation properties. A coframe derivative first produces a mixed current;
local Lorentz invariance or a spin-current improvement is needed to recover a
symmetric metric stress tensor.

The complementary uniqueness theorem is now checked: two symmetric component
matrices with the same finite Frobenius response against every symmetric matrix
variation are equal. The diagonal probes carry a harmless factor of two over
\(\mathbb R\). This proves coefficient uniqueness if an actual first variation
has already been represented by that pairing. The theorem contains no spacetime
integral, volume density, localization, or covariance theorem. The open problem
is to construct the localized measure-normalized derivative from the null-edge
matter action and derive its on-shell Noether conservation law.

One restricted construction now goes beyond uniqueness. On a single
homogeneous diagonal `(+---)` cell, the scalar matter action includes both the
oriented determinant `N a_1 a_2 a_3` and inverse metric component
`g^{00}=N^{-2}`.
Its reduced form is

\[
  S_m=a_1a_2a_3\left(\frac{\dot\phi^2}{2N}-NV\right).
\]

Varying the lapse gives `-a_1a_2a_3 rho`, while varying `a_i` gives `N` times
the oriented opposite-face factor times `p`, with

\[
  \rho=\frac{\dot\phi^2}{2N^2}+V,
  \qquad
  p=\frac{\dot\phi^2}{2N^2}-V.
\]

All four derivatives come from the same checked action. The usual
`sqrt(-g)` reading additionally requires the positive-orientation sector
`N a_1a_2a_3>0`, and a nondegenerate Lorentzian metric requires every diagonal
coframe scale to be nonzero. The assembled matrix `diag(rho,p,p,p)` records
covariant orthonormal components; the normalized coframe responses instead
couple to the mixed components `diag(rho,-p,-p,-p)`. Zero displayed flux is a
fact about the assembled definition, not a result of an off-diagonal
variation. This is a genuine measure-aware diagonal response, but only in the
homogeneous sector. It does not yet supply spatial gradients, off-diagonal
responses, graph localization, the scalar equation of motion, a Lorentz or
diffeomorphism Noether identity, or covariant conservation. Thus G6 has a
constructed perfect-fluid slice, not a general null-edge stress tensor.

The first controlled departure from homogeneity is also checked. Adding one
coordinate gradient \(w=\partial_1\phi\) changes the diagonal action by

\[
  -Na_1a_2a_3\frac{w^2}{2a_1^2}.
\]

The same four diagonal variations then yield

\[
  \rho=K_t+K_x+V,
  \qquad p_1=K_t+K_x-V,
  \qquad p_2=p_3=K_t-K_x-V,
\]

where \(K_t=\dot\phi^2/(2N^2)\) and \(K_x=w^2/(2a_1^2)\). The exact positive-chart
witness \((\dot\phi,w,V,N,a_i)=(2,2,1,1,1)\) gives
\((\rho,p_1,p_2,p_3)=(5,3,-1,-1)\), so the result genuinely distinguishes
longitudinal and transverse stress.

One time-space response is now checked as well. Supply the ADM-like coframe

\[
  \theta^0=Ndt,
  \qquad
  \theta^1=a_1(dx^1+\beta dt),
\]

with the other two spatial legs diagonal. Holding the coordinate derivatives
\(\dot\phi\) and \(w=\partial_1\phi\) fixed, the unit-normal derivative is
\((\dot\phi-\beta w)/N\). Differentiation of the same oriented scalar action
with respect to \(\beta\) gives

\[
  \frac{\partial S_m}{\partial\beta}
  =-a_1a_2a_3\frac{w(\dot\phi-\beta w)}{N}.
\]

The sign-defined canonical shift momentum is the negative of this response. For
nonzero \(N\) and \(a_1\), its exact coframe conversion yields the covariant
orthonormal flux

\[
  T_{\hat0\hat1}
  =\frac{\dot\phi-\beta w}{N}\frac{w}{a_1},
  \qquad
  P_\beta=a_1^2a_2a_3T_{\hat0\hat1}.
\]

The unit fixture has nonzero flux and derivative, so this does not collapse to
the diagonal sector. The result still packages only one shifted one-gradient
cell. It does not establish arbitrary coframe response, graph localization,
the scalar Euler--Lagrange equation, a local Lorentz or diffeomorphism Noether
identity, symmetry of a fully derived coframe current, or conservation.

### G7. Einstein dynamics

Prove that the selected interval-count action and matter path sum admit a
manifoldlike coarse effective action. The infrared target is not exact Einstein
gravity at finite spacing, but

\[
  \Gamma_{\mathrm{eff}}[g,\Psi]
    =\int\sqrt{|g|}\left[
      \frac{R-2\Lambda_R}{16\pi G_R}
      +a_RR^2+b_RR_{\mu\nu}R^{\mu\nu}+\cdots
    \right]d^4x
    +\Gamma_{\mathrm m}[g,\Psi].
\]

Its stationary equation is Einstein's equation plus controlled ultraviolet,
stochastic, boundary, and nonlocal corrections. The thermodynamic and
teleparallel routes must reproduce or consistently reformulate this same
infrared equation; they are no longer alternative unspecified choices.

**Success:**

\[
  G_{\mu\nu}+\Lambda g_{\mu\nu}=8\pi G T_{\mu\nu}
\]

with convention-locked constants and controlled corrections.  
**Kill:** a different tensor equation, nonlocal unsuppressed terms, or no
universal coupling.

Newton's constant is the renormalized coefficient of the Einstein-Hilbert
term. The kinematics need not predict its numerical value, but the theory must
show that the coefficient is finite and nonzero and fix it through a physical
renormalization condition such as the weak-field potential. Likewise,
\(\Lambda_R\) is the renormalized volume coefficient, not automatically a count
fluctuation.

The constant normalization now has one exact control: under the standard
weak-field identifications \(G_{00}=2\nabla^2\Phi/c^2\) and
\(T_{00}=\rho c^2\), the coupling \(8\pi G/c^4\) is equivalent to
\(\nabla^2\Phi=4\pi G\rho\). This checks the coefficient but assumes the two
identifications; deriving them remains part of G7-G8.

A second, stronger but still conditional control now exists in the homogeneous
sector. Assume the continuum metric has already been reduced to spatially flat
FLRW form,

\[
  ds^2=N(t)^2dt^2-a(t)^2d\mathbf{x}^2,
\]

and import the boundary-reduced Einstein-Hilbert action with convention
\((R-2\Lambda)/(16\pi G)\). The curvature sign is fixed by

\[
  R=6\left(\frac{\ddot a}{aN^2}
    +\frac{\dot a^2}{a^2N^2}
    -\frac{\dot a\dot N}{aN^3}\right),
\]

and the endpoint/GHY convention cancels
\(d[3a^2\dot a/(8\pi G N)]/dt\). Per unit coordinate volume the
remaining gravitational part is

\[
  S_g=-\frac{3a\dot a^2}{8\pi G N}
      -\frac{\Lambda Na^3}{8\pi G}.
\]

Adding the checked homogeneous scalar action and varying \(N\) gives a residual
whose vanishing is machine-proved equivalent, for nonzero \(G,N,a\), to

\[
  H^2=\frac{8\pi G}{3}\rho+\frac{\Lambda}{3},
  \qquad H=\frac{\dot a}{aN}.
\]

The independent scale-factor Euler--Lagrange calculation is now checked too.
With convention
\(\partial L/\partial a-d(\partial L/\partial\dot a)/dt=0\), the scale partial
and momentum are

\[
  \frac{\partial L}{\partial a}
  =-\frac{3\dot a^2}{8\pi G N}
   -\frac{3\Lambda Na^2}{8\pi G}+3Na^2p,
  \qquad
  \frac{\partial L}{\partial\dot a}
  =-\frac{6a\dot a}{8\pi G N}.
\]

For a history satisfying \(da/dt=\dot a\), the vanishing residual is equivalent
to

\[
  2\frac{1}{N}\frac{dH}{dt}+3H^2=\Lambda-8\pi Gp.
\]

Combining this scale equation with the independent lapse equation yields

\[
  \frac{\ddot a}{aN^2}-\frac{\dot a\dot N}{aN^3}
  =\frac{\Lambda}{3}-\frac{8\pi G}{6}(\rho+3p).
\]

An exact nondegenerate fixture with (G=3/(8\pi)), \(\Lambda=0\),
\(\dot\phi=0\), \(V=1\), and \(N=a=\dot a=\ddot a=1\), \(\dot N=0\),
satisfies the lapse, spatial, Euler--Lagrange, and acceleration equations. These
results validate the pressure coupling and constants in one cosmological
reduction. They do not derive the reduced action or FLRW variables from the
graph, and they are not the full Einstein equation. Inhomogeneous variations,
the scalar equation, Bianchi/Noether consistency, and graph dynamics remain
open. Exact zero-coupling, zero-lapse, and zero-scale countercontrols show that
all three nondegeneracy hypotheses in the residual/spatial-equation equivalence
are load-bearing under Lean's totalized division.

### G8. Physical controls

Recover benchmark sectors.

- Minkowski and weak-field Newtonian limits;
- gravitational redshift and geodesic motion;
- propagating transverse tensor modes in four dimensions;
- Schwarzschild-like and FLRW-like solutions or controlled analogues;
- causal horizon thermodynamics;
- regulator-independent observables.

Failure on these controls defeats the GR interpretation even if the finite
algebra remains interesting.

Three initial controls are formalized but conditional. The weak-field coefficient
reduces exactly to Poisson normalization, the standard dust/radiation laws
satisfy homogeneous scale-factor continuity, and lapse stationarity of an
imported flat-FLRW Einstein-Hilbert reduction plus the constructed scalar action
is exactly the first Friedmann equation, while its independent scale variation
gives the spatial and acceleration equations. None derives a Newtonian limit,
an FLRW metric or gravitational action, or an equation of state from the
null-edge framework. Redshift, geodesic motion, tensor waves, compact sources,
horizons, and regulator independence remain untouched.

## 12. Conditional continuum recovery theorem

The largest honest derivation currently available is conditional. It is useful
because it separates what follows mathematically from what the null-edge model
must still prove dynamically.

Assume a refinement family of decorated null-edge systems satisfies:

- **H0, manifoldlike order:** the causal orders converge to the causal relation
  of a past-and-future-distinguishing \(d\)-dimensional spacetime \(M\);
- **H1, count-normalized operator metric:** normalized event counts converge to
  a smooth positive measure, \(\widehat B_C\) converges jointly on a separating
  product-closed probe algebra to \(\Box_g+V\), and its corrected carre du champ
  has a stable rank-\(d\) Lorentzian image whose volume agrees with counting;
- **H2, gauge-relative soldering:** a chosen dual soldering converges to a
  nondegenerate coframe \(e^I{}_{\mu}\) factoring the H1 metric, and changes of
  choice converge to local Lorentz gauge transformations;
- **H3, connection:** the operator-derived finite derivative and Christoffel
  estimators converge to Levi-Civita, while fitted Lorentz/spin transports
  converge to its lift and their holonomy curvature agrees with the
  operator/connection curvature;
- **H4, operator:** the finite dual-soldered Dirac operator converges to the
  spin Dirac operator and its commutator-curvature block has the correct
  Lichnerowicz coefficient;
- **H5, dynamics:** the interval-count action and matter path sum have the
  stated local infrared effective action with finite nonzero \(G_R\), while
  higher-curvature, stochastic, and nonlocal corrections are controlled;
- **H6, matter:** the matter functional converges on the same geometry, its
  metric/coframe variation defines \(T_{\mu\nu}\), and the relevant Noether
  identity survives refinement;
- **H7, control:** boundary, nonlocal, stochastic, and higher-curvature
  corrections are controlled in the limit.

Then the following chain is **T|H [interp]**.

### 12.1 Metric reconstruction

H0 fixes a conformal class \([\bar g]\). H1 independently reconstructs the
inverse metric through the principal symbol,

\[
  \Gamma_C(f,h)\longrightarrow g^{-1}(df,dh),
\]

and fixes its positive conformal factor consistently with the count measure by

\[
  g=\left(
    \frac{d\mu}{d\operatorname{Vol}_{\bar g}}
    \right)^{2/d}\bar g.
\]

H2 is therefore a gauge-lift and consistency theorem, not permission to
introduce a second independent metric: it must satisfy

\[
  g_{\mu\nu}=\eta_{IJ}e^I{}_{\mu}e^J{}_{\nu}
\]

with the same \(g\) reconstructed from order and volume.

### 12.2 Levi-Civita geometry and transport

H3 derives the torsion-free metric-compatible connection from the H1 metric,
so uniqueness identifies it as Levi-Civita. The tetrad postulate then lifts
that connection to a chosen coframe gauge, while holonomy determines the same
Riemann curvature in the infinitesimal-loop limit.

As a secondary teleparallel reformulation, H3 must instead produce a flat
metric-compatible spin connection and a coframe torsion. H5 must prove the
convention-correct
TEGR torsion scalar and its boundary-term equivalence to the
Einstein-Hilbert action. The present finite torsion/nonmetricity split does not
yet establish those hypotheses.

### 12.3 Selected Einstein dynamics

The primary variational route assumes the limiting effective functional has
the form

\[
  S[g,\psi]
    =\frac{1}{16\pi G}\int_M
       (R-2\Lambda)\sqrt{|g|}\,d^dx
      +S_{\mathrm m}[g,\psi]+S_{\partial}
      +o(1),
\]

and that variation commutes with the limit. Stationarity with

\[
  T_{\mu\nu}
    =-\frac{2}{\sqrt{|g|}}
       \frac{\delta S_{\mathrm m}}{\delta g^{\mu\nu}}
\]

then gives

\[
  G_{\mu\nu}+\Lambda g_{\mu\nu}=8\pi G T_{\mu\nu}.
\]

The thermodynamic route may independently recover the same equation under the
all-local-null-horizon assumptions displayed in Section 6.2. The teleparallel
route may reformulate the same action through the TEGR torsion scalar plus its
required boundary term. Agreement would be a strong control; combining their
finite avatars does not reduce their separate continuum debts.

### 12.4 Conservation, motion, and clocks

Once the limiting gravitational action is diffeomorphism invariant, the
contracted Bianchi identity and the matter Noether identity give

\[
  \nabla_\mu T^{\mu\nu}=0.
\]

The finite theorem `source_conserved_of_fieldEquation_bianchi` is the exact
operator analogue of the last implication: conservation of the gravitational
side passes through a parallel left-invertible coupling to the source. It is a
consistency bridge for a future reconstruction theorem, not a replacement for
the diffeomorphism Noether identity or contracted Bianchi identity.

At the intervening component level, `divEinstein_eq_zero` now derives the
contracted identity from explicit Riemann antisymmetries and the uncontracted
differential Bianchi premise. The remaining continuum theorem must show that
the reconstructed null-edge curvature supplies exactly those inputs.

Universal coupling then supplies the standard equivalence-principle route to
geodesic motion for suitable test bodies, with the usual qualifications for
spin and finite size. Proper time is no longer an additional primitive:

\[
  \tau[\gamma]
    =\frac1c\int_\gamma
       \sqrt{g_{\mu\nu}\,dx^\mu dx^\nu}.
\]

The null-tick formula of Section 2 is the flat, coarse-grained kinematic
prototype of this reconstructed functional.

### 12.5 What this theorem does and does not say

The deduction from H0-H7 to general relativity is standard geometry and
effective-action variation. It does **not** prove that the current
null-edge ensemble satisfies H0-H7. The original research content must be in
deriving those hypotheses from the finite causal, soldering, transport, and
matter rules with quantitative error bounds. Merely renaming H5 as an
"emergence principle" would be hollow telescoping.

## 13. Interpretation of direction change and experienced time

The intuition that a system "does not experience time until it changes
direction" contains a useful null-aggregate insight but is not literally a
statement of general relativity.

The accurate version is:

1. a primitive null segment has zero proper time;
2. mixed null directions can produce a timelike net displacement with positive
   endpoint proper time;
3. mixed null momenta can produce a timelike total momentum with nonzero mass;
4. in a checkerboard or Dirac walk, the mass operator supplies or weights
   chirality-changing turns;
5. a massive inertial particle nevertheless accumulates proper time without
   macroscopic acceleration or repeated direction changes.

In curved spacetime, gravitational time dilation is encoded by the metric. A
stationary clock in one gravitational potential and a moving clock along
another worldline compare proper times by integrating \(d\tau\), not by simply
counting corners. A null-edge theory must derive that metric dependence before
claiming to explain gravitational clock rates.

The promising synthesis is therefore not "time is caused by corners." It is:

> Null propagation is primitive; timelike duration and invariant mass are
> aggregate Lorentzian norms; local direction mixing is dynamically controlled
> by the mass and connection sectors; curvature changes how those null
> directions, scales, and transports fit together from event to event.

## 14. Bottom line

The null-edge framework has a coherent route toward general relativity, but it
is currently a route, not a completed derivation.

Its strongest assets are:

- a natural causal primitive;
- an exact null-to-timelike aggregation mechanism;
- a potential-canceling operator formula that can reconstruct an inverse
  metric if the causal wave operator converges;
- an executable order/count operator calibration with a visible two-scale
  signature and variance window;
- a disciplined conformal, operator, and volume consistency split;
- finite coframe and local-frame covariance;
- a concrete `SL(2,C)` central sign and a choice-independent finite obstruction
  class;
- gauge-covariant holonomy;
- an exact Dirac-square channel decomposition;
- several finite, nonvacuous dynamics avatars;
- explicit no-go and kill conditions.

Its decisive debts are:

- a Lorentz-compatible continuum ensemble;
- intrinsic construction and uniform convergence of the count-normalized
  causal operator and its mesoscopic probe calculus, including support and
  scale selection;
- stable rank-four signature and count-volume consistency;
- a derived nondegenerate tetrad and spin structure;
- agreement of operator, Levi-Civita, and holonomy curvature;
- a conserved stress tensor;
- a manifoldlike infrared phase and Einstein effective action with physical
  constants;
- weak-field, wave, horizon, and cosmological controls.

The correct near-term claim is therefore:

\[
  \boxed{\text{finite null-edge Lorentzian and Dirac geometry with a graded GR reconstruction program}}
\]

not

\[
  \boxed{\text{general relativity already derived from a graph}}.
\]

## References and primary anchors

1. S. W. Hawking, A. R. King, and P. J. McCarthy, "A new topology for
   curved space-time which incorporates the causal, differential, and
   conformal structures," *J. Math. Phys.* **17** (1976) 174-181,
   [doi:10.1063/1.522874](https://doi.org/10.1063/1.522874).
2. D. B. Malament, "The class of continuous timelike curves determines the
   topology of spacetime," *J. Math. Phys.* **18** (1977) 1399-1404,
   [doi:10.1063/1.523436](https://doi.org/10.1063/1.523436).
3. L. Bombelli, J. Lee, D. Meyer, and R. D. Sorkin, "Space-time as a causal
   set," *Phys. Rev. Lett.* **59** (1987) 521-524,
   [doi:10.1103/PhysRevLett.59.521](https://doi.org/10.1103/PhysRevLett.59.521).
4. L. Bombelli, J. Henson, and R. D. Sorkin, "Discreteness without symmetry
   breaking: a theorem," [arXiv:gr-qc/0605006](https://arxiv.org/abs/gr-qc/0605006).
5. D. M. T. Benincasa and F. Dowker, "The scalar curvature of a causal set,"
   [arXiv:1001.2725](https://arxiv.org/abs/1001.2725).
6. A. Belenchia, D. M. T. Benincasa, and F. Dowker, "The continuum limit of a
   4-dimensional causal set scalar d'Alembertian,"
   [arXiv:1510.04656](https://arxiv.org/abs/1510.04656).
7. T. Jacobson, "Thermodynamics of spacetime: the Einstein equation of state,"
   [arXiv:gr-qc/9504004](https://arxiv.org/abs/gr-qc/9504004).
8. C. Eling, R. Guedens, and T. Jacobson, "Non-equilibrium thermodynamics of
   spacetime," [arXiv:gr-qc/0602001](https://arxiv.org/abs/gr-qc/0602001).
9. D. Ackermann and J. Tolksdorf, "The generalized Lichnerowicz formula and
   analysis of Dirac operators," [arXiv:hep-th/9503153](https://arxiv.org/abs/hep-th/9503153).
10. J. C. Baez and D. K. Wise, "Teleparallel gravity as a higher gauge theory,"
    [arXiv:1204.4339](https://arxiv.org/abs/1204.4339).
11. J. G. Pereira and T. Vargas, "Regge calculus in teleparallel gravity,"
    [arXiv:gr-qc/0208036](https://arxiv.org/abs/gr-qc/0208036).
12. S. Surya, "The causal set approach to quantum gravity,"
    [arXiv:1903.11544](https://arxiv.org/abs/1903.11544).
13. C.-M. Lin, "More solutions for the Wheeler-DeWitt equation in a flat FLRW
    minisuperspace," [arXiv:2309.02955](https://arxiv.org/abs/2309.02955).
14. S. Aslanbeigi, M. Saravani, and R. D. Sorkin, "Generalized causal set
    d'Alembertians," [arXiv:1403.1622](https://arxiv.org/abs/1403.1622).
15. M. Boguna and D. Krioukov, "Local d'Alembertian for causal sets,"
    [arXiv:2506.18745](https://arxiv.org/abs/2506.18745).
16. L. Machet and J. Wang, "On the continuum limit of Benincasa-Dowker-Glaser
    causal set action," [arXiv:2007.13192](https://arxiv.org/abs/2007.13192).
17. S. Major, D. Rideout, and S. Surya, "On recovering continuum topology from
    a causal set," [arXiv:gr-qc/0604124](https://arxiv.org/abs/gr-qc/0604124).
18. S. P. Loomis and S. Carlip, "Suppression of non-manifold-like sets in the
    causal set path integral,"
    [arXiv:1709.00064](https://arxiv.org/abs/1709.00064).
19. S. Johnston, "Embedding causal sets into Minkowski spacetime,"
    [arXiv:2111.09331](https://arxiv.org/abs/2111.09331).
20. S. Johnston, "Simpler embeddings of causal sets into Minkowski spacetime,"
    [arXiv:2502.09701](https://arxiv.org/abs/2502.09701).
21. C. A. Hu, D. A. Meyer, and E. J. Q. Meyer, "Reconstructing Minkowski
    geometry from causal separations,"
    [arXiv:2601.03280](https://arxiv.org/abs/2601.03280).
22. N. Madsen, "On the uniqueness of embeddings of causal sets,"
    [arXiv:2607.05840](https://arxiv.org/abs/2607.05840).

## Repository anchors

- `docs/NULLSTRAND.md`
- `docs/CONVENTIONS.md`
- `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`
- `Sources/Null_Edge_Program_Overview_Packet_2026-07-12.tex`
- `Sources/Null_Edge_Causal_Graph_Bibliography.md`
- `PhysicsSM/Draft/NullEdge/NondegenerateSolderingGeometry.lean`
- `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean`
- `PhysicsSM/Draft/NullEdge/RelativeGraphScaleReconstruction.lean`
- `PhysicsSM/Draft/NullEdge/RelativeScaleCurvatureBridge.lean`
- `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean`
- `PhysicsSM/Draft/NullEdge/HermitianSpinLiftBoundary.lean`
- `PhysicsSM/Draft/NullEdge/GraphSpinLiftCocycle.lean`
- `PhysicsSM/Draft/NullEdge/FiniteSpinCochainObstruction.lean`
- `PhysicsSM/Draft/NullEdge/SpinLiftDefectFromTransport.lean`
- `PhysicsSM/Draft/NullEdge/SL2CCentralSign.lean`
- `PhysicsSM/Draft/NullEdge/CausalOperatorMetric.lean`
- `PhysicsSM/Draft/NullEdge/CausalMetricFirstJet.lean`
- `PhysicsSM/Draft/NullEdge/CausalLeviCivita.lean`
- `PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean`
- `PhysicsSM/Draft/NullEdge/NullTickProperTime.lean`
- `PhysicsSM/Draft/NullEdge/SolderingLocalFrameCovariance.lean`
- `PhysicsSM/Draft/NullEdge/Carrier/SolderedSquareGram.lean`
- `PhysicsSM/Draft/NullEdge/Carrier/WeitzenbockMaster.lean`
- `PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean`
- `PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean`
- `PhysicsSM/Draft/NullEdge/FiniteConnectionGeometry.lean`
- `PhysicsSM/Draft/NullEdge/FiniteCartanBianchi.lean`
- `PhysicsSM/Draft/NullEdge/FiniteContractedBianchi.lean`
- `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean`
- `PhysicsSM/Draft/NullEdge/GraphPlaquetteCurvatureLimit.lean`
- `PhysicsSM/Draft/NullEdge/TrigonometricHolonomyCurvatureLimit.lean`
- `PhysicsSM/Draft/NullEdge/FiniteGravityConservation.lean`
- `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean`
- `PhysicsSM/Draft/NullEdge/HomogeneousScalarStressVariation.lean`
- `PhysicsSM/Draft/NullEdge/DiagonalScalarGradientStressVariation.lean`
- `PhysicsSM/Draft/NullEdge/ADMShiftScalarFluxVariation.lean`
- `PhysicsSM/Draft/NullEdge/FlatFLRWFriedmannControl.lean`
- `PhysicsSM/Draft/NullEdge/FlatFLRWAccelerationControl.lean`
- `PhysicsSM/Draft/NullEdge/FiniteDynamicsNoetherThermoCapstone.lean`
- `PhysicsSM/Draft/NullEdge/JacobsonClausius.lean`
- `PhysicsSM/Draft/NullEdge/GravitySourceMatter.lean`
- `PhysicsSM/Draft/NullEdge/EinsteinHilbertTerm.lean`
- `PhysicsSM/Draft/NullEdge/TeleparallelSoldering.lean`
- `PhysicsSM/Draft/NullEdge/GravityUnificationCapstone.lean`
- `AgentTasks/null-edge-finite-connection-gr-aristotle-2026-07-14.md`
- `AgentTasks/null-edge-finite-cartan-bianchi-aristotle-2026-07-14.md`
- `AgentTasks/null-edge-finite-gravity-conservation-aristotle-2026-07-14.md`
- `AgentTasks/null-edge-finite-contracted-bianchi-aristotle-2026-07-14.md`
- `AgentTasks/null-edge-relative-scale-curvature-aristotle-2026-07-15.md`
- `AgentTasks/null-edge-graph-spin-lift-cocycle-aristotle-2026-07-15.md`
- `AgentTasks/null-edge-finite-spin-cochain-obstruction-aristotle-2026-07-15.md`
- `AgentTasks/null-edge-spin-lift-defect-transport-aristotle-2026-07-15.md`
