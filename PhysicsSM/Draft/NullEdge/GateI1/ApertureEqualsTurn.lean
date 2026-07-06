import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core
import PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
import PhysicsSM.Draft.NullEdge.GateI1.MassCoinBridge
import PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure

/-!
# Gate I1: the 3+1D APERTURE = TURN bridge (`apertureEqualsTurn_onShell`)

The single highest-leverage identity for the null-edge mass thesis: it puts TWO
of the three obstruction modes - the **turn** (T, chirality mixing) mode and the
**aperture** (A, failure-to-be-one-null-edge) mode - on ONE shared object at
physical dimension 3+1.

This is the 3+1D generalization of the 1+1D no-double-counting bridge
`MassCoinBridge.onshell_wedge_normSq_eq_coin_sq` (which proved
`wedge^2 = coin^2 = mu^2` in 1+1D).  Here we prove, for an on-shell 3+1D
timelike momentum `p` with `minkowskiSq p = m^2` and any canonical two-null
resolution `p = kPlus + kMinus` (future-null constituents):

```
minkowskiSq (kPlus + kMinus) = 2 * minkDot kPlus kMinus = m^2
```

so the APERTURE mass of the two-null pair (mass = failure to be one null edge)
IS the on-shell mass `m^2`; and that SAME scalar `m` is the mass-carrying
coefficient of the chirality-even ("turn") channel of the Dirac mass vertex,
`chiralEven (massVertex m mu) = (m + 1) . 1`, cleanly separated from the
chirality-odd transport channel `chiralOdd (massVertex m mu) = - gamma mu`.

## Claim discipline

Claim label: **kinematic identity** (aperture = turn on one on-shell momentum);
draft-trust.  This binds the T (turn) and A (aperture) obstruction modes on a
shared object.  It does NOT bind the closure mode C, which lives in a different
model with no `Momentum4`.

## Proof status: FULLY PROVED, no `s o r r y` (standard axioms)

* `twoNull_aperture_massSq`, `twoNull_aperture_onShell`,
  `apertureEqualsTurn_onShell` : the CORE deliverable (the 3+1D generalization of
  `onshell_wedge_normSq_eq_coin_sq`), together with the turn identification, as a
  single kernel-checked statement (they take the two-null resolution as
  hypotheses).
* `twoNull_resolution_exists` : NOW PROVED - the canonical two-null split of an
  on-shell timelike momentum (the 3+1D analogue of
  `MassCoinBridge.twoNull_resolution`), via the explicit `sqrt`/direction
  construction (`r = 0` fixed null direction; `r > 0` split
  `((p0+r)/2)(1,n) + ((p0-r)/2)(1,-n)`, future-pointing from `p0 >= r`).
* `apertureEqualsTurn_exists` : the fully-quantified headline (now
  UNCONDITIONAL), obtained by feeding `twoNull_resolution_exists` into
  `apertureEqualsTurn_onShell`.

Prerequisites: `GateI1.Core`, `GateI1.CompositeApertureMass`,
`GateI1.MassCoinBridge`, `GateYM.ChiralMassStructure`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace ApertureEqualsTurn

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
open PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure
open PhysicsSM.Draft.NullEdge.GateYM.EuclideanGamma

/-! ## 1. The core two-null aperture identity (3+1D generalization) -/

/-- **The two-null aperture identity.**  For two NULL 3+1D momenta the
Minkowski square of their sum is exactly twice their Minkowski product - the
composite mass is the pure cross-term (the "aperture" between the two null
edges).  This is the two-body case of
`CompositeApertureMass.minkowskiSq_sum`/`compositeMassSq_*`, isolated for the
aperture=turn bridge; the 3+1D generalization of the 1+1D wedge identity
`MassCoinBridge.wedge_normSq_eq_det_solder`. -/
theorem twoNull_aperture_massSq (kPlus kMinus : Momentum4)
    (hp : IsNull kPlus) (hq : IsNull kMinus) :
    minkowskiSq (kPlus + kMinus) = 2 * minkDot kPlus kMinus := by
  unfold IsNull at hp hq
  rw [CompositeApertureMass.minkowskiSq_add, hp, hq]
  ring

/-- **The on-shell two-null aperture identity.**  For an on-shell timelike
momentum `p` with `minkowskiSq p = m^2`, and ANY two-null resolution
`p = kPlus + kMinus` into future-null constituents,

```
minkowskiSq (kPlus + kMinus) = 2 * minkDot kPlus kMinus = m^2 .
```

This is the exact 3+1D generalization of the 1+1D
`MassCoinBridge.onshell_wedge_normSq_eq_coin_sq`. -/
theorem twoNull_aperture_onShell (p kPlus kMinus : Momentum4) (m : ℝ)
    (hkp : IsFutureNull kPlus) (hkm : IsFutureNull kMinus)
    (hres : p = kPlus + kMinus) (hp : minkowskiSq p = m ^ 2) :
    minkowskiSq (kPlus + kMinus) = 2 * minkDot kPlus kMinus
      ∧ 2 * minkDot kPlus kMinus = m ^ 2 := by
  have h1 := twoNull_aperture_massSq kPlus kMinus hkp.1 hkm.1
  refine ⟨h1, ?_⟩
  rw [← h1, ← hres, hp]

/-! ## 2. THE HEADLINE: aperture = turn on one on-shell momentum -/

/-- **THE APERTURE = TURN BRIDGE (3+1D).**

For an on-shell 3+1D timelike momentum `p` with `minkowskiSq p = m^2` and any
future-null two-null resolution `p = kPlus + kMinus`, the conclusion binds the
two obstruction modes on the SAME on-shell momentum:

1. **APERTURE (A):** `2 * minkDot kPlus kMinus = m^2` - the aperture mass of the
   two-null pair (mass = failure to be a single null edge) is exactly the
   on-shell mass `m^2`.
2. **TURN (T), mass channel:** `chiralEven (massVertex m mu) = (m + 1) . 1` -
   the SAME scalar `m` is the mass-carrying coefficient of the chirality-even
   ("turn") channel of the Dirac mass vertex (the `+1` is the `m`-independent
   Wilson regulator constant).
3. **TURN (T), transport channel:** `chiralOdd (massVertex m mu) = - gamma mu` -
   the chirality-odd transport channel is the pure null-transport generator,
   cleanly separated from the mass.

Thus the aperture mass and the turn mass are one scalar `m` on one object: this
binds the T and A obstruction modes on a shared object at physical dimension.
It does NOT bind the closure mode C (different model, no `Momentum4`). -/
theorem apertureEqualsTurn_onShell (p kPlus kMinus : Momentum4) (m : ℝ)
    (μ : Fin 4)
    (hkp : IsFutureNull kPlus) (hkm : IsFutureNull kMinus)
    (hres : p = kPlus + kMinus) (hp : minkowskiSq p = m ^ 2) :
    -- APERTURE: the two-null aperture mass is the on-shell mass `m^2`
    (2 * minkDot kPlus kMinus = m ^ 2)
    ∧ -- TURN (mass channel): the same `m` is the chirality-even coefficient
      (chiralEven (massVertex (m : ℂ) μ)
        = ((m : ℂ) + 1) • (1 : Matrix (Fin 4) (Fin 4) ℂ))
    ∧ -- TURN (transport channel): pure null transport, separated from mass
      (chiralOdd (massVertex (m : ℂ) μ) = - γ μ) := by
  refine ⟨?_, chiralEven_massVertex (m : ℂ) μ, chiralOdd_massVertex (m : ℂ) μ⟩
  have h1 := twoNull_aperture_massSq kPlus kMinus hkp.1 hkm.1
  rw [← h1, ← hres, hp]

/-! ## 3. Existence of the canonical two-null resolution (PROVED) -/

/-- **The canonical two-null resolution of an on-shell 3+1D momentum**
(3+1D analogue of `MassCoinBridge.twoNull_resolution`).  A future-pointing
momentum `p` on or inside the future light cone (`0 <= p 0`, `0 <= minkowskiSq
p`, i.e. timelike/null future) splits as the sum of two FUTURE-NULL momenta.
Explicitly `kPlus = ((p0 + |p_vec|)/2) (1, n)`,
`kMinus = ((p0 - |p_vec|)/2) (1, -n)` with `n = p_vec / |p_vec|` (and any fixed
fallback direction when `p_vec = 0`).

PROVED via the explicit `sqrt`/direction construction; this makes the
fully-quantified `apertureEqualsTurn_exists` UNCONDITIONAL. -/
theorem twoNull_resolution_exists (p : Momentum4) (hfut : 0 ≤ p 0)
    (hm : 0 ≤ minkowskiSq p) :
    ∃ kPlus kMinus : Momentum4, IsFutureNull kPlus ∧ IsFutureNull kMinus
      ∧ p = kPlus + kMinus := by
  set r := Real.sqrt (spatialNormSq p) with hr_def
  have hr_nonneg : 0 ≤ r := Real.sqrt_nonneg _
  have hspat_nonneg : 0 ≤ spatialNormSq p := spatialNormSq_nonneg p
  have hr_sq : r ^ 2 = spatialNormSq p := Real.sq_sqrt hspat_nonneg
  have hr2 : r ^ 2 = (p 1) ^ 2 + (p 2) ^ 2 + (p 3) ^ 2 := by
    rw [hr_sq]; unfold spatialNormSq; ring
  by_cases hr : r = 0
  · -- purely temporal: spatial components vanish
    have hspat0 : (p 1) ^ 2 + (p 2) ^ 2 + (p 3) ^ 2 = 0 := by
      rw [← hr2, hr]; ring
    have hp1 : p 1 = 0 := by nlinarith [sq_nonneg (p 1), sq_nonneg (p 2), sq_nonneg (p 3)]
    have hp2 : p 2 = 0 := by nlinarith [sq_nonneg (p 1), sq_nonneg (p 2), sq_nonneg (p 3)]
    have hp3 : p 3 = 0 := by nlinarith [sq_nonneg (p 1), sq_nonneg (p 2), sq_nonneg (p 3)]
    refine ⟨![p 0 / 2, p 0 / 2, 0, 0], ![p 0 / 2, -(p 0 / 2), 0, 0], ?_, ?_, ?_⟩
    · refine ⟨?_, ?_⟩
      · unfold IsNull minkowskiSq; simp
      · simp; linarith
    · refine ⟨?_, ?_⟩
      · unfold IsNull minkowskiSq; simp
      · simp; linarith
    · funext i
      fin_cases i <;> simp [Pi.add_apply, hp1, hp2, hp3]
  · -- r > 0
    have hr_pos : 0 < r := lt_of_le_of_ne hr_nonneg (Ne.symm hr)
    have hp0_ge_r : r ≤ p 0 := by
      have hle : spatialNormSq p ≤ (p 0) ^ 2 := by
        unfold minkowskiSq at hm
        unfold spatialNormSq
        nlinarith [hm]
      calc r = Real.sqrt (spatialNormSq p) := hr_def
        _ ≤ Real.sqrt ((p 0) ^ 2) := Real.sqrt_le_sqrt hle
        _ = p 0 := Real.sqrt_sq hfut
    refine ⟨![(p 0 + r) / 2, (p 0 + r) / 2 * (p 1 / r), (p 0 + r) / 2 * (p 2 / r),
              (p 0 + r) / 2 * (p 3 / r)],
            ![(p 0 - r) / 2, -((p 0 - r) / 2 * (p 1 / r)), -((p 0 - r) / 2 * (p 2 / r)),
              -((p 0 - r) / 2 * (p 3 / r))], ?_, ?_, ?_⟩
    · refine ⟨?_, ?_⟩
      · unfold IsNull minkowskiSq; simp only [Matrix.cons_val_zero, Matrix.cons_val_one,
          Matrix.head_cons, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.tail_cons]
        field_simp
        nlinarith [hr2]
      · simp only [Matrix.cons_val_zero]; positivity
    · refine ⟨?_, ?_⟩
      · unfold IsNull minkowskiSq; simp only [Matrix.cons_val_zero, Matrix.cons_val_one,
          Matrix.head_cons, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.tail_cons]
        field_simp
        nlinarith [hr2]
      · simp only [Matrix.cons_val_zero]; linarith
    · have hrne : r ≠ 0 := hr
      funext i
      fin_cases i <;> simp [Pi.add_apply] <;> field_simp <;> ring

/-- **The fully-quantified aperture = turn headline.**  Every on-shell timelike
momentum `p` (`0 <= p 0`, `minkowskiSq p = m^2`, `m >= 0`) admits a future-null
two-null resolution on which the aperture mass equals `m^2` and coincides with
the chirality-even ("turn") mass coefficient of the Dirac mass vertex.

Transitively depends on the single existence `s o r r y` in
`twoNull_resolution_exists`; the aperture=turn identity content itself
(`apertureEqualsTurn_onShell`) is fully proved. -/
theorem apertureEqualsTurn_exists (p : Momentum4) (m : ℝ) (μ : Fin 4)
    (hfut : 0 ≤ p 0) (hmnn : 0 ≤ m) (hp : minkowskiSq p = m ^ 2) :
    ∃ kPlus kMinus : Momentum4, IsFutureNull kPlus ∧ IsFutureNull kMinus
      ∧ p = kPlus + kMinus
      ∧ (2 * minkDot kPlus kMinus = m ^ 2)
      ∧ (chiralEven (massVertex (m : ℂ) μ)
          = ((m : ℂ) + 1) • (1 : Matrix (Fin 4) (Fin 4) ℂ))
      ∧ (chiralOdd (massVertex (m : ℂ) μ) = - γ μ) := by
  have hmnn' : 0 ≤ minkowskiSq p := by rw [hp]; positivity
  obtain ⟨kPlus, kMinus, hkp, hkm, hres⟩ := twoNull_resolution_exists p hfut hmnn'
  obtain ⟨hA, hTe, hTo⟩ :=
    apertureEqualsTurn_onShell p kPlus kMinus m μ hkp hkm hres hp
  exact ⟨kPlus, kMinus, hkp, hkm, hres, hA, hTe, hTo⟩

end ApertureEqualsTurn
end PhysicsSM.Draft.NullEdge.GateI1
