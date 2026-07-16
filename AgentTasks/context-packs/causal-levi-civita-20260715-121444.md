# Aristotle semantic context pack

Generated: 2026-07-15T12:15:09
Query: `causal operator recovered metric first jet Levi-Civita Christoffel torsion free metric compatibility`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [12.2 Levi-Civita geometry and transport]

Score: `0.811`

```text
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
```

### 2. `AgentTasks/model-calls/claude/2026-07-06-220107-fable-call-02.md` [CRACK 2 - the E-slot]

Score: `0.811`

```text
vity argument as `mZero_iff_commute`). That is the **discrete tetrad postulate / metric compatibility**: the frame is covariantly constant. `E` is then honestly the discrete spin-connection-defect (torsion/nonmetricity) term of the generalized Lichnerowicz formula (hep-th/9503153), realized on the lattice. Grade the iff [CONJECTURAL] pending the `mZero`-style cancellation; the "if" direction is trivial.
```

### 3. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.4 Selected operator-first metric architecture]

Score: `0.799`

```text
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

At finite density, arbitrary functions on the event set are too numerous and
too noisy to serve as cotangent
```

### 4. `Sources/NullStrand_Open_Questions_For_Frontier_Models.md` [Frame compatibility tests]

Score: `0.797`

```text
#### Frame compatibility tests

The frame term should be treated as a discrete tetrad-postulate defect:

```text
T_frame = sum_a,b C_a [nabla_a, C_b] nabla_b.
```

The clean finite tetrad postulate is

```text
[nabla_a, C_b] = 0 for all a,b,
```

or, with explicit spin transport and label rotation, a covariance condition of
the form

```text
U_a C_b(target) U_a^{-1} = sum_c R_ab^c C_c(source).
```

Recommended finite tests:

```text
frameTermVanishesUnderTetradPostulate;
metricCompatibilityFromCliffordAnticommutator;
curvatureIsCommutatorOfCompatibleConnection.
```

The metric-compatibility proxy is

```text
nabla_a {C_b, C_c} = 0.
```

If this fails, the defect is not merely curvature; it indicates nonmetricity or
inconsistent soldering. If metric compatibility holds and `[nabla_a,nabla_b]` is
nonzero, the remaining defect belongs in curvature/holonomy.
```

### 5. `PhysicsSM/Draft/NullEdge/GravityUnificationCapstone.lean` [gravity_unification_capstone]

Score: `0.786`

```text
.D 2 0 0 0 ^ 4).trace = 60 ∧
        (60 : ℚ) ≠ 0) ∧
      (SpectralActionAvatar.D 3 1 3 5 ^ 2).trace ≠ (SpectralActionAvatar.D 2 1 3 5 ^ 2).trace ∧
      (SpectralActionAvatar.D 2 7 8 9 ^ 2).trace = (SpectralActionAvatar.D 2 1 3 5 ^ 2).trace ∧
      (SpectralActionAvatar.D 2 1 3 6 ^ 4).trace ≠ (SpectralActionAvatar.D 2 1 3 5 ^ 4).trace) ∧
    -- (10) order-2 curvature / Einstein–Hilbert avatar
    ((∀ E : ℚ, Matrix.trace (EinsteinHilbertTerm.D E * EinsteinHilbertTerm.D E) =
          Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dkin) + EinsteinHilbertTerm.Rfin E) ∧
      (∀ E : ℚ, EinsteinHilbertTerm.Rfin E = 4 * E + 2 * E ^ 2) ∧
      HasDerivAt (fun x : ℚ => Matrix.trace (EinsteinHilbertTerm.D x * EinsteinHilbertTerm.D x)) 0
        EinsteinHilbertTerm.Estar ∧
      EinsteinHilbertTerm.Estar =
        -Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dsold) /
          Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold) ∧
      0 < Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold)) ∧
    -- (11) teleparallel E-slot torsion/nonmetricity split
    (TeleparallelSoldering.curvatureLoop = 1 ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
      (∀ g : TeleparallelSoldering.M,
        g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
      (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
        TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
      TeleparallelSoldering.torsion Tele
```

### 6. `PhysicsSM/Draft/NullEdge/LambdaGravityCosmologyBridge.lean` [gravityUnificationStmt]

Score: `0.785`

```text
nHilbertTerm.Rfin E = 4 * E + 2 * E ^ 2) ∧
      HasDerivAt (fun x : ℚ => Matrix.trace (EinsteinHilbertTerm.D x * EinsteinHilbertTerm.D x)) 0
        EinsteinHilbertTerm.Estar ∧
      EinsteinHilbertTerm.Estar =
        -Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dsold) /
          Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold) ∧
      0 < Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold)) ∧
    (TeleparallelSoldering.curvatureLoop = 1 ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
      (∀ g : TeleparallelSoldering.M,
        g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
      (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
        TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
      TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0) ∧
    ((TeleparallelSoldering.curvatureLoop = 1 ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
        (∀ g : TeleparallelSoldering.M,
          g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
        (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
          TeleparallelSoldering.nonmetricity TeleparallelSoldering.g
```

### 7. `AgentTasks/model-calls/claude/2026-07-06-220107-fable-call-02.md` [Response stdout]

Score: `0.784`

```text
d). Then by the exact mechanism of `nabla_commutator_path_difference`:\n\n```\n[nabla_e, gamma_f] = M( U_e · (γ_f ∘ tau_e) - γ_f · U_e ) ∘ T_e\n```\n\n- the **covariant lattice gradient of the soldering**, so `E = 0 iff U_e · (γ_f ∘ tau_e) = γ_f · U_e` for all `e, f` (via the same `gaugeLM`-injectivity + shift-bijectivity argument as `mZero_iff_commute`). That is the **discrete tetrad postulate / metric compatibility**: the frame is covariantly constant. `E` is then honestly the discrete spin-connection-defect (torsion/nonmetricity) term of the generalized Lichnerowicz formula (hep-th/9503153), realized on the lattice. Grade the iff [CONJECTURAL] pending the `mZero`-style cancellation; the \"if\" direction is trivial.\n\n## CRACK 3 - Krein positivity (thrust B)\n\n**Verdict: genuinely obstructed in general; one natural sector exists and is worth banking now.**\n\n- **[ESTABLISHED-shape, provable this run] `positivity_on_flat_sector`**: on `S := ⋂_e ker (nabla_e)` (covariantly constant sections), `D` acts as `Gamma phi`, so `D^#D` acts as `phi^# phi = phi^2`. Statement: for `psi ∈ S`, `⟪D psi, D psi⟫_eta = ⟪phi psi, phi psi⟫_eta` - **the mass form on the flat sector is pure turn**, `eta`-positive iff `phi` preserves an `eta`-positive subspace. Small, exact, and it is the Move-2 hook: flat sector = zero-aperture = collinear lane, mass = turn only. This is the theorem-shaped version of the mass thesis at its most defensible point.\n- **[CRUX] generic invariant sectors**: for indefinite `eta` a `D`-invariant `eta`-positive subspace is exactly what Krein hyperbolicity generically forbids; do not expect a pointwise (site-diagonal) one. Program guardrail applies: Krein self-adjointness is an audit, not positivity.\n- **Probe design [recommended this run, cheap]**: `W = R^2`, `
```

### 8. `PhysicsSM/Draft/NullEdge/GoalIVReconciliationCapstone.lean` [source_equation_route_capstone]

Score: `0.782`

```text
HilbertTerm.D E) =
          Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dkin) + EinsteinHilbertTerm.Rfin E) ∧
      (∀ E : ℚ, EinsteinHilbertTerm.Rfin E = 4 * E + 2 * E ^ 2) ∧
      HasDerivAt (fun x : ℚ => Matrix.trace (EinsteinHilbertTerm.D x * EinsteinHilbertTerm.D x)) 0
        EinsteinHilbertTerm.Estar ∧
      EinsteinHilbertTerm.Estar =
        -Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dsold) /
          Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold) ∧
      0 < Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold)) ∧
    (TeleparallelSoldering.curvatureLoop = 1 ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
      (∀ g : TeleparallelSoldering.M,
        g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
      (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
        TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
      TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0) ∧
    ((TeleparallelSoldering.curvatureLoop = 1 ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
        (∀ g : TeleparallelSoldering.M,
          g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
        (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gPu
```

## Scoped paper hits

### 1. The Scalar Curvature of a Causal Set

Score: `0.746`
Zotero key: `JUVWME9X`
arXiv: `1001.2725`
DOI: `10.1103/PhysRevLett.104.181301`
URL: https://www.zotero.org/19894138/items/JUVWME9X

Abstract:

A one parameter family of retarded linear operators on scalar fields on causal sets is introduced. When the causal set is well-approximated by 4 dimensional Minkowski spacetime, the operators are Lorentz invariant but nonlocal, are parametrised by the scale of the nonlocality and approximate the continuum scalar D'Alembertian, $\Box$, when acting on fields that vary slowly on the nonlocality scale. The same operators can be applied to scalar fields on causal sets which are well-approximated by curved spacetimes in which case they approximate $\Box - {{1/2}}R$ where $R$ is the Ricci scalar curvature. This can used to define an approximately local action functional for causal sets.

### 2. Torsion Degrees of Freedom in the Regge Calculus as Dislocations on the Simplicial Lattice

Score: `0.735`
Zotero key: `IJ2MZ3FH`
arXiv: `gr-qc/0103111`
DOI: `10.1023/A:1013031402382`
URL: http://arxiv.org/abs/gr-qc/0103111

Abstract:

Using the notion of a general conical defect, the Regge Calculus is generalized by allowing for dislocations on the simplicial lattice in addition to the usual disclinations. Since disclinations and dislocations correspond to curvature and torsion singularities, respectively, the method we propose provides a natural way of discretizing gravitational theories with torsion degrees of freedom like the Einstein-Cartan theory. A discrete version of the Einstein-Cartan action is given and field equations are derived, demanding stationarity of the action with respect to the discrete variables of the theory.

### 3. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.730`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 4. Local d'Alembertian for causal sets

Score: `0.730`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`

### 5. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.729`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.
