# Aristotle semantic context pack

Generated: 2026-07-13T05:59:51
Query: `quantum relative entropy equality zero iff density matrices equal doubly stochastic spectral overlap degenerate eigenspaces`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/aristotle-p9-sj-reference-state-report.md` [Summary]

Score: `0.834`

```text
ide.

relative entropy / data-processing connection:
  Normalize the kept SJ eigenvalues to sjSpectralDist : FinDist; encode nested
  sub-diamond restriction as a column-stochastic FinObs; then reuse the proved
  finite klDiv data-processing inequality, convexity-along-chain, and
  equality/recoverability (sufficiency / discrete Petz) lemmas from
  NullEdgeRelativeEntropyObserverRoadmap. The genuine matrix Umegaki SJ entropy
  is deferred to the (open) quantum matrix layer.

ranked next theorem signatures:
  1. iDelta_isHermitian  : (iDelta G).IsHermitian
       (gates the whole spectral construction; expected easy from Δᵀ = −Δ).
  2. pauliJordanReal_antisymm : (pauliJordanReal G)ᵀ = - pauliJordanReal G.
  3. sjTwoPoint_posSemidef : 0 ⪯ sjTwoPoint G hH.
  4. sjTwoPoint_peierls :
       sjTwoPoint G hH - star (sjTwoPoint G hH) = iDelta G  (on range iΔ).
  5. sjSpectralDist_wellDef : the kept-eigenvalue weights form a FinDist
       (nonneg + sum_one).
  6. sj_dpi_nested :
       klDiv (pushforward (restrictChannel D') (sjSpectralDist D))
             (pushforward (restrictChannel D') ref)
         ≤ klDiv (sjSpectralDist D) ref.
  7. sj_entropy_chain_monotone : k ↦ klDiv (sjSpectralDist (Dchain k)) ref
       is antitone along a nested diamond chain.
  8. sjTwoPointTrunc_trace_le :
       trace (sjTwoPointTrunc …) ≤ trace (sjTwoPoint …)  (truncation control).

likely blockers:
  - Mathlib spectral-API friction: assembling the positive part via
    eigenvectorUnitary / spectral_theorem and proving PSD and the Peierls
    identity on range(iΔ) can be fiddly (unitary star bookkeeping, coercions
    ℝ→ℂ). Budget the most effort here.
  - Existence/invertibility of the link-resolvent model (need L nilpotent in a
    linear extension); the direct-causal model avoids this and s
```

### 2. `AgentTasks/null-edge-relative-entropy-observer-channel-output.md` [Stage 3 (LATER, quantum — gated): matrix relative entropy]

Score: `0.828`

```text
### Stage 3 (LATER, quantum — gated): matrix relative entropy

Only attempt once a concrete program need forces it. Explicit hypotheses that
**must** be bundled (the prompt's checklist), and why the classical layer dodges
each:

| quantum hypothesis | needed because | classical analogue (already handled) |
|---|---|---|
| finite-dim Hilbert space `Fin d`, `Matrix (Fin d) (Fin d) ℂ` | `Tr`, eigen-decomposition exist | finite `ι` |
| `ρ.PosSemidef`, `σ.PosSemidef` | `log` of operator defined; entropy real | `nonneg` |
| `ρ.trace = 1`, `σ.trace = 1` | normalization, `S(ρ‖ρ)=0` | `sum_one` |
| support inclusion `ker σ ⊆ ker ρ` (i.e. `ρ ≪ σ`) | otherwise `S = +∞` | `AbsCont` |
| channel is **CPTP** (`Φ` completely positive, trace preserving) | DPI needs *complete* positivity, not just positivity | column-stochastic = CPTP for diagonal/classical channels |

The hard part of the quantum DPI (Lindblad/Uhlmann monotonicity, operator
convexity of `t ↦ t log t`, Lieb concavity) has **no Mathlib support** and is a
large independent formalization. Recommendation: do **not** open this gate for
P7/P9. The classical layer is the honest "Type-I matrix analogue" the
publication plan already says is the safe claim. If a quantum statement is ever
needed, restrict first to **commuting** `ρ, σ` (simultaneously diagonalizable),
which reduces *exactly* to the proven classical `klDiv` on shared eigenvalues —
no new analysis required.

Staging confidence:

| stage | conf | status |
|---|---|---|
| 0 classical KL spine | 9 | DONE (proved) |
| 1 observer loss + exact recovery | 9 | DONE (proved) |
| 2 partition specializations | 9 | trivial reuse |
| 3 quantum matrix RE | 3 | gated; only via commuting-operator reduction |

---
```

### 3. `PhysicsSM/Draft/NullEdge/FiniteSSBDegeneracyNoGo.lean` [simple_eigenstate_density_invariant]

Score: `0.825`

```text
theorem simple_eigenstate_density_invariant {n : Nat}
    (H U : Matrix (Fin n) (Fin n) ℂ) (E : ℂ) (psi : Fin n → ℂ)
    (hsimple : IsSimpleEigenpair H E psi)
    (hnorm : vecNormSq psi = 1)
    (hunit : U.conjTranspose * U = 1)
    (hcomm : H * U = U * H) :
    pureDensity (U.mulVec psi) = pureDensity psi := by
  obtain ⟨c, hc⟩ := commuting_symmetry_preserves_simple_line H U E psi hsimple hcomm
  have hnormc : Complex.normSq c = 1 := by
    have h1 : vecNormSq (U.mulVec psi) = vecNormSq psi :=
      vecNormSq_mulVec_unitary U psi hunit
    have h2 : vecNormSq (c • psi) = Complex.normSq c * vecNormSq psi := by
      unfold vecNormSq
      rw [Finset.mul_sum]
      refine Finset.sum_congr rfl (fun i _ => ?_)
      simp [Complex.normSq_mul]
    rw [hc] at h1
    rw [h2, hnorm, mul_one] at h1
    exact h1
  have hcc : c * star c = 1 := by
    have h := Complex.mul_conj c
    rw [hnormc] at h
    simpa [mul_comm, RCLike.star_def] using h
  ext i j
  simp only [pureDensity, hc, Pi.smul_apply, smul_eq_mul, star_mul']
  have hrw : c * psi i * (star c * star (psi j)) =
      (c * star c) * (psi i * star (psi j)) := by ring
  rw [hrw, hcc, one_mul]

/-- Degenerate zero Hamiltonian on two states. -/
```

### 4. `AgentTasks/null-edge-relative-entropy-observer-channel-output.md` [4. Interface with the qubit concurrence theorem (P7)]

Score: `0.817`

```text
## 4. Interface with the qubit concurrence theorem (P7)

The audit already flagged the trap; the API must respect it.

**The fact.** `NullEdgeQubitConcurrence.concurrenceSqComplex ρ = 4 det ρ` is the
**single-qubit linear entropy / tangle** `2(1 − Tr ρ²) = 4 det ρ` (proved there
via `Tr ρ² = (Tr ρ)² − 2 det ρ`). It is **not** the Wootters two-qubit
concurrence `max(0, λ₁−λ₂−λ₃−λ₄)` with spin-flip and eigenvalue ordering.

**How the relative-entropy API connects without confusing the two.** For a
genuine qubit density (PSD, trace 1) with eigenvalues `(λ, 1−λ)`:

* `4 det ρ = 4 λ(1−λ)` is a *symmetric concave mixedness functional* of the
  classical eigenvalue distribution `eigDist ρ := ⟨λ, 1−λ⟩ : FinDist (Fin 2)`.
* The proper-time wrapper `m/E = 2√det ρ_vis` is `√(4λ(1−λ))`, a function of
  `eigDist ρ` only.
* The correct monotonicity statement is therefore: *under a classical
  (eigenbasis-diagonal / pinching) observer channel `T : FinObs (Fin 2) (Fin 2)`,
  the mixedness `4 det` and hence `m/E` does not decrease* — because such `T`
  pushes `eigDist ρ` toward uniform, and `λ(1−λ)` is Schur-concave. This is the
  **same DPI principle** restated for a concave functional; it is honestly LOCC/
  classical-channel-only, matching the program's stated boundary that entangling
  hidden channels can *increase* concurrence (so a bare monotonicity claim is
  false).

Recommended bridge declarations (NEXT job, see ranking):

```lean
def eigDist (ρ : QubitDensity) (h : ρ.PosSemidef) (htr : ρ.trace = 1) : FinDist (Fin 2)
def visibleMixedness (ρ) : ℝ := 4 * (Matrix.det ρ).re          -- = 4 λ(1−λ)
theorem visibleMixedness_eq_concurrenceSq (ρ) (htr : trace2 ρ = 1) :
    visibleMixedness ρ = (concurrenceSqComplex ρ).re             -- ties to the banked wrapper
theorem visibleMixedness
```

### 5. `AgentTasks/aristotle-p9-sj-reference-state-report.md` [5.3 Quantum upgrade (flagged, not asserted)]

Score: `0.813`

```text
### 5.3 Quantum upgrade (flagged, not asserted)

The roadmap's classical layer is commutative (diagonal). The genuine SJ
relative entropy is the **matrix** Umegaki entropy
`S(W ‖ W_ref) = tr(W (log W − log W_ref))`. This requires the quantum matrix
layer that the roadmap explicitly lists as open. The honest staging is: prove
the classical spectral-distribution diagnostics now (they are real theorems via
the existing DPI), and list the matrix Umegaki DPI as the downstream blocker.

---
```

### 6. `PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean` [blochDensity_purity_eq_radius_sq]

Score: `0.812`

```text
theorem blochDensity_purity_eq_radius_sq (r : BlochVector) :
    blochPurity r = (1 + dot3 r r) / 2 := by
  unfold blochPurity
  rw [blochDensity_trace_square_eq_radius_sq, Complex.ofReal_re]

/--
For a qubit Bloch density, normalized linear entropy is exactly `4 det`.
This is the finite "mass as visible mixedness" identity.
-/
```

### 7. `AgentTasks/null-edge-physics-audit-report-aristotle-20260622.md` [PhysicsSM/Draft/NullEdgeQubitConcurrence.lean]

Score: `0.812`

```text
### PhysicsSM/Draft/NullEdgeQubitConcurrence.lean
| Declaration | Score | Note |
|---|---|---|
| `trace2_mul_self_eq_trace_sq_sub_two_det` | 9 | Correct `Tr(rho^2)=Tr(rho)^2-2 det`. |
| `concurrenceSqComplex` | 7 | "Concurrence" = single-qubit tangle/linear-entropy form `4 det`, not Wootters; no positivity bundled. Comment added. |
| `linearEntropyComplex_eq_concurrenceSq_of_trace_one` | 8 | Correct under trace-one hypothesis. |
| `normalized_mass_ratio_eq_concurrence` and `_sq_eq_four_det` | 8 | Identification is by definition (`2 sqrt d`); honest but tautological bridge. |
```

### 8. `PhysicsSM/Draft/NullEdge/PathSumSemantics.lean` [coherent_linear_entropy_zero]

Score: `0.810`

```text
theorem coherent_linear_entropy_zero (a : H → ℂ) (psi : H → Fin 2 → ℂ)
    (hnorm : (rhoDir a psi (onesKer)).trace = 1) :
    1 - (rhoDir a psi (onesKer) * rhoDir a psi (onesKer)).trace = 0 := by
  rw [ coherent_purity, hnorm ] ; norm_num

/-! ## Target 3 : decohered mass equals which-direction disagreement. -/

/--
With the delta kernel, `rhoDir = ∑_h |a h|² |psi h⟩⟨psi h|`.
-/
```

## Scoped paper hits

No paper hits returned.
