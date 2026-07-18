# Aristotle semantic context pack

Generated: 2026-07-16T13:00:45
Query: `bare graph permutation equivariant idempotent rank four projector no canonicity`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/clifford-cover-projector-aristotle-2026-07-13.md` [Semantic priorities]

Score: `0.849`

```text
## Semantic priorities

1. Prove the even-right projector is an idempotent, nonprimitive rank-four
   projector on the eight-dimensional complex state space.
2. Prove it commutes with every left signed flip and with `Gamma`.
3. Prove `B` is Hermitian and involutive, then prove the projector is
   Hermitian in the stated delta-basis sense, nonzero, nonidentity, and rank 4.
   (`projector_nonzero` and `projector_nonidentity` are already derived once
   `projector_vacuum_value` is filled.)
4. Complete the no-conjugacy control: a commuting family of invertible deck
   flips cannot simultaneously be an anticommuting family after conjugation.
5. Preserve the explicit finite sign conventions and kernel-reduced `decide`
   lemmas. Do not replace results with assumptions or trusted escape hatches.

For rank, a useful route is the existing handoff: the matrix decomposes into
four disjoint two-dimensional toggle pairs, with one `+1` and one `-1`
eigenvector for `B` in each pair. An explicit basis/equivalence argument is
welcome. Do not weaken `projector_rank_four` or replace exact finrank with an
inequality.
```

### 2. `PhysicsSM/Draft/NullEdge/GateC1/OverlapIndex.lean` [chiralProjector_idempotent]

Score: `0.818`

```text
theorem chiralProjector_idempotent (M : Matrix Spin Spin ℂ)
    (hM : M * M = (1 : Matrix Spin Spin ℂ)) :
    chiralProjector M * chiralProjector M = chiralProjector M := by
  have h1 :
      chiralProjector M * chiralProjector M =
        (1 / 4 : ℂ) • ((1 + M) * (1 + M)) := by
    unfold chiralProjector
    rw [Matrix.smul_mul, Matrix.mul_smul, smul_smul]
    norm_num
  rw [h1, mul_add, add_mul, add_mul, one_mul, mul_one, one_mul, hM]
  unfold chiralProjector
  module

/-- The rank of the chiral projector of an involution. -/
```

### 3. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/CODEX_CLIFFORD_COVER_DECODER_2026-07-13.md` [DK2. Local commutant projector]

Score: `0.812`

```text
### DK2. Local commutant projector

Construct the commuting right Clifford action.  Exhibit an explicit nonzero,
nonidentity Hermitian idempotent `P` of rank two or four such that

```text
P c_j = c_j P
```

for every spatial generator.  Prove the rank with an explicit rational or
Gaussian-rational basis witness.  This is the first genuinely new resource:
an onsite, momentum-independent candidate physical-sector projector.
```

### 4. `PhysicsSM/Draft/NullEdge/ChiralProjectorsDirac.lean` [projector_ranks]

Score: `0.811`

```text
theorem projector_ranks : Matrix.trace PL = 2 ∧ Matrix.trace PR = 2 := by
  constructor
  · simp [Matrix.trace, Matrix.diag, Fin.sum_univ_four, PL, g5, Matrix.smul_apply,
      Matrix.sub_apply]
    norm_num
  · simp [Matrix.trace, Matrix.diag, Fin.sum_univ_four, PR, g5, Matrix.smul_apply,
      Matrix.add_apply]
    norm_num

/-- info: 'ChiralProjectorsDirac.projector_ranks' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projector_ranks

/-! ## Non-degeneracy: the involution and projectors are genuinely nontrivial -/
```

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

### 6. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/CODEX_FLAVOR_COVER_OCTONION_ROUTE_2026-07-13.md` [F4a. Momentum-independent projector no-go]

Score: `0.806`

```text
#### F4a. Momentum-independent projector no-go

A projector that is onsite and independent of momentum acts in the same way at
every cover crossing.  It may reduce the internal rank uniformly, but it cannot
select one momentum sheet while removing the others.  Thus a constant
Clifford/taste idempotent is not a doubler decoder, even when it commutes with
the flavored walk.

This kills the naive reading of a Dirac--Kahler/Watterson-style projector as a
solution.  Such projectors preserve chirality or a taste subspace uniformly
over all complexes; they do not remove the unwanted momentum copies.
```

### 7. `PhysicsSM/Draft/NullEdge/PinnedSpecProjectors.lean`

Score: `0.806`

```text
/-
# Deliverable 2 (part 3c) — the spectral projectors are genuine (structural)

Companion Lean file for `PINNED_STABILITY_DESIGN.md`.  Certifies that the
projectors of `Pinned.SectorDefs` used to define the sector-resolved index are
genuine orthogonal spectral projectors onto `ker(W-ε)`.  Proved **structurally**
(matrix algebra) from the landed isometry/intertwining facts plus the exact
`4×4` involution of the fixed-leg compression — no heavy `native_decide` on the
full `8×8` expressions.

* general `B`-compression projector lemma `bproj_spectral`;
* general involution projector lemma `invproj_spectral`;
* instantiations: `eigProj13_is_spectral` (protected singletons, rank `2`),
  `eigProj02_is_spectral` (blind singletons, rank `2`),
  `eigProjW_is_spectral` (blocks, rank `4`).

Draft-trust disclosure: only the small `4×4` involution facts
(`Mfix_involution`, `Mfix0_involution`) use `native_decide`; everything else is
kernel-only.
-/
/-
Provenance: Aristotle job 573430f4 harvest (statements) + local Fable
proofs for the two abstract projector lemmas (2026-07-11, 24h run;
elementary ring algebra closed locally per the local-first policy).
Statements UNCHANGED from the harvest; import rewires only.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.HalfPeriodInvariant
import PhysicsSM.Draft.NullEdge.PinnedMirrorChart
import PhysicsSM.Draft.NullEdge.PinnedSectorDefs
```

### 8. `PhysicsSM/NullStrand/Entanglement/DirectionProjector.lean` [pureDirectionProjector_isHermitian]

Score: `0.805`

```text
theorem pureDirectionProjector_isHermitian (ω : Fin 3 → ℝ) :
    (pureDirectionProjector ω).IsHermitian := by
  unfold pureDirectionProjector
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.conjTranspose_apply, Complex.conj_I, Complex.conj_ofReal, sub_eq_add_neg]

/-- ENT-001c. On the unit sphere the Bloch projector is idempotent, hence a
rank-one orthogonal projector. -/
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.742`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. Scattering Amplitudes and the Positive Grassmannian

Score: `0.736`
Zotero key: `FB3H4MF3`
arXiv: `1212.5605`
URL: http://arxiv.org/abs/1212.5605

Abstract:

We establish a direct connection between scattering amplitudes in planar four-dimensional theories and a remarkable mathematical structure known as the positive Grassmannian. The central physical idea is to focus on on-shell diagrams as objects of fundamental importance to scattering amplitudes. We show that the all-loop integrand in N=4 SYM is naturally represented in this way. On-shell diagrams in this theory are intimately tied to a variety of mathematical objects, ranging from a new graphical representation of permutations to a beautiful stratification of the Grassmannian G(k,n) which generalizes the notion of a simplex in projective space.

### 3. Quantum geometric tensor determines the pure-state i.i.d. conversion rate in the resource theory of asymmetry for any compact Lie group

Score: `0.726`
Zotero key: `45FTB5VF`
arXiv: `2411.04766`
URL: http://arxiv.org/abs/2411.04766

Abstract:

Shows that the quantum geometric tensor determines pure-state iid conversion rates in the resource theory of asymmetry for compact Lie groups.

### 4. On Noncommutative and semi-Riemannian Geometry

Score: `0.717`
Zotero key: `F877GT5B`
arXiv: `math-ph/0110001`
DOI: `10.48550/arXiv.math-ph/0110001`
URL: https://arxiv.org/abs/math-ph/0110001

Abstract:

Introduces semi-Riemannian spectral triples using Krein spaces and Krein-selfadjoint Dirac operators, with recovery of signature data from spectral data.

### 5. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.716`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.
