# Aristotle semantic context pack

Generated: 2026-07-19T18:13:22
Query: `SU2 quaternion endpoint equals reverse parity cosine product extreme HNU walk`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/HNUGlobalHolonomyClassification.lean` [hnuRefls]

Score: `0.811`

```text
def hnuRefls : List M2 := [-σ1, -σ3, -σ2, σ3, σ1, -σ3, σ2, σ3]

/-- **The HNU complement holonomy is the central element `-1`.**  (Same content as
`AntiperiodicHNU.prodS_eq_neg_one`, packaged as a list product.) -/
```

### 2. `PhysicsSM/Draft/NullEdge/HNUManyStepContinuumLive.lean` [Hw]

Score: `0.807`

```text
def Hw (q : Fin 3 → ℝ) : Mat :=
  (q 0 : ℂ) • sx + (q 1 : ℂ) • sy + (q 2 : ℂ) • sz

/-- The exact HNU endpoint at rescaled compact momentum `W(q, eps) = U(eps • q)`. -/
```

### 3. `PhysicsSM/Draft/NullEdge/AntiperiodicHNU.lean` [twEndpoint_zero]

Score: `0.805`

```text
theorem twEndpoint_zero : twEndpoint (0 : Fin 3 → ℝ) = -1 := by
  unfold twEndpoint
  simp only [Pi.zero_apply, zero_div, UtwPlus_zero, UtwMinus_zero]
  exact reflection_product_eq_neg_one

/-- Scoped no-go: symmetric antiperiodic twisting relocates the HNU origin
from quasienergy zero to quasienergy pi. -/
```

### 4. `PhysicsSM/Draft/NullEdge/HNUGlobalHolonomyClassification.lean` [hnu_holonomy_trace]

Score: `0.804`

```text
theorem hnu_holonomy_trace : hnuRefls.prod.trace = -2 := by
  rw [hnu_holonomy]; simp

/-- The HNU holonomy has determinant `+1`: it lies in `SU(2)`.  The determinant is
frame-independent and does **not** detect the sector. -/
```

## Scoped paper hits

### 1. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.760`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.

### 2. Dirac quantum walk on tetrahedra

Score: `0.741`
Zotero key: `8RZQA73D`
arXiv: `2404.09840`
DOI: `10.1103/physreva.110.042418`
URL: http://arxiv.org/abs/2404.09840

### 3. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.740`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039
