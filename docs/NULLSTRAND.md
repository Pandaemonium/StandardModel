# NullStrand / null-edge agent orientation

This is a living orientation note for agents working on the NullStrand and
null-edge causal graph program. It records current program guardrails,
conventions, and task-shaping advice. AGENTS.md keeps the permanent quick rules;
this file can evolve as the program sharpens.

## Current program status

The near-term publishable target is a dual-soldered finite null-edge Dirac
algebra. It should be presented as a finite algebraic and formalization result,
not as a completed physical theory.

The NERD/NRQG synthesis treatises live in `Sources/NERD_1.md` through
`Sources/NERD_4.md` (v2.1, `NERD_4`, supersedes earlier versions where they
conflict), and the Gate D dynamics proposal lives in
`Sources/Null_Edge_Dynamics_Gate_D.md`. The consolidated post-v2.1 gate
ladder, claim discipline, track
assignments, and kill conditions live in
[`docs/NERD_ROADMAP.md`](NERD_ROADMAP.md). Consult the roadmap before opening
new NERD-related task files; in particular, the tetrahedral lattice is now a
gauge-fixed regulator (not the ontology) and the three-J / claim-scope
conventions in [`docs/CONVENTIONS.md`](CONVENTIONS.md) apply to all new
operator statements.

The strongest current finite-core package is:

1. Simplex null-solder frame.
2. Diagonal trace obstruction for diagonal null soldering.
3. Dual-soldered commutator theorem.
4. Correct graded super-Dirac square.
5. Finite tetrad-postulate and frame-term audit.
6. Krein retarded/advanced double.
7. Determinant-level branch-count protocol.
8. Spectral mass-shell matching theorem.
9. Pauli diamond normalization audit.
10. Claim-boundary ledger.

The full physics program still needs controlled continuum scaling, chirality and
anomaly control, a finite spectral-action or variational principle with genuine
codimension, and at least one non-inserted prediction if the goal is stronger
than reconstruction.

### GR order-side gate status (2026-07-16)

Do not launch the proposed intrinsic generalized-cluster eigensolver yet. The
Stage A3b max-clearance schedule `s = sqrt(ell * L)` repairs the earlier fixed
`s/L` scale-window artifact: `(s/r, s, r*s)` lies strictly between `ell` and
`L` exactly when `L/ell > r^2`. For the frozen benchmark this requires
`N > 743.239`, and common three-scale interiors occur in every evaluated
realization above that threshold.

Stage A3c resolves the boundary question. Holding `ell`, `L`, the ratio, and
all count bands fixed while multiplying the global four-volume by `1,2,4`
raises the all-scale rank-capable mark rate from `1.93%` to `17.19%` to
`36.97%`; an exploratory volume-eight point reaches `50.85%`. This is strong
infrared-boundary dependence, not local convergence. A fixed proper-time shell
has a noncompact rapidity direction, so the finite diamond is its infrared
cutoff.

Do not enlarge the global diamond until the old support threshold passes.
`RetardedShellInfraredNoGo.lean` also kernel-checks that arbitrary shell
cardinality is possible in one fixed minimal interval-count band with nonzero
two-sided abundance. Preserve the necessary theorem `finrank P <= shell.card`,
but reject global shell cardinality as a locality certificate. The successor
must use a compact order-derived Alexandrov carrier, or the full equivariant
ensemble of eligible brackets, and prove refinement/overlap stability before
spectral rank selection. See
`AgentTasks/null-edge-causal-larger-diamond-support-stage-a3c-benchmark-2026-07-16.md`.

Stage A3d tests the first compact replacement. The order-only excess
`C(p,q)/(C(p,x)^(1/4)+C(x,q)^(1/4))^4` stabilizes carrier cardinality to
`0.281%` between fixed-density volume multipliers two and four, but the same
bracket over-truncates the evaluation germ: induced common-interiority is
essentially zero, all clustered rank rates are zero, and overlap/metric gates
fail. Do not retune its caps. The next mechanism must separate an outer compact
regulator from a buffered inner evaluation region. See
`AgentTasks/null-edge-causal-compact-bracket-carrier-stage-a3d-benchmark-2026-07-16.md`.

Stage A3e then separates the outer regulator from the inner germ and freezes
two analytically admissible count-buffer ratios, `B=24` and `B=32`, before a
five-realization `N=9600` run. The finite nesting calculus itself is exact:
`AlexandrovNestedGerm.lean` proves carrier inclusion, induced-count and
zero-extended layered-operator compatibility, and additive transport of
protected-core depth across the endpoint buffer. The frozen selector is not
available in the random orders: only one of 40 sampled marks has any `B=32`
bracket, none has a nested `B=24` bracket, and Phase 2 is not reached. Kill the
fixed symmetric buffer bands and exact-minimum orbit selector. Do not rescue
them with a larger diamond, capable-mark selection, or retuning. A successor
must select an order-only outer atlas, then distinguish its probe-data region,
protected evaluation core, and row-source support. Row sources need not also
be evaluation centers. Preregister the analytic typical-event core coverage
before fixing the finite diamond or gate; the A3e two-sided depth target alone
has ideal flat protected fractions `7.545%` at `B=24` and `3.580%` at
`B=32`, before selector and finite-count losses. See
`AgentTasks/null-edge-causal-nested-regulator-germ-stage-a3e-benchmark-2026-07-16.md`.

Stages A3f-R1 and A3f-R2 test the resulting outer-first atlas. Uniform
`K=16` sampling is killed by correlated placement: 29 of 30 atlases have all
120 core pairs overlapping, and measured union coverage is about half the
independent-placement diagnostic. The order-equivariant greedy successor is
positively retained. `GreedyAtlasCoverage.lean` kernel-checks its average-
marginal and exact finite-factor guarantees, and the held-out selector captures
`95.6%` to `99.7%` of the complete-family union with connected overlaps. The
two-density stage still fails because the complete family misses its low-
density feasibility floor. At the only absolute-passing cell, even complete
union minus uniform is `0.0953`, so the frozen `0.10` improvement floor was
arithmetically unsatisfiable. Do not cite that floor as a selector failure.

Two exact corrections now govern successors. First,
`AtlasCoreBulkContainment.lean` proves every protected-core union lies in the
independent two-sided order bulk, so all-event union coverage factors into bulk
fraction times family saturation of bulk. Second, if core size is
`B_N=O(N^(3/4))`, fixed atlas size forces global coverage to zero; nonzero
continuum coverage needs at least `K_N=Omega(N^(1/4))`.

Stage A3f-R3 passes the fresh complete-family scaling gate. At
`N=(6000,12000)`, all six density/rung cells are valid, bulk saturation rises
strictly on every rung, and `sqrt(N) * (1-S_N)` drifts by only `1.2%` to
`2.7%` against the frozen `20%` ceiling. The narrow high-density complete
union covers `0.6499` of all events, above its `0.60` floor, and order-bulk
fractions track the flat `F_4` calibration within `0.011`. Treat this only as a
finite stochastic confirmation of the displayed scaling form.

Every citation must disclose provenance incident
`INC-2026-07-16-A3F-R3-DUPLICATE-RUN` until Director review: two blind
concurrent launches used the same hard-pinned seed and inputs, and the retained
second-writer artifact passed independent science and provenance review. Its
run-invariant deterministic-content hash is
`2bddbd2e26a24598a04252d68b776bd8685a8cfeaca1303e9eb45f27348b8085`.
No rerun is permitted, and every future frozen run must acquire an exclusive
sentinel and output reservation before computation.

R4 then tests the growing `K_N=ceil(2 N^(1/4))` atlas under eventwise caps
`5,8,12`. Every selector and paired control stops at the cap in a selected-
family full-intersection regime, so the frozen outcome is correctly
`INADMISSIBLE`. The gate-free R4-D audit shows the complete-family obstruction
is scale-dependent: beta `0.80` has a common event in all six families; beta
`1.00` mixes true apices and near-apex hubs; beta `1.25` has empty intersections
but still has hubs covering `87.4%` to `97.9%` of each family.

Fresh-seed R5 makes beta `1.25` the sole result rung and beta `1.00` a
decision-inert negative control. All 18 result cells remain inadmissible solely
because every random-feasible control shortfalls. The useful change is that the
greedy selector grows past the cap for the first time: at `N=12000`, cap `12`
reaches `17-19` of `21` required charts without a full selected intersection.
This turns the R4 wall into a margin, but does not construct an atlas. The
frozen R5 family/selector/cap/cardinality architecture and the claim that an
empty complete-family intersection suffices are now ruled out. Do not continue
beta tuning. A successor needs its own preregistration and must use the
fractional-dual certificate interface or a genuinely redesigned candidate
family/growth law. Keep source rows, operators, G2, and all downstream GR gates
closed.

The rank-four selector has a separate symmetry guardrail. The five-event
antichain's zero-sum scalar sector has rank four only because its dimension is
`5-1`. For every `n>=6`, a fully permutation-equivariant idempotent on the
natural scalar vertex-probe module cannot have rank four. A universal bare-
graph selector must therefore use restricted symmetry, derived equivariant
decorations, or a richer edge/cochain/spin probe representation; it cannot be
another pointwise canonical scalar frame. See
`BareGraphPermutationProjectorNoGo.lean` and
`EquivariantInvolutionProbeProjector.lean`. Polynomial filters do not evade
this guardrail: `EquivariantPolynomialProbeProjector.lean` proves exact
naturality and certificate transport once an operator, polynomial,
idempotence, and source rank four are supplied, but derives none of them.
Moreover, `RetardedPolynomialProjectorNoGo.lean` proves that a scalar-plus-
nilpotent operator has no nonzero proper idempotent polynomial filter at all.
`FiniteStrictPastNilpotence.lean` proves the required nilpotence for every
weighted strict-past operator on a nonempty finite transitive irreflexive
relation, and `LayeredOperatorPolynomialNoGo.lean` kernel-checks the exact
decomposition for both the production layered operator and the active smeared
project-sign operator. The resulting no-go excludes direct polynomial
selection from one-sided retarded transport; it does not exclude the corrected
symmetric pairing, normal or Hermitian retarded/advanced constructions,
constraint kernels, or richer probe representations.

Absolute scale has an independent identifiability guardrail. Automorphism
invariance alone leaves a positive rescaling ray admissible; it does not forbid
a conventional constant selector. The actual no-go requires a physical
realization map: if a nonunit positive rescaling is invisible to the bare
observation while a positive length has Weyl weight one, no estimator using
only that observation can be exact on all realizations. Count ratios can still
fix relative four-dimensional Weyl factors under a common-density hypothesis.
Dimensional transmutation can select a scale relative to a supplied reference,
but the generated scale inherits any global change of that reference unit.
See `BareGraphScaleReconstruction.lean`,
`RelativeGraphScaleReconstruction.lean`, and
`OneLoopDimensionalTransmutation.lean`.

### All-mass program: strategic guidance (2026-07-08)

The all-mass manuscript
(`Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`) and its strengthening
plan are the current headline all-mass work. Before opening new all-mass tasks,
read
[`AgentTasks/overnight-allmass-run-2026-07-08/STRENGTHENING_ROADMAP.md`](../AgentTasks/overnight-allmass-run-2026-07-08/STRENGTHENING_ROADMAP.md)
- it consolidates three independent strengthening reviews (Fable, Aristotle,
Gemini Pro) into a dependency-ordered roadmap (T1-T7 core theorems + F2-F11
frontier contact points). The durable strategic facts:

- **The decisive question is the `S3<->S4` bridge** (`min spec(D^#D|P) = det P`).
  It does not land-or-fail: it **splits** into a free-case equality (an M-target,
  near-automatic from `(slash)^2 = det P`) plus `Delta := min spec - det P`, a
  finite, negative, off-diagonal, closure-controlled **binding energy** (the
  program's first new invariant;
  `AgentTasks/overnight-allmass-run-2026-07-08/DELTA_BINDING_ENERGY_FINDING.md`).
- **The keystone `sector_ground_mass` is proved (M)**
  (`PhysicsSM/Draft/NullEdge/Carrier/SectorGroundMass.lean`), *conditional* on a
  definite positive sector. The single-doublet witness has none (the closure
  grading balances the aperture too), but a two-edge `Cl(4)` carrier escapes the
  obstruction and supplies one under aperture dominance (validated numerically;
  Lean transcription is the top construction).
- **The honest contribution is methodology-first** and survives every channel-name
  kill: verified constructive-QFT fragments (RP->OS->gap->clustering; a
  polymer/cluster-expansion Lean library), new finite theorems (mass monogamy,
  finite Witten positive-mass, rigidity-as-classification), sharpened finite
  diagnoses of continuum obstructions (Nielsen-Ninomiya, the 3+1D checkerboard,
  Kugo-Ojima positivity), and the grading discipline itself. Absolute masses stay
  behind the (unbuilt) renormalization dictionary - which is why the checkerboard
  bridge (the one place a proven continuum reduction exists) is worth
  disproportionate effort.

## Core operator convention

Do not identify the null finite-difference direction with the Clifford soldering
covector.

The active architecture is:

```text
D_+^h = sum_a c(alpha^a) (T_a - I) / h
```

where `ell_a` is the primitive null edge direction and `alpha^a` is the dual
covector in the null-solder frame. The support is null; the Clifford symbol is
dual-soldered.

Do not revive:

```text
sum_a c(ell_a^flat) nabla_ell_a
```

as the continuum Dirac-symbol operator. The diagonal trace obstruction is known:
`sum_a b_a ell_a^flat tensor ell_a` has trace zero because every `ell_a` is
null, while the identity on cotangent space has trace `d`.

## Simplex null-solder frame

In spacetime dimension `d = s + 1`, with mostly-minus signature, use spatial
simplex vertices `n_A` satisfying:

```text
n_A . n_A = 1
n_A . n_B = -1 / (d - 1), A != B
sum_A n_A = 0
ell_A = (1, n_A)
```

Then `ell_A` are future null, and the dual covectors are:

```text
alpha^A = (1 / d) dt + ((d - 1) / d) n_A . dx
```

with:

```text
alpha^A(ell_B) = delta^A_B
xi = sum_A xi(ell_A) alpha^A
```

For `d = 4`:

```text
alpha^A = 1/4 dt + 3/4 n_A . dx
```

If scaled null vectors are used, scale the dual covectors consistently. Do not
mix scaled vectors with unscaled duals.

This construction does not derive four dimensions. It works for all `d >= 2`
using a spatial `(d - 1)`-simplex.

## Super-Dirac square guardrails

Keep these gradings distinct:

```text
Gamma_s       spacetime chirality
chi_E         internal finite grading
epsilon_form  cochain/form degree, if present
```

For:

```text
D_N = sum_a C_a nabla_a
C_a = c(alpha^a)
D = i D_N + Gamma_s Phi
```

the safe sign hypotheses for a `+ Phi^2` square include:

```text
Gamma_s^2 = 1
{Gamma_s, C_a} = 0
[Gamma_s, nabla_a] = 0
[Gamma_s, Phi] = 0
[C_a, Phi] = 0
```

The Higgs or internal mass block should be internally odd under `chi_E`, not
spacetime-chirality odd under the same `Gamma_s`. If `Phi` anticommutes with
`Gamma_s`, the square flips the sign of `Phi^2`.

Higgs ontology and curvature conventions:

- Treat the Higgs multiplet as vertex-local internal zero-form data. Its
  gauge-covariant variation and kinetic transport are link-supported; a
  physical radial excitation is represented by a gauge-invariant local
  composite whose response propagates through sums of causal histories, not by
  a pointlike Higgs trajectory on one null edge.
- Distinguish support preservation from kernel selection. The finite Higgs
  path sums are proved to vanish outside any supplied transitive strict past,
  but this does not by itself derive the primitive weights or identify that
  supplied kernel with a continuum-calibrated null-link Green function.
- Use path language only when backed by explicit primitive support. The finite
  extraction theorem shows that a nonzero `K ^ n` entry has an actual
  length-`n` chain of nonzero primitive entries; for a strict-past-supported
  kernel this becomes a strict-past history. It does not prove that the
  primitive relation is continuum-null.
- Do not identify a finite causal-set covering relation with an exact null
  vector by terminology alone. Nullity must come from supplied decorated
  frame data or from a proved continuum concentration/calibration theorem.
- Lock the complete massless kernel and normalization by dimension. Johnston's
  original scalar controls use causal-matrix chains in `1+1` and link-matrix
  paths in `3+1`, while Hinrichsen--Kastrati (arXiv:2604.24812) give evidence
  for a normalized factorially weighted link-path kernel `exp(L)` in `1+1`.
  Thus dimension does not select `C` versus `L` by slogan: the continuum gate
  must certify the full function of the primitive adjacency and its weights.
- If the selected massless kernel contains an identity term, classify it as a
  zero-length contact convention. For `G0 = b * I + N`, the checked finite
  response has contact coefficient `b / (1 + c * b)`; after subtracting it,
  the remainder and its leading FMS radial lift retain strict-past support.
  Do not count that diagonal term as edge motion.
- Lock the density units in the massive scattering coefficient. Literature
  formulas commonly use `m^2 / rho`; a finite parameter named `massSq` is not a
  physical mass squared until the supplied kernel normalization proves where
  the density factor lives.
- The normalized expected four-dimensional Johnston link kernel is now proved
  to be a one-sided Gaussian delta sequence in `s = tau^2`, with exact mass
  `1/(2*pi)` and bounded-continuous test convergence. Do not promote this to a
  full spacetime theorem until the future-cone coarea lift is proved, or to an
  individual-causal-set theorem until random-sprinkling concentration is
  proved.
- Keep fermionic chirality flips separate from scalar propagation. A Higgs
  radial mode has no left/right Weyl zig-zag of its own. Primitive null support
  may nevertheless sum to an aggregate timelike massive scalar tail; this is a
  path-sum statement, not a literal scalar zig-zag.
- Do not assign the radial Higgs mass to a chiral spiral. Internal holonomy may
  rotate gauge-orbit directions, but the leading gauge-invariant radial
  observable annihilates those tangents; the current elementary radial mass
  comes from potential curvature.
- Keep the radial coordinate normalization explicit. The one-component control
  `H = v + h` with `lambda (|H|^2-v^2)^2` gives `m_h^2 = 8 lambda v^2`.
  The standard electroweak doublet
  `H = (0,(v+h)/sqrt(2))` with
  `lambda (H^dagger H-v^2/2)^2` gives `m_h^2 = 2 lambda v^2`.
  These are a coordinate/convention translation, not two mass predictions.
- In generic curved spacetime, formulate the Higgs target first as a local
  gauge-invariant two-point observable with a stated Hadamard/microlocal state
  condition. Reserve particle, pole, and LSZ language for stationary,
  adiabatic, or asymptotic regimes where those notions are available.
- Keep the present propagation claim scoped to the linearized radial channel
  and its leading FMS observable lift. The multiplet edge kinetic term is gauge
  covariant, but no full interacting nonabelian Higgs-doublet propagator has
  been constructed.
- For a nonzero Standard Model Higgs reference section, keep the exact tangent
  split explicit: one real radial direction is transverse to the rank-three
  physical electroweak orbit; gauge coordinates remain ambiguous only modulo
  the electromagnetic stabilizer. Do not describe the radial mode as a fourth
  Goldstone direction.
- If a supplied scalar operator has continuum convention
  `B_beta -> Box - beta * R` and the finite equation adds
  `-countertermXi * R`, record the physical coefficient as
  `xi = beta + countertermXi`. For the four-dimensional
  Benincasa--Dowker value `beta = 1/2`, the raw operator is not minimally
  coupled in this convention; minimal coupling requires counterterm `-1/2`.
  Do not present the built-in/operator split as observable: finite scalar
  propagation depends only on the sum.
- Audit curvature insertions against the complete calibrated base propagator,
  not only against a formal wave-operator symbol. Curved sprinklings may encode
  curvature through order and density while retaining flat jump amplitudes, so
  an explicit diagonal `xi * R` term must not double-count that response.
- In a constant-curvature scalar control, the local scattering insertion is
  the effective-mass difference between target and calibrated base kernels:
  `(m^2 + xi * R) - (m0^2 + xi0 * R)` (X--Dowker--Surya,
  arXiv:1701.07212). It reduces to `m^2 + xi * R` for a minimally coupled
  massless base, but to `m^2 + (xi - 1/6) * R` for the four-dimensional
  conformal base. Treat this as a curved-scalar precedent, not as a derivation
  of the interacting four-dimensional Higgs kernel.
- For quantum claims, treat the Higgs curvature coupling as a renormalized,
  scale- and scheme-dependent parameter until the program derives the relevant
  running. A finite bare coefficient is not by itself a prediction of physical
  `xi`.
- Do not infer a nonminimally coupled Higgs stress tensor from the local
  `xi * R` propagation insertion alone. Geometry variation of
  `measure * xi * R * ||H||^2` has separate volume and curvature-response
  channels; a stress claim needs the graph/coframe realization of the latter.

Use `Box_null` as the kinetic mass-shell operator. In mostly-minus signature,
the analytic d'Alembertian has plane-wave symbol `-p^2`; the mass-shell
normalization for `-Box_null + Phi^2 = 0` should give `p^2 = m^2`.

## Frame term and tetrad compatibility

The finite square should be decomposed as:

```text
D_N^2 = Box_null + C_diamond + T_frame
```

with:

```text
Box_null  = 1/4 sum_{a,b} {C_a, C_b} {nabla_a, nabla_b}
C_diamond = 1/4 sum_{a,b} [C_a, C_b] [nabla_a, nabla_b]
T_frame   = sum_{a,b} C_a [nabla_a, C_b] nabla_b
```

The finite tetrad postulate is:

```text
[nabla_a, C_b] = 0
```

or the corresponding edge-transport compatibility equation. If this fails,
classify the defect rather than hiding it:

- Nonmetricity or bad soldering if metric compatibility fails.
- Curvature or holonomy if metric compatibility holds but connection
  commutators survive.
- Torsion-like defect if edge parallelograms fail to close or antisymmetric
  displacement defects appear.
- Smooth-limit contamination if `C_b` jumps by order one across `h`-edges.

## Gravity connection guardrails

- Do not use the pointwise forward-difference affine connection as the active
  finite Palatini dynamics. Its exact periodic Euler coefficient has a
  three-site conformal null-edge witness with coefficient `-95`, and the
  reconstructed Christoffel candidate fails even torsion-free stationarity.
  The canonical flat chart remains a valid control only.
- Put finite gravitational transport on directed links and curvature on
  oriented faces. The current group-valued substrate has conjugation-covariant
  plaquette holonomy; its real additive tangent action is vertex-gauge
  invariant and has an exact periodic discrete adjoint.
- For an antisymmetric ordered face weight, the additive link equation is
  exactly vanishing backward face divergence. This is a linearized consistency
  theorem, not yet a Levi-Civita recovery theorem.
- The transported finite-fiber control uses ordinary transpose because its
  component pairing is Euclidean. Do not identify this with Lorentz transport
  by notation alone. The abstract Krein bridge proves the corresponding
  predecessor identity for `A^sharp = J A^T J`. The physical bivector bridge
  orders spatial rotation planes first and time-space boost planes second,
  derives `J = diag(+,+,+,-,-,-)` from the mostly-minus spacetime metric, and
  proves preservation by every eta-Lorentz transport, including the concrete
  null-edge `SL(2,C)` action. The complete linearized face-action Euler chain
  has now also been rebuilt with this Krein pairing, including separating
  component probes and the antisymmetric-face divergence equation.
- The same six-component bivector fiber is exactly equivalent to the matrix
  Lorentz Lie algebra through `hat(B)=F(B) eta`, and its Krein pairing is
  `-1/2 tr(hat(B)hat(C))`. Do not pair a six-component face field directly with
  an unconstrained matrix holonomy. The exact right-trivialized plaquette
  tangent is now proved to lie in the Lorentz Lie algebra for eta-Lorentz
  links; recover its six coordinates through this equivalence before pairing.
  Its four-corner adjoint formula is an exact response one-form, not by itself
  a scalar action. The scalar successor uses
  `-1/2 tr(hat(B_ab)(H_ab-I))`, whose formal variation carries the required
  extra holonomy factor away from identity and recovers the additive Krein
  response exactly at identity links. The complete scalar action is already
  vertex-gauge invariant for any face field obeying the exterior-square
  Lorentz transformation law. Proper eta-Lorentz coframe transformations with
  determinant `+1` commute with the concrete Hodge star, so the complementary
  coframe face obeys that law and the concrete action is exactly gauge
  invariant. On identity links, formal stationarity is exactly the
  complementary-face Krein divergence equation, with a constant-coframe flat
  control. At arbitrary group-valued links, the exact global formal response
  is now reorganized into four local contribution families, each local
  functional has six ordinary Lorentz-generator coefficients, and formal
  stationarity is equivalent to vanishing of every coefficient. Canonical
  curves `U exp(t hat(delta A))` realize every link variation, and ordinary
  derivative stationarity along these curves is equivalent to that formal
  stationarity condition. Their invertibility and preservation of the proper
  eta-Lorentz subgroup are exact. Do not call them proper-orthochronous curves
  until the separate time-orientation sign is proved.
- Keep coframe-pair and curvature-face labels distinct. The internal building
  block is `star(e_a wedge e_b)`, but the coefficient of curvature plaquette
  `(a,b)` is `(1/2) sum_cd epsilon^(cdab) star(e_c wedge e_d)`. The exact
  module checks all six complements, including `F_01` paired with the `23`
  coframe plane. Reusing the same `(a,b)` for both factors is not the tetradic
  Palatini four-form.
- The complementary unweighted face field, orientation `0123`, `star^2=-1`,
  ordered antisymmetry, and the resulting Krein-divergence equation are exact.
  Proper local Lorentz covariance of both face fields is also exact. The
  metric dual-cell volume factor is still owed.
- In the fixed six-vector convention,
  `[star(B),C]_J = -(1/4) epsilon_IJKL B^IJ C^KL`. The minus sign is harmless
  for the vacuum connection stationarity equation, but a joint matter action
  must absorb it explicitly in the gravitational prefactor or curvature
  orientation before comparing `kappa` signs.
- A physical Palatini claim still owes the metric dual-cell volume factor,
  projective and boundary analysis, and uniqueness of the compatible
  Levi-Civita link transport.

## Krein double guardrails

The minimal finite Krein API is:

```text
J = J^dagger = J^{-1}
[u, v]_J = <u, J v>
A^sharp = J A^dagger J
```

Given `D_- := D_+^sharp`, the doubled operator:

```text
D_dbl = [[0, D_-], [D_+, 0]]
```

is the right finite object to audit for `J`-self-adjointness.

Do not overclaim. Krein self-adjointness does not by itself imply positivity,
unitary time evolution, real spectrum, stability, anomaly cancellation, or a
chiral Standard Model sector.

## No-doubling and branch-count tests

Retardedness alone is not a no-doubling proof.

On a flat periodic patch:

```text
D_+(q) = sum_a C_a (exp(i q_a) - 1) / h = c(p(q))
p(q) = h^{-1} sum_a (exp(i q_a) - 1) alpha^a
```

The fact that `p(q) = 0` only at the continuum point rules out coefficient-zero
doublers. It does not rule out determinant-level Clifford singularities.

The physical test is:

```text
det D_+(q) = 0
```

or, in the massless flat case:

```text
p(q)^2 = 0
```

A nonzero null `p(q)` can still have a Clifford kernel. Future no-doubling
claims should discuss the determinant-level branch-count protocol, including
high-momentum real branches, complex branches, kernel dimensions, chirality, and
Krein doubling behavior.

## Universal null frames

For a single hidden strand, observer normalization or a timelike barycenter can
be useful. For a universal field operator, do not introduce a preferred observer
unless that is an explicit physical assumption.

The preferred architecture is a decorated null-tetrad graph. In four dimensions:

```text
ell_A(x) = e_0(x) + n_A^i e_i(x)
alpha^A(x) = 1/4 e^0(x) + 3/4 n_A^i e^i(x)
```

The finite object carries:

```text
V, E, ell_a(x), alpha^a(x), h_a(x), U_a(x), J_x,
Gamma_s, chi_E, Phi_x
```

plus compatibility laws. Do not claim that a bare graph canonically supplies a
tetrad or finite null frame unless a separate theorem derives it.

Sharper form of the same guardrail (recorded 2026-07-07 from the
ontology-extensions memo, `Sources/Ontology_extensions.md` sec 6): in the
continuum, causal order alone already determines the conformal class
(Malament; Hawking-King-McCarthy), so the honest division of labor is -
order data may be credited with the CONFORMAL structure, while decorations
(the soldering Gram data) owe exactly the SCALE/volume factor, no more and no
less (Sorkin: "order + number = geometry"). Emergence claims should say which
half they address; "the tetrad emerges" conflates a free half with an owed
half.

Retardedness guardrail, sharpened (2026-07-07, Q03 no-go audit): retarded
transports delete lattice HERMITICITY, not chirality - a third doubling-escape
mechanism distinct from Wilson terms and overlap kernels, principled only
because Krein `J`-self-adjointness replaces Hilbert Hermiticity. It provably
CANNOT delete doubling partners (the retarded symbol determinant's zero set is
null-homologous on the Brillouin torus), only relocate them off the unitary
shell; in `d >= 2` a two-edge model has entire LINES of gapless modes. The
load-bearing chirality evasion is Ginsparg-Wilson DESCENT to the physical
sector; retardedness is the physical constraint selecting forward data. Any
physical-sector quotient must re-check that off-shell doublers are not dragged
back on-shell.

Terminology guard (standing): the Krein fundamental symmetry `J` (linear,
metric operator) and an NCG-style real structure `J_R` (antilinear, charge
conjugation) are different objects; never let the notation collide in any
document.

## Scaling and continuum tests

Use this order:

1. Flat symbol test on a fixed decorated periodic graph.
2. Flat determinant/branch-count test for real and complex branches.
3. Curved tetrad test with smooth frame and spin connection.
4. Commuting-square test: finite square then limit equals continuum Dirac then
   Lichnerowicz square.
5. Stochastic or covariant graph ensemble test only after the decorated
   deterministic case works.

The finite square can be exact while the continuum limit fails. Watch for
surviving frame terms, wrong holonomy normalization, wrong Pauli coefficient,
high-frequency branches that do not decouple, and wrong Lichnerowicz
endomorphism.

For same-graph causal-operator concentration, do not treat several globally
selected rows as independent samples. The active finite successor is the
complete ensemble of maximum eligible Alexandrov-germ packings with pairwise
disjoint closed carriers. Average over the whole ensemble rather than choosing
one automorphism-breaking packing. Even then, disjoint carriers yield local
random variables only after every score input is computed internally, and a
fixed-total-count graph law can retain dependence across disjoint carriers.
The active finite locality bridge uses the induced causal order on each closed
carrier. Causal convexity makes every induced interval count equal its ambient
count, and the induced smeared operator equals the ambient operator on zero
extension. This validates the local read architecture; it does not make the
current cutoff-control score a complete metric-reconstruction probe family.

Do not require a physical scalar-probe basis to be pointwise natural under all
order isomorphisms. On an automorphism-transitive order, every such individual
probe is constant, and a zero-sum one vanishes. The viable finite object is a
natural probe subspace transported up to basis change. The canonical zero-sum
subspace gives a rank-four control on a five-event antichain and an exactly
covariant carrier pairing, but that rank comes from cardinality rather than
causal dimension and is not evidence by itself for Lorentzian signature.

Once a natural carrier subspace has rank four, treat a probe tetrad as a basis
of that subspace. The active corrected pairing is a symmetric bilinear form,
and its matrices in two probe frames obey `G_c = M^T G_b M`. Conditional on one
frame giving the project matrix `diag(1,-1,-1,-1)`, the normalized frame changes
are exactly the `eta`-orthogonal transformations. This identifies the correct
finite Lorentz-gauge quotient, but it is not a proof that physical carriers
have rank four or that their operator pairing has Lorentzian inertia.

Open target-metric and signature scores only after the intrinsic retarded-shell
availability gate. Build the shell from count-band past/future abundance and a
marked event, and treat visibility basis-freely as injectivity of probe-space
restriction to that shell. Exact finite dimension gives
`finrank P <= shell.card`; in particular, fewer than four shell events forbid a
visible rank-four probe sector. Four events are only the sharp qualitative
minimum. They do not imply a positive quantitative coverage quotient, local
affinity, product closure, Lorentzian inertia, or metric convergence.

Keep the tensor variance explicit when composing probe frames with relative
scale. Simultaneously scaling the operator lengths by `r` leaves the smearing
ratio fixed and scales its corrected-pairing Gram matrix by `r^-2`; this is the
principal-symbol inverse metric. The row-coframe metric scales by `r^2`.
Therefore count-derived relative area appears directly in the covariant metric
and inversely in the probe Gram matrix. Do not compare those matrices as though
they were the same tensor, and do not infer rank four, Lorentzian inertia, or
continuum convergence from their reciprocal finite scale laws.

## Claim-boundary labels

When discussing physics implications, prefer explicit labels:

- finite identity
- asymptotic theorem
- reconstruction
- kinematic identity
- consistency check
- prediction

This is not mandatory prose bureaucracy, but it prevents accidental overclaiming.
The dual-soldered square is currently a reconstruction and finite identity, not
new physics by itself.

## Aristotle jobs for NullStrand

Use Aristotle ambitiously. Besides Lean proof jobs, good NullStrand Aristotle
tasks include:

- strategy jobs that compare proof routes and no-go risks;
- audit jobs for hidden assumptions, sign errors, grading mistakes, and
  convention drift;
- determinant branch-count analysis;
- continuum scaling and commuting-square analysis;
- literature-informed formalization plans;
- semantic review of returned Lean theorem statements;
- pressure tests for prediction claims.

Aristotle output still needs human/agent semantic review. The Lean kernel checks
proofs, not whether the theorem is the intended physics statement.

## Current priority list

High-priority near-term jobs:

- determinant branch-count audit for the tetrahedral retarded operator;
- graded square theorem with separated `Gamma_s` and `chi_E`;
- frame-term and finite tetrad-postulate theorem;
- Krein retarded/advanced self-adjointness API plus spectral caveats;
- spectral mass-shell matching theorem;
- Pauli diamond normalization;
- finite Markov regenerative strong-law route;
- stopped/local node theorem charter;
- moduli-rank prediction ledger.

## Main source files

Start with:

- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `Sources/NullStrand_Open_Questions_For_Frontier_Models.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `AgentTasks/`

These files are allowed to evolve faster than AGENTS.md.

## Lateral-analysis guardrails (2026-06-27)

Guardrails added after a lateral read of the mass program. These are
convention/claim-label rules, recorded here so future agents apply them by
default. The decision-log entry is
`AgentTasks/null-edge-decision-log-2026-06-27.md` (D25).

- **Treat the project as obstruction geometry, not only mass from spread.** The
  finite Plucker theorem is the trusted core example, but the wider program is
  the classification of canonical failures of one-beam, one-branch, one-orbit,
  or one-mode descriptions. Use the pattern `zero locus / moduli locus +
  canonical obstruction + quadratic norm, determinant, Hessian, or gap`. Do not
  force Yukawa, Higgs, QCD, Gate C, and internal finite algebra into one literal
  Plucker formula.

- **Observer-conditioned mixedness is a separate claim label from the invariant
  Pluecker mass.** Keep `det P = m^2` as the invariant finite statement on the
  unnormalized visible momentum block `P = sum_i psi_i psi_i^dagger`. Only the
  normalized form `det rho_{p|u} = (m / E_u)^2`, with `rho = P / Tr(P)` in a
  chosen visible sector and `E_u` a chosen timelike normalization, may carry
  "mixedness" / "impurity" language, and it must be labeled observer-conditioned:
  it depends on both a resolution observer (the partial trace over hidden labels)
  and a kinematic observer (the timelike frame). Do not let frame-relative
  mixedness language leak into statements about the invariant determinant.

- **Gate C is a branch-topology problem, not a scalar-coefficient tweak.** Treat
  the branch locus `Z = { q : det D_+(q) = 0 }`, its kernel sheaf, and the branch
  involution as first-class objects. Do not describe a Gate C1 release as scalar
  Wilson tuning: the scalar Wilson no-go is sharp. Log any candidate release in
  terms of nodal control, kernel/spinor-line projection, a true inverse-propagator
  mass gap (not a propagator zero), ghost-zero safety, and chirality alignment.
  This sharpens the existing guardrail that retardedness alone is not a
  no-doubling proof: the determinant-level test lives on `Z`.

- **C1 is release data, not a bare corrected symbol.** A C1 claim needs at least
  `(D_gap, Pi_phys, D_phys, Gamma_lat, physical/Krein data)` with a selected
  one-Weyl-line origin sector, true gaps on mirror/unwanted branch components,
  locality or controlled quasi-locality, and anomaly/ghost audits. Treat direct
  unprojected overlap on the full bare `D_+` as unsafe until a shifted-kernel
  mass-window theorem proves there is no singular crossing from an unwanted
  zero branch germ. The null-edge-native route to try first is a branch
  classifier/projector (`T_br` or `Pi_br`) that is not scalar on the balanced
  origin kernel and separates branch germs rather than tastes only.

- **C1 first asks for an origin polarizer.** If the balanced origin kernel has a
  chirality-flipping balance symmetry `J`, then any origin projector commuting
  with `J` has zero chiral index. A physical one-Weyl-line projector must
  therefore escape the balance commutant. The next native Gate C fork is:
  either find a gauge-safe Hermitian involution `T0` in the native origin algebra
  with nonzero `Tr(Gamma0 (1 + T0)/2)`, then extend it to an analytic/local
  branch classifier `T_br(q,U)`; or prove all native gauge-safe origin
  endomorphisms commute with `J`, which rules out native finite/local
  `T_br`/non-scalar-Wilson C1 under those assumptions. Projected overlap and
  domain-wall routes are then fallback escape structures, not magic fixes.

- **C90 is release-audit plumbing, not C1 closure.** The recovered
  `NullEdgeProjectedGateCWilsonRelease` payload exposes
  `ProjectedWilsonGateCRelease D_phys` and separates residue/Krein positivity,
  no gauge-coupled ghost zeros, BRST/Krein obligations, and Wilson-regulator
  moduli fields. Use it as the current projected Wilson-release API spine, but
  do not cite it as a construction of `D_phys`, a release of bare `D_+`, or a
  proof of C1.

- **Route labels, projections, localization, and formal projectors are not
  release audits.** `NullEdgeReleaseAuditToyGuardrails` and
  `NullEdgeLocalityCertificateToy` are finite draft guardrails showing that a
  Ginsparg-Wilson/overlap label, a projection, a localized one-Weyl-line
  candidate, or a formal projector does not by itself supply the full release
  audit. Treat these as warning modules when writing future Gate C claims.

- **Prediction-grade should start with absence theorems.** Before numerical mass
  values, prefer forbidden-operator, codimension, rank, texture, and map-choice
  constraints. In particular, Gate H/Gate F should prioritize legal finite
  Dirac/Higgs block classification and neutrino branch decisions before any
  Yukawa-value rhetoric.
