# Aristotle semantic context pack

Generated: 2026-07-15T18:29:00
Query: `A39 A40 causal mesoscopic algebra strong triple commutator projected weak Gamma2 flat Ricci failure analytic retarded kernel normalization local Alexandrov algebra germ`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.47 Stage A40 kills global projected weak geometry]

Score: `0.828`

```text
core.

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
```

### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.47 Stage A40 kills global projected weak geometry]

Score: `0.821`

```text
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
operator identities or weak geometry: t
```

### 3. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.45 Stage A38 promotes one-operator weak geometry]

Score: `0.803`

```text
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
Pointwise Christoffels remain a valuable gauge
```

### 4. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G2. Operator metric and unique scale reconstruction]

Score: `0.790`

```text
ear charts have exact
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

The next G2 test is therefore a basis-independent mesoscopic function algebra
selected by product, operator, and `Gamma` closure; small double-commutator
multiplication defect; decreasing triple commutator; two-sided support; stable
Lorentz rank; and count-volume agreement. Its projected weak Hessian and
`Gamma2` must first return zero Ricci in both nonlinear flat charts, then
recover convention-locked curved Ricci. Pointwise second jets remain a
cross-check. Only after those cancellations pass may weak/operator curvature
be compared with pointwise connection and area-normalized holonomy curvature
```

### 5. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.45 Stage A38 promotes one-operator weak geometry]

Score: `0.784`

```text
,h)-\Gamma(f,\Box h)-\Gamma(h,\Box f)\right].
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
```

### 6. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.46 Stage A39 kills strong locality on the first algebra candidate]

Score: `0.784`

```text
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
but only one of four high-density samples and f
```

### 7. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.46 Stage A39 kills strong locality on the first algebra candidate]

Score: `0.780`

```text
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
```

### 8. `PhysicsSM/Draft/NullEdge/CommutatorMixedDerivative.lean`

Score: `0.754`

```text
import PhysicsSM.Draft.NullEdge.CommutatorRegulator
import PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge

/-!
# Mixed second derivative of the exact unitary commutator

The exact trigonometric group commutator has identity value and zero complete
first derivative at the origin. Its first nontrivial mixed derivative is the
Lie coefficient `G*A-A*G`. This module makes that analytic statement exact.

Provenance: internal exact regulator construction; all proof bodies were
completed by Aristotle project `2ed756dc-b838-4fa3-8fea-0bffe6a433bc` on
2026-07-11.

## Implementation notes

`M4 = Matrix (Fin 4) (Fin 4) ℂ` carries only its product (topological-module)
```

### 9. `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` [The $3+1$ high-symmetry verdict]

Score: `0.753`

```text
e quadratic
regulator $q(\mathbf k)R$, with $q(\mathbf k)=\sum_j k_j^2$ and an explicit
chirality-odd matrix $R$, vanishes at the Dirac point and has zero complete
Fr\'echet derivative there, yet equals a nonzero chirality-mixing matrix on a
unit-axis fixture.  This is \NewResult{} \Kernel{}.  It proves that higher-order
mixing can preserve the desired first jet; it does not yet make the regulator
an exact finite-range unitary or exclude every unwanted crossing.

The compatible exact-unitary primitive is a four-factor group commutator of
circle phase steps.  Kernel-checked, it is unitary, becomes the identity when
either angle vanishes, gives $+\id$ for commuting involutions and $-\id$ for
anticommuting involutions at a quarter turn, and admits an explicit rational
mixed pair whose result is not any scalar matrix.  Its algebraic Lie
coefficient $GA-AG$ is chirality-odd whenever $A$ is chirality-even and $G$ is
chirality-odd; for the live $(\alpha_1,\beta)$ pair that coefficient is
nonzero and equals its full odd projection.  The complete first Fr\'echet
derivative of the commutator vanishes at the origin, while its mixed second
derivative is exactly $GA-AG$.  These are \NewResult{} \Kernel{}.  The same
exact algebra also proves a sharp negative result.  A common sign flip of either
cosine/sine pair leaves the commutator unchanged because the corresponding
central signs occur twice and cancel.  Hence every integer-frequency phase
commutator, including one with affine phase offsets, takes the same value at
all cubic $0/\pi$ corners as at the origin; every finite product of zero-offset
loops is exactly invisible there.  A single phase step supplies the negative
control and does see the sign flip.  Thus the obstruction belongs to the
doubled commutator architecture, not to
```

### 10. `AgentTasks/24h-publication-run-2026-07-12/ARISTOTLE_B_COMMUTATOR_REGULATOR.md` [Aristotle target: exact commutator regulator]

Score: `0.752`

```text
# Aristotle target: exact commutator regulator

Prove every theorem in the focused package without changing statements. This is
the first construction primitive for the corrected strict-3+1 route: exact
unitarity, identity on either coordinate axis, the anticommuting central-collapse
control, and a genuinely noncentral mixed fixture. Keep the scope at finite
complex matrices. Do not claim that the trigonometric factors have already been
packaged as Laurent matrices or that chirality-oddness is proved here.

```yaml
aristotle:
  project_id: 1b5d1015-a2a1-4f4a-b0da-5ab23a328c94
  task_id: d231e2c6-855d-4671-ab3e-13284c72a398
  target_file: CommutatorRegulator.lean
  expected_module: CommutatorRegulator
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-commutator-regulator-20260711-project
  output_dir: AgentTasks/aristotle-output/1b5d1015-a2a1-4f4a-b0da-5ab23a328c94
  status: landed-with-explicit-statement-correction
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Aristotle closed the target but correctly found the original
`anticommuting_quarterTurn_eq_neg_one` false: it omitted `G * G = 1`. The
intended theorem concerns two involutions, so the promoted module adds that
load-bearing hypothesis and includes a kernel-checked counterexample to the
omitted version. No result is claimed statement-preserving. Direct Lean PASS;
targeted build PASS (8,026 jobs); Lean LSP axiom/source audit PASS for all four
headline declarations with only the standard footprint.
```

## Scoped paper hits

### 1. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.742`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.

### 2. Local d'Alembertian for causal sets

Score: `0.741`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`

### 3. On Noncommutative and semi-Riemannian Geometry

Score: `0.738`
Zotero key: `F877GT5B`
arXiv: `math-ph/0110001`
DOI: `10.48550/arXiv.math-ph/0110001`
URL: https://arxiv.org/abs/math-ph/0110001

Abstract:

Introduces semi-Riemannian spectral triples using Krein spaces and Krein-selfadjoint Dirac operators, with recovery of signature data from spectral data.

### 4. Temporal Lorentzian Spectral Triples

Score: `0.735`
Zotero key: `JKDD4KGC`
arXiv: `1210.6575`
DOI: `10.48550/arXiv.1210.6575`
URL: https://arxiv.org/abs/1210.6575

Abstract:

Introduces temporal Lorentzian spectral triples, corresponding to a 3+1 decomposition and global time structure for noncommutative Lorentzian spaces.

### 5. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.727`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 6. On the definition of spacetimes in Noncommutative Geometry, part II

Score: `0.726`
Zotero key: `RADF3RUP`
arXiv: `1611.07842`
DOI: `10.48550/arXiv.1611.07842`
URL: https://arxiv.org/abs/1611.07842

Abstract:

Defines spectral spacetimes with time-orientation forms, stable causality, finite graph examples, split Dirac structures, and Lorentzian discretized Dirac operators.
