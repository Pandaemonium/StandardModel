# Aristotle semantic context pack

Generated: 2026-07-15T07:57:21
Query: `finite causal order open interval count Benincasa Dowker operator relabeling equivariance corrected metric pairing`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeP9IntrinsicOrderObservables.lean`

Score: `0.792`

```text
namespace PhysicsSM.Draft.NullEdgeP9IntrinsicOrderObservables

variable {A B : Type} [Fintype A] [Fintype B] [DecidableEq A] [DecidableEq B]

/-- Relabel a relation along an equivalence of finite vertex sets. -/
```

### 2. `PhysicsSM/Draft/NullEdgeP9IntrinsicOrderObservables.lean`

Score: `0.789`

```text
import Mathlib.Tactic

/-!
# P9 intrinsic order-observable invariance

This module integrates Aristotle project
`e71998cf-0c45-4dba-8677-639cf47576af`.

Scientific role: after the P9 block-aliasing and offset-window guardrails, the
program needs observables that are intrinsic to the finite causal order rather
than artifacts of a grid offset or vertex labeling. This module proves that two
basic causal-set graph observables, interval abundance and out-degree
histograms, are invariant under finite relabeling.
-/
```

### 3. `PhysicsSM/Draft/NullEdge/SpectralDistance.lean` [spectral_distance_nondegenerate]

Score: `0.785`

```text
theorem spectral_distance_nondegenerate (m : ℝ) (hm : 0 < m) :
    0 < spectralDist (Dm m) 0 1 := by
  rw [spectral_distance_two_point m hm]
  positivity

/-! ## Finite Malament step: causal order recovery -/

/-- The causal-link relation read off directly from the Dirac operator: two vertices are
linked when they coincide or when `D` propagates between them (`D x y ≠ 0`). For a genuine
Lorentzian (Krein) carrier the sign of the Krein form would orient this relation into a
causal *order*; the Riemannian witness below carries no time arrow, so the relation is the
symmetric adjacency relation. -/
```

### 4. `PhysicsSM/NullStrand/BellQFT/MinimalJumpRates.lean` [minimalBellRate_masterEquation]

Score: `0.782`

```text
theorem minimalBellRate_masterEquation
    {Q : Type*} [Fintype Q] (J : Q → Q → ℝ) (ρ : Q → ℝ) (F : Q → ℝ)
    (hρne : ∀ q, ρ q ≠ 0) (hρpos : ∀ q, 0 ≤ ρ q) (hAnti : ∀ q q', J q q' = -J q' q)
    (hcont : ∀ q, F q = ∑ q', J q q') (q : Q) :
    (∑ q', minimalBellRate J ρ q q' * ρ q) - (∑ q', minimalBellRate J ρ q' q * ρ q') = F q := by
  have hOut :
      (∑ q', minimalBellRate J ρ q q' * ρ q) = ∑ q', realPos (J q q') := by
    refine Finset.sum_congr rfl ?_
    intro q' hq'
    exact minimalBellRate_mul_density (J := J) (ρ := ρ) q q' (hρne q)
  have hIn :
      (∑ q', minimalBellRate J ρ q' q * ρ q') = ∑ q', realPos (J q' q) := by
    refine Finset.sum_congr rfl ?_
    intro q' hq'
    exact minimalBellRate_mul_density (J := J) (ρ := ρ) q' q (hρne q')
  have hIn' : (∑ q', realPos (J q' q)) = ∑ q', realPos (-J q q') := by
    refine Finset.sum_congr rfl ?_
    intro q' hq'
    simpa [hAnti q' q]
  calc
    (∑ q', minimalBellRate J ρ q q' * ρ q) - (∑ q', minimalBellRate J ρ q' q * ρ q')
        = (∑ q', realPos (J q q')) - (∑ q', realPos (J q' q)) := by
            rw [hOut, hIn]
    _ = (∑ q', realPos (J q q')) - (∑ q', realPos (-J q q')) := by
            rw [hIn']
    _ = ∑ q', (realPos (J q q') - realPos (-J q q')) := by
            simpa using
              (Finset.sum_sub_distrib (s := Finset.univ) (f := fun q' => realPos (J q q'))
                (g := fun q' => realPos (-J q q')))
    _ = ∑ q', J q q' := by
          refine Finset.sum_congr rfl ?_
          intro q' hq'
          exact (realPos_sub_realPos_neg (J q q'))
    _ = F q := by
          simpa using (hcont q).symm

/-- Equivariance under relabeling by a finite permutation. -/
```

### 5. `PhysicsSM/Draft/NullEdgeP9IntrinsicOrderObservables.lean` [intervalAbundance_transportRel]

Score: `0.781`

```text
theorem intervalAbundance_transportRel
    (e : Equiv A B) (R : A -> A -> Prop)
    [DecidableRel R] [DecidableRel (transportRel e R)] (k : Nat) :
    intervalAbundance (transportRel e R) k = intervalAbundance R k := by
  refine' Finset.card_bij (fun p _hp => (e.symm p.1, e.symm p.2)) _ _ _
  next =>
    intro p hp
    have := intervalCard_transportRel e R (e.symm p.1) (e.symm p.2)
    aesop
  next =>
    aesop
  next =>
    simp +zetaDelta at *
    exact fun a b h =>
      ⟨e a, e b, by simpa [intervalCard_transportRel] using h, by simp +decide,
        by simp +decide⟩

/-- Out-degree is invariant under finite relabeling. -/
```

### 6. `PhysicsSM/Draft/NullEdgeP9IntrinsicOrderObservables.lean` [intervalCard_transportRel]

Score: `0.778`

```text
theorem intervalCard_transportRel
    (e : Equiv A B) (R : A -> A -> Prop)
    [DecidableRel R] [DecidableRel (transportRel e R)] (a b : A) :
    intervalCard (transportRel e R) (e a) (e b) = intervalCard R a b := by
  simp +decide [intervalCard, transportRel]
  rw [Finset.card_filter, Finset.card_filter]
  conv_rhs => rw [<- Equiv.sum_comp e.symm]

/-- Interval abundance is invariant under finite relabeling. -/
```

### 7. `AgentTasks/null-edge-codex-overnight-run-ledger-2026-06-23.md` [Submitted P9 intrinsic order-observable invariance job]

Score: `0.773`

```text
## Submitted P9 intrinsic order-observable invariance job

Submitted Aristotle project:

- `e71998cf-0c45-4dba-8677-639cf47576af`
  (`task_id: 29e79cdc-dcca-4536-b3b4-61b8147221d1`)
  `null-edge-p9-intrinsic-order-observables-20260623`

Targets:

- `intervalCard_transportRel`
- `intervalAbundance_transportRel`
- `outDegree_transportRel`
- `outDegreeHistogram_transportRel`

Scientific role: first formal bridge from the new causal-set observable source
`RC5XF8RD` into Lean-facing theorem work. The target proves that interval
abundance and out-degree histograms are invariant under finite relabeling, so
they are genuinely intrinsic order observables rather than artifacts of a block
grid or vertex labeling.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-intrinsic-order-observables-20260623/NullEdgeP9IntrinsicOrderObservables/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-intrinsic-order-observables-20260623-project/NullEdgeP9IntrinsicOrderObservables/Core.lean
```

Both checks passed with exactly four intended proof-hole warnings.
```

### 8. `PhysicsSM/NullStrand/BellQFT/FockCutoff.lean` [DirectionEquivariant]

Score: `0.772`

```text
def DirectionEquivariant {Q : Type*} {Γ : Type*}
    (e : Γ ≃ Γ) (L : (Q → Γ → ℝ) → (Q → Γ → ℝ)) : Prop :=
  ∀ ρ, L (relabelDirection e ρ) = relabelDirection e (L ρ)

/-- Relabeling the direction variable does not change the direction marginal
(the total mass over directions is permutation invariant). -/
```

## Scoped paper hits

### 1. On the continuum limit of Benincasa–Dowker–Glaser causal set action

Score: `0.760`
Zotero key: `WCCDDR3H`
arXiv: `2007.13192`
DOI: `10.1088/1361-6382/abc274`
URL: https://www.zotero.org/19894138/items/WCCDDR3H

Abstract:

We study the continuum limit of the Benincasa–Dowker–Glaser causal set action on a causally convex compact region. In particular, we compute the action of a causal set randomly sprinkled on a small causal diamond in the presence of arbitrary curvature in various spacetime dimensions. In the continuum limit, we show that the action admits a finite limit. More importantly, the limit is composed by an Einstein–Hilbert bulk term as predicted by the Benincasa–Dowker–Glaser action, and a boundary term exactly proportional to the codimension-two joint volume. Our calculation provides strong evidence in support of the conjecture that the Benincasa–Dowker–Glaser action naturally includes codimension-two boundary terms when evaluated on causally convex regions.

### 2. Local d'Alembertian for causal sets

Score: `0.758`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`

### 3. Locality properties of Neuberger's lattice Dirac operator

Score: `0.753`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 4. On the definition of spacetimes in Noncommutative Geometry, part II

Score: `0.749`
Zotero key: `RADF3RUP`
arXiv: `1611.07842`
DOI: `10.48550/arXiv.1611.07842`
URL: https://arxiv.org/abs/1611.07842

Abstract:

Defines spectral spacetimes with time-orientation forms, stable causality, finite graph examples, split Dirac structures, and Lorentzian discretized Dirac operators.

### 5. Correction terms for propagators and d'Alembertians due to spacetime discreteness

Score: `0.741`
Zotero key: `arxiv:1411.2614`
arXiv: `1411.2614`
DOI: `10.1088/0264-9381/32/19/195020`
URL: http://arxiv.org/abs/1411.2614

Abstract:

Finite-sprinkling correction terms for causal-set retarded propagators and d'Alembertian operators compared with continuum limits.
