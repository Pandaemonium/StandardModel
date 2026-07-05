# Aristotle semantic context pack

Generated: 2026-07-04T17:39:55
Query: `Q7 plaquette polymer support counting bound for overlap-or-touch incompatible connected supports using closed touch neighborhood`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/Sedenions/BarnesWallFirstShell.lean` [gl32_orbit_covers_zpSupports]

Score: `0.803`

```text
theorem gl32_orbit_covers_zpSupports : gl32Orbit = zpSupportSet := by native_decide

-- =====================================================
-- § 11. Support statistics
-- =====================================================

/-- The distinct support bitmasks among all signed plaquettes. -/
```

### 2. `PhysicsSM/Draft/Sedenions/BarnesWallFirstShell.lean` [distinctSupportBitmasks]

Score: `0.795`

```text
def distinctSupportBitmasks : Finset Nat :=
  signedPlaquetteBitmasks.toFinset

/-- There are exactly 42 distinct supports among the 168 signed plaquettes. -/
```

### 3. `PhysicsSM/Draft/Sedenions/BarnesWallFirstShell.lean` [distinctSupportBitmasks_card]

Score: `0.795`

```text
theorem distinctSupportBitmasks_card :
    distinctSupportBitmasks.card = 42 := by native_decide

/-- Each support appears exactly 4 times among the 168 signed plaquettes
    (2 sign choices × 2 factor orderings). -/
```

### 4. `PhysicsSM/Draft/Sedenions/S3PsiAction.lean` [psi_image_pair_not_low]

Score: `0.788`

```text
theorem psi_image_pair_not_low :
    ∀ a b : Fin 16, a ∈ imagLowHalf → b ∈ imagLowHalf → a ≠ b →
    ¬ (psiImageSupport {a, b} ⊆ lowHalf) := by
  native_decide +revert

-- ============================================================
-- § 9. Plaquette support spreading
-- ============================================================

/-- A representative zero-product plaquette support.
    The lines {1,2,3} and {4,5,1} give a plaquette {1, 2, 4, 5}. -/
```

### 5. `PhysicsSM/Draft/Sedenions/AnomalyCancellationAnalogue.lean` [supportList]

Score: `0.779`

```text
def supportList (w : Nat) : List Nat :=
  (List.range 16).filter fun i => getBit w i = 1

/-- Linear anomaly of a charge assignment `q` on a plaquette `w`:
    `∑_{i ∈ supp(w)} q(i)`. -/
```

### 6. `PhysicsSM/Draft/Sedenions/BarnesWallFirstShell.lean` [signedPlaquettes_sqNorm]

Score: `0.772`

```text
theorem signedPlaquettes_sqNorm :
    ∀ p ∈ signedPlaquetteListRaw,
      (p.map (fun (_, v) => v * v)).sum = 4 := by native_decide

/-- The representative support bitmask is in the shortened RM(2,4) code. -/
```

### 7. `PhysicsSM/Draft/Sedenions/BarnesWallFirstShell.lean` [signedPlaquettes_pm1]

Score: `0.769`

```text
theorem signedPlaquettes_pm1 :
    ∀ p ∈ signedPlaquetteListRaw, ∀ e ∈ p, e.2 = 1 ∨ e.2 = -1 := by native_decide

-- =====================================================
-- § 9. Shell candidate verification for all plaquettes
-- =====================================================

/-- The list of support bitmasks from all signed plaquettes. -/
```

### 8. `PhysicsSM/Draft/Sedenions/BarnesWallFirstShell.lean` [repSupport_bitmask_in_code]

Score: `0.768`

```text
theorem repSupport_bitmask_in_code :
    toBitmask repSupport ∈ shortRM24Code := by native_decide

/-- The support of the representative plaquette `{1, 4, 10, 15}` is an
    affine 2-plane in F₂⁴ with translation space `{0, 5, 11, 14}`. -/
```

## Scoped paper hits

### 1. Matching number, Hamiltonian graphs and magnetic Laplacian matrices

Score: `0.696`
Zotero key: `GNEARI9Q`
arXiv: `2010.08828`
DOI: `10.1016/j.laa.2022.02.006`
URL: https://doi.org/10.1016/j.laa.2022.02.006

### 2. Connecting the discrete- and continuous-time quantum walks

Score: `0.694`
Zotero key: `XK9ZRDNJ`
DOI: `10.1103/physreva.74.030301`
URL: https://doi.org/10.1103/physreva.74.030301
