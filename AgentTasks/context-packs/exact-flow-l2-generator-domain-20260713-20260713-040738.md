# Aristotle semantic context pack

Generated: 2026-07-13T04:08:05
Query: `strong derivative at zero of the exact Dirac momentum-space unitary multiplier on L2 with unbounded generator domain, using compactly supported or graph-norm states and dominated convergence`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Publication_Portfolio_2026-07-10.md` [Submission gate]

Score: `0.816`

```text
### Submission gate

Define the changing Hilbert spaces, Fourier normalization, `S_a`, `I_a`, and
the limiting generator. Prove strong `L2` convergence for a stated Sobolev
class and identify the multiplier with the position-space Dirac PDE. Variable
`z(x)` is an extension, not a requirement for the first paper. Do not advertise
operator-norm convergence unless it is actually proved.
```

### 2. `AgentTasks/model-calls/claude/2026-07-12-200701-afpl-exact-flow-cell-integral-audit.md` [Momentum Lipschitz bound for the exact 3+1 Dirac flow]

Score: `0.814`

```text
# Momentum Lipschitz bound for the exact 3+1 Dirac flow

This module specializes the sharp Hermitian exponential estimate to the live
four-by-four Dirac symbol. The exact multiplier changes across one physical
momentum cell by at most `3 * |t| * h / 2` in L2 operator norm.

This is the local analytic rung needed by `CONT-MULT-001`. It does not yet sum
the cellwise estimate against an arbitrary L2 field, apply inverse Fourier
transform, or identify a position-space PDE solution.

Provenance: in-project composition of `HermitianExpLipschitz`,
`Compact3Plus1DiracRate`, and `ChangingMomentumCellSampling`, July 12, 2026.
-/

noncomputable section

open Matrix Complex Real
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz

open Compact3Plus1DiracRate
open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling

/-- The difference of two equal-mass Dirac symbols is the symbol of the
momentum difference with zero mass. -/
theorem H_sub_H_eq (kx ky kz qx qy qz m : Real) :
    H kx ky kz m - H qx qy qz m =
      H (kx - qx) (ky - qy) (kz - qz) 0 := by
  unfold H
  push_cast
  module

/-- The Dirac symbol is Lipschitz in the coordinate L1 momentum distance. -/
theorem norm_H_sub_H_le_l1 (kx ky kz qx qy qz m : Real) :
    ‖H kx ky kz m - H qx qy qz m‖ <=
      |kx - qx| + |ky - qy| + |kz - qz| := by
  rw [H_sub_H_eq]
  exact le_trans (norm_H_le_B4 _ _ _ _) (by simp [B4])

/-- The exact Dirac multiplier is sharply Lipschitz in momentum, with no
growth in the absolute momentum window. -/
theorem exactFlow_momentum_lipschitz
    (kx ky kz qx qy qz m t : Real) :
    ‖exactFlow kx ky kz m t - exactFlow qx qy qz m t‖ <=
      |t| * (|kx - qx| + |ky - qy| + |kz - qz|) := by
  refine le_trans
    (by
      simpa [exactFlow] using
```

### 3. `PhysicsSM/Draft/NullEdge/Finite3Plus1FourierBridge.lean` [finiteLocalSymbol_unitary]

Score: `0.813`

```text
theorem finiteLocalSymbol_unitary {L : Nat} [NeZero L]
    (m eps : Real) (k : Position L) :
    SuccessiveAxisDiracWalk.IsUnitary (finiteLocalSymbol m eps k) := by
  unfold finiteLocalSymbol
  exact isUnitary_mul _ _
    (isUnitary_mul _ _
      (isUnitary_mul _ _
        (finiteAxisSymbol_unitary 0 k)
        (finiteAxisSymbol_unitary 1 k))
      (finiteAxisSymbol_unitary 2 k))
    (Local3Plus1RateBridge.massFactor_unitary m eps)

/-- Zero lattice momentum is an exact normalization control. -/
```

### 4. `AgentTasks/overnight-publication-run-2026-07-11/RUN_PLAN.md` [P3. Paper D: changing-lattice continuum theorem]

Score: `0.811`

```text
### P3. Paper D: changing-lattice continuum theorem

Close the bridge from exact finite walks to the position-space Dirac PDE:

- changing Hilbert spaces and exact Fourier normalization;
- explicit sampling and interpolation maps;
- walk-specific product-DFT conjugacy;
- compact/tail decomposition for a stated Sobolev class;
- strong `L2` convergence on compact time intervals;
- identification of the limiting multiplier with the Dirac flow;
- explicit rate where proved, qualitative convergence where not.

Do not claim operator-norm convergence, variable-coefficient convergence, or a
continuum field theory unless those statements actually land.
```

### 5. `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` [Interpretation and open problems]

Score: `0.808`

```text
ompact-support momentum-space $L^2$ limit are closed.  Control
  the changing lattice/continuum Fourier spaces and identify the limiting
  multiplier with the position-space Dirac PDE propagator.  The abstract
  bulk/tail split and vanishing of the ultraviolet tail under measurable
  monotone band exhaustion are now closed for arbitrary $L^2$ data, and the
  per-step symbol estimate now carries the refined form
  $2B_4^2t^2/n\cdot\exp(|t|B_4/n)$, which retains the small-step factor
  that the earlier bound discarded; the remaining frontier is the
  balancing of a growing momentum window against the Sobolev tail,
  composed with the concrete scaled sampling/interpolation isometry.
  Equations \eqref{eq:plancherel3}, \eqref{eq:countablel2},
  \eqref{eq:continuousl2multiplier}, and \eqref{eq:walkcompactl2} close the
  finite, abstract countable, and compact-support multiplier steps, not that
  final physical identification.
  \item \textbf{Remove the lattice partners without losing the derivation.}
  The no-go \eqref{eq:stationarynogo} rules out the naive degree-one
  stationary-amplitude factor with a full Dirac tangent.  The Wilson
  construction \eqref{eq:wilsonsquare} now removes the unwanted corners and
  gives a uniform massive gap for a nearest-neighbor Hamiltonian.  The open
  task is to retain that spectral success in a strictly finite-range,
  exactly unitary discrete-time update.  Test the enlarged
  internal cells, longer Laurent range, and tilted-projector stay-put
  constructions of the kind realized by Gupta and Short
  \cite{GuptaShortDoubling} while preserving the
  Pluecker-derived coin and exact path dictionary; by the corollary above,
  any such stay-put route must quantify what replaces the involutory
  unit-speed tangent.  In $3+1$, remove the three
```

### 6. `AgentTasks/24h-publication-run-2026-07-12/GRAND_STRATEGY8_REPORT.md` [5. One ambitious 6-hour composition]

Score: `0.807`

```text
## 5. One ambitious 6-hour composition

**Paper D physical-space Dirac limit on the compact-support dense core**
(items 2 + 6). Compose, in one guarded chain:

```
ScaledChangingMomentumWalk (uniform live split-vs-Dirac bound, landed)
  → sampleFinite_tendsto_L2                         (T2, new)
  → ChangingMomentumCellIsometry (h^{-3/2} exact isometry, landed)
  → ChangingLatticePDECore.band_approx_tendsto_zero (landed)
  → MeasureTheory.Lp.fourierTransformₗᵢ            (Mathlib)
  → position-space Dirac-flow identification         (new, load-bearing)
```

Deliverable: for compactly-supported Lipschitz complex `L2(R^3)` data on the
`h_N = 1/(N+1)`, cutoff `(N+1)^2`, radius `N+1` schedule, the changing-cell
interpolant of the live scaled `3+1` walk converges in `L2(R^3)` to the
position-space Dirac flow, with the limiting multiplier explicitly identified as
the Dirac propagator (not merely named `exact`). Witness: the explicit retained
`x`-face mode with represented physical momentum `N+1`. Negative control: the
D-R3 kill list (fixed `h`, bounded `N h`, missing normalization, unscaled
symbol). This is ambitious because the final multiplier-to-propagator identity
is the one step the manuscript still lists as open; it is *achievable* in 6 h
only because every upstream rung is already landed and only T2 + the
identification are new. **Kill:** if the identification requires a Sobolev class
strictly stronger than compact-support Lipschitz, publish the compact-support
dense-core PDE theorem and mark arbitrary-`L2` as the residual frontier.
```

### 7. `AgentTasks/overnight-null-information-run-2026-07-10/LEDGER.md` [Entries]

Score: `0.806`

```text
one-point finite-measure control prevents vacuity. This closes the walk-specific compact-support multiplier composition. The remaining continuum obligation is changing-lattice/continuum Fourier identification and matching the limiting multiplier to the position-space Dirac PDE. Updated Paper I, theorem ledger, open-problem ordering, document map, draft-root imports, and the overnight axiom guard; targeted multi-module/guard build PASS.
2026-07-10 12:53 PDT | Codex | Builder/Auditor/Author | Strengthened `CompactSupportL2WalkBridge` from the initial `|t| <= 1` window to EVERY fixed real time: a finite index shift makes the local-step hypothesis eventual, after which the same explicit `O(1/(n+1))` compact-box envelope gives measure-theoretic `L2` convergence. The theorem remains momentum-space and compact-support scoped; it does not silently supply the changing-lattice Fourier identification or the position-space Dirac PDE limit. Paper I and the consolidated axiom guard now cite the arbitrary-fixed-time theorem.
2026-07-10 13:17 PDT | Codex | Builder/Assassin/Registrar | LANDED and guarded `WilsonDiracRegulator`: in the live `3+1` Clifford basis the nearest-neighbor Wilson Hamiltonian has an exact scalar square, a uniform all-momentum gap bounded below by `m^2` for `m >= 0, r >= 0`, and for `m=0, r>0` its energy vanishes iff all three momentum cosines equal one. The `(pi,0,0)` control has exact energy squared `4r^2`. Paper I now distinguishes this successful local-Hamiltonian regulator from the still-open strictly finite-range one-step QCA realization. Targeted 8,111-job guard build PASS. Submitted the complete manuscript plus all `PhysicsSM` supporting Lean to adversarial Aristotle project `d6da22f3` (task `f2924d7d`), requiring declaration-by-declaration semantic, nonva
```

### 8. `PhysicsSM/Draft/NullEdge/ContinuumL2MultiplierBridge.lean`

Score: `0.804`

```text
import Mathlib.MeasureTheory.Function.LpSeminorm.SMul
import Mathlib.MeasureTheory.Function.LpSpace.Basic

/-!
# Uniform multiplier error implies L2 convergence

This module isolates the analytic step after the null-edge walk's uniform
momentum-symbol estimate.  A square-integrable wave packet is acted on by a
family of pointwise errors.  If the pointwise norm is bounded by a scalar
sequence times the wave-packet norm, and that scalar tends to zero, then the
`L2` multiplier error tends to zero.

For the complex `3+1` walk, `err n k` can be instantiated by
`(U_n(k) - exp (-i t H(k))) (f k)` and `eps n` by the landed explicit compact
envelope.  This theorem closes the measure-theoretic multiplier step.  A
Fourier isometry between the chosen lattice/continuum spaces and identification
of the limiting multiplier with a position-space Dirac PDE remain separate
obligations.

Provenance: target prepared from the null-edge continuum audit; proofs
completed by Aristotle project `b4b82493-818d-48db-b7e1-148396c9e3e2`, then
reviewed and checked locally under Lean 4.28.0.  The proof uses Mathlib's
`eLpNorm_mono_ae`, scalar seminorm identity, and ENNReal squeeze APIs.
-/
```

## Scoped paper hits

### 1. Locality properties of Neuberger's lattice Dirac operator

Score: `0.773`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 2. Laplace and Dirac Operators on Graphs

Score: `0.758`
Zotero key: `WW6TKVH8`
arXiv: `2203.02782`
URL: https://www.zotero.org/19894138/items/WW6TKVH8

Abstract:

Discrete versions of the Laplace and Dirac operators studied in the context of combinatorial models of statistical mechanics and quantum field theory. Introduces several variations of the Laplace and Dirac operators on graphs and investigates graph-theoretic versions of the Schroedinger and Dirac equation, with a combinatorial interpretation for solutions, and proves gluing identities for the Dirac operator on lattice graphs as well as for graph Clifford algebras.

### 3. Discrete approximations to Dirac operators and norm resolvent convergence

Score: `0.752`
Zotero key: `JMGCEG8U`
arXiv: `2203.07826`
DOI: `10.4171/JST/438`
URL: http://arxiv.org/abs/2203.07826

Abstract:

We consider continuous Dirac operators defined on $\mathbf{R}^d$, $d\in\{1,2,3\}$, together with various discrete versions of them. Both forward-backward and symmetric finite differences are used as approximations to partial derivatives. We also allow a bounded, Hölder continuous, and self-adjoint matrix-valued potential, which in the discrete setting is evaluated on the mesh. Our main goal is to investigate whether the proposed discrete models converge in norm resolvent sense to their continuous counterparts, as the mesh size tends to zero and up to a natural embedding of the discrete space into the continuous one. In dimension one we show that forward-backward differences lead to norm resolvent convergence, while in dimension two and three they do not. The same negative result holds in all dimensions when symmetric differences are used. On the other hand, strong resolvent convergence holds in all these cases. Nevertheless, and quite remarkably, a rather simple but non-standard modification to the discrete models, involving the mass term, ensures norm resolvent convergence in general.

### 4. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.752`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`
