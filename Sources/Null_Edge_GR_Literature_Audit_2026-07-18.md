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
