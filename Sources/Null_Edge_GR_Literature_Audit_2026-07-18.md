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
already exists in Kur and Glasser. First-order Regge and Poincare formulations
already provide small-curvature Levi-Civita selection results.

The repo's defensible distinctive contribution is therefore not the broad idea
"GR from null links." It is the exact, convention-locked, kernel-checked finite
chain and its unusually sharp positive and negative results:

1. a concrete proper-Lorentz null-wave curvature witness satisfying the finite
   vacuum coframe equation;
2. the complete rank-six, ten-parameter fixed-link coframe-response kernel;
3. the no-go for every invertible jointly stationary coframe when those wave
   links are held fixed at nonzero area;
4. a coupled link/coframe linearization whose current exact-rational oracle has
   a two-dimensional curvature image.

The fourth item is not yet a two-polarization graviton theorem. Linearized
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
current action with his. Four narrow imports are worth pursuing:

1. **Null-frame admissibility:** kernel-check the Pfaffian, six-length,
   four-volume, and backward-ray reconstruction identities in the repo's
   conventions.
2. **Proper-time bridge:** formalize the centered-plaquette identity
   `Delta s = |f_mu_nu|` and state exactly how it composes with the existing
   null-turn mass dictionary without identifying the two quantities.
3. **Manifold projector:** expose the backward-volume inequalities as an F1
   admissibility interface, while keeping dynamical manifold selection open.
4. **Action comparison:** expand Schaden's v2 routed-transport density and the
   repo's inverse-holonomy Palatini density around the same smooth background,
   then prove where they agree and where the reversal convention changes the
   finite theory.

The last item is the remaining source-audit debt. Until that comparison is
done, the defensible statement is that Schaden establishes the broad
null-lattice Palatini architecture and several valuable kinematic interfaces,
not that it already contains our finite action or our derived Einstein-response
chain.

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
| Coupled backreaction contains a two-dimensional nonflat curvature image | Oracle evidence | Exact rational computation, not yet kernel-checked or physically quotiented |

## Revised theorem order

1. **Kernelize the coupled Hessian.** Prove the linearized link and coframe
   equations and the explicit plus-like and cross-like solutions in Lean.
2. **Classify gauge.** Define infinitesimal local Lorentz and carrier-vertex
   transformations, prove Hessian nullity, and identify the discrete Noether
   identities.
3. **Compute the quotient.** Prove the curvature map has rank two on the
   gauge-reduced stationary space, or revise the claim if it does not.
4. **Audit propagation and doubling.** Introduce a momentum family large
   enough to distinguish propagation from a two-site standing pattern and scan
   the full Brillouin zone.
5. **Prove local connection selection.** Use a gauge-fixed Jacobian theorem in
   the Gionti small-curvature style.
6. **Test nonlinear continuation.** Compute the second-order obstruction and
   apply an implicit-function or Lyapunov-Schmidt reduction where possible.
7. **Build the convergence theorem.** Combine holonomy-curvature estimates,
   coframe/dual-volume convergence, boundary control, and variation-limit
   interchange on one refinement family.

## Kill conditions

- If the two curvature classes vanish after the correct gauge/constraint
  quotient, the polarization claim is killed.
- If extra zero-frequency modes occur elsewhere in the momentum zone, the
  proposed wave regulator has graviton doublers.
- If the gauge-fixed connection Jacobian is singular beyond expected gauge
  directions on every nondegenerate background tested, the local
  Levi-Civita-selection route is killed for this action.
- If second-order consistency projects nontrivially onto the Hessian cokernel
  for both candidate curvature modes, the linear wave does not continue to a
  nearby nonlinear branch.
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
  -> nonlinear jointly stationary branch
  -> local Levi-Civita selection
  -> controlled null-carrier refinement
  -> continuum Einstein dynamics
```

That is a smaller program than "derive GR from null edges," but it is also a
far more credible one.
