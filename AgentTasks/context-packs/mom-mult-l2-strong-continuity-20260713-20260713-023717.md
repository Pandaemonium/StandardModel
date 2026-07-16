# Aristotle semantic context pack

Generated: 2026-07-13T02:37:22
Query: `strong continuity Lp vector valued L2 pointwise unitary multiplier dominated convergence matrix exponential exact Dirac flow`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/overnight-publication-run-2026-07-11/RUN_PLAN.md` [P3. Paper D: changing-lattice continuum theorem]

Score: `0.833`

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

### 2. `AgentTasks/aristotle-standalone/physical-mass-continuum-audit-20260710/Audit/Inputs/PriorCompositionAudit.md` [C. Fixed-momentum many-step continuum (self-contained; all derived from Mathlib)]

Score: `0.830`

```text
### C. Fixed-momentum many-step continuum (self-contained; all derived from Mathlib)
```
[primitive: Mathlib]  NormedSpace.exp, Matrix.unitaryGroup, L2 operator norm  ═▶
   │
   ├─ abs_one_sub_cos_le, abs_sub_sin_le ─┐
   ├─ norm_H_le, l2_opNorm_le_two_entryMax ┤
   ├─ walk_sub_firstOrder_entry{00,01,10,11}_bound ─▶ walk_sub_firstOrder_entry_bound ─▶ walk_sub_firstOrder_bound
   ├─ norm_exp_sub_one_sub_le ─▶ firstOrder_sub_exactFlow_bound
   │        └──────────────┬───────────────┘
   │                       ▼
   │            one_step_to_exact_flow_bound  (‖walk−flow‖ ≤ Dkm·eps²)
   ├─ walk_mem_unitary, exactFlow_mem_unitary ─▶ unitary_pow_telescope (linear, no eⁿ loss)
   ├─ exactFlow_div_pow (flow(t/n)^n = flow(t))
   │                       ▼
   └──────────▶ fixed_time_many_step_bound ──▶ fixed_time_many_step_tendsto
                          OBSERVABLE: n-step walk → exact Dirac flow, rate Dkm·t²/n
```
```

### 3. `AgentTasks/null-edge-cycle-06-literature-2026-07-02.md` [Sources checked]

Score: `0.829`

```text
## Sources checked

1. P. Arrighi, M. Forets, and V. Nesme,
   "The Dirac equation as a quantum walk: higher dimensions, observational
   convergence," arXiv:1307.3524.
   Source: https://arxiv.org/abs/1307.3524

   Relevance: remains the main conceptual anchor. Its convergence statement is
   operator-splitting/Trotter flavored and reports an `O(eps^2)` observational
   discrepancy. The Lean path now mirrors this: per-step error is proved, and
   the next missing item is stable accumulation plus the exponential bridge.

2. Mathlib documentation,
   `Mathlib.Analysis.Normed.Algebra.MatrixExponential`.
   Source:
   https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Normed/Algebra/MatrixExponential.html

   Relevance: this is the first place to search for Lean-native matrix
   exponential lemmas. The current project uses `NormedSpace.exp`; the next
   theorem should reuse Mathlib's existing matrix exponential API rather than
   building a bespoke exponential theory.

3. Mathlib documentation,
   `Mathlib.Analysis.Normed.Algebra.Exponential`.
   Source:
   https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Normed/Algebra/Exponential.html

   Relevance: documents the Banach/topological algebra exponential API behind
   `NormedSpace.exp`. It is the likely source of continuity, differentiability,
   and first-order expansion lemmas.

4. General matrix-exponential norm bounds.
   Source: https://en.wikipedia.org/wiki/Matrix_exponential

   Relevance: only background orientation, not formal provenance. It highlights
   the standard role of submultiplicative norms with `||I|| = 1`. This is
   exactly why the current `matrixL1Norm_one = 2` guardrail matters.
```

### 4. `AgentTasks/overnight-null-information-run-2026-07-10/2026-07-10_ARISTOTLE_COMPOSITION_LANDINGS_AUDIT_01.md` [C. Fixed-momentum many-step continuum (self-contained; all derived from Mathlib)]

Score: `0.826`

```text
### C. Fixed-momentum many-step continuum (self-contained; all derived from Mathlib)
```
[primitive: Mathlib]  NormedSpace.exp, Matrix.unitaryGroup, L2 operator norm  ═▶
   │
   ├─ abs_one_sub_cos_le, abs_sub_sin_le ─┐
   ├─ norm_H_le, l2_opNorm_le_two_entryMax ┤
   ├─ walk_sub_firstOrder_entry{00,01,10,11}_bound ─▶ walk_sub_firstOrder_entry_bound ─▶ walk_sub_firstOrder_bound
   ├─ norm_exp_sub_one_sub_le ─▶ firstOrder_sub_exactFlow_bound
   │        └──────────────┬───────────────┘
   │                       ▼
   │            one_step_to_exact_flow_bound  (‖walk−flow‖ ≤ Dkm·eps²)
   ├─ walk_mem_unitary, exactFlow_mem_unitary ─▶ unitary_pow_telescope (linear, no eⁿ loss)
   ├─ exactFlow_div_pow (flow(t/n)^n = flow(t))
   │                       ▼
   └──────────▶ fixed_time_many_step_bound ──▶ fixed_time_many_step_tendsto
                          OBSERVABLE: n-step walk → exact Dirac flow, rate Dkm·t²/n
```
```

### 5. `AgentTasks/model-calls/claude/2026-07-12-200701-afpl-exact-flow-cell-integral-audit.md` [Momentum Lipschitz bound for the exact 3+1 Dirac flow]

Score: `0.821`

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

### 6. `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` [Uniform many-step Dirac control]

Score: `0.821`

```text
\section{Uniform many-step Dirac control}
\label{sec:continuum}

The finite walk should approximate the continuous Dirac flow over a fixed
macroscopic time, not merely at one infinitesimal step.  For the real
representative of the phase-conjugacy class, write
\begin{equation}
 U(q,r)=e^{-\ii q\sigma_z}e^{-\ii r\sigma_x},
 \qquad
 H(k,\mu)=k\sigma_z+\mu\sigma_x,
 \qquad
 V_t(k,\mu)=e^{-\ii tH(k,\mu)}.
\end{equation}

\begin{theorem}[Uniform bounded-momentum product limit]\label{thm:rate}
For $K,M\geq0$, define
\begin{align}
 C_{\mathrm{box}}(K,M)
   &=2K^2+2M^2+KM^2+K^2M+KM,\\
 D_{\mathrm{box}}(K,M)
   &=4C_{\mathrm{box}}(K,M)
     +4(K+M)^2e^{K+M}.
\end{align}
If $|k|\leq K$, $|\mu|\leq M$, $n>0$, and $|t/n|\leq1$, then
\begin{equation}\label{eq:rate}
 \norm{
   U\!\left(k\frac{t}{n},\mu\frac{t}{n}\right)^n
   -V_t(k,\mu)}
 \leq D_{\mathrm{box}}(K,M)\frac{t^2}{n}.
\end{equation}
The bound is uniform on the displayed parameter box, and its right-hand side
tends to zero as $n\to\infty$.
\end{theorem}
\noindent\NewResult{} \Kernel{}

\begin{proof}[Proof architecture]
The one-step walk differs from $\id-\ii(t/n)H$ by an explicit quadratic
remainder.  The exact exponential differs from the same first-order matrix by
another quadratic remainder, giving
$\norm{U-V_{t/n}}\leq D(k,\mu)t^2/n^2$.  Both matrices are unitary, so the power
telescope has no norm-growth factor:
\[
 \norm{U^n-V_{t/n}^n}\leq n\norm{U-V_{t/n}}.
\]
The exact short-time flows compose to $V_t$, producing the $1/n$ rate.  Finally
$D(k,\mu)\leq D_{\mathrm{box}}(K,M)$ on the parameter box.  Lean checks the
entrywise remainder estimates, operator-norm conversion, unitarity, telescope,
flow composition, box inequality, and limit.
\end{proof}

\begin{figure}[t]
\centering
\includegraphics[width=0.88\linewidth]{nul
```

### 7. `AgentTasks/model-calls/claude/2026-07-12-200701-afpl-exact-flow-cell-integral-audit.md` [Momentum Lipschitz bound for the exact 3+1 Dirac flow]

Score: `0.819`

```text
ky kz qx qy qz m t : Real) :
    ‖exactFlow kx ky kz m t - exactFlow qx qy qz m t‖ <=
      |t| * (|kx - qx| + |ky - qy| + |kz - qz|) := by
  refine le_trans
    (by
      simpa [exactFlow] using
        HermitianExpLipschitz.hermitian_exp_lipschitz
          (H kx ky kz m) (H qx qy qz m)
          (H_isHermitian _ _ _ _) (H_isHermitian _ _ _ _) t)
    (mul_le_mul_of_nonneg_left
      (norm_H_sub_H_le_l1 kx ky kz qx qy qz m) (abs_nonneg t))

/-- Inside one physical momentum cell, the exact multiplier differs from its
cell-center value by at most `3 |t| h / 2`. -/
theorem exactFlow_cellCenter_norm_le {h : Real}
    {k : Mode3} {x : Momentum3} (hx : x ∈ momentumCell h k)
    (m t : Real) :
    ‖exactFlow (x 0) (x 1) (x 2) m t -
        exactFlow (cellCenter h k 0) (cellCenter h k 1)
          (cellCenter h k 2) m t‖ <=
      |t| * (3 * h / 2) := by
  have h0 := mem_momentumCell_coord_error hx 0
  have h1 := mem_momentumCell_coord_error hx 1
  have h2 := mem_momentumCell_coord_error hx 2
  refine le_trans
    (exactFlow_momentum_lipschitz
      (x 0) (x 1) (x 2)
      (cellCenter h k 0) (cellCenter h k 1) (cellCenter h k 2) m t) ?_
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg t)
  nlinarith

/-- Boundary control: at zero elapsed time, the exact multiplier is the
identity for every momentum. -/
theorem exactFlow_zero_time (kx ky kz m : Real) :
    exactFlow kx ky kz m 0 = 1 := by
  simp [exactFlow]

/-- Nonconstant control: changing the x momentum changes the live Hermitian
generator. -/
theorem H_x_witness_ne : H 1 0 0 0 ≠ H 0 0 0 0 := by
  intro h
  have h03 := congrFun (congrFun h 0) 3
  norm_num [H, alpha1, alpha2, alpha3, beta] at h03
  simp at h03

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz.exactFlow_momentum_lipschitz' depends on axioms: [prope
```

### 8. `PhysicsSM/Draft/NullEdge/FixedMomentumManyStepContinuum.lean` [exactFlow]

Score: `0.816`

```text
def exactFlow (k m t : ℝ) : Mat :=
  NormedSpace.exp ((-(t : ℂ)) • (I • H k m))
```

## Scoped paper hits

### 1. Discrete approximations to Dirac operators and norm resolvent convergence

Score: `0.746`
Zotero key: `JMGCEG8U`
arXiv: `2203.07826`
DOI: `10.4171/JST/438`
URL: http://arxiv.org/abs/2203.07826

Abstract:

We consider continuous Dirac operators defined on $\mathbf{R}^d$, $d\in\{1,2,3\}$, together with various discrete versions of them. Both forward-backward and symmetric finite differences are used as approximations to partial derivatives. We also allow a bounded, Hölder continuous, and self-adjoint matrix-valued potential, which in the discrete setting is evaluated on the mesh. Our main goal is to investigate whether the proposed discrete models converge in norm resolvent sense to their continuous counterparts, as the mesh size tends to zero and up to a natural embedding of the discrete space into the continuous one. In dimension one we show that forward-backward differences lead to norm resolvent convergence, while in dimension two and three they do not. The same negative result holds in all dimensions when symmetric differences are used. On the other hand, strong resolvent convergence holds in all these cases. Nevertheless, and quite remarkably, a rather simple but non-standard modification to the discrete models, involving the mass term, ensures norm resolvent convergence in general.

### 2. Locality properties of Neuberger's lattice Dirac operator

Score: `0.742`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 3. Frustration index and Cheeger inequalities for discrete and continuous magnetic Laplacians

Score: `0.734`
Zotero key: `FNP9V3DT`
DOI: `10.1007/s00526-015-0935-x`
URL: https://doi.org/10.1007/s00526-015-0935-x

### 4. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.732`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 5. The generalized Lichnerowicz formula and analysis of Dirac operators

Score: `0.724`
Zotero key: `BQJAG9TR`
arXiv: `hep-th/9503153`
URL: http://arxiv.org/abs/hep-th/9503153v1

Abstract:

Generalized Lichnerowicz formula for Dirac operator squares, with applications to gravity and Yang-Mills actions from Dirac operators.
