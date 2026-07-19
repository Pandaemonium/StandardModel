# Null-Edge General Relativity Literature Audit

**Date:** 2026-07-18
**Status:** primary-source audit and program correction
**Scope:** null lattices, first-order discrete gravity, linearized lattice
gravitons, connection/curvature convergence, and the novelty boundary of the
current null-edge Palatini program

## Executive conclusion

The literature supports the basic architecture but narrows its originality.
A causal null lattice with local `SL(2,C)` data and a smooth Hilbert-Palatini
limit already exists in Schaden. A locally Lorentz-invariant discretization of
the tetradic Palatini action with independent coframe and connection equations
already exists in Kur and Glasser. A 3+1 Regge evolution architecture whose
successive spacelike three-geometries are joined entirely by null struts
predates both in Kheyfets, LaFave, and Miller. First-order Regge and Poincare
formulations already provide small-curvature Levi-Civita selection results.

The repo's defensible distinctive contribution is therefore not the broad idea
"GR from null links." It is the exact, convention-locked, kernel-checked finite
chain and its unusually sharp positive and negative results:

1. a concrete proper-Lorentz null-wave curvature witness satisfying the finite
   vacuum coframe equation;
2. the complete rank-six, ten-parameter fixed-link coframe-response kernel;
3. the no-go for every invertible jointly stationary coframe when those wave
   links are held fixed at nonzero area;
4. an exact affine connection-dependent Palatini theorem whose twenty-four
   equations select `de + omega wedge e = 0`, with a cubic finite-spacing
   defect and shrinking endpoint;
5. a coupled link/coframe linearization whose complete stationary curvature
   image is kernel-checked as an injective two-real-dimensional plus/cross
   range; the oracle still supplies the full Hessian rank and nullity;
6. a formal second-order exponential-jet obstruction whose integrated
   time-time charge is exactly `-8(p^2+c^2)` and is unchanged by arbitrary
   second-order link corrections.

The fifth item is not yet a two-polarization graviton theorem, and the sixth
shows that its nonzero modes do not pass the same-carrier formal continuation
condition. Linearized
Regge theory makes clear that a physical mode count requires an identified
gauge kernel, discrete Bianchi identities, a quotient by gauge, and a
propagation statement. Those are now the immediate gate.

## Search protocol

The search combined:

- exact and semantic search over the local Zotero/Neo4j null-edge collection;
- arXiv and INSPIRE-HEP discovery searches;
- primary full-text inspection of the closest papers;
- title and external-identifier deduplication before Zotero ingestion;
- full-text chunk ingestion for the principal sources.

Search concepts included `null lattice gravity`, `tetradic Palatini lattice`,
`local Lorentz discrete gravity`, `linearized Regge Hessian`, `lattice
gravitons`, `Levi-Civita small deficit`, `holonomy curvature convergence`, and
`light-like curvature defects`. The search was designed to find both close
constructions and no-go or claim-limiting results. It is not a citation-count
review.

Ten arXiv papers were added to Zotero collection `9W59V3K9`, synced to Neo4j,
abstract-embedded, and full-text chunked. Menotti and Pelissetto was added by
DOI. The local keys are recorded in `Sources/Null_Edge_References.md`.

A second, gap-driven pass tested the remaining F2/P8/P9 obligations against
recent primary literature. Five further papers were added and full-text
chunked, and two already-keyed 2025-2026 papers were read end to end. This pass
searched specifically for distributional Einstein convergence, weak Cartan
curvature, DEC/FEEC operator convergence, simplicial Holst actions, practical
manifoldlikeness tests, and noncompact Lorentz gauge fixing.

A third pass searched the older Regge evolution and consistency literature.
It added six papers to Zotero collection `9W59V3K9`: both null-strut papers,
Miller's local-versus-averaged residual study, Brewin's pointwise-residual
critique, Brewin and Gentle's oscillatory-error reconciliation, and Brewin's
discrete exterior derivative. This pass
corrects the evolution-priority claim and sharpens the first convergence norm
to test.

## Closest prior art

| Source | What it establishes | What it does not establish | Consequence for this repo |
|---|---|---|---|
| Schaden, [Causal Space-Times on a Null Lattice](https://arxiv.org/abs/1509.03095) | A causal null lattice with local `SL(2,C)`, null frame data, link transport, and lattice actions reducing on smooth fields to Hilbert-Palatini, cosmological, and topological terms | A rigorous refinement-convergence theorem, a finite jointly stationary curved branch, or a physical linearized graviton count | The broad null-lattice Palatini architecture is imported prior art; novelty must live in exact finite theorems and stronger reconstruction gates |
| Kur and Glasser, [Discrete Gravity with Local Lorentz Invariance](https://arxiv.org/abs/2202.02486) | A tetradic Palatini discretization with exact local Lorentz invariance and independent tetrad and Lorentz-link equations; leading small-cell equations match continuum Einstein and torsion equations | Numerical convergence, stability, or a graph-derived null carrier | This is the nearest action and Euler-equation precedent and should remain the main discretization comparator |
| Gionti, [Discrete Gravity as a Local Theory of the Poincare Group](https://arxiv.org/abs/gr-qc/0501082) | A first-order discrete Poincare theory; in the small-deficit regime the Levi-Civita-Regge connection is a locally unique solution | Global uniqueness, Lorentzian null-carrier applicability, or a refinement theorem | The realistic Levi-Civita gate is local uniqueness near a nondegenerate background via a Jacobian/inverse-function argument |
| Dittrich and Hoehn, [From Covariant to Canonical Formulations of Discrete Gravity](https://arxiv.org/abs/0912.1817) | On flat backgrounds, the linearized Regge Hessian has exact gauge degeneracies tied to vertex displacement and linearized Bianchi identities; nonlinear orders generally turn these into pseudo-constraints | Exact nonlinear diffeomorphism symmetry on a generic lattice | The coupled null-edge Hessian must classify gauge directions, and nonlinear continuation is a separate gate |
| Hoehn, [Canonical Linearized Regge Calculus](https://arxiv.org/abs/1411.5672) | A canonical count of gauge-invariant curvature degrees of freedom after separating vertex-displacement gauge modes | Identification of those lattice modes with continuum gravitons without further analysis | Curvature-image rank two before quotient is evidence, not a two-polarization theorem |
| Neiman, [Causal Cells](https://arxiv.org/abs/1212.2916) | A regular tetrahedral null-ray lattice and detailed null-faced polytope geometry | A working curved-spacetime dynamics | Flat null-faced polyhedra cannot encode generic Ricci focusing; use variable decorated light-ray directions and affine spacings, not literal rigid null-faced cells |
| Wieland, [Discrete Gravity as a Topological Gauge Theory with Light-Like Curvature Defects](https://arxiv.org/abs/1611.02784) | Exact lightlike curvature defects and impulsive gravitational-wave solutions in a local Lorentz/spinor boundary theory | Local bulk degrees of freedom; the theory is topological in each cell and on three-dimensional interfaces | Our finite wave is not the first null discrete gravitational-wave construction; the new obligation is to show non-topological propagating modes |
| Christiansen, [Exact Formulas for the Approximation of Connections and Curvature](https://arxiv.org/abs/1307.3376) | Exact holonomy-curvature formulas and a rigorous measure-limit justification of Regge scalar curvature for canonical smoothing | Convergence of the null-edge Palatini action or its Euler equations | Provides the mathematical template for the holonomy-curvature convergence gate, but not its solution |
| Foster and Jacobson, [Propagating Spinors on a Tetrahedral Spacetime Lattice](https://arxiv.org/abs/hep-th/0310166) | A tetrahedral hyperdiamond Weyl propagator, bend amplitudes, a continuum limit, and a no-doubling result for its retarded scheme | A gravity theory; its links are not null in the convergent construction, while its faces are null | "Null edges" and "null faces" cannot be conflated; Courant stability and determinant-level doubling remain mandatory audits |
| Menotti and Pelissetto, [Poincare, de Sitter, and Conformal Gravity on the Lattice](https://doi.org/10.1103/PhysRevD.35.1194) | An early gauge-theoretic lattice gravity with link variables, vierbeins, reflection positivity, and a reported graviton-doubling phenomenon | A Lorentzian null lattice or the present action | Graviton doubling is old and must be tested explicitly in any translationally invariant wave sector |
| Dupuis, Girelli, Hrytseniak, and Wieland, [Topological Field Theory Plus Local Lorentz Symmetry Is Gravity](https://arxiv.org/abs/2603.12100) | A 2026 continuum formulation using Weyl-spinor-valued one-forms encoding frame data, with gravity arising when `SL(2,C)` is localized | A discrete implementation or continuum limit from a graph | A modern spinorial frame/connection comparator; it does not replace the finite Palatini program |

### Null-strut evolution precedent

Kheyfets, LaFave, and Miller's two-part 1990 construction is the clearest
pre-Schaden precedent for null-link **evolution**. Part I develops a 3+1 Regge
kinematics in which spacelike three-geometries are connected by momentumlike
layers made entirely of null struts. Part II derives the corresponding Regge
geometrodynamic evolution algorithm. The construction does not use the repo's
spinorial null-frame soldering, local `SL(2,C)` face action, independent
Palatini coframe/connection variables, or operator-first metric. Therefore:

- the broad claim that null edges can carry discrete time evolution is
  `[import]`, not a new result of this program;
- null-strut initial-value and boundary bookkeeping should be mined for the
  eventual graph-refinement construction;
- the repo's defensible contribution remains the exact finite
  spinor/coframe/holonomy/Palatini chain and its kernel-checked gates.

Primary sources: Kheyfets, LaFave, and Miller,
[Null-Strut Calculus I: Kinematics](https://doi.org/10.1103/PhysRevD.41.3628)
and
[Null-Strut Calculus II: Dynamics](https://doi.org/10.1103/PhysRevD.41.3637).

### Residual convergence is a weak or averaged question

The older Regge consistency literature gives a direct warning for the current
weak-Einstein endpoint. Miller found that individual Regge equations evaluated
on continuum metrics vanish at second order, while suitable local averages
vanish at least at third order and numerically at fourth order on tested exact
solutions. Brewin showed that generic pointwise residuals may fail to
distinguish Einstein from non-Einstein metrics. Brewin and Gentle then exhibited
second-order convergent simplicial Kasner solutions despite nonconvergent
continuum-sampled residuals, explained by oscillatory error. Thus the first
continuum gate should not be pointwise residual decay. It should be a
volume-weighted weak pairing or an equivalent averaged residual, followed
separately by stability or compactness of stationary fields.

Brewin's earlier exterior differentiation supplies a compatible discrete-form
template: Stokes' theorem and `d^2 = 0` hold on the piecewise-continuous Regge
complex, and its Stokes formula tends to the smooth one under refinement. This
supports keeping the connection equation in a cochain/exterior-calculus form
through the convergence proof.

Primary sources: Miller,
[Regge Calculus as a Fourth Order Method in Numerical Relativity](https://arxiv.org/abs/gr-qc/9502044);
Brewin,
[Is the Regge Calculus a Consistent Approximation to General Relativity?](https://arxiv.org/abs/gr-qc/9502043);
Brewin and Gentle,
[On the Convergence of Regge Calculus to General Relativity](https://arxiv.org/abs/gr-qc/0006017);
and Brewin,
[Exterior Differentiation in the Regge Calculus](https://doi.org/10.1063/1.527332).

## Gap-driven second pass

The second pass found a concrete analytic route for refinement and a useful
empirical route for carrier selection. It did not locate a paper that closes
the Lorentzian null-edge Palatini program.

| Source | Theorem-level result | Scope boundary | Action for this repo |
|---|---|---|---|
| Gawlik and Neunteufel, [Finite Element Approximation of the Einstein Tensor](https://arxiv.org/abs/2310.18802) | For optimal-order degree-`r` Regge interpolants of a smooth Riemannian metric, the distributional densitized Einstein tensor converges in `H^-2` at rate `O(h^(r+1))` under the displayed mesh and regularity hypotheses | Riemannian metric variables, not Lorentzian tetrad/connection variables; convergence of interpolated curvature, not of stationary fields or Euler equations | Make a weak test-tensor pairing the first continuum Einstein target. Prove null-edge curvature convergence in a negative Sobolev or distributional norm before seeking pointwise equations |
| Gawlik and Neunteufel, [Finite Element Approximation of Scalar Curvature](https://arxiv.org/abs/2301.02159) | Defines distributional densitized scalar curvature for Regge metrics, proves the corresponding `H^-2` convergence rate, and identifies its boundaryless first variation with the distributional densitized Einstein tensor | The same Riemannian and interpolation restrictions apply | Use its action-variation identity as the model for a commuting square: finite action variation, weak Einstein response, and refinement |
| Gawlik and McKee, [On the Curvature of Regge Metrics](https://arxiv.org/abs/2510.25027) | Constructs a measure-valued curvature from moving frames that satisfies weak Cartan structure equations and the appropriate frame-gauge transformation law, and proves equivalence with existing densitized distributional curvature | Piecewise-smooth Riemannian Regge metrics; no null carrier or independent Lorentzian Palatini dynamics | Provides the direct template for P8(b): define the null-edge connection and curvature as weak objects, then prove gauge covariance and agreement with the coframe-side Einstein tensor |
| Beltran and Zapata, [A Discretization of Holst's Action for General Relativity](https://arxiv.org/abs/2208.13808) | On a compact oriented four-manifold with a uniformly refining, shape-regular simplicial sequence, the action sampled from a continuous tetrad and a `C^1` Lorentz connection converges to the Holst action; the paper also derives finite field equations | Action consistency does not prove convergence of the discrete field equations or of discrete stationary solutions; the matter examples are sketches | A stronger action-limit comparator than was previously recorded. Borrow its explicit refinement hypotheses and atom-local matter organization, but retain the variation-limit and stability gates |
| Guzman and Potu, [DEC Approximations via Generalized Whitney Forms](https://arxiv.org/abs/2505.08934), and Dabetic and Hiptmair, [DEC for the Hodge-Dirac Operator](https://arxiv.org/abs/2507.19405) | Identify primal/dual cochains with Whitney/generalized Whitney forms and prove convergence estimates for Hodge-Laplacian and Hodge-Dirac boundary-value problems on suitable mesh families | Bounded Euclidean domains, de Rham Hodge-Dirac rather than the spinorial Lorentzian Dirac operator, and strong well-centered/shape-regular/topological hypotheses | Useful analytic infrastructure for cochain maps, adjoints, stability, and error norms. It does not justify calling the current soldered Dirac operator convergent |
| Eichhorn, Mack, Le, and Wagner, [Charting Causal Set Configuration Space with Graph Observables](https://arxiv.org/abs/2605.27514) | In large ensembles from nine tested classes, link-degree distributions, symmetrized-Hasse graph-Laplacian spectra, and causal-interval abundances distinguish manifoldlike, nonmanifoldlike, and candidate coarse-grainable classes with relatively small fluctuations | Primarily finite, mostly two-dimensional, size-2048 ensemble evidence; no universal single-causet classifier, coarse-graining map, or dynamical selection theorem | Add an F2 screening layer before expensive reconstruction: compute these three label-invariant observables on candidate carriers and pre-register acceptance regions against sprinkled controls |

The noncompact-gauge search did not locate a discrete-gravity theorem stronger
than Schaden's conditional `SL(2,C)/SU(2)` boost slice for this purpose.
Canonical time-gauge and unrelated noncompact Abelian lattice results do not
solve the null-frame measure problem. The boost-slice Jacobian, residual
`SU(2)` stabilizer, and Faddeev-Popov factor therefore remain source-audit and
formalization obligations rather than imported facts.

### Revised bridge architecture

The new convergence sources suggest splitting the final continuum gate into a
sequence that can fail honestly at each interface:

```text
finite null-edge action and Euler identities
  -> uniformly controlled refinement family
  -> weak Cartan connection/curvature with gauge covariance
  -> distributional densitized Einstein tensor convergence
  -> convergence or compactness of stationary fields
  -> Lorentzian Einstein equations for the limit
```

The first four arrows are now supported by close mathematical templates. The
last two remain genuinely open for this program.

## Schaden deep read

The initial audit correctly identified Schaden as the closest architectural
prior art, but that one-line classification hides several distinctions that
matter for this program. This section records a full-source read of arXiv v2
and a comparison with the shorter LATTICE 2014 proceedings version.

### 1. The carrier is supplied, not reconstructed

Schaden starts with a four-dimensional topologically hypercubic lattice of
fixed coordination eight: four future and four past neighbors at every event.
The GPS principle motivates the construction: four forward light cones from a
spatial tetrahedron meet at a later event. Spatial slices inherit a
tetrahedral-octahedral triangulation. Cell shapes and sizes vary, but dimension,
coordination, foliation, and the intended manifold topology are inputs.

This is therefore a **manifold-conditioned null-carrier theory**, not a
dynamical derivation of four-dimensional manifoldlike order. It is useful prior
art for F1 admissibility and F5 decorated geometry, but it does not solve F1-F3
selection or reconstruction from a bare causal order.

### 2. A null lat-frame has exactly the spinor-area geometry we use

At each site, the four future displacements are anti-Hermitian rank-one
matrices

```text
E_mu = i xi_mu xi_mu^dagger,
```

with bosonic two-component spinors `xi_mu`. They transform as
`E_mu -> g E_mu g^dagger` under local `SL(2,C)` and are invariant under four
independent spinor phases. The antisymmetric spinor products

```text
f_mu_nu = xi_mu^T epsilon xi_nu
```

satisfy

```text
ell_mu_nu^2 = -2 E_mu . E_nu = |f_mu_nu|^2.
```

Thus four null rays modulo local Lorentz transformations and spinor phases
carry six real geometric degrees of freedom, represented by the six spatial
edge lengths of the illuminated tetrahedron. Because four spinors live in a
two-dimensional complex spin space, the antisymmetric `4 x 4` matrix `f` has
rank at most two and zero Pfaffian. The resulting three products
`ell_12 ell_34`, `ell_13 ell_24`, and `ell_14 ell_23` obey triangle inequalities,
equivalently the Gram determinant has the sign required for a real four-volume.

This is not merely analogous to the repo's area construction. It is the same
Pluecker/Pfaffian mechanism in a gravitational null-frame role. The distinction
is interpretive: Schaden uses `|f_mu_nu|` as an edge length and proper-time
increment, while the mass program uses the same wedge magnitude in a finite
Dirac-corner channel.

### 3. Proper time is an aggregate of two null directions

Every path made only of elementary null links has zero proper time. Schaden
adds the center event of a plaquette spanned by two distinct null directions.
The timelike increment across that centered plaquette is

```text
Delta s_mu_nu = |f_mu_nu| = ell_mu_nu.
```

The proper time of a causal path is the sum of these centered-plaquette
increments, and the timelike geodesic distance between two causally related
events is the maximum proper time over causal paths.

This gives a precise finite realization of the statement that a single null
direction carries no proper time, while combining distinct null directions
does. It strongly supports the null-edge kinematics behind the user's
"direction change creates proper time" intuition. It does **not** derive mass:
the paper supplies no Dirac operator, mass gap, Higgs mechanism, or theorem
identifying this path functional with inertial mass.

### 4. Manifold consistency is an explicit extra gate

Local future null frames are not enough to glue a causal manifold. The six
lengths assigned to the backward light cone of each event must agree with
shifted forward-frame lengths and must themselves satisfy the same volume
triangle inequalities. Schaden gives an explicit reconstruction of the four
backward null rays from these six lengths, unique up to local Lorentz
transformations and orientation.

The paper then constructs a topological lattice theory whose partition factor
is the product of Heaviside functions enforcing the backward-volume
inequalities. This is a useful concrete model of an **admissibility projector**:
apparently nonlocal gluing conditions can be represented with local auxiliary
fields and BRST machinery. It still restricts the ensemble to causal
manifolds; it does not show that a broader null-order ensemble dynamically
concentrates on them.

### 5. The connection convention is not our plaquette convention

The full arXiv v2 assigns a reversed link the Hermitian conjugate transport,

```text
U[n,n'] = U[n',n]^dagger,
```

rather than the inverse. Since `SL(2,C)` is nonunitary, the paper explicitly
notes that this removes ordinary closed Wilson loops from the basic invariant
algebra. Its curvature term compares spinor-bookended transport along the two
orders around a plaquette; it is not the same object as the repo's group
holonomy with inverse orientation `H_ba = H_ab^(-1)`.

There is also source-version drift. The shorter LATTICE 2014 proceedings paper
uses inverse reversal and ordinary Wilson loops, whereas arXiv v2 switches to
Hermitian conjugation. Any imported action formula must therefore name the
version and convention. The current null-edge Palatini action should not be
described as Schaden's action formalized in Lean.

The v2 paper states that its local invariants reduce on smooth configurations
to Hilbert-Palatini, cosmological, and topological terms. It constructs the
intended finite densities, but it does not provide the quantitative refinement
estimates, stationary-field compactness, or variation-limit interchange needed
for a convergence theorem.

### 6. The gauge slice and measure are useful, but conditional

Because local `SL(2,C)` is noncompact, the finite-lattice generating function
contains an infinite gauge volume. Schaden minimizes a local Morse function on
`SL(2,C)/SU(2)`. Its Hessian is positive for a nondegenerate null frame, giving
a unique boost gauge modulo spatial rotations. This is a concrete model for
the gauge slice required by our nonlinear implicit-function and local
Levi-Civita programs.

After localization, the invariant spinor measure can be expressed through the
six lengths as

```text
product_(mu<nu) d ell_mu_nu^2 * V^(gamma-1) * Upsilon,
```

where `Upsilon` imposes the volume triangle inequalities. The small-volume
density `rho(V) ~ V^gamma` is an assumed invariant regulator, not a consequence
of the Palatini action. The reported simulations retain only the cosmological
term, use a purely imaginary cosmological coupling, and reach depth at most
seven. They are evidence that this unphysical strong-coupling truncation may be
finite, not evidence for a curved Einstein phase.

### 7. What the paper leaves open

Schaden does not derive or test:

1. the finite connection and coframe Euler equations of the displayed action;
2. torsion-free or Levi-Civita selection;
3. a jointly stationary nonflat configuration;
4. a graviton gauge quotient, propagation law, or no-doubling result;
5. convergence of stationary refinements to Einstein's equation;
6. dynamical selection of dimension, coordination, topology, or manifoldlikeness;
7. a mass, Higgs, or Standard Model mechanism.

Its "duoverse" and dark-matter discussion is speculative and is not needed by
the null-edge GR derivation.

### 8. Concrete imports for this repo

The productive response is neither to ignore Schaden nor to replace the
current action with his. Five narrow imports are worth pursuing:

1. **Null-frame admissibility (partially landed):**
   `SchadenNullFrameAdmissibility` kernel-checks the four-spinor Pfaffian,
   all three opposite-length triangle inequalities, the hollow
   squared-length determinant criterion, and
   `det(lengthSq) = -16 det(coframe)^2` in project conventions. Constructive
   backward-spinor reconstruction from arbitrary admissible six-length data
   remains open.
2. **Proper-time bridge (landed):**
   `SchadenProperTimeBridge.centeredPlaquetteProperTime_eq_norm_wedge`
   kernel-checks `Delta s = |f_mu_nu|`; its companion dictionary theorem
   identifies the square with the existing Pluecker mass scalar without
   claiming that elapsed time dynamically generates mass.
3. **Manifold projector (interface landed):** the same module assembles six
   backward lengths from commuting two-step predecessor sites and exposes the
   exact positivity-plus-determinant predicate. Deriving or dynamically
   enforcing that predicate, and manifold selection itself, remain open.
4. **Boost gauge slice:** adapt the positive-Hessian `SL(2,C)/SU(2)` Morse
   slice to the repo's nondegenerate null frames and use it in the local
   connection-selection and nonlinear-continuation Jacobians.
5. **Action comparison:** expand Schaden's v2 routed-transport density and the
   repo's inverse-holonomy Palatini density around the same smooth background,
   then prove where they agree and where the reversal convention changes the
   finite theory.

The implementation order is now: prove constructive backward-frame
reconstruction and connect the admissibility predicate to carrier dynamics,
formalize the boost slice, and then perform the action comparison. The last
item is the remaining source-audit debt. Until that comparison is done, the
defensible statement is that Schaden establishes the broad null-lattice
Palatini architecture and several valuable kinematic interfaces, not that it
already contains our finite action or our derived Einstein-response chain.

## Detailed program corrections

### 1. The action architecture is prior art

The combination

```text
null causal carrier
  + independent coframe or null-frame data
  + local Lorentz or SL(2,C) link transport
  + face holonomy
  + Hilbert-Palatini smooth limit
```

must be graded `[import]` at the architectural level. Schaden is particularly
close. Kur and Glasser independently pin the permutation and complementary-face
structure used by the current finite action.

This does not erase the value of the Lean development. Exact finite Euler
coefficients, convention bridges, no-go theorems, and complete response-kernel
classifications are stronger and differently scoped claims than proposing the
architecture.

### 2. Rigid null-faced cells are the wrong curved object

Neiman identifies a structural obstruction. A null hypersurface tiled by flat
null polyhedra has a fixed-area condition that cannot represent generic
Raychaudhuri focusing and hence generic Ricci curvature. The promising route is
a light-ray-threaded carrier whose ray cross-ratios, affine spacings, and local
connectivity may vary.

This supports the repo's separation between:

- primitive null support in the carrier;
- gauge-relative coframe/soldering decorations;
- independent Lorentz transport;
- curvature reconstructed from transport defects.

It argues against treating the finite cells themselves as exact flat null
polyhedra in a curved tessellation.

### 3. Two curvature modes are not yet two gravitons

The exact-rational backreaction oracle currently reports:

```text
joint Hessian: 80 x 80
rank: 52
kernel dimension: 28
curvature-image rank on the joint kernel: 2
```

Hoehn and Dittrich show why the last number is not by itself a physical mode
count. A valid claim needs:

1. an explicit infinitesimal local-Lorentz and vertex/discrete-diffeomorphism
   gauge action on link and coframe perturbations;
2. proof that those gauge directions lie in the Hessian kernel;
3. the linearized Bianchi/Noether identities responsible for the degeneracy;
4. a quotient of the joint kernel by gauge and constraint directions;
5. a propagation or dispersion theorem for the remaining curvature classes;
6. a no-doubling audit across the full discrete momentum zone.

Only after these steps may a two-dimensional quotient be compared with the two
continuum tensor polarizations.

### 4. Nonlinear continuation is an independent gate

Linearized Regge calculus has exact gauge symmetry on flat backgrounds even
when nonlinear discrete gravity does not. At higher order, background gauge
parameters can be selected by consistency equations and constraints become
pseudo-constraints. The current coupled Hessian therefore cannot be promoted
directly to a nonlinear curved branch.

The next nonlinear target should be an implicit-function theorem around a
gauge-fixed nondegenerate linear mode, with an explicit obstruction projection
onto the cokernel. Failure is informative: it would identify which linear
curvature modes are lattice artifacts or obstructed at second order.

### 5. Levi-Civita selection should be local first

The fixed forward-Christoffel candidate already fails the repo's finite
connection equation. That is not evidence against first-order gravity; it is
evidence that the connection must be selected by the actual link equations.

Gionti suggests the right first theorem:

> Near a nondegenerate flat or small-curvature background, after gauge fixing,
> the connection Euler map has an invertible Jacobian in the transverse
> directions, so a unique local Levi-Civita-like branch exists.

Global uniqueness can remain open. This theorem would be both achievable and
physically meaningful.

### 6. Continuum consistency is not convergence

Kur and Glasser derive the correct leading small-cell continuum equations.
Schaden derives the correct smooth-field action limit. These are consistency
checks. A full convergence result additionally needs:

- a specified refinement family and shape regularity;
- first-order control of link holonomy by a smooth connection;
- coframe and dual-cell measure convergence;
- consistency of the discrete adjoint/divergence;
- compactness or stability of stationary fields;
- control of boundary terms;
- justification for interchanging variation and refinement limit.

Christiansen provides rigorous holonomy/curvature and Regge-measure techniques
that can seed this gate, but no located source closes it for Lorentzian
tetradic Palatini gravity on a null carrier.

The second search substantially sharpens this gate. Gawlik and Neunteufel show
that distributional densitized scalar and Einstein curvature can converge at a
controlled rate in `H^-2`; Gawlik and McKee supply the compatible weak Cartan
and gauge-covariant curvature side; Beltran and Zapata prove convergence of a
sampled tetrad/connection action on uniformly refining simplicial families.
Together these results support a weak-curvature commuting-square strategy.
They still do not justify interchanging variation and refinement or passing
from sampled smooth fields to convergent discrete stationary solutions.

## Linearization-instability comparison

The two-site nonlinear-continuation audit lands in a classical GR problem
class. Brill and Deser showed that closed backgrounds can admit solutions of
the linearized Einstein equations that fail a quadratic second-order
constraint. Fischer and Marsden defined linearization stability precisely by
whether linearized solutions are tangent to curves of exact solutions.
Moncrief related the nonlinear constraints on compact Cauchy backgrounds with
Killing symmetries to conserved, hypersurface-independent integrals.

The finite null-edge result has the same algebraic shape. The summed
time-time coframe Euler row annihilates the linear Hessian image, while its
quadratic value on the complete curved sector is
`-8 * (p^2 + c^2)`. This is strong evidence for a discrete Taub-charge
analogue and explains why adding arbitrary local second-order link corrections
cannot repair the two-site wave. It is not yet an identification theorem: the
repo has not derived a compact Cauchy hypersurface, a Killing field, the ADM
constraint map, or convergence of the finite charge to Moncrief's integral.
The safe claim is therefore **finite second-order linearization obstruction**.

## Revised originality matrix

| Candidate claim | Revised grade | Reason |
|---|---|---|
| A null lattice can carry local `SL(2,C)` gravity data | `T [import]` | Schaden |
| A discrete tetradic Palatini action can preserve local Lorentz invariance | `T [import]` | Kur and Glasser; older gauge-lattice work |
| The current complementary-face sign architecture is novel | `T [import]` at architecture level | Kur and Glasser give the same four-form permutation logic |
| The repo has an exact kernel-checked finite Palatini-to-Einstein response chain | `M [orig/comp]` | The exact Lean composition and convention audit remain local contributions |
| The proper-Lorentz two-site wave is the first discrete null gravitational wave | Rejected | Wieland has exact lightlike curvature defects and impulsive Einstein waves |
| The proper-Lorentz two-site wave is an exact finite witness for this specific action and convention set | `M [orig]`, subject to external priority audit | Narrow statement supported by the current repo search |
| Fixed wave links admit no invertible jointly stationary coframe | `M [orig]`, subject to external priority audit | Exact complete finite no-go; no close prior theorem located |
| Curvature-image rank two proves two graviton polarizations | Rejected | Gauge quotient, propagation, and doubling are unproved |
| Coupled backreaction has exactly a two-dimensional nonflat stationary curvature image | `M [orig]`, subject to external priority audit | Lean checks all 80 concrete-action Hessian rows and exact curvature-residual certificates, then proves equality with an injective plus/cross range; it is not yet physically quotiented or propagated |
| The two-site curved linearized sector continues to a nearby nonlinear stationary branch | Rejected on the formal second-order exponential jet | The integrated time-time Hessian functional kills every second-order correction but leaves the exact charge `-8(p^2+c^2)` |
| The finite integrated charge is the continuum Taub charge | Open comparison | Its left-kernel and quadratic-obstruction shape matches classical linearization instability, but no refinement or analytic identification theorem is proved |

## Revised theorem order

1. **Kernelize the coupled curvature image.** Completed: all linearized link
   and coframe rows, explicit plus/cross solutions, and the exact image upper
   bound are checked in Lean. The total Hessian rank/nullity remains oracle
   evidence.
2. **Complete the gauge classification.** The injective 12-parameter local
   Lorentz family is flat and no plus/cross combination is gauge; carrier-vertex
   transformations, Hessian nullity, and the full discrete Noether identities
   remain to be identified.
3. **Establish physical propagation.** The finite stationary curvature image is
   exactly rank two, but a physical polarization claim still requires a
   gauge-complete quotient, a larger/refining carrier, and a propagation and
   no-doubling theorem.
4. **Audit propagation and doubling.** Introduce a momentum family large
   enough to distinguish propagation from a two-site standing pattern and scan
   the full Brillouin zone.
5. **Prove local connection selection.** Use a gauge-fixed Jacobian theorem in
   the Gionti small-curvature style.
6. **Test nonlinear continuation.** Completed negatively on the two-site
   periodic carrier: the full curved image has formal second-order charge
   `-8(p^2+c^2)`, independent of every second-order link correction. Do not
   apply an implicit-function argument there. Repeat only after changing the
   global problem through a larger/open carrier, boundary flux, background
   evolution, matter, or modified weights.
7. **Build a weak-curvature commuting square.** On one uniformly controlled
   refinement family, prove gauge-covariant weak Cartan curvature, convergence
   of the densitized Einstein response against test tensors, and agreement
   with the refined finite action variation.
8. **Add stability and variation-limit interchange.** Only after step 7, prove
   compactness or stability for stationary fields, boundary control, and the
   passage from discrete Euler equations to the Lorentzian continuum equation.

## Kill conditions

- If the two curvature classes vanish after the correct gauge/constraint
  quotient, the polarization claim is killed.
- If extra zero-frequency modes occur elsewhere in the momentum zone, the
  proposed wave regulator has graviton doublers.
- If the gauge-fixed connection Jacobian is singular beyond expected gauge
  directions on every nondegenerate background tested, the local
  Levi-Civita-selection route is killed for this action.
- The second-order consistency kill condition is triggered on the two-site
  periodic carrier: every nonzero plus/cross combination projects onto the
  integrated time-time Hessian cokernel functional. The formal linear wave
  does not continue there without changing the global problem.
- If refinement requires rigid flat null-faced cells, Neiman's focusing
  obstruction kills generic Ricci recovery; the carrier must be generalized.

## Bottom line

The literature does not supply the completed theory, but it makes the remaining
work much sharper. The null-edge program should no longer spend effort proving
that a Lorentz-covariant discrete Palatini architecture can be written. It
should prove what the literature leaves open and what the repo is now uniquely
positioned to test exactly:

```text
physical gauge-reduced wave modes
  -> larger/open-carrier propagation and second-order charge cancellation
  -> nonlinear jointly stationary branch on the repaired global problem
  -> local Levi-Civita selection
  -> controlled null-carrier refinement
  -> continuum Einstein dynamics
```

That is a smaller program than "derive GR from null edges," but it is also a
far more credible one.
