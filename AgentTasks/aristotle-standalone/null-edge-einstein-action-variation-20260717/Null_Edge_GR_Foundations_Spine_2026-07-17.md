# Null-Edge GR Foundations Spine

**Status:** canonical architecture and literature audit, 2026-07-17  
**Scope:** the minimum complete dependency chain from finite causal data to
general relativity, with exact repository status and no competing foundational
routes

## Executive verdict

The repo contains nearly every *kind* of object needed for a GR reconstruction:
causal order, count volume, scalar causal operators, metric pairings, coframes,
Lorentz and spin transitions, connections, curvature, Bianchi identities,
matter variations, and controlled Einstein-equation reductions. The main
problem is not a missing finite analogue. It is that the ingredients are spread
across many capstones and experimental stages, while the genuinely open
continuum and dynamical bridges can be hard to distinguish from exact finite
algebra.

The program should therefore have one foundations spine:

\[
 (C,\mu)
 \longrightarrow B_L
 \longrightarrow \Gamma_{B_L}
 \longrightarrow g^{-1}
 \longrightarrow (e,\nabla,R)
 \longrightarrow (S_{\rm grav}+S_{\rm matter},T)
 \longrightarrow G+\Lambda g=8\pi G_NT.
\]

Here `C` is a locally finite causal order, `mu` is count measure, `B_L` is one
count-normalized mesoscopic scalar operator, and

\[
 \Gamma_B(f,h)=\frac12\bigl(B(fh)-fBh-hBf+fhB1\bigr)
\]

is its potential-canceling principal-symbol pairing. The physical metric is
the unique metric reconstructed from this pairing and count volume. A coframe
is a local Lorentz-gauge factorization of that metric, not a second metric.
Connection, holonomy, Dirac-square curvature, matter variation, and the action
must all converge on that same geometry.

The deepest missing fundamental is a probability/dynamics statement:

> The theory must distinguish reconstruction on causal sets already known to
> approximate a manifold from a dynamics that actually selects such
> manifoldlike causal sets.

No amount of additional finite GR-shaped algebra closes that gap.

Claim grades follow the project calculus: `T [import]` for source-verified
continuum results, `M` for kernel-checked finite identities, `T|H` for results
conditional on displayed reconstruction hypotheses, and `C` for open bridges
with success and kill conditions. No `M` result in this note is thereby a
continuum GR theorem.

## 1. Minimal ontology

Only four layers are fundamental.

### Layer A: order and number

The bare covariant datum is a finite or locally finite order/count pair

\[
 (C,\prec,\mu_C).
\]

Relabeling is gauge. Open intervals and their cardinalities are intrinsic.
Counting is the candidate volume datum. A causal-set covering relation is
causal support; it is not automatically an exact continuum-null tangent.

This last distinction matters for the name "null edge." Exact null vectors,
spin frames, or soldering forms must be either decorations with transformation
laws or outputs of a reconstruction theorem. The literature also rules out an
intrinsic finite preferred direction set for a Poisson sprinkling if Lorentz
equivariance is retained.

### Layer B: reconstructed geometry

At mesoscopic scale `L`, one order/count construction must select:

\[
 (\mathcal A_L,\mu_L,B_L,\prec),
\]

where `A_L` is a gauge-relative scalar probe algebra. The corrected pairing of
`B_L` reconstructs the inverse metric on a stable four-dimensional image. The
count measure fixes the missing Weyl factor. Coordinates are local generators
of `A_L`, not primitive labels.

The coframe, spin frame, Levi-Civita connection, and curvature are lifts or
derivatives of this one metric:

\[
 g_{\mu\nu}=\eta_{IJ}e^I{}_{\mu}e^J{}_{\nu},
 \qquad \nabla=\nabla^{\rm LC}(g),
 \qquad R=R(\nabla).
\]

### Layer C: spin and matter

The same coframe solders the Dirac principal symbol. The same metric and count
measure enter the matter action. Stress-energy is the localized metric or
coframe variation of that action, not an energy scalar or trace budget.

Spin structure is a global lift condition on the reconstructed oriented
Lorentz atlas. It is not supplied by a local `SL(2,C)` formula alone.

### Layer D: dynamics and continuum selection

The model needs a covariant measure, quantum measure, or effective weighting on
causal histories. Two independent results are required:

1. **Manifold-conditioned reconstruction:** given a faithful approximation to
   a suitable Lorentzian manifold, all estimators converge to its geometry.
2. **Dynamical selection:** the model's own measure concentrates on the sector
   where those reconstruction hypotheses hold.

Only after both steps may an interval-count action be said to produce a GR
infrared phase.

## 2. The canonical gates

| Gate | Required result | Present in the repo | Exact open debt |
|---|---|---|---|
| F0: finite kinematics | Strict causal order, count measure, relabeling covariance | Exact open intervals, layers, equivariant causal operators, null-spinor soldering controls | A single agreed primitive data type linking order/count data to optional decorations |
| F1: manifold-conditioned limit | Faithful embeddings or an equivalent intrinsic convergence interface | Extensive sprinkled-manifold controls and a two-scale reconstruction protocol | One theorem family with explicit probability space, regulator schedule, topology, and uniform error bounds |
| F2: dynamical manifold selection | The theory suppresses nonmanifoldlike orders and selects a four-dimensional Lorentzian phase | Candidate actions and finite experiments only | A covariant ensemble/quantum measure and concentration on the F1 domain |
| F3: dimension, topology, conformal class | Recover dimension, topology, and causal conformal geometry | Continuum Malament/HKM result is imported; finite topology and dimension literature is catalogued | Intrinsic dimension/topology convergence for the selected ensemble |
| F4: metric and scale | `Gamma_B` converges to rank-four `(+---)` inverse metric and count volume fixes scale | Potential cancellation, relabeling covariance, scale laws, rank-four interfaces, no-go results, and finite witnesses are exact | Canonical selector, four-mode gap, product closure, overlap/refinement persistence, concentration, and absolute calibration |
| F5: coframe and spin | Gauge-relative coframe and a compatible spin lift of the metric atlas | Exact coframe covariance, Lorentz transitions, central sign, and finite obstruction interfaces | Derive the atlas and identify the stable finite class with the continuum spin obstruction |
| F6: one curvature | Levi-Civita, holonomy, operator, and Dirac-square curvature agree | Exact finite connection/Bianchi algebra and conditional shrinking-loop limits | Convergence of all routes to the same Riemann/Ricci/scalar curvature with the correct `R/4` coefficient |
| F7: one matter source | Localized variation of one matter action gives symmetric conserved `T` | Higgs/scalar controls, full symmetric-probe uniqueness, and the explicit Bianchi-to-source-conservation composition are exact | Derive the arbitrary local variation and matter Noether identity on the common reconstructed geometry |
| F8: one gravity action | One graph action converges to Einstein-Hilbert plus boundary and controlled corrections | Benincasa-Dowker/FLRW controls and the exact finite stationarity-to-Einstein-equation coefficient theorem | Derive the action, boundary term, `G_N`, `Lambda`, variation-limit interchange, stationarity, and backreaction from null-edge data |
| F9: physical recovery | Newtonian, redshift, geodesic, wave, horizon, black-hole, and cosmological controls | Poisson normalization and FLRW equations under imported actions | Full independent controls, including tensor modes and curved local observables |

The program is strongest at F0 and in the exact algebraic interfaces inside
F4-F7. Its decisive bottleneck remains F4, but F1 and F2 are logically prior
to any claim that the continuum theory is selected rather than supplied.

The theorems
`EinsteinEquationVariation.metricStationary_iff_finiteEinsteinEquation` and
`actionMetricStationary_iff_finiteEinsteinEquation` now make the final finite
variational implication exact. For nonzero coupling, vanishing response
against every symmetric component variation is equivalent to
`G + Lambda g = kappa T`; if an actual finite action is proved to have that
directional derivative, its ordinary stationarity is equivalent to the same
tensor equation. The companion conservation theorem composes a differentiated
field equation with the explicit finite contracted Bianchi identity. This
advances the F7/F8 interface, but does not close F8: the graph action, its
first-variation formula, and variation-limit interchange remain inputs rather
than derived results.

## 3. Five consistency contracts

These contracts prevent the repo from accumulating mutually incompatible
finite gravities.

### Contract 1: one metric

The causal-operator pairing and count volume define the physical metric. Every
coframe theorem must prove that its Gram metric is this metric. A separate
coframe fit is only a control until that equality is established.

### Contract 2: one curvature

At refinement, the following must agree after convention and index conversion:

\[
 R_{\rm LC}=R_{\rm holonomy}=R_{\rm operator}=R_{D^2}.
\]

Finite Bianchi identities do not prove this agreement. Persistent disagreement
kills a common geometric interpretation. Torsion and nonmetricity must either
converge to zero on the Levi-Civita route or enter a separately proved
equivalent formulation; they cannot be silently absorbed into curvature.

### Contract 3: one matter geometry

Scalar, Higgs, fermion, and gauge actions must use the same measure, inverse
metric, coframe, and connection. Channel-dependent metric estimators or
gravitational couplings violate the intended equivalence-principle reading.

### Contract 4: one primary action

The order/operator action is the primary dynamics candidate. Spectral,
thermodynamic, and teleparallel constructions are comparisons until an
equivalence theorem identifies them with the same action including boundary
terms and constants.

### Contract 5: one refinement law

Every local object needs a common refinement interface: carriers, probe
algebras, projectors, metric, orientation, spin lifts, connection, curvature,
matter fields, and action. Pointwise witnesses without overlap and refinement
compatibility are finite models, not continuum reconstruction.

## 4. What the literature changes

### Order plus number is the right kinematical split

Hawking-King-McCarthy and Malament show, under explicit causality hypotheses,
that causal data determine continuum topology/differentiable/conformal
structure. They do not recover the conformal factor. The causal-set proposal
adds local finiteness/counting as the volume input. This supports the repo's
order-versus-scale split, but only after a manifoldlike correspondence is
proved.

### Lorentz invariance is statistical, not a finite frame

Poisson sprinkling can preserve Lorentz symmetry in distribution. The
Bombelli-Henson-Sorkin theorem excludes a measurable Lorentz-equivariant map
from a sprinkling to a preferred direction, and in particular blocks a
canonical intrinsic finite-valency frame. The repo's move from preferred
vectors to natural subspaces and gauge-relative frames is therefore not merely
convenient; it matches the known obstruction.

### Reconstruction and dynamics are separate research programs

Faithful embedding, thickened-antichain topology, dimension estimators, and
operator convergence concern reconstruction on manifoldlike inputs. The fact
that most large finite orders are not manifoldlike creates a separate entropy
and dynamics problem. Results suppressing one class of nonmanifoldlike orders
under a causal-set action are encouraging but not a general selection theorem.

### The scalar operator is the highest-leverage bridge

Benincasa-Dowker operators recover `Box - R/2` in an appropriate mean
continuum limit. Their principal symbol therefore carries the inverse metric,
while their constant response carries scalar curvature. The repo's corrected
pairing is the right algebraic device because it cancels the curvature
potential exactly before taking a limit.

The recent local causal-set d'Alembertian offers a serious alternate estimator.
It proves a Minkowski continuum result using intrinsic timelike and spacelike
neighborhoods, but it does not remove the repo's dimension, scale, curved-limit,
and dynamical-selection debts. The local and compact-nonlocal branches should
share the same F1 benchmark rather than become two foundations.

### The action route must include boundaries

The Benincasa-Dowker-Glaser action has a studied continuum limit on causal
diamonds with an Einstein-Hilbert bulk term and a codimension-two joint term.
This strengthens the interval-count action route and shows why the boundary
sector cannot be postponed until after the bulk field equation.

## 5. Repository simplification

The documents now have distinct jobs:

| Artifact | Canonical role |
|---|---|
| `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md` | Stable architecture, completeness checklist, and literature-grounded claim boundary |
| `PhysicsSM/Draft/NullEdge/GRFoundations.lean` | Lean import facade for the load-bearing finite theorem modules |
| `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` | Detailed theorem ledger, experimental history, negative results, and conditional continuum theorem |
| `AutonomousLab/work/DIRECTOR_REVIEW_PACKET_2026-07-16.md` | Time-local experimental and governance status |
| `Sources/Null_Edge_Derivation_Map_SM_GR_2026-07-17.md` | Cross-program SM/GR dependency map |

Future GR work should attach to exactly one F-gate and name which consistency
contract it advances. A capstone that only imports several avatars does not
advance a gate. A new estimator should replace or compare with the canonical
one on a preregistered common benchmark; it should not silently create another
metric, curvature, or action.

## 6. Immediate program

1. **Finish the F4 selector theorem.** Derive a canonical rank-four selected
   sector with a nonzero four-mode gap, mostly-minus inertia, overlap transport,
   and refinement persistence. The marked Alexandrov 1+3 construction is a
   conditional witness, not yet the selector.
2. **Split G0 permanently into F1 and F2.** First prove convergence on known
   sprinklings. Then test whether the chosen dynamics concentrates on the
   preregistered manifoldlike domain. Never use success at F1 as evidence for
   F2.
3. **Close the curvature triangle before adding dynamics avatars.** Compare
   Levi-Civita, holonomy, and operator curvature on the same reconstructed
   metric and refinement schedule; only then test the Dirac `R/4` term.
4. **Localize one matter action.** Generalize the existing scalar/Higgs
   variations to arbitrary symmetric local metric or coframe probes and prove
   the finite Noether interface. The coefficient-identification and
   Bianchi-to-conservation endpoints are now exact; the missing step is to
   derive their variation and differentiated-field-equation premises from the
   same local action.
5. **Promote one interval-count action.** Include bulk, boundary, constants,
   matter coupling, and variation-limit interchange in one statement, using
   the exact stationarity theorem as its endpoint. Keep thermodynamic,
   spectral, and teleparallel routes as checks.
6. **Run independent physical controls last.** Newtonian gravity, redshift,
   geodesic motion, tensor waves, FLRW, and horizon behavior should test the
   derived continuum package rather than define it piecemeal.

## 7. Primary literature

1. S. W. Hawking, A. R. King, and P. J. McCarthy, "A new topology for curved
   space-time which incorporates the causal, differential, and conformal
   structures," [doi:10.1063/1.522874](https://doi.org/10.1063/1.522874).
2. D. B. Malament, "The class of continuous timelike curves determines the
   topology of spacetime,"
   [doi:10.1063/1.523436](https://doi.org/10.1063/1.523436).
3. L. Bombelli, J. Lee, D. Meyer, and R. D. Sorkin, "Space-time as a causal
   set," [doi:10.1103/PhysRevLett.59.521](https://doi.org/10.1103/PhysRevLett.59.521).
4. L. Bombelli, J. Henson, and R. D. Sorkin, "Discreteness without symmetry
   breaking: a theorem,"
   [arXiv:gr-qc/0605006](https://arxiv.org/abs/gr-qc/0605006).
5. S. Major, D. Rideout, and S. Surya, "On recovering continuum topology from
   a causal set,"
   [arXiv:gr-qc/0604124](https://arxiv.org/abs/gr-qc/0604124).
6. D. P. Rideout and R. D. Sorkin, "A classical sequential growth dynamics
   for causal sets,"
   [arXiv:gr-qc/9904062](https://arxiv.org/abs/gr-qc/9904062).
7. D. M. T. Benincasa and F. Dowker, "The scalar curvature of a causal set,"
   [arXiv:1001.2725](https://arxiv.org/abs/1001.2725).
8. A. Belenchia, D. M. T. Benincasa, and F. Dowker, "The continuum limit of a
   4-dimensional causal set scalar d'Alembertian,"
   [arXiv:1510.04656](https://arxiv.org/abs/1510.04656).
9. L. Machet and J. Wang, "On the continuum limit of Benincasa-Dowker-Glaser
   causal set action,"
   [arXiv:2007.13192](https://arxiv.org/abs/2007.13192).
10. S. P. Loomis and S. Carlip, "Suppression of non-manifold-like sets in the
    causal set path integral,"
    [arXiv:1709.00064](https://arxiv.org/abs/1709.00064).
11. S. Surya, "The causal set approach to quantum gravity,"
    [arXiv:1903.11544](https://arxiv.org/abs/1903.11544).
12. M. Boguna and D. Krioukov, "Local d'Alembertian for causal sets,"
    [arXiv:2506.18745](https://arxiv.org/abs/2506.18745).

## Bottom line

The fundamentals are conceptually present, but not yet complete as theorems.
The correct unification is not to merge every finite gravity avatar. It is to
enforce one order/count core, one operator-derived metric, one gauge-relative
coframe, one curvature in several equivalent representations, one matter
variation, and one primary action, all on one refinement and probability
space.

The resulting honest claim remains:

> A finite null-edge Lorentzian and Dirac geometry with a precise,
> literature-grounded reconstruction program for general relativity.

The missing theorem is the passage from the model's own causal histories to a
selected manifoldlike continuum satisfying the entire spine.
