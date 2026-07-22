# Aristotle semantic context pack

Generated: 2026-07-21T14:40:29
Query: `continuous finite complex idempotent matrix family constant rank trace equals rank HNU Cayley band projector`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean`

Score: `0.843`

```text
namespace GateC1

variable {n : Type*} [Fintype n] [DecidableEq n]
variable {Q : Type*} [TopologicalSpace Q]

/-! ## Section 1.  Finite-dimensional / operator facts: trace, rank, persistence. -/

/-- **Core operator fact.**  The (complex-cast) rank of an idempotent matrix equals its
trace.  This is the algebraic substitute for "a projector's rank is read off its trace"
and is what makes the rank an *integer* invariant that contour integration cannot move
continuously. -/
```

### 2. `PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean` [ProjectorRankStable]

Score: `0.834`

```text
def ProjectorRankStable (P : Q → Matrix n n ℂ) : Prop :=
  ∀ q₀ : Q, ∀ᶠ q in nhds q₀, (P q).rank = (P q₀).rank

/-- **Finite-dimensional persistence theorem.**  A continuous family of idempotent
matrices has locally constant rank.  This is the minimal, integration-free statement of
projector persistence: continuity (which the maintained gap supplies analytically) plus
idempotency forces the integer rank to stay put. -/
```

### 3. `PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean` [rank_eq_of_trace_close]

Score: `0.832`

```text
theorem rank_eq_of_trace_close (P R : Matrix n n ℂ)
    (hP : IsIdempotentElem P) (hR : IsIdempotentElem R)
    (h : ‖P.trace - R.trace‖ < 1) : P.rank = R.rank := by
  rw [← trace_eq_rank_of_idem P hP, ← trace_eq_rank_of_idem R hR] at h
  have key : ‖(((P.rank : ℤ) - (R.rank : ℤ) : ℤ) : ℂ)‖ < 1 := by
    have he : (((P.rank : ℤ) - (R.rank : ℤ) : ℤ) : ℂ) = (P.rank : ℂ) - (R.rank : ℂ) := by
      push_cast; ring
    rw [he]; exact h
  rw [Complex.norm_intCast] at key
  have hh : |((P.rank : ℤ) - (R.rank : ℤ))| < 1 := by exact_mod_cast key
  rw [abs_lt] at hh
  omega

/-- The projector rank is **locally constant** in the parameter `q`. -/
```

### 4. `AgentTasks/model-calls/claude/2026-07-08-001918-fable-call-02.md` [Response stdout]

Score: `0.827`

```text
ank of a Matrix.\"}],\"count\":6,\"processing_time_ms\":669}"}]},"parent_tool_use_id":null,"session_id":"3c82d87d-232b-45df-9ef6-1d82e7b5b34c","uuid":"560e5145-040e-4298-8484-3c3fb7826762","timestamp":"2026-07-08T07:15:56.123Z","tool_use_result":{"content":"{\"query\":\"trace of idempotent matrix equals rank\",\"results\":[{\"id\":251365,\"name\":\"LinearMap.IsIdempotentElem.trace_eq_zero_iff\",\"description\":\"Trace of an Idempotent Endomorphism.\"},{\"id\":131971,\"name\":\"InnerProductSpace.isIdempotentElem_rankOne_self\",\"description\":\"Idempotency of Rank-One Projections.\"},{\"id\":251366,\"name\":\"LinearMap.IsIdempotentElem.eq_zero_of_trace_eq_zero\",\"description\":\"Vanishing Trace of an Idempotent Endomorphism.\"},{\"id\":247015,\"name\":\"Matrix.trace\",\"description\":\"Trace of a Square Matrix.\"},{\"id\":251348,\"name\":\"LinearMap.trace_one\",\"description\":\"Trace of the Identity Map.\"},{\"id\":246300,\"name\":\"Matrix.rank\",\"description\":\"Rank of a Matrix.\"}],\"count\":6,\"processing_time_ms\":669}","structuredContent":{"query":"trace of idempotent matrix equals rank","results":[{"id":251365,"name":"LinearMap.IsIdempotentElem.trace_eq_zero_iff","description":"Trace of an Idempotent Endomorphism."},{"id":131971,"name":"InnerProductSpace.isIdempotentElem_rankOne_self","description":"Idempotency of Rank-One Projections."},{"id":251366,"name":"LinearMap.IsIdempotentElem.eq_zero_of_trace_eq_zero","description":"Vanishing Trace of an Idempotent Endomorphism."},{"id":247015,"name":"Matrix.trace","description":"Trace of a Square Matrix."},{"id":251348,"name":"LinearMap.trace_one","description":"Trace of the Identity Map."},{"id":246300,"name":"Matrix.rank","description":"Rank of a Matrix."}],"count":6,"processing_time_ms":669}}}
{"type":"user","messa
```

### 5. `AgentTasks/context-packs/rank-four-davis-kahan-20260719-20260719-225651.md` [4. `PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean` [ProjectorRankStable]]

Score: `0.825`

```text
### 4. `PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean` [ProjectorRankStable]

Score: `0.809`

```text
def ProjectorRankStable (P : Q → Matrix n n ℂ) : Prop :=
  ∀ q₀ : Q, ∀ᶠ q in nhds q₀, (P q).rank = (P q₀).rank

/-- **Finite-dimensional persistence theorem.**  A continuous family of idempotent
matrices has locally constant rank.  This is the minimal, integration-free statement of
projector persistence: continuity (which the maintained gap supplies analytically) plus
idempotency forces the integer rank to stay put. -/
```
```

### 6. `AgentTasks/context-packs/bare-graph-permutation-projector-no-go-20260716-130011.md` [5. `PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean` [ProjectorRankStable]]

Score: `0.825`

```text
### 5. `PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean` [ProjectorRankStable]

Score: `0.810`

```text
def ProjectorRankStable (P : Q → Matrix n n ℂ) : Prop :=
  ∀ q₀ : Q, ∀ᶠ q in nhds q₀, (P q).rank = (P q₀).rank

/-- **Finite-dimensional persistence theorem.**  A continuous family of idempotent
matrices has locally constant rank.  This is the minimal, integration-free statement of
projector persistence: continuity (which the maintained gap supplies analytically) plus
idempotency forces the integer rank to stay put. -/
```
```

### 7. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` [hnuCayley_negativeProjector_exists]

Score: `0.824`

```text
theorem hnuCayley_negativeProjector_exists (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) :
    ∃ eps P : Mat4,
      SignCertificate (hnuCayleyGenerator a k) eps ∧
      eps.IsHermitian ∧
      P = (2 : Complex)⁻¹ • (1 - eps) ∧
      P * P = P ∧ P.IsHermitian := by
  sorry

end PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector
```

### 8. `PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean` [trace_eq_rank_of_idem]

Score: `0.824`

```text
theorem trace_eq_rank_of_idem (P : Matrix n n ℂ) (hP : IsIdempotentElem P) :
    (P.rank : ℂ) = P.trace := by
  have hproj : LinearMap.IsProj (LinearMap.range (toLin' P)) (toLin' P) := by
    refine ⟨fun x => LinearMap.mem_range_self _ x, ?_⟩
    intro x hx; obtain ⟨y, rfl⟩ := hx; rw [← Matrix.toLin'_mul_apply, hP]
  have htr := hproj.trace
  rw [Matrix.trace_toLin'_eq] at htr
  have hrank : P.rank = Module.finrank ℂ (LinearMap.range (toLin' P)) := by
    rw [Matrix.rank, toLin'_apply']
  rw [hrank, ← htr]

/-- **Pairwise rank stability.**  Two idempotents whose traces differ by less than `1`
have equal rank.  (The rank is integer-valued, so a sub-unit perturbation of the trace
cannot change it.)  This is the discrete heart of "the projector rank cannot jump while
the island stays separated". -/
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.743`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. An Analysis of Completely-Positive Trace-Preserving Maps on 2x2 Matrices

Score: `0.739`
Zotero key: `PKMDHXHA`
arXiv: `quant-ph/0101003`
URL: http://arxiv.org/abs/quant-ph/0101003

Abstract:

We give a useful new characterization of the set of all completely positive, trace-preserving (i.e., stochastic) maps from 2x2 matrices to 2x2 matrices. These conditions allow one to easily check any trace-preserving map for complete positivity. We also determine explicitly all extreme points of this set, and give a useful parameterization after reduction to a certain canonical form.

### 3. Decay Properties of Spectral Projectors with Applications to Electronic Structure

Score: `0.733`
Zotero key: `8CPJCV8S`
arXiv: `1203.3953`
DOI: `10.1137/100814019`
URL: https://doi.org/10.1137/100814019

Abstract:

This paper applies approximation theory and matrix analysis to spectral projectors of large sparse Hermitian matrices. It proves exponential off-diagonal decay for the density matrix of gapped systems at zero temperature in orthogonal and non-orthogonal representations, and discusses metallic systems at positive temperature.

### 4. Spectral Theory of Self-adjoint Finitely Cyclic Operators and Introduction to Matrix Measure $L^2$-spaces

Score: `0.719`
Zotero key: `F5KRJPCA`
arXiv: `2212.13953`
URL: http://arxiv.org/abs/2212.13953

Abstract:

We study finitely cyclic self-adjoint operators in a Hilbert space, i.e. self-adjoint operators that posses such a finite subset in the domain that the orbits of all its elements with respect to the operator are linearly dense in the space. One of the main goals here is to obtain the representation theorem for such operators in a form analogous to the one well-known in the cyclic self-adjoint operators case. To do this, we present here a detailed introduction to matrix measures, to the matrix measure $L^2$ spaces, and to the multiplication by scalar functions operators in such spaces. This allows us to formulate and prove in all the details the less known representation result, saying that the finitely cyclic self-adjoint operator is unitary equivalent to the multiplication by the identity function on $\mathbb{R}$ in the appropriate matrix measure $L^2$ space. We study also some detailed spectral problems for finitely cyclic self-adjoint operators, like the absolute continuity.

### 5. Tri-partitions and Bases of an Ordered Complex

Score: `0.700`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x
